// ============================================================================
// lib/presentation/pages/alerts/fleet_vehicle_alerts_page.dart
// FLEET VEHICLE ALERTS PAGE — Detalle de alertas de un vehículo (Nivel 2)
//
// QUÉ HACE:
// - Muestra todas las alertas de un activo agrupadas en secciones:
//   Críticas | Por vencer | Otras.
// - Nivel 2 del flujo de alertas de flota.
// - Recibe FleetAlertGroupVm por Get.arguments — sin controller propio.
// - Cada alerta navega al Nivel 3 (FleetAlertDetailPage).
//
// QUÉ NO HACE:
// - No re-evalúa ni re-fetcha datos — fuente única de verdad desde Nivel 1.
// - No renderiza secciones vacías.
// - No tiene controller — es stateless puro.
//
// PRINCIPIOS:
// - Guard al inicio del build: redirige a /alerts/fleet si arguments inválido.
// - Secciones derivadas de AlertSeverity y AlertDocStatus — no desde strings.
// - Las alertas llegan ya ordenadas (FleetAlertGrouper aplicó sort intra-grupo).
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/alerts/alert_severity.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';
import '../../alerts/viewmodels/alert_doc_status.dart';
import '../../alerts/viewmodels/fleet_alert_group_vm.dart';
import '../../alerts/widgets/alert_doc_status_badge.dart';
import '../../../routes/app_routes.dart';

class FleetVehicleAlertsPage extends StatelessWidget {
  const FleetVehicleAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Guard: si arguments no es FleetAlertGroupVm, el stack está roto.
    final args = Get.arguments;
    if (args is! FleetAlertGroupVm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.fleetAlerts);
      });
      return const SizedBox.shrink();
    }

    final group = args;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Clasificar alertas en secciones (el sort intra-grupo ya fue aplicado).
    final criticals = group.alerts
        .where((a) => a.severity == AlertSeverity.critical)
        .toList();
    final dueSoon = group.alerts
        .where(
          (a) =>
              a.docStatus == AlertDocStatus.dueSoon &&
              a.severity != AlertSeverity.critical,
        )
        .toList();
    final others = group.alerts
        .where(
          (a) =>
              a.severity != AlertSeverity.critical &&
              a.docStatus != AlertDocStatus.dueSoon,
        )
        .toList();

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.placa,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (group.vehicleLabel != null)
                  Text(
                    group.vehicleLabel!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            centerTitle: false,
            floating: true,
          ),

          // ── Resumen compacto ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _VehicleSummaryRow(group: group),
          ),

          // ── Sección Críticas ──────────────────────────────────────────────
          if (criticals.isNotEmpty) ...[
            _SliverSectionHeader(
              label: 'Críticas',
              icon: Icons.warning_rounded,
              color: colors.error,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _AlertRowItem(
                  vm: criticals[i],
                  onTap: () => Get.toNamed(
                    Routes.fleetAlertDetail,
                    arguments: criticals[i],
                  ),
                ),
                childCount: criticals.length,
              ),
            ),
          ],

          // ── Sección Por vencer ────────────────────────────────────────────
          if (dueSoon.isNotEmpty) ...[
            _SliverSectionHeader(
              label: 'Por vencer',
              icon: Icons.schedule_rounded,
              color: const Color(0xFFF59E0B),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _AlertRowItem(
                  vm: dueSoon[i],
                  onTap: () => Get.toNamed(
                    Routes.fleetAlertDetail,
                    arguments: dueSoon[i],
                  ),
                ),
                childCount: dueSoon.length,
              ),
            ),
          ],

          // ── Sección Otras ─────────────────────────────────────────────────
          if (others.isNotEmpty) ...[
            _SliverSectionHeader(
              label: 'Otras',
              icon: Icons.info_outline_rounded,
              color: colors.onSurfaceVariant,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _AlertRowItem(
                  vm: others[i],
                  onTap: () => Get.toNamed(
                    Routes.fleetAlertDetail,
                    arguments: others[i],
                  ),
                ),
                childCount: others.length,
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _VehicleSummaryRow extends StatelessWidget {
  final FleetAlertGroupVm group;

  const _VehicleSummaryRow({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Text(
            '${group.totalCount} ${group.totalCount == 1 ? 'alerta' : 'alertas'}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          if (group.criticasCount > 0) ...[
            const SizedBox(width: 12),
            AlertCountChip(
              count: group.criticasCount,
              label: 'crítica${group.criticasCount == 1 ? '' : 's'}',
              color: colors.error,
            ),
          ],
          if (group.porVencerCount > 0) ...[
            const SizedBox(width: 8),
            AlertCountChip(
              count: group.porVencerCount,
              label: 'por vencer',
              color: const Color(0xFFF59E0B),
            ),
          ],
        ],
      ),
    );
  }
}

// _CountChip movido a alert_doc_status_badge.dart como AlertCountChip.

// ─────────────────────────────────────────────────────────────────────────────

class _SliverSectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SliverSectionHeader({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AlertRowItem extends StatelessWidget {
  final AlertCardVm vm;
  final VoidCallback onTap;

  const _AlertRowItem({required this.vm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final sColor = severityColor(vm.severity, colors);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Barra de severidad
                Container(
                  width: 3,
                  height: 40,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: sColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vm.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AlertDocStatusBadge(status: vm.docStatus),
                        ],
                      ),
                      if (vm.subtitle != null)
                        Text(
                          vm.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
