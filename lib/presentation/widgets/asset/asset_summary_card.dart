// ============================================================================
// lib/presentation/widgets/asset/asset_summary_card.dart
// ASSET SUMMARY CARD — Tarjeta de resumen de activo tipada
//
// QUÉ HACE:
// - Renderiza el ViewModel de resumen correcto según el tipo de activo.
// - Para vehículos: envuelve VehicleSummaryWidget en una Card consistente.
// - Para otros tipos: muestra un placeholder funcional con icono y datos básicos.
// - Expone onTap para navegar al detalle del activo.
//
// QUÉ NO HACE:
// - No modifica VehicleSummaryWidget ni PlateWidget.
// - No contiene lógica de negocio ni accede a repositorios.
// - No conoce la navegación (el llamador pasa onTap).
//
// PRINCIPIOS:
// - StatelessWidget puro: sin estado interno.
// - Pattern matching exhaustivo sobre AssetSummaryVM (sealed class).
// - Consistencia visual: Card con borderRadius=12 alineado con el design system.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): parte del Asset Summary System.
// ============================================================================

import 'package:flutter/material.dart';

import 'vehicle/vehicle_summary_widget.dart';
import '../../viewmodels/asset/asset_summary_vm.dart';

/// Tarjeta de resumen de activo reutilizable.
///
/// Renderiza el ViewModel apropiado según el tipo:
///   [VehicleSummaryVM]      → [VehicleSummaryWidget] envuelto en Card
///   [RealEstateSummaryVM]   → placeholder de inmueble
///   [MachinerySummaryVM]    → placeholder de maquinaria
///   [EquipmentSummaryVM]    → placeholder de equipo
///
/// El llamador es responsable de pasar [onTap] para navegación.
class AssetSummaryCard extends StatelessWidget {
  /// ViewModel del activo a renderizar.
  final AssetSummaryVM summary;

  /// Callback ejecutado al tocar la tarjeta (navegación al detalle).
  final VoidCallback? onTap;

  const AssetSummaryCard({
    super.key,
    required this.summary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return switch (summary) {
      VehicleSummaryVM() => _VehicleCard(
          vm: summary as VehicleSummaryVM,
          onTap: onTap,
        ),
      RealEstateSummaryVM() => _PlaceholderCard(
          summary: summary,
          icon: Icons.home_outlined,
          subtitle: (summary as RealEstateSummaryVM).propertyType,
          onTap: onTap,
        ),
      MachinerySummaryVM() => _PlaceholderCard(
          summary: summary,
          icon: Icons.construction_outlined,
          subtitle: (summary as MachinerySummaryVM).category,
          onTap: onTap,
        ),
      EquipmentSummaryVM() => _PlaceholderCard(
          summary: summary,
          icon: Icons.devices_outlined,
          subtitle: (summary as EquipmentSummaryVM).category,
          onTap: onTap,
        ),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE CARD — Envuelve VehicleSummaryWidget en Card consistente
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final VehicleSummaryVM vm;
  final VoidCallback? onTap;

  const _VehicleCard({required this.vm, this.onTap});

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(12));

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: radius),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: ClipRRect(
          borderRadius: radius,
          child: VehicleSummaryWidget(
            plate: vm.plate,
            brand: vm.brand.isNotEmpty ? vm.brand : null,
            model: vm.model.isNotEmpty ? vm.model : null,
            version: vm.line,
            modelYear: vm.modelYear,
            cilindraje: vm.cilindraje,
            bodyType: vm.bodyType,
            vehicleColor: vm.vehicleColor,
            vehicleClass: vm.vehicleClass,
            serviceType: vm.serviceType,
            vin: vm.vin,
            engine: vm.engine,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER CARD — Para tipos no-vehículo (inmueble, maquinaria, equipo)
// ─────────────────────────────────────────────────────────────────────────────

class _PlaceholderCard extends StatelessWidget {
  final AssetSummaryVM summary;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onTap;

  const _PlaceholderCard({
    required this.summary,
    required this.icon,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono del tipo de activo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 14),
              // Nombre y estado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.displayTitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      summary.stateLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
