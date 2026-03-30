// ============================================================================
// lib/core/alerts/support/alert_dedupe.dart
// MOVIDO — Este archivo ya no vive aquí.
//
// Nueva ubicación canónica:
//   lib/domain/services/alerts/support/alert_dedupe.dart
//
// Razón del movimiento:
//   dedupeAlerts solo depende de DomainAlert (domain puro).
//   El orquestador vive en domain y no puede importar core.
//   Ver ALERTS_SYSTEM_V4.md §12.1 (actualizado 2026-03).
// ============================================================================

export '../../../domain/services/alerts/support/alert_dedupe.dart';
