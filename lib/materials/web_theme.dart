import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const yukiWebBackground = Color(0xff10121a);
const yukiWebSurface = Color(0xff1a1d28);
const yukiWebSurfaceHigh = Color(0xff232735);
const yukiWebBorder = Color(0xff343949);
const yukiWebAccent = Color(0xffe4b7df);
const yukiWebMuted = Color(0xffaeb4c5);

ThemeData buildYukiDarkTheme() {
  if (!kIsWeb) {
    return ThemeData(brightness: Brightness.dark);
  }

  final scheme =
      ColorScheme.fromSeed(
        seedColor: yukiWebAccent,
        brightness: Brightness.dark,
        surface: yukiWebSurface,
      ).copyWith(
        primary: yukiWebAccent,
        onPrimary: const Color(0xff241822),
        secondary: const Color(0xffa8c8f0),
        surface: yukiWebSurface,
        onSurface: const Color(0xfff3eef5),
        outline: yukiWebBorder,
        outlineVariant: const Color(0xff292d3a),
      );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: yukiWebBackground,
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.55),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: yukiWebBackground,
      foregroundColor: Color(0xfff3eef5),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: 68,
      titleTextStyle: TextStyle(
        color: Color(0xfff3eef5),
        fontSize: 19,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      iconTheme: IconThemeData(color: yukiWebAccent),
    ),
    cardTheme: CardThemeData(
      color: yukiWebSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: yukiWebBorder),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: yukiWebBorder,
      thickness: 1,
      space: 1,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: yukiWebAccent,
      textColor: Color(0xfff3eef5),
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: yukiWebSurfaceHigh,
      hintStyle: const TextStyle(color: yukiWebMuted),
      labelStyle: const TextStyle(color: yukiWebMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: yukiWebBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: yukiWebAccent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: yukiWebAccent,
        foregroundColor: const Color(0xff241822),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: yukiWebSurfaceHigh,
        foregroundColor: yukiWebAccent,
        elevation: 0,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: yukiWebBorder),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: yukiWebAccent,
        minimumSize: const Size(0, 46),
        side: const BorderSide(color: yukiWebBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: yukiWebAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: yukiWebAccent,
      unselectedLabelColor: yukiWebMuted,
      indicatorColor: yukiWebAccent,
      dividerColor: yukiWebBorder,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: yukiWebSurface,
      surfaceTintColor: Colors.transparent,
      width: 340,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(22)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: yukiWebSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: yukiWebBorder),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: yukiWebSurfaceHigh,
      contentTextStyle: const TextStyle(color: Color(0xfff3eef5)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: yukiWebAccent,
    ),
  );
}

class YukiScrollBehavior extends MaterialScrollBehavior {
  const YukiScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    if (kIsWeb) return const ClampingScrollPhysics();
    return super.getScrollPhysics(context);
  }
}
