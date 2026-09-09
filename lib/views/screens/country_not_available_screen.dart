import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shown when a user from a non-approved country tries to open the free demo
/// form. Keeps the message on-brand and offers a link to the global shop.
class CountryNotAvailableScreen extends StatelessWidget {
  const CountryNotAvailableScreen({super.key});

  static const String _shopUrl = 'https://shop.solexnation.com/energy1';

  Future<void> _openShop() async {
    final uri = Uri.parse(_shopUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not open the shop. Please visit $_shopUrl',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Free AO Scan Demo',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.02),
              Image.asset(
                'assets/images/logo.png',
                height: size.height * 0.14,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.04),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      size: 44,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Not Available In Your Region',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please go to shop.solexnation.com/energy1 to view a '
                      'current list where AO Scan is available. Check back '
                      'often! Our global frequency community is growing '
                      'rapidly.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regular(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _openShop(),
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'View Available Regions',
                            style: AppTextStyle.bold(
                              fontSize: 16,
                              color: AppColors.buttonTextWhite,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Back to Dashboard',
                  style: AppTextStyle.bold(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}