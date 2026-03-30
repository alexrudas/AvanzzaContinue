// ============================================================================
// lib/presentation/pages/asset/runt_consult_page.dart
// RUNT CONSULT PAGE — Panel de documentos y estado oficial del vehículo
//
// QUÉ HACE:
// - Muestra el estado de los documentos oficiales del vehículo en un grid de
//   5 tiles con el mismo lenguaje visual que AssetDetailPage.
// - Tiles: SOAT, RTM (dinámico desde runtMetaJson), Seguros RC, Estado
//   jurídico (dinámico desde runtMetaJson), Multas (placeholder).
// - Banner de estado legal: "Sin novedades" o resumen de restricciones.
// - Navega a las detail pages existentes desde cada tile.
// - Metadata: Fuente RUNT + fecha de última actualización.
// - Recibe AssetVehiculoEntity directamente desde Get.arguments.
//
// QUÉ NO HACE:
// - No duplica datos técnicos del vehículo (VIN, motor, clase, color, modelo).
// - No carga repositorios ni accede a Isar/Firestore directamente.
// - No incluye el tile Seg. Todo Riesgo.
// - No muestra métricas de días SOAT/RC (esos datos viven en detail pages).
// - No hardcodea colores — theme-only via Theme.of(context).colorScheme.
//
// PRINCIPIOS:
// - Parse-once: RTM y Legal se calculan una sola vez en build() del body,
//   fuera de widgets hoja, y se pasan hacia abajo como valores ya resueltos.
// - Theme-only: cero colores hardcodeados.
// - Offline-first: datos ya persistidos en AssetVehiculoEntity.
// - Mismo lenguaje visual de grid que AssetDetailPage._VehicleStateTile.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Panel de documentos RUNT accesible desde AssetDetailPage
//   (sección 4.6, después de la tarjeta RUNT). Consolida los 5 documentos
//   clave en un panel de navegación unificado hacia las detail pages
//   ya implementadas. Complementa VehicleInfoPage (datos administrativos).
// DEPENDENCIAS INTERNAS: parseRtmFromMetaJson (asset_rtm_helpers.dart),
//   parseLegalDataFromMetaJson (asset_legal_helpers.dart).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../../domain/entities/vehicle/vehicle_document_status.dart';
import '../../controllers/asset/asset_detail_runt_controller.dart';
import '../../../routes/app_pages.dart';
import 'asset_legal_helpers.dart';
import 'asset_rtm_helpers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const double _kHPad = 16;
const double _kVPad = 20;
const double _kGap = 16;
const double _kCardRadius = 14;

// ─────────────────────────────────────────────────────────────────────────────
// SEVERITY — señal visual de tiles (replicado de asset_detail_page.dart)
// ─────────────────────────────────────────────────────────────────────────────

enum _Severity { neutral, attention, critical }

Color _borderColor(_Severity s, ColorScheme cs) => switch (s) {
      _Severity.neutral => cs.outline.withValues(alpha: 0.12),
      _Severity.attention => cs.tertiary.withValues(alpha: 0.38),
      _Severity.critical => cs.error.withValues(alpha: 0.42),
    };

Color _iconColor(_Severity s, ColorScheme cs) => switch (s) {
      _Severity.neutral => cs.primary,
      _Severity.attention => cs.tertiary,
      _Severity.critical => cs.error,
    };

Color _metricColor(_Severity s, ColorScheme cs) => switch (s) {
      _Severity.neutral => cs.onSurfaceVariant,
      _Severity.attention => cs.tertiary,
      _Severity.critical => cs.error,
    };

// ─────────────────────────────────────────────────────────────────────────────
// DATA CLASS — definición de tile
// ─────────────────────────────────────────────────────────────────────────────

/// Definición de un tile del grid de documentos RUNT.
class _TileDef {
  final IconData icon;
  final String title;
  final String primaryMetric;
  final String? secondaryMetric;
  final _Severity severity;
  final VoidCallback? onTap;

  const _TileDef({
    required this.icon,
    required this.title,
    required this.primaryMetric,
    this.secondaryMetric,
    this.severity = _Severity.neutral,
    this.onTap,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE — punto de entrada GetX
// ─────────────────────────────────────────────────────────────────────────────

class RuntConsultPage extends StatelessWidget {
  const RuntConsultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    if (arg is! AssetVehiculoEntity) {
      return Scaffold(
        appBar: AppBar(title: const Text('Consulta RUNT')),
        body: const Center(child: Text('Sin datos disponibles')),
      );
    }
    return _RuntConsultBody(vehiculo: arg);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BODY — scaffolding + parse-once de datos
// ─────────────────────────────────────────────────────────────────────────────

class _RuntConsultBody extends StatelessWidget {
  final AssetVehiculoEntity vehiculo;

  const _RuntConsultBody({required this.vehiculo});

  DateTime? get _lastUpdate {
    try {
      return Get.find<AssetDetailRuntController>().lastRuntQueryAt.value;
    } catch (_) {
      return null;
    }
  }

  /// Formatea la placa como "ABC · 123" (o sin separador si el formato es inusual).
  String _formatPlate(String placa) {
    final p = placa.toUpperCase().trim();
    // Placas colombianas estándar: 3 letras + 3 números = 6 chars
    // Motos: 3 letras + 2 números = 5 chars
    if (p.length >= 5) {
      return '${p.substring(0, 3)} · ${p.substring(3)}';
    }
    return p;
  }

  /// Línea compacta marca · modelo para el encabezado.
  String? _brandModel() {
    final parts = <String>[];
    if (vehiculo.marca.isNotEmpty) parts.add(vehiculo.marca);
    if (vehiculo.modelo.isNotEmpty) parts.add(vehiculo.modelo);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  /// Construye el tile RTM a partir del estado resuelto desde runtMetaJson.
  _TileDef _buildRtmTile(VehicleDocumentStatus? rtm) {
    final days = rtm?.daysToExpire;
    final status = rtm?.status;

    final String metric = switch (days) {
      null => 'Sin información',
      < 0 => 'Vencida',
      0 => 'Vence hoy',
      1 => 'Vence en 1 día',
      _ => 'Vence en $days días',
    };

    final _Severity severity = switch (status) {
      null => _Severity.neutral,
      DocumentValidityStatus.vigente => _Severity.neutral,
      DocumentValidityStatus.desconocido => _Severity.attention,
      DocumentValidityStatus.porVencer => _Severity.attention,
      DocumentValidityStatus.vencido => _Severity.critical,
    };

    final String? secondary = rtm?.endDate != null
        ? DateFormat('d MMM yyyy', 'es_CO').format(rtm!.endDate!)
        : null;

    return _TileDef(
      icon: Icons.fact_check_outlined,
      title: 'Rev. Técnico-Mecánica',
      primaryMetric: metric,
      secondaryMetric: secondary,
      severity: severity,
      onTap: () => Get.toNamed(Routes.assetRtmDetail,
          arguments: vehiculo.assetId),
    );
  }

  /// Construye el tile Estado jurídico a partir de los datos parseados.
  _TileDef _buildLegalTile(LegalStatusData legal) {
    final String metric;
    String? secondary;
    final _Severity severity;

    if (legal.hasLimitations || legal.hasWarranties) {
      final firstLimType = legal.limitations.isNotEmpty
          ? legal.limitations.first.limitationType
          : null;
      metric = firstLimType?.toUpperCase() ??
          '${legal.totalNovelties} novedad(es)';
      final firstCreditor = legal.warranties.isNotEmpty
          ? legal.warranties.first.creditorName
          : null;
      secondary = firstCreditor ?? 'Limitaciones · Gravámenes';
      severity = _Severity.critical;
    } else if (legal.hasPropertyLiensNovelties) {
      metric = 'Gravamen registrado';
      secondary = 'Limitaciones · Gravámenes';
      severity = _Severity.attention;
    } else {
      metric = 'Sin novedades';
      secondary = 'Limitaciones · Gravámenes';
      severity = _Severity.neutral;
    }

    return _TileDef(
      icon: Icons.gavel_outlined,
      title: 'Estado jurídico',
      primaryMetric: metric,
      secondaryMetric: secondary,
      severity: severity,
      onTap: () => Get.toNamed(Routes.legalStatus,
          arguments: vehiculo.assetId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Parse-once: calcular antes de construir el árbol de widgets.
    final rtm = parseRtmFromMetaJson(vehiculo.runtMetaJson);
    final legal = parseLegalDataFromMetaJson(
      vehiculo.runtMetaJson,
      propertyLiens: vehiculo.propertyLiens,
    );
    final lastUpdate = _lastUpdate;
    final formattedDate = _fmtDate(lastUpdate);

    final tiles = [
      _TileDef(
        icon: Icons.shield_outlined,
        title: 'SOAT',
        primaryMetric: 'Ver historial',
        severity: _Severity.neutral,
        onTap: () => Get.toNamed(Routes.soatDetail,
            arguments: vehiculo.assetId),
      ),
      _buildRtmTile(rtm),
      _TileDef(
        icon: Icons.policy_outlined,
        title: 'Seguros RC',
        primaryMetric: 'Ver historial',
        secondaryMetric: 'RCC + RCEC',
        severity: _Severity.neutral,
        onTap: () => Get.toNamed(Routes.segurosRcDetail,
            arguments: vehiculo.assetId),
      ),
      _buildLegalTile(legal),
      const _TileDef(
        icon: Icons.receipt_long_outlined,
        title: 'Multas SIMIT',
        primaryMetric: 'Sin información',
        secondaryMetric: 'Próximamente',
        severity: _Severity.neutral,
        // sin onTap: módulo placeholder
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Get.back),
        title: const Text('Consulta RUNT'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: _kHPad,
          vertical: _kVPad,
        ),
        children: [
          // ── 1. Encabezado del vehículo ────────────────────────────────────
          _VehicleHeader(
            plate: _formatPlate(vehiculo.placa),
            brandModel: _brandModel(),
            service: vehiculo.serviceType,
          ),

          const SizedBox(height: _kGap),

          // ── 2. Banner estado legal ─────────────────────────────────────────
          _LegalStatusBanner(legal: legal),

          const SizedBox(height: _kGap),

          // ── 3. Grid de documentos oficiales ───────────────────────────────
          _RuntDocGrid(tiles: tiles),

          const SizedBox(height: _kGap),

          // ── 4. Metadata ───────────────────────────────────────────────────
          _MetadataCard(formattedDate: formattedDate),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

/// Formatea [dt] como "24 mar 2026 · 7:34 p. m." (locale es_CO, 12h).
String? _fmtDate(DateTime? dt) {
  if (dt == null) return null;
  try {
    return DateFormat("d MMM y · h:mm a", 'es_CO').format(dt.toLocal());
  } catch (_) {
    return DateFormat('d MMM y · HH:mm').format(dt.toLocal());
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE HEADER — placa dominante + marca/modelo + servicio
// ─────────────────────────────────────────────────────────────────────────────

/// Encabezado compacto: placa grande, marca/modelo en línea secundaria,
/// chip de tipo de servicio.
class _VehicleHeader extends StatelessWidget {
  final String plate;
  final String? brandModel;
  final String? service;

  const _VehicleHeader({
    required this.plate,
    this.brandModel,
    this.service,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placa dominante
        Text(
          plate,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
            color: cs.onSurface,
          ),
        ),

        // Marca · Modelo
        if (brandModel != null) ...[
          const SizedBox(height: 2),
          Text(
            brandModel!,
            style: textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],

        // Chip de servicio
        if (service != null && service!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              service!.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: cs.onSecondaryContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEGAL STATUS BANNER — estado jurídico consolidado
// ─────────────────────────────────────────────────────────────────────────────

/// Banner de estado legal: sin novedades (verde) o con restricciones (rojo/naranja).
///
/// Se alimenta de [LegalStatusData] ya parseado — no llama parsers.
class _LegalStatusBanner extends StatelessWidget {
  final LegalStatusData legal;

  const _LegalStatusBanner({required this.legal});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bool hasNovelty = legal.hasAnyLegalNovelty;

    // Icono y colores según presencia de novedades.
    final IconData icon = hasNovelty
        ? Icons.warning_amber_rounded
        : Icons.verified_outlined;

    final Color bgColor = hasNovelty
        ? cs.errorContainer
        : cs.tertiaryContainer;

    final Color fgColor = hasNovelty
        ? cs.onErrorContainer
        : cs.onTertiaryContainer;

    // Texto principal del banner.
    final String label = hasNovelty
        ? (legal.hasLimitations
            ? '${legal.totalLimitations} limitación(es) registrada(s)'
            : (legal.hasWarranties
                ? '${legal.totalWarranties} gravamen(es) registrado(s)'
                : 'Gravamen textual registrado'))
        : 'Sin novedades jurídicas';

    // Subtexto de detalle.
    final String detail = hasNovelty
        ? 'Consulta el estado jurídico para más información'
        : 'No se encontraron limitaciones ni gravámenes';

    return GestureDetector(
      onTap: hasNovelty
          ? () => Get.toNamed(Routes.legalStatus,
              arguments: Get.arguments is AssetVehiculoEntity
                  ? (Get.arguments as AssetVehiculoEntity).assetId
                  : null)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(_kCardRadius),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: fgColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: fgColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    detail,
                    style: textTheme.bodySmall?.copyWith(
                      color: fgColor.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            if (hasNovelty) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: fgColor.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RUNT DOC GRID — grid 2 columnas de documentos oficiales
// ─────────────────────────────────────────────────────────────────────────────

/// Grid de 2 columnas con el mismo lenguaje visual de AssetDetailPage.
///
/// childAspectRatio 1.65: compacto sin sacrificar legibilidad.
/// mainAxisSpacing/crossAxisSpacing 8: densidad dashboard.
class _RuntDocGrid extends StatelessWidget {
  final List<_TileDef> tiles;

  const _RuntDocGrid({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(label: 'Documentos oficiales'),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.65,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: tiles.length,
          itemBuilder: (_, i) => _RuntTile(def: tiles[i]),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RUNT TILE — widget base de tile del grid (mismo patrón que _VehicleStateTile)
// ─────────────────────────────────────────────────────────────────────────────

/// Tile del grid de documentos RUNT.
///
/// Replica fielmente el patrón visual de [_VehicleStateTile] de AssetDetailPage:
/// - Fondo surfaceContainerLow
/// - Borde con color según severidad
/// - Icono (18 dp) + chevron en fila superior
/// - Título (labelMedium w700) + métrica principal + métrica secundaria
class _RuntTile extends StatelessWidget {
  final _TileDef def;

  const _RuntTile({required this.def});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final ic = _iconColor(def.severity, cs);
    final bc = _borderColor(def.severity, cs);
    final mc = _metricColor(def.severity, cs);
    final isAlert = def.severity != _Severity.neutral;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          if (def.onTap != null) {
            def.onTap!();
          } else {
            Get.snackbar(
              'Próximamente',
              '${def.title} estará disponible pronto',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(_kHPad),
              borderRadius: 12,
              duration: const Duration(seconds: 2),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: bc),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icono + chevron
              Row(
                children: [
                  Icon(def.icon, size: 18, color: ic),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // ── Título
              Text(
                def.title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),

              // ── Métrica principal
              Text(
                def.primaryMetric,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: mc,
                  fontSize: 11,
                  fontWeight:
                      isAlert ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // ── Métrica secundaria
              if (def.secondaryMetric != null)
                Text(
                  def.secondaryMetric!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// METADATA CARD — fuente y fecha de consulta
// ─────────────────────────────────────────────────────────────────────────────

/// Card de metadatos: fuente (RUNT) y fecha de última actualización.
class _MetadataCard extends StatelessWidget {
  final String? formattedDate;

  const _MetadataCard({this.formattedDate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(label: 'Información de la consulta'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(_kCardRadius),
            border: Border.all(color: cs.outline.withValues(alpha: 0.10)),
          ),
          child: Column(
            children: [
              _MetaRow(
                label: 'Fuente',
                value: 'RUNT',
                textTheme: textTheme,
                cs: cs,
              ),
              const SizedBox(height: 6),
              _MetaRow(
                label: 'Última actualización',
                value: formattedDate ?? '—',
                textTheme: textTheme,
                cs: cs,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fila simple label + valor para la metadata card.
class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme cs;

  const _MetaRow({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL — etiqueta de sección
// ─────────────────────────────────────────────────────────────────────────────

/// Etiqueta de sección: labelLarge primary w700, consistente con VehicleInfoPage.
class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      label,
      style: textTheme.labelLarge?.copyWith(
        color: cs.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }
}
