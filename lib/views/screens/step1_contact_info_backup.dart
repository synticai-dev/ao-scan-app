import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/demo_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../widgets/step_header.dart';
import '../widgets/disclaimer_footer.dart';
import '../widgets/phone_number_field.dart';

class Step1ContactInfo extends StatelessWidget {
  final DemoFormController controller = Get.find<DemoFormController>();
  final _formKey = GlobalKey<FormState>();

  Step1ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          Obx(
            () => StepHeader(
              currentStep: controller.currentStep.value,
              totalSteps: controller.totalSteps,
              onBack: () => Get.back(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: AppTextStyle.bold(
                        fontSize: 24,
                        color: AppColors.buttonPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: controller.firstNameController,
                      label: 'First Name *',
                      validator: controller.validateFirstName,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.lastNameController,
                      label: 'Last Name *',
                      validator: controller.validateLastName,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.emailController,
                      label: 'Email *',
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _buildCountryDropdown(
                      controller: controller.countryController,
                      validator: controller.validateCountry,
                    ),
                    const SizedBox(height: 16),
                    PhoneNumberField(
                      controller: controller.phoneController,
                      label: 'Phone Number *',
                      validator: controller.validatePhone,
                      selectedCountryCode: controller.phoneCountryCode,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.weightController,
                      label: 'Weight *',
                      keyboardType: TextInputType.number,
                      validator: controller.validateWeight,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.heightController,
                      label: 'Height *',
                      keyboardType: TextInputType.number,
                      validator: controller.validateHeight,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.dobController,
                      label: 'Date of Birth *',
                      suffixIcon: const Icon(Icons.calendar_today),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: controller.validateDOB,
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
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
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.backgroundWhite,
        errorStyle: AppTextStyle.regular(fontSize: 12, color: Colors.red),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.dobController.text =
          '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  Widget _buildCountryDropdown({
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: 'Country *',
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
      items: _getCountryItems(),
      onChanged: (String? value) {
        controller.text = value ?? '';
      },
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Row(
        children: [
          Text(
            'Select Country',
            style: AppTextStyle.regular(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
      selectedItemBuilder: (BuildContext context) {
        return _getCountryItems().map((DropdownMenuItem<String> item) {
          final countryName = item.value ?? '';
          final flag = _getCountryFlag(countryName);
          return Row(
            children: [
              if (flag != null && flag.isNotEmpty) ...[
                Text(flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  countryName,
                  style: AppTextStyle.regular(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }).toList();
      },
    );
  }

  List<DropdownMenuItem<String>> _getCountryItems() {
    final countryMap = _getCountryMap();
    final sortedCountries = countryMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedCountries.map((entry) {
      final countryName = entry.key;
      final flag = entry.value;
      return DropdownMenuItem<String>(
        value: countryName,
        child: Row(
          children: [
            if (flag != null && flag.isNotEmpty) ...[
              Text(flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                countryName,
                style: AppTextStyle.regular(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String? _getCountryFlag(String countryName) {
    return _getCountryMap()[countryName];
  }

  Map<String, String?> _getCountryMap() {
    return {
      'United States': '🇺🇸',
      'United Kingdom': '🇬🇧',
      'Canada': '🇨🇦',
      'Australia': '🇦🇺',
      'Germany': '🇩🇪',
      'France': '🇫🇷',
      'Italy': '🇮🇹',
      'Spain': '🇪🇸',
      'Netherlands': '🇳🇱',
      'Belgium': '🇧🇪',
      'Switzerland': '🇨🇭',
      'Austria': '🇦🇹',
      'Sweden': '🇸🇪',
      'Norway': '🇳🇴',
      'Denmark': '🇩🇰',
      'Finland': '🇫🇮',
      'Poland': '🇵🇱',
      'Portugal': '🇵🇹',
      'Greece': '🇬🇷',
      'Ireland': '🇮🇪',
      'Czech Republic': '🇨🇿',
      'Hungary': '🇭🇺',
      'Romania': '🇷🇴',
      'Bulgaria': '🇧🇬',
      'Croatia': '🇭🇷',
      'Slovakia': '🇸🇰',
      'Slovenia': '🇸🇮',
      'Estonia': '🇪🇪',
      'Latvia': '🇱🇻',
      'Lithuania': '🇱🇹',
      'Luxembourg': '🇱🇺',
      'Malta': '🇲🇹',
      'Cyprus': '🇨🇾',
      'Iceland': '🇮🇸',
      'Liechtenstein': '🇱🇮',
      'Monaco': '🇲🇨',
      'San Marino': '🇸🇲',
      'Vatican City': '🇻🇦',
      'Andorra': '🇦🇩',
      'Japan': '🇯🇵',
      'China': '🇨🇳',
      'India': '🇮🇳',
      'South Korea': '🇰🇷',
      'Singapore': '🇸🇬',
      'Malaysia': '🇲🇾',
      'Thailand': '🇹🇭',
      'Indonesia': '🇮🇩',
      'Philippines': '🇵🇭',
      'Vietnam': '🇻🇳',
      'Taiwan': '🇹🇼',
      'Hong Kong': '🇭🇰',
      'New Zealand': '🇳🇿',
      'South Africa': '🇿🇦',
      'Egypt': '🇪🇬',
      'Nigeria': '🇳🇬',
      'Kenya': '🇰🇪',
      'Morocco': '🇲🇦',
      'Tunisia': '🇹🇳',
      'Algeria': '🇩🇿',
      'Ghana': '🇬🇭',
      'Ethiopia': '🇪🇹',
      'Tanzania': '🇹🇿',
      'Uganda': '🇺🇬',
      'Zimbabwe': '🇿🇼',
      'Botswana': '🇧🇼',
      'Namibia': '🇳🇦',
      'Mozambique': '🇲🇿',
      'Angola': '🇦🇴',
      'Zambia': '🇿🇲',
      'Malawi': '🇲🇼',
      'Madagascar': '🇲🇬',
      'Mauritius': '🇲🇺',
      'Seychelles': '🇸🇨',
      'Brazil': '🇧🇷',
      'Mexico': '🇲🇽',
      'Argentina': '🇦🇷',
      'Chile': '🇨🇱',
      'Colombia': '🇨🇴',
      'Peru': '🇵🇪',
      'Venezuela': '🇻🇪',
      'Ecuador': '🇪🇨',
      'Guatemala': '🇬🇹',
      'Cuba': '🇨🇺',
      'Haiti': '🇭🇹',
      'Dominican Republic': '🇩🇴',
      'Jamaica': '🇯🇲',
      'Trinidad and Tobago': '🇹🇹',
      'Bahamas': '🇧🇸',
      'Barbados': '🇧🇧',
      'Belize': '🇧🇿',
      'Costa Rica': '🇨🇷',
      'Panama': '🇵🇦',
      'Honduras': '🇭🇳',
      'Nicaragua': '🇳🇮',
      'El Salvador': '🇸🇻',
      'Paraguay': '🇵🇾',
      'Uruguay': '🇺🇾',
      'Bolivia': '🇧🇴',
      'Guyana': '🇬🇾',
      'Suriname': '🇸🇷',
      'Russia': '🇷🇺',
      'Ukraine': '🇺🇦',
      'Turkey': '🇹🇷',
      'Saudi Arabia': '🇸🇦',
      'United Arab Emirates': '🇦🇪',
      'Israel': '🇮🇱',
      'Jordan': '🇯🇴',
      'Lebanon': '🇱🇧',
      'Syria': '🇸🇾',
      'Iraq': '🇮🇶',
      'Iran': '🇮🇷',
      'Kuwait': '🇰🇼',
      'Qatar': '🇶🇦',
      'Bahrain': '🇧🇭',
      'Oman': '🇴🇲',
      'Yemen': '🇾🇪',
      'Afghanistan': '🇦🇫',
      'Pakistan': '🇵🇰',
      'Bangladesh': '🇧🇩',
      'Sri Lanka': '🇱🇰',
      'Nepal': '🇳🇵',
      'Bhutan': '🇧🇹',
      'Myanmar': '🇲🇲',
      'Cambodia': '🇰🇭',
      'Laos': '🇱🇦',
      'Mongolia': '🇲🇳',
      'North Korea': '🇰🇵',
      'Other': null,
    };
  }
}
