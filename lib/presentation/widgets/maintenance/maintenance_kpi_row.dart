import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin/maintenance/maintenance_stats_controller.dart';
import '../../controllers/admin/maintenance/types/kpi_filter.dart';

class MaintenanceKpiRow extends GetView<MaintenanceStatsController> {
  const MaintenanceKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingSkeleton();
      }
      if (controller.error.value != null) {
        return _buildErrorState();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   borderRadius: BorderRadius.circular(16),
        //   border: Border.all(color: const Color(0xFFE0E3E7), width: 1.1),
        //   boxShadow: const [
        //     BoxShadow(
        //         color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 3)),
        //   ],
        // ),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Estado de Mantenimientos',
            //   style: TextStyle(
            //     fontSize: 17.5,
            //     fontWeight: FontWeight.w800,
            //     height: 1.1,
            //     color: Color(0xFF1A1A1A),
            //   ),
            // ),
            // const SizedBox(height: 6),

            // ⬇️ Chips de filtro por tipo de activo (solo agregados)
            _buildTypeChips(),

            const SizedBox(height: 10),

            Row(
              children: [
                // programados
                Expanded(
                  child: _buildKpiCard(
                    context: context,
                    filter: KpiFilter.programados,
                    isActive:
                        controller.activeFilter.value == KpiFilter.programados,
                  ),
                ),
                const SizedBox(width: 12),
                // En proceso
                Expanded(
                  child: _buildKpiCard(
                    context: context,
                    filter: KpiFilter.enProceso,
                    isActive:
                        controller.activeFilter.value == KpiFilter.enProceso,
                  ),
                ),
                const SizedBox(width: 12),
                // Finalizados
                Expanded(
                  child: _buildKpiCard(
                    context: context,
                    filter: KpiFilter.finalizados,
                    isActive:
                        controller.activeFilter.value == KpiFilter.finalizados,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

// ---------- Chips horizontales ----------
// Siempre muestra chips. Incluye 'Todos' por defecto.
// Reacciona a cambios en assetTypeOptions y selectedAssetType.
  Widget _buildTypeChips() {
    return Obx(() {
      // 1) Tomar opciones actuales del controlador
      final opts = controller.assetTypeOptions.toList();

      // 2) Asegurar que exista al menos 'Todos'
      final List<String> items = ['Todos', ...opts]
          .where((e) => e.trim().isNotEmpty)
          .toSet() // evita duplicados si ya venía 'Todos'
          .toList();

      // 3) Valor seleccionado actual
      final selected = controller.selectedAssetType.value.isEmpty
          ? 'Todos'
          : controller.selectedAssetType.value;

      // 4) Render horizontal scroll de chips
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          children: items.map((t) {
            final isSel = selected == t;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                // Etiqueta visible del chip
                label: Text(t),

                // Estado visual de selección
                selected: isSel,

                // Al tocar, actualiza el filtro en el controlador
                onSelected: (_) => controller.onAssetTypeSelected(t),

                // Colores de chip activo/inactivo
                selectedColor: const Color(0xFF0EA5E9),
                backgroundColor: const Color(0xFFF3F4F6),

                // Estilo del texto según selección
                labelStyle: TextStyle(
                  color: isSel ? Colors.black : const Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w600,
                ),

                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    const VisualDensity(horizontal: -2, vertical: -2),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
// ---------------------------------------

  Widget _buildKpiCard({
    required BuildContext context,
    required KpiFilter filter,
    required bool isActive,
  }) {
    final count = controller.getCountFor(filter);
    final color = filter.color;
    final icon = filter.icon;
    final label = filter.label;

    return GestureDetector(
      onTap: () => controller.toggleFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.grey.shade200,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isActive ? Colors.white : color),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white.withValues(alpha: 0.9)
                    : const Color(0xFF64748B),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildSkeletonCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildSkeletonCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildSkeletonCard()),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF87171)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.error.value ?? 'Error cargando estadísticas',
              style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D)),
            ),
          ),
          TextButton(
            onPressed: () => controller.loadStats(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Reintentar', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
