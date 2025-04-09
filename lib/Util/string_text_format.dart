
class StringTextFormat {
  String formatStringTime(String value) {
    String character = ':00';
    if (value.length == 5) {
      return value += character;
    }
    return value;
  }

  String formatStringTimeRemove(String value) {
    String character = ':00';
    if (value.length == 8) {
       return value.replaceAll(character, "") + character;
    }
    return value;
  }
}
