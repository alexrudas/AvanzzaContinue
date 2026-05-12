// ============================================================================
// lib/presentation/demo_registration_v2/fusionado/onboarding_commit_controller.dart
// OnboardingCommitController — orquesta loading/error/retry del commit
// final del onboarding.
// ============================================================================
// QUÉ HACE:
//   - Encapsula el ciclo de vida del commit final:
//       idle → committing → success | error
//   - Invoca [CompleteOnboardingUC.execute] con manejo de errores.
//   - Calcula la decisión de navegación vía [resolveOnboardingNavigation]
//     pero NO navega (eso lo hace el caller — separación de concerns).
//   - Retry: re-ejecuta el commit con el último input registrado.
//
// QUÉ NO HACE:
//   - NO navega. Expone Rx<OnboardingNavigationDecision?> con la decisión
//     calculada en éxito; el caller observa y ejecuta `Get.offAllNamed`.
//   - NO instancia el UC. Recibe el UC inyectado para testabilidad y
//     desacoplamiento de DIContainer.
//   - NO toca AssetActorLink, Portfolio fuera del UC, ni shells. Solo
//     orquesta el commit.
//
// SE TESTEA inyectando un fake [CompleteOnboardingUC]:
//   - idle por default
//   - committing tras invocar commit()
//   - success con result poblado
//   - error con lastError poblado
//   - retry repite el último input
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../application/services/access/access_snapshot_service.dart';
import '../../../domain/usecases/onboarding/complete_onboarding_uc.dart';
import '../../../domain/usecases/onboarding/workspace_bootstrap_result.dart';
import '../demo_state.dart';
import 'onboarding_navigation_resolver.dart';

enum OnboardingCommitStatus { idle, committing, success, error }

class OnboardingCommitController extends GetxController {
  final CompleteOnboardingUC useCase;

  OnboardingCommitController({required this.useCase});

  // ─────────────────────────────────────────────────────────────────────
  // STATE
  // ─────────────────────────────────────────────────────────────────────

  final Rx<OnboardingCommitStatus> status =
      Rx<OnboardingCommitStatus>(OnboardingCommitStatus.idle);

  /// Resultado del último commit exitoso. Null hasta que succeed.
  final Rxn<WorkspaceBootstrapResult> lastResult = Rxn<WorkspaceBootstrapResult>();

  /// Decisión de navegación calculada tras el último commit exitoso.
  /// El caller observa este Rx para invocar `Get.offAllNamed`.
  final Rxn<OnboardingNavigationDecision> lastNavigation =
      Rxn<OnboardingNavigationDecision>();

  /// Mensaje de error del último intento fallido. Null en idle/committing/success.
  final Rxn<String> lastError = Rxn<String>();

  // Last input snapshot — para retry sin que el caller tenga que pasar
  // todo de nuevo.
  String? _lastUserId;
  DemoRegistrationState? _lastState;

  // ─────────────────────────────────────────────────────────────────────
  // GETTERS DE CONVENIENCIA
  // ─────────────────────────────────────────────────────────────────────

  bool get isIdle => status.value == OnboardingCommitStatus.idle;
  bool get isCommitting => status.value == OnboardingCommitStatus.committing;
  bool get isSuccess => status.value == OnboardingCommitStatus.success;
  bool get isError => status.value == OnboardingCommitStatus.error;

  /// True si hay un retry posible (último intento falló y tenemos input).
  bool get canRetry => isError && _lastUserId != null && _lastState != null;

  // ─────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────

  /// Ejecuta el commit con [userId] y [state]. Snapshot guardado para retry.
  Future<void> commit({
    required String userId,
    required DemoRegistrationState state,
  }) async {
    _lastUserId = userId;
    _lastState = state;
    await _run();
  }

  /// Re-ejecuta el último commit registrado. No-op si nunca se invocó
  /// `commit()` o si los inputs no se preservaron.
  Future<void> retry() async {
    if (_lastUserId == null || _lastState == null) return;
    await _run();
  }

  /// Reset a idle (útil al desmontar el flow o tras navegar).
  void reset() {
    status.value = OnboardingCommitStatus.idle;
    lastResult.value = null;
    lastNavigation.value = null;
    lastError.value = null;
    _lastUserId = null;
    _lastState = null;
  }

  // ─────────────────────────────────────────────────────────────────────
  // INTERNAL
  // ─────────────────────────────────────────────────────────────────────

  Future<void> _run() async {
    final uid = _lastUserId;
    final st = _lastState;
    if (uid == null || st == null) return;

    status.value = OnboardingCommitStatus.committing;
    lastError.value = null;

    try {
      final result = await useCase.execute(userId: uid, state: st);
      // Persistir snapshot LOCAL_BOOTSTRAP+pendingSync para que el próximo
      // cold start hidrate capabilities/isOwner sin esperar a Core API.
      // Solo si el commit creó el workspace en esta sesión (no hidratado
      // de existente) — para hidratados ya hay un snapshot CONFIRMED previo
      // (o lo hará el próximo /context).
      //
      // syncStatus=pendingSync por construcción: la creación local NO es
      // confirmación del backend. El próximo /context exitoso (o el
      // BootstrapSyncController) lo elevará a CONFIRMED.
      if (!result.fromExisting && Get.isRegistered<AccessSnapshotService>()) {
        try {
          await Get.find<AccessSnapshotService>().persistLocalBootstrap(
            userId: uid,
            org: result.organization,
          );
        } catch (e) {
          // Persistencia best-effort: si falla, el siguiente refresh
          // remoto reconstruirá el snapshot. No bloqueamos navegación.
          debugPrint(
              '[OnboardingCommitController] snapshot persist failed: $e');
        }
      }
      final navigation = resolveOnboardingNavigation(
        result: result,
        state: st,
      );
      lastResult.value = result;
      lastNavigation.value = navigation;
      status.value = OnboardingCommitStatus.success;
    } catch (e, st_) {
      debugPrint('[OnboardingCommitController] commit error: $e\n$st_');
      lastError.value = e.toString();
      status.value = OnboardingCommitStatus.error;
    }
  }
}
