import 'dart:async';
import 'package:ao_scan_app/utils/analytics_service.dart';
import 'package:ao_scan_app/models/user_model.dart';
import 'package:ao_scan_app/utils/notification_service.dart';
import 'package:ao_scan_app/views/screens/home_screen.dart';
import 'package:ao_scan_app/views/screens/auth/login_screen.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  /// Tracks whether the current user has already submitted a free demo request.
  RxBool hasSubmittedDemo = false.obs;
  StreamSubscription<QuerySnapshot>? _demoSubscription;

  // ─── Phone OTP verification state (registration) ─────────────────────────
  RxBool isSendingOtp = false.obs;
  RxBool isVerifyingOtp = false.obs;
  RxInt otpResendSecondsLeft = 0.obs;
  Timer? _otpResendTimer;

  String? _verificationId;
  PhoneAuthCredential? _autoVerifiedCredential;
  String? pendingE164Phone;

  /// True when the OS auto-verified the phone (Android SMS Retriever /
  /// iOS silent push). The OTP screen can then skip manual code entry.
  bool get hasAutoVerifiedCredential => _autoVerifiedCredential != null;

  // Pending registration data captured before the OTP is entered
  String? _pendingEmail;
  String? _pendingPassword;
  String? _pendingFirstName;
  String? _pendingLastName;
  String? _pendingDob;
  String? _pendingOccupation;
  String? _pendingCountry;
  String? _pendingPhoneNumber;
  String? _pendingSex;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user != null) {
      await _fetchUserModel(user.uid);
      await updateFcmToken();
      await updateLastActivePlatform(user.uid);
      await AnalyticsService.setUserId(user.uid);
      _listenToDemoRequests(user.uid);
    } else {
      userModel.value = null;
      hasSubmittedDemo.value = false;
      _demoSubscription?.cancel();
      _demoSubscription = null;
      await AnalyticsService.setUserId(null);
    }
  }

  Future<void> updateLastActivePlatform(String uid) async {
    try {
      String platformStr = Platform.isIOS ? 'Apple' : (Platform.isAndroid ? 'Google' : 'Other');
      await _firestore.collection('users').doc(uid).update({
        'lastActivePlatforms.$platformStr': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating active platform: $e');
      }
    }
  }

  /// Listens to demo_requests for the current user and updates [hasSubmittedDemo].
  void _listenToDemoRequests(String uid) {
    _demoSubscription?.cancel();
    _demoSubscription = _firestore
        .collection('demo_requests')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      hasSubmittedDemo.value = snapshot.docs.isNotEmpty;
    });
  }

  Future<void> _fetchUserModel(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Failed to fetch user model: $e');
      Get.snackbar(
        'Error',
        'Could not load your profile. Please check your internet and try again.',
      );
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dob,
    required String occupation,
    required String country,
    required String phoneNumber,
    required String sex,
    PhoneAuthCredential? phoneCredential,
  }) async {
    bool verifiedPhone = false;
    bool resumed = false;
    String failureMessage = 'Registration failed. Please try again.';
    late UserCredential credential;
    try {
      isLoading.value = true;

      // 1. Firebase Auth Registration.
      //    If the email already exists, this may be an interrupted previous
      //    attempt (app closed / connection lost after the auth account was
      //    created but before the profile was saved). In that case we resume
      //    the incomplete registration instead of blocking the user.
      try {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code != 'email-already-in-use') rethrow;
        try {
          final existing = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final doc = await _firestore
              .collection('users')
              .doc(existing.user!.uid)
              .get();

          if (doc.exists) {
            // The profile was already saved before → the account is complete.
            Get.snackbar(
              'Account Exists',
              'An account with this email already exists. Please login instead.',
            );
            return false;
          }

          // Incomplete (interrupted) registration → resume it.
          credential = existing;
          resumed = true;
          if ((existing.user!.phoneNumber ?? '').isNotEmpty) {
            verifiedPhone = true; // phone was already linked & verified
          }
        } on FirebaseAuthException {
          // Wrong password for the existing account (or sign-in blocked).
          Get.snackbar(
            'Email Already Registered',
            'An account with this email already exists. Please login or use a different email.',
          );
          return false;
        }
      }

      // 2. Link the verified phone number (validates the OTP code).
      //    The credential is created from the 6-digit SMS code the user
      //    entered, so a successful link proves the phone is reachable.
      if (phoneCredential != null && !verifiedPhone) {
        try {
          await credential.user!.linkWithCredential(phoneCredential);
          verifiedPhone = true;
        } on FirebaseAuthException {
          // Rollback: delete the temporary account on OTP failure — but only
          // when WE created it in this attempt. A resumed (interrupted)
          // account is kept so the user can simply retry the code.
          if (!resumed) {
            try {
              await credential.user?.delete();
            } catch (_) {}
          }
          rethrow;
        }
      }

      // 3. Compulsory External API Registration
      final http.Response apiResponse;
      try {
        apiResponse = await http
            .post(
              Uri.parse('https://admin.aoscanglobal.com/api/register'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: jsonEncode({
                "firstName": firstName,
                "lastName": lastName,
                "country": country,
                "email": email,
                "phoneNumber": phoneNumber,
              }),
            )
            .timeout(const Duration(seconds: 30));
      } on TimeoutException {
        debugPrint('Register API: timed out after 30s');
        failureMessage =
            'The server took too long to respond. Please check your internet '
            'connection and try again.';
        if (!resumed) await credential.user?.delete();
        throw Exception(failureMessage);
      } catch (e) {
        debugPrint('Register API: network error → $e');
        failureMessage =
            'Could not reach the registration server. Please check your '
            'internet connection and try again.';
        if (!resumed) await credential.user?.delete();
        throw Exception(failureMessage);
      }

      debugPrint('Register API → status: ${apiResponse.statusCode}, '
          'body: ${apiResponse.body}');

      if (apiResponse.statusCode != 200 && apiResponse.statusCode != 201) {
        final bool duplicateOnPortal = _isDuplicatePortalEmail(apiResponse.body);
        if (duplicateOnPortal && resumed) {
          // The interrupted attempt already reached the portal — treat the
          // portal step as done and continue saving the profile.
          debugPrint(
              'Register API: email already on portal (resumed) → continuing');
        } else {
          failureMessage = duplicateOnPortal
              ? 'This email is already registered on our portal. Please use a '
                  'different email or contact support.'
              : _apiFailureMessage(apiResponse);
          // ROLLBACK: Delete the Firebase user because the API failed — but
          // only when WE created it in this attempt (never a resumed account,
          // so the user does not lose their verified phone on a transient
          // API error).
          if (!resumed) {
            await credential.user?.delete();
          }
          throw Exception(failureMessage);
        }
      }

      String platformStr = Platform.isIOS ? 'Apple' : (Platform.isAndroid ? 'Google' : 'Other');

      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        occupation: occupation,
        country: country,
        phoneNumber: phoneNumber,
        sex: sex,
        originPlatform: platformStr,
        lastActivePlatforms: {platformStr: FieldValue.serverTimestamp()},
        phoneVerified: verifiedPhone,
        createdAt: DateTime.now(),
      );

      try {
        await _firestore
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());
      } on FirebaseException catch (e) {
        debugPrint('Firestore profile write failed: $e');
        // Keep the account (it is resumable) — the profile is simply written
        // on the next attempt. Never delete here: the portal already has the
        // user, so the duplicate is tolerated on the resumed retry.
        failureMessage =
            'Could not save your profile. Please check your internet and try again.';
        rethrow;
      }
      userModel.value = newUser;
      
      // Log sign up
      await AnalyticsService.logSignUp('email');
      
      Get.offAll(() => HomeScreen());
      Get.snackbar('Success', 'Account created successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        Get.snackbar(
          'Verification Failed',
          'Invalid or expired verification code. Please check and try again.',
        );
      } else if (e.code == 'credential-already-in-use' ||
          e.code == 'provider-already-linked') {
        Get.snackbar(
          'Phone Already Registered',
          'This phone number is already registered to another account. Please use a different number.',
        );
      } else if (e.code == 'weak-password') {
        Get.snackbar(
          'Weak Password',
          'Your password is too weak. Please use at least 6 characters.',
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Account Exists',
          'An account with this email already exists. Please login instead.',
        );
      } else if (e.code == 'network-request-failed') {
        Get.snackbar(
          'No Internet',
          'Please check your connection and try again.',
        );
      } else {
        Get.snackbar(
          'Registration Failed',
          e.message ?? 'Registration failed. Please try again.',
        );
      }
      return false;
    } catch (e) {
      debugPrint('Registration failed: $e');
      Get.snackbar('Registration Failed', failureMessage);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Starts the phone verification flow for a new registration.
  /// Stores the pending registration data, sends the OTP SMS and, on success,
  /// the UI navigates to the OTP screen.
  Future<bool> startPhoneVerification({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dob,
    required String occupation,
    required String country,
    required String phoneNumber,
    required String sex,
    required String e164Phone,
  }) async {
    // Store the registration data while the user verifies their phone
    _pendingEmail = email;
    _pendingPassword = password;
    _pendingFirstName = firstName;
    _pendingLastName = lastName;
    _pendingDob = dob;
    _pendingOccupation = occupation;
    _pendingCountry = country;
    _pendingPhoneNumber = phoneNumber;
    _pendingSex = sex;

    // Pre-check: if this email already belongs to an account, tell the user
    // up front — BEFORE spending an SMS on a code they can never use.
    // (A matching password without a saved profile is an interrupted
    // registration; register() resumes that case after verification.)
    final canContinue = await _preCheckEmailForRegistration(email);
    if (!canContinue) return false;

    return _sendOtp(e164Phone);
  }

  /// Returns `true` when registration with [email] may proceed (brand-new
  /// email, or an interrupted registration whose password matches). Returns
  /// `false` (with a friendly snackbar) when the email belongs to an existing
  /// account, so the user is told to login instead of receiving an SMS code.
  Future<bool> _preCheckEmailForRegistration(String email) async {
    try {
      final existing = await _auth.signInWithEmailAndPassword(
        email: email,
        password: _pendingPassword ?? '',
      );

      // Email + password match an existing account. Tell completed accounts
      // apart from interrupted (incomplete) registrations via their profile.
      final doc = await _firestore
          .collection('users')
          .doc(existing.user!.uid)
          .get();
      await _auth.signOut(); // restore state; register() re-authenticates
      if (doc.exists) {
        Get.snackbar(
          'Account Exists',
          'An account with this email already exists. Please login instead.',
        );
        return false;
      }
      return true; // incomplete registration → proceed (will be resumed)
    } on FirebaseAuthException catch (e) {
      try {
        await _auth.signOut(); // keep state clean if a session was created
      } catch (_) {}
      switch (e.code) {
        case 'user-not-found':
          return true; // brand-new email → proceed
        case 'wrong-password':
          Get.snackbar(
            'Email Already Registered',
            'This email belongs to an existing account but the password does '
            'not match. Please login or correct your password.',
          );
          return false;
        case 'invalid-email':
          Get.snackbar(
            'Invalid Email',
            'Please enter a valid email address.',
          );
          return false;
        case 'network-request-failed':
          Get.snackbar(
            'No Internet',
            'Please check your connection and try again.',
          );
          return false;
        case 'too-many-requests':
          Get.snackbar(
            'Too Many Attempts',
            'Please wait a few minutes and try again.',
          );
          return false;
        default:
          // Ambiguous failures (e.g. invalid-credential when email enumeration
          // protection is enabled) — never risk blocking a brand-new user;
          // register() resolves any real conflict after phone verification.
          return true;
      }
    } catch (_) {
      // Unexpected/non-auth errors should never block registration.
      return true;
    }
  }

  /// Sends (or resends) the SMS verification code via Firebase Phone Auth.
  /// Resolves with `true` only once the code was actually sent (or auto-
  /// verified), and `false` when Firebase rejects the phone number — so the
  /// UI only navigates to the OTP screen when verification can proceed.
  Future<bool> _sendOtp(String e164Phone) async {
    final completer = Completer<bool>();
    try {
      isSendingOtp.value = true;
      pendingE164Phone = e164Phone;
      _autoVerifiedCredential = null;
      _verificationId = null;

      await _auth.verifyPhoneNumber(
        phoneNumber: e164Phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieved on Android (SMS Retriever) / iOS silent push
          _autoVerifiedCredential = credential;
          _verificationId = null;
          isSendingOtp.value = false;
          if (!completer.isCompleted) completer.complete(true);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('verifyPhoneNumber failed: [${e.code}] ${e.message}');
          isSendingOtp.value = false;
          Get.snackbar('Error', _friendlyPhoneError(e));
          _autoVerifiedCredential = null;
          if (!completer.isCompleted) completer.complete(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          isSendingOtp.value = false;
          _startResendTimer();
          if (!completer.isCompleted) completer.complete(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _autoVerifiedCredential = null;
        },
      );

      // Safety net: never block the UI for more than ~70s even if no callback
      // arrives (this also covers slow carrier delivery edge cases).
      return await completer.future
          .timeout(const Duration(seconds: 70), onTimeout: () => false);
    } on Exception catch (e) {
      debugPrint('Phone verification error: $e');
      isSendingOtp.value = false;
      // Catch native platform errors (e.g. missing APNs / GoogleService config)
      // so the app doesn't hard-crash. The most common cause on iOS is a
      // missing CLIENT_ID in GoogleService-Info.plist or APNs not configured.
      final message = e.toString().toLowerCase();
      if (message.contains('nil') ||
          message.contains('apns') ||
          message.contains('client') ||
          message.contains('platform')) {
        Get.snackbar(
          'Configuration Error',
          'Phone verification is not available. Please ensure notifications '
          'are enabled and try again on a physical device.',
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send verification code. Please try again.',
        );
      }
      if (!completer.isCompleted) completer.complete(false);
      return false;
    }
  }

  /// Resends the OTP code to the same phone number.
  Future<void> resendOtp() async {
    final phone = pendingE164Phone;
    if (phone == null) return;
    isSendingOtp.value = true;
    await _sendOtp(phone);
  }

  /// Validates the 6-digit code and completes the registration (create
  /// account → link verified phone → external API → Firestore → Home).
  Future<bool> verifyOtpAndRegister(String otpCode) async {
    try {
      isVerifyingOtp.value = true;

      if (_verificationId == null && _autoVerifiedCredential == null) {
        Get.snackbar(
          'Session Expired',
          'The verification session expired. Please go back and request a new code.',
        );
        return false;
      }

      final credential = _autoVerifiedCredential ??
          PhoneAuthProvider.credential(
            verificationId: _verificationId!,
            smsCode: otpCode.trim(),
          );

      final success = await register(
        email: _pendingEmail ?? '',
        password: _pendingPassword ?? '',
        firstName: _pendingFirstName ?? '',
        lastName: _pendingLastName ?? '',
        dob: _pendingDob ?? '',
        occupation: _pendingOccupation ?? '',
        country: _pendingCountry ?? '',
        phoneNumber: _pendingPhoneNumber ?? '',
        sex: _pendingSex ?? '',
        phoneCredential: credential,
      );

      if (success) {
        _clearOtpState();
      }
      return success;
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  void _startResendTimer() {
    _otpResendTimer?.cancel();
    otpResendSecondsLeft.value = 30;
    _otpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpResendSecondsLeft.value <= 1) {
        timer.cancel();
        otpResendSecondsLeft.value = 0;
      } else {
        otpResendSecondsLeft.value--;
      }
    });
  }

  void _clearOtpState() {
    _otpResendTimer?.cancel();
    otpResendSecondsLeft.value = 0;
    _verificationId = null;
    _autoVerifiedCredential = null;
    pendingE164Phone = null;
    _pendingEmail = null;
    _pendingPassword = null;
    _pendingFirstName = null;
    _pendingLastName = null;
    _pendingDob = null;
    _pendingOccupation = null;
    _pendingCountry = null;
    _pendingPhoneNumber = null;
    _pendingSex = null;
  }

  String _friendlyPhoneError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number you entered is invalid. Please check and try again.';
      case 'too-many-requests':
        return 'Too many verification attempts. Please wait a few minutes and try again.';
      case 'quota-exceeded':
        return 'Verification service is temporarily unavailable. Please try again later.';
      case 'invalid-app-credential':
      case 'missing-client-identifier':
      case 'captcha-check-failed':
        return 'Device verification failed. Please ensure notifications are enabled or try on a physical device.';
      default:
        return e.message ?? 'Phone verification failed. Please try again.';
    }
  }

  /// Maps common FirebaseAuthException codes to clear, human messages used by
  /// login and password reset. [fallback] is used for unmapped codes.
  String _friendlyAuthMessage(
    FirebaseAuthException e, {
    required String fallback,
  }) {
    final String code = e.code;
    if (code == 'user-not-found') {
      return 'No account found with this email. Please sign up first.';
    } else if (code == 'wrong-password' ||
        code == 'invalid-credential' ||
        code == 'invalid-login-credentials') {
      return 'Incorrect email or password. Please try again.';
    } else if (code == 'invalid-email') {
      return 'Please enter a valid email address.';
    } else if (code == 'user-disabled') {
      return 'This account has been disabled. Please contact support.';
    } else if (code == 'too-many-requests') {
      return 'Too many attempts. Please wait a few minutes and try again.';
    } else if (code == 'network-request-failed') {
      return 'No internet connection. Please check your connection and try again.';
    }
    return e.message ?? fallback;
  }

  /// Detects the backend's duplicate-email failure (Mailchimp "Member Exists")
  /// so the UI can show a clear message instead of a generic one.
  bool _isDuplicatePortalEmail(String responseBody) {
    final String body = responseBody.toLowerCase();
    return body.contains('already a list member') ||
        body.contains('member exists') ||
        body.contains('already registered') ||
        body.contains('already exists') ||
        body.contains('duplicate');
  }

  /// Builds a friendly message from an unexpected register-API error response.
  String _apiFailureMessage(http.Response response) {
    final String lower = response.body.toLowerCase();
    // Internal backend jargon (Mailchimp delivery etc.) stays out of the UI.
    if (lower.contains('mailchimp') || lower.contains('subscribe user')) {
      return 'Registration service is temporarily unavailable. '
          'Please try again later.';
    }
    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map) {
        final dynamic message = decoded['message'] ?? decoded['detail'];
        if (message is String && message.trim().isNotEmpty) return message;
        if (decoded['error'] is Map) {
          final dynamic detail = decoded['error']['detail'];
          if (detail is String && detail.trim().isNotEmpty) return detail;
        }
      }
    } catch (_) {}
    return 'Registration service is temporarily unavailable '
        '(error ${response.statusCode}). Please try again later.';
  }

  @override
  void onClose() {
    _otpResendTimer?.cancel();
    super.onClose();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _fetchUserModel(credential.user!.uid);
      
      // Log login
      await AnalyticsService.logLogin('email');
      
      Get.offAll(() => HomeScreen());
      Get.snackbar('Success', 'Logged in successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        _friendlyAuthMessage(e, fallback: 'Login failed. Please try again.'),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.back(); // Go back to Login screen
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Password Reset Failed',
        _friendlyAuthMessage(
          e,
          fallback: 'Could not send the password reset email. Please try again.',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => LoginScreen());
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      String? uid = firebaseUser.value?.uid;
      if (uid != null) {
        // Delete user data from collection
        await _firestore.collection('users').doc(uid).delete();

        // Optionally delete other related data like demo requests
        var requests = await _firestore
            .collection('demo_requests')
            .where('userId', isEqualTo: uid)
            .get();
        for (var doc in requests.docs) {
          await doc.reference.delete();
        }

        // Delete the user from Firebase Auth
        await _auth.currentUser?.delete();
        Get.offAll(() => HomeScreen());
        Get.snackbar('Deleted', 'Your account has been deleted successfully');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Get.snackbar(
          'Re-authentication Required',
          'Please logout and login again to delete your account for security reasons.',
        );
      } else {
        Get.snackbar('Error', e.message ?? 'Failed to delete account');
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<void> updateFcmToken() async {
    try {
      String? uid = firebaseUser.value?.uid;
      if (uid != null) {
        String? token = await Get.find<NotificationService>().getToken();
        if (token != null) {
          await _firestore.collection('users').doc(uid).set({
            'fcmToken': token,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          if (kDebugMode) {
            print('FCM Token updated: $token');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FCM token: $e');
      }
    }
  }
}
