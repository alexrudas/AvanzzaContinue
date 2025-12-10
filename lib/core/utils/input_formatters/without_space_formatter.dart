import 'package:flutter/services.dart';

TextInputFormatter get withOutSpaceFormatter =>
    TextInputFormatter.withFunction((a, b) => b.text.contains(" ") ? a : b);
