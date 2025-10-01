import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/repositories/maintenance_repository.dart';
import '../../../common/ensure_registered_guard.dart';
import '../../../controllers/session_context_controller.dart';
import '../../../widgets/empty_state.dart';

class AdminMaintenanceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final loading = true.obs;
  final RxnString error = RxnString();
  bool get hasActiveOrg => _orgId != null;

  late final TabController tabController;
  final itemsIncidencias = <Widget>[].obs;
  final itemsProgramacion = <Widget>[].obs;
  final itemsProceso = <Widget>[].obs;
  final itemsFinalizados = <Widget>[].obs;

  String? _orgId;
  late final MaintenanceRepository _repo;

  List<Widget> get tabViews => [
        _buildListOrEmpty(itemsIncidencias),
        _buildListOrEmpty(itemsProgramacion),
        _buildListOrEmpty(itemsProceso),
        _buildListOrEmpty(itemsFinalizados),
      ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    final di = DIContainer();
    _repo = di.maintenanceRepository;

    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;

    _subscribeLocal();
    di.syncService.sync();
  }

  void _subscribeLocal() {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) return;
      final orgId = _orgId!;

      _repo.watchIncidencias(orgId).listen((list) {
        itemsIncidencias
            .assignAll(list.map((e) => ListTile(title: Text(e.descripcion))));
      });
      _repo.watchProgramaciones(orgId).listen((list) {
        itemsProgramacion.assignAll(list.map((e) => ListTile(
            title: Text('Programación ${e.programmingDates.length} fechas'))));
      });
      _repo.watchProcesos(orgId).listen((list) {
        itemsProceso.assignAll(list.map((e) => ListTile(
            title: Text(e.descripcion), subtitle: const Text('En proceso'))));
      });
      _repo.watchFinalizados(orgId).listen((list) {
        itemsFinalizados.assignAll(list.map((e) => ListTile(
            title: Text(e.descripcion), subtitle: const Text('Finalizado'))));
      });
    } catch (e) {
      error.value = 'Error suscribiendo datos locales';
    } finally {
      loading.value = false;
    }
  }

  Widget _buildListOrEmpty(List<Widget> items) {
    return items.isEmpty
        ? const EmptyState(title: 'Sin registros')
        : ListView(children: items);
  }

  void createIncidentOrSchedule() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async => Get.toNamed('/incidencia'));
  }
}
