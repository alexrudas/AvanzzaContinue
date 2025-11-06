import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/repositories/maintenance_repository.dart';
import '../../../common/ensure_registered_guard.dart';
import '../../../controllers/session_context_controller.dart';
import 'maintenance_item.dart';
import 'maintenance_stats_controller.dart';
import 'types/i_maintenance_stats_repo.dart';

class AdminMaintenanceController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();
  bool get hasActiveOrg => _orgId != null;

  String? _orgId;
  late final MaintenanceRepository _repo;
  late final MaintenanceStatsController stats;

  final items = <MaintenanceItem>[].obs;

  StreamSubscription? _incSub;
  StreamSubscription? _progSub;
  StreamSubscription? _procSub;
  StreamSubscription? _finSub;

  List<MaintenanceItem> _incItems = [];
  List<MaintenanceItem> _progItems = [];
  List<MaintenanceItem> _procItems = [];
  List<MaintenanceItem> _finItems = [];

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _repo = di.maintenanceRepository;
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;

    // Register stats controller with repo + orgId
    final repo = MockMaintenanceStatsRepo();
    stats = Get.put<MaintenanceStatsController>(
      MaintenanceStatsController(repo: repo, orgId: _orgId ?? ''),
      permanent: false,
    );

    _subscribeLocal();
    di.syncService.sync();
  }

  void _subscribeLocal() {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) {
        loading.value = false;
        return;
      }
      final orgId = _orgId!;

      _incSub = _repo.watchIncidencias(orgId).listen((list) {
        _incItems = list
            .map((e) => MaintenanceItem(
                  id: e.id,
                  type: 'incidencia',
                  title: e.descripcion,
                  subtitle: e.cityId,
                  priority: e.prioridad,
                  status: e.estado,
                  date: e.createdAt,
                  assetId: e.assetId,
                ))
            .toList();
        _rebuildCombined();
      });
      _progSub = _repo.watchProgramaciones(orgId).listen((list) {
        _progItems = list
            .map((e) => MaintenanceItem(
                  id: e.id,
                  type: 'programacion',
                  title: 'Programación (${e.programmingDates.length})',
                  subtitle: e.notes,
                  status: 'programado',
                  date: e.programmingDates.isNotEmpty
                      ? e.programmingDates.first
                      : e.createdAt,
                  assetId: e.assetId,
                ))
            .toList();
        _rebuildCombined();
      });
      _procSub = _repo.watchProcesos(orgId).listen((list) {
        _procItems = list
            .map((e) => MaintenanceItem(
                  id: e.id,
                  type: 'proceso',
                  title: e.descripcion,
                  subtitle: 'En proceso',
                  status: e.estado,
                  date: e.startedAt,
                  assetId: e.assetId,
                ))
            .toList();
        _rebuildCombined();
      });
      _finSub = _repo.watchFinalizados(orgId).listen((list) {
        _finItems = list
            .map((e) => MaintenanceItem(
                  id: e.id,
                  type: 'finalizado',
                  title: e.descripcion,
                  subtitle: 'Finalizado',
                  status: 'finalizado',
                  date: e.fechaFin,
                  assetId: e.assetId,
                ))
            .toList();
        _rebuildCombined();
      });
    } catch (e) {
      error.value = 'Error suscribiendo datos locales';
    } finally {
      loading.value = false;
    }
  }

  void _rebuildCombined() {
    final combined = <MaintenanceItem>[
      ..._incItems,
      ..._progItems,
      ..._procItems,
      ..._finItems,
    ];
    combined.sort((a, b) => (b.date ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.date ?? DateTime.fromMillisecondsSinceEpoch(0)));
    items.assignAll(combined);
    stats.setBaseItems(combined);
  }

  void createIncidentOrSchedule() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async => Get.toNamed('/incidencia'));
  }

  @override
  void onClose() {
    _incSub?.cancel();
    _progSub?.cancel();
    _procSub?.cancel();
    _finSub?.cancel();
    super.onClose();
  }
}
