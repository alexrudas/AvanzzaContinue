// ============================================================================
// lib/domain/usecases/account/get_desktop_access_status_uc.dart
// Resuelve el estado actual de acceso para escritorio del usuario autenticado.
//
// Combina dos fuentes:
//   1. providerData de FirebaseAuth (¿existe credencial 'password' vinculada?).
//   2. UserProfile.username en Firestore (alias necesario para login).
//
// Si cualquiera de las dos falta, el estado canónico es notConfigured.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';

import '../../entities/account/desktop_access_status.dart';
import '../../repositories/auth_repository.dart';

class GetDesktopAccessStatusUC {
  final FirebaseAuth _auth;
  final AuthRepository _authRepo;

  GetDesktopAccessStatusUC(this._auth, this._authRepo);

  Future<DesktopAccessStatus> call() async {
    final user = _auth.currentUser;
    if (user == null) return const DesktopAccessStatus.notConfigured();

    final hasPassword =
        user.providerData.any((p) => p.providerId == 'password');
    if (!hasPassword) return const DesktopAccessStatus.notConfigured();

    final username = await _authRepo.fetchUsernameForUid(user.uid);
    if (username == null || username.isEmpty) {
      return const DesktopAccessStatus.notConfigured();
    }
    return DesktopAccessStatus.configured(username: username);
  }
}
