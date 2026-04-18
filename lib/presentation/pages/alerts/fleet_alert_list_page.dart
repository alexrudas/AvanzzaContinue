// ============================================================================
// lib/presentation/pages/alerts/fleet_alert_list_page.dart
// FLEET ALERT LIST PAGE — Lista de alertas agrupadas por vehículo (Nivel 1)
//
// QUÉ HACE:
// - Muestra 1 tarjeta por vehículo (no por alerta), agrupadas y ordenadas
//   por riesgo descendente (HIGH primero).
// - Incluye resumen global arriba: total de vehículos con alertas, críticas,
//   por vencer y riesgo global.
// - Punto de entrada desde AdminHome (reemplaza la navegación a AlertCenterPage).
// - Nivel 1 del flujo de alertas de flota.
//
// QUÉ NO HACE:
// - No muestra alertas individuales — eso es Nivel 2 y Nivel 3.
// - No tiene filtros — ver AlertCenterPage para el flujo de oportunidades.
// - No re-evalúa alertas.
//
// PRINCIPIOS:
// - GetView<FleetAlertController>: un solo controller, cero Get.find en UI.
// - Obx solo donde hay estado reactivo.
// - Pull-to-refresh invalida cache y recarga.
// - Lista vacía con empty state honesto.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alerts/viewmodels/fleet_alert_group_vm.dart';
import '../../alerts/widgets/alert_doc_status_badge.dart';
import '../../controllers/alerts/fleet_alert_controller.dart';
import '../../../routes/app_routes.dart';

class FleetAlertListPage extends GetView<FleetAlertController> {
  const FleetAlertListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Alertas de la flota'),
        centerTitle: false,
        actions: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: controller.refreshGroups,
              tooltip: 'Actualizar',
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.groups.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.groups.isEmpty) {
          return _EmptyState(onRefresh: controller.refreshGroups);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshGroups,
          child: CustomScrollView(
            slivers: [
              // ── Resumen global ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: _FleetSummaryHeader(groups: controller.groups),
              ),

              // ── Lista de vehículos ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _FleetVehicleCard(
                      group: controller.groups[i],
                    ),
                    childCount: controller.groups.length,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESUMEN GLOBAL (Ajuste 1)
// ─────────────────────────────────────────────────────────────────────────────

class _FleetSummaryHeader extends StatelessWidget {
  final List<FleetAlertGroupVm> groups;

  const _FleetSummaryHeader({required this.groups});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final totalVehiculos = groups.length;
    final totalCriticas =
        groups.fold(0, (acc, g) => acc + g.criticasCount);
    final totalPorVencer =
        groups.fold(0, (acc, g) => acc + g.porVencerCount);

    final riesgoGlobal = totalCriticas > 0
        ? 'Alto'
        : totalPorVencer > 0
            ? 'Medio'
            : 'Bajo';

    final riesgoColor = riskLevelColor(riesgoGlobal, colors);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Resumen de la flota',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: riesgoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined,
                        size: 14, color: riesgoColor),
                    const SizedBox(width: 4),
                    Text(
                      'Riesgo $riesgoGlobal',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: riesgoColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SummaryMetric(
                value: '$totalVehiculos',
                label: totalVehiculos == 1 ? 'vehículo' : 'vehículos',
                color: colors.onSurface,
              ),
              const SizedBox(width: 16),
              if (totalCriticas > 0)
                _SummaryMetric(
                  value: '$totalCriticas',
                  label: totalCriticas == 1 ? 'crítica' : 'críticas',
                  color: colors.error,
                ),
              if (totalCriticas > 0 && totalPorVencer > 0)
                const SizedBox(width: 16),
              if (totalPorVencer > 0)
                _SummaryMetric(
                  value: '$totalPorVencer',
                  label: 'por vencer',
                  color: const Color(0xFFF59E0B),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TARJETA DE VEHÍCULO
// ─────────────────────────────────────────────────────────────────────────────

class _FleetVehicleCard extends StatelessWidget {
  final FleetAlertGroupVm group;

  const _FleetVehicleCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final rColor = riskLevelColor(group.riskLevel.label, colors);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Get.toNamed(
            Routes.fleetAlertVehicle,
            arguments: group,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Barra lateral de riesgo
                Container(
                  width: 4,
                  height: 52,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: rColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila: placa + badge de total
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.placa,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  rColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${group.totalCount}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: rColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Subtítulo: marca/modelo
                      if (group.vehicleLabel != null)
                        Text(
                          group.vehicleLabel!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),

                      const SizedBox(height: 6),

                      // Chips de conteo
                      Row(
                        children: [
                          if (group.criticasCount > 0)
                            AlertCountChip(
                              count: group.criticasCount,
                              label:
                                  'crítica${group.criticasCount == 1 ? '' : 's'}',
                              color: colors.error,
                            ),
                          if (group.criticasCount > 0 &&
                              group.porVencerCount > 0)
                            const SizedBox(width: 6),
                          if (group.porVencerCount > 0)
                            AlertCountChip(
                              count: group.porVencerCount,
                              label: 'por vencer',
                              color: const Color(0xFFF59E0B),
                            ),
                          if (group.criticasCount == 0 &&
                              group.porVencerCount == 0)
                            AlertCountChip(
                              count: group.totalCount,
                              label: 'sin urgencia',
                              color: colors.primary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chevron
                Icon(
                  Icons.chevron_right_rounded,
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

// _CountChip movido a alert_doc_status_badge.dart como AlertCountChip.

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 64,
                  color: colors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sin alertas activas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'La flota está al día.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
