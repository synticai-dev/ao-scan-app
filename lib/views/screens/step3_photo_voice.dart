import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/demo_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../widgets/step_header.dart';
import '../widgets/disclaimer_footer.dart';

class Step3PhotoVoice extends StatelessWidget {
  final DemoFormController controller = Get.find<DemoFormController>();

  Step3PhotoVoice({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,

      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
        child: Column(
          children: [
            StepHeader(
              currentStep: controller.currentStep.value,
              totalSteps: controller.totalSteps,
              onBack: () => controller.previousStep(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'Photo + Voice Upload',
                        style: AppTextStyle.bold(
                          fontSize: 24,
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      textAlign: TextAlign.center,
                      'Upload your photo and voice recording for the AO Scan demo.',
                      style: AppTextStyle.regular(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Photo Upload
                    _buildPhotoUpload(context, size),
                    const SizedBox(height: 24),
                    // Voice Sample
                    _buildVoiceSample(context, size),
                    const SizedBox(height: 24),
                    // Or separator
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.borderLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or',
                            style: AppTextStyle.regular(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.borderLight)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Audio File Upload
                    _buildAudioFileUpload(context, size),
                    const SizedBox(height: 24),
                    Text(
                      'Please record a clear 10-second voice sample with no background noises, voices, or music.',
                      style: AppTextStyle.regular(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffA7A7A7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      final hasPhoto = controller.selectedPhoto.value != null;
                      final hasAudio =
                          controller.audioFilePath.value.isNotEmpty;
                      return Column(
                        children: [
                          if (!hasPhoto || !hasAudio)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                !hasPhoto && !hasAudio
                                    ? 'Please upload a photo and record/upload audio'
                                    : !hasPhoto
                                    ? 'Please upload a photo'
                                    : 'Please record or upload audio',
                                style: AppTextStyle.regular(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(
                            width: size.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: hasPhoto && hasAudio
                                  ? () {
                                      if (controller.validateStep3()) {
                                        controller.nextStep();
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hasPhoto && hasAudio
                                    ? AppColors.buttonPrimary
                                    : AppColors.borderLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Next',
                                style: AppTextStyle.bold(
                                  fontSize: 16,
                                  color: AppColors.buttonTextWhite,
                                ),
                              ),
                            ),
                          ),
                          const DisclaimerFooter(),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUpload(BuildContext context, Size size) {
    return Obx(
      () => GestureDetector(
        onTap: () => _showImageSourceDialog(context),
        child: Container(
          width: size.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: controller.selectedPhoto.value != null
              ? Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(controller.selectedPhoto.value!.path),
                        height: 200,
                        width: size.width * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Photo uploaded',
                      style: AppTextStyle.regular(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svgs/Rectangle 61.svg",
                      height: 45,
                      width: size.width * 0.4,
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'Tap to Upload or Take Photo',
                      style: AppTextStyle.bold(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor.withOpacity(0.56),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clear facial photo, plain background, neck to top of head.',
                      style: AppTextStyle.regular(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffA7A7A7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildVoiceSample(BuildContext context, Size size) {
    return Obx(
      () => GestureDetector(
        onTap: controller.isRecording.value
            ? controller.stopRecording
            : controller.startRecording,
        child: Container(
          width: size.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                height: 45,
                width: size.width * 0.4,
                "assets/svgs/Vector.svg",
                color: controller.isRecording.value
                    ? AppColors.progressActive
                    : AppColors.textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                controller.isRecording.value
                    ? 'Recording... ${10 - controller.recordingDuration.value}s'
                    : controller.audioFilePath.value.isNotEmpty
                    ? 'Voice sample recorded'
                    : 'Record 10-Second Voice Sample',
                style: AppTextStyle.bold(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackColor.withOpacity(0.56),
                ),
              ),
              if (controller.isRecording.value) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: controller.recordingDuration.value / 10,
                    backgroundColor: AppColors.borderLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.progressActive,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioFileUpload(BuildContext context, Size size) {
    return Obx(
      () => GestureDetector(
        onTap: controller.pickAudioFile,
        child: Container(
          width: size.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/svgs/Icon.svg",
                height: 45,
                width: size.width * 0.4,
              ),
              const SizedBox(height: 12),
              Text(
                controller.audioFilePath.value.isNotEmpty
                    ? 'Audio file uploaded'
                    : 'Upload Audio File',
                style: AppTextStyle.bold(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackColor.withOpacity(0.56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Image Source',
            style: AppTextStyle.bold(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
