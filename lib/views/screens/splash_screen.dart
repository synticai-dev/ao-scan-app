import 'package:ao_scan_app/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ao_scan_app/controllers/auth_controller.dart';
import 'package:ao_scan_app/views/screens/auth/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      final authController = Get.find<AuthController>();
      if (authController.isLoggedIn) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 210,
                    width: 210,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40),
                // Main Heading
                SizedBox(
                  width: size.width,
                  child: FittedBox(
                    child: const Text(
                      'Request a Free AO Scan Demo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3A53A3),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Bulleted List
                // Bulleted List
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildBulletPoint('First time AO Scan users only'),
                        _buildBulletPoint('Must be over 18 years of age'),
                        _buildBulletPoint('One demo per person'),
                        _buildBulletPoint(
                          'Professionals & prospects of AO Scan Global QLA only',
                        ),
                        _buildBulletPoint('Scan(s) performed remotely'),
                        _buildBulletPoint(
                          'Demo scans are educational and not diagnostic',
                        ),
                        _buildBulletPoint('Scans subject to availability'),
                        _buildBulletPoint(
                          'We refuse the right to not complete a demo scan',
                        ),
                        _buildBulletPoint('Fast uptake, secure data'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Divider
                const Divider(color: Color(0xFFE0E0E0), thickness: 1),
                const SizedBox(height: 15),
                // Disclaimer
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'AO Scan technology is an educational tool and not a medical device. '
                    'AO Scan Global is the largest reseller of AO Scan technology. We are not Solex Global. '
                    'I am an Independent Quantum Living Advocate for Solex Global.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 12.0),
            child: Icon(Icons.circle, size: 8, color: Colors.black),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1a3a5f),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
