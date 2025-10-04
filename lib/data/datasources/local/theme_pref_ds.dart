import 'package:isar_community/isar.dart';
import '../../models/settings/theme_pref_model.dart';

class ThemePrefDS {
  final Isar isar;
  ThemePrefDS(this.isar);

  Future<String?> getMode() async {
    final existing = await isar.themePreferenceModels.where().findFirst();
    return existing?.mode;
  }

  Future<void> setMode(String mode) async {
    final now = DateTime.now().toUtc();
    final existing = await isar.themePreferenceModels.where().findFirst();
    final m = existing ?? ThemePreferenceModel();
    m.mode = mode;
    m.updatedAt = now;
    await isar.writeTxn(() async {
      await isar.themePreferenceModels.put(m);
    });
  }
}
