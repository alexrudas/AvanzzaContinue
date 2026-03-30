// ============================================================================
// lib/core/alerts/support/alert_sort.dart
// MOVIDO — Este archivo ya no vive aquí.
//
// Nueva ubicación canónica:
//   lib/domain/services/alerts/support/alert_sort.dart
//
// Razón del movimiento:
//   sortAlerts solo depende de domain (AlertCode, AlertFactKeys, DomainAlert).
//   El orquestador vive en domain y no puede importar core.
//   Ver ALERTS_SYSTEM_V4.md §12.2 (actualizado 2026-03).
// ============================================================================

export '../../../domain/services/alerts/support/alert_sort.dart';
