import 'package:get/get.dart';
import '../../../../core/di/container.dart';
import '../../../controllers/session_context_controller.dart';
import '../../../../domain/repositories/accounting_repository.dart';
import 'package:flutter/material.dart';

class AdminAccountingController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();
  bool get hasActiveOrg => _orgId != null;

  String? _orgId;
  late final AccountingRepository _repo;

  final _entriesTiles = <Widget>[].obs;
  List<Widget> get entryTiles => _entriesTiles;

  double totalIngresos = 0;
  double totalEgresos = 0;
  double get neto => totalIngresos - totalEgresos;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _repo = di.accountingRepository;
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;

    _loadLocal();
    di.syncService.sync();
  }

  Future<void> _loadLocal() async {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) return;
      final orgId = _orgId!;

      final entries = await _repo.fetchEntriesByOrg(orgId);
      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);
      final delMes = entries.where((e) => e.fecha.isAfter(inicioMes)).toList();
      totalIngresos = delMes.where((e) => e.tipo == 'ingreso').fold<double>(0.0, (s, e) => s + e.monto);
      totalEgresos = delMes.where((e) => e.tipo != 'ingreso').fold<double>(0.0, (s, e) => s + e.monto);

      _entriesTiles
        ..clear()
        ..addAll(delMes.map((e) => ListTile(
              title: Text('${e.tipo} ${e.monto.toStringAsFixed(2)} ${e.currencyCode}'),
              subtitle: Text(e.descripcion),
            )));
    } catch (e) {
      error.value = 'Error cargando asientos';
    } finally {
      loading.value = false;
    }
  }

  void quickAddEntry() {
    // Stub rápido; navegación futura a formulario
    Get.snackbar('Contabilidad', 'Agregar asiento rápido');
  }
}
