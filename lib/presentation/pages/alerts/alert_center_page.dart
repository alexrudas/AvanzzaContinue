// ============================================================================
// lib/presentation/pages/alerts/alert_center_page.dart
// ALERT CENTER PAGE — Vista global de alertas de la flota
//
// QUÉ HACE:
// - Muestra TODAS las alertas activas de la org, sin filtro de promoción.
// - Provee filtros por categoría: Todas | Críticas | Documentos | Legal.
//   Fase 6 (Mantenimiento, Contabilidad, Compras) declarados pero disabled.
// - Prioriza visualmente las alertas CRITICAL con sección separada.
// - Muestra empty state honesto cuando no hay alertas.
// - Permite pull-to-refresh.
// - Cada alerta tiene CTA navegable via actionLabel / actionRoute.
//
// QUÉ NO HACE:
// - No evalúa alertas — consume AlertCenterController.
// - No filtra con reglas de negocio — solo filtra por categoría UI.
// - No construye AlertCardVm manualmente.
//
// PRINCIPIOS:
// - GetView<AlertCenterController>: un solo controller, cero Get.find en UI.
// - Obx solo donde hay estado reactivo.
// - Priorización visual refuerza el sort canónico: CRITICAL siempre arriba.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 5.5 — Ver ALERTS_SYSTEM_V4.md §18 Fase 5.5.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/alerts/alert_severity.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';
import '../../controllers/alerts/alert_center_controller.dart';

class AlertCenterPage extends GetView<AlertCenterController> {
  const AlertCenterPage({super.key});

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
              onPressed: controller.refreshAlerts,
              tooltip: 'Actualizar',
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // ── Chips de filtro ──────────────────────────────────────────────
          _FilterChipsRow(controller: controller),
          const Divider(height: 1),
          // ── Contenido principal ──────────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshAlerts,
              child: Obx(() {
                if (controller.isLoading.value && controller.alerts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = controller.filteredAlerts;

                if (items.isEmpty) {
                  return _EmptyState(
                    filter: controller.activeFilter.value,
                    hasAnyAlerts: controller.alerts.isNotEmpty,
                  );
                }

                return _AlertList(alerts: items);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER CHIPS ROW
// ─────────────────────────────────────────────────────────────────────────────

class _FilterChipsRow extends StatelessWidget {
  final AlertCenterController controller;
  const _FilterChipsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: AlertCenterFilter.values
            .map((f) => Obx(() => _FilterChip(
                  filter: f,
                  isSelected: controller.activeFilter.value == f,
                  onTap: () => controller.setFilter(f),
                )))
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final AlertCenterFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = filter.isEnabledInV1;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter.label),
        selected: isSelected,
        onSelected: enabled ? (_) => onTap() : null,
        backgroundColor:
            enabled ? null : colors.surfaceContainerHighest.withValues(alpha: 0.5),
        labelStyle: TextStyle(
          color: !enabled ? colors.onSurface.withValues(alpha: 0.38) : null,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ALERT LIST — con sección CRITICAL separada
// ─────────────────────────────────────────────────────────────────────────────

class _AlertList extends StatelessWidget {
  final List<AlertCardVm> alerts;
  const _AlertList({required this.alerts});

  @override
  Widget build(BuildContext context) {
    final criticals = alerts
        .where((a) => a.severity == AlertSeverity.critical)
        .toList();
    final rest =
        alerts.where((a) => a.severity != AlertSeverity.critical).toList();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Sección CRITICAL — priorización visual obligatoria
        if (criticals.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _SectionHeader(
              label: 'Críticas',
              color: Theme.of(context).colorScheme.error,
              icon: Icons.warning_rounded,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _AlertCard(vm: criticals[i]),
              childCount: criticals.length,
            ),
          ),
        ],
        // Sección resto
        if (rest.isNotEmpty) ...[
          if (criticals.isNotEmpty)
            SliverToBoxAdapter(
              child: _SectionHeader(
                label: 'Otras alertas',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _AlertCard(vm: rest[i]),
              childCount: rest.length,
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _SectionHeader({
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
          ],
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ALERT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _AlertCard extends StatelessWidget {
  final AlertCardVm vm;
  const _AlertCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final severityColor = _colorForSeverity(vm.severity, colors);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador de severidad
              Container(
                width: 4,
                height: 44,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identidad del activo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            vm.assetPrimaryLabel,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.onSurface,
                                ),
                          ),
                        ),
                        if (vm.assetSecondaryLabel != null) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              vm.assetSecondaryLabel!,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (vm.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        vm.subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              // CTA de acción
              if (vm.actionLabel != null && vm.actionRoute != null)
                TextButton(
                  onPressed: () => Get.toNamed(
                    vm.actionRoute!,
                    arguments: {
                      'assetId': vm.sourceEntityId,
                      'primaryLabel': vm.assetPrimaryLabel,
                      'secondaryLabel': vm.assetSecondaryLabel,
                    },
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    vm.actionLabel!,
                    style: TextStyle(fontSize: 12, color: severityColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorForSeverity(AlertSeverity severity, ColorScheme colors) =>
      switch (severity) {
        AlertSeverity.critical => colors.error,
        AlertSeverity.high => const Color(0xFFF97316), // naranja
        AlertSeverity.medium => const Color(0xFFF59E0B), // ámbar
        AlertSeverity.low => colors.primary,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final AlertCenterFilter filter;
  final bool hasAnyAlerts;

  const _EmptyState({
    required this.filter,
    required this.hasAnyAlerts,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Si tiene alertas pero el filtro no devuelve nada
    final isFilterEmpty = hasAnyAlerts;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFilterEmpty
                    ? Icons.filter_list_off_rounded
                    : Icons.check_circle_outline_rounded,
                size: 64,
                color: isFilterEmpty
                    ? colors.onSurfaceVariant
                    : const Color(0xFF22C55E),
              ),
              const SizedBox(height: 16),
              Text(
                isFilterEmpty
                    ? 'Sin alertas en este filtro'
                    : 'No hay alertas activas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  isFilterEmpty
                      ? 'Prueba con otro filtro para ver más alertas.'
                      : 'No se detectaron vencimientos ni bloqueos con la información disponible.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ),
              if (!isFilterEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => Get.toNamed('/assets'),
                      child: const Text('Revisar activos'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
