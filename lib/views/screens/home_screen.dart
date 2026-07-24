import 'package:ao_scan_app/controllers/demo_form_controller.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:ao_scan_app/views/screens/about_screen.dart';
import 'package:ao_scan_app/views/screens/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'demo_form_screen.dart';
import 'about_demo_screen.dart';
import 'webview_screen.dart';
import 'dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'records/ao_scan_records_main_screen.dart';
import 'package:ao_scan_app/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.put(DemoFormController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title: Text(
          'AO Scan Global',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.textPrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.015,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.01),

                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: size.height * 0.2,
                  width: size.width * 0.45,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: size.height * 0.02),

                // Free Demo / About Your AO Scan Demo button
                Obx(() {
                  final hasDemo = authController.hasSubmittedDemo.value;
                  return _buildOutlinedButton(
                    context: context,
                    text: hasDemo
                        ? 'About Your AO Scan Demo'
                        : 'Free AO Scan Demo',
                    onPressed: () {
                      if (hasDemo) {
                        Get.to(() => const AboutDemoMenuScreen());
                      } else {
                        controller.resetForm();
                        Get.to(() => const DemoFormScreen());
                      }
                    },
                    size: size,
                  );
                }),

                SizedBox(height: size.height * 0.01),

                _buildOutlinedButton(
                  context: context,
                  text: 'My Dashboard',
                  onPressed: () {
                    if (authController.isLoggedIn) {
                      Get.to(() => DashboardScreen());
                    } else {
                      Get.to(() => LoginScreen());
                    }
                  },
                  size: size,
                ),

                SizedBox(height: size.height * 0.01),

                _buildOutlinedButton(
                  context: context,
                  text: 'AO Scan Records',
                  onPressed: () {
                    if (authController.isLoggedIn) {
                      Get.to(() => const AoScanRecordsMainScreen());
                    } else {
                      Get.to(() => LoginScreen());
                    }
                  },
                  size: size,
                ),

                SizedBox(height: size.height * 0.01),

                _buildOutlinedButton(
                  context: context,
                  text: 'Explore AO Scan',
                  onPressed: () async {
                    final uri = Uri.parse(
                      "https://shop.solexnation.com/energy1/home",
                    );
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw 'Could not launch "https://shop.solexnation.com/energy1/home';
                    }
                    // Get.to(
                    //   () => const WebViewScreen(
                    //     url: 'https://shop.solexnation.com/energy1/home',
                    //     title: 'Shop AO Scan & Products',
                    //   ),
                    // );
                  },
                  size: size,
                ),
                SizedBox(height: size.height * 0.01),
                _buildOutlinedButton(
                  context: context,
                  text: 'About AO Scan',
                  onPressed: () {
                    Get.to(() => AboutScreen());
                  },
                  size: size,
                ),
                SizedBox(height: size.height * 0.01),
                _buildOutlinedButton(
                  context: context,
                  text: 'Resources Hub',
                  onPressed: () {
                    Get.to(() => SocialLinksScreen());
                  },
                  size: size,
                ),

                SizedBox(height: size.height * 0.01),
                _buildGreenButton(
                  context: context,
                  text: 'Live Chat',
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://tawk.to/chat/647b63247957702c744b9614/1h20vmhkl',
                    );
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw 'Could not launch Tawk chat';
                    }
                  },
                  size: size,
                ),

                SizedBox(height: size.height * 0.01),
                _buildOutlinedButton(
                  context: context,
                  text: 'Log In (already subscribed)',
                  onPressed: () async {
                    final uri = Uri.parse("https://app.aoscan.com/");
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw 'Could not launch "https://app.aoscan.com/';
                    }
                  },
                  size: size,
                ),
                SizedBox(height: size.height * 0.01),
                _buildOutlinedButton(
                  context: context,
                  text: 'Back Office',
                  onPressed: () async {
                    final uri = Uri.parse("https://office2.solexnation.com/");
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw 'Could not launch "https://office2.solexnation.com/';
                    }
                    // Get.to(
                    //   () => const WebViewScreen(
                    //     url: 'https://office2.solexnation.com/',
                    //     title: 'Back Office',
                    //   ),
                    // );
                  },
                  size: size,
                ),
                SizedBox(height: size.height * 0.02),
                // Agreement Text
                _buildAgreementText(context, size),
                SizedBox(height: size.height * 0.015),
                // Divider
                Divider(color: AppColors.borderLight, thickness: 1),
                SizedBox(height: size.height * 0.015),
                // Disclaimer
                _buildDisclaimerText(context, size),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await authController.logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Size size,
  }) {
    return SizedBox(
      width: size.width * 0.88,
      height: size.height * 0.05,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyle.bold(
              fontSize: 16,
              color: AppColors.buttonTextWhite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Size size,
  }) {
    return SizedBox(
      width: size.width * 0.88,
      height: size.height * 0.05,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.backgroundWhite,
          side: BorderSide(color: AppColors.buttonPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyle.bold(
              fontSize: 16,
              color: AppColors.buttonPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreenButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Size size,
  }) {
    return SizedBox(
      width: size.width * 0.88,
      height: size.height * 0.05,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.chat_bubble_rounded, size: 20),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyle.bold(fontSize: 16, color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF059669),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFF059669).withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildAgreementText(BuildContext context, Size size) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyle.regular(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        children: [
          const TextSpan(text: 'By continuing you agree to our '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppTextStyle.regular(
              fontSize: 14,
              color: AppColors.textSecondary,
            ).copyWith(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(
                  () => const WebViewScreen(
                    url:
                        'https://www.iubenda.com/privacy-policy/65675001/legal',
                    title: 'Privacy Policy',
                  ),
                );
              },
          ),

          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _buildDisclaimerText(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Column(
        children: [
          Text(
            'AO Scan technology is an educational tool and not a medical device.'
            'AO Scan Global is the largest reseller of AO Scan technology. We are not Solex Global.'
            'I am an Independent Quantum Living Advocate for Solex Global.',
            style: AppTextStyle.regular(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Copyright © 2026 AO Scan Global. All rights reserved.',
            style: AppTextStyle.regular(
              fontSize: 11,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
