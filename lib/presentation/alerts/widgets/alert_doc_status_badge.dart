// ============================================================================
// lib/presentation/alerts/widgets/alert_doc_status_badge.dart
// ALERT DOC STATUS BADGE — Widgets compartidos del flujo de alertas de flota
//
// QUÉ HACE:
// - AlertDocStatusBadge: badge de estado documental (VENCIDO, POR VENCER, etc.)
// - AlertCountChip: chip de conteo compartido entre Nivel 1 y Nivel 2 del flujo.
// - Helpers de color: severityColor, riskLevelColor.
//
// QUÉ NO HACE:
// - No renderiza nada si status == AlertDocStatus.unknown.
// - No infiere estado desde strings — consume enums directamente.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Extraído de alert_center_page.dart para reutilización
//   en el flujo de 3 niveles de alertas de flota.
// ACTUALIZADO (2026-04): AlertCountChip movido aquí desde páginas Nivel 1/2
//   para eliminar duplicación.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../domain/entities/alerts/alert_severity.dart';
import '../viewmodels/alert_doc_status.dart';

/// Badge de estado documental/legal.
///
/// Consume [AlertDocStatus] directamente — no infiere estado desde strings.
/// No renderiza nada cuando [status] == [AlertDocStatus.unknown].
class AlertDocStatusBadge extends StatelessWidget {
  final AlertDocStatus status;

  const AlertDocStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == AlertDocStatus.unknown) return const SizedBox.shrink();
    final (label, color) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  static (String, Color) _resolve(AlertDocStatus status) => switch (status) {
        AlertDocStatus.expired => ('VENCIDO', const Color(0xFFEF4444)),
        AlertDocStatus.dueSoon => ('POR VENCER', const Color(0xFFF59E0B)),
        AlertDocStatus.missing => ('AUSENTE', const Color(0xFFF97316)),
        AlertDocStatus.exempt => ('EXENTO', const Color(0xFF22C55E)),
        AlertDocStatus.restricted => (
            'CON RESTRICCIÓN',
            const Color(0xFFB91C1C)
          ),
        AlertDocStatus.opportunity => (
            'RIESGO PATRIMONIAL',
            const Color(0xFF6366F1)
          ),
        AlertDocStatus.unknown => ('', Colors.transparent),
      };
}

/// Retorna el color asociado a [severity] del [ColorScheme] activo.
///
/// Utilidad compartida para las páginas del flujo de flota.
Color severityColor(AlertSeverity severity, ColorScheme colors) =>
    switch (severity) {
      AlertSeverity.critical => colors.error,
      AlertSeverity.high => const Color(0xFFF97316),
      AlertSeverity.medium => const Color(0xFFF59E0B),
      AlertSeverity.low => colors.primary,
    };

/// Retorna el color asociado a un nivel de riesgo por string label.
///
/// Usado por FleetAlertListPage para la barra lateral de las tarjetas.
/// Recibe el label del FleetRiskLevel ('Alto', 'Medio', 'Bajo').
Color riskLevelColor(String riskLabel, ColorScheme colors) =>
    switch (riskLabel) {
      'Alto' => colors.error,
      'Medio' => const Color(0xFFF97316),
      _ => colors.primary,
    };

/// Chip de conteo para resúmenes de alertas.
///
/// Compartido entre FleetAlertListPage (Nivel 1) y FleetVehicleAlertsPage
/// (Nivel 2). Fuente única para evitar divergencia de estilo entre niveles.
class AlertCountChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const AlertCountChip({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$count $label',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
