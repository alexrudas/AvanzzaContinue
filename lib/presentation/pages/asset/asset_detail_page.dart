// ============================================================================
// lib/presentation/pages/asset/asset_detail_page.dart
// ASSET OS — Asset Operating System (Enterprise Ultra Pro Premium 2026)
//
// QUÉ HACE:
// - Consola de diagnóstico y operación para un activo (vehículo).
// - Separa claramente dos capas de producto:
//     1. Estado del vehículo: compliance, seguros, RTM, jurídico, tracking y
//        restricciones operativas del vehículo como activo.
//     2. Gestión operativa: conductor, contabilidad, mantenimiento e
//        incidencias como operación del negocio sobre el activo.
// - Hero Header (SliverAppBar): placa dominante, estado y score.
// - Health Score: barra de salud siempre visible.
// - Alertas del estado del vehículo: banner condicional de alta visibilidad.
// - Grid compacto "Estado del vehículo" con severidad visual UI-only.
// - Lista "Gestión operativa": estilo row/card, diferenciado del grid.
// - Ficha técnica: VehicleDetailSection integrada (solo vehículos).
// - Timeline: eventos cronológicos reales de la entidad.
// - FAB: Quick Actions Sheet (mantenimiento, gasto, incidencia).
//
// QUÉ NO HACE:
// - No navega a módulos pendientes (módulos sin página real → snackbar temporal).
//   Excepción: RTM ya tiene navegación real a RtmDetailPage (RTM v1, 2026-03).
// - No inventa datos de dominio: campos sin VM marcados TODO explícito.
// - No modifica contratos de repositorios ni dominio.
// - No crea nuevos controllers GetX ni rutas.
//
// PRINCIPIOS:
// - CustomScrollView + Slivers: performance óptima en scroll complejo.
// - StreamBuilder local: sin controller dedicado, consistente con el legado.
// - Theme-only: cero colores hardcodeados (solo ThemeData + cs).
// - Desacoplamiento: cada sección es un widget independiente y testeable.
// - Severidad UI-only: neutral/attention/critical solo en "Estado del vehículo".
//   Debe alimentarse desde datos reales cuando los módulos estén conectados.
//
// ENTERPRISE NOTES:
// REFACTORIZADO (2026-03): Separación producto Estado del vehículo / Gestión
//   operativa. Elimina el collage de módulos mezclados. Introduce _ModuleSeverity
//   privado para señal visual sobria sin hardcodear colores.
// Consulta RUNT añadida (2026-03): sección "Consulta RUNT" debajo de ficha
//   técnica. Muestra la fecha de la última consulta RUNT (proxy: _vehiculo.updatedAt
//   ?? createdAt) y el botón "ACTUALIZAR INFORMACIÓN" que navega al flujo de
//   registro con la placa pre-cargada via AssetRegistrationContext.initialPlate.
// TODO (Score): Agregar campo `score` a VehicleSummaryVM cuando esté en dominio.
// TODO (Timeline): Conectar a repositorio de eventos del activo.
// TODO (Módulos): Activar navegación real cuando cada módulo esté disponible.
// TODO (Severidad): Alimentar severity desde datos reales de cada módulo.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/asset/asset_content.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../domain/shared/enums/asset_type.dart';
import '../../../domain/value/navigation/asset_detail_args.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../routes/app_pages.dart';
import '../../alerts/mappers/domain_alert_mapper.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';
import '../../controllers/asset/asset_detail_runt_controller.dart';
import '../../controllers/asset/asset_operational_status_controller.dart';
import '../../controllers/session_context_controller.dart';
import '../../mappers/asset_summary_mapper.dart';
import '../../viewmodels/asset/asset_summary_vm.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SEMANTIC COLOR HELPERS — Tokens M3 sin literales hex
// ─────────────────────────────────────────────────────────────────────────────
//
// Material 3 ColorScheme no define tokens "success" ni "warning" nativos.
// Esta capa mapea la intención semántica a los tokens disponibles:
//   tertiary  → positivo  (activo, verificado, score alto)
//   secondary → intermedio (pendiente, score medio)
//   error     → crítico   (archivado, score bajo)
//   onSurfaceVariant → neutro (borrador)
//
// Si el diseño requiere paleta de colores semánticos propia (ej. verde #2E7D32),
// añadir AppSemanticColors al design system en un ticket dedicado y reemplazar
// estas llamadas por tokens explícitos.
// ─────────────────────────────────────────────────────────────────────────────

Color _stateSemanticColor(String lowerLabel, ColorScheme cs) {
  if (lowerLabel.contains('activo') || lowerLabel.contains('verificado')) {
    return cs.tertiary;
  }
  if (lowerLabel.contains('pendiente')) return cs.secondary;
  if (lowerLabel.contains('archivado')) return cs.error;
  return cs.onSurfaceVariant;
}

Color _scoreSemanticColor(int score, ColorScheme cs) {
  if (score >= 80) return cs.tertiary;
  if (score >= 60) return cs.secondary;
  return cs.error;
}

// ─────────────────────────────────────────────────────────────────────────────
// SEVERITY — Enum privado para señal visual de tiles Estado del vehículo
// ─────────────────────────────────────────────────────────────────────────────

/// Severidad visual UI-only de un tile del grid "Estado del vehículo".
///
/// Solo aplica a módulos de compliance/estado. No se usa en Gestión operativa.
/// Los valores actuales son placeholders coherentes con los datos temporales.
/// TODO (Severidad): Alimentar desde datos reales cuando los módulos estén
///   conectados (ej. si SOAT vence en < 30 días → critical).
enum _ModuleSeverity {
  /// Sin señal de alerta. Borde neutro, icon y métrica en color de tema.
  neutral,

  /// Requiere atención próximamente. Borde y acento sutil en cs.tertiary.
  attention,

  /// Requiere acción inmediata. Borde y acento en cs.error con opacidad moderada.
  critical,
}

// Helpers de color por severidad — file-level para accesibilidad sin contexto.

Color _severityBorderColor(_ModuleSeverity s, ColorScheme cs) => switch (s) {
      _ModuleSeverity.neutral => cs.outline.withValues(alpha: 0.12),
      _ModuleSeverity.attention => cs.tertiary.withValues(alpha: 0.38),
      _ModuleSeverity.critical => cs.error.withValues(alpha: 0.42),
    };

Color _severityIconColor(_ModuleSeverity s, ColorScheme cs) => switch (s) {
      _ModuleSeverity.neutral => cs.primary,
      _ModuleSeverity.attention => cs.tertiary,
      _ModuleSeverity.critical => cs.error,
    };

Color _severityMetricColor(_ModuleSeverity s, ColorScheme cs) => switch (s) {
      _ModuleSeverity.neutral => cs.onSurfaceVariant,
      _ModuleSeverity.attention => cs.tertiary,
      _ModuleSeverity.critical => cs.error,
    };

// ─────────────────────────────────────────────────────────────────────────────
// DATA CLASSES — Módulos y Timeline
// ─────────────────────────────────────────────────────────────────────────────

/// Definición de un módulo de activo (estado del vehículo o gestión operativa).
///
/// [primaryMetric] — dato principal visible bajo el título del tile.
/// [secondaryMetric] — subtipo o segundo dato contextual; null cuando sería
///   redundante con el título o la métrica principal.
/// [severity] — señal visual UI-only; solo relevante para tiles de estado.
///   Ignorado por [_OperationalItemRow].
class _ModuleDef {
  final String id;
  final IconData icon;
  final String title;
  final String primaryMetric;
  final String? secondaryMetric;
  final _ModuleSeverity severity;

  const _ModuleDef({
    required this.id,
    required this.icon,
    required this.title,
    required this.primaryMetric,
    this.secondaryMetric,
    this.severity = _ModuleSeverity.neutral,
  });
}

/// Evento de la línea de tiempo del activo.
class _TimelineEvent {
  final IconData icon;
  final Color Function(ColorScheme) iconColor;
  final String title;
  final String dateLabel;

  const _TimelineEvent({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.dateLabel,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// ASSET DETAIL PAGE — Asset OS
// ─────────────────────────────────────────────────────────────────────────────

class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  String? _assetId;

  /// Portafolio de origen. Recibido desde [AssetDetailArgs.portfolio].
  /// Null solo en rutas legacy (argumento String crudo).
  /// Usado por [AppNavigator.backFromAssetDetail] para decidir el destino back.
  PortfolioEntity? _portfolio;

  /// Controller reactivo granular para el estado RUNT (freshness, connectivity).
  ///
  /// Instanciado en [initState] y eliminado en [dispose].
  /// El header y la tarjeta RUNT observan sus observables via [Obx] — solo
  /// esas secciones se reconstruyen cuando cambia el estado RUNT.
  late final AssetDetailRuntController _runtCtrl;

  /// Controller reactivo para el bloque "Estado operativo HOY".
  ///
  /// Instanciado en [initState] y eliminado en [dispose].
  /// Default: [OperationalDayStatus.unconfigured] hasta que exista
  /// configuración real del módulo operativo del activo.
  late final AssetOperationalStatusController _opStatusCtrl;

  late final Stream<AssetEntity?>? _assetStream;
  AssetVehiculoEntity? _vehiculo;

  /// Alertas canónicas del activo, cargadas vía el pipeline de alertas.
  ///
  /// Null mientras la carga no ha completado (spinner no mostrado — fail-silent).
  /// Lista vacía si el pipeline no produjo alertas para este activo.
  /// Poblada por [_loadAlerts] una vez por ciclo de vida de la página.
  List<AlertCardVm>? _alertCardVms;

  @override
  void initState() {
    super.initState();
    // El controller RUNT se registra antes de _initializeData para que esté
    // disponible cuando los streams y los loaders actualicen _vehiculo.
    _runtCtrl = Get.put(AssetDetailRuntController());
    _opStatusCtrl = Get.put(AssetOperationalStatusController());
    _initializeData();
  }

  @override
  void dispose() {
    Get.delete<AssetDetailRuntController>();
    Get.delete<AssetOperationalStatusController>();
    super.dispose();
  }

  void _initializeData() {
    final arg = Get.arguments;

    String? resolvedId;
    if (arg is AssetDetailArgs && arg.assetId.isNotEmpty) {
      // Formato nuevo: recibe assetId + portfolio de origen para back explícito.
      resolvedId = arg.assetId;
      _portfolio = arg.portfolio;
    } else if (arg is String && arg.isNotEmpty) {
      // Formato legacy: solo assetId. Back irá a Home como fallback seguro.
      resolvedId = arg;
      _portfolio = null;
    }

    if (resolvedId != null) {
      _assetId = resolvedId;
      _assetStream = DIContainer().assetRepository.watchAsset(resolvedId);
      _loadVehiculoDetails(resolvedId);
      _loadAlerts(resolvedId);
    } else {
      _assetId = null;
      _assetStream = null;
    }
  }

  /// Carga [AssetVehiculoEntity] y resuelve el estado RTM desde [runtMetaJson].
  ///
  /// [_vehiculo] provee el año del vehículo para la ficha técnica.
  /// Carga [AssetVehiculoEntity] y notifica al controller RUNT.
  ///
  /// [_vehiculo] provee el año del vehículo para la ficha técnica y los
  /// tiles de acceso rápido (VehicleInfo, RuntConsult).
  Future<void> _loadVehiculoDetails(String assetId) async {
    try {
      final details =
          await DIContainer().assetRepository.getAssetDetails(assetId);
      if (!mounted) return;
      final veh = details.vehiculo;
      // Notificar al controller RUNT ANTES del setState para que el header
      // reactive se actualice simultáneamente con el rebuild del StreamBuilder.
      _runtCtrl.updateFromVehiculo(veh);

      setState(() {
        _vehiculo = veh;
      });
    } catch (e) {
      if (!mounted) return;
      if (kDebugMode) {
        debugPrint('[AssetDetailPage][_loadVehiculoDetails] Error al cargar '
            'detalles del activo $assetId: $e');
      }
      // No setState: el estado anterior (_vehiculo == null) es correcto ante error.
    }
  }

  /// Ejecuta el pipeline canónico de alertas para el activo y almacena el
  /// resultado en [_alertCardVms].
  ///
  /// Fail-silent: ante orgId vacío o cualquier error, [_alertCardVms] queda
  /// en null — el banner simplemente no se muestra.
  Future<void> _loadAlerts(String assetId) async {
    final orgId =
        Get.find<SessionContextController>().user?.activeContext?.orgId ?? '';
    if (orgId.isEmpty) return;

    try {
      final raw = await DIContainer()
          .assetComplianceAlertOrchestrator
          .evaluate(assetId: assetId, orgId: orgId);
      if (!mounted) return;
      setState(() {
        _alertCardVms = DomainAlertMapper.fromDomainList(raw);
      });
    } catch (e) {
      // Fail-silent: el banner queda oculto en lugar de bloquear la página.
      if (kDebugMode) {
        debugPrint('[AssetDetailPage][_loadAlerts] Error: $e');
      }
    }
  }

  /// Carga en paralelo las pólizas más recientes de SOAT, RC Contractual y RC
  /// Extracontractual usando [latestPolicyByTipo].
  ///
  /// Fail-silent: ante cualquier error los tiles muestran "Sin información"
  /// con severidad neutral — comportamiento correcto y seguro.
  /// Handler del botón "Actualizar" de la tarjeta RUNT.
  ///
  /// Verifica conectividad y estado del controller antes de actuar.
  /// Navega al wizard RUNT con la placa pre-cargada (flujo actual hasta que
  /// AssetRepository soporte refresh directo sin ownerDocument).
  ///
  /// Fail-silent: muestra snackbar en lugar de propagar excepciones.
  Future<void> _onRuntUpdateTapped(AssetEntity entity) async {
    // Verificación de conectividad y doble-tap vía controller.
    if (!_runtCtrl.beginUpdate()) {
      if (!_runtCtrl.isOnline.value) {
        Get.snackbar(
          'Sin conexión',
          'Conéctate para actualizar los datos RUNT.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    final portfolioId = entity.portfolioId;
    if (portfolioId == null || portfolioId.isEmpty) {
      _runtCtrl.cancelUpdate();
      Get.snackbar(
        'Sin portafolio',
        'Este activo no está asociado a un portafolio.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final portfolio =
          await DIContainer().portfolioRepository.getPortfolioById(portfolioId);
      if (!mounted) {
        _runtCtrl.cancelUpdate();
        return;
      }

      if (portfolio == null) {
        _runtCtrl.cancelUpdate();
        Get.snackbar(
          'Portafolio no encontrado',
          'No se pudo cargar el portafolio del activo.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final ctx = AssetRegistrationContext(
        portfolioId: portfolio.id,
        portfolioName: portfolio.portfolioName,
        countryId: portfolio.countryId,
        cityId: portfolio.cityId,
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: const Uuid().v4(),
        initialPlate: entity.assetKey,
      );

      // Navegar al wizard; isUpdating se cancela si el usuario vuelve sin
      // completar el flujo. Cuando vuelva con datos nuevos, el stream de Isar
      // emitirá el vehículo actualizado → updateFromVehiculo → header refresca.
      _runtCtrl.cancelUpdate(); // Reset antes de navegar (wizard toma control).
      Get.toNamed(Routes.assetRegister, arguments: ctx);
    } catch (e) {
      if (!mounted) return;
      _runtCtrl.cancelUpdate();
      Get.snackbar(
        'Error',
        'No se pudo iniciar la actualización. Intenta nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Guard: argumento de navegación inválido
    if (_assetId == null || _assetStream == null) {
      return _ErrorState(
        onBack: () => AppNavigator.backFromAssetDetail(_portfolio),
      );
    }

    // PopScope intercepta el botón de sistema (Android back) y aplica la
    // misma política que el AppBar: siempre al portafolio (o Home si null).
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) AppNavigator.backFromAssetDetail(_portfolio);
      },
      child: StreamBuilder<AssetEntity?>(
        stream: _assetStream,
        builder: (context, snapshot) {
          // ── Estado: cargando (antes del primer evento del stream) ───────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingSkeleton();
          }

          // ── Estado: error del stream ─────────────────────────────────────────
          if (snapshot.hasError) {
            return _ErrorState(
              onBack: () => AppNavigator.backFromAssetDetail(_portfolio),
            );
          }

          // ── Estado: activo no encontrado en Isar ─────────────────────────────
          final entity = snapshot.data;
          if (entity == null) return const _NotFoundState();

          // ── Estado: activo cargado → renderizar Asset OS ─────────────────────
          // Las alertas canónicas se pasan al mapper para que vm.alerts sea
          // la fuente real — null colapsa a lista vacía hasta que carguen.
          final summary = AssetSummaryMapper.fromEntity(
            entity,
            alerts: _alertCardVms ?? const [],
          );
          final vm = summary is VehicleSummaryVM ? summary : null;

          // Construir módulos del grid aquí para que el tile RTM use _rtmDoc
          // actualizado. El StreamBuilder re-ejecuta este builder tanto cuando
          // el stream emite como cuando setState actualiza _rtmDoc.
          final vehicleModules = _buildVehicleStateModules();

          // TODO: Agregar campo `score` a VehicleSummaryVM cuando esté disponible
          // en el dominio. Valor temporal exclusivamente para renderizar la UI.
          // No propagar este valor fuera del builder ni a capa de datos.
          const int placeholderScore = 92;

          final plate = vm?.plate ?? entity.assetKey;
          final brandModel = vm != null
              ? '${vm.brand} ${vm.model}'.trim()
              : entity.content.displayName;

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: CustomScrollView(
              slivers: [
                // 1. SliverAppBar — Hero Header ─────────────────────────────────
                _buildHeroAppBar(
                  context,
                  entity,
                  plate,
                  brandModel,
                  vm?.stateLabel ?? _stateLabel(entity.state),
                  placeholderScore,
                ),

                // 2. Estado operativo HOY ─────────────────────────────────────
                // Siempre visible: "Por configurar" es informativo incluso sin
                // datos del vehículo cargados. No es alerta de compliance.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    child: _OperationalDayCard(ctrl: _opStatusCtrl),
                  ),
                ),

                // 3. Health Score + Alertas del estado del vehículo ─────────────
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const _HealthScoreBar(score: placeholderScore),
                      if (vm != null && vm.alerts.isNotEmpty)
                        _AlertsBanner(alerts: vm.alerts),
                    ],
                  ),
                ),

                // 3. Encabezado sección Estado del vehículo ─────────────────────
                // Padding compacto: prioridad visual alta, sin espaciado excesivo.
                const SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Estado del vehículo',
                    topSpacing: AppSpacing.md,
                    bottomSpacing: 6,
                  ),
                ),

                // 4. SliverGrid — Estado del vehículo (8 tiles de compliance) ───
                // childAspectRatio 1.65: compacto sin sacrificar legibilidad.
                // vehicleModules fue construido antes del Scaffold para que el
                // tile RTM refleje _rtmDoc actual en cada rebuild del StreamBuilder.
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.65,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: vehicleModules.length,
                    itemBuilder: (_, i) =>
                        _VehicleStateTile(def: vehicleModules[i]),
                  ),
                ),

                // 5. Encabezado sección Gestión operativa ───────────────────────
                const SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Gestión operativa',
                    topSpacing: AppSpacing.lg,
                    bottomSpacing: AppSpacing.sm,
                  ),
                ),

                // 6. Lista — Gestión operativa (4 módulos de negocio) ───────────
                const SliverToBoxAdapter(
                  child: _OperationalSection(modules: _operationalModules),
                ),

                // 7. Acceso rápido — Información del vehículo ─────────────────
                if (_vehiculo != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        0,
                      ),
                      child: _VehicleInfoTile(vehiculo: _vehiculo!),
                    ),
                  ),

                // 8. Acceso rápido — Consulta RUNT ────────────────────────────
                if (_vehiculo != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.sm,
                        AppSpacing.md,
                        0,
                      ),
                      child: Obx(() {
                        final dt = _runtCtrl.lastRuntQueryAt.value;
                        String? fd;
                        if (dt != null) {
                          try {
                            fd = DateFormat("d MMM y · h:mm a", 'es_CO')
                                .format(dt.toLocal());
                          } catch (_) {
                            fd = DateFormat('d MMM y · HH:mm')
                                .format(dt.toLocal());
                          }
                        }
                        return _RuntConsultTile(
                          vehiculo: _vehiculo!,
                          formattedDate: fd,
                        );
                      }),
                    ),
                  ),

                // 9. Timeline — actividad reciente ─────────────────────────────
                SliverToBoxAdapter(
                  child: _TimelineSection(events: _buildTimeline(entity)),
                ),

                // 10. Espaciado inferior (clearance para FAB) ───────────────────
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl + AppSpacing.xl),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showQuickActionsSheet(context),
              icon: const Icon(Icons.bolt_rounded),
              label: const Text('Acciones'),
            ),
          );
        },
      ),
    );
  }

  // ── Hero SliverAppBar ──────────────────────────────────────────────────────

  SliverAppBar _buildHeroAppBar(
    BuildContext context,
    AssetEntity entity,
    String plate,
    String brandModel,
    String stateLabel,
    int score,
  ) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 195,
      pinned: true,
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => AppNavigator.backFromAssetDetail(_portfolio),
        tooltip: 'Volver',
      ),
      // Título colapsado: placa + marca/modelo en dos líneas.
      // letterSpacing elevado simula densidad monoespaciada sin depender de
      // una fuente custom no garantizada por el proyecto.
      // TODO: Si el design system define una fuente mono (ej. 'SpaceMono'),
      //   agregar fontFamily aquí via AppTextStyles.plateFont.
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plate.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          if (brandModel.isNotEmpty)
            Text(
              brandModel,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _HeroBackground(
          plate: plate,
          brandModel: brandModel,
          stateLabel: stateLabel,
          score: score,
          // Obx granular: solo esta línea se reconstruye cuando cambia el
          // estado RUNT. El resto del header no se ve afectado.
          runtLine: Obx(() => _RuntHeaderLine(
                lastQueryAt: _runtCtrl.lastRuntQueryAt.value,
                freshness: _runtCtrl.freshnessState,
              )),
        ),
      ),
    );
  }

  // ── Quick Actions BottomSheet ─────────────────────────────────────────────

  void _showQuickActionsSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _QuickActionsSheet(),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _stateLabel(AssetState state) => switch (state) {
        AssetState.draft => 'Borrador',
        AssetState.pendingOwnership => 'Pendiente',
        AssetState.verified => 'Verificado',
        AssetState.active => 'Activo',
        AssetState.archived => 'Archivado',
      };

  /// Construye los eventos de la timeline a partir de datos reales de la entidad.
  ///
  /// VERSIÓN TRANSITIONAL (mínima): solo usa [AssetEntity.createdAt] y
  /// [AssetEntity.updatedAt] porque el repositorio de eventos del activo
  /// aún no está implementado. No inventa datos históricos.
  ///
  /// TODO (Timeline v2): Conectar a repositorio de eventos del activo para incluir
  ///   mantenimientos, cambios de estado, documentos y otros registros históricos.
  List<_TimelineEvent> _buildTimeline(AssetEntity entity) {
    final events = <_TimelineEvent>[];

    // Evento: actualización (solo si difiere significativamente de la creación)
    final diffMin =
        entity.updatedAt.difference(entity.createdAt).inMinutes.abs();
    if (diffMin > 5) {
      events.add(_TimelineEvent(
        icon: Icons.sync_rounded,
        iconColor: (cs) => cs.primary,
        title: 'Datos actualizados',
        dateLabel: _relativeDate(entity.updatedAt),
      ));
    }

    // Evento: registro inicial (siempre presente)
    events.add(_TimelineEvent(
      icon: Icons.add_circle_outline_rounded,
      iconColor: (cs) => cs.secondary,
      title: 'Registro inicial en Avanzza',
      dateLabel: _relativeDate(entity.createdAt),
    ));

    return events;
  }

  /// Formatea una fecha como texto relativo en español.
  String _relativeDate(DateTime dt) {
    final now = DateTime.now();
    final local = dt.toLocal();
    final diff = now.difference(local);

    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    if (diff.inDays < 30) return 'Hace ${(diff.inDays / 7).floor()} sem.';

    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  // ── Grid: Estado del vehículo ──────────────────────────────────────────────
  //
  // Módulos de tracking y restricciones operativas.
  // SOAT, RTM, Seguros RC y Estado jurídico se movieron a RuntConsultPage
  // (sección 7.6 — tile "Consulta RUNT").

  /// Construye la lista de módulos del grid "Estado del vehículo".
  ///
  /// Los módulos de documentación oficial (SOAT, RTM, RC, Legal) viven ahora
  /// en [RuntConsultPage]. Este grid muestra los módulos operativos del activo.
  List<_ModuleDef> _buildVehicleStateModules() {
    return [
      const _ModuleDef(
        id: 'insurance_full',
        icon: Icons.security_outlined,
        title: 'Seg. Todo Riesgo',
        primaryMetric: 'Por configurar', // TODO: conectar a módulo
        severity: _ModuleSeverity.critical,
      ),
      const _ModuleDef(
        id: 'gps',
        icon: Icons.gps_fixed,
        title: 'GPS / Ubicación',
        primaryMetric: 'Sin configurar', // TODO: conectar a módulo
        severity: _ModuleSeverity.neutral,
      ),
      const _ModuleDef(
        id: 'road_kit',
        icon: Icons.health_and_safety_outlined,
        title: 'Kit de carretera',
        primaryMetric: 'Sin información', // TODO: conectar a módulo
        severity: _ModuleSeverity.neutral,
      ),
      const _ModuleDef(
        id: 'restriction',
        icon: Icons.schedule_outlined,
        title: 'Descanso / Restricción',
        primaryMetric: 'Sin configurar', // TODO: conectar a módulo
        severity: _ModuleSeverity.neutral,
      ),
    ];
  }

  // ── Lista: Gestión operativa ───────────────────────────────────────────────
  //
  // Módulos de operación del negocio sobre el activo.
  // No representan compliance del vehículo; no usan severity.
  //
  // TODO (Módulos): Reemplazar primaryMetric/secondaryMetric con datos reales.
  static const _operationalModules = [
    _ModuleDef(
      id: 'driver',
      icon: Icons.person_outlined,
      title: 'Conductor',
      primaryMetric: 'Sin asignar', // TODO: conectar a módulo
    ),
    _ModuleDef(
      id: 'accounting',
      icon: Icons.account_balance_outlined,
      title: 'Contabilidad',
      primaryMetric: '\$1.2M este mes', // TODO: conectar a módulo
      secondaryMetric: '+18% vs anterior', // útil: tendencia financiera
    ),
    _ModuleDef(
      id: 'maintenance',
      icon: Icons.build_outlined,
      title: 'Mantenimientos',
      primaryMetric: 'Próx. 1,200 km', // TODO: conectar a módulo
      secondaryMetric: 'Último hace 15 días', // útil: último registro
    ),
    _ModuleDef(
      id: 'incidents',
      icon: Icons.warning_amber_outlined,
      title: 'Incidencias',
      primaryMetric: 'Sin activas', // TODO: conectar a módulo
      secondaryMetric: '2 resueltas', // útil: historial reciente
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER — Encabezado de sección reutilizable
// ─────────────────────────────────────────────────────────────────────────────

/// Encabezado de sección con padding configurable.
///
/// [topSpacing] controla la separación con la sección anterior.
/// [bottomSpacing] controla la separación con el contenido que sigue.
/// Valores por defecto apretados: optimizado para el grid de Estado del vehículo.
class _SectionHeader extends StatelessWidget {
  final String title;
  final double topSpacing;
  final double bottomSpacing;

  const _SectionHeader({
    required this.title,
    this.topSpacing = AppSpacing.md,
    this.bottomSpacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.md, topSpacing, AppSpacing.md, bottomSpacing),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO BACKGROUND — Contenido expandido del SliverAppBar
// ─────────────────────────────────────────────────────────────────────────────

/// Fondo del hero con placa dominante, marca/modelo, estado y score.
///
/// Se muestra cuando el SliverAppBar está expandido.
/// Al colapsar, se desvanece y el `title` del SliverAppBar toma el control.
class _HeroBackground extends StatelessWidget {
  final String plate;
  final String brandModel;
  final String stateLabel;
  final int score;

  /// Línea reactiva de estado RUNT inyectada desde la página.
  ///
  /// Se pasa como widget (Obx) para que solo este fragmento del header
  /// se reconstruya cuando cambia el estado RUNT — sin afectar el resto.
  /// Null si el activo no es un vehículo.
  final Widget? runtLine;

  const _HeroBackground({
    required this.plate,
    required this.brandModel,
    required this.stateLabel,
    required this.score,
    this.runtLine,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primaryContainer,
            cs.primaryContainer.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          // top: deja espacio para el leading + status bar
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ── Placa dominante ────────────────────────────────────────────
              Text(
                plate.toUpperCase(),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onPrimaryContainer,
                  letterSpacing: 3.0,
                  height: 1.0,
                ),
              ),

              // ── Marca + Modelo ─────────────────────────────────────────────
              if (brandModel.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  brandModel.toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onPrimaryContainer.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // ── Estado + Score ─────────────────────────────────────────────
              Row(
                children: [
                  _StateBadge(label: stateLabel),
                  const SizedBox(width: 8),
                  _ScoreBadge(score: score),
                ],
              ),

              // ── Línea RUNT — reactiva via Obx (inyectada desde la página) ──
              // Solo se muestra para vehículos. Se reconstruye de forma granular
              // sin afectar placa, badges ni score.
              if (runtLine != null) ...[
                const SizedBox(height: 8),
                runtLine!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE BADGE + SCORE BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _StateBadge extends StatelessWidget {
  final String label;
  const _StateBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = _stateSemanticColor(label.toLowerCase(), cs);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = _scoreSemanticColor(score, cs);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.speed_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            'Score $score',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEALTH SCORE BAR
// ─────────────────────────────────────────────────────────────────────────────

/// Barra de salud horizontal compacta, siempre visible debajo del hero.
class _HealthScoreBar extends StatelessWidget {
  final int score;
  const _HealthScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = _scoreSemanticColor(score, cs);

    final label = score >= 80
        ? 'Salud Óptima'
        : score >= 60
            ? 'Atención Requerida'
            : 'Acción Urgente';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            // ── Score numérico ──────────────────────────────────────────────
            Text(
              '$score',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/100',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),

            // ── Barra de progreso + etiqueta ────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: color.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ALERTS BANNER — Visible solo si existen alertas del estado del vehículo
// ─────────────────────────────────────────────────────────────────────────────

/// Banner de alertas del estado del vehículo.
///
/// Solo se renderiza cuando [alerts] no está vacío.
/// Alimentado exclusivamente por [DomainAlertMapper] — nunca por strings crudos.
class _AlertsBanner extends StatelessWidget {
  final List<AlertCardVm> alerts;
  const _AlertsBanner({required this.alerts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: Container(
        decoration: BoxDecoration(
          color: cs.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.error.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 16, color: cs.error),
                  const SizedBox(width: 6),
                  Text(
                    'Alertas del estado del vehículo',
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
            ...alerts.map((alert) => Padding(
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
                                  color: cs.onErrorContainer
                                      .withValues(alpha: 0.7),
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE STATE TILE — Tile compacto del grid "Estado del vehículo"
// ─────────────────────────────────────────────────────────────────────────────

/// Tile del grid de Estado del vehículo con señal de severidad UI-only.
///
/// Severidad se aplica en tres puntos: borde del container, color del icono
/// y color/peso de [primaryMetric]. El fondo permanece neutro para no
/// convertir la UI en un carnaval de colores.
///
/// Activar módulo: reemplazar [Get.snackbar] con [Get.toNamed(Routes.xxx)].
class _VehicleStateTile extends StatelessWidget {
  final _ModuleDef def;
  const _VehicleStateTile({required this.def});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final iconColor = _severityIconColor(def.severity, cs);
    final borderColor = _severityBorderColor(def.severity, cs);
    final metricColor = _severityMetricColor(def.severity, cs);
    final isAlert = def.severity != _ModuleSeverity.neutral;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.snackbar(
            'En construcción',
            '${def.title} en desarrollo',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(AppSpacing.md),
            borderRadius: 12,
            duration: const Duration(seconds: 2),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icono + chevron ───────────────────────────────────────────
              Row(
                children: [
                  Icon(def.icon, size: 18, color: iconColor),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // ── Título ────────────────────────────────────────────────────
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

              // ── Métrica principal (acento semántico si hay alerta) ─────────
              Text(
                def.primaryMetric,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: metricColor,
                  fontSize: 11,
                  // Refuerzo tipográfico sutil para attention/critical.
                  fontWeight: isAlert ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // ── Métrica secundaria (contextual, no siempre presente) ───────
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
// OPERATIONAL SECTION — Lista de módulos de Gestión operativa
// ─────────────────────────────────────────────────────────────────────────────

/// Sección de Gestión operativa: lista de rows premium, distinta del grid.
///
/// Diseño más ancho y menos "cajita dashboard" que el grid de estado.
/// Refleja operación del negocio sobre el activo, no compliance del vehículo.
class _OperationalSection extends StatelessWidget {
  final List<_ModuleDef> modules;
  const _OperationalSection({required this.modules});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          for (int i = 0; i < modules.length; i++) ...[
            _OperationalItemRow(def: modules[i]),
            if (i < modules.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Row operativo premium con icono leading, métricas y chevron trailing.
///
/// Deliberadamente más ancho y lineal que [_VehicleStateTile].
/// No usa severidad: los módulos operativos no son compliance.
///
/// Activar módulo: reemplazar [Get.snackbar] con [Get.toNamed(Routes.xxx)].
class _OperationalItemRow extends StatelessWidget {
  final _ModuleDef def;
  const _OperationalItemRow({required this.def});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.snackbar(
            'En construcción',
            '${def.title} en desarrollo',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(AppSpacing.md),
            borderRadius: 12,
            duration: const Duration(seconds: 2),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              // ── Icono en contenedor small ──────────────────────────────────
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(def.icon, size: 18, color: cs.primary),
              ),
              const SizedBox(width: 14),

              // ── Título + métricas ──────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      def.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      def.primaryMetric,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    if (def.secondaryMetric != null)
                      Text(
                        def.secondaryMetric!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),

              // ── Chevron trailing ───────────────────────────────────────────
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIMELINE SECTION — Actividad reciente del activo
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineSection extends StatelessWidget {
  final List<_TimelineEvent> events;
  const _TimelineSection({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.lg, AppSpacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividad reciente',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                for (int i = 0; i < events.length; i++) ...[
                  _TimelineEventItem(event: events[i]),
                  if (i < events.length - 1)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: cs.outline.withValues(alpha: 0.1),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventItem extends StatelessWidget {
  final _TimelineEvent event;
  const _TimelineEventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = event.iconColor(cs);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // ── Icono del evento ──────────────────────────────────────────────
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(event.icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),

          // ── Descripción ───────────────────────────────────────────────────
          Expanded(
            child: Text(
              event.title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),

          // ── Fecha relativa ────────────────────────────────────────────────
          Text(
            event.dateLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK ACTIONS SHEET — BottomSheet de acciones rápidas
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet();

  static const _actions = [
    (
      icon: Icons.build_circle_outlined,
      label: 'Registrar mantenimiento',
      id: 'maintenance'
    ),
    (
      icon: Icons.receipt_long_outlined,
      label: 'Registrar gasto',
      id: 'expense'
    ),
    (
      icon: Icons.report_problem_outlined,
      label: 'Reportar incidencia',
      id: 'incident'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ────────────────────────────────────────────────────
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Acciones rápidas',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Filas de acción ────────────────────────────────────────────
            ..._actions.map((a) => _QuickActionRow(
                  icon: a.icon,
                  label: a.label,
                  moduleId: a.id,
                )),
          ],
        ),
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String moduleId;

  const _QuickActionRow({
    required this.icon,
    required this.label,
    required this.moduleId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // Mensaje contextual por módulo — cada acción tiene su propio título
    // para reforzar qué funcionalidad específica está en construcción.
    final snackTitle = switch (moduleId) {
      'maintenance' => 'Mantenimiento en construcción',
      'expense' => 'Reporte de gasto en construcción',
      'incident' => 'Incidencias en construcción',
      _ => '$label en construcción',
    };

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).pop();
        Get.snackbar(
          snackTitle,
          'Módulo disponible próximamente',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(AppSpacing.md),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ESTADOS DE APOYO — Loading, NotFound, Error
// ─────────────────────────────────────────────────────────────────────────────

/// Skeleton de carga: placeholders rectangulares mientras el stream emite.
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget block({double w = double.infinity, double h = 16, double r = 8}) =>
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(r),
          ),
        );

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: block(w: 100, h: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(h: 150, r: 16),
            const SizedBox(height: AppSpacing.md),
            block(h: 60, r: 12),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              Expanded(child: block(h: 90, r: 12)),
              const SizedBox(width: 10),
              Expanded(child: block(h: 90, r: 12)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: block(h: 90, r: 12)),
              const SizedBox(width: 10),
              Expanded(child: block(h: 90, r: 12)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: block(h: 90, r: 12)),
              const SizedBox(width: 10),
              Expanded(child: block(h: 90, r: 12)),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Estado vacío: activo con ID válido pero no encontrado en Isar.
class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 56, color: cs.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Activo no encontrado',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No existe en la base local.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Estado de error: argumento inválido o error del stream.
class _ErrorState extends StatelessWidget {
  final VoidCallback onBack;
  const _ErrorState({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 56, color: cs.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Error al cargar',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: onBack,
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// RUNT HEADER LINE
// ─────────────────────────────────────────────────────────────────────────────

/// Línea informativa de estado RUNT para el hero header.
///
/// Muestra "RUNT actualizado: {fecha}" con color según [freshness].
/// Se renderiza dentro del gradiente de [_HeroBackground] vía [Obx] granular.
///
/// Estados visuales:
///   noData   → texto neutro   "Sin consulta RUNT"
///   fresh    → texto normal   "RUNT actualizado: {fecha}"
///   warning  → texto amber    "RUNT actualizado: {fecha} · Actualizar pronto"
///   stale    → texto error    "RUNT desactualizado · {fecha}"
class _RuntHeaderLine extends StatelessWidget {
  final DateTime? lastQueryAt;
  final RuntFreshnessState freshness;

  const _RuntHeaderLine({
    required this.lastQueryAt,
    required this.freshness,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final (label, color) = switch (freshness) {
      RuntFreshnessState.noData => (
          'Sin consulta RUNT',
          cs.onPrimaryContainer.withValues(alpha: 0.55),
        ),
      RuntFreshnessState.fresh => (
          'RUNT actualizado: ${_fmt(lastQueryAt)}',
          cs.onPrimaryContainer.withValues(alpha: 0.72),
        ),
      RuntFreshnessState.warning => (
          'RUNT: ${_fmt(lastQueryAt)} · Actualizar pronto',
          cs.tertiary,
        ),
      RuntFreshnessState.stale => (
          'RUNT desactualizado · ${_fmt(lastQueryAt)}',
          cs.error,
        ),
    };

    return Row(
      children: [
        Icon(Icons.manage_search_rounded, size: 13, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  static String _fmt(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('d MMM yyyy', 'es').format(dt.toLocal());
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE INFO TILE — entrada destacada hacia VehicleInfoPage
// ─────────────────────────────────────────────────────────────────────────────

/// ListTile destacado que navega a [RuntConsultPage].
///
/// Solo se renderiza cuando [AssetVehiculoEntity] está cargado.
/// Posición: sección 7.6, inmediatamente debajo de [_VehicleInfoTile].
class _RuntConsultTile extends StatelessWidget {
  final AssetVehiculoEntity vehiculo;
  final String? formattedDate;

  const _RuntConsultTile({required this.vehiculo, this.formattedDate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(Routes.runtConsult, arguments: vehiculo),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: cs.onSecondaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documentos del vehículo y Estado jurídico',
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fuente: RUNT',
                      style: textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    if (formattedDate != null) ...[
                      const SizedBox(height: 0),
                      Row(
                        children: [
                          Text(
                            'Actualizado',
                            style: textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formattedDate!,
                            style: textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OPERATIONAL DAY CARD — Estado operativo HOY
// ─────────────────────────────────────────────────────────────────────────────

/// Tarjeta de estado operativo diario del activo.
///
/// Muestra el estado actual ([OperationalDayStatus]) y la razón textual cuando
/// aplica. No es navegable — es un display de estado, no un acceso a un módulo.
///
/// Semántica de color:
///   unconfigured → onSurfaceVariant (neutro/gris)
///   enabled      → tertiaryContainer (positivo)
///   blocked      → errorContainer (crítico)
///   limited      → secondaryContainer (atención)
///
/// Siempre visible en la página, incluso sin datos del vehículo cargados.
/// Cuando no hay configuración muestra "Por configurar" como estado informativo.
class _OperationalDayCard extends StatelessWidget {
  final AssetOperationalStatusController ctrl;

  const _OperationalDayCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final status = ctrl.status.value;
      final reason = ctrl.reason.value;

      // Color semántico e icono según el estado operativo.
      final (icon, containerColor, iconColor, label) = switch (status) {
        OperationalDayStatus.unconfigured => (
            Icons.tune_rounded,
            cs.surfaceContainerHighest,
            cs.onSurfaceVariant,
            'Por configurar',
          ),
        OperationalDayStatus.enabled => (
            Icons.check_circle_outline_rounded,
            cs.tertiaryContainer,
            cs.onTertiaryContainer,
            'Habilitado para operar hoy',
          ),
        OperationalDayStatus.blocked => (
            Icons.block_rounded,
            cs.errorContainer,
            cs.onErrorContainer,
            'No puede operar hoy',
          ),
        OperationalDayStatus.limited => (
            Icons.warning_amber_rounded,
            cs.secondaryContainer,
            cs.onSecondaryContainer,
            'Operación limitada',
          ),
      };

      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            // ── Icono semántico ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),

            // ── Título + estado + razón ──────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado operativo HOY',
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  if (reason != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      reason,
                      style: textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE INFO TILE — entrada destacada hacia VehicleInfoPage
// ─────────────────────────────────────────────────────────────────────────────

/// ListTile destacado que navega a [VehicleInfoPage].
///
/// Solo se renderiza cuando [AssetVehiculoEntity] está cargado.
class _VehicleInfoTile extends StatelessWidget {
  final AssetVehiculoEntity vehiculo;

  const _VehicleInfoTile({required this.vehiculo});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(Routes.vehicleInfo, arguments: vehiculo),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.directions_car_outlined,
                  color: cs.onPrimaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del vehículo',
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Datos para trámites, seguros y autoridades',
                      style: textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
