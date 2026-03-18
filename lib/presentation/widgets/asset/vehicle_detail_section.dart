// ============================================================================
// lib/presentation/widgets/asset/vehicle_detail_section.dart
// VEHICLE DETAIL SECTION — Sección de detalle vehicular agrupada
//
// QUÉ HACE:
// - Renderiza la ficha técnica del vehículo organizada en tres grupos:
//   1. Identificación (placa, marca, modelo, año)
//   2. Especificaciones (línea, clase, carrocería, servicio, color, combustible, cilindraje)
//   3. Identificadores técnicos (VIN, motor, chasis) — solo si al menos uno está presente.
// - Recibe VehicleContent y el año del vehículo (de AssetVehiculoEntity.anio).
// - Omite campos con valor null, vacío o sentinel ("PENDIENTE", 0.0).
//
// QUÉ NO HACE:
// - No accede a repositorios ni al dominio directamente.
// - No inventa datos ni muestra fallbacks ficticios.
// - No modifica el estado de ningún activo.
//
// PRINCIPIOS:
// - StatelessWidget puro: sin estado ni side-effects.
// - Usa exclusivamente Theme.of(context) para colores y estilos.
// - Manejo seguro de nulos: campos vacíos simplemente no aparecen.
// - _DetailGroup encapsula cada sección con título + filas.
//
// ENTERPRISE NOTES:
// ACTUALIZADO (2026-03): reemplaza lista plana con agrupación en secciones
// para mejor jerarquía visual y lectura escaneable. API externa sin cambios.
// Complementa RealEstateDetailSection, MachineryDetailSection y
// EquipmentDetailSection que se implementarán en tickets posteriores.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../domain/entities/asset/asset_content.dart';
import 'vehicle_detail_row.dart';

/// Ficha técnica vehicular agrupada en secciones.
///
/// Las tres secciones son:
/// - **Identificación**: placa, marca, modelo, año
/// - **Especificaciones**: línea, clase, carrocería, servicio, color,
///   combustible, cilindraje
/// - **Identificadores técnicos**: VIN, motor, chasis (omitida si vacíos)
///
/// Los campos nulos/vacíos/sentinel son silenciados por [VehicleDetailRow].
class VehicleDetailSection extends StatelessWidget {
  /// Contenido vehicular del AssetEntity (placa, marca, modelo y opcionales).
  final VehicleContent content;

  /// Año del vehículo, obtenido de AssetVehiculoEntity.anio via getAssetDetails().
  /// No está disponible en VehicleContent — se pasa como campo separado.
  final int? modelYear;

  const VehicleDetailSection({
    super.key,
    required this.content,
    this.modelYear,
  });

  @override
  Widget build(BuildContext context) {
    // ── Normalización de valores sentinel ─────────────────────────────────────
    // 'PENDIENTE' y 0.0 son placeholders insertados por _toEnrichedEntity()
    // cuando el dato real aún no está disponible. Se convierten a null.
    final color =
        (content.color.isNotEmpty && content.color.toUpperCase() != 'PENDIENTE')
            ? content.color
            : null;

    final cilindraje = content.engineDisplacement > 0
        ? '${content.engineDisplacement.toStringAsFixed(0)} cc'
        : null;

    // ── Sección 3 solo si algún identificador técnico está presente ─────────
    final hasIdentifiers = (content.vin?.isNotEmpty == true) ||
        (content.engineNumber?.isNotEmpty == true) ||
        (content.chassisNumber?.isNotEmpty == true);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Identificación ────────────────────────────────────────────
          _DetailGroup(
            title: 'Identificación',
            children: [
              VehicleDetailRow(
                label: 'Placa',
                value: content.assetKey.isNotEmpty ? content.assetKey : null,
              ),
              VehicleDetailRow(
                label: 'Marca',
                value: content.brand.isNotEmpty ? content.brand : null,
              ),
              VehicleDetailRow(
                label: 'Modelo',
                value: content.model.isNotEmpty ? content.model : null,
              ),
              VehicleDetailRow(
                label: 'Año',
                value: modelYear != null && modelYear! > 0
                    ? modelYear.toString()
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── 2. Especificaciones (colapsable) ────────────────────────────
          _DetailGroup(
            title: 'Especificaciones',
            expandable: true,
            children: [
              VehicleDetailRow(label: 'Línea',      value: content.line),
              VehicleDetailRow(label: 'Clase',      value: content.vehicleClass),
              VehicleDetailRow(label: 'Carrocería', value: content.bodyType),
              VehicleDetailRow(label: 'Servicio',   value: content.serviceType),
              VehicleDetailRow(label: 'Color',      value: color),
              VehicleDetailRow(label: 'Combustible',value: content.fuelType),
              VehicleDetailRow(label: 'Cilindraje', value: cilindraje),
            ],
          ),

          // ── 3. Identificadores técnicos (condicional) ─────────────────
          if (hasIdentifiers) ...[
            const SizedBox(height: 12),
            _DetailGroup(
              title: 'Identificadores técnicos',
              children: [
                VehicleDetailRow(label: 'VIN',    value: content.vin),
                VehicleDetailRow(label: 'Motor',  value: content.engineNumber),
                VehicleDetailRow(label: 'Chasis', value: content.chassisNumber),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DETAIL GROUP — Sección con título y filas
// ─────────────────────────────────────────────────────────────────────────────

/// Contenedor de una sección de detalle con título, divisor y filas de datos.
///
/// El título usa [colorScheme.primary] para distinguirse visualmente de los
/// valores, creando jerarquía dentro de la ficha técnica.
///
/// Cuando [expandable] es `true`, la sección se renderiza como [ExpansionTile]
/// colapsable. Útil para secciones secundarias (ej: Especificaciones) que no
/// siempre requieren atención inmediata del usuario.
class _DetailGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  /// Si `true`, la sección es colapsable/expandible. Default: `false`.
  final bool expandable;

  const _DetailGroup({
    required this.title,
    required this.children,
    this.expandable = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final decoration = BoxDecoration(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
    );

    final titleStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: cs.primary,
      letterSpacing: 0.4,
    );

    if (expandable) {
      // ClipRRect garantiza que ExpansionTile no desborde el border radius.
      return Container(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Theme(
            // Elimina el divider nativo del ExpansionTile para usar el propio.
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              title: Text(title, style: titleStyle),
              iconColor: cs.primary,
              collapsedIconColor: cs.primary,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: cs.outline.withValues(alpha: 0.2),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                ...children,
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          const SizedBox(height: 8),
          Divider(color: cs.outline.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 2),
          ...children,
        ],
      ),
    );
  }
}
