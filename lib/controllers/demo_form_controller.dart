import 'package:ao_scan_app/utils/analytics_service.dart';
import 'dart:io';
import 'package:ao_scan_app/views/screens/step5_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ao_scan_app/controllers/auth_controller.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class DemoFormController extends GetxController {
  final authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Listen for user model changes to prefill data
    ever(authController.userModel, (_) => _prefillUserData());
    _prefillUserData();
  }

  void _prefillUserData() {
    final user = authController.userModel.value;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      emailController.text = user.email;
      dobController.text = user.dob ?? '';
      occupationController.text = user.occupation ?? '';
      countryController.text = user.country ?? '';
      sexController.text = user.sex ?? '';

      // Handle phone number splitting
      if (user.phoneNumber != null) {
        if (user.phoneNumber!.contains(' ')) {
          final parts = user.phoneNumber!.split(' ');
          if (parts.length >= 2) {
            phoneCountryCode.value = parts[0];
            phoneController.text = parts.sublist(1).join(' ');
          } else {
            phoneController.text = user.phoneNumber!;
          }
        } else {
          phoneController.text = user.phoneNumber ?? '';
        }
      }
    } else if (authController.firebaseUser.value?.email != null) {
      emailController.text = authController.firebaseUser.value!.email!;
    }
  }

  // Step 1: Contact Information
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  RxBool consent6 = false.obs;

  RxList<String> dropdownList = <String>[].obs;
  RxString selectedValue = ''.obs;

  void setDropdownData(List<String> newList) {
    // Remove duplicates
    final uniqueList = newList.toSet().toList();

    dropdownList.assignAll(uniqueList);

    // Validate selected value
    if (!uniqueList.contains(selectedValue.value)) {
      selectedValue.value = '';
    }
  }

  final countryController = TextEditingController();
  final phoneCountryCode = '+1'.obs; // Default to US
  final phoneController = TextEditingController();
  final sexController = TextEditingController();
  final weightController = TextEditingController();
  final weightUnit = 'lb'.obs; // Default to lb
  final heightController = TextEditingController();
  final heightUnit = 'in'.obs; // Default to in
  final dobController = TextEditingController();

  // Step 2: Free Demo
  final occupationController = TextEditingController();
  final otherOccupationController = TextEditingController();
  final useTypeController = TextEditingController();

  // Step 3: Photo + Voice
  final selectedPhoto = Rx<XFile?>(null);
  final audioFilePath = RxString('');
  final isRecording = false.obs;
  final AudioRecorder audioRecorder = AudioRecorder();
  final recordingDuration = 0.obs;

  // Step 4: Tell Us More & Consent
  final messageController = TextEditingController();
  final consent1 = false.obs;
  final consent2 = false.obs;
  final consent3 = false.obs;
  final consent4 = false.obs;
  final consent5 = false.obs;

  // Current step
  final currentStep = 1.obs;
  final totalSteps = 4;

  // Loading state
  final isSubmitting = false.obs;

  // Validation
  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Country is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  String? validateSex(String? value) {
    if (value == null || value.isEmpty) {
      return 'Sex is required';
    }
    if (value != 'Male' && value != 'Female') {
      return 'Please select Male or Female';
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a whole number';
    }
    return null;
  }

  String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a whole number';
    }
    return null;
  }

  String? validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }
    try {
      final parts = value.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final birthDate = DateTime(year, month, day);
        final today = DateTime.now();
        int age = today.year - birthDate.year;
        if (today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }
        if (age < 18) {
          return 'You must be at least 18 years old';
        }
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  String? validateOccupation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Occupation is required';
    }
    return null;
  }

  String? validateUseType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Use type is required';
    }
    return null;
  }

  bool validateStep1() {
    return validateFirstName(firstNameController.text) == null &&
        validateLastName(lastNameController.text) == null &&
        validateEmail(emailController.text) == null &&
        validateCountry(countryController.text) == null &&
        validatePhone(phoneController.text) == null &&
        validateSex(sexController.text) == null &&
        validateWeight(weightController.text) == null &&
        validateHeight(heightController.text) == null &&
        validateDOB(dobController.text) == null;
  }

  bool validateStep2() {
    return validateOccupation(occupationController.text) == null &&
        validateUseType(useTypeController.text) == null;
  }

  bool validateStep3() {
    return selectedPhoto.value != null && audioFilePath.value.isNotEmpty;
  }

  bool validateStep4() {
    return consent1.value &&
        consent2.value &&
        consent3.value &&
        consent4.value &&
        consent5.value;
  }

  void nextStep() {
    if (currentStep.value < totalSteps) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        selectedPhoto.value = image;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> startRecording() async {
    if (isRecording.value) return;

    try {
      final hasPermission = await audioRecorder.hasPermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Required',
          'Microphone permission is required',
        );
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc, // iOS compatible
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      isRecording.value = true;
      recordingDuration.value = 0;

      _startTimer(); // separate timer
    } catch (e) {
      isRecording.value = false;
      Get.snackbar('Error', 'Recording failed: $e');
    }
  }

  void _startTimer() async {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(seconds: 1));

      if (!isRecording.value) return;

      recordingDuration.value = i;

      if (i == 10) {
        await stopRecording();
      }
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      final path = await audioRecorder.stop();

      isRecording.value = false;
      recordingDuration.value = 0;

      if (path != null) {
        audioFilePath.value = path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Stop recording failed: $e');
    }
  }

  final isPickingAudio = false.obs;

  Future<void> pickAudioFile() async {
    if (isPickingAudio.value) return;

    try {
      isPickingAudio.value = true;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['m4a', 'mp3', 'wav', 'aac'],
      );

      if (result != null && result.files.single.path != null) {
        audioFilePath.value = result.files.single.path!;
      }
    } finally {
      isPickingAudio.value = false;
    }
  }

  Future<void> submitForm() async {
    if (!validateStep4()) {
      Get.snackbar('Validation Error', 'Please accept all consent checkboxes');
      return;
    }

    if (isSubmitting.value) return; // Prevent multiple submissions

    isSubmitting.value = true;

    if (authController.firebaseUser.value == null) {
      isSubmitting.value = false;
      Get.snackbar(
        'Authentication Required',
        'Please login or register to submit a demo request.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }


    try {
      final email = emailController.text.trim().toLowerCase();
      final phoneNumber =
          '${phoneCountryCode.value}${phoneController.text.trim()}';

      // Check for duplicate email or phone number
      final duplicateCheck = await FirebaseFirestore.instance
          .collection('demo_requests')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (duplicateCheck.docs.isNotEmpty) {
        isSubmitting.value = false;
        Get.snackbar(
          'Error',
          '',
          messageText: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: [
                const TextSpan(
                  text:
                      'It looks like you have already used your free AO Scan demo. Please contact AO Scan Global or visit our website for more information: ',
                ),
                TextSpan(
                  text: 'www.aoscanglobal.com/contact',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(
                        'https://www.aoscanglobal.com/contact',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                ),
              ],
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      final phoneCheck = await FirebaseFirestore.instance
          .collection('demo_requests')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (phoneCheck.docs.isNotEmpty) {
        isSubmitting.value = false;
        Get.snackbar(
          'Error',
          '',
          messageText: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: [
                const TextSpan(
                  text:
                      'It looks like you have already used your free AO Scan demo. Please contact AO Scan Global or visit our website for more information: ',
                ),
                TextSpan(
                  text: 'www.aoscanglobal.com/contact',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(
                        'https://www.aoscanglobal.com/contact',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                ),
              ],
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      // Upload photo to Firebase Storage
      String? photoUrl;
      if (selectedPhoto.value != null) {
        try {
          final photoFile = File(selectedPhoto.value!.path);
          final photoFileName =
              'photos/${DateTime.now().millisecondsSinceEpoch}_${selectedPhoto.value!.name}';
          final photoRef = FirebaseStorage.instance.ref().child(photoFileName);
          await photoRef.putFile(photoFile);
          photoUrl = await photoRef.getDownloadURL();
        } catch (e) {
          isSubmitting.value = false;
          Get.snackbar(
            'Error',
            'Failed to upload photo: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Upload audio to Firebase Storage
      String? audioUrl;
      if (audioFilePath.value.isNotEmpty) {
        try {
          final audioFile = File(audioFilePath.value);
          final audioFileName =
              'audio/${DateTime.now().millisecondsSinceEpoch}_voice_sample.m4a';
          final audioRef = FirebaseStorage.instance.ref().child(audioFileName);
          await audioRef.putFile(audioFile);
          audioUrl = await audioRef.getDownloadURL();
        } catch (e) {
          isSubmitting.value = false;
          Get.snackbar(
            'Error',
            'Failed to upload audio: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Prepare form data
      final formData = {
        "consent6": consent6.value,
        "userId": authController.firebaseUser.value?.uid ?? '',
        "adminNote": "",
        "status": "Pending",

        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': email,
        'country': countryController.text.trim(),
        'phoneCountryCode': phoneCountryCode.value,
        'phoneNumber': phoneNumber,
        'sex': sexController.text.trim(),
        'weight': weightController.text.trim(),
        'weightUnit': weightUnit.value,
        'height': heightController.text.trim(),
        'heightUnit': heightUnit.value,
        'dateOfBirth': dobController.text.trim(),
        'occupation': occupationController.text.contains("Other")
            ? otherOccupationController.text.trim()
            : occupationController.text.trim(),
        'useType': useTypeController.text.trim(),
        'message': messageController.text.trim(),
        'photoUrl': photoUrl ?? '',
        'audioUrl': audioUrl ?? '',
        'consent1': consent1.value,
        'consent2': consent2.value,
        'consent3': consent3.value,
        'consent4': consent4.value,
        'consent5': consent5.value,
        'submissionDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore and get document reference
      final docRef = await FirebaseFirestore.instance
          .collection('demo_requests')
          .add(formData);


      // Prepare API request body
      final now = DateTime.now();

      // submittedAt format -> 2026-04-10 12:00:00
      final submittedAtFormatted = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(now);

      // Parse DOB from DD/MM/YYYY -> YYYY-MM-DD
      String formattedDateOfBirth = '';

      try {
        final dobText = dobController.text.trim();

        if (dobText.isNotEmpty) {
          final parts = dobText.split('/');

          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);

            final dob = DateTime(year, month, day);
            formattedDateOfBirth = DateFormat('yyyy-MM-dd').format(dob);
          }
        }
      } catch (e) {
        formattedDateOfBirth = '';
      }

      final apiBody = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "country": countryController.text.trim(),
        "email": email,
        "phoneNumber": phoneNumber,
        "sex": sexController.text.trim(),
        "weight": "${weightController.text.trim()} ${weightUnit.value}",
        "height": "${heightController.text.trim()} ${heightUnit.value}",
        "dateOfBirth": formattedDateOfBirth,
        "occupation": occupationController.text.trim(),
        "concent1": consent1.value,
        "concent2": consent2.value,
        "concent3": consent3.value,
        "concent4": consent4.value,
        "concent5": consent5.value,
        "message": messageController.text.trim(),
        "useType": useTypeController.text.trim(),
        "photoUrl": photoUrl ?? "",
        "audioUrl": audioUrl ?? "",
        "status": "NEW",
        "submittedAt": submittedAtFormatted,
      };

      // POST to Mailchimp API
      bool mailchimpSyncSuccess = false;
      try {
        final response = await http.post(
          Uri.parse('https://admin.aoscanglobal.com/api/add_mailchimp'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(apiBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // API call successful
          mailchimpSyncSuccess = true;
          print('API call successful: ${response.body}');
        } else {
          // API call failed but don't block the user
          print(
            'API call failed with status ${response.statusCode}: ${response.body}',
          );
        }
      } catch (e) {
        // API call error but don't block the user
        print('API call error: $e');
      }

      // Update Firestore with Mailchimp sync status if failed
      if (!mailchimpSyncSuccess) {
        try {
          await docRef.update({
            'mailchimpSyncStatus': 'Mailchimp Sync Pending',
          });
        } catch (e) {
          print('Failed to update mailchimpSyncStatus: $e');
        }
      }

      isSubmitting.value = false;

      // Show success message and proceed to confirmation screen
      Get.snackbar(
        'Success',
        'Your form has been submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Log free demo submission
      await AnalyticsService.logFreeDemoSubmission();

      Get.off(() => Step5Confirmation());
    } catch (e) {
      isSubmitting.value = false;
      Get.snackbar(
        'Error',
        'Failed to submit form: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void resetForm() {
    // Clear form-specific fields
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    countryController.clear();
    phoneController.clear();
    sexController.clear();
    weightController.clear();
    weightUnit.value = 'lb';
    heightController.clear();
    heightUnit.value = 'in';
    dobController.clear();
    occupationController.clear();
    otherOccupationController.clear();
    useTypeController.clear();
    messageController.clear();
    selectedPhoto.value = null;
    audioFilePath.value = '';
    isRecording.value = false;
    recordingDuration.value = 0;
    consent1.value = false;
    consent2.value = false;
    consent3.value = false;
    consent4.value = false;
    consent5.value = false;
    currentStep.value = 1;
    // Re-prefill user profile data after clearing
    _prefillUserData();
    isSubmitting.value = false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    countryController.dispose();
    phoneController.dispose();
    sexController.dispose();
    weightController.dispose();
    heightController.dispose();
    dobController.dispose();
    occupationController.dispose();
    useTypeController.dispose();
    messageController.dispose();
    audioRecorder.dispose();
    super.onClose();
  }
}
