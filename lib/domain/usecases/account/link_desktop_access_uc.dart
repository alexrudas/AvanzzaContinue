// ============================================================================
// lib/domain/usecases/account/link_desktop_access_uc.dart
// Vincula una credencial email/password (alias canónico) al UID Firebase
// vigente, preservando identidad. Delegado al AuthRepository para mantener
// el dominio agnóstico del SDK de Firebase.
// ============================================================================

import '../../entities/account/desktop_access_status.dart';
import '../../repositories/auth_repository.dart';

class LinkDesktopAccessUC {
  final AuthRepository _authRepo;

  LinkDesktopAccessUC(this._authRepo);

  Future<DesktopAccessStatus> call({
    required String username,
    required String password,
  }) {
    return _authRepo.linkDesktopAccess(username: username, password: password);
  }
}
