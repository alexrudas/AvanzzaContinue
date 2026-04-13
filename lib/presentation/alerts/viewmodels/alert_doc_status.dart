// ============================================================================
// lib/presentation/alerts/viewmodels/alert_doc_status.dart
// ALERT DOC STATUS — Estado documental/legal derivado para la UI
//
// QUÉ HACE:
// - Define AlertDocStatus: estado estructurado derivado desde AlertCode.
// - Es el contrato entre DomainAlertMapper y los widgets de alertas para
//   el badge de estado documental.
// - Elimina la necesidad de inferir estado desde strings en la UI.
//
// QUÉ NO HACE:
// - No contiene lógica de evaluación ni de negocio.
// - No depende de package:flutter (Dart puro).
// - No reemplaza AlertSeverity (canal ortogonal: severidad ≠ estado documental).
//
// PRINCIPIOS:
// - Fuente única de verdad: producido exclusivamente por DomainAlertMapper.
// - Un código → un estado, sin ambigüedad.
// - `unknown` existe para códigos reservados V1: la UI puede ocultarlo o
//   renderizar un badge neutro sin lanzar excepciones.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 5.5 — corrige inferencia de estado desde strings
//   en alert_center_page.dart. Ver ALERTS_SYSTEM_V4.md §18.
// ============================================================================

/// Estado documental/legal del activo relacionado con la alerta.
///
/// Derivado exclusivamente desde [AlertCode] por [DomainAlertMapper].
/// Consumido por widgets de alertas para el badge de estado — no construir
/// manualmente en UI.
///
/// Canal ortogonal a [AlertSeverity]:
/// - [AlertSeverity] → urgencia operativa (color de barra lateral)
/// - [AlertDocStatus] → estado del documento/cobertura (badge textual)
enum AlertDocStatus {
  /// Documento o póliza expirada — requiere renovación inmediata.
  /// Ejemplos: SOAT vencido, RTM vencida, RC expirada.
  expired,

  /// Documento próximo a vencer — dentro de la ventana de alerta configurada.
  /// Ejemplos: SOAT por vencer, RTM por vencer.
  dueSoon,

  /// Cobertura o documento nunca contratado/registrado.
  /// Semánticamente distinto de expired: no existe, no expiró.
  /// Ejemplos: RC contractual ausente, RC extracontractual ausente.
  missing,

  /// Exento por clasificación legal o regulatoria.
  /// Ejemplos: vehículo exento de RTM por cilindraje.
  exempt,

  /// Con restricción jurídica activa (limitación de dominio, embargo).
  /// Ejemplos: limitación jurídica activa, embargo registrado.
  restricted,

  /// Señal de oportunidad comercial — no es alerta de cumplimiento.
  /// Ejemplos: RC extracontractual recomendada (alertKind=opportunity).
  opportunity,

  /// Estado no determinado — códigos reservados para fases futuras.
  /// La UI puede optar por ocultar el badge cuando el estado es unknown.
  unknown,
}
