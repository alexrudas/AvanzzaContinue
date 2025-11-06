import 'package:get/get.dart';

import 'maintenance_item.dart';
import 'types/i_maintenance_stats_repo.dart';
import 'types/kpi_filter.dart';
import 'types/maintenance_stats.dart';

/// ---------------------------------------------------------------------------
/// MaintenanceStatsController
/// ---------------------------------------------------------------------------
/// Controlador GetX para manejar la lógica de:
/// - Estadísticas y KPIs de mantenimientos
/// - Filtros activos (por tipo de KPI y por tipo de activo)
/// - Carga asincrónica de métricas desde el repositorio
/// - Recalculo dinámico de KPIs según el filtro seleccionado
/// - Almacenamiento local temporal de los ítems base
/// ---------------------------------------------------------------------------
class MaintenanceStatsController extends GetxController {
  final IMaintenanceStatsRepo _repo;
  final String orgId;

  MaintenanceStatsController({
    required IMaintenanceStatsRepo repo,
    required this.orgId,
  }) : _repo = repo;

  // ---------------------------------------------------------------------------
  // ESTADO GENERAL
  // ---------------------------------------------------------------------------

  /// Estado principal de métricas
  final Rx<MaintenanceStats> stats = MaintenanceStats.empty().obs;

  /// Indicadores de carga y error
  final isLoading = false.obs;
  final RxnString error = RxnString();

  /// Filtro activo del panel KPI (ej. incidencias, en proceso, finalizados)
  final Rxn<KpiFilter> activeFilter = Rxn<KpiFilter>();

  /// Lista base de mantenimientos cargados desde el repositorio
  final RxList<MaintenanceItem> _baseItems = <MaintenanceItem>[].obs;

  // ---------------------------------------------------------------------------
  // FILTROS POR TIPO DE ACTIVO (USADOS POR LOS CHIPS)
  // ---------------------------------------------------------------------------

  /// Tipos de activo que el usuario administra (se llena dinámicamente)
  /// Ejemplo: ["Vehículos", "Inmuebles", "Maquinaria"]
  final RxList<String> assetTypeOptions = <String>[].obs;

  /// Tipo de activo seleccionado actualmente
  /// Default: "Todos"
  final RxString selectedAssetType = 'Todos'.obs;

  // ---------------------------------------------------------------------------
  // CICLO DE VIDA
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  // ---------------------------------------------------------------------------
  // CARGA Y REFRESCO DE DATOS
  // ---------------------------------------------------------------------------

  /// Carga inicial de estadísticas desde el repositorio remoto/local
  Future<void> loadStats() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await _repo.getStats(orgId);
      stats.value = data;

      // Cuando se carga por primera vez, se alimenta lista de tipos de activos
      _populateAssetTypesFromItems();
    } catch (e) {
      error.value = 'Error cargando estadísticas: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca manualmente las estadísticas (limpia caché si es necesario)
  Future<void> refreshStats() async {
    await _repo.refreshCache(orgId);
    await loadStats();
  }

  // ---------------------------------------------------------------------------
  // MANEJO DE FILTROS
  // ---------------------------------------------------------------------------

  /// Alterna un KPI al hacer tap sobre su tarjeta
  void toggleFilter(KpiFilter filter) {
    if (activeFilter.value == filter) {
      activeFilter.value = null; // desactiva si ya estaba activo
    } else {
      activeFilter.value = filter;
    }
  }

  /// Obtiene el número correspondiente a cada KPI (se usa en las cards)
  int getCountFor(KpiFilter filter) {
    switch (filter) {
      case KpiFilter.programados:
        return stats.value.totalProgramados;
      case KpiFilter.enProceso:
        return stats.value.totalEnProceso;
      case KpiFilter.finalizados:
        return stats.value.totalFinalizados;
    }
  }

  // ---------------------------------------------------------------------------
  // MANEJO DE ITEMS BASE
  // ---------------------------------------------------------------------------

  /// Guarda los items base y **actualiza los tipos de activo disponibles**
  void setBaseItems(List<MaintenanceItem> items) {
    _baseItems.assignAll(items);
    _populateAssetTypesFromItems();
  }

  /// Retorna la lista de mantenimientos filtrados por KPI activo
  List<MaintenanceItem> get mantenimientosFiltrados {
    final filter = activeFilter.value;
    if (filter == null) return _baseItems;

    return _baseItems.where((item) {
      switch (filter) {
        case KpiFilter.programados:
          return item.type == 'programados';
        case KpiFilter.enProceso:
          return item.type == 'proceso';
        case KpiFilter.finalizados:
          return item.type == 'finalizado';
      }
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // FILTRO POR TIPO DE ACTIVO (CHIPS)
  // ---------------------------------------------------------------------------

  /// Acción al seleccionar un chip de tipo de activo
  void onAssetTypeSelected(String type) {
    selectedAssetType.value = type;
    _recomputeKpis();
  }

  /// Recalcula los KPIs según el tipo de activo seleccionado
  /// (puede integrarse con Isar o Firestore según tu flujo)
  void _recomputeKpis() {
    // 🔧 Aquí implementas tu lógica real para filtrar stats locales.
    // Por ahora solo simula el refresco sin recargar la API.
    // Ejemplo: loadStats(assetType: selectedAssetType.value);
  }

  /// Alimenta la lista de chips a partir de los tipos de activo únicos
  void _populateAssetTypesFromItems() {
    final types = _baseItems
        .map((e) => e.assetType)
        .whereType<String>()
        .where((t) => t.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    assetTypeOptions
      ..clear()
      ..addAll(types);

    // Si no hay tipos registrados, vacía el filtro
    if (assetTypeOptions.isEmpty) {
      selectedAssetType.value = 'Todos';
    }
  }
}
