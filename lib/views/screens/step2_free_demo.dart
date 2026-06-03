import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/demo_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../widgets/step_header.dart';
import '../widgets/disclaimer_footer.dart';

class Step2FreeDemo extends StatelessWidget {
  final DemoFormController controller = Get.find<DemoFormController>();
  final _formKey = GlobalKey<FormState>();

  Step2FreeDemo({super.key});

  static const List<String> occupations = [
    "Doctor",
    "Mom",
    "Affiliate Marketer",
    "Influencer",
    "Naturopath",
    "Chiropractor",
    "Biohacker",
    "Energy Healer",
    "Health Coach",
    "Holistic Practitioner",
    "Life Coach",
    "Massage Therapist",
    "Wellness Enthusiast",
    "Personal Trainer",
    "Emotion Code Practitioner",
    "Physical Therapist",
    "Veterinarian",
    "Dentist",
    "Other",
  ];

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Free Demo',
                          style: AppTextStyle.bold(
                            fontSize: 24,
                            color: AppColors.buttonPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        textAlign: TextAlign.center,
                        'Tell us who you are so we can tailor your AO Scan demo experience.',
                        style: AppTextStyle.regular(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildDropdown(
                        controller: controller.occupationController,
                        label: 'Occupation (I am...)',
                        items: occupations,
                        validator: controller.validateOccupation,
                        readOnly: controller.authController.userModel.value != null,
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder(
                        valueListenable: controller.occupationController,
                        builder: (context, value, child) {
                          return controller.occupationController.text.contains(
                                "Other",
                              )
                              ? TextFormField(
                                  controller:
                                      controller.otherOccupationController,
                                  keyboardType: TextInputType.name,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    labelText: 'Other',
                                    labelStyle: AppTextStyle.regular(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: AppColors.borderLight,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: AppColors.borderLight,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: AppColors.buttonPrimary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    errorStyle: AppTextStyle.regular(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your occupation';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                )
                              : const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: size.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.nextStep();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary,
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            const DisclaimerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required List<String> items,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyle.regular(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.buttonPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: readOnly ? null : const Icon(Icons.arrow_drop_down),
        filled: true,
        fillColor: AppColors.backgroundWhite,
        errorStyle: AppTextStyle.regular(fontSize: 12, color: Colors.red),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: readOnly
          ? null
          : (String? value) {
              controller.text = value ?? '';
            },
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
