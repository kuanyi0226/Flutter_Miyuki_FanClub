import 'package:firebase_analytics/firebase_analytics.dart';

import '../../materials/InitData.dart';

class AnalyticsService {
  static Future<void> turnOnAnalytics(FirebaseAnalytics analytics) async {
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.setUserId(id: InitData.miyukiUser.uid);
  }
}
