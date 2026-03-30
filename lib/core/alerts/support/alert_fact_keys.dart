// ============================================================================
// lib/core/alerts/support/alert_fact_keys.dart
// MOVIDO — Este archivo ya no vive aquí.
//
// Nueva ubicación canónica:
//   lib/domain/entities/alerts/alert_fact_keys.dart
//
// Razón del movimiento:
//   AlertFactKeys es contrato de dominio puro (keys de DomainAlert.facts).
//   Domain no puede importar core; ubicarlo en domain elimina la violación
//   de dependencias. Ver ALERTS_SYSTEM_V4.md §7.1 (actualizado 2026-03).
//
// Si ves imports apuntando a esta ruta, actualízalos a:
//   import 'package:avanzza/domain/entities/alerts/alert_fact_keys.dart';
// ============================================================================

export '../../../domain/entities/alerts/alert_fact_keys.dart';
