class Validators {
  static bool nonEmpty(String? v) => v != null && v.trim().isNotEmpty;

  static bool minLength(String? v, int length) => nonEmpty(v) && v!.trim().length >= length;

  static bool maxLength(String? v, int length) => v == null || v.trim().length <= length;

  static bool isEmail(String? v) {
    if (!nonEmpty(v)) return false;
    final re = RegExp(r'^.+@[^@]+\.[^@]{2,}$');
    return re.hasMatch(v!.trim());
    }

  static bool isPhone(String? v) {
    if (!nonEmpty(v)) return false;
    final re = RegExp(r'^[+]?\d{6,15}$');
    return re.hasMatch(v!.trim());
  }

  static bool matchesRegex(String? v, Pattern pattern) {
    if (!nonEmpty(v)) return false;
    return RegExp(pattern.toString()).hasMatch(v!.trim());
  }

  static bool isIsoDate(String? v) {
    if (!nonEmpty(v)) return false;
    final re = RegExp(r'^\d{4}-\d{2}-\d{2}(?:[T ]\d{2}:\d{2}:\d{2}(?:\.\d{1,6})?Z?)?$');
    return re.hasMatch(v!.trim());
  }

  static bool isUrl(String? v) {
    if (!nonEmpty(v)) return false;
    final re = RegExp(r'^(https?:)//([\w.-]+)(:[0-9]+)?(/.*)?$');
    return re.hasMatch(v!.trim());
  }
}
