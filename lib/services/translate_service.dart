import 'dart:ui' as ui;
import 'package:translator/translator.dart';

class TranslateService {
  static final GoogleTranslator _translator = GoogleTranslator();

  /// Translates an unknown language string to the target language.
  ///
  /// [inputText]: The string you want to translate.
  /// [targetLang]: The language code to translate into (e.g., 'zh-tw', 'en', 'ja').
  /// If [targetLang] is not provided, it falls back to the device's current locale.
  static Future<String> translateText(String inputText,
      {String? targetLang}) async {
    if (inputText.trim().isEmpty) return inputText;

    try {
      // Get the current device language code if targetLang is null
      final String finalTargetLang = targetLang ?? _getDeviceLanguageCode();

      // The 'translator' package automatically detects the source language
      // when 'from' is not explicitly provided.
      final Translation translation = await _translator.translate(
        inputText,
        to: finalTargetLang,
      );

      return translation.text;
    } catch (error) {
      // In case of network error or rate limit, print the error and return original text
      print('Translation Error: $error');
      return inputText;
    }
  }

  /// Helper method to fetch the current device locale
  static String _getDeviceLanguageCode() {
    try {
      // Fetch the platform locale
      final ui.Locale platformLocale = ui.PlatformDispatcher.instance.locale;

      // Some languages need specific country codes for Google Translate (e.g., Traditional Chinese)
      if (platformLocale.languageCode == 'zh') {
        return platformLocale.countryCode == 'TW' ||
                platformLocale.countryCode == 'HK'
            ? 'zh-tw'
            : 'zh-cn';
      }

      return platformLocale.languageCode;
    } catch (error) {
      print('Error getting locale: $error');
      return 'en'; // Default fallback
    }
  }
}
