import '../entities/maintenance/incidencia_entity.dart';
import '../entities/maintenance/maintenance_programming_entity.dart';
import '../entities/maintenance/maintenance_process_entity.dart';
import '../entities/maintenance/maintenance_finished_entity.dart';

abstract class MaintenanceRepository {
  // Incidencias
  Stream<List<IncidenciaEntity>> watchIncidencias(String orgId,
      {String? assetId, String? cityId});
  Future<List<IncidenciaEntity>> fetchIncidencias(String orgId,
      {String? assetId, String? cityId});
  Future<void> upsertIncidencia(IncidenciaEntity entity);

  // Programaciones
  Stream<List<MaintenanceProgrammingEntity>> watchProgramaciones(String orgId,
      {String? assetId, String? cityId});
  Future<List<MaintenanceProgrammingEntity>> fetchProgramaciones(String orgId,
      {String? assetId, String? cityId});
  Future<void> upsertProgramacion(MaintenanceProgrammingEntity entity);

  // Procesos
  Stream<List<MaintenanceProcessEntity>> watchProcesos(String orgId,
      {String? assetId, String? cityId});
  Future<List<MaintenanceProcessEntity>> fetchProcesos(String orgId,
      {String? assetId, String? cityId});
  Future<void> upsertProceso(MaintenanceProcessEntity entity);

  // Finalizados
  Stream<List<MaintenanceFinishedEntity>> watchFinalizados(String orgId,
      {String? assetId, String? cityId});
  Future<List<MaintenanceFinishedEntity>> fetchFinalizados(String orgId,
      {String? assetId, String? cityId});
  Future<void> upsertFinalizado(MaintenanceFinishedEntity entity);
}
