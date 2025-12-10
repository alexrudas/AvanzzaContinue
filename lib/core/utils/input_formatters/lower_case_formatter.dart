import 'package:flutter/services.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  final RegExp regExp = RegExp(r'(?=.*[A-Z])');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (regExp.hasMatch(newValue.text)) {
      return TextEditingValue(
        text: newValue.text.toLowerCase(),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}
