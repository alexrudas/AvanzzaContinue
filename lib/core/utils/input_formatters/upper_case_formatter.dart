import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  final RegExp regExp = RegExp(r'(?=.*[a-z])');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (regExp.hasMatch(newValue.text)) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}
