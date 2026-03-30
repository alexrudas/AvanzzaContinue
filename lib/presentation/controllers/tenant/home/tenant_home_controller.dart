// ============================================================================
// lib/presentation/controllers/tenant/home/tenant_home_controller.dart
// TENANT HOME CONTROLLER — Arrendatario workspace
//
// QUÉ HACE:
// - Provee estado reactivo para TenantHomePage: tareas, arriendos, pago urgente.
// - Carga alertas promovidas via HomeAlertAggregationService (pipeline canónico).
// - Alimenta [aiMessages] para el banner IA y [promotedAlertVms] para métricas.
// - Expone métricas: totalAlertsCount, criticalAlertsCount, affectedAssetsCount.
// - Reactividad V1: suscripción a InsurancePolicyModel y AssetVehiculoModel
//   via watchLazy() con debounce 800ms para re-evaluar alertas al cambiar datos.
// - Concurrencia segura: guard _isRefreshing + request ID para resultados stale.
// - Provee [refreshAlerts()] público para pull-to-refresh.
// - Provee métodos de navegación y acciones de emergencia.
// - Expone ViewModels (TaskVM, RentalVM, UrgentPaymentVM) y utilidades
//   (Formatters, Analytics, TenantHomeRoutes) reutilizadas por la página.
//
// QUÉ NO HACE:
// - NO evalúa alertas — recibe la lista del pipeline canónico.
// - NO contiene lógica de negocio de alertas ni de dominio.
// - NO importa repositorios ni datasources del data layer.
//   (Importa modelos Isar solo para usar sus extensiones watchLazy() — V1).
//
// PRINCIPIOS:
// - Una sola fuente de estado para TenantHomePage: este controller.
// - [aiMessages] se alimenta exclusivamente desde _loadPromotedAlerts(). Sin mocks.
// - Reactividad V1 (táctica): watchers globales + debounce 800ms.
//   NO es la arquitectura final. V2: AlertInvalidationCoordinator.
//   Aceptable mientras org ≤15 activos y rescan ≤300ms.
// - Falla silenciosa: si orgId es null o pipeline falla, listas quedan vacías.
//
// ENTERPRISE NOTES:
// CREADO: mock inicial (sin fecha registrada).
// ACTUALIZADO (2026-03): Fase 4 — integración HomeAlertAggregationService.
// ACTUALIZADO (2026-03): Fase 5 — controller activo consolidado.
// ACTUALIZADO (2026-03): Fase 5.5 — reactividad V1, métricas, fix AIAlertDomain.
//   Ver ALERTS_SYSTEM_V4.md §8.1 (reactividad), §8.2 (criterio escalamiento).
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/container.dart';
import '../../../../data/models/asset/special/asset_vehiculo_model.dart';
import '../../../../data/models/insurance/insurance_policy_model.dart';
import '../../../../domain/entities/alerts/alert_code.dart';
import '../../../../domain/entities/alerts/alert_severity.dart';
import '../../../alerts/mappers/domain_alert_mapper.dart';
import '../../../alerts/viewmodels/alert_card_vm.dart';
import '../../../controllers/session_context_controller.dart';
import '../../../widgets/ai_banner/ai_banner.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UTILIDADES — reutilizadas por el controller y por TenantHomePage
// ─────────────────────────────────────────────────────────────────────────────

/// Formateadores de valores para la Home del arrendatario.
class Formatters {
  static String money(num value) {
    final f =
        NumberFormat.currency(locale: 'es_CO', symbol: r'$', decimalDigits: 0);
    return f.format(value);
  }

  static String dayShort(DateTime date) {
    final f = DateFormat('EEE, d MMM', 'es_CO');
    final s = f.format(date);
    return s[0].toUpperCase() + s.substring(1);
  }

  static String weekdayLong(DateTime date) {
    final f = DateFormat('EEEE', 'es_CO');
    final s = f.format(date);
    return s[0].toUpperCase() + s.substring(1);
  }

  static String timeOfDay(DateTime date) {
    final hour = date.hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m';
      }
      return '${diff.inHours}h';
    }
    if (diff.inDays == 1) return 'Mañana';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('d MMM', 'es_CO').format(date);
  }
}

/// Stub de tracking analítico para la Home.
class Analytics {
  static void track(String event, [Map<String, dynamic>? props]) {
    debugPrint('📊 Analytics: $event ${props ?? ""}');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RUTAS — pendiente migración a app_routes.dart
// ─────────────────────────────────────────────────────────────────────────────

/// Rutas de navegación del workspace arrendatario.
///
/// TODO: Migrar a app_routes.dart cuando se implementen las pantallas reales.
class TenantHomeRoutes {
  static const paymentsPending = '/payments/pending';
  static const picoPlacaCalendar = '/traffic/restrictions';
  static const tasksAll = '/tasks';
  static const rentalsAll = '/rentals';
  static const notifications = '/notifications';
  static const profile = '/profile';

  // Emergencias / soporte
  static const emergencyCai = '/emergency/cai';
  static const emergencyAmbulance = '/emergency/ambulance';
  static const emergencyFirefighters = '/emergency/firefighters';
  static const emergencyTow = '/emergency/tow';
  static const accidentGuide = '/emergency/accident-guide';
  static const techHelp = '/support/tech-help';
  static const callInsurance = '/support/insurance-help';
  static const legalHelp = '/support/legal-help';
  static const onlineAssistance = '/support/online-assistance';
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW MODELS — estados de UI tipados para la Home
// ─────────────────────────────────────────────────────────────────────────────

/// Tarea del día con icono, urgencia y fecha límite.
class TaskVM {
  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final DateTime? dueDate;
  final bool isUrgent;
  final bool isCompleted;

  TaskVM({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.dueDate,
    this.isUrgent = false,
    this.isCompleted = false,
  });

  String get dueLabel {
    if (dueDate == null) return '';
    return Formatters.relativeTime(dueDate!);
  }
}

/// Contrato de arriendo activo con estado de pago.
class RentalVM {
  final String id;
  final String icon;
  final String type;
  final String name;
  final String details;
  final bool hasPendingPayment;
  final int pendingInvoices;
  final num nextPaymentAmount;
  final DateTime? nextPaymentDate;

  RentalVM({
    required this.id,
    required this.icon,
    required this.type,
    required this.name,
    required this.details,
    required this.hasPendingPayment,
    required this.pendingInvoices,
    required this.nextPaymentAmount,
    this.nextPaymentDate,
  });

  String get dueDateLabel {
    if (nextPaymentDate == null) return '';
    final now = DateTime.now();
    final diff = nextPaymentDate!.difference(now);

    if (diff.inDays == 0) return 'Vence hoy';
    if (diff.inDays < 0) return 'Pago inmediato';
    if (diff.inDays == 1) return 'Vence mañana';
    return Formatters.dayShort(nextPaymentDate!);
  }

  bool get isOverdue {
    if (nextPaymentDate == null) return false;
    return nextPaymentDate!.isBefore(DateTime.now());
  }
}

/// Pago urgente con cuenta regresiva.
class UrgentPaymentVM {
  final num amount;
  final String concept;
  final DateTime dueDate;
  final String vehicleName;

  UrgentPaymentVM({
    required this.amount,
    required this.concept,
    required this.dueDate,
    required this.vehicleName,
  });

  String get timeRemaining {
    final now = DateTime.now();
    final diff = dueDate.difference(now);

    if (diff.inHours < 0) return 'Vencido';
    if (diff.inHours == 0) return 'Vence en ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Vence en ${diff.inHours}h';
    return 'Vence hoy';
  }

  bool get isOverdue => dueDate.isBefore(DateTime.now());
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────

/// Controller principal de la Home del arrendatario.
///
/// Fuente única de estado para [TenantHomePage]. Provee datos reactivos
/// (tareas, arriendos, pago urgente) y alertas del pipeline canónico.
class TenantHomeController extends GetxController {
  // ── Datos de perfil ────────────────────────────────────────────────────────
  final userName = 'Alexander'.obs;
  final now = DateTime.now().obs;
  final notificationsCount = 3.obs;

  // ── Pago urgente ───────────────────────────────────────────────────────────
  final urgentPayment = Rxn<UrgentPaymentVM>();

  // ── Pico y Placa ───────────────────────────────────────────────────────────
  final picoPlacaActive = false.obs;
  final picoPlacaCity = 'Barranquilla'.obs;

  // ── Tareas del día ─────────────────────────────────────────────────────────
  final tasks = <TaskVM>[].obs;
  final showAllTasks = false.obs;

  // ── Arriendos activos ──────────────────────────────────────────────────────
  final rentals = <RentalVM>[].obs;

  // ── Banner IA + VMs de alertas (pipeline canónico) ────────────────────────

  /// Alertas promovidas para el banner IA.
  ///
  /// Fuente: pipeline canónico via [_loadPromotedAlerts].
  /// NO hay mocks hardcodeados aquí. Lista vacía si pipeline no disponible.
  final aiMessages = <AIBannerMessage>[].obs;

  /// VMs de alertas promovidas. Fuente de métricas (total, críticas, activos).
  ///
  /// Se actualiza en paralelo con [aiMessages] en cada ciclo del pipeline.
  final promotedAlertVms = <AlertCardVm>[].obs;

  // ── Reactividad V1 — watchers Isar + debounce ──────────────────────────────
  StreamSubscription<void>? _insuranceSub;
  StreamSubscription<void>? _vehiculoSub;
  Timer? _alertDebounce;

  // Guard de concurrencia: previene solapamiento de llamadas al pipeline.
  bool _isRefreshing = false;

  // Request ID: descarta resultados stale si llega uno más nuevo.
  int _requestId = 0;

  // ── Asistencia online ──────────────────────────────────────────────────────
  final assistanceSubscribed = false.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // CICLO DE VIDA
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    _loadPromotedAlerts(); // carga inicial
    _setupAlertReactivity(); // V1: watchers Isar + debounce 800ms
  }

  @override
  void onClose() {
    _alertDebounce?.cancel();
    _insuranceSub?.cancel();
    _vehiculoSub?.cancel();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GETTERS COMPUTADOS
  // ─────────────────────────────────────────────────────────────────────────

  String get greeting => Formatters.timeOfDay(now.value);
  String get todayLabel => Formatters.dayShort(now.value);
  String get picoPlacaLabel => picoPlacaActive.value
      ? '🔴 Pico y Placa HOY en ${picoPlacaCity.value}'
      : 'Sin restricción vehicular en ${picoPlacaCity.value}';

  int get urgentTasksCount =>
      tasks.where((t) => t.isUrgent && !t.isCompleted).length;
  int get totalTasksCount => tasks.where((t) => !t.isCompleted).length;

  List<TaskVM> get visibleTasks =>
      showAllTasks.value ? tasks : tasks.take(3).toList();

  // ── Métricas de alertas ───────────────────────────────────────────────────

  /// Total de alertas promovidas activas.
  int get totalAlertsCount => promotedAlertVms.length;

  /// Total de alertas con severidad CRITICAL.
  int get criticalAlertsCount =>
      promotedAlertVms.where((v) => v.severity == AlertSeverity.critical).length;

  /// Número de activos únicos con al menos una alerta activa.
  int get affectedAssetsCount =>
      promotedAlertVms.map((v) => v.sourceEntityId).toSet().length;

  // ─────────────────────────────────────────────────────────────────────────
  // ACCIONES DE UI
  // ─────────────────────────────────────────────────────────────────────────

  void toggleTasksView() {
    showAllTasks.value = !showAllTasks.value;
    HapticFeedback.selectionClick();
  }

  void onAIMessageTap() {
    HapticFeedback.lightImpact();
    Analytics.track('ai_banner_tap');
  }

  void onTaskTap(TaskVM task) {
    HapticFeedback.selectionClick();
    Analytics.track('task_tap', {'task_id': task.id});
  }

  void onRentalTap(RentalVM rental) {
    HapticFeedback.selectionClick();
    Analytics.track('rental_tap', {'rental_id': rental.id});
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NAVEGACIÓN
  // ─────────────────────────────────────────────────────────────────────────

  void goToPayment() {
    HapticFeedback.mediumImpact();
    Analytics.track('urgent_payment_tap');
    Get.toNamed(TenantHomeRoutes.paymentsPending);
  }

  void goToNotifications() {
    HapticFeedback.lightImpact();
    Analytics.track('notifications_tap');
    Get.toNamed(TenantHomeRoutes.notifications);
  }

  void goToProfile() {
    HapticFeedback.lightImpact();
    Analytics.track('profile_tap');
    Get.toNamed(TenantHomeRoutes.profile);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EMERGENCIAS
  // ─────────────────────────────────────────────────────────────────────────

  void openCai() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_cai');
    Get.toNamed(TenantHomeRoutes.emergencyCai);
  }

  void callAmbulance() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_ambulance');
    Get.toNamed(TenantHomeRoutes.emergencyAmbulance);
  }

  void callFirefighters() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_firefighters');
    Get.toNamed(TenantHomeRoutes.emergencyFirefighters);
  }

  void requestTow() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_tow');
    Get.toNamed(TenantHomeRoutes.emergencyTow);
  }

  void openAccidentGuide() {
    HapticFeedback.lightImpact();
    Analytics.track('accident_guide');
    Get.toNamed(TenantHomeRoutes.accidentGuide);
  }

  void registerCallInsurance() {
    HapticFeedback.lightImpact();
    Analytics.track('accident_guide');
    Get.toNamed(TenantHomeRoutes.callInsurance);
  }

  void openLegalHelp() {
    HapticFeedback.lightImpact();
    Analytics.track('accident_guide');
    Get.toNamed(TenantHomeRoutes.legalHelp);
  }

  void openTechHelp() {
    HapticFeedback.lightImpact();
    Analytics.track('tech_help');
    Get.toNamed(TenantHomeRoutes.techHelp);
  }

  void openOnlineAssistance() {
    HapticFeedback.lightImpact();
    Analytics.track('online_assistance');
    Get.toNamed(TenantHomeRoutes.onlineAssistance);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DATOS MOCK — tareas, arriendos, pago urgente
  // ─────────────────────────────────────────────────────────────────────────

  /// Carga datos mock para tareas, arriendos y pago urgente.
  ///
  /// Las alertas del banner IA NO se inicializan aquí — provienen del
  /// pipeline canónico via [_loadPromotedAlerts].
  void _loadMockData() {
    urgentPayment.value = UrgentPaymentVM(
      amount: 450000,
      concept: 'Arriendo',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      vehicleName: 'Hyundai Grand i10',
    );

    tasks.value = [
      TaskVM(
        id: '1',
        icon: Icons.local_gas_station_rounded,
        iconColor: const Color(0xFFEF4444),
        title: 'Pagar arriendo del vehículo',
        subtitle: '🚗 Hyundai Grand i10',
        dueDate: DateTime.now().add(const Duration(hours: 2)),
        isUrgent: true,
      ),
      TaskVM(
        id: '2',
        icon: Icons.build_rounded,
        iconColor: const Color(0xFFF59E0B),
        title: 'Revisar equipo de carretera',
        subtitle: '🚗 Hyundai Grand i10',
        dueDate: DateTime.now().add(const Duration(hours: 6)),
      ),
      TaskVM(
        id: '3',
        icon: Icons.engineering_rounded,
        iconColor: const Color(0xFF3B82F6),
        title: 'Llevar el carro al taller',
        subtitle: '🚗 Hyundai Grand i10',
        dueDate: DateTime.now().add(const Duration(hours: 9)),
      ),
    ];

    rentals.value = [
      RentalVM(
        id: '1',
        icon: '🚗',
        type: 'Vehículo',
        name: 'Hyundai Grand i10',
        details: 'WPV-584 • 2018',
        hasPendingPayment: true,
        pendingInvoices: 1,
        nextPaymentAmount: 450000,
        nextPaymentDate: DateTime.now().add(const Duration(hours: 2)),
      ),
      RentalVM(
        id: '2',
        icon: '🏠',
        type: 'Inmueble',
        name: 'Casa en San José',
        details: 'Calle 45 # 19-54',
        hasPendingPayment: false,
        pendingInvoices: 0,
        nextPaymentAmount: 980000,
        nextPaymentDate: DateTime.now().add(const Duration(days: 15)),
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PIPELINE V4 — ALERTAS PROMOVIDAS (Fase 5.5)
  // ─────────────────────────────────────────────────────────────────────────

  /// Expone el pipeline para pull-to-refresh desde la UI.
  Future<void> refreshAlerts() => _loadPromotedAlerts();

  /// Suscripción reactiva V1: watchers globales de las 2 colecciones fuente.
  ///
  /// V1 (táctica): watchers globales con debounce 800ms.
  /// NOT arquitectura final — válida mientras org ≤15 activos y rescan ≤300ms.
  /// V2: AlertInvalidationCoordinator. Ver ALERTS_SYSTEM_V4.md §8.1 y §8.3.
  void _setupAlertReactivity() {
    final isar = DIContainer().isar;
    // V1: cualquier cambio en pólizas o vehículos dispara re-evaluación global.
    // V2: diferenciar por tipo → insurance change → solo SOAT/RC;
    //     vehiculo change → solo RTM/Legal.
    _insuranceSub = isar.insurancePolicyModels.watchLazy().listen((_) => _debounce());
    _vehiculoSub = isar.assetVehiculoModels.watchLazy().listen((_) => _debounce());
  }

  void _debounce() {
    _alertDebounce?.cancel();
    _alertDebounce = Timer(
      const Duration(milliseconds: 800),
      _loadPromotedAlerts,
    );
  }

  /// Carga alertas promovidas para la org activa via el pipeline canónico.
  ///
  /// Actualiza [promotedAlertVms] y [aiMessages] con el resultado mapeado.
  /// Concurrencia segura: guard [_isRefreshing] + request ID para stale results.
  /// Falla silenciosamente en release con logging en debug.
  Future<void> _loadPromotedAlerts() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    final currentId = ++_requestId;
    final stopwatch = Stopwatch()..start();

    try {
      final orgId =
          Get.find<SessionContextController>().user?.activeContext?.orgId;
      if (orgId == null) return;

      final domainAlerts = await DIContainer()
          .homeAlertAggregationService
          .promotedAlertsForOrg(orgId);

      if (currentId != _requestId) return; // resultado stale — ignorar

      final vms = DomainAlertMapper.fromDomainList(domainAlerts);
      promotedAlertVms.assignAll(vms);
      aiMessages.assignAll(vms.map(_toAIBannerMessage));
    } catch (e, st) {
      // Falla silenciosa en release — UI muestra lista vacía sin romperse.
      assert(() {
        debugPrint('[Alerts] refresh failed: $e');
        debugPrint('$st');
        return true;
      }());
    } finally {
      _isRefreshing = false;
      stopwatch.stop();
      assert(() {
        debugPrint(
          '[Alerts] refresh took ${stopwatch.elapsedMilliseconds}ms '
          '(${promotedAlertVms.length} alertas promovidas)',
        );
        return true;
      }());
    }
  }

  /// Traduce un [AlertCardVm] a [AIBannerMessage] para el banner visual.
  ///
  /// [AIBannerMessage] sobrevive como componente visual (bridge Fase 5).
  /// No es fuente de dominio — recibe datos del pipeline canónico.
  AIBannerMessage _toAIBannerMessage(AlertCardVm vm) {
    final type = switch (vm.severity) {
      AlertSeverity.critical => AIMessageType.critical,
      AlertSeverity.high => AIMessageType.warning,
      AlertSeverity.medium || AlertSeverity.low => AIMessageType.info,
    };
    return AIBannerMessage(
      type: type,
      icon: _iconForAlertCode(vm.code),
      title: vm.title,
      subtitle: vm.subtitle,
      domain: _domainForCode(vm.code),
    );
  }

  /// Resuelve el dominio semántico para [AIAlertDomain] desde el [AlertCode].
  ///
  /// Corrige el bug V1 donde todas las alertas se clasificaban como
  /// [AIAlertDomain.documentos] independientemente de su código.
  static AIAlertDomain _domainForCode(AlertCode code) => switch (code) {
        AlertCode.soatExpired ||
        AlertCode.soatDueSoon ||
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing ||
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing =>
          AIAlertDomain.documentos,
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          AIAlertDomain.legal,
        _ => AIAlertDomain.operativo,
      };

  IconData _iconForAlertCode(AlertCode code) => switch (code) {
        AlertCode.soatExpired ||
        AlertCode.soatDueSoon =>
          Icons.receipt_long_rounded,
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon =>
          Icons.build_circle_rounded,
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing ||
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing =>
          Icons.policy_rounded,
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          Icons.gavel_rounded,
        _ => Icons.warning_rounded,
      };
}
