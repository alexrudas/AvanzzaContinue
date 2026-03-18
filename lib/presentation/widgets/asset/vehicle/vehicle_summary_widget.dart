// ============================================================================
// lib/presentation/widgets/asset/vehicle/vehicle_summary_widget.dart
// VEHICLE SUMMARY WIDGET — Widget público reutilizable de resumen vehicular
//
// QUÉ HACE:
// - Renderiza el header completo de resumen de un vehículo:
//   placa estilizada, marca/modelo/versión, tipo de servicio (badge),
//   clase/carrocería/color, año/transmisión/cilindraje, VIN y motor.
// - Exporta VehicleSummaryWidget como widget público reutilizable.
//
// QUÉ NO HACE:
// - No modifica ni persiste datos del vehículo.
// - No conoce controladores ni repositorios.
//
// PRINCIPIOS:
// - StatelessWidget puro: sin estado, sin side-effects.
// - Usa PlateWidget (plate_widget.dart) para la representación de placa.
// - _TechLine y _ServiceBadge son helpers privados internos del widget.
//
// ENTERPRISE NOTES:
// EXTRAÍDO (2026-03): era `_VehicleSummary` privado en runt_query_result_page.dart.
// Convertido en widget público para habilitar reutilización en
// PortfolioAssetListPage, AssetListPage y futuras vistas de detalle.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'plate_widget.dart';

/// Header de resumen de vehículo con placa, datos técnicos y metadata visual.
///
/// Muestra en orden:
///   1. Placa estilizada (PlateWidget)
///   2. MARCA MODELO VERSIÓN
///   3. Badge de tipo de servicio
///   4. Clase · Carrocería · Color
///   5. Año · Transmisión · Cilindraje
///   6. VIN (con icono de copia)
///   7. MOTOR (con icono de copia)
class VehicleSummaryWidget extends StatelessWidget {
  final String plate;
  final String? brand;
  final String? model;
  final String? version;
  final String? modelYear;
  final String? transmision;
  final String? cilindraje;
  final String? bodyType;
  final String? vehicleColor;

  /// Clase de vehículo (Automóvil, Motocicleta, etc.) desde vehicleRegistration.
  final String? vehicleClass;

  /// Tipo de servicio (Público / Particular) — controla color de placa y badge.
  final String? serviceType;
  final String? vin;
  final String? engine;

  const VehicleSummaryWidget({
    super.key,
    required this.plate,
    this.brand,
    this.model,
    this.version,
    this.modelYear,
    this.transmision,
    this.cilindraje,
    this.bodyType,
    this.vehicleColor,
    this.vehicleClass,
    this.serviceType,
    this.vin,
    this.engine,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // ── Línea 2: MARCA MODELO VERSIÓN ───────────────────────────────────────
    // Combina brand + model + version en una línea. Flutter envuelve si largo.
    final modelParts = <String>[
      if (brand != null && brand!.isNotEmpty) brand!,
      if (model != null && model!.isNotEmpty) model!,
      if (version != null && version!.isNotEmpty) version!,
    ];
    final modelLine = modelParts.join(' ').toUpperCase();

    // ── Línea 3: TIPO DE SERVICIO ────────────────────────────────────────────
    // Se renderiza como badge visual. Se oculta si no hay valor.
    // NO se antepone "SERVICIO". Ej: PÚBLICO, PARTICULAR, DIPLOMÁTICO.
    final serviceLabel = (serviceType != null && serviceType!.trim().isNotEmpty)
        ? serviceType!.trim().toUpperCase()
        : null;

    // ── Línea 4: CLASE · CARROCERÍA · COLOR ─────────────────────────────────
    // Separadores se omiten automáticamente si falta algún campo.
    // Orden: clase > carrocería > color. Uppercase uniforme.
    final bodyParts = <String>[
      if (vehicleClass != null && vehicleClass!.isNotEmpty)
        vehicleClass!.toUpperCase(),
      if (bodyType != null && bodyType!.isNotEmpty) bodyType!.toUpperCase(),
      if (vehicleColor != null && vehicleColor!.isNotEmpty)
        vehicleColor!.toUpperCase(),
    ];
    final bodyLine = bodyParts.join(' · ');

    // ── Línea 5: AÑO · TRANSMISIÓN · CILINDRAJE ─────────────────────────────
    // Año es el primer campo del grupo. Si transmisión falta se omite.
    // Si cilindraje falta, no se añade "cc" huérfano.
    final techParts = <String>[
      if (modelYear != null && modelYear!.isNotEmpty) modelYear!,
      if (transmision != null && transmision!.isNotEmpty) transmision!,
      if (cilindraje != null && cilindraje!.isNotEmpty) '$cilindraje cc',
    ];
    final techLine = techParts.join(' · ');

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── 1. PLACA ─────────────────────────────────────────────────────
          // Widget dedicado: aplica color semántico (_getPlateStyle) y
          // formato visual "XXX - XXX" (_formatPlateForDisplay).
          // Excepción motocicleta: siempre amarillo, sin importar el servicio.
          PlateWidget(
            plate: plate,
            serviceType: serviceType,
            vehicleType: vehicleClass,
          ),

          const SizedBox(height: 14),

          // ── 2. MARCA MODELO VERSIÓN ─────────────────────────────────────────
          // Mayor peso visual del summary.
          if (modelLine.isNotEmpty)
            Text(
              modelLine,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
                letterSpacing: 0.4,
              ),
              textAlign: TextAlign.center,
            ),

          // ── 3. TIPO DE SERVICIO (badge discreto) ────────────────────────────
          // Badge gris neutro centrado debajo del modelo.
          // El color fuerte ya lo aporta la placa — el badge solo informa.
          if (serviceLabel != null) ...[
            const SizedBox(height: 6),
            _ServiceBadge(label: serviceLabel),
          ],

          // ── 4. CLASE · CARROCERÍA · COLOR ───────────────────────────────────
          // Metadata secundaria. Sin separadores rotos si falta algún campo.
          if (bodyLine.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              bodyLine,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // ── 5. AÑO · TRANSMISIÓN · CILINDRAJE ──────────────────────────────
          // Línea técnica secundaria. Año primero; nulls omitidos sin rotura.
          if (techLine.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              techLine,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // ── 6. VIN / 7. MOTOR ──────────────────────────────────────────────
          // Layout horizontal: etiqueta (80px) + valor monospace + icono copiar.
          // Se ocultan si vacíos para no dejar espacio muerto.
          if (vin != null && vin!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _TechLine(label: 'VIN', value: vin!),
          ],
          if (engine != null && engine!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _TechLine(label: 'MOTOR', value: engine!),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE HELPERS — Solo para uso interno de VehicleSummaryWidget
// ─────────────────────────────────────────────────────────────────────────────

/// Identificador técnico en layout horizontal con icono de copia.
///
/// Layout:
///   [label 80px fijo] [valor monospace expandido alineado derecha] [icono copy]
///
/// El ancho fijo de 80px asegura que VIN y MOTOR queden perfectamente alineados.
/// El valor usa fuente monospace (RobotoMono) para máxima legibilidad de series.
class _TechLine extends StatelessWidget {
  final String label;
  final String value;

  const _TechLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final displayValue = value.toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Etiqueta con ancho fijo 80px — VIN y MOTOR quedan alineados entre sí.
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Valor en fuente monoespaciada — ancho natural, sin expansión forzada.
        Text(
          displayValue,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
            fontFamily: 'RobotoMono',
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        // Icono de copia discreto. Copia el valor sin procesar al portapapeles.
        // Intencionalmente pequeño (14px) para no distraer del identificador.
        GestureDetector(
          onTap: () => Clipboard.setData(ClipboardData(text: value)),
          child: Icon(
            Icons.copy_rounded,
            size: 14,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Badge visual del tipo de servicio (PARTICULAR, PÚBLICO, DIPLOMÁTICO, etc.).
///
/// Usa fondo gris neutro muy suave — NO usa colores fuertes.
/// El color semántico principal ya lo aporta la placa.
/// Se centra debajo del nombre del modelo.
class _ServiceBadge extends StatelessWidget {
  final String label;

  const _ServiceBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        // Fondo neutro suave — complementa sin competir con la placa.
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
