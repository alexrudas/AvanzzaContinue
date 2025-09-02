import 'package:isar_community/isar.dart';

import '../../models/maintenance/incidencia_model.dart';
import '../../models/maintenance/maintenance_finished_model.dart';
import '../../models/maintenance/maintenance_process_model.dart';
import '../../models/maintenance/maintenance_programming_model.dart';

class MaintenanceLocalDataSource {
  final Isar isar;
  MaintenanceLocalDataSource(this.isar);

  Future<List<IncidenciaModel>> incidencias(String orgId,
      {String? assetId, String? cityId}) async {
    final q = isar.incidenciaModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(assetId != null, (q) => q.assetIdEqualTo(assetId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertIncidencia(IncidenciaModel m) async =>
      isar.writeTxn(() async => isar.incidenciaModels.put(m));

  Future<List<MaintenanceProgrammingModel>> programaciones(String orgId,
      {String? assetId, String? cityId}) async {
    final q = isar.maintenanceProgrammingModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(assetId != null, (q) => q.assetIdEqualTo(assetId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertProgramacion(MaintenanceProgrammingModel m) async =>
      isar.writeTxn(() async => isar.maintenanceProgrammingModels.put(m));

  Future<List<MaintenanceProcessModel>> procesos(String orgId,
      {String? assetId, String? cityId}) async {
    final q = isar.maintenanceProcessModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(assetId != null, (q) => q.assetIdEqualTo(assetId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertProceso(MaintenanceProcessModel m) async =>
      isar.writeTxn(() async => isar.maintenanceProcessModels.put(m));

  Future<List<MaintenanceFinishedModel>> finalizados(String orgId,
      {String? assetId, String? cityId}) async {
    final q = isar.maintenanceFinishedModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(assetId != null, (q) => q.assetIdEqualTo(assetId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertFinalizado(MaintenanceFinishedModel m) async =>
      isar.writeTxn(() async => isar.maintenanceFinishedModels.put(m));
}
