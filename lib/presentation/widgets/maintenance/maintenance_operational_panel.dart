import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin/maintenance/admin_maintenance_controller.dart';
import '../../controllers/admin/maintenance/maintenance_stats_controller.dart';
import '../../controllers/admin/maintenance/maintenance_item.dart' as model;
import 'maintenance_card.dart';

/// Panel operativo sin tabs.
/// Incluye: barra de búsqueda, botón de filtros y lista filtrada por KPI/activo.
class MaintenanceOperationalPanel extends GetView<AdminMaintenanceController> {
  const MaintenanceOperationalPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Altura acotada por el contenedor padre (NestedScrollView o SliverFill)
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 8),
              // Lista reactiva filtrada por KPI/activo
              Expanded(
                child: Obx(() {
                  final stats = Get.find<MaintenanceStatsController>();
                  final List<model.MaintenanceItem> items = stats.mantenimientosFiltrados;
                  if (items.isEmpty) {
                    return _emptyState();
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96), // 96 para no quedar bajo el FAB
                    itemCount: items.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: MaintenanceCard(item: items[i]),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Search
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar vehículo o incidencia...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (query) {
                  // TODO: Integrar con filtro de búsqueda en MaintenanceStatsController/AdminMaintenanceController
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filtro
          SizedBox(
            height: 44,
            width: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_alt_outlined, size: 20),
                onPressed: () => _showFiltersBottomSheet(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No hay registros', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filtros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const ListTile(leading: Icon(Icons.directions_car), title: Text('Por tipo de activo'), trailing: Icon(Icons.chevron_right)),
              const ListTile(leading: Icon(Icons.calendar_today), title: Text('Por fecha'), trailing: Icon(Icons.chevron_right)),
              const ListTile(leading: Icon(Icons.attach_money), title: Text('Por rango de costo'), trailing: Icon(Icons.chevron_right)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar'))),
                  const SizedBox(width: 12),
                  Expanded(child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Aplicar'))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
