// ============================================================================
// lib/presentation/pages/asset/rtm_detail_page.dart
// RTM DETAIL PAGE v1 — Detalle de Revisión Técnico-Mecánica
//
// QUÉ HACE:
// - Muestra el estado RTM real del activo, derivado de los registros RUNT
//   persistidos en runtMetaJson.
// - Carga AssetVehiculoEntity desde el repositorio usando assetId recibido
//   por argumento de navegación (mismo patrón que AssetDetailPage).
// - Resuelve el estado RTM mediante parseRtmFromMetaJson (helper compartido)
//   para no duplicar la lógica de parsing.
// - Distingue explícitamente cuatro estados:
//     1. Argumento de navegación inválido (_PageState.invalidArg)
//     2. Error en getAssetDetails() o vehiculo == null (_PageState.loadError)
//     3. Activo cargado sin datos RTM parseables (_PageState.noRtmData)
//     4. Datos RTM disponibles y resueltos (_PageState.ready)
//
// QUÉ NO HACE:
// - No implementa historial RTM completo (RTM v2).
// - No modifica repositorios ni dominio.
// - No usa GetX controller propio — StatefulWidget con carga async puntual,
//   consistente con AssetDetailPage.
// - No llama endpoints RUNT en tiempo real (muestra solo lo persistido).
//
// PRINCIPIOS:
// - StatefulWidget con _loadRtmData() en initState y try/catch explícito.
// - Cada estado de carga es discriminado, no colapsado en un único null-check.
// - Theme-only: cero colores hardcodeados.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): RTM v1 — primera pantalla de detalle documental real.
// TODO (RTM v2): Agregar historial completo cuando resolveRtm() exponga List.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/di/container.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/vehicle/vehicle_document_status.dart';
import '../../controllers/session_context_controller.dart';
import '../../widgets/asset_document_context_header.dart';
import 'asset_rtm_helpers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ESTADO INTERNO DE CARGA
// ─────────────────────────────────────────────────────────────────────────────

/// Estado discriminado de carga de la página.
///
/// Cada valor representa una condición única y bien definida.
/// Evita colapsar "sin datos RTM" con "error de carga" o "argumento inválido".
enum _PageState {
  /// Carga en curso.
  loading,

  /// Get.arguments no era un assetId String válido.
  /// No debería ocurrir en flujos normales; el tile RTM siempre pasa _assetId.
  invalidArg,

  /// getAssetDetails() lanzó excepción, o devolvió vehiculo == null.
  /// vehiculo == null indica que la especialización vehicular no existe en Isar.
  loadError,

  /// Activo vehicular cargado. runtMetaJson no contiene registros RTM
  /// parseables (activo registrado sin consulta RUNT, o RUNT sin datos RTM).
  noRtmData,

  /// Activo en periodo de exención RTM (rtmExemptUntil >= now, sin RTM registrada).
  /// La exención se lee del snapshot de dominio; nunca se recalcula en UI.
  exempt,

  /// Datos RTM disponibles y resueltos correctamente.
  ready,
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class RtmDetailPage extends StatefulWidget {
  const RtmDetailPage({super.key});

  @override
  State<RtmDetailPage> createState() => _RtmDetailPageState();
}

class _RtmDetailPageState extends State<RtmDetailPage> {
  VehicleDocumentStatus? _rtmDoc;
  DateTime? _rtmExemptUntil;
  _PageState _state = _PageState.loading;

  String _assetPrimaryLabel = '';
  String? _assetSecondaryLabel;

  @override
  void initState() {
    super.initState();
    _initFromArgs();
  }

  void _initFromArgs() {
    final args = Get.arguments;
    String? assetId;
    if (args is Map) {
      // Entry point: AlertCenter — labels viajan en el Map junto al assetId.
      assetId = args['assetId'] as String?;
      _assetPrimaryLabel = (args['primaryLabel'] as String?) ?? '';
      _assetSecondaryLabel = args['secondaryLabel'] as String?;
    } else if (args is String && args.isNotEmpty) {
      assetId = args;
    }
    if (assetId != null && assetId.isNotEmpty) {
      // Inicia la carga; _state permanece loading hasta que _loadRtmData complete.
      // Si veh carga OK, sus labels (veh.placa, etc.) reemplazarán los del Map.
      _loadRtmData(assetId);
    } else {
      // Asignación directa — no llamar setState dentro de initState.
      _state = _PageState.invalidArg;
    }
  }

  /// Carga [AssetVehiculoEntity] y resuelve RTM.
  ///
  /// Estados posibles tras la carga:
  /// - [_PageState.loadError]: excepción o vehiculo == null.
  /// - [_PageState.noRtmData]: vehiculo cargado, sin registros RTM parseables.
  /// - [_PageState.ready]: RTM resuelto correctamente.
  Future<void> _loadRtmData(String assetId) async {
    try {
      final details =
          await DIContainer().assetRepository.getAssetDetails(assetId);

      if (!mounted) return;

      final veh = details.vehiculo;
      if (veh == null) {
        // La especialización vehicular no existe en Isar para este assetId.
        // Es un error de estructura, no un "sin datos RTM".
        setState(() => _state = _PageState.loadError);
        return;
      }

      _assetPrimaryLabel = veh.placa;
      _assetSecondaryLabel =
          buildVehicleSecondaryLabel(veh.marca, veh.modelo, veh.anio);

      final rtm = parseRtmFromMetaJson(veh.runtMetaJson);

      // ORDEN OBLIGATORIO: exempt → ready → noRtmData.
      if (rtm != null) {
        setState(() {
          _rtmDoc = rtm;
          _state = _PageState.ready;
        });
        return;
      }

      // Sin RTM — consultar snapshot de dominio para rtmExemptUntil.
      // No recalcular: la lógica de exención vive en AssetAlertSnapshotAssembler.
      final orgId = Get.find<SessionContextController>()
          .activeWorkspaceContext.value?.orgId;

      if (orgId != null) {
        final snapshot = await DIContainer()
            .assetAlertSnapshotAssembler
            .assemble(assetId: assetId, orgId: orgId);

        if (!mounted) return;

        final exemptUntil = snapshot?.rtmExemptUntil;
        if (exemptUntil != null &&
            exemptUntil.isAfter(DateTime.now().toUtc())) {
          setState(() {
            _rtmExemptUntil = exemptUntil;
            _state = _PageState.exempt;
          });
          return;
        }
      }

      if (!mounted) return;
      setState(() => _state = _PageState.noRtmData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RTM_DETAIL][_loadRtmData] Error al cargar datos RTM '
            'para assetId=$assetId: $e');
      }
      if (!mounted) return;
      setState(() => _state = _PageState.loadError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
          tooltip: 'Volver',
        ),
        title: Text(
          'Rev. Técnico-Mecánica',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_assetPrimaryLabel.isNotEmpty)
            AssetDocumentContextHeader(
              primaryLabel: _assetPrimaryLabel,
              secondaryLabel: _assetSecondaryLabel,
              sectionTitle: 'Revisión Técnico-Mecánica',
            ),
          Expanded(
            child: switch (_state) {
              _PageState.loading => const _LoadingState(),
              _PageState.invalidArg => const _InvalidArgState(),
              _PageState.loadError => const _LoadErrorState(),
              _PageState.exempt =>
                _RtmExemptState(exemptUntil: _rtmExemptUntil!),
              _PageState.noRtmData => const _NoRtmDataState(),
              _PageState.ready =>
                _RtmContent(rtm: _rtmDoc!, cs: cs, theme: theme),
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENT — Datos RTM reales
// ─────────────────────────────────────────────────────────────────────────────

class _RtmContent extends StatelessWidget {
  final VehicleDocumentStatus rtm;
  final ColorScheme cs;
  final ThemeData theme;

  const _RtmContent({
    required this.rtm,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      children: [
        _StatusBadge(status: rtm.status, cs: cs, theme: theme),
        const SizedBox(height: AppSpacing.lg),
        _PrimaryMetricCard(rtm: rtm, cs: cs, theme: theme),
        const SizedBox(height: AppSpacing.md),
        _DetailsCard(rtm: rtm, cs: cs, theme: theme),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final DocumentValidityStatus status;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatusBadge({
    required this.status,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      DocumentValidityStatus.vigente => ('Vigente', cs.tertiary),
      DocumentValidityStatus.porVencer => ('Por vencer', cs.secondary),
      DocumentValidityStatus.vencido => ('Vencida', cs.error),
      DocumentValidityStatus.desconocido => (
          'Sin información',
          cs.onSurfaceVariant
        ),
    };

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.38)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fact_check_outlined, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIMARY METRIC CARD — Countdown principal
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryMetricCard extends StatelessWidget {
  final VehicleDocumentStatus rtm;
  final ColorScheme cs;
  final ThemeData theme;

  const _PrimaryMetricCard({
    required this.rtm,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final days = rtm.daysToExpire;

    final String headline = switch (days) {
      null => 'Sin fecha de vencimiento',
      < 0 => 'Vencida hace ${days.abs()} ${days.abs() == 1 ? "día" : "días"}',
      0 => 'Vence hoy',
      1 => 'Vence en 1 día',
      _ => 'Vence en $days días',
    };

    final Color headlineColor = switch (rtm.status) {
      DocumentValidityStatus.vigente => cs.tertiary,
      DocumentValidityStatus.porVencer => cs.secondary,
      DocumentValidityStatus.vencido => cs.error,
      DocumentValidityStatus.desconocido => cs.onSurfaceVariant,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: headlineColor.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de vigencia',
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            headline,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: headlineColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DETAILS CARD — Fechas, proveedor, certificado
// ─────────────────────────────────────────────────────────────────────────────

class _DetailsCard extends StatelessWidget {
  final VehicleDocumentStatus rtm;
  final ColorScheme cs;
  final ThemeData theme;

  const _DetailsCard({
    required this.rtm,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy', 'es_CO');

    final rows = <(IconData, String, String?)>[
      (
        Icons.event_outlined,
        'Fecha de vencimiento',
        rtm.endDate != null ? fmt.format(rtm.endDate!) : null,
      ),
      (
        Icons.event_available_outlined,
        'Fecha de expedición',
        rtm.startDate != null ? fmt.format(rtm.startDate!) : null,
      ),
      (
        Icons.business_outlined,
        'CDA / Entidad emisora',
        rtm.provider?.isNotEmpty == true ? rtm.provider : null,
      ),
      (
        Icons.numbers_outlined,
        'Número de certificado',
        rtm.referenceNumber?.isNotEmpty == true ? rtm.referenceNumber : null,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _DetailRow(
              icon: rows[i].$1,
              label: rows[i].$2,
              value: rows[i].$3,
              cs: cs,
              theme: theme,
            ),
            if (i < rows.length - 1)
              Divider(
                height: 1,
                indent: AppSpacing.md + 40,
                color: cs.outline.withValues(alpha: 0.08),
              ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final ColorScheme cs;
  final ThemeData theme;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue =
        (value != null && value!.isNotEmpty) ? value! : 'Sin información';
    final isAbsent = value == null || value!.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: cs.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayValue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isAbsent
                        ? cs.onSurfaceVariant.withValues(alpha: 0.5)
                        : cs.onSurface,
                    fontStyle: isAbsent ? FontStyle.italic : FontStyle.normal,
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

// ─────────────────────────────────────────────────────────────────────────────
// ESTADOS AUXILIARES — Cada uno representa una condición discriminada
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// [_PageState.invalidArg]: el argumento de navegación no era un assetId válido.
class _InvalidArgState extends StatelessWidget {
  const _InvalidArgState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return _CenteredMessage(
      icon: Icons.link_off_rounded,
      iconColor: cs.error,
      title: 'Navegación inválida',
      body: 'No se recibió el identificador del activo. '
          'Regresa e intenta de nuevo.',
      cs: cs,
      theme: theme,
    );
  }
}

/// [_PageState.loadError]: excepción en getAssetDetails() o vehiculo == null.
class _LoadErrorState extends StatelessWidget {
  const _LoadErrorState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return _CenteredMessage(
      icon: Icons.error_outline_rounded,
      iconColor: cs.error,
      title: 'Error al cargar el detalle RTM',
      body: 'No fue posible obtener los datos del vehículo. '
          'Intenta volver e ingresar de nuevo.',
      cs: cs,
      theme: theme,
    );
  }
}

/// [_PageState.exempt]: activo sin RTM pero dentro del periodo de exención.
///
/// La fecha [exemptUntil] proviene de [AssetAlertSnapshot.rtmExemptUntil],
/// calculada por el assembler (2 años público / 5 años particular).
/// No se recalcula aquí.
class _RtmExemptState extends StatelessWidget {
  final DateTime exemptUntil;

  const _RtmExemptState({required this.exemptUntil});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final fmt = DateFormat('d MMM yyyy', 'es_CO');
    return _CenteredMessage(
      icon: Icons.verified_outlined,
      iconColor: cs.primary,
      title: 'RTM exenta',
      body: 'Este vehículo se encuentra en periodo de exención de '
          'Revisión Técnico-Mecánica.\n\n'
          'Exenta hasta: ${fmt.format(exemptUntil.toLocal())}\n\n'
          'Fuente: RUNT',
      cs: cs,
      theme: theme,
    );
  }
}

/// [_PageState.noRtmData]: activo cargado pero sin registros RTM parseables.
///
/// Ocurre cuando el vehículo fue registrado sin consulta RUNT o el RUNT
/// no devolvió datos de revisión técnico-mecánica en ese momento.
class _NoRtmDataState extends StatelessWidget {
  const _NoRtmDataState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return _CenteredMessage(
      icon: Icons.fact_check_outlined,
      iconColor: cs.onSurfaceVariant.withValues(alpha: 0.4),
      title: 'Sin datos de RTM',
      body: 'Este vehículo no tiene registros de Revisión '
          'Técnico-Mecánica disponibles.\n\n'
          'Fuente: RUNT.',
      cs: cs,
      theme: theme,
    );
  }
}

/// Widget de mensaje centrado reutilizable para estados auxiliares.
class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final ColorScheme cs;
  final ThemeData theme;

  const _CenteredMessage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(
              onPressed: Get.back,
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
