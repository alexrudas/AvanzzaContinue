// ============================================================================
// lib/presentation/pages/portfolio/wizard/runt_query_result_page.dart
//
// RUNT QUERY RESULT PAGE — Enterprise 2026
//
// Propósito: Ficha RUNT previa al registro del vehículo en Avanzza.
// Identifica el vehículo, muestra estado legal/documental y permite importarlo.
//
// ORDEN DE PANTALLA
//   1.  Vehicle Summary             (header — no expandible)
//   2.  Metadata de consulta        (2 líneas pequeñas)
//   3.  Estado del activo           (resumen legal — no expandible)
//   4.  SOAT                        (expandible · accordion)
//   5.  RC Contractual              (expandible · accordion)
//   6.  RC Extracontractual         (expandible · accordion)
//   7.  Revisión técnico-mecánica   (expandible · accordion)
//   8.  Limitaciones a la propiedad (expandible · accordion)
//   9.  Garantías                   (expandible · accordion)
//  10.  Identificación del vehículo (expandible · accordion)
//  11.  Datos técnicos              (expandible · accordion)
//  12.  Registro                    (expandible · accordion)
//  13.  CTA: Registrar / Nueva consulta / Volver
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_routes.dart';
import '../../../controllers/runt/runt_query_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class RuntQueryResultPage extends StatefulWidget {
  const RuntQueryResultPage({super.key});

  @override
  State<RuntQueryResultPage> createState() => _RuntQueryResultPageState();
}

class _RuntQueryResultPageState extends State<RuntQueryResultPage> {
  late final RuntQueryController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<RuntQueryController>();
  }

  Future<void> _confirmBackToForm() async {
    final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('¿Volver al formulario?'),
            content: const Text(
              'Puedes regresar al formulario sin perder esta consulta. '
              'La información permanecerá disponible mientras no inicies una nueva consulta.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('SEGUIR AQUÍ'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('VOLVER'),
              ),
            ],
          ),
        ) ??
        false;

    if (!mounted) return;
    if (shouldLeave) {
      Get.until((r) => r.settings.name == Routes.createPortfolioStep2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _confirmBackToForm();
      },
      child: Scaffold(
        backgroundColor: colors.surfaceContainerLow,
        appBar: AppBar(
          title: const Text('Ficha técnica RUNT'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: colors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'Volver al formulario',
              onPressed: _confirmBackToForm,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        body: Obx(() {
          final data = _ctrl.vehicleData.value;
          if (data == null || data.isEmpty) {
            return _EmptyResultView(
              onBackToForm: () => Get.until(
                  (r) => r.settings.name == Routes.createPortfolioStep2),
            );
          }
          return _ResultView(data: data, ctrl: _ctrl);
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESULT VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _ResultView extends StatefulWidget {
  final Map<String, dynamic> data;
  final RuntQueryController ctrl;

  const _ResultView({required this.data, required this.ctrl});

  @override
  State<_ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<_ResultView> {
  // Accordion: expansión exclusiva para 9 cards expandibles.
  // Índices: 0=SOAT, 1=RC Contractual, 2=RC Extracontractual,
  //          3=RTM, 4=Limitaciones, 5=Garantías,
  //          6=Identidad, 7=Datos técnicos, 8=Registro
  final List<ExpansionTileController> _tiles =
      List.generate(9, (_) => ExpansionTileController());

  /// Colapsa todas las cards excepto la de [index].
  void _onExpanded(int index) {
    for (int i = 0; i < _tiles.length; i++) {
      if (i != index) {
        try {
          _tiles[i].collapse();
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final ctrl = widget.ctrl;

    // ── Secciones estructuradas ───────────────────────────────────────────
    final vs = _map(data['vehicleSpecs']);
    final vi = _map(data['vehicleIdentity']);
    final vr = _map(data['vehicleRegistration']);
    final vtd = _map(data['vehicleTechnicalData']);

    // ── Listas operativas ─────────────────────────────────────────────────
    final soatList = _list(data['soatItems']);
    final rtmList = _list(data['revisionTecnicaItems']);
    final limList = _list(data['limitacionesPropiedad']);
    final garList = _list(data['garantias']);
    final rcList = _list(data['segurosRc']);

    // ── Registros más recientes ───────────────────────────────────────────
    final latestSoat = _latestItem(soatList, 'fechaFinVigencia');
    final latestRtm = _latestItem(rtmList, 'fechaVigencia');
    final firstLim = limList.isNotEmpty ? _map(limList.first) : null;
    final firstGar = garList.isNotEmpty ? _map(garList.first) : null;
    final rcContractualItem = _latestRc(rcList, 'contractual');
    final rcExtracontractualItem = _latestRc(rcList, 'extracontractual');

    // ── Vigencia ──────────────────────────────────────────────────────────
    final soatStatus = _computeVigenciaStatus(latestSoat?['fechaFinVigencia']);
    final rtmStatus = _computeVigenciaStatus(latestRtm?['fechaVigencia']);
    final limStatus =
        limList.isEmpty ? _VigenciaStatus.vigente : _VigenciaStatus.vencido;
    final garStatus =
        garList.isEmpty ? _VigenciaStatus.vigente : _VigenciaStatus.sinDatos;
    final rcConStatus =
        _computeVigenciaStatus(rcContractualItem?['fechaFinVigencia']);
    final rcExtStatus =
        _computeVigenciaStatus(rcExtracontractualItem?['fechaFinVigencia']);

    // ── Días restantes ────────────────────────────────────────────────────
    final soatDays = latestSoat != null
        ? _computeDaysRemaining(latestSoat['fechaFinVigencia'])
        : null;
    final rtmDays = latestRtm != null
        ? _computeDaysRemaining(latestRtm['fechaVigencia'])
        : null;
    final rcConDays = rcContractualItem != null
        ? _computeDaysRemaining(rcContractualItem['fechaFinVigencia'])
        : null;
    final rcExtDays = rcExtracontractualItem != null
        ? _computeDaysRemaining(rcExtracontractualItem['fechaFinVigencia'])
        : null;

    // ── Subtítulos cerrados ───────────────────────────────────────────────
    final limSubtitle = limList.isEmpty
        ? 'Sin restricciones'
        : (_strOf(firstLim, 'tipoLimitacion') ?? 'Con limitaciones');
    final garSubtitle = garList.isEmpty
        ? 'Sin garantía'
        : (_strOf(firstGar, 'acreedor') ?? 'Con garantía');

    // ── Datos para Vehicle Summary ────────────────────────────────────────
    final plate = _str(data['plate']) ?? '---';
    final brand = _str(vs?['brand'] ?? data['brand']);
    final model = _str(vs?['model'] ?? data['model']);
    // RUNT puede enviar el año como int o String bajo distintas keys; normalizar a String.
    final modelYear = _str((vs?['modelYear'] ??
            data['modelYear'] ??
            vs?['year'] ??
            data['year'] ??
            vs?['anio'] ??
            data['anio'])
        ?.toString());
    final bodyType = _str(vs?['tipoCarroceria'] ?? data['tipoCarroceria']);
    final vehicleColor = _str(vs?['color'] ?? data['color']);
    // Tipo de servicio (Público / Particular) — para color de placa y badge.
    // RUNT lo envía típicamente en vehicleRegistration.type, con fallback al mapa raíz.
    final serviceType = _str(
        vr?['type'] ?? vs?['type'] ?? data['type'] ??
        vr?['tipoServicio'] ?? data['tipoServicio']);
    // Clase de vehículo (Automóvil, Motocicleta, etc.) — sube al summary.
    final vehicleClass = _str(
        vr?['category'] ?? vs?['category'] ?? data['category'] ??
        vr?['clase'] ?? vs?['clase'] ?? data['clase']);
    final vin = _str(vi?['vin'] ?? data['vin']);
    final engine = _str(vi?['engine'] ?? data['engine']);
    final version = _str(vs?['version'] ?? vs?['trim'] ?? data['version']);
    // RUNT envía la caja como tipoCaja / tipoTransmision; se mantienen las
    // keys genéricas como fallback para compatibilidad con otros orígenes.
    final transmision = _str(vs?['tipoCaja'] ??
        vs?['tipoTransmision'] ??
        vs?['transmision'] ??
        vs?['transmission'] ??
        data['tipoCaja'] ??
        data['tipoTransmision'] ??
        data['transmision'] ??
        data['transmission']);
    final cilindraje = _str(vs?['cilindraje'] ?? data['cilindraje']);

    // ── Metadata ──────────────────────────────────────────────────────────
    final docType =
        ctrl.ownerDocumentType.value ?? _str(data['ownerDocumentType']);
    final docNumber =
        ctrl.ownerDocumentNumber.value ?? _str(data['ownerDocument']);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Vehicle Summary
        SliverToBoxAdapter(
          child: _VehicleSummary(
            plate: plate,
            brand: brand,
            model: model,
            version: version,
            modelYear: modelYear,
            transmision: transmision,
            cilindraje: cilindraje,
            bodyType: bodyType,
            vehicleColor: vehicleColor,
            vehicleClass: vehicleClass,
            serviceType: serviceType,
            vin: vin,
            engine: engine,
          ),
        ),

        // 2. Metadata de consulta
        SliverToBoxAdapter(
          child: _MetadataBlock(docType: docType, docNumber: docNumber),
        ),

        // 2b. Semáforo legal global
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _LegalBadge(
              hasLimitaciones: limList.isNotEmpty,
              hasSoatVencido: soatStatus == _VigenciaStatus.vencido,
              hasRtmVencido: rtmStatus == _VigenciaStatus.vencido,
            ),
          ),
        ),

        // 3. Estado del activo (no expandible)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _RiskOverviewCard(
              soatStatus: soatStatus,
              rcConStatus: rcConStatus,
              rcExtStatus: rcExtStatus,
              rtmStatus: rtmStatus,
              limitaciones: limList,
              garantias: garList,
            ),
          ),
        ),

        // 4. SOAT
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _OperationalCard(
              title: 'SOAT',
              status: soatStatus,
              daysRemaining: soatDays,
              closedSubtitle: _computeVigenciaSubtitle(soatStatus, soatDays),
              expandedRows: _soatExpandedRows(latestSoat),
              progressValue:
                  soatDays != null ? (soatDays / 365.0).clamp(0.0, 1.0) : null,
              controller: _tiles[0],
              onExpansionChanged: () => _onExpanded(0),
            ),
          ),
        ),

        // 5. RC Contractual
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _OperationalCard(
              title: 'RC Contractual',
              status: rcConStatus,
              daysRemaining: rcConDays,
              closedSubtitle: _computeVigenciaSubtitle(rcConStatus, rcConDays),
              expandedRows: _rcExpandedRows(rcContractualItem),
              progressValue: rcConDays != null
                  ? (rcConDays / 365.0).clamp(0.0, 1.0)
                  : null,
              controller: _tiles[1],
              onExpansionChanged: () => _onExpanded(1),
            ),
          ),
        ),

        // 6. RC Extracontractual
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _OperationalCard(
              title: 'RC Extracontractual',
              status: rcExtStatus,
              daysRemaining: rcExtDays,
              closedSubtitle: _computeVigenciaSubtitle(rcExtStatus, rcExtDays),
              expandedRows: _rcExpandedRows(rcExtracontractualItem),
              progressValue: rcExtDays != null
                  ? (rcExtDays / 365.0).clamp(0.0, 1.0)
                  : null,
              controller: _tiles[2],
              onExpansionChanged: () => _onExpanded(2),
            ),
          ),
        ),

        // 7. Revisión técnico-mecánica
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _OperationalCard(
              title: 'Revisión técnico-mecánica',
              status: rtmStatus,
              daysRemaining: rtmDays,
              closedSubtitle: _computeVigenciaSubtitle(rtmStatus, rtmDays),
              expandedRows: _rtmExpandedRows(latestRtm),
              progressValue:
                  rtmDays != null ? (rtmDays / 365.0).clamp(0.0, 1.0) : null,
              controller: _tiles[3],
              onExpansionChanged: () => _onExpanded(3),
            ),
          ),
        ),

        // 8. Limitaciones a la propiedad
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _OperationalCard(
              title: 'Limitaciones a la propiedad',
              status: limStatus,
              closedSubtitle: limSubtitle,
              expandedRows: _limExpandedRows(firstLim),
              leadingIcon: limList.isEmpty
                  ? Icons.check_circle_rounded
                  : Icons.block_rounded,
              controller: _tiles[4],
              onExpansionChanged: () => _onExpanded(4),
            ),
          ),
        ),

        // 9. Garantías
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _OperationalCard(
              title: 'Garantías',
              status: garStatus,
              closedSubtitle: garSubtitle,
              expandedRows: _garExpandedRows(firstGar),
              leadingIcon: garList.isEmpty
                  ? Icons.check_circle_rounded
                  : Icons.account_balance_rounded,
              controller: _tiles[5],
              onExpansionChanged: () => _onExpanded(5),
            ),
          ),
        ),

        // 10. Identificación del vehículo
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _DataExpandableCard(
              title: 'Identificación del vehículo',
              icon: Icons.fingerprint_rounded,
              closedSubtitle: _identidadSubtitle(vin, engine),
              expandedRows: _identidadExpandedRows(vi, data),
              controller: _tiles[6],
              onExpansionChanged: () => _onExpanded(6),
            ),
          ),
        ),

        // 11. Datos técnicos
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _DataExpandableCard(
              title: 'Datos técnicos',
              icon: Icons.tune_rounded,
              closedSubtitle: _datosTecnicosSubtitle(vs, data),
              expandedRows: _datosTecnicosExpandedRows(vs, vtd, data),
              controller: _tiles[7],
              onExpansionChanged: () => _onExpanded(7),
            ),
          ),
        ),

        // 12. Registro
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _DataExpandableCard(
              title: 'Registro',
              icon: Icons.assignment_rounded,
              closedSubtitle: _registroSubtitle(vr, data),
              expandedRows: _registroExpandedRows(vr, data),
              controller: _tiles[8],
              onExpansionChanged: () => _onExpanded(8),
            ),
          ),
        ),

        // 11. CTA
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          sliver: SliverToBoxAdapter(child: _ActionFooter(ctrl: ctrl)),
        ),
      ],
    );
  }

  // ── Filas expandidas: SOAT ───────────────────────────────────────────────

  List<_DisplayField> _soatExpandedRows(Map<String, dynamic>? item) {
    if (item == null) return [];
    return [
      _f('Estado',
          _vigenciaLabel(_computeVigenciaStatus(item['fechaFinVigencia']))),
      _f('Vence',
          _formatShortDate(item['fechaFinVigencia']) ?? 'No disponible'),
      _f(
          'Restan',
          item['fechaFinVigencia'] != null
              ? '${_computeDaysRemaining(item['fechaFinVigencia'])} días'
              : null),
      _f('Aseguradora', item['entidadExpide']),
    ];
  }

  // ── Filas expandidas: RTM ────────────────────────────────────────────────

  List<_DisplayField> _rtmExpandedRows(Map<String, dynamic>? item) {
    if (item == null) return [];
    return [
      _f('Estado',
          _vigenciaLabel(_computeVigenciaStatus(item['fechaVigencia']))),
      _f('Vence', _formatShortDate(item['fechaVigencia']) ?? 'No disponible'),
      _f(
          'Restan',
          item['fechaVigencia'] != null
              ? '${_computeDaysRemaining(item['fechaVigencia'])} días'
              : null),
      _f('CDA', item['cdaExpide']),
    ];
  }

  // ── Filas expandidas: Limitaciones ──────────────────────────────────────

  List<_DisplayField> _limExpandedRows(Map<String, dynamic>? item) {
    if (item == null) return [];
    return [
      _f('Tipo', item['tipoLimitacion']),
      _f('Entidad', item['entidadJuridica']),
      _f('Departamento', item['departamento']),
      _f('Municipio', item['municipio']),
      _f('Fecha del oficio', _fmtDate(item['fechaExpedicionOficio'])),
      _f('Fecha de registro', _fmtDate(item['fechaRegistro'])),
    ];
  }

  // ── Filas expandidas: Garantías ──────────────────────────────────────────

  List<_DisplayField> _garExpandedRows(Map<String, dynamic>? item) {
    if (item == null) return [];
    return [
      _f('Acreedor', item['acreedor']),
      _f('Identificación', item['identificacion'] ?? item['nit']),
      _f('Fecha de inscripción', _fmtDate(item['fechaInscripcion'])),
      _f('Confecámaras', item['confecamaras']),
    ];
  }

  // ── Filas expandidas: Identificación del vehículo ────────────────────────

  List<_DisplayField> _identidadExpandedRows(
      Map<String, dynamic>? vi, Map<String, dynamic> data) {
    return [
      _f('VIN', vi?['vin'] ?? data['vin']),
      _f('Motor', vi?['engine'] ?? data['engine']),
      _f('Licencia de tránsito',
          vi?['licenciaTransito'] ?? data['licenciaTransito']),
    ];
  }

  String _identidadSubtitle(String? vin, String? engine) {
    if (vin != null && vin.isNotEmpty) return 'VIN: $vin';
    if (engine != null && engine.isNotEmpty) return 'Motor: $engine';
    return 'Sin datos';
  }

  // ── Filas expandidas: Datos técnicos ─────────────────────────────────────

  List<_DisplayField> _datosTecnicosExpandedRows(Map<String, dynamic>? vs,
      Map<String, dynamic>? vtd, Map<String, dynamic> data) {
    return [
      _f('Carrocería', vs?['tipoCarroceria'] ?? data['tipoCarroceria']),
      _f('Cilindraje', vs?['cilindraje'] ?? data['cilindraje']),
      _f('Combustible', vs?['fuel'] ?? data['fuel']),
      _f('Pasajeros', data['capacity']),
      _f('Puertas', vs?['numeroPuertas'] ?? data['numeroPuertas']),
      _f('Ejes', vtd?['numeroEjes'] ?? data['numeroEjes']),
      _f('Peso bruto vehicular',
          vtd?['pesoBrutoVehicular'] ?? data['pesoBrutoVehicular']),
      _f('Capacidad de carga',
          vtd?['capacidadCarga'] ?? data['capacidadCarga']),
    ];
  }

  String _datosTecnicosSubtitle(
      Map<String, dynamic>? vs, Map<String, dynamic> data) {
    final body = _str(vs?['tipoCarroceria'] ?? data['tipoCarroceria']);
    final cc = _str(vs?['cilindraje'] ?? data['cilindraje']);
    final parts = <String>[
      if (body != null) body,
      if (cc != null) '$cc cc',
    ];
    return parts.isNotEmpty ? parts.join(' · ') : 'Sin datos';
  }

  // ── Filas expandidas: Registro ───────────────────────────────────────────

  List<_DisplayField> _registroExpandedRows(
      Map<String, dynamic>? vr, Map<String, dynamic> data) {
    final auth = _str(vr?['autoridadTransito'] ?? data['autoridadTransito']);
    return [
      _f('Autoridad de tránsito',
          auth != null ? _normalizeAuthority(auth) : null),
      _f('Fecha de matrícula',
          _fmtDate(vr?['fechaMatricula'] ?? data['fechaMatricula'])),
      _f('Estado del vehículo',
          vr?['estadoVehiculo'] ?? data['estadoVehiculo']),
      _f('Gravámenes sobre propiedad',
          vr?['gravamenesPropiedad'] ?? data['gravamenesPropiedad']),
    ];
  }

  String _registroSubtitle(
      Map<String, dynamic>? vr, Map<String, dynamic> data) {
    final raw = _str(vr?['autoridadTransito'] ?? data['autoridadTransito']);
    return raw != null ? _normalizeAuthority(raw) : 'Sin datos';
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  _DisplayField _f(String label, dynamic raw,
          {_FieldType type = _FieldType.plain}) =>
      _DisplayField(
          label: label, value: _str(raw) ?? 'No reportado', type: type);

  String? _str(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    return s.isEmpty ? null : s;
  }

  Map<String, dynamic>? _map(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.map((k, v) => MapEntry(k.toString(), v));
    return null;
  }

  List<dynamic> _list(dynamic raw) => raw is List ? raw : const [];

  String? _fmtDate(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;
    try {
      return DateFormat.yMMMMd('es_CO').format(DateTime.parse(s));
    } catch (_) {
      return s;
    }
  }

  Map<String, dynamic>? _latestItem(List<dynamic> items, String dateField) {
    Map<String, dynamic>? best;
    DateTime? bestDate;
    for (final item in items) {
      final m = _map(item);
      if (m == null) continue;
      final dt = DateTime.tryParse(m[dateField]?.toString().trim() ?? '');
      if (dt == null) continue;
      if (bestDate == null || dt.isAfter(bestDate)) {
        bestDate = dt;
        best = m;
      }
    }
    return best;
  }

  String? _strOf(Map<String, dynamic>? m, String field) {
    final v = m?[field]?.toString().trim();
    return (v != null && v.isNotEmpty) ? v : null;
  }

  // ── RC: busca el item cuyo tipoSeguro contiene [keyword] ─────────────────

  /// Busca el primer item de segurosRc cuyo [tipoPoliza] corresponde al tipo
  /// solicitado. Para contractual excluye explícitamente "extra" para evitar
  /// que "Responsabilidad Civil Extracontractual" sea capturado por ambos filtros.
  Map<String, dynamic>? _latestRc(List<dynamic> items, String keyword) {
    final kw = keyword.toLowerCase();
    for (final item in items) {
      final m = _map(item);
      if (m == null) continue;
      // Backend envía tipoPoliza (no tipoSeguro ni tipo)
      final tipo = (m['tipoPoliza'] ?? '').toString().toLowerCase();
      if (kw == 'contractual') {
        // Coincide con contractual pero NO con extracontractual
        if (tipo.contains('contractual') && !tipo.contains('extra')) return m;
      } else {
        if (tipo.contains(kw)) return m;
      }
    }
    return null;
  }

  // ── Filas expandidas: RC Contractual / RC Extracontractual ───────────────

  List<_DisplayField> _rcExpandedRows(Map<String, dynamic>? item) {
    if (item == null) return [];
    return [
      _f('Estado',
          _vigenciaLabel(_computeVigenciaStatus(item['fechaFinVigencia']))),
      _f('Vence',
          _formatShortDate(item['fechaFinVigencia']) ?? 'No disponible'),
      _f(
          'Restan',
          item['fechaFinVigencia'] != null
              ? '${_computeDaysRemaining(item['fechaFinVigencia'])} días'
              : null),
      _f('Aseguradora', item['aseguradora'] ?? item['entidadExpide']),
      _f('Número de póliza',
          item['numeroPóliza'] ?? item['numeroPoliza'] ?? item['poliza']),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE SUMMARY
// ─────────────────────────────────────────────────────────────────────────────

/// Cabecera del activo. Muestra placa prominente, nombre del vehículo,
/// carrocería/color y datos técnicos de identificación (VIN, motor).
/// No es una card expandible — siempre visible.
class _VehicleSummary extends StatelessWidget {
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

  const _VehicleSummary({
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

    // Color de placa según tipo de servicio.
    // "publico" / "público" → blanco; "particular" → amarillo; desconocido → amarillo.
    final serviceNorm = serviceType?.trim().toLowerCase() ?? '';
    final isPublico = serviceNorm.contains('public');
    final plateBackground =
        isPublico ? Colors.white : const Color(0xFFFDD835);

    // Línea 2: MARCA MODELO VERSIÓN
    final modelParts = <String>[
      if (brand != null && brand!.isNotEmpty) brand!,
      if (model != null && model!.isNotEmpty) model!,
      if (version != null && version!.isNotEmpty) version!,
    ];
    final modelLine = modelParts.join(' ').toUpperCase();

    // Badge de servicio — se muestra solo si hay valor
    final badgeLabel =
        (serviceType != null && serviceType!.trim().isNotEmpty)
            ? serviceType!.trim().toUpperCase()
            : null;

    // Línea 3: CLASE · CARROCERÍA · COLOR
    final bodyParts = <String>[
      if (vehicleClass != null && vehicleClass!.isNotEmpty) vehicleClass!,
      if (bodyType != null && bodyType!.isNotEmpty) bodyType!,
      if (vehicleColor != null && vehicleColor!.isNotEmpty) vehicleColor!,
    ];
    final bodyLine = bodyParts.join(' · ');

    // Línea 4: TRANSMISIÓN · CILINDRAJE
    final techParts = <String>[
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
          // Línea 1: Placa — color dinámico según tipo de servicio
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              color: plateBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              plate.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 6,
                fontFamily: 'monospace',
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Línea 2: MARCA MODELO VERSIÓN + badge de servicio en la misma línea
          if (modelLine.isNotEmpty || badgeLabel != null)
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
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
                if (badgeLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
              ],
            ),

          // Línea 3: CLASE · CARROCERÍA · COLOR (normal)
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

          // Línea 4: TRANSMISIÓN · CILINDRAJE (normal)
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

          // Línea 5: AÑO: XXXX
          if (modelYear != null && modelYear!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _TechLine(label: 'AÑO', value: modelYear!),
          ],

          // Línea 6: VIN
          if (vin != null) ...[
            const SizedBox(height: 4),
            _TechLine(label: 'VIN', value: vin!),
          ],

          // Línea 7: Motor
          if (engine != null) ...[
            const SizedBox(height: 4),
            _TechLine(label: 'MOTOR', value: engine!),
          ],
        ],
      ),
    );
  }
}

/// Fila de dato técnico de identificación (VIN / Motor).
class _TechLine extends StatelessWidget {
  final String label;
  final String value;

  const _TechLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        Flexible(
          child: Text(
            value.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// METADATA BLOCK
// ─────────────────────────────────────────────────────────────────────────────

/// Dos líneas pequeñas de metadata debajo del Vehicle Summary.
/// No es una card — solo texto muted informativo.
class _MetadataBlock extends StatelessWidget {
  final String? docType;
  final String? docNumber;

  const _MetadataBlock({this.docType, this.docNumber});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final docParts = <String>[
      if (docType != null && docType!.isNotEmpty) docType!,
      if (docNumber != null && docNumber!.isNotEmpty) docNumber!,
    ];
    final docLine = docParts.isNotEmpty
        ? 'Consulta realizada con ${docParts.join(' ')}'
        : null;

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
      child: Column(
        children: [
          Divider(
              height: 1, color: colors.outlineVariant.withValues(alpha: 0.4)),
          const SizedBox(height: 8),
          const _MetaRow(
            icon: Icons.verified_rounded,
            text: 'Consulta validada por RUNT',
          ),
          if (docLine != null) ...[
            const SizedBox(height: 4),
            _MetaRow(icon: Icons.badge_rounded, text: docLine),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 12, color: colors.onSurfaceVariant),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style:
                textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEGAL BADGE — Semáforo global de estado legal (lectura rápida)
// ─────────────────────────────────────────────────────────────────────────────

/// Indicador compacto de estado legal global.
/// No reemplaza la card "Estado del activo" — complementa la lectura rápida
/// entre la metadata de consulta y el resumen detallado.
class _LegalBadge extends StatelessWidget {
  final bool hasLimitaciones;
  final bool hasSoatVencido;
  final bool hasRtmVencido;

  const _LegalBadge({
    required this.hasLimitaciones,
    required this.hasSoatVencido,
    required this.hasRtmVencido,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final IconData icon;
    final String text;
    final Color color;

    if (hasLimitaciones) {
      icon = Icons.warning_amber_rounded;
      text = 'Con limitaciones registradas';
      color = colors.error;
    } else if (hasSoatVencido || hasRtmVencido) {
      icon = Icons.warning_amber_rounded;
      text = 'Documentos vencidos';
      color = colors.error;
    } else {
      icon = Icons.check_circle_outline_rounded;
      text = 'Sin restricciones registradas';
      color = colors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RISK OVERVIEW CARD — Estado del activo (no expandible)
// ─────────────────────────────────────────────────────────────────────────────

/// Resumen legal/documental del activo. No expandible.
/// Permite leer el estado en menos de 2 segundos.
class _RiskOverviewCard extends StatelessWidget {
  final _VigenciaStatus soatStatus;
  final _VigenciaStatus rcConStatus;
  final _VigenciaStatus rcExtStatus;
  final _VigenciaStatus rtmStatus;
  final List<dynamic> limitaciones;
  final List<dynamic> garantias;

  const _RiskOverviewCard({
    required this.soatStatus,
    required this.rcConStatus,
    required this.rcExtStatus,
    required this.rtmStatus,
    required this.limitaciones,
    required this.garantias,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final limText = limitaciones.isEmpty
        ? 'Sin restricciones'
        : (_firstStr(limitaciones.first, 'tipoLimitacion') ??
            'Con limitaciones');
    final garText = garantias.isEmpty
        ? 'Sin garantía'
        : (_firstStr(garantias.first, 'acreedor') ?? 'Con garantía');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Icon(Icons.shield_rounded, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'Resumen estado del activo',
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _RiskRow(
              label: 'SOAT',
              text: _vigenciaLabel(soatStatus),
              icon: _vigenciaIcon(soatStatus),
              status: soatStatus,
              showBorder: true),
          _RiskRow(
              label: 'RC Contractual',
              text: _vigenciaLabel(rcConStatus),
              icon: _vigenciaIcon(rcConStatus),
              status: rcConStatus,
              showBorder: true),
          _RiskRow(
              label: 'RC Extracontractual',
              text: _vigenciaLabel(rcExtStatus),
              icon: _vigenciaIcon(rcExtStatus),
              status: rcExtStatus,
              showBorder: true),
          _RiskRow(
              label: 'RTM',
              text: _vigenciaLabel(rtmStatus),
              icon: _vigenciaIcon(rtmStatus),
              status: rtmStatus,
              showBorder: true),
          _RiskRow(
              label: 'Limitaciones',
              text: limText,
              icon: limitaciones.isEmpty
                  ? Icons.check_circle_rounded
                  : Icons.block_rounded,
              status: limitaciones.isEmpty
                  ? _VigenciaStatus.vigente
                  : _VigenciaStatus.vencido,
              showBorder: true),
          _RiskRow(
              label: 'Garantías',
              text: garText,
              icon: garantias.isEmpty
                  ? Icons.check_circle_rounded
                  : Icons.account_balance_rounded,
              status: garantias.isEmpty
                  ? _VigenciaStatus.vigente
                  : _VigenciaStatus.sinDatos,
              showBorder: false),
        ],
      ),
    );
  }

  String? _firstStr(dynamic item, String field) {
    Map<String, dynamic>? m;
    if (item is Map<String, dynamic>) {
      m = item;
    } else if (item is Map) {
      m = item.map((k, v) => MapEntry(k.toString(), v));
    }
    final v = m?[field]?.toString().trim();
    return (v != null && v.isNotEmpty) ? v : null;
  }
}

class _RiskRow extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final _VigenciaStatus status;
  final bool showBorder;

  const _RiskRow({
    required this.label,
    required this.text,
    required this.icon,
    required this.status,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _vigenciaColor(status, colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: showBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.28)),
              ),
            )
          : null,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: textTheme.labelMedium
                    ?.copyWith(color: colors.onSurfaceVariant)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(icon, size: 15, color: statusColor),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                    style: textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
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
// OPERATIONAL CARD — expandible con estado de vigencia y barra de tiempo
// ─────────────────────────────────────────────────────────────────────────────

/// Card expandible para SOAT, RTM, Limitaciones y Garantías.
/// Participa en el accordion: [controller] colapsa/expande externamente,
/// [onExpansionChanged] notifica al padre para colapsar las demás.
class _OperationalCard extends StatelessWidget {
  final String title;
  final _VigenciaStatus status;
  final String closedSubtitle;
  final List<_DisplayField> expandedRows;

  /// Icono override (Limitaciones / Garantías). Null = deriva del status.
  final IconData? leadingIcon;

  /// Porcentaje de vigencia [0..1] para SOAT/RTM/RC. Null = sin barra.
  final double? progressValue;

  /// Días restantes para calcular el color dinámico de la barra de riesgo.
  final int? daysRemaining;

  final ExpansionTileController? controller;
  final VoidCallback? onExpansionChanged;

  const _OperationalCard({
    required this.title,
    required this.status,
    required this.closedSubtitle,
    required this.expandedRows,
    this.leadingIcon,
    this.progressValue,
    this.daysRemaining,
    this.controller,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final icon = leadingIcon ?? _vigenciaIcon(status);
    final iconColor = _vigenciaColor(status, colors);
    final barColor = daysRemaining != null
        ? _progressColor(daysRemaining!, colors)
        : iconColor;
    // Borde izquierdo usa el mismo color que la barra para coherencia visual.
    final accentColor = barColor;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Acento visual: franja izquierda del color del estado
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 4, color: accentColor),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  controller: controller,
                  onExpansionChanged: (expanded) {
                    if (expanded) onExpansionChanged?.call();
                  },
                  tilePadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  title: Text(
                    title,
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    closedSubtitle,
                    style: textTheme.bodySmall?.copyWith(
                        color: iconColor, fontWeight: FontWeight.w600),
                  ),
                  childrenPadding: EdgeInsets.zero,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _buildChildren(context, colors, textTheme, iconColor),
                ),
              ),
              // Barra de progreso siempre visible (cerrada y expandida)
              if (progressValue != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: 0.28)),
                      const SizedBox(height: 10),
                      Text(
                        'Tiempo restante de vigencia',
                        style: textTheme.labelSmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 8,
                          backgroundColor: colors.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildren(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
    Color iconColor,
  ) {
    final children = <Widget>[const Divider(height: 1)];

    if (expandedRows.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.inbox_rounded, size: 18, color: colors.outline),
              const SizedBox(width: 8),
              Text('Sin registros',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant)),
            ],
          ),
        ),
      );
      return children;
    }

    for (int i = 0; i < expandedRows.length; i++) {
      children.add(_InfoRow(
        field: expandedRows[i],
        showBottomBorder: i < expandedRows.length - 1,
      ));
    }

    return children;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA EXPANDABLE CARD — expandible para datos de identificación / técnicos
// ─────────────────────────────────────────────────────────────────────────────

/// Card expandible de datos informativos (Identificación, Datos técnicos,
/// Registro). Sin estado de vigencia ni barra de progreso.
/// Participa en el accordion via [controller] / [onExpansionChanged].
class _DataExpandableCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String closedSubtitle;
  final List<_DisplayField> expandedRows;
  final ExpansionTileController? controller;
  final VoidCallback? onExpansionChanged;

  const _DataExpandableCard({
    required this.title,
    required this.icon,
    required this.closedSubtitle,
    required this.expandedRows,
    this.controller,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconColor = colors.secondary;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: controller,
          onExpansionChanged: (expanded) {
            if (expanded) onExpansionChanged?.call();
          },
          tilePadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            closedSubtitle,
            style:
                textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: _buildChildren(context, colors, textTheme),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(
      BuildContext context, ColorScheme colors, TextTheme textTheme) {
    final children = <Widget>[const Divider(height: 1)];

    if (expandedRows.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.inbox_rounded, size: 18, color: colors.outline),
              const SizedBox(width: 8),
              Text('Sin datos disponibles',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant)),
            ],
          ),
        ),
      );
      return children;
    }

    for (int i = 0; i < expandedRows.length; i++) {
      children.add(_InfoRow(
        field: expandedRows[i],
        showBottomBorder: i < expandedRows.length - 1,
      ));
    }

    return children;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIELD ROW
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final _DisplayField field;
  final bool showBottomBorder;

  const _InfoRow({required this.field, required this.showBottomBorder});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateStyle = _dateSemantic(field.value, colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.28),
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(field.label,
                style: textTheme.labelMedium
                    ?.copyWith(color: colors.onSurfaceVariant)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildValue(context, textTheme, colors, dateStyle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValue(BuildContext context, TextTheme textTheme,
      ColorScheme colors, _DateSemanticStyle? dateStyle) {
    switch (field.type) {
      case _FieldType.statusOk:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            field.value,
            style: textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.end,
          ),
        );
      case _FieldType.date:
        return Text(
          field.value.toUpperCase(),
          textAlign: TextAlign.end,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: dateStyle?.color ?? colors.onSurface,
          ),
        );
      case _FieldType.plain:
        return Text(
          field.value.toUpperCase(),
          textAlign: TextAlign.end,
          style: textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
        );
    }
  }

  _DateSemanticStyle? _dateSemantic(String value, ColorScheme colors) {
    for (final fmt in [
      'dd/MM/yyyy',
      'yyyy-MM-dd',
      'yyyy/MM/dd',
      'dd-MM-yyyy'
    ]) {
      try {
        final date = DateFormat(fmt).parseStrict(value);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final target = DateTime(date.year, date.month, date.day);
        if (target.isBefore(today)) {
          return _DateSemanticStyle(color: colors.error);
        }
        if (target.difference(today).inDays <= 30) {
          return _DateSemanticStyle(color: colors.tertiary);
        }
        return null;
      } catch (_) {}
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION FOOTER
// ─────────────────────────────────────────────────────────────────────────────

class _ActionFooter extends StatelessWidget {
  final RuntQueryController ctrl;

  const _ActionFooter({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: () => Get.until(
                (r) => r.settings.name == Routes.createPortfolioStep2),
            icon: const Icon(Icons.check_rounded),
            label: const Text('REGISTRAR VEHÍCULO EN AVANZZA'),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () async {
              await ctrl.clearQueryState();
              Get.until((r) => r.settings.name == Routes.createPortfolioStep2);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('NUEVA CONSULTA'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () =>
              Get.until((r) => r.settings.name == Routes.createPortfolioStep2),
          child: const Text('VOLVER AL FORMULARIO'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyResultView extends StatelessWidget {
  final VoidCallback onBackToForm;

  const _EmptyResultView({required this.onBackToForm});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 78, color: colors.outline),
            const SizedBox(height: 18),
            Text(
              'No se obtuvieron resultados',
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'La consulta finalizó sin información utilizable. Regresa al formulario y vuelve a intentarlo.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant, height: 1.45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onBackToForm,
              child: const Text('VOLVER AL FORMULARIO'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIPOS DE SOPORTE
// ─────────────────────────────────────────────────────────────────────────────

enum _FieldType { plain, date, statusOk }

/// Estado de vigencia de un documento temporal (SOAT / RTM).
enum _VigenciaStatus { vigente, proximoAVencer, vencido, sinDatos }

class _DisplayField {
  final String label;
  final String value;
  final _FieldType type;

  const _DisplayField({
    required this.label,
    required this.value,
    this.type = _FieldType.plain,
  });
}

class _DateSemanticStyle {
  final Color color;
  const _DateSemanticStyle({required this.color});
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS DE VIGENCIA — file-level, accesibles por todos los widgets del archivo
// ─────────────────────────────────────────────────────────────────────────────

_VigenciaStatus _computeVigenciaStatus(dynamic dateRaw) {
  if (dateRaw == null) return _VigenciaStatus.sinDatos;
  final s = dateRaw.toString().trim();
  if (s.isEmpty) return _VigenciaStatus.sinDatos;
  final dt = DateTime.tryParse(s);
  if (dt == null) return _VigenciaStatus.sinDatos;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(dt.year, dt.month, dt.day);
  if (target.isBefore(today)) return _VigenciaStatus.vencido;
  if (target.difference(today).inDays <= 30) {
    return _VigenciaStatus.proximoAVencer;
  }
  return _VigenciaStatus.vigente;
}

int _computeDaysRemaining(dynamic dateRaw) {
  if (dateRaw == null) return 0;
  final s = dateRaw.toString().trim();
  if (s.isEmpty) return 0;
  final dt = DateTime.tryParse(s);
  if (dt == null) return 0;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final diff = DateTime(dt.year, dt.month, dt.day).difference(today).inDays;
  return diff < 0 ? 0 : diff;
}

String _computeVigenciaSubtitle(_VigenciaStatus status, int? days) {
  switch (status) {
    case _VigenciaStatus.vigente:
      return days != null ? 'Vigente · vence en $days días' : 'Vigente';
    case _VigenciaStatus.proximoAVencer:
      return days != null ? 'Por vencer · $days días restantes' : 'Por vencer';
    case _VigenciaStatus.vencido:
      return 'Vencido';
    case _VigenciaStatus.sinDatos:
      return 'Sin registro';
  }
}

String _vigenciaLabel(_VigenciaStatus s) {
  switch (s) {
    case _VigenciaStatus.vigente:
      return 'Vigente';
    case _VigenciaStatus.proximoAVencer:
      return 'Próximo a vencer';
    case _VigenciaStatus.vencido:
      return 'Vencido';
    case _VigenciaStatus.sinDatos:
      return 'Sin datos';
  }
}

IconData _vigenciaIcon(_VigenciaStatus s) {
  switch (s) {
    case _VigenciaStatus.vigente:
      return Icons.check_circle_rounded;
    case _VigenciaStatus.proximoAVencer:
      return Icons.warning_rounded;
    case _VigenciaStatus.vencido:
      return Icons.error_rounded;
    case _VigenciaStatus.sinDatos:
      return Icons.help_outline_rounded;
  }
}

Color _vigenciaColor(_VigenciaStatus s, ColorScheme colors) {
  switch (s) {
    case _VigenciaStatus.vigente:
      return colors.primary;
    case _VigenciaStatus.proximoAVencer:
      return colors.tertiary;
    case _VigenciaStatus.vencido:
      return colors.error;
    case _VigenciaStatus.sinDatos:
      return colors.outline;
  }
}

/// Normaliza abreviaturas comunes de autoridades de tránsito colombianas.
/// Expande palabras conocidas a su forma legible; si no coincide con ninguna
/// abreviatura, aplica title-case para mejorar legibilidad sin romper el dato.
String _normalizeAuthority(String raw) {
  const abbrevs = {
    'STRIA': 'Secretaría',
    'STRÍA': 'Secretaría',
    'DTAL': 'Distrital',
    'MPAL': 'Municipal',
    'DPTAL': 'Departamental',
    'TTO': 'de Tránsito',
    'TRANSITO': 'de Tránsito',
    'TRÁNSITO': 'de Tránsito',
    'MOV': 'Movilidad',
    'MOVILIDAD': 'Movilidad',
    'DTO': 'Departamento',
    'MUN': 'Municipal',
    'MN': 'Municipal',
    'DE': 'de',
    'DEL': 'del',
    'Y': 'y',
  };
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;
  final parts = trimmed.split(RegExp(r'\s+'));
  return parts.map((w) => abbrevs[w.toUpperCase()] ?? _titleCase(w)).join(' ');
}

/// Convierte una palabra a Title Case (primera letra mayúscula, resto minúscula).
String _titleCase(String w) =>
    w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';

/// Color dinámico de la barra de progreso según días restantes de vigencia.
/// >120 días → primary (verde/azul) · 30-120 → tertiary (amarillo)
/// 1-29 → naranja · ≤0 → error (rojo)
Color _progressColor(int days, ColorScheme colors) {
  if (days > 120) return colors.primary;
  if (days >= 30) return colors.tertiary;
  if (days >= 1) return const Color(0xFFF57C00);
  return colors.error;
}

/// Formatea fecha ISO a formato corto: "25 sep 2026".
String? _formatShortDate(dynamic raw) {
  if (raw == null) return null;
  final s = raw.toString().trim();
  if (s.isEmpty) return null;
  try {
    return DateFormat('d MMM yyyy', 'es_CO').format(DateTime.parse(s));
  } catch (_) {
    return s;
  }
}
