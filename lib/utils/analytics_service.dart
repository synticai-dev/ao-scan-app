import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Log App Open
  static Future<void> logAppOpen() async {
    print("ANALYTICS: Logging App Open");
    await _analytics.logAppOpen();
  }

  // Log Login
  static Future<void> logLogin(String loginMethod) async {
    print("ANALYTICS: Logging Login - Method: $loginMethod");
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  // Log Registration
  static Future<void> logSignUp(String signUpMethod) async {
    print("ANALYTICS: Logging Sign Up - Method: $signUpMethod");
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  // Log Free Demo Form Submission
  static Future<void> logFreeDemoSubmission() async {
    print("ANALYTICS: Logging Free Demo Submission");
    await _analytics.logEvent(
      name: 'free_demo_submit',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Set User ID
  static Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  // Log Custom Screen Views (Optional but good practice)
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // Analytics Observer for GetX or Navigator
  static FirebaseAnalyticsObserver getObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}
