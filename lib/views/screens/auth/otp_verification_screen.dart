import 'package:ao_scan_app/controllers/auth_controller.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Shows the 6-digit SMS code entry screen during registration.
///
/// The user enters the code they received via SMS (Firebase Phone Auth).
/// On success the account is created and the user lands on the Home screen.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  String get _otpCode => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Android SMS Retriever auto-verifies the phone: if the credential is
      // already available, complete registration without asking for the code.
      if (_authController.hasAutoVerifiedCredential) {
        _verify();
      } else {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Masks the verified phone number, e.g. +1 → "+1 •••• ••2345".
  String _maskPhone(String phone) {
    if (phone.isEmpty) return 'your phone';
    final last4 = phone.substring(phone.length - 4);
    final match = RegExp(r'^\+\d{1,3}').firstMatch(phone);
    final code = match?.group(0) ?? phone.substring(0, 1);
    return '$code •••• ••$last4';
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-submit when the last box is filled
    if (index == 5 && value.isNotEmpty && _otpCode.length == 6) {
      _verify();
    }
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();

    // The 6-digit code is only required when the OS didn't auto-verify.
    if (!_authController.hasAutoVerifiedCredential && _otpCode.length < 6) {
      Get.snackbar(
        'Incomplete Code',
        'Please enter the 6-digit code sent to your phone.',
      );
      return;
    }

    final success = await _authController.verifyOtpAndRegister(_otpCode);
    if (!success) {
      // Failures (wrong/expired code) keep the user on this screen with a
      // message from the controller; clear the input so they can retry.
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final phone = _authController.pendingE164Phone ?? '';
    final maskedPhone = _maskPhone(phone);

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
          'Verify Phone',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.02),
              Image.asset(
                'assets/images/logo.png',
                height: size.height * 0.12,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Verify Your Phone Number',
                textAlign: TextAlign.center,
                style: AppTextStyle.bold(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We sent a 6-digit verification code to\n$maskedPhone',
                textAlign: TextAlign.center,
                style: AppTextStyle.regular(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // 6 OTP digit boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return _buildOtpBox(index);
                }),
              ),
              SizedBox(height: size.height * 0.03),

              // Verify button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                        (_authController.isVerifyingOtp.value ||
                                _authController.isLoading.value)
                            ? null
                            : _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: (_authController.isVerifyingOtp.value ||
                            _authController.isLoading.value)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          )
                        : Text(
                            'Verify & Create Account',
                            style: AppTextStyle.bold(
                              fontSize: 16,
                              color: AppColors.buttonTextWhite,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),
              // Resend section with countdown
              Obx(() {
                final seconds = _authController.otpResendSecondsLeft.value;
                if (seconds > 0) {
                  return Text(
                    'Resend code in 0:${seconds.toString().padLeft(2, '0')}',
                    style: AppTextStyle.regular(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  );
                }
                return Column(
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: AppTextStyle.regular(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _authController.isSendingOtp.value
                          ? null
                          : () => _authController.resendOtp(),
                      child: Text(
                        _authController.isSendingOtp.value
                            ? 'Sending...'
                            : 'Resend Code',
                        style: AppTextStyle.bold(
                          fontSize: 14,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 48,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppTextStyle.bold(fontSize: 22, color: AppColors.textPrimary),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.zero,
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
        ),
        onChanged: (value) => _onDigitChanged(index, value),
        onTap: () {
          _controllers[index].selection =
              TextSelection.collapsed(offset: _controllers[index].text.length);
        },
        onEditingComplete: () {
          if (index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
        },
        textInputAction: index < 5
            ? TextInputAction.next
            : TextInputAction.done,
      ),
    );
  }
}