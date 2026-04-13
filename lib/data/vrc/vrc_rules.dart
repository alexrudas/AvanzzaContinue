// ============================================================================
// lib/data/vrc/vrc_rules.dart
// VRC RULES — Data Layer / Reglas operativas puras
//
// QUÉ HACE:
// - Centraliza TODAS las reglas operativas del módulo VRC en funciones puras.
// - Determina bloqueo, revisión manual, degradación de UI y estado de vista.
// - Expone shouldBlockRegistration, shouldRequireManualReview, isDegradedForUi,
//   classifyViewState.
//
// QUÉ NO HACE:
// - No accede a red, Isar ni GetX.
// - No usa meta.sources como señal operativa (solo diagnóstico).
// - No contiene lógica de UI (colores, textos, widgets).
//
// PRINCIPIOS:
// - Fuente primaria: businessDecision.action + owner.runt.error + simit.summary.
// - meta.sources va al diagnóstico colapsable, NUNCA al motor de decisión.
// - Hardening ante businessDecision == null: postura conservadora (bloquear).
// - APPROVE + LOW + simit.summary == null → degraded (SIMIT ausente degrada).
//
// INVARIANTES:
// - shouldBlockRegistration(null) == true   (sin data → no podemos aprobar)
// - classifyViewState con ok==false → VrcViewState.failed
// - classifyViewState con data==null → VrcViewState.failed
// ============================================================================

import 'models/vrc_models.dart';

/// Estado de vista de la consulta VRC.
///
/// Representa el resultado TÉCNICO de la llamada HTTP, no la aprobación operativa.
/// La aprobación operativa se lee desde canProceedAutomatically en VrcController.
enum VrcViewState {
  /// Sin consulta activa.
  idle,

  /// Consulta en progreso.
  loading,

  /// Respuesta recibida y parseada correctamente (ok == true, data != null).
  /// No implica aprobación — puede haber bloqueo operativo (shouldBlockRegistration).
  success,

  /// Respuesta recibida pero información incompleta o parcial.
  /// Distinto de failed: el HTTP funcionó pero falta businessDecision, SIMIT o RUNT.
  degraded,

  /// Error técnico: ok == false, HTTP error, o parsing fallido.
  failed,

  /// Timeout superando los 120 segundos de espera del servidor.
  timeout,
}

/// Reglas operativas puras del módulo VRC Individual.
abstract final class VrcRules {
  // ── REGLA 1: Bloqueo de registro ──────────────────────────────────────────

  /// Retorna true si el registro del activo debe ser bloqueado.
  ///
  /// Criterios de bloqueo:
  /// - data es null → no se pudo determinar la situación del vehículo.
  /// - businessDecision es null → respuesta incoherente; postura conservadora.
  /// - action == 'REJECT' → el backend explícitamente rechaza el vehículo.
  static bool shouldBlockRegistration(VrcDataModel? data) {
    if (data == null) return true;
    final decision = data.businessDecision;
    if (decision == null) return true;
    return decision.action == 'REJECT';
  }

  // ── REGLA 2: Revisión manual ──────────────────────────────────────────────

  /// Retorna true si el caso debe escalarse a revisión manual humana.
  ///
  /// Criterios de revisión:
  /// - businessDecision es null → incertidumbre, revisar manualmente.
  /// - action == 'REVIEW' con riskLevel HIGH o UNKNOWN → riesgo elevado.
  ///
  /// NOTA: REVIEW + LOW o REVIEW + MEDIUM no impone revisión manual automática.
  static bool shouldRequireManualReview(VrcDataModel? data) {
    if (data == null) return true;
    final decision = data.businessDecision;
    if (decision == null) return true;
    if (decision.action != 'REVIEW') return false;
    final risk = decision.riskLevel;
    return risk == 'HIGH' || risk == 'UNKNOWN';
  }

  // ── REGLA 3: Degradación de UI ────────────────────────────────────────────

  /// Retorna true si la UI debe mostrar advertencia de información incompleta.
  ///
  /// Criterios de degradación (cualquiera basta):
  /// - businessDecision es null → respuesta recibida pero sin decisión.
  /// - action == 'UNKNOWN' → el backend no pudo clasificar.
  /// - owner.simit.summary es null → SIMIT no disponible.
  ///   (APPROVE + LOW sigue siendo degraded si SIMIT ausente)
  /// - owner.runt.error no null → RUNT persona falló.
  ///
  /// NO usa meta.sources. Los sources son solo diagnóstico.
  static bool isDegradedForUi(VrcDataModel? data) {
    if (data == null) return false; // null data → failed, no degraded
    final decision = data.businessDecision;
    if (decision == null) return true;
    if (decision.action == 'UNKNOWN') return true;
    // WARN: el backend indica riesgo pero no bloquea — se trata como degraded.
    if (decision.action == 'WARN') return true;
    if (data.owner?.simit?.summary == null) return true;
    if (data.owner?.runt?.error != null) return true;
    return false;
  }

  // ── REGLA 4: Clasificación del estado de vista ────────────────────────────

  /// Clasifica el resultado técnico de la consulta VRC en un [VrcViewState].
  ///
  /// Jerarquía de clasificación:
  /// 1. ok == false → failed
  /// 2. data == null → failed
  /// 3. shouldBlockRegistration → success (con señal operativa shouldBlock)
  /// 4. isDegradedForUi → degraded
  /// 5. default → success
  ///
  /// SEPARACIÓN IMPORTANTE:
  /// - [VrcViewState.success] significa éxito técnico, NO aprobación operativa.
  /// - La aprobación operativa se lee desde canProceedAutomatically en el controller.
  static VrcViewState classifyViewState(VrcResponseModel response) {
    if (!response.ok || response.data == null) {
      return VrcViewState.failed;
    }
    final data = response.data!;
    if (isDegradedForUi(data)) return VrcViewState.degraded;
    return VrcViewState.success;
  }
}
