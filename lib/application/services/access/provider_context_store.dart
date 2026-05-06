// ============================================================================
// lib/application/services/access/provider_context_store.dart
// PROVIDER CONTEXT STORE — Rx store de `isProvider` + `workspaceId` resueltos.
// ============================================================================
// QUÉ HACE:
// - Mantiene reactivamente el estado "soy proveedor en este workspace" para
//   que widgets/controllers consuman sin tener que disparar `GET /v1/providers/me`
//   en cada build.
// - Lo populan los puntos canónicos del flujo:
//     · `SplashBootstrapController` tras el fetch inicial.
//     · `ProviderMeController.refresh()` tras refresh manual.
// - Se vacía en logout y en workspace switch (el nuevo workspace puede tener
//   un valor distinto de `isProvider`).
//
// QUÉ NO HACE:
// - No hace HTTP. No conoce `ProviderSelfRepository`.
// - No persiste a disco. Vive en memoria por sesión (igual que
//   [SessionCapabilitiesStore]). El próximo arranque re-derivará el estado
//   desde `GET /v1/providers/me`.
// - No reemplaza al campo `Membership.roles[]` ni a `ActiveContext.rol` con
//   un sentinel local; el "rol UI" se compone de capabilities + isProvider.
//
// PRINCIPIOS:
// - Single source of truth en proceso para `isProvider` y `workspaceId`.
// - Wire-stable: shape coincide con `ProviderMeEntity` (workspaceId, isProvider).
// - Reactividad GetX (`Rx`) para `Obx(() => ...)`.
//
// ENTERPRISE NOTES:
// - Acompaña a [SessionCapabilitiesStore]: ese expone capabilities[]; este
//   expone la otra señal canónica de routing post-bootstrap (`isProvider`).
// - Cuando llegue offline-cache de `/providers/me` (M2 del provider), este
//   store quedará intacto: la fuente es el repo, pero la UI sigue leyendo de
//   aquí.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProviderContextStore {
  /// `true` si el caller tiene `ProviderProfile` activo en el workspace
  /// resuelto. Se popula tras `GET /v1/providers/me`.
  final RxBool _isProvider = false.obs;

  /// UUID del workspace canónico devuelto por `/v1/providers/me`. Vacío
  /// hasta que el primer fetch resuelva.
  final RxString _workspaceId = ''.obs;

  /// Lectura reactiva: `true` si el caller es proveedor en el workspace
  /// activo.
  bool get isProvider => _isProvider.value;
  RxBool get isProviderRx => _isProvider;

  /// Workspace canónico resuelto por `/v1/providers/me`. Vacío hasta que el
  /// primer fetch complete (durante el splash).
  String get workspaceId => _workspaceId.value;
  RxString get workspaceIdRx => _workspaceId;

  /// `true` si el store ya recibió al menos una respuesta de `/me`.
  /// Útil para diferenciar "aún no sé" vs "sé que no es proveedor".
  bool get isResolved => _workspaceId.value.isNotEmpty;

  /// Reemplaza el snapshot. Idempotente — si los valores no cambian, no
  /// dispara notificación.
  void set({required bool isProvider, required String workspaceId}) {
    final wsChanged = _workspaceId.value != workspaceId;
    final ipChanged = _isProvider.value != isProvider;
    if (!wsChanged && !ipChanged) return;
    _workspaceId.value = workspaceId;
    _isProvider.value = isProvider;
    if (kDebugMode) {
      debugPrint('[ProviderContext] '
          'isProvider=$isProvider workspaceId=$workspaceId');
    }
  }

  /// Limpia el snapshot. Llamado en logout y en workspace switch.
  void clear() {
    if (!isResolved && !_isProvider.value) return;
    _workspaceId.value = '';
    _isProvider.value = false;
    if (kDebugMode) {
      debugPrint('[ProviderContext] cleared');
    }
  }
}
