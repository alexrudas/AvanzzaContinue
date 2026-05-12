// ============================================================================
// lib/domain/usecases/account/update_personal_data_uc.dart
// Persistencia de datos personales editables del UserEntity global.
// MVP: solo `name` (Nombre completo) y `email`. El resto del entity se
// conserva intacto. Local-first vía UserRepository.upsertUser.
// ============================================================================

import '../../entities/user/user_entity.dart';
import '../../repositories/user_repository.dart';

class UpdatePersonalDataUC {
  final UserRepository _userRepo;

  UpdatePersonalDataUC(this._userRepo);

  Future<UserEntity> call({
    required UserEntity current,
    required String name,
    required String email,
  }) async {
    final updated = current.copyWith(
      name: name.trim(),
      email: email.trim(),
      updatedAt: DateTime.now().toUtc(),
    );
    await _userRepo.upsertUser(updated);
    return updated;
  }
}
