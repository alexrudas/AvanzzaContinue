// ============================================================================
// lib/presentation/widgets/asset/portfolio_asset_operational_tile.dart
// PORTFOLIO ASSET OPERATIONAL TILE — Enterprise Ultra Pro Premium 2026
//
// QUÉ HACE:
// - Renderiza activos como tiles densos, escaneables y con alto contraste.
// - Implementa Pattern Matching exhaustivo de Dart 3.2+ (Zero Casts).
// - Soporta estados operativos complejos con codificación de color dinámica.
//
// MEJORAS 2026:
// - Semantic Logic: Colores basados en contraste dinámico (Dark/Light ready).
// - Perf: Optimización de jerarquía Material/Ink para evitar Overdraw.
// - UX: Identidad visual reforzada (Placa con fuente mono y tracking).
// - Mantenibilidad: Sub-widgets desacoplados con paso de tokens de tema.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';
import '../../viewmodels/asset/asset_summary_vm.dart';

/// Tile de activo de alto rendimiento para listas operativas.
class PortfolioAssetOperationalTile extends StatelessWidget {
  final AssetSummaryVM summary;
  final VoidCallback? onTap;

  const PortfolioAssetOperationalTile({
    super.key,
    required this.summary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Pattern matching limpio: elimina la necesidad de 'as VehicleSummaryVM'
    return switch (summary) {
      VehicleSummaryVM vm => _VehicleOperationalTile(vm: vm, onTap: onTap),
      RealEstateSummaryVM vm => _GenericOperationalTile(
          summary: vm,
          icon: Icons.home_outlined,
          subtitle: vm.propertyType,
          onTap: onTap,
        ),
      MachinerySummaryVM vm => _GenericOperationalTile(
          summary: vm,
          icon: Icons.construction_outlined,
          subtitle: vm.category,
          onTap: onTap,
        ),
      EquipmentSummaryVM vm => _GenericOperationalTile(
          summary: vm,
          icon: Icons.devices_outlined,
          subtitle: vm.category,
          onTap: onTap,
        ),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE OPERATIONAL TILE
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleOperationalTile extends StatelessWidget {
  final VehicleSummaryVM vm;
  final VoidCallback? onTap;

  const _VehicleOperationalTile({required this.vm, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: cs.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 4,
            ),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                _PlateChip(plate: vm.plate),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${vm.brand} ${vm.model}'.trim(),
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (vm.modelYear?.isNotEmpty ?? false)
                        Text(
                          vm.modelYear!,
                          style: textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (vm.ownerName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: _OwnerRow(
                            name: vm.ownerName!,
                            document: vm.ownerDocument,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _AssetStateBadge(stateLabel: vm.stateLabel),
                    const SizedBox(height: 6),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GENERIC OPERATIONAL TILE
// ─────────────────────────────────────────────────────────────────────────────

class _GenericOperationalTile extends StatelessWidget {
  final AssetSummaryVM summary;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onTap;

  const _GenericOperationalTile({
    required this.summary,
    required this.icon,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: cs.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, color: cs.primary, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.displayTitle,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle?.isNotEmpty ?? false)
                        Text(
                          subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      const SizedBox(height: 6),
                      _AssetStateBadge(stateLabel: summary.stateLabel),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPONENTES DE APOYO REFINADOS
// ─────────────────────────────────────────────────────────────────────────────

class _PlateChip extends StatelessWidget {
  final String plate;

  const _PlateChip({required this.plate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: cs.secondary.withValues(alpha: 0.2)),
      ),
      child: Text(
        plate.toUpperCase(),
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w900,
          fontFamily: 'RobotoMono', // Esencial para legibilidad de placas
          letterSpacing: 1.2,
          color: cs.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _OwnerRow extends StatelessWidget {
  final String name;
  final String? document;

  const _OwnerRow({required this.name, this.document});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_outline_rounded,
            size: 12, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            document != null ? '$name • $document' : name,
            style: textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _AssetStateBadge extends StatelessWidget {
  final String stateLabel;

  const _AssetStateBadge({required this.stateLabel});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final label = stateLabel.toLowerCase();

    // Lógica de color semántica Enterprise 2026
    final (Color bgColor, Color fgColor) = switch (label) {
      String s when s.contains('activo') || s.contains('verificado') => (
          const Color(0xFFE8F5E9),
          const Color(0xFF2E7D32)
        ),
      String s when s.contains('pendiente') => (
          const Color(0xFFFFF8E1),
          const Color(0xFFF57F17)
        ),
      String s when s.contains('archivado') || s.contains('error') => (
          cs.errorContainer,
          cs.onErrorContainer
        ),
      _ => (cs.surfaceContainerHighest, cs.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: fgColor.withValues(alpha: 0.1)),
      ),
      child: Text(
        stateLabel.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.w900,
          fontSize: 9,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
