import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/repositories/accounting_repository.dart';
import '../../../../domain/repositories/asset_repository.dart';
import '../../../../domain/repositories/maintenance_repository.dart';
import '../../../../domain/repositories/purchase_repository.dart';
import '../../../common/ensure_registered_guard.dart';
import '../../../controllers/session_context_controller.dart';

class AdminHomeController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  final _kpi = <String, num>{}.obs;
  final _events = <Widget>[].obs;

  bool get hasActiveOrg => _orgId != null;
  List<Widget> get kpiChips => _kpi.entries
      .map((e) => Chip(label: Text('${e.key}: ${e.value}')))
      .toList();
  List<Widget> get eventTiles => _events;

  String? _orgId;

  late final AssetRepository _assetRepo;
  late final MaintenanceRepository _mntRepo;
  late final AccountingRepository _accRepo;
  late final PurchaseRepository _purRepo;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _assetRepo = di.assetRepository;
    _mntRepo = di.maintenanceRepository;
    _accRepo = di.accountingRepository;
    _purRepo = di.purchaseRepository;

    _resolveOrg();
    _loadLocal();
    di.syncService.sync();
  }

  void _resolveOrg() {
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;
  }

  Future<void> refreshData() async {
    await _loadLocal();
    final di = DIContainer();
    await di.syncService.sync();
  }

  Future<void> _loadLocal() async {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) {
        _kpi.clear();
        _events.clear();
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

      _kpi
        ..clear()
        ..addAll({
          'Activos': assets.length,
          'Incidencias': incidencias.length,
          'Programaciones': programaciones.length,
          'Compras abiertas':
              compras.where((c) => c.estado == 'abierta').length,
          'Egresos del mes': egresosMes,
        });

      _events
        ..clear()
        ..addAll([
          const ListTile(title: Text('Incidencia creada')),
          ListTile(
              title: const Text('Compras respondidas'),
              subtitle: Text(
                  '${compras.fold<int>(0, (s, r) => s + r.respuestasCount)} respuestas')),
          ListTile(
              title: const Text('Asientos contables'),
              subtitle: Text('${entries.length} en cache')),
        ]);
    } catch (e) {
      error.value = 'Error cargando datos locales';
    } finally {
      loading.value = false;
    }
  }

  List<Widget> quickActionButtons(BuildContext context) => [
        FilledButton.icon(
          onPressed: () async {
            final guard = EnsureRegisteredGuard();
            await guard.run(() async => Get.toNamed('/incidencia'));
          },
          icon: const Icon(Icons.build),
          label: const Text('Nuevo mantenimiento'),
        ),
        FilledButton.icon(
          onPressed: () async {
            final guard = EnsureRegisteredGuard();
            await guard.run(() async => Get.toNamed('/purchase'));
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Nueva compra'),
        ),
        FilledButton.icon(
          onPressed: () async {
            final guard = EnsureRegisteredGuard();
            await guard.run(() async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nuevo asiento contable (stub)')),
              );
            });
          },
          icon: const Icon(Icons.addchart),
          label: const Text('Nuevo asiento'),
        ),
        OutlinedButton.icon(
          onPressed: () async {
            final guard = EnsureRegisteredGuard();
            await guard.run(() async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Broadcast (stub)')),
              );
            });
          },
          icon: const Icon(Icons.campaign),
          label: const Text('Broadcast'),
        ),
      ];
}
