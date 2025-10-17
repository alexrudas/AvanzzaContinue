import 'package:avanzza/presentation/widgets/maintenance/review_events_strip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin/maintenance/admin_maintenance_controller.dart';
import '../../../controllers/admin/maintenance/maintenance_item.dart' as model;
import '../../../controllers/admin/maintenance/maintenance_stats_controller.dart';
import '../../../controllers/admin/maintenance/types/kpi_filter.dart';
import '../../../widgets/maintenance/fab_actions_sheet.dart';
import '../../../widgets/maintenance/maintenance_card.dart';
import '../../../widgets/maintenance/maintenance_kpi_row.dart';
import '../../../widgets/campaign/campaign_launcher.dart';
import '../../../../core/config/campaign_config.dart';

/// ---------------------------------------------------------------------------
/// AdminMaintenancePage
/// ---------------------------------------------------------------------------
/// Vista principal de Mantenimientos (Admin)
/// - Header
/// - SmartBanner
/// - Eventos por revisar (si mantienes esta tira)
/// - KPIs (fila principal)
/// - Fila rápida con 2 cards: Incidencias | Mttos. Preventivos
/// - Lista filtrada
/// - FAB
/// ---------------------------------------------------------------------------
class AdminMaintenancePage extends GetView<AdminMaintenanceController> {
  const AdminMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = Get.find<MaintenanceStatsController>();

    return CampaignLauncher(
      screenId: 'admin_maintenance',
      enabled: kCampaignsEnabled,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
      resizeToAvoidBottomInset: true,
      floatingActionButton: const MaintenanceFAB(heroTag: 'adminMaintFab'),
      body: SafeArea(
        child: Obx(() {
          final MaintenanceStatsController s = stats;

          // Fuente base y filtro por KPI activo
          final List<model.MaintenanceItem> source = controller.items;
          final KpiFilter? active = s.activeFilter.value;

          final filtered = active == null
              ? source
              : source.where((e) {
                  switch (active) {
                    // programados
                    case KpiFilter.programados:
                      return e.type == 'programados';
                    // En proceso
                    case KpiFilter.enProceso:
                      return e.type == 'proceso';
                    // Finalizados
                    case KpiFilter.finalizados:
                      return e.type == 'finalizado';
                  }
                }).toList();

          // Métricas para las 2 mini-cards (con fallback por si no existen en stats)
          final incidenciasCount =
              source.where((e) => e.type == 'incidencia').length;

          final preventivosCount = source
              .where((e) => e.type == 'programacion' || e.type == 'preventivo')
              .length;
          final hasPreventivos = preventivosCount > 0;

          // -------- CAMBIO: uso SingleChildScrollView + padding y física solicitadas --------
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context),

                // KPIs principales
                const MaintenanceKpiRow(),

                // Fila de 2 cards: Incidencias | Mttos. Preventivos
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniKpiCard(
                          color: const Color(0xFFFEE2E2),
                          icon: Icons.warning_amber_rounded,
                          title: 'Incidencias',
                          value: '$incidenciasCount',
                          subtitle: 'Ver detalles',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniKpiCard(
                          color: const Color(0xFFE0F2FE),
                          icon: Icons.build_circle_rounded,
                          title: 'Mttos. Preventivos',
                          value: hasPreventivos ? '$preventivosCount' : '—',
                          subtitle: hasPreventivos
                              ? 'Gestionar'
                              : 'Aún no configurados',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista filtrada
                ...filtered.map(
                  (item) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: MaintenanceCard(item: item),
                  ),
                ),
                // Tira de eventos por revisar
                const ReviewEventsStrip(),
              ],
            ),
          );
          // -------- FIN CAMBIO --------
        }),
      ),
      ),
    );
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mantenimientos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          GetBuilder<MaintenanceStatsController>(
            builder: (statsController) {
              final st = statsController.stats.value;
              final totalActivos = st.totalActivos;
              final lastUpdate = st.formattedUpdateTime;
              return Text(
                '$totalActivos activos gestionados • Actualizado $lastUpdate',
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// _MiniKpiCard
/// ---------------------------------------------------------------------------
/// Card compacta tipo KPI + CTA para accesos rápidos.
/// ---------------------------------------------------------------------------
class _MiniKpiCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const _MiniKpiCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E3E7), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icono + Título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: const Color(0xFF111827)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Valor grande
            Column(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                // Subtítulo
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
