// ============================================================================
// lib/presentation/pages/asset/vehicle_info_page.dart
// VEHICLE INFO PAGE — Información completa del vehículo
//
// QUÉ HACE:
// - Muestra los datos completos del vehículo en 5 secciones: Información
//   general, Matrícula, Datos de identificación, Información del propietario
//   e Información de la consulta.
// - Soporte de "Copiar datos" global (AppBar) y long-press por campo.
// - Lee la fecha de última actualización RUNT desde AssetDetailRuntController
//   (Get.find) sin acceder directamente a repositorios.
// - Recibe AssetVehiculoEntity directamente desde Get.arguments (ya cargado
//   en AssetDetailPage — sin carga extra de repositorio).
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore directamente.
// - No muestra SOAT, RTM, seguros ni limitaciones jurídicas.
// - No permite editar datos del propietario (iteración futura).
// - No hardcodea colores — theme-only via Theme.of(context).colorScheme.
//
// PRINCIPIOS:
// - Offline-first: datos ya persistidos en AssetVehiculoEntity.
// - Parse-once: _fmtDate y _buildNameLine se calculan en build(), fuera
//   de widgets hoja, y se pasan hacia abajo como Strings.
// - Theme-only: cero colores hardcodeados.
// - "—" explícito para campos sin datos RUNT disponibles.
// - Long-press: único mecanismo de copia por campo. Sin iconos de copiar.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Pantalla de información vehicular completa accesible
//   desde AssetDetailPage. Complementa la ficha técnica con datos para
//   trámites, seguros y autoridades.
// WIDGETS PÚBLICOS: VehicleInfoSectionCard + InfoRow — reutilizables
//   en otros módulos sin importar esta página.
// ACTUALIZADO (2026-03): Layout de cada campo cambiado de Column a Row
//   (label izquierda fijo, value derecha expandido, wrap libre).
//   Nueva sección "Matrícula" extraída de "Información general".
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../controllers/asset/asset_detail_runt_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const double _kHorizontalPad = 16;
const double _kVerticalPad = 20;
const double _kSectionGap = 20;
const double _kItemGap = 4;
const double _kCardPad = 16;
const double _kCardRadius = 18;

/// Ancho fijo de la columna de labels.
///
/// 120 dp acomoda las etiquetas más largas ("Tipo de documento" no cabe, pero
/// "Número de documento" y "Última actualización" sí en bodySmall).
/// Si el label supera el ancho, se wrappea consistentemente.
const double _kLabelWidth = 120;
const double _kLabelValueGap = 8;

// ─────────────────────────────────────────────────────────────────────────────
// PAGE — punto de entrada GetX
// ─────────────────────────────────────────────────────────────────────────────

class VehicleInfoPage extends StatelessWidget {
  const VehicleInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    if (arg is! AssetVehiculoEntity) {
      return Scaffold(
        appBar: AppBar(title: const Text('Información del vehículo')),
        body: const Center(child: Text('Sin datos disponibles')),
      );
    }
    return _VehicleInfoBody(vehiculo: arg);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BODY — scaffolding + construcción de datos (parse-once)
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleInfoBody extends StatelessWidget {
  final AssetVehiculoEntity vehiculo;

  const _VehicleInfoBody({required this.vehiculo});

  DateTime? get _lastUpdate {
    try {
      return Get.find<AssetDetailRuntController>().lastRuntQueryAt.value;
    } catch (_) {
      return null;
    }
  }

  String? _buildNameLine() {
    final parts = <String>[];
    if (vehiculo.marca.isNotEmpty) parts.add(vehiculo.marca);
    if (vehiculo.line?.isNotEmpty == true) parts.add(vehiculo.line!);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String? get _vinValue => (vehiculo.vin?.isNotEmpty == true)
      ? vehiculo.vin
      : vehiculo.chassisNumber;

  @override
  Widget build(BuildContext context) {
    final lastUpdate = _lastUpdate;
    final formattedDate = _fmtDate(lastUpdate);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Get.back),
        title: const Text('Información del vehículo'),
        actions: [
          TextButton(
            onPressed: () => _copyAll(vehiculo, formattedDate),
            child: const Text('Copiar datos'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: _kHorizontalPad,
          vertical: _kVerticalPad,
        ),
        children: [
          // ── 1. Información general ──────────────────────────────────────────
          // Matrícula y Tránsito se movieron a la sección "Matrícula".
          VehicleInfoSectionCard(
            title: 'Información general',
            children: [
              InfoRow(
                label: 'Placa',
                value: vehiculo.placa,
                isHighPriority: true,
              ),
              InfoRow(
                label: 'Marca',
                value: _buildNameLine(),
                isHighPriority: true,
              ),
              InfoRow(label: 'Modelo', value: vehiculo.modelo),
              InfoRow(label: 'Año', value: vehiculo.anio.toString()),
              InfoRow(
                label: 'Cilindraje',
                value: vehiculo.engineDisplacement != null
                    ? '${vehiculo.engineDisplacement!.toStringAsFixed(0)} CC'
                    : null,
              ),
              InfoRow(label: 'Clase', value: vehiculo.vehicleClass),
              InfoRow(label: 'Carrocería', value: vehiculo.bodyType),
              InfoRow(label: 'Color', value: vehiculo.color),
              InfoRow(
                  label: 'Servicio',
                  value: vehiculo.serviceType?.toUpperCase()),
            ],
          ),

          const SizedBox(height: _kSectionGap),

          // ── 2. Matrícula ────────────────────────────────────────────────────
          // Campos extraídos de "Información general".
          VehicleInfoSectionCard(
            title: 'Matrícula',
            children: [
              InfoRow(label: 'Tránsito', value: vehiculo.transitAuthority),
              InfoRow(
                label: 'Fecha matrícula',
                value: vehiculo.initialRegistrationDate,
              ),
            ],
          ),

          const SizedBox(height: _kSectionGap),

          // ── 3. Datos de identificación ──────────────────────────────────────
          VehicleInfoSectionCard(
            title: 'Datos de identificación',
            children: [
              InfoRow(label: 'VIN / Chasis', value: _vinValue),
              InfoRow(label: 'Número de motor', value: vehiculo.engineNumber),
            ],
          ),

          const SizedBox(height: _kSectionGap),

          // ── 4. Información del propietario ──────────────────────────────────
          VehicleInfoSectionCard(
            title: 'Información del propietario',
            children: [
              InfoRow(label: 'Nombre', value: vehiculo.ownerName),
              InfoRow(
                label: 'Tipo de documento',
                value: vehiculo.ownerDocumentType,
              ),
              InfoRow(
                label: 'No. documento',
                value: vehiculo.ownerDocument,
              ),
            ],
          ),

          const SizedBox(height: _kSectionGap),

          // ── 5. Información de la consulta ───────────────────────────────────
          VehicleInfoSectionCard(
            title: 'Información de la consulta',
            children: [
              const InfoRow(label: 'Fuente', value: 'RUNT'),
              InfoRow(label: 'Última actualización', value: formattedDate),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

/// Formatea [dt] como "24 mar 2026 · 7:34 p. m." (locale es_CO, 12 h).
String? _fmtDate(DateTime? dt) {
  if (dt == null) return null;
  try {
    return DateFormat("d MMM y · h:mm a", 'es_CO').format(dt.toLocal());
  } catch (_) {
    return DateFormat('d MMM y · HH:mm').format(dt.toLocal());
  }
}

/// Copia todo el contenido al portapapeles en el orden visual exacto.
void _copyAll(AssetVehiculoEntity v, String? formattedDate) {
  String f(String? s) => (s?.isNotEmpty == true) ? s! : '—';
  final vinValue = (v.vin?.isNotEmpty == true) ? v.vin : v.chassisNumber;

  final buffer = StringBuffer()
    // 1. Información general
    ..writeln('Placa: ${f(v.placa)}')
    ..writeln('Marca: ${f(v.marca)}')
    ..writeln('Modelo: ${f(v.modelo)}')
    ..writeln('Línea: ${f(v.line)}')
    ..writeln('Clase: ${f(v.vehicleClass)}')
    ..writeln('Carrocería: ${f(v.bodyType)}')
    ..writeln('Color: ${f(v.color)}')
    ..writeln('Servicio: ${f(v.serviceType)}')
    ..writeln()
    // 2. Matrícula
    ..writeln('Tránsito: ${f(v.transitAuthority)}')
    ..writeln('Fecha matrícula: ${f(v.initialRegistrationDate)}')
    ..writeln()
    // 3. Datos de identificación
    ..writeln('VIN / Chasis: ${f(vinValue)}')
    ..writeln('Motor: ${f(v.engineNumber)}')
    ..writeln()
    // 4. Información del propietario
    ..writeln('Propietario: —')
    ..writeln('Tipo doc.: —')
    ..writeln('N.° doc.: —')
    ..writeln()
    // 5. Información de la consulta
    ..writeln('Fuente: RUNT')
    ..write('Última actualización: ${formattedDate ?? '—'}');

  Clipboard.setData(ClipboardData(text: buffer.toString()));
  Get.snackbar(
    'Datos copiados',
    'Información del vehículo copiada al portapapeles',
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(_kHorizontalPad),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE INFO SECTION CARD — widget base reutilizable
// ─────────────────────────────────────────────────────────────────────────────

/// Card base de una sección de información vehicular.
///
/// Sin Dividers internos — separación mediante espaciado entre [InfoRow]s.
class VehicleInfoSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const VehicleInfoSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(_kCardPad),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(_kCardRadius),
            border: Border.all(color: cs.outline.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _intersperse(children, const SizedBox(height: _kItemGap)),
          ),
        ),
      ],
    );
  }

  static List<Widget> _intersperse(List<Widget> items, Widget spacer) {
    if (items.isEmpty) return [];
    return [
      for (int i = 0; i < items.length; i++) ...[
        items[i],
        if (i < items.length - 1) spacer,
      ],
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO ROW — widget base reutilizable para cada fila de dato
// ─────────────────────────────────────────────────────────────────────────────

/// Fila de un campo: label con ancho fijo a la izquierda, value expandido
/// a la derecha.
///
/// Comportamiento de layout:
/// - El label ocupa [_kLabelWidth] dp; si el texto es largo, wrappea hacia
///   abajo manteniendo la columna alineada.
/// - El value ocupa el espacio restante con [Expanded]; wrappea libremente
///   sin ellipsis para no truncar datos críticos.
/// - [crossAxisAlignment.start] garantiza que label y value arrancan desde
///   la misma línea base aunque alguno baje a segunda línea.
///
/// Long-press en cualquier parte de la fila → copia el valor al portapapeles.
class InfoRow extends StatelessWidget {
  /// Etiqueta del campo (siempre visible).
  final String label;

  /// Valor del campo. Null o vacío → muestra "—" sin acción de copia.
  final String? value;

  /// Si true, el value usa tipografía ligeramente más prominente.
  /// Usado para campos de alta prioridad como placa y marca.
  final bool isHighPriority;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final hasValue = value != null && value!.isNotEmpty;
    final displayValue = hasValue ? value! : '—';

    final valueStyle = isHighPriority
        ? textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: hasValue ? cs.onSurface : cs.onSurfaceVariant,
          )
        : textTheme.bodySmall?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: hasValue ? cs.onSurface : cs.onSurfaceVariant,
          );

    return GestureDetector(
      onLongPress: hasValue
          ? () {
              Clipboard.setData(ClipboardData(text: displayValue));
              Get.snackbar(
                'Copiado',
                '$label: $displayValue',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(_kHorizontalPad),
              );
            }
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label — ancho fijo, wrappea si es necesario
          SizedBox(
            width: _kLabelWidth,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: _kLabelValueGap),

          // Value — ocupa el espacio restante, wrappea libremente
          Expanded(
            child: Text(
              displayValue,
              style: valueStyle,
              // Sin maxLines ni ellipsis: los valores deben ser legibles completos.
            ),
          ),
        ],
      ),
    );
  }
}
