import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/YukiSekai.dart';

import './MyApp.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const MyApp());
  //runApp((InitData.inGame) ? GameWidget(game: yukiSekai) : const MyApp());
}
