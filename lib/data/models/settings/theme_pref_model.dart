import 'package:isar_community/isar.dart';

part 'theme_pref_model.g.dart';

@Collection()
class ThemePreferenceModel {
  Id? isarId;

  // Single row collection; we will always keep one document
  String mode = 'system'; // 'system' | 'light' | 'dark'
  late DateTime updatedAt;

  ThemePreferenceModel();
}
