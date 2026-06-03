import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/demo_form_controller.dart';
import 'step1_contact_info.dart';
import 'step2_free_demo.dart';
import 'step3_photo_voice.dart';
import 'step4_consent.dart';

class DemoFormScreen extends StatelessWidget {
  const DemoFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DemoFormController());

    return Obx(() {
      switch (controller.currentStep.value) {
        case 1:
          return Step1ContactInfo();
        case 2:
          return Step2FreeDemo();
        case 3:
          return Step3PhotoVoice();
        case 4:
          return Step4Consent();

        default:
          return Step1ContactInfo();
      }
    });
  }
}
