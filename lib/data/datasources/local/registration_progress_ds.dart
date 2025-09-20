import 'package:isar_community/isar.dart';
import '../../models/auth/registration_progress_model.dart';

class RegistrationProgressDS {
  final Isar isar;
  RegistrationProgressDS(this.isar);

  Future<RegistrationProgressModel> upsert(RegistrationProgressModel model) async {
    model.updatedAt = DateTime.now().toUtc();
    await isar.writeTxn(() async => isar.registrationProgressModels.put(model));
    return model;
  }

  Future<RegistrationProgressModel?> get(String id) async {
    return isar.registrationProgressModels.filter().idEqualTo(id).findFirst();
  }

  Future<void> clear(String id) async {
    final found = await get(id);
    if (found?.isarId != null) {
      await isar.writeTxn(() async => isar.registrationProgressModels.delete(found!.isarId!));
    }
  }
}
