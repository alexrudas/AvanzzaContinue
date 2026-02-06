// lib/presentation/controllers/admin/home/admin_home_controller.dart
// ============================================================================
// AdminHomeController — UI Governance v1.0.5 (Enterprise-ready)
// ============================================================================
// - Controller 100% data-only (sin Widgets / BuildContext)
// - Sin Get.snackbar (usa uiEvent)
// - Sin navegación directa (la vista ejecuta side-effects)
// - Regla dura: “Activo primero” (bloquea acciones operativas sin activos)
// ============================================================================

import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/repositories/accounting_repository.dart';
import '../../../../domain/repositories/asset_repository.dart';
import '../../../../domain/repositories/maintenance_repository.dart';
import '../../../../domain/repositories/purchase_repository.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../routes/app_routes.dart';
import '../../../common/ensure_registered_guard.dart';
import '../../session_context_controller.dart';

// ============================================================================
// UI EVENT PATTERN (data-only)
// ============================================================================

enum AdminUiEventType { snackbar, redirect, snackbarAndRedirect }

class AdminUiEvent {
  final AdminUiEventType type;

  // Snackbar
  final String? title;
  final String? message;

  // Redirect
  final String? route;
  final Object? arguments;

  const AdminUiEvent._({
    required this.type,
    this.title,
    this.message,
    this.route,
    this.arguments,
  });

  const AdminUiEvent.snackbar({
    required String title,
    required String message,
  }) : this._(
          type: AdminUiEventType.snackbar,
          title: title,
          message: message,
        );

  const AdminUiEvent.redirect({
    required String route,
    Object? arguments,
  }) : this._(
          type: AdminUiEventType.redirect,
          route: route,
          arguments: arguments,
        );

  const AdminUiEvent.snackbarAndRedirect({
    required String title,
    required String message,
    required String route,
    Object? arguments,
  }) : this._(
          type: AdminUiEventType.snackbarAndRedirect,
          title: title,
          message: message,
          route: route,
          arguments: arguments,
        );
}

// ============================================================================
// VIEW MODELS (Data-only)
// ============================================================================

class AdminKpiVM {
  final String label;
  final num value;
  final String? suffix;

  const AdminKpiVM({
    required this.label,
    required this.value,
    this.suffix,
  });
}

class AdminEventVM {
  final String title;
  final String? subtitle;
  final DateTime? timestamp;

  const AdminEventVM({
    required this.title,
    this.subtitle,
    this.timestamp,
  });
}

/// ViewModel para alertas de atención requerida (data-only)
class AdminAiAlertVM {
  final String title;
  final String subtitle;
  final String route;
  final Object? arguments;
  final int priority; // 1 = alta, 2 = media, 3 = baja

  const AdminAiAlertVM({
    required this.title,
    required this.subtitle,
    required this.route,
    this.arguments,
    required this.priority,
  });
}

// ============================================================================
// CONTROLLER
// ============================================================================

class AdminHomeController extends GetxController {
  // ──────────────────────────────────────────────────────────────────────────
  // STATE
  // ──────────────────────────────────────────────────────────────────────────
  final loading = true.obs;
  final RxnString error = RxnString();

  final kpis = <AdminKpiVM>[].obs;
  final events = <AdminEventVM>[].obs;
  final alerts = <AdminAiAlertVM>[].obs;

  /// Canal de eventos de UI (la vista ejecuta side-effects)
  final Rxn<AdminUiEvent> uiEvent = Rxn<AdminUiEvent>();

  // ──────────────────────────────────────────────────────────────────────────
  // ALERTS GETTERS
  // ──────────────────────────────────────────────────────────────────────────
  int get pendingAlertsCount => alerts.length;
  AdminAiAlertVM? get topAlert => alerts.isEmpty ? null : alerts.first;

  // ──────────────────────────────────────────────────────────────────────────
  // ASSETS GETTER (sync, data-only)
  // ──────────────────────────────────────────────────────────────────────────
  /// Retorna true si el KPI "Activos" indica > 0 activos registrados.
  bool get hasAssets {
    for (final kpi in kpis) {
      if (kpi.label == 'Activos') {
        return kpi.value.toInt() > 0;
      }
    }
    return false;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // GETTERS
  // ──────────────────────────────────────────────────────────────────────────
  bool get hasActiveOrg => _orgId != null;

  String get userName {
    try {
      final session = Get.find<SessionContextController>();
      final fullName = session.user?.name ?? '';
      if (fullName.isEmpty) return 'Usuario';

      final firstName =
          fullName.trim().replaceAll(RegExp(r'\s+'), ' ').split(' ').first;
      if (firstName.isEmpty) return 'Usuario';

      return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
    } catch (_) {
      return 'Usuario';
    }
  }

  String get activeWorkspace {
    try {
      final session = Get.find<SessionContextController>();
      return session.user?.activeContext?.rol ?? 'Workspace';
    } catch (_) {
      return 'Workspace';
    }
  }

  List<String> get availableRoles {
    try {
      final session = Get.find<SessionContextController>();
      final roles = session.memberships
          .where((m) => m.estatus == 'activo')
          .expand((m) => m.roles)
          .toSet()
          .toList();

      // Orden determinista: ascendente case-insensitive
      roles.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return roles;
    } catch (_) {
      return [];
    }
  }

  bool get hasMultipleWorkspaces => availableRoles.length > 1;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String get shortDate {
    final now = DateTime.now();
    const weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
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
      'Dic'
    ];

    final weekday = weekdays[now.weekday - 1];
    final day = now.day;
    final month = months[now.month - 1];

    return '$weekday, $day $month';
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PRIVATE
  // ──────────────────────────────────────────────────────────────────────────
  String? _orgId;

  /// DI singleton (una sola instancia por controller)
  late final DIContainer _di;

  late final AssetRepository _assetRepo;
  late final MaintenanceRepository _mntRepo;
  late final AccountingRepository _accRepo;
  late final PurchaseRepository _purRepo;

  // ──────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    _di = DIContainer();
    _assetRepo = _di.assetRepository;
    _mntRepo = _di.maintenanceRepository;
    _accRepo = _di.accountingRepository;
    _purRepo = _di.purchaseRepository;

    _resolveOrg();
    _loadLocal();

    // Mantener compatibilidad con el flujo actual de la app (no es UI side-effect)
    _di.syncService.sync();
  }

  void _resolveOrg() {
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DATA LOADING
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> refreshData() async {
    await _loadLocal();
    await _di.syncService.sync();
  }

  Future<void> _loadLocal() async {
    try {
      loading.value = true;
      error.value = null;

      if (_orgId == null) {
        kpis.clear();
        events.clear();
        alerts.clear();
        return;
      }

      final orgId = _orgId!;

      final assets = await _assetRepo.fetchAssetsByOrg(orgId);
      final incidencias = await _mntRepo.fetchIncidencias(orgId);
      final programaciones = await _mntRepo.fetchProgramaciones(orgId);
      final compras = await _purRepo.fetchRequestsByOrg(orgId);

      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);
      final entries = await _accRepo.fetchEntriesByOrg(orgId);

      final egresosMes = entries
          .where((e) => e.tipo != 'ingreso' && e.fecha.isAfter(inicioMes))
          .fold<double>(0.0, (s, e) => s + e.monto);

      kpis.value = [
        AdminKpiVM(label: 'Activos', value: assets.length),
        AdminKpiVM(label: 'Incidencias', value: incidencias.length),
        AdminKpiVM(label: 'Programaciones', value: programaciones.length),
        AdminKpiVM(
          label: 'Compras abiertas',
          value: compras.where((c) => c.estado == 'abierta').length,
        ),
        AdminKpiVM(label: 'Egresos del mes', value: egresosMes, suffix: '\$'),
      ];

      final respuestasCount =
          compras.fold<int>(0, (s, r) => s + r.respuestasCount);

      events.value = [
        const AdminEventVM(title: 'Incidencia creada'),
        AdminEventVM(
          title: 'Compras respondidas',
          subtitle: '$respuestasCount respuestas',
        ),
        AdminEventVM(
          title: 'Asientos contables',
          subtitle: '${entries.length} en cache',
        ),
      ];

      // ────────────────────────────────────────────────────────────────────────
      // ALERTAS DE ATENCIÓN REQUERIDA (generadas desde datos locales)
      // ────────────────────────────────────────────────────────────────────────
      final newAlerts = <AdminAiAlertVM>[];

      final comprasAbiertas = compras.where((c) => c.estado == 'abierta').length;

      if (incidencias.isNotEmpty) {
        newAlerts.add(AdminAiAlertVM(
          title: 'Incidencias pendientes',
          subtitle: 'Tienes ${incidencias.length} por atender',
          route: Routes.incidencia,
          priority: 1,
        ));
      }

      if (programaciones.isNotEmpty) {
        newAlerts.add(AdminAiAlertVM(
          title: 'Programaciones activas',
          subtitle: 'Tienes ${programaciones.length} agendadas',
          route: Routes.assets,
          priority: 2,
        ));
      }

      if (comprasAbiertas > 0) {
        newAlerts.add(AdminAiAlertVM(
          title: 'Compras abiertas',
          subtitle: 'Tienes $comprasAbiertas solicitudes activas',
          route: Routes.purchase,
          priority: 2,
        ));
      }

      // Ordenar por prioridad ascendente (1 = más urgente)
      newAlerts.sort((a, b) => a.priority.compareTo(b.priority));
      alerts.value = newAlerts;
    } catch (_) {
      error.value = 'Error cargando datos locales';
    } finally {
      loading.value = false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPER: “Activo primero” (regla de negocio)
  // ──────────────────────────────────────────────────────────────────────────
  Future<bool> _ensureHasAtLeastOneAssetOrRedirect() async {
    // Sin org activa
    if (_orgId == null) {
      uiEvent.value = const AdminUiEvent.snackbar(
        title: 'Acción no disponible',
        message: 'Seleccione una organización primero',
      );
      return false;
    }

    // 1) Intentar inferir desde KPI "Activos"
    int assetsCount = -1;
    for (final k in kpis) {
      if (k.label == 'Activos') {
        assetsCount = k.value.toInt();
        break;
      }
    }

    // 2) Fallback a repo local si KPI no está disponible
    if (assetsCount < 0) {
      final assets = await _assetRepo.fetchAssetsByOrg(_orgId!);
      assetsCount = assets.length;
    }

    // 3) Bloqueo duro
    if (assetsCount == 0) {
      uiEvent.value = const AdminUiEvent.snackbarAndRedirect(
        title: 'Primero registra un activo',
        message: 'Debes registrar al menos un activo para continuar',
        route: Routes.assets,
      );
      return false;
    }

    return true;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // ACTIONS (data-only)
  // ──────────────────────────────────────────────────────────────────────────

  /// Flujo correcto: seleccionar activo primero (NO Routes.incidencia aquí)
  Future<void> goToNewMaintenance() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async {
      final ok = await _ensureHasAtLeastOneAssetOrRedirect();
      if (!ok) return;

      uiEvent.value = const AdminUiEvent.redirect(route: Routes.assets);
    });
  }

  /// Compra: exige activo primero (por ahora)
  Future<void> goToNewPurchase() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async {
      final ok = await _ensureHasAtLeastOneAssetOrRedirect();
      if (!ok) return;

      uiEvent.value = const AdminUiEvent.redirect(route: Routes.purchase);
    });
  }

  Future<void> goToNewAccountingEntry() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async {
      uiEvent.value = const AdminUiEvent.snackbar(
        title: 'Próximamente',
        message: 'Nuevo asiento contable (stub)',
      );
    });
  }

  Future<void> goToBroadcast() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async {
      uiEvent.value = const AdminUiEvent.snackbar(
        title: 'Próximamente',
        message: 'Broadcast (stub)',
      );
    });
  }

  Future<void> changeWorkspace(String newRole) async {
    if (newRole == activeWorkspace) return;

    try {
      final session = Get.find<SessionContextController>();
      final user = session.user;
      if (user == null) return;

      // Buscar membership sin depender de firstWhereOrNull
      dynamic targetMembership;
      for (final m in session.memberships) {
        final hasRole =
            m.roles.any((r) => r.toLowerCase() == newRole.toLowerCase());
        if (hasRole) {
          targetMembership = m;
          break;
        }
      }

      if (targetMembership != null) {
        // ignore: avoid_dynamic_calls
        final newContext = user.activeContext?.copyWith(
          orgId: targetMembership.orgId,
          orgName: targetMembership.orgName,
          rol: newRole,
        );

        if (newContext != null) {
          await session.setActiveContext(newContext);
          uiEvent.value = const AdminUiEvent.redirect(route: Routes.home);
        }
      }
    } catch (_) {
      uiEvent.value = const AdminUiEvent.snackbar(
        title: 'Error',
        message: 'No se pudo cambiar el espacio de trabajo',
      );
    }
  }

  void goToHome() {
    uiEvent.value = const AdminUiEvent.redirect(route: Routes.home);
  }

  /// Muestra snackbar de funcionalidad no disponible
  void showFeatureUnavailable(String featureName) {
    uiEvent.value = AdminUiEvent.snackbar(
      title: 'Próximamente',
      message: 'El módulo $featureName está en construcción',
    );
  }

  /// Navega a la alerta más prioritaria
  void openTopAlert() {
    final alert = topAlert;
    if (alert == null) return;
    uiEvent.value = AdminUiEvent.redirect(
      route: alert.route,
      arguments: alert.arguments,
    );
  }

  /// Abre el wizard de registro de activo con tipo preseleccionado
  /// El wizard crea el portafolio internamente (camuflado en UX)
  void openCreateAssetWizard(AssetType assetType) {
    uiEvent.value = AdminUiEvent.redirect(
      route: Routes.createPortfolioStep1,
      arguments: {'preselectedAssetType': assetType},
    );
  }

  /// Navega a la página de activos (vista agrupada por portafolios)
  void goToAssetsPage() {
    uiEvent.value = const AdminUiEvent.redirect(route: Routes.assets);
  }
}
