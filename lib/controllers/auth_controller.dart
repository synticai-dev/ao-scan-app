import 'package:ao_scan_app/utils/analytics_service.dart';
import 'package:ao_scan_app/models/user_model.dart';
import 'package:ao_scan_app/utils/notification_service.dart';
import 'package:ao_scan_app/views/screens/home_screen.dart';
import 'package:ao_scan_app/views/screens/auth/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

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
      await AnalyticsService.setUserId(user.uid);
    } else {
      userModel.value = null;
      await AnalyticsService.setUserId(null);
    }
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
      Get.snackbar('Error', 'Failed to fetch user data');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dob,
    required String occupation,
    required String country,
    required String phoneNumber,
    required String sex,
  }) async {
    try {
      isLoading.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());
      userModel.value = newUser;
      
      // Log sign up
      await AnalyticsService.logSignUp('email');
      
      Get.offAll(() => HomeScreen());
      Get.snackbar('Success', 'Account created successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Registration failed');
    } finally {
      isLoading.value = false;
    }
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
      Get.snackbar('Error', e.message ?? 'Login failed');
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
      Get.snackbar('Error', e.message ?? 'Password reset failed');
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
          print('FCM Token updated: $token');
        }
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }
}
