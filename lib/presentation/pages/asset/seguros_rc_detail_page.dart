// ============================================================================
// lib/presentation/pages/asset/seguros_rc_detail_page.dart
// SEGUROS RC DETAIL PAGE — Detalle agrupado de pólizas RC de un activo vehicular
//
// QUÉ HACE:
// - Carga todas las pólizas InsurancePolicyEntity del activo filtrando por
//   policyType == rcContractual y policyType == rcExtracontractual.
// - Muestra dos bloques visuales permanentes y explícitamente etiquetados:
//   "RC Contractual" y "RC Extracontractual", cada uno con su primer registro
//   según el sort determinístico del archivo (fechaFin calendario local desc
//   → createdAt desc → id desc) y su vigencia calculada dinámicamente.
// - Muestra banner de inconsistencia cuando ambos bloques tienen datos y las
//   pólizas más recientes no coinciden en fecha de vencimiento o aseguradora.
// - Muestra historial completo de cada subtipo ordenado por el mismo sort
//   determinístico.
// - Calcula vigencia por fecha calendario local (.toLocal()) para evitar
//   off-by-one por timezone/UTC.
//
// QUÉ NO HACE:
// - No muestra pólizas SOAT ni de otro tipo.
// - No calcula vigencia desde el campo estado (puede estar stale).
// - No accede al RUNT en tiempo real.
// - No muestra banner de inconsistencia si uno de los bloques está vacío
//   (el bloque vacío ya comunica por sí mismo que hay datos faltantes en RUNT).
// - No usa GetX controller propio (StatefulWidget con carga async, patrón
//   consistente con SoatDetailPage y RtmDetailPage).
//
// PRINCIPIOS:
// - StatefulWidget con _loadData() en initState y try/catch explícito.
// - Estados discriminados: loading, invalidArg, loadError, ready.
// - Vigencia calculada desde _calendarDay(fechaFin) por fecha calendario local.
// - Sort determinístico: fechaFin calendario local desc → createdAt desc → id desc.
// - Theme-only: cero colores hardcodeados.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Track A — Detail page específica para Seguros RC. Parte del
//   saneamiento del modelo de seguros. Complementa el tile Seguros RC del grid
//   de estado del vehículo en AssetDetailPage. Los dos bloques permanentes
//   permiten diagnosticar inconsistencias provenientes del RUNT.
// ACTUALIZADO (2026-04): Entry-point canónico de alertas "Riesgo patrimonial"
//   (rcExtracontractual*). DomainAlertMapper ahora enruta esos códigos a esta
//   page vía /asset/insurance/rc, y el Upsell Card actúa como puente al flujo
//   SRCE (/insurance/rc/quote/request). El branch tipado de
//   _navigateToQuoteRequest (RcQuoteRequestArgs con VehicleSnapshot) quedó
//   activo; se conserva el fallback Map minimal como defensa ante entradas
//   sin AssetDetailRuntController hidratado.
// ACTUALIZADO (2026-04): Hidratación unificada del VehicleSnapshot. Antes el
//   snapshot solo se poblaba cuando AssetDetailRuntController estaba en memoria
//   (entry canónico String). Ahora [_loadData] paraleliza fetch de pólizas +
//   AssetRepository.getAssetDetails cuando la entrada es Map (alerta), vía
//   [VehicleSnapshot.fromVehiculo]. Ambos caminos terminan en un snapshot
//   válido, por lo que el Upsell Card lleva a RcQuoteRequestPage con el CTA
//   habilitado en cualquier entry-point.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/di/container.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../../domain/entities/insurance/insurance_policy_entity.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/asset/asset_detail_runt_controller.dart';
import '../../widgets/asset_document_context_header.dart';
import '../../widgets/monetization/rc_extracontractual_upsell_card.dart';
import '../insurance/rc_quote_request_page.dart' show RcQuoteRequestArgs;

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS DE FECHA Y TEXTO
// ─────────────────────────────────────────────────────────────────────────────

/// Normaliza un DateTime a medianoche en zona horaria local.
///
/// Usamos .toLocal() antes de extraer año/mes/día para evitar el off-by-one
/// que ocurre en dispositivos en zonas horarias negativas respecto a UTC:
/// una fecha que en UTC es "2025-01-01 02:00:00Z" puede ser "2024-12-31" en
/// América/Bogotá si se accede directamente a .year/.month/.day sin toLocal().
/// Este helper se usa de forma uniforme en el sort, en la detección de
/// inconsistencia y en el cálculo de vigencia.
DateTime _calendarDay(DateTime dt) {
  final local = dt.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// Normaliza una cadena de aseguradora para comparación semántica.
///
/// Elimina espacios sobrantes y pasa a minúsculas para evitar falsos positivos
/// cuando el RUNT usa capitalización o espaciado inconsistente entre pólizas.
String _normalizeAseguradora(String s) =>
    s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

// ─────────────────────────────────────────────────────────────────────────────
// ESTADO INTERNO DE CARGA
// ─────────────────────────────────────────────────────────────────────────────

enum _PageState { loading, invalidArg, loadError, ready }

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class SegurosRcDetailPage extends StatefulWidget {
  const SegurosRcDetailPage({super.key});

  @override
  State<SegurosRcDetailPage> createState() => _SegurosRcDetailPageState();
}

class _SegurosRcDetailPageState extends State<SegurosRcDetailPage> {
  /// Pólizas RC Contractual del activo.
  /// Orden determinístico: fechaFin calendario local desc → createdAt desc → id desc.
  /// El primer elemento es el más reciente según este criterio.
  List<InsurancePolicyEntity> _rcC = [];

  /// Pólizas RC Extracontractual del activo.
  /// Orden determinístico: fechaFin calendario local desc → createdAt desc → id desc.
  /// El primer elemento es el más reciente según este criterio.
  List<InsurancePolicyEntity> _rcE = [];

  _PageState _state = _PageState.loading;

  String _assetId = '';
  String _assetPrimaryLabel = '';
  String? _assetSecondaryLabel;

  /// Snapshot del vehículo para el flujo de cotización SRCE.
  /// Null si AssetDetailRuntController no está en memoria (entrada desde AlertCenter).
  VehicleSnapshot? _vehicleSnapshotForQuote;

  @override
  void initState() {
    super.initState();
    _initFromArgs();
  }

  /// Resuelve assetId y labels desde [Get.arguments] e intenta el fast-path
  /// de hidratación vía [AssetDetailRuntController].
  ///
  /// Entradas soportadas:
  ///   - `String assetId`          → entry canónico (AssetDetailPage → RUNT → Seguros RC).
  ///     El controller RUNT está en memoria, aportamos labels y snapshot sin fetch.
  ///   - `Map{assetId, primaryLabel, secondaryLabel}` → entry desde AlertCenter /
  ///     FleetAlertDetailPage. El controller RUNT NO está en memoria; [_loadData]
  ///     hidrata el snapshot desde [AssetRepository] como puente defensivo.
  ///
  /// La separación permite que [_loadData] paralelice fetch de pólizas +
  /// carga del vehículo solo cuando es necesario.
  void _initFromArgs() {
    final args = Get.arguments;
    String? assetId;

    if (args is String && args.isNotEmpty) {
      assetId = args;
    } else if (args is Map) {
      assetId = args['assetId'] as String?;
      _assetPrimaryLabel = (args['primaryLabel'] as String?)?.trim() ?? '';
      _assetSecondaryLabel = (args['secondaryLabel'] as String?)?.trim();
    }

    if (assetId == null || assetId.isEmpty) {
      _state = _PageState.invalidArg;
      return;
    }

    _assetId = assetId;

    // Fast-path: reusar AssetDetailRuntController si ya está registrado.
    // Evita un fetch redundante al repositorio cuando la entrada viene del
    // flujo canónico (AssetDetailPage → RuntConsultPage → Seguros RC).
    try {
      final runtCtrl = Get.find<AssetDetailRuntController>();
      if (_assetPrimaryLabel.isEmpty) {
        _assetPrimaryLabel = runtCtrl.vehiclePrimaryLabel;
      }
      _assetSecondaryLabel ??= runtCtrl.vehicleSecondaryLabel;
      _vehicleSnapshotForQuote = runtCtrl.vehicleSnapshotForQuote;
    } catch (_) {
      // Controller no registrado — [_loadData] hidratará desde AssetRepository.
    }

    _loadData(assetId);
  }

  /// Navega al flujo de cotización SRCE pasando el contrato tipado.
  ///
  /// Si [_vehicleSnapshotForQuote] está hidratado (entrada canónica vía
  /// AssetDetailRuntController desde RuntConsultPage), se navega con
  /// [RcQuoteRequestArgs] tipado y la page habilita el CTA de submit.
  ///
  /// Si no está disponible (entrada residual sin controller RUNT en memoria),
  /// se navega con Map minimal — la page muestra banner de contrato inválido.
  /// Comportamiento defensivo: el error al usuario es explícito, no silencioso.
  void _navigateToQuoteRequest() {
    final snapshot = _vehicleSnapshotForQuote;

    if (snapshot == null) {
      Get.toNamed(
        Routes.rcQuoteRequest,
        arguments: {
          'assetId': _assetId,
          'primaryLabel': _assetPrimaryLabel,
          'secondaryLabel': _assetSecondaryLabel,
        },
      );
      return;
    }

    Get.toNamed(
      Routes.rcQuoteRequest,
      arguments: RcQuoteRequestArgs(
        assetId: _assetId,
        vehicleSnapshot: snapshot,
        primaryLabel: _assetPrimaryLabel.isNotEmpty ? _assetPrimaryLabel : null,
        secondaryLabel: _assetSecondaryLabel,
      ),
    );
  }

  /// Carga pólizas del activo y, si hace falta, hidrata el [VehicleSnapshot]
  /// desde el repositorio.
  ///
  /// Paraleliza ambos fetches cuando el snapshot no vino pre-cargado desde
  /// [AssetDetailRuntController] (entry desde AlertCenter). La hidratación
  /// cierra el gap que antes dejaba el CTA de cotización deshabilitado.
  Future<void> _loadData(String assetId) async {
    try {
      final insuranceRepo = DIContainer().insuranceRepository;
      final assetRepo = DIContainer().assetRepository;

      final needsHydration = _vehicleSnapshotForQuote == null;

      final policiesFuture = insuranceRepo.fetchPoliciesByAsset(assetId);
      final detailsFuture =
          needsHydration ? assetRepo.getAssetDetails(assetId) : null;

      final all = await policiesFuture;
      final details = await detailsFuture;

      if (!mounted) return;

      if (details?.vehiculo != null) {
        _hydrateFromVehiculo(details!.vehiculo!);
      }

      final rcC = all
          .where((p) => p.policyType == InsurancePolicyType.rcContractual)
          .toList();
      final rcE = all
          .where((p) => p.policyType == InsurancePolicyType.rcExtracontractual)
          .toList();

      _sortRc(rcC);
      _sortRc(rcE);

      setState(() {
        _rcC = rcC;
        _rcE = rcE;
        _state = _PageState.ready;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SEGUROS_RC_DETAIL][_loadData] Error: $e');
      }
      if (!mounted) return;
      setState(() => _state = _PageState.loadError);
    }
  }

  /// Hidrata [VehicleSnapshot] y labels desde una [AssetVehiculoEntity].
  ///
  /// Mantiene paridad semántica con
  /// [AssetDetailRuntController.updateFromVehiculo]: ambos caminos construyen
  /// el snapshot vía [VehicleSnapshot.fromVehiculo]. Los labels provenientes
  /// del Map (entry alerta) tienen precedencia: solo se rellenan los vacíos.
  void _hydrateFromVehiculo(AssetVehiculoEntity vehiculo) {
    _vehicleSnapshotForQuote = VehicleSnapshot.fromVehiculo(vehiculo);

    if (_assetPrimaryLabel.isEmpty && vehiculo.placa.isNotEmpty) {
      _assetPrimaryLabel = vehiculo.placa;
    }
    _assetSecondaryLabel ??= buildVehicleSecondaryLabel(
      vehiculo.marca,
      vehiculo.modelo,
      vehiculo.anio,
    );
  }

  /// Sort determinístico para listas de pólizas RC.
  ///
  /// Orden de criterios:
  ///   1° fechaFin por día calendario local descendente — criterio principal.
  ///   2° createdAt descendente — tiebreaker cuando dos pólizas vencen el mismo
  ///      día calendario local.
  ///   3° id descendente — fallback absoluto que garantiza orden estable entre
  ///      runs aunque dos pólizas compartan fechaFin y createdAt.
  ///
  /// createdAt puede ser null en registros anteriores al campo. En ese caso se
  /// usa DateTime.fromMillisecondsSinceEpoch(0) como sentinel de antigüedad
  /// máxima para que queden al final del grupo.
  void _sortRc(List<InsurancePolicyEntity> list) {
    list.sort((a, b) {
      // 1° fecha calendario local descendente
      final cmp = _calendarDay(b.fechaFin).compareTo(_calendarDay(a.fechaFin));
      if (cmp != 0) return cmp;

      // 2° createdAt descendente — null → antigüedad máxima (sentinel)
      final createdA =
          a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      final createdB =
          b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      final cmpCreated = createdB.compareTo(createdA);
      if (cmpCreated != 0) return cmpCreated;

      // 3° id descendente — fallback absoluto
      return b.id.compareTo(a.id);
    });
  }

  /// Detecta inconsistencia entre el primer elemento de cada lista.
  ///
  /// "Primer elemento" = póliza más reciente según el sort determinístico.
  ///
  /// Solo aplica cuando AMBAS listas tienen al menos un elemento. Si uno de los
  /// bloques está vacío, no se muestra banner — el bloque vacío ya comunica
  /// por sí mismo que hay datos faltantes en RUNT.
  bool _hasInconsistency() {
    if (_rcC.isEmpty || _rcE.isEmpty) return false;

    final latestC = _rcC.first;
    final latestE = _rcE.first;

    final sameDate =
        _calendarDay(latestC.fechaFin) == _calendarDay(latestE.fechaFin);
    final sameAseg = _normalizeAseguradora(latestC.aseguradora) ==
        _normalizeAseguradora(latestE.aseguradora);

    return !sameDate || !sameAseg;
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
          'Seguros RC',
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
              sectionTitle: 'Responsabilidad Civil',
            ),
          Expanded(
            child: switch (_state) {
              _PageState.loading => const _LoadingState(),
              _PageState.invalidArg => _MessageState(
                  icon: Icons.link_off_rounded,
                  iconColor: cs.error,
                  title: 'Navegación inválida',
                  body: 'No se recibió el identificador del activo. '
                      'Regresa e intenta de nuevo.',
                ),
              _PageState.loadError => _MessageState(
                  icon: Icons.error_outline_rounded,
                  iconColor: cs.error,
                  title: 'Error al cargar',
                  body: 'No fue posible obtener las pólizas de Seguros RC. '
                      'Intenta volver e ingresar de nuevo.',
                ),
              _PageState.ready => _RcContent(
                  rcC: _rcC,
                  rcE: _rcE,
                  hasInconsistency: _hasInconsistency(),
                  onQuoteRequest: _navigateToQuoteRequest,
                  cs: cs,
                  theme: theme,
                ),
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENT — Dos bloques permanentes + historial + banner de inconsistencia
// ─────────────────────────────────────────────────────────────────────────────

class _RcContent extends StatelessWidget {
  final List<InsurancePolicyEntity> rcC;
  final List<InsurancePolicyEntity> rcE;
  final bool hasInconsistency;
  final VoidCallback onQuoteRequest;
  final ColorScheme cs;
  final ThemeData theme;

  const _RcContent({
    required this.rcC,
    required this.rcE,
    required this.hasInconsistency,
    required this.onQuoteRequest,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // El primer elemento de cada lista es el más reciente según el sort
    // determinístico. Los elementos restantes forman el historial del subtipo.
    final histC = rcC.skip(1).toList();
    final histE = rcE.skip(1).toList();
    final hasHistory = histC.isNotEmpty || histE.isNotEmpty;

    // Upsell visible cuando rcE está vacío o la póliza más reciente está vencida.
    // Mismo criterio de vencimiento que _PolicyCard: _calendarDay(fechaFin) < hoy.
    final showUpsell = rcE.isEmpty ||
        _calendarDay(rcE.first.fechaFin).isBefore(_calendarDay(DateTime.now()));

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      children: [
        // Banner de inconsistencia — solo visible cuando ambos bloques tienen
        // datos y sus pólizas más recientes difieren en fecha de vencimiento
        // o aseguradora. No aparece si uno de los bloques está vacío.
        if (hasInconsistency) ...[
          _InconsistencyBanner(cs: cs, theme: theme),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Bloque RC Contractual ────────────────────────────────────────────
        _SectionLabel(label: 'RC Contractual', cs: cs, theme: theme),
        const SizedBox(height: AppSpacing.sm),
        rcC.isEmpty
            ? _NoDataChip(
                subtypeLabel: 'RC Contractual',
                cs: cs,
                theme: theme,
              )
            : _PolicyCard(
                policy: rcC.first,
                isHighlighted: true,
                cs: cs,
                theme: theme,
              ),

        const SizedBox(height: AppSpacing.lg),

        // ── Bloque RC Extracontractual ───────────────────────────────────────
        _SectionLabel(label: 'RC Extracontractual', cs: cs, theme: theme),
        const SizedBox(height: AppSpacing.sm),
        rcE.isEmpty
            ? _NoDataChip(
                subtypeLabel: 'RC Extracontractual',
                cs: cs,
                theme: theme,
              )
            : _PolicyCard(
                policy: rcE.first,
                isHighlighted: true,
                cs: cs,
                theme: theme,
              ),

        // ── Upsell RC Extracontractual ───────────────────────────────────────
        // Visible cuando rcE está vacío o la póliza más reciente está vencida.
        // El snapshot se valida en la request page, no aquí.
        if (showUpsell) ...[
          const SizedBox(height: AppSpacing.md),
          RcExtracontractualUpsellCard(
            onTap: onQuoteRequest,
          ),
        ],

        // ── Historial ────────────────────────────────────────────────────────
        if (hasHistory) ...[
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(label: 'Historial', cs: cs, theme: theme),
          if (histC.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _SubHistoryLabel(label: 'RC Contractual', cs: cs, theme: theme),
            const SizedBox(height: AppSpacing.xs),
            for (final p in histC) ...[
              _PolicyCard(
                  policy: p, isHighlighted: false, cs: cs, theme: theme),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
          if (histE.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _SubHistoryLabel(
                label: 'RC Extracontractual', cs: cs, theme: theme),
            const SizedBox(height: AppSpacing.xs),
            for (final p in histE) ...[
              _PolicyCard(
                  policy: p, isHighlighted: false, cs: cs, theme: theme),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INCONSISTENCY BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _InconsistencyBanner extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _InconsistencyBanner({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: cs.onSecondaryContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Las pólizas más recientes de RC Contractual y RC Extracontractual '
              'no coinciden en fecha de vencimiento o aseguradora. '
              'Revisa la información consultada en RUNT.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POLICY CARD — Tarjeta individual de póliza RC
// ─────────────────────────────────────────────────────────────────────────────

class _PolicyCard extends StatelessWidget {
  final InsurancePolicyEntity policy;
  final bool isHighlighted;
  final ColorScheme cs;
  final ThemeData theme;

  const _PolicyCard({
    required this.policy,
    required this.isHighlighted,
    required this.cs,
    required this.theme,
  });

  /// Calcula vigencia por fecha calendario local.
  ///
  /// Usa _calendarDay() tanto para hoy como para fechaFin, el mismo helper que
  /// usa el sort y la detección de inconsistencia, garantizando coherencia total.
  _VigenciaInfo _resolveVigencia() {
    final hoy = _calendarDay(DateTime.now());
    final fin = _calendarDay(policy.fechaFin);
    final days = fin.difference(hoy).inDays;

    if (days < 0) {
      return _VigenciaInfo(
        label: 'Vencida hace ${days.abs()} día${days.abs() == 1 ? '' : 's'}',
        badgeText: 'Vencida',
        color: cs.error,
      );
    }
    if (days == 0) {
      return _VigenciaInfo(
        label: 'Vence hoy',
        badgeText: 'Por vencer',
        color: cs.secondary,
      );
    }
    if (days <= 30) {
      return _VigenciaInfo(
        label: 'Vence en $days día${days == 1 ? '' : 's'}',
        badgeText: 'Por vencer',
        color: cs.secondary,
      );
    }
    return _VigenciaInfo(
      label: 'Vence en $days días',
      badgeText: 'Vigente',
      color: cs.tertiary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy', 'es_CO');
    final vigencia = _resolveVigencia();
    final aseguradoraDisplay = policy.aseguradora.trim().isNotEmpty
        ? policy.aseguradora.trim()
        : 'Sin datos de aseguradora';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color:
            isHighlighted ? cs.surfaceContainerLow : cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? vigencia.color.withValues(alpha: 0.25)
              : cs.outline.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aseguradora + badge de estado
          Row(
            children: [
              Expanded(
                child: Text(
                  aseguradoraDisplay,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              _StatusBadge(
                  label: vigencia.badgeText,
                  color: vigencia.color,
                  theme: theme),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Días restantes / vencida
          Text(
            vigencia.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: vigencia.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Fechas — .toLocal() para evitar corrimiento por UTC al renderizar
          _DateRow(
            icon: Icons.event_available_outlined,
            label: 'Inicio',
            value: fmt.format(policy.fechaInicio.toLocal()),
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 4),
          _DateRow(
            icon: Icons.event_outlined,
            label: 'Vencimiento',
            value: fmt.format(policy.fechaFin.toLocal()),
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  const _SectionLabel(
      {required this.label, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SubHistoryLabel extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  const _SubHistoryLabel(
      {required this.label, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Chip de ausencia de datos — específico por subtipo para mayor claridad diagnóstica.
///
/// El parámetro [subtypeLabel] produce mensajes como:
///   "Sin información de RUNT para RC Contractual"
///   "Sin información de RUNT para RC Extracontractual"
class _NoDataChip extends StatelessWidget {
  final String subtypeLabel;
  final ColorScheme cs;
  final ThemeData theme;

  const _NoDataChip({
    required this.subtypeLabel,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 16,
            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Sin información de RUNT para $subtypeLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final ThemeData theme;

  const _StatusBadge(
      {required this.label, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style:
              theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

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

class _MessageState extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _MessageState({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
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

// ─────────────────────────────────────────────────────────────────────────────
// VALUE OBJECT INTERNO — datos de vigencia calculada
// ─────────────────────────────────────────────────────────────────────────────

class _VigenciaInfo {
  final String label;
  final String badgeText;
  final Color color;

  const _VigenciaInfo({
    required this.label,
    required this.badgeText,
    required this.color,
  });
}
