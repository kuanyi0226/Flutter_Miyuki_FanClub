import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/screens/auth_system/auth_page.dart';
import 'package:provider/provider.dart';

import './l10n/l10n.dart';
import './materials/web_theme.dart';
import './screens/web_home_layout.dart';
import 'package:project5_miyuki/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //check internet connections
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionChecker().onStatusChange;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '雪クラブ Yuki Club',
        theme: buildYukiDarkTheme(),
        darkTheme: buildYukiDarkTheme(),
        themeMode: ThemeMode.dark,
        scrollBehavior: const YukiScrollBehavior(),
        home: AuthPage(),
        navigatorObservers: [if (kIsWeb) webHomeRouteObserver],
        supportedLocales: L10n.all,
        //locale: const Locale("ja"),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
      ),
    );
  }
}
