class StringService {
  //Song Name
  static String dashToSpace(String originalString) {
    String result = 'Transform Error';
    result = originalString.replaceAll('_', ' ');
    return result;
  }
}
