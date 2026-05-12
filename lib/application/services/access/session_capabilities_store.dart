// ============================================================================
// lib/application/services/access/session_capabilities_store.dart
// SESSION CAPABILITIES STORE — Rx store de capabilities resueltas.
// ============================================================================
// QUÉ HACE:
// - Guarda la lista de capabilities canónicas (`provider.create`,
//   `vehicle_batch.circuit.read`, …) resueltas por GET /v1/access/me/context
//   o por el resultado de bootstrap.
// - Expone getter reactivo (`Rx`) para que widgets/controllers puedan
//   habilitar/ocultar UI sin hacer llamadas adicionales al backend.
//
// QUÉ NO HACE:
// - No persiste a disco (hoy). El contrato indica que capabilities son
//   derivables cada login → re-fetch al iniciar sesión es suficiente.
// - No decide UX. Los widgets preguntan `hasCapability(id)`; la policy de
//   "ocultar vs. disabled" es UX.
//
// PRINCIPIOS:
// - Fuente única de verdad de capabilities en el proceso.
// - Siempre consistente con el último context/bootstrap exitoso; en logout
//   queda vacío.
// - No acoplado a SessionContextController (ciclos de vida distintos).
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §9.2
//   (recomendado: cache local de capabilities).
// - Se coloca en `application/services/` para seguir el patrón del proyecto
//   (servicios cross-domain consumidos por presentation y data).
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SessionCapabilitiesStore {
  /// Lista reactiva de ids semánticos de capabilities.
  final RxList<String> _capabilities = <String>[].obs;

  /// Lectura inmutable. El consumer debe tratarlo como snapshot de sólo
  /// lectura; cambios se hacen vía `set` / `clear`.
  List<String> get capabilities => List.unmodifiable(_capabilities);

  /// Observable para `Obx(() => ...)` en widgets.
  RxList<String> get capabilitiesRx => _capabilities;

  /// `true` si la capability está presente. Comparación exacta (wire-name).
  bool hasCapability(String id) => _capabilities.contains(id);

  /// Reemplaza el contenido completo. Idempotente — si ya coincide, no
  /// dispara notificación.
  void set(List<String> capabilities) {
    final incoming = List<String>.from(capabilities);
    if (_sameContent(_capabilities, incoming)) return;
    _capabilities
      ..clear()
      ..addAll(incoming);
    if (kDebugMode) {
      debugPrint('[ACCESS] capabilities updated (${incoming.length})');
    }
  }

  /// Limpia la lista. Llamado en logout o cuando el backend indica
  /// `CONTACT_SUPPORT` (el caller no opera).
  void clear() {
    if (_capabilities.isEmpty) return;
    _capabilities.clear();
    if (kDebugMode) {
      debugPrint('[ACCESS] capabilities cleared');
    }
  }

  bool _sameContent(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
