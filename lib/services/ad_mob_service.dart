import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
  );

  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7079414090734216/5001251790';
    } else if (Platform.isIOS) {
      return null;
    } else
      return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7079414090734216/3921455483';
    } else if (Platform.isIOS) {
      return null;
    } else
      return null;
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7079414090734216/1818036322';
    } else if (Platform.isIOS) {
      return null;
    } else
      return null;
  }
}
