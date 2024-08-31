import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './materials/colors.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import './MyApp.dart';
import './firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    //Web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCcDle3v-4nfMDR-pRtrueKhL5KE5xY1pI',
        appId: '1:825033090624:web:f6e8b382c9bf74760e61a5',
        messagingSenderId: '825033090624',
        projectId: 'miyuki-b1c80',
        storageBucket: 'miyuki-b1c80.appspot.com',
        databaseURL: 'https://miyuki-b1c80-default-rtdb.firebaseio.com',
        measurementId: "G-70HQFNVTSB",
      ),
    );
  } else {
    //Mobile
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          )
        : await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
    MobileAds.instance.initialize();
  }

  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: 700.0,
    app: const MyApp(),
  );
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  runApp(runnableApp);
  //runApp((InitData.inGame) ? GameWidget(game: yukiSekai) : const MyApp());
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Container(
    color: theme_purple,
    child: Center(
      child: ClipRect(
        child: SizedBox(
          width: webAppWidth,
          child: app,
        ),
      ),
    ),
  );
}
