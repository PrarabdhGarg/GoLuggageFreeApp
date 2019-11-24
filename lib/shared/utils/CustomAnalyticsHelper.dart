import 'package:firebase_analytics/firebase_analytics.dart';

class CustomAnalyticsHelper {
  static FirebaseAnalytics _analytics;

  CustomAnalyticsHelper._();

  static FirebaseAnalytics getAnalyticsInstance() {
    if(_analytics == null) {
      _analytics = FirebaseAnalytics();
      _analytics.setAnalyticsCollectionEnabled(true);
    }
    return _analytics;
  }
}