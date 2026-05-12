// ============================================================================
// lib/presentation/controllers/account/desktop_access_controller.dart
// Controller del flujo "Configurar acceso para escritorio".
//
// Vive durante la vida del bottom-sheet/dialog de setup. Encapsula:
//   - Validaciones de entrada (username/password).
//   - Disponibilidad del username contra Firestore (vía AuthRepository).
//   - Llamada al UC de linking (linkWithCredential).
//   - Mensajes de error localizados desde AuthFailure.
//
// NO toca FirebaseAuth directamente: todo pasa por AuthRepository / UC.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../domain/entities/account/desktop_access_status.dart';
import '../../../domain/errors/auth_failure.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/account/link_desktop_access_uc.dart';

class DesktopAccessController extends GetxController {
  final LinkDesktopAccessUC _linkUC;
  final AuthRepository _authRepo;

  DesktopAccessController({
    required LinkDesktopAccessUC linkUC,
    required AuthRepository authRepo,
  })  : _linkUC = linkUC,
        _authRepo = authRepo;

  final RxnString usernameError = RxnString();
  final RxnString passwordError = RxnString();
  final RxnString formError = RxnString();
  final RxBool checkingUsername = false.obs;
  final RxBool submitting = false.obs;

  /// Disponibilidad del username contra Firestore. Devuelve `true` si el
  /// username está libre o ya pertenece al UID actual.
  Future<bool> checkUsernameAvailability(String raw) async {
    final username = raw.trim().toLowerCase();
    usernameError.value = null;
    if (username.length < 3) {
      usernameError.value = 'Mínimo 3 caracteres.';
      return false;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      usernameError.value = 'No hay sesión activa.';
      return false;
    }
    checkingUsername.value = true;
    try {
      final res = await _authRepo.checkUsernameAvailability(username, uid);
      if (res == UsernameCheckResult.takenByOtherUser) {
        usernameError.value = 'Este nombre de usuario ya está en uso.';
        return false;
      }
      return true;
    } catch (_) {
      usernameError.value = 'No se pudo verificar el nombre de usuario.';
      return false;
    } finally {
      checkingUsername.value = false;
    }
  }

  /// Vincula la credencial password al UID actual. Devuelve el nuevo estado
  /// si fue exitoso; en caso de error setea [formError] y devuelve `null`.
  Future<DesktopAccessStatus?> submit({
    required String username,
    required String password,
    required String passwordConfirm,
  }) async {
    formError.value = null;
    usernameError.value = null;
    passwordError.value = null;

    final u = username.trim().toLowerCase();
    if (u.length < 3) {
      usernameError.value = 'Mínimo 3 caracteres.';
      return null;
    }
    if (password.length < 8) {
      passwordError.value = 'Mínimo 8 caracteres.';
      return null;
    }
    if (password != passwordConfirm) {
      passwordError.value = 'Las contraseñas no coinciden.';
      return null;
    }

    submitting.value = true;
    try {
      return await _linkUC(username: u, password: password);
    } on AuthFailure catch (e) {
      // Routing fino: el username y el password van a su propio slot.
      if (e.code == 'username_taken' || e.code == 'invalid-username') {
        usernameError.value = e.message;
      } else if (e.code == 'weak-password') {
        passwordError.value = e.message;
      } else {
        formError.value = e.message;
      }
      return null;
    } catch (_) {
      formError.value = 'No se pudo activar el acceso para escritorio.';
      return null;
    } finally {
      submitting.value = false;
    }
  }
}
