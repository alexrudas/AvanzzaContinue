// ============================================================================
// lib/domain/entities/alerts/alert_evidence_keys.dart
// ALERT EVIDENCE KEYS — Keys canónicas para evidenceRefs de DomainAlert
//
// QUÉ HACE:
// - Centraliza todas las keys permitidas en cada entrada de DomainAlert.evidenceRefs.
// - Garantiza consistencia entre productores (evaluadores) y capas consumidoras.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No define los valores — solo las keys.
// - No valida el tipo del valor.
//
// PRINCIPIOS:
// - REGLA: nadie puede usar keys de evidenceRefs que no estén aquí.
// - Toda key nueva requiere agregarse aquí primero.
// - sourceId es el identificador principal de la evidencia de cada entrada.
//   Su uso en el pipeline de dedupe es responsabilidad del productor.
// - Los valores asociados a estas keys deben ser serializables (String, null).
//   No insertar objetos arbitrarios ni instancias no serializables.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Estándar canónico v1. Ver ALERTS_SYSTEM_V4.md §7.2.
// MOVIDO (2026-03): de lib/core/alerts/support/ → lib/domain/entities/alerts/
//   Razón: AlertEvidenceKeys es contrato de dominio puro (keys de DomainAlert.evidenceRefs).
//   Domain no puede importar core; moverlo aquí elimina la violación de dependencias.
// ============================================================================

/// Keys canónicas para cada entrada de [DomainAlert.evidenceRefs].
///
/// Uso:
/// ```dart
/// evidenceRefs: [{
///   AlertEvidenceKeys.sourceType: 'insurance_policy',
///   AlertEvidenceKeys.sourceId: policy.id,
///   AlertEvidenceKeys.sourceCollection: 'insurance_policies',
///   AlertEvidenceKeys.documentId: policy.policyId,
/// }]
/// ```
abstract final class AlertEvidenceKeys {
  AlertEvidenceKeys._();

  /// Tipo de fuente que respalda la alerta.
  ///
  /// Tipo: String.
  /// Valores esperados en V1: 'insurance_policy', 'rtm_doc', 'legal_record'.
  static const String sourceType = 'sourceType';

  /// ID de la entidad fuente (PK en Isar/Firestore).
  ///
  /// Tipo: String.
  static const String sourceId = 'sourceId';

  /// Colección Firestore o colección/namespace local equivalente donde vive el documento fuente.
  ///
  /// Tipo: String.
  /// Ejemplo: 'insurance_policies', 'assets'.
  static const String sourceCollection = 'sourceCollection';

  /// ID del documento específico (puede ser diferente a sourceId).
  ///
  /// Tipo: String.
  /// Ejemplo: policyId UUID de InsurancePolicyEntity.
  static const String documentId = 'documentId';

  /// Referencia externa opcional (RUNT, SIMIT, número de póliza).
  ///
  /// Tipo: String? (puede ser null).
  static const String externalRef = 'externalRef';
}
