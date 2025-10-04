import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/di/container.dart';
import '../../controllers/session_context_controller.dart';
import '../../../domain/repositories/accounting_repository.dart';

abstract class BaseAccountingController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  late final AccountingRepository _repo;
  String? _orgId;

  final entriesTiles = <Widget>[].obs;
  double totalIngresos = 0;
  double totalEgresos = 0;
  double get neto => totalIngresos - totalEgresos;

  // Hooks de especialización
  String? get providerTypeFilter => null; // 'servicios' | 'articulos'
  String get title => 'Contabilidad';

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

  Future<void> refreshData() => _loadLocal();

  Future<void> _loadLocal() async {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) {
        entriesTiles.clear();
        totalIngresos = 0;
        totalEgresos = 0;
        return;
      }
      final orgId = _orgId!;
      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);

      final entries = await _repo.fetchEntriesByOrg(orgId);
      // TODO aplicar filtros adicionales con providerTypeFilter si dispones de metadata en entries
      final delMes = entries.where((e) => e.fecha.isAfter(inicioMes)).toList();

      totalIngresos = delMes
          .where((e) => e.tipo == 'ingreso')
          .fold<double>(0.0, (s, e) => s + e.monto);
      totalEgresos = delMes
          .where((e) => e.tipo != 'ingreso')
          .fold<double>(0.0, (s, e) => s + e.monto);

      entriesTiles
        ..clear()
        ..addAll(delMes.map((e) => ListTile(
              title: Text('${e.tipo} ${e.monto.toStringAsFixed(2)} ${e.currencyCode}'),
              subtitle: Text(e.descripcion),
            )));
    } catch (e) {
      error.value = 'Error cargando contabilidad';
    } finally {
      loading.value = false;
    }
  }
}
