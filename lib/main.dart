import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './MyApp.dart';
import './firebase_options.dart';
import './widgets/ClubCachedImage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.maximumSize = 48;
    imageCache.maximumSizeBytes = 8 * 1024 * 1024;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    MobileAds.instance.initialize();
    await ClubCachedImage.initializeCache();
  }

  runApp(const MyApp());
}
