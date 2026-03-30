// ============================================================================
// lib/core/alerts/support/alert_evidence_keys.dart
// MOVIDO — Este archivo ya no vive aquí.
//
// Nueva ubicación canónica:
//   lib/domain/entities/alerts/alert_evidence_keys.dart
//
// Razón del movimiento:
//   AlertEvidenceKeys es contrato de dominio puro (keys de DomainAlert.evidenceRefs).
//   Domain no puede importar core; ubicarlo en domain elimina la violación
//   de dependencias. Ver ALERTS_SYSTEM_V4.md §7.2 (actualizado 2026-03).
//
// Si ves imports apuntando a esta ruta, actualízalos a:
//   import 'package:avanzza/domain/entities/alerts/alert_evidence_keys.dart';
// ============================================================================

export '../../../domain/entities/alerts/alert_evidence_keys.dart';
