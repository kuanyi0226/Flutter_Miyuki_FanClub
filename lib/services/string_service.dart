class StringService {
  //Song Name
  static String dashToSpace(String originalString) {
    String result = 'Transform Error';
    result = originalString.replaceAll('_', ' ');
    return result;
  }

  static String fullwidthToHalfwidth(String input) {
    // Define the offset between fullwidth and halfwidth characters
    const int fullwidthOffset = 0xFEE0;

    // Convert the input string to a list of runes (Unicode code points)
    List<int> runes = input.runes.map((int rune) {
      // Check if the rune is within the fullwidth ASCII range
      if (rune >= 0xFF01 && rune <= 0xFF5E) {
        // Convert the fullwidth character to halfwidth by subtracting the offset
        return rune - fullwidthOffset;
      } else if (rune == 0x3000) {
        // Special case for the fullwidth space character
        return 0x0020;
      } else {
        // Return the rune as-is if it's not a fullwidth character
        return rune;
      }
    }).toList();

    // Convert the list of runes back to a string
    return String.fromCharCodes(runes);
  }

  static String katakanaToHiragana(String input) {
    // Define the offset between Katakana and Hiragana characters
    const int kanaOffset = 0x60;

    // Convert the input string to a list of runes (Unicode code points)
    List<int> runes = input.runes.map((int rune) {
      // Check if the rune is within the Katakana range
      if (rune >= 0x30A1 && rune <= 0x30F6) {
        // Convert the Katakana character to Hiragana by subtracting the offset
        return rune - kanaOffset;
      } else {
        // Return the rune as-is if it's not a Katakana character
        return rune;
      }
    }).toList();

    // Convert the list of runes back to a string
    return String.fromCharCodes(runes);
  }

  //Comment time (add zero)
  static String commentTimeFix(String commentTimeStamp) {
    int colonIndex = commentTimeStamp.lastIndexOf(':');
    String result = commentTimeStamp;
    //check hour
    if (commentTimeStamp[colonIndex - 2] == ' ') {
      result = insertCharAt(result, colonIndex - 1, '0');
    }
    //check minute
    if (colonIndex == commentTimeStamp.length - 2) {
      colonIndex = result.lastIndexOf(':');
      result = insertCharAt(result, colonIndex + 1, '0');
    }

    return result;
  }

  static String insertCharAt(String input, int index, String char) {
    if (index < 0 || index > input.length) {
      throw RangeError("Index out of bounds");
    }
    return input.substring(0, index) + char + input.substring(index);
  }
}
