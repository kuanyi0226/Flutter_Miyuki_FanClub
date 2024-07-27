class StringService {
  //Song Name
  static String dashToSpace(String originalString) {
    String result = 'Transform Error';
    result = originalString.replaceAll('_', ' ');
    return result;
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
