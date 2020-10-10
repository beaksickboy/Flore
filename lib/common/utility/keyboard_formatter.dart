import 'package:flutter/services.dart';

/// not allow key will be replace with ""
/// Use with inputFormatter props in TextField
class KeyboardFormatter {
  static FilteringTextInputFormatter positiveInteger() {
    return FilteringTextInputFormatter(RegExp('[ .,-]'), allow: false);
  }

  static FilteringTextInputFormatter positiveNumber() {
    return FilteringTextInputFormatter(RegExp('[ ,-]'), allow: false);
  }

  static FilteringTextInputFormatter blackList(String blackListCharacters) {
    return FilteringTextInputFormatter(RegExp('[$blackListCharacters]'),
        allow: false);
  }

  static TextInputFormatter uppercase() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(text: newValue.text?.toUpperCase());
    });
  }

  static TextInputFormatter lowercase() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(text: newValue.text?.toLowerCase());
    });
  }

  static TextInputFormatter allowOneDecimal() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final allMatch = '.'.allMatches(newValue.text);
      return allMatch.length <= 1 ? newValue : oldValue;
    });
  }
}
