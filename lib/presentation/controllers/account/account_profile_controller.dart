// ============================================================================
// lib/presentation/controllers/account/account_profile_controller.dart
// Controller de la pantalla global /account.
//
// Responsabilidades:
//   - Exponer reactivamente la identidad del usuario (userRx) y el contexto
//     operativo resumido (memberships + activeWorkspaceContext).
//   - Persistir cambios canónicos de datos personales (name, email).
//   - Cargar y refrescar el estado de acceso de escritorio del UID actual.
//
// NO hace:
//   - Lógica de plataforma (delega a PlatformCapabilities en la UI).
//   - Linking de credenciales (eso vive en DesktopAccessController).
//   - Acceso directo a Firestore/Firebase (todo pasa por UCs / repos).
// ============================================================================

import 'package:get/get.dart';

import '../../../domain/entities/account/desktop_access_status.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/entities/workspace/workspace_context.dart';
import '../../../domain/usecases/account/get_desktop_access_status_uc.dart';
import '../../../domain/usecases/account/update_personal_data_uc.dart';
import '../session_context_controller.dart';

class AccountProfileController extends GetxController {
  final SessionContextController _session;
  final UpdatePersonalDataUC _updatePersonal;
  final GetDesktopAccessStatusUC _getDesktopAccess;

  AccountProfileController({
    required SessionContextController session,
    required UpdatePersonalDataUC updatePersonal,
    required GetDesktopAccessStatusUC getDesktopAccess,
  })  : _session = session,
        _updatePersonal = updatePersonal,
        _getDesktopAccess = getDesktopAccess;

  // ── Identidad / contexto (proxies reactivos a la sesión) ──────────────────
  Rxn<UserEntity> get userRx => _session.userRx;
  RxList<MembershipEntity> get membershipsRx => _session.membershipsRx;
  Rxn<WorkspaceContext> get activeWorkspaceRx => _session.activeWorkspaceContext;

  // ── Estado del acceso desktop ─────────────────────────────────────────────
  final Rx<DesktopAccessStatus> desktopAccess = Rx<DesktopAccessStatus>(
    const DesktopAccessStatus.notConfigured(),
  );
  final RxBool desktopAccessLoading = false.obs;

  // ── Estado del form de datos personales ───────────────────────────────────
  final RxBool savingPersonal = false.obs;
  final RxnString personalError = RxnString();

  @override
  void onInit() {
    super.onInit();
    refreshDesktopAccess();
  }

  Future<void> refreshDesktopAccess() async {
    if (desktopAccessLoading.value) return;
    desktopAccessLoading.value = true;
    try {
      desktopAccess.value = await _getDesktopAccess();
    } catch (_) {
      // Fail-safe: ante cualquier error de lectura, asumimos no configurado;
      // el usuario podrá reintentar o configurar manualmente.
      desktopAccess.value = const DesktopAccessStatus.notConfigured();
    } finally {
      desktopAccessLoading.value = false;
    }
  }

  /// Guarda nombre + email del UserEntity actual. Devuelve `true` si se
  /// persistió. Errores se exponen en [personalError].
  ///
  /// La actualización del `userRx` ocurre vía `UserRepository.watchUser`
  /// → ahora watcher REAL sobre Isar (ver `UserRepositoryImpl.watchUser`).
  /// El `upsertUser` que hace este UC escribe a Isar; el watcher emite el
  /// nuevo estado al `SessionContextController._userSub`, que pone el
  /// valor en `_user.value`. Cero push optimista necesario aquí.
  Future<bool> savePersonalData({
    required String name,
    required String email,
  }) async {
    final current = userRx.value;
    if (current == null) {
      personalError.value = 'No hay sesión activa.';
      return false;
    }
    if (name.trim().isEmpty) {
      personalError.value = 'El nombre no puede estar vacío.';
      return false;
    }
    savingPersonal.value = true;
    personalError.value = null;
    try {
      await _updatePersonal(
        current: current,
        name: name,
        email: email,
      );
      return true;
    } catch (e) {
      personalError.value = 'No se pudo guardar. Intenta de nuevo.';
      return false;
    } finally {
      savingPersonal.value = false;
    }
  }
}
