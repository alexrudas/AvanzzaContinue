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
import '../../alerts/viewmodels/alert_doc_status.dart';
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
        backgroundColor: enabled
            ? null
            : colors.surfaceContainerHighest.withValues(alpha: 0.5),
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
    final criticals =
        alerts.where((a) => a.severity == AlertSeverity.critical).toList();
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
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (vm.actionRoute != null)
              ? () => Get.toNamed(
                    vm.actionRoute!,
                    arguments: {
                      'assetId': vm.sourceEntityId,
                      'primaryLabel': vm.assetPrimaryLabel,
                      'secondaryLabel': vm.assetSecondaryLabel,
                    },
                  )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de severidad (SE MANTIENE)
                Container(
                  width: 4,
                  height: 56,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Contenido principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ───────── HEADER (PLACA + BADGE ESTADO) ─────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Placa (IDENTIDAD PRINCIPAL)
                          Expanded(
                            child: Text(
                              vm.assetPrimaryLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),

                          // Badge de estado documental.
                          // Ocultar cuando el estado no aporta información
                          // accionable (unknown).
                          if (vm.docStatus != AlertDocStatus.unknown)
                            _DocStatusBadge(status: vm.docStatus),
                        ],
                      ),

                      // Marca + modelo
                      if (vm.assetSecondaryLabel != null) ...[
                        Text(
                          vm.assetSecondaryLabel!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                        ),
                      ],

                      const SizedBox(height: 6),

                      // Título alerta
                      Text(
                        vm.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),

                      // Subtítulo (tiempo / detalle)
                      if (vm.subtitle != null) ...[
                        Text(
                          vm.subtitle!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
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
// DOC STATUS BADGE
// ─────────────────────────────────────────────────────────────────────────────

/// Badge de estado documental/legal.
///
/// Consume [AlertDocStatus] directamente — no infiere estado desde strings.
/// Solo se renderiza cuando [status] != [AlertDocStatus.unknown].
class _DocStatusBadge extends StatelessWidget {
  final AlertDocStatus status;
  const _DocStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _resolve(status);
    return Container(
      margin: const EdgeInsets.only(left: 8),
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
