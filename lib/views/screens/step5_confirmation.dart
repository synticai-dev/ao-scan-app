import 'package:ao_scan_app/views/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/demo_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../widgets/disclaimer_footer.dart';

class Step5Confirmation extends StatelessWidget {
  final DemoFormController controller = Get.find<DemoFormController>();

  Step5Confirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: AppColors.backgroundWhite),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),

                    const SizedBox(height: 40),
                    // Success Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.buttonPrimary,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 50,
                        color: AppColors.buttonTextWhite,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'Your AO Scan demo request has been received.',
                      style: AppTextStyle.bold(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Message
                    Text(
                      'We\'ll review your information and send your demo results to the email you provided. Please keep an eye on your inbox (and spam/promotions folder) for an email from AO Scan Global.',
                      style: AppTextStyle.regular(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Button
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle visit AO Scan Global
                          Get.snackbar(
                            'Success',
                            'Redirecting to AO Scan Global...',
                          );
                          Get.to(
                            () => const WebViewScreen(
                              url: 'https://www.aoscanglobal.com',
                              title: 'About AO Scan',
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Visit AO Scan Global',
                          style: AppTextStyle.bold(
                            fontSize: 16,
                            color: AppColors.buttonTextWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.borderLight, height: 1),
            const DisclaimerFooter(),
          ],
        ),
      ),
    );
  }
}
