import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
        child: Column(
          children: [
            StepHeader(
              currentStep: controller.currentStep.value,
              totalSteps: controller.totalSteps,
              onBack: () => Get.back(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Contact Information',
                        style: AppTextStyle.bold(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(
                        controller: controller.firstNameController,
                        label: 'First Name *',
                        validator: controller.validateFirstName,
                        readOnly: controller.authController.userModel.value != null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.lastNameController,
                        label: 'Last Name *',
                        validator: controller.validateLastName,
                        readOnly: controller.authController.userModel.value != null,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: controller.emailController,
                        label: 'Email *',
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        readOnly: true,
                        validator: controller.validateCountry,
                        suffixIcon: controller.authController.userModel.value != null
                            ? null
                            : const Icon(Icons.arrow_drop_down),
                        onTap: controller.authController.userModel.value != null
                            ? null
                            : () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: false,
                                  onSelect: (Country country) {
                                    controller.countryController.text = country.name;
                                    controller.phoneCountryCode.value =
                                        '+${country.phoneCode}';
                                  },
                                );
                              },
                        controller: controller.countryController,
                        label: 'Country *',
                      ),
                      const SizedBox(height: 16),
                      PhoneNumberField(
                        controller: controller.phoneController,
                        label: 'Phone Number *',
                        validator: controller.validatePhone,
                        selectedCountryCode: controller.phoneCountryCode,
                        readOnly: controller.authController.userModel.value != null,
                      ),
                      const SizedBox(height: 16),
                      _buildSexDropdown(
                        controller: controller.sexController,
                        validator: controller.validateSex,
                      ),
                      const SizedBox(height: 16),
                      _buildUnitAndValueDropdown(
                        label: 'Weight',
                        unitValue: controller.weightUnit,
                        units: ['lb', 'kg'],
                        valueController: controller.weightController,
                        validator: controller.validateWeight,
                      ),
                      const SizedBox(height: 16),
                      _buildUnitAndValueDropdown(
                        label: 'Height',
                        unitValue: controller.heightUnit,
                        units: ['in', 'cm'],
                        valueController: controller.heightController,
                        validator: controller.validateHeight,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.dobController,
                        label: 'Date of Birth *',
                        suffixIcon: controller.authController.userModel.value != null
                            ? null
                            : const Icon(Icons.calendar_today),
                        readOnly: true,
                        onTap: controller.authController.userModel.value != null
                            ? null
                            : () => _selectDate(context),
                        validator: controller.validateDOB,
                      ),
                      const SizedBox(height: 15),
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
                      const DisclaimerFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
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

  Widget _buildSexDropdown({
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: _getInputDecoration(label: 'Sex *'),
      items: ['Male', 'Female']
          .map(
            (val) => DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: AppTextStyle.regular(fontSize: 14),
              ),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val != null) {
          controller.text = val;
        }
      },
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildUnitAndValueDropdown({
    required String label,
    required RxString unitValue,
    required List<String> units,
    required TextEditingController valueController,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(() {
                // Determine range based on current unit
                List<int> currentRange;

                switch (unitValue.value) {
                  case 'kg':
                    currentRange = List.generate(221, (i) => 30 + i);
                    break;
                  case 'lb':
                    currentRange = List.generate(451, (i) => 50 + i);
                    break;
                  case 'cm':
                    currentRange = List.generate(151, (i) => 100 + i);
                    break;
                  case 'in':
                    currentRange = List.generate(71, (i) => 30 + i);
                    break;
                  default:
                    currentRange = [];
                }

                final values = currentRange
                    .map((e) => e.toString())
                    .toSet()
                    .toList();

                String? dropdownValue;

                if (values.contains(valueController.text)) {
                  dropdownValue = valueController.text;
                } else {
                  dropdownValue = null;
                  valueController.clear(); // 💥 Important Fix
                }

                return DropdownButtonFormField<String>(
                  key: ValueKey('${label}_${unitValue.value}'),
                  value: dropdownValue,
                  decoration: _getInputDecoration(label: 'Select $label *'),
                  items: values
                      .map(
                        (val) => DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            style: AppTextStyle.regular(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      valueController.text = val;
                    }
                  },
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                );
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: units.contains(unitValue.value)
                      ? unitValue.value
                      : units.first,
                  decoration: _getInputDecoration(label: '$label Unit *'),
                  items: units
                      .toSet()
                      .map(
                        (u) => DropdownMenuItem<String>(
                          value: u,
                          child: Text(
                            u,
                            style: AppTextStyle.regular(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      unitValue.value = val;
                      valueController.clear(); // 🔥 prevent crash
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _getInputDecoration({required String label}) {
    return InputDecoration(
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
        borderSide: const BorderSide(color: AppColors.buttonPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      errorStyle: AppTextStyle.regular(fontSize: 12, color: Colors.red),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: DateTime(1900),
      lastDate: lastDate,
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
      hint: Text(
        'Select Country',
        style: AppTextStyle.regular(fontSize: 14, color: AppColors.textLight),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getCountryItems() {
    final countries = [
      'United States',
      'United Kingdom',
      'Canada',
      'Australia',
      'Germany',
      'France',
      'Italy',
      'Spain',
      'Netherlands',
      'Belgium',
      'Switzerland',
      'Austria',
      'Sweden',
      'Norway',
      'Denmark',
      'Finland',
      'Poland',
      'Portugal',
      'Greece',
      'Ireland',
      'Czech Republic',
      'Hungary',
      'Romania',
      'Bulgaria',
      'Croatia',
      'Slovakia',
      'Slovenia',
      'Estonia',
      'Latvia',
      'Lithuania',
      'Luxembourg',
      'Malta',
      'Cyprus',
      'Iceland',
      'Liechtenstein',
      'Monaco',
      'San Marino',
      'Vatican City',
      'Andorra',
      'Japan',
      'China',
      'India',
      'South Korea',
      'Singapore',
      'Malaysia',
      'Thailand',
      'Indonesia',
      'Philippines',
      'Vietnam',
      'Taiwan',
      'Hong Kong',
      'New Zealand',
      'South Africa',
      'Egypt',
      'Nigeria',
      'Kenya',
      'Morocco',
      'Tunisia',
      'Algeria',
      'Ghana',
      'Ethiopia',
      'Tanzania',
      'Uganda',
      'Zimbabwe',
      'Botswana',
      'Namibia',
      'Mozambique',
      'Angola',
      'Zambia',
      'Malawi',
      'Madagascar',
      'Mauritius',
      'Seychelles',
      'Brazil',
      'Mexico',
      'Argentina',
      'Chile',
      'Colombia',
      'Peru',
      'Venezuela',
      'Ecuador',
      'Guatemala',
      'Cuba',
      'Haiti',
      'Dominican Republic',
      'Jamaica',
      'Trinidad and Tobago',
      'Bahamas',
      'Barbados',
      'Belize',
      'Costa Rica',
      'Panama',
      'Honduras',
      'Nicaragua',
      'El Salvador',
      'Paraguay',
      'Uruguay',
      'Bolivia',
      'Guyana',
      'Suriname',
      'Russia',
      'Ukraine',
      'Turkey',
      'Saudi Arabia',
      'United Arab Emirates',
      'Israel',
      'Jordan',
      'Lebanon',
      'Syria',
      'Iraq',
      'Iran',
      'Kuwait',
      'Qatar',
      'Bahrain',
      'Oman',
      'Yemen',
      'Afghanistan',
      'Pakistan',
      'Bangladesh',
      'Sri Lanka',
      'Nepal',
      'Bhutan',
      'Myanmar',
      'Cambodia',
      'Laos',
      'Mongolia',
      'North Korea',
      'Other',
    ];

    return countries.map((String country) {
      return DropdownMenuItem<String>(
        value: country,
        child: Text(
          country,
          style: AppTextStyle.regular(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      );
    }).toList();
  }
}
