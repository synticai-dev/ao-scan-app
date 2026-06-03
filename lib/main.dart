import 'package:ao_scan_app/controllers/demo_form_controller.dart';
import 'package:ao_scan_app/views/screens/splash_screen.dart';
import 'package:ao_scan_app/controllers/auth_controller.dart';
import 'package:ao_scan_app/utils/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ao_scan_app/utils/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Log app open
  await AnalyticsService.logAppOpen();

  Get.put(AuthController());
  await Get.putAsync(() => NotificationService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DemoFormController controller = Get.put<DemoFormController>(
      DemoFormController(),
    );

    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [AnalyticsService.getObserver()],
    );
  }
}
