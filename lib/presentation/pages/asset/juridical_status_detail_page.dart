// ============================================================================
// lib/presentation/pages/asset/juridical_status_detail_page.dart
// JURIDICAL STATUS DETAIL PAGE — Estado Jurídico de un activo vehicular
//
// QUÉ HACE:
// - Carga AssetVehiculoEntity desde el repositorio usando assetId recibido
//   por argumento de navegación (mismo patrón que RtmDetailPage y SegurosRcDetailPage).
// - Parsea los datos jurídicos vía parseLegalDataFromMetaJson (parse-once en
//   initState, resultado en _legalData — nunca en build()).
// - Muestra DOS bloques permanentes y explícitamente etiquetados:
//     1. "Limitaciones a la propiedad" — de runt_limitations
//     2. "Garantías y gravámenes"       — de runt_warranties + propertyLiensText
// - Ambos bloques son SIEMPRE visibles aunque estén vacíos (muestra chip
//   explícito "Sin registro RUNT").
// - Discrimina cuatro estados de carga: loading, invalidArg, loadError, ready.
//
// QUÉ NO HACE:
// - No parsea fechas a DateTime: las muestra como String fuente del RUNT.
// - No accede al RUNT en tiempo real (muestra solo lo persistido en Isar).
// - No usa GetX controller propio — StatefulWidget con carga async, consistente
//   con el patrón del módulo de activos.
// - No hardcodea colores — theme-only.
// - _StatusBanner NO deriva su estado de datos RUNT estructurales — consume
//   únicamente el resultado del pipeline canónico (legalAlerts). Así se elimina
//   la posibilidad de que el banner de estado contradiga a las alertas canónicas.
//
// PRINCIPIOS:
// - Bloques permanentes: la ausencia de datos es información, no silencio.
// - Theme-only: cero colores hardcodeados.
// - Parse-once: parseLegalDataFromMetaJson() se llama una vez en initState.
// - Fuente única de status: _StatusBanner consume legalAlerts del pipeline;
//   los bloques estructurales (Limitations, Warranties) consumen legalData RUNT.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Track B1 — Estado Jurídico. Primera implementación.
//   Complementa el tile "Estado jurídico" del grid de estado del vehículo.
// ACTUALIZADO (2026-03): Fase 3 — Alineación semántica jurídica.
//   _StatusBanner migrado de hasAnyLegalNovelty (RUNT-driven) a legalAlerts
//   (pipeline-driven). Elimina contradicción visible en escenarios con prendas,
//   garantías o limitaciones con solo fechas, donde el pipeline no emite alerta.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../core/theme/spacing.dart';
import '../../alerts/mappers/domain_alert_mapper.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';
import '../../controllers/session_context_controller.dart';
import '../../widgets/asset_document_context_header.dart';
import '../../../domain/entities/alerts/alert_code.dart';
import 'asset_legal_helpers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ESTADO INTERNO DE CARGA
// ─────────────────────────────────────────────────────────────────────────────

enum _PageState { loading, invalidArg, loadError, ready }

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class JuridicalStatusDetailPage extends StatefulWidget {
  const JuridicalStatusDetailPage({super.key});

  @override
  State<JuridicalStatusDetailPage> createState() =>
      _JuridicalStatusDetailPageState();
}

class _JuridicalStatusDetailPageState extends State<JuridicalStatusDetailPage> {
  _PageState _pageState = _PageState.loading;

  String _assetPrimaryLabel = '';
  String? _assetSecondaryLabel;

  /// Datos jurídicos parseados una sola vez en [_loadData].
  /// Nunca null una vez asignado (contrato de LegalStatusData.empty).
  LegalStatusData _legalData = LegalStatusData.empty;

  /// Alertas jurídicas canónicas del activo, filtradas del pipeline.
  ///
  /// Contiene solo [AlertCode.embargoActive] y [AlertCode.legalLimitationActive].
  /// Null mientras no ha completado la carga. Lista vacía si no hay alertas.
  List<AlertCardVm>? _legalAlerts;

  @override
  void initState() {
    super.initState();
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
      // Si veh carga OK, sus labels (veh.placa, etc.) reemplazarán los del Map.
      _loadData(assetId);
    } else {
      _pageState = _PageState.invalidArg;
    }
  }

  Future<void> _loadData(String assetId) async {
    try {
      final details =
          await DIContainer().assetRepository.getAssetDetails(assetId);
      if (!mounted) return;
      final veh = details.vehiculo;
      if (veh == null) {
        setState(() => _pageState = _PageState.loadError);
        return;
      }

      _assetPrimaryLabel = veh.placa;
      _assetSecondaryLabel =
          buildVehicleSecondaryLabel(veh.marca, veh.modelo, veh.anio);

      // Parse-once: resultado cacheado en _legalData para todo el ciclo de vida.
      final parsed = parseLegalDataFromMetaJson(
        veh.runtMetaJson,
        propertyLiens: veh.propertyLiens,
      );

      // Cargar alertas jurídicas desde el pipeline canónico.
      // Fail-silent: ante error o orgId vacío la sección de alertas queda oculta.
      List<AlertCardVm> legalVms = const [];
      final orgId =
          Get.find<SessionContextController>().user?.activeContext?.orgId ?? '';
      if (orgId.isNotEmpty) {
        final rawAlerts = await DIContainer()
            .assetComplianceAlertOrchestrator
            .evaluate(assetId: assetId, orgId: orgId);
        if (!mounted) return;
        const legalCodes = {
          AlertCode.embargoActive,
          AlertCode.legalLimitationActive,
        };
        legalVms = DomainAlertMapper.fromDomainList(rawAlerts)
            .where((vm) => legalCodes.contains(vm.code))
            .toList();
      }

      setState(() {
        _legalData = parsed;
        _legalAlerts = legalVms;
        _pageState = _PageState.ready;
      });
    } catch (e) {
      if (!mounted) return;
      if (kDebugMode) {
        debugPrint('[JuridicalStatusDetailPage][_loadData] Error: $e');
      }
      setState(() => _pageState = _PageState.loadError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Estado jurídico'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
          tooltip: 'Volver',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_assetPrimaryLabel.isNotEmpty)
            AssetDocumentContextHeader(
              primaryLabel: _assetPrimaryLabel,
              secondaryLabel: _assetSecondaryLabel,
              sectionTitle: 'Estado jurídico',
            ),
          Expanded(
            child: switch (_pageState) {
              _PageState.loading =>
                const Center(child: CircularProgressIndicator()),
              _PageState.invalidArg => const _ErrorMessage(
                  icon: Icons.link_off_rounded,
                  message: 'Argumento de navegación inválido.',
                ),
              _PageState.loadError => const _ErrorMessage(
                  icon: Icons.error_outline_rounded,
                  message: 'No se pudo cargar el estado jurídico del activo.',
                ),
              _PageState.ready => _ReadyBody(
                  legalData: _legalData,
                  legalAlerts: _legalAlerts ?? const [],
                ),
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// READY BODY
// ─────────────────────────────────────────────────────────────────────────────

class _ReadyBody extends StatelessWidget {
  final LegalStatusData legalData;

  /// Alertas jurídicas canónicas del pipeline (embargoActive, legalLimitationActive).
  ///
  /// Lista vacía si el pipeline no produjo alertas para este activo.
  final List<AlertCardVm> legalAlerts;

  const _ReadyBody({required this.legalData, required this.legalAlerts});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      children: [
        // Alertas canónicas del pipeline — solo jurídicas (embargo + limitación).
        // Visible únicamente si el pipeline emitió alertas para este activo.
        if (legalAlerts.isNotEmpty) ...[
          _LegalAlertsBanner(alerts: legalAlerts),
          const SizedBox(height: AppSpacing.md),
        ],

        // Banner de estado canónico derivado del pipeline — siempre visible.
        // Consume legalAlerts (no legalData) para evitar contradicción visual.
        _StatusBanner(legalAlerts: legalAlerts),
        const SizedBox(height: AppSpacing.lg),

        // BLOQUE 1 — Limitaciones a la propiedad (siempre visible).
        _LimitationsBlock(limitations: legalData.limitations),
        const SizedBox(height: AppSpacing.lg),

        // BLOQUE 2 — Garantías y gravámenes (siempre visible).
        _WarrantiesBlock(
          warranties: legalData.warranties,
          propertyLiensText: legalData.propertyLiensText,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEGAL ALERTS BANNER — Alertas canónicas del pipeline (jurídicas)
// ─────────────────────────────────────────────────────────────────────────────

/// Banner de alertas jurídicas canónicas.
///
/// Solo renderiza alertas con código [AlertCode.embargoActive] o
/// [AlertCode.legalLimitationActive], previamente filtradas por [_ReadyBody].
/// Alimentado exclusivamente por [DomainAlertMapper] — nunca por strings crudos.
class _LegalAlertsBanner extends StatelessWidget {
  final List<AlertCardVm> alerts;

  const _LegalAlertsBanner({required this.alerts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Icon(Icons.gavel_rounded, size: 16, color: cs.error),
                const SizedBox(width: 6),
                Text(
                  'Alertas jurídicas activas',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onErrorContainer,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${alerts.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onError,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: cs.error.withValues(alpha: 0.15)),
          ...alerts.map(
            (alert) => Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle, size: 5, color: cs.error),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (alert.subtitle != null)
                          Text(
                            alert.subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onErrorContainer.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BANNER DE ESTADO CANÓNICO
// ─────────────────────────────────────────────────────────────────────────────

/// Banner de estado jurídico canónico — siempre visible.
///
/// Consume [legalAlerts] del pipeline (embargoActive, legalLimitationActive),
/// NO los datos estructurales RUNT. Esto garantiza que el estado visible sea
/// siempre coherente con las alertas canónicas: si el pipeline no emite alerta,
/// el banner no puede decir "hay novedad" (y viceversa).
///
/// Los datos RUNT estructurales (prendas, garantías, limitaciones con solo
/// fechas) se muestran en [_LimitationsBlock] y [_WarrantiesBlock] — no aquí.
class _StatusBanner extends StatelessWidget {
  /// Alertas jurídicas canónicas ya filtradas del pipeline.
  /// Vacío = sin alertas activas (independientemente de lo que reporta el RUNT).
  final List<AlertCardVm> legalAlerts;

  const _StatusBanner({required this.legalAlerts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    // Estado canónico: proviene del pipeline, no de datos RUNT estructurales.
    final hasAlerts = legalAlerts.isNotEmpty;

    final color = hasAlerts ? cs.error : cs.tertiary;
    final icon = hasAlerts ? Icons.gavel_rounded : Icons.verified_outlined;
    final title = hasAlerts
        ? 'Alertas jurídicas activas'
        : 'Sin alertas jurídicas activas';
    final String subtitle;
    if (hasAlerts) {
      final n = legalAlerts.length;
      subtitle =
          '$n alerta${n == 1 ? '' : 's'} detectada${n == 1 ? '' : 's'} por el sistema';
    } else {
      subtitle = 'El sistema no detectó alertas jurídicas para este activo';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
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
// BLOQUE 1 — LIMITACIONES A LA PROPIEDAD
// ─────────────────────────────────────────────────────────────────────────────

class _LimitationsBlock extends StatelessWidget {
  final List<LimitationItem> limitations;

  const _LimitationsBlock({required this.limitations});

  @override
  Widget build(BuildContext context) {
    return _Block(
      title: 'Limitaciones a la propiedad',
      icon: Icons.lock_outline_rounded,
      child: limitations.isEmpty
          ? const _NoDataChip(label: 'Sin registro RUNT de limitaciones')
          : Column(
              children:
                  limitations.map((l) => _LimitationCard(item: l)).toList(),
            ),
    );
  }
}

class _LimitationCard extends StatelessWidget {
  final LimitationItem item;

  const _LimitationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _ItemCard(
      children: [
        if (item.limitationType != null)
          _Field(label: 'Tipo', value: item.limitationType!),
        if (item.legalEntity != null)
          _Field(label: 'Entidad jurídica', value: item.legalEntity!),
        if (item.department != null)
          _Field(label: 'Departamento', value: item.department!),
        if (item.municipality != null)
          _Field(label: 'Municipio', value: item.municipality!),
        if (item.officeNumber != null)
          _Field(label: 'N.° oficio', value: '${item.officeNumber}'),
        // primaryDate resuelve automáticamente la fecha más relevante.
        if (item.primaryDate != null)
          _Field(label: 'Fecha de registro', value: item.primaryDate!),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BLOQUE 2 — GARANTÍAS Y GRAVÁMENES
// ─────────────────────────────────────────────────────────────────────────────

class _WarrantiesBlock extends StatelessWidget {
  final List<WarrantyItem> warranties;
  final String? propertyLiensText;

  const _WarrantiesBlock({
    required this.warranties,
    required this.propertyLiensText,
  });

  @override
  Widget build(BuildContext context) {
    final hasWarranties = warranties.isNotEmpty;
    final hasLiens = propertyLiensText != null;
    final isEmpty = !hasWarranties && !hasLiens;

    return _Block(
      title: 'Garantías y gravámenes',
      icon: Icons.account_balance_outlined,
      child: isEmpty
          ? const _NoDataChip(label: 'Sin registro RUNT de garantías')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasLiens) _PropertyLiensChip(text: propertyLiensText!),
                if (hasLiens && hasWarranties)
                  const SizedBox(height: AppSpacing.sm),
                if (hasWarranties)
                  ...warranties.map((w) => _WarrantyCard(item: w)),
              ],
            ),
    );
  }
}

class _WarrantyCard extends StatelessWidget {
  final WarrantyItem item;

  const _WarrantyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _ItemCard(
      children: [
        if (item.creditorName != null)
          _Field(label: 'Acreedor', value: item.creditorName!),
        if (item.creditorId != null)
          _Field(label: 'ID acreedor', value: item.creditorId!),
        if (item.registrationDate != null)
          _Field(label: 'Fecha de inscripción', value: item.registrationDate!),
        if (item.autonomousPatrimony != null)
          _Field(
              label: 'Patrimonio autónomo', value: item.autonomousPatrimony!),
        if (item.confecamaras != null)
          _Field(label: 'Confecámaras', value: item.confecamaras!),
      ],
    );
  }
}

/// Chip que muestra el texto fuente de propertyLiens del RUNT.
///
/// Muestra el valor exacto del RUNT (incluye "NO REGISTRA") para transparencia
/// total con el dato fuente. La interpretación de novedad vive en
/// LegalStatusData.hasPropertyLiensNovelties — no aquí.
class _PropertyLiensChip extends StatelessWidget {
  final String text;

  const _PropertyLiensChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS COMPARTIDOS
// ─────────────────────────────────────────────────────────────────────────────

/// Contenedor de sección con título, ícono y contenido inyectable.
class _Block extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Block({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: cs.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

/// Card de un ítem individual (limitación o garantía).
class _ItemCard extends StatelessWidget {
  final List<Widget> children;

  const _ItemCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Si no hay campos a mostrar, no renderizar nada.
    if (children.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Fila de campo etiquetado + valor.
class _Field extends StatelessWidget {
  final String label;
  final String value;

  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip de "sin datos" para un bloque vacío.
///
/// El bloque siempre es visible — este chip comunica ausencia sin silenciar
/// la sección, que es información en sí misma.
class _NoDataChip extends StatelessWidget {
  final String label;

  const _NoDataChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.remove_circle_outline_rounded,
              size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            label,
            style:
                theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de error genérica con ícono y mensaje.
class _ErrorMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _ErrorMessage({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: cs.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
