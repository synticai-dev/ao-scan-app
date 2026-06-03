import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/demo_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../widgets/step_header.dart';
import '../widgets/disclaimer_footer.dart';

class Step4Consent extends StatelessWidget {
  final DemoFormController controller = Get.find<DemoFormController>();

  Step4Consent({super.key});

  final Uri _purchaseUrl = Uri.parse("https://shop.solexnation.com/energy1");

  Future<void> _launchUrl() async {
    if (!await launchUrl(_purchaseUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_purchaseUrl');
    }
  }

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
                        'Additional Comments',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bold(
                          fontSize: 24,
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tell us more about yourself and where you will be using the AO Scan (home or wellness clinic use)',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regular(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Your Message',
                        hintStyle: AppTextStyle.regular(
                          fontSize: 14,
                          color: AppColors.textLight,
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
                        filled: true,
                        fillColor: AppColors.backgroundWhite,
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// Checkbox 1
                    _buildCheckbox(
                      value: controller.consent1,
                      text:
                          'I understand that AO Scan technology is an educational tool and not a medical device.',
                    ),
                    const SizedBox(height: 16),

                    /// Checkbox 2
                    _buildCheckbox(
                      value: controller.consent2,
                      text: 'I am over 18 years of age.',
                    ),
                    const SizedBox(height: 16),

                    /// Checkbox 3 (NEW PURCHASE CONSENT WITH LINK)
                    _buildPurchaseCheckbox(),
                    const SizedBox(height: 16),

                    /// Checkbox 4
                    _buildCheckbox(
                      value: controller.consent4,
                      text:
                          'I agree to receive emails and text messages related to my AO Scan demo, results, and follow-up information.',
                    ),
                    const SizedBox(height: 16),

                    /// Checkbox 5
                    _buildCheckbox(
                      value: controller.consent5,
                      text:
                          "I understand that AO Scan Global is an independent Quantum Living Advocate and the largest reseller of AO Scan technology, and is not affiliated with Solex Global.",
                    ),
                    const SizedBox(height: 16),

                    /// MOVED TO LAST (as requested by client)
                    _buildCheckbox(
                      value: controller.consent3,
                      text:
                          'I confirm this is my first AO Scan demo and that this request is for my own body.',
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed:
                              controller.consent1.value &&
                                  controller.consent2.value &&
                                  controller.consent3.value &&
                                  controller.consent4.value &&
                                  controller.consent5.value &&
                                  controller.consent6.value &&
                                  !controller.isSubmitting.value
                              ? () async {
                                  await controller.submitForm();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.consent1.value &&
                                    controller.consent2.value &&
                                    controller.consent3.value &&
                                    controller.consent4.value &&
                                    controller.consent5.value &&
                                    controller.consent6.value
                                ? AppColors.buttonPrimary
                                : AppColors.borderLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Obx(
                            () => controller.isSubmitting.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.progressActive,
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.progressActive,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Submit Request',
                                    style: AppTextStyle.bold(
                                      fontSize: 16,
                                      color: AppColors.buttonTextWhite,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const DisclaimerFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox({required RxBool value, required String text}) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => value.value = !value.value,
            child: Container(
              width: 25,
              height: 21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: value.value
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
                border: Border.all(
                  color: value.value
                      ? AppColors.buttonPrimary
                      : AppColors.checkboxBorder,
                  width: 2,
                ),
              ),
              child: value.value
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => value.value = !value.value,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  text,
                  style: AppTextStyle.regular(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff5B5B5B),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCheckbox() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.consent6.value = !controller.consent6.value,
            child: Container(
              width: 25,
              height: 21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: controller.consent6.value
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
                border: Border.all(
                  color: controller.consent6.value
                      ? AppColors.buttonPrimary
                      : AppColors.checkboxBorder,
                  width: 2,
                ),
              ),
              child: controller.consent6.value
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  controller.consent6.value = !controller.consent6.value,
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle.regular(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff5B5B5B),
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'If I decide to purchase the AO Scan, I will do so from ',
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: _launchUrl,
                        child: Text(
                          'shop.solexnation.com/energy1',

                          style: AppTextStyle.regular(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.buttonPrimary,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' with this current email.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
