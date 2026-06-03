import 'package:ao_scan_app/controllers/auth_controller.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:ao_scan_app/views/widgets/phone_number_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sexController = TextEditingController();
  final _otherOccupationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isConfirmPasswordVisible = false.obs;
  final RxString _phoneCountryCode = '+1'.obs;
  final _formKey = GlobalKey<FormState>();

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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.08),
                Image.asset(
                  'assets/images/logo.png',
                  height: size.height * 0.15,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Create your account',
                  style: AppTextStyle.bold(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 34, 34, 34),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'Enter first name',
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Enter last name',
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                _buildTextField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  hint: 'Select your birth date',
                  readOnly: true,
                  onTap: () async {
                    final DateTime now = DateTime.now();
                    final DateTime lastDate = DateTime(
                      now.year - 18,
                      now.month,
                      now.day,
                    );
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: lastDate,
                      firstDate: DateTime(1900),
                      lastDate: lastDate,
                    );
                    if (picked != null) {
                      _dobController.text =
                          '${picked.day}/${picked.month}/${picked.year}';
                    }
                  },
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Date of birth is required'
                      : null,
                ),
                SizedBox(height: size.height * 0.02),
                _buildDropdown(
                  controller: _occupationController,
                  label: 'Occupation (I am...)',
                  items: occupations,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Occupation is required'
                      : null,
                ),
                ValueListenableBuilder(
                  valueListenable: _occupationController,
                  builder: (context, value, child) {
                    return _occupationController.text.contains("Other")
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _buildTextField(
                              controller: _otherOccupationController,
                              label: 'Other Occupation',
                              hint: 'Enter your occupation',
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Please enter your occupation'
                                  : null,
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                SizedBox(height: size.height * 0.02),
                _buildTextField(
                  controller: _countryController,
                  label: 'Country',
                  hint: 'Select your country',
                  readOnly: true,
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        _countryController.text = country.name;
                        _phoneCountryCode.value = '+${country.phoneCode}';
                      },
                    );
                  },
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Country is required'
                      : null,
                ),
                SizedBox(height: size.height * 0.02),
                PhoneNumberField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  selectedCountryCode: _phoneCountryCode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                _buildDropdown(
                  controller: _sexController,
                  label: 'Sex *',
                  items: const ['Male', 'Female'],
                  validator: (value) => value == null || value.isEmpty
                      ? 'Sex is required'
                      : null,
                ),
                SizedBox(height: size.height * 0.02),
                Obx(
                  () => _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_isPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password is required';
                      if (value.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        _isPasswordVisible.value = !_isPasswordVisible.value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Obx(
                  () => _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: !_isConfirmPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please confirm your password';
                      if (value != _passwordController.text)
                        return 'Passwords do not match';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        _isConfirmPasswordVisible.value =
                            !_isConfirmPasswordVisible.value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _authController.register(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            dob: _dobController.text.trim(),
                            occupation:
                                _occupationController.text.contains("Other")
                                ? _otherOccupationController.text.trim()
                                : _occupationController.text.trim(),
                            country: _countryController.text.trim(),
                            phoneNumber:
                                '${_phoneCountryCode.value} ${_phoneController.text.trim()}',
                            sex: _sexController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _authController.isLoading.value
                            ? AppColors.borderLight
                            : AppColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _authController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(159, 58, 82, 163),
                            )
                          : Text(
                              'Register',
                              style: AppTextStyle.bold(
                                fontSize: 18,
                                color: AppColors.buttonTextWhite,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyle.regular(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Login',
                        style: AppTextStyle.bold(
                          fontSize: 14,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    bool obscureText = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyle.regular(fontSize: 14, color: Colors.black87),
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
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100,
        errorStyle: AppTextStyle.regular(fontSize: 12, color: Colors.red),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required List<String> items,
    String? Function(String?)? validator,
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
        suffixIcon: const Icon(Icons.arrow_drop_down),
        filled: true,
        fillColor: AppColors.backgroundWhite,
        errorStyle: AppTextStyle.regular(fontSize: 12, color: Colors.red),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: (String? value) {
        controller.text = value ?? '';
      },
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
