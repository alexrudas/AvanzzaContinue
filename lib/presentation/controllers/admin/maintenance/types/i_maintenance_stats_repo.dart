import 'maintenance_stats.dart';

/// Interface para repositorio de estadísticas de mantenimientos
///
/// Define el contrato para obtener métricas agregadas.
/// Permite testing con mocks y desacopla UI de lógica de datos.
abstract class IMaintenanceStatsRepo {
  /// Obtiene estadísticas actualizadas para una organización
  ///
  /// [orgId] ID de la organización
  /// Retorna [MaintenanceStats] con datos actuales
  Future<MaintenanceStats> getStats(String orgId);

  /// Obtiene estadísticas filtradas por tipo de activo
  ///
  /// [orgId] ID de la organización
  /// [assetType] Tipo de activo (vehiculos, inmuebles, etc.)
  Future<MaintenanceStats> getStatsByAssetType(
    String orgId,
    String assetType,
  );

  /// Refresca cache de estadísticas
  Future<void> refreshCache(String orgId);
}

/// Mock implementation para testing y desarrollo
class MockMaintenanceStatsRepo implements IMaintenanceStatsRepo {
  @override
  Future<MaintenanceStats> getStats(String orgId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return MaintenanceStats(
      totalProgramados: 8,
      totalEnProceso: 12,
      totalFinalizados: 45,
      totalActivos: 156,
      lastUpdate: DateTime.now(),
    );
  }

  @override
  Future<MaintenanceStats> getStatsByAssetType(
    String orgId,
    String assetType,
  ) async {
    return getStats(orgId);
  }

  @override
  Future<void> refreshCache(String orgId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
