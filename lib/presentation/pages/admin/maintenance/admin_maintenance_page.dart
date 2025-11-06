import 'package:avanzza/presentation/widgets/floating_quick_actions_row/floating_quick_actions_row.dart';
import 'package:avanzza/presentation/widgets/maintenance/review_events_strip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/campaign_config.dart';
import '../../../controllers/admin/maintenance/admin_maintenance_controller.dart';
import '../../../controllers/admin/maintenance/maintenance_item.dart' as model;
import '../../../controllers/admin/maintenance/maintenance_stats_controller.dart';
import '../../../controllers/admin/maintenance/types/kpi_filter.dart';
import '../../../themes/tokens/primitives.dart';
import '../../../themes/tokens/semantic.dart';
import '../../../widgets/campaign/campaign_launcher.dart';
import '../../../widgets/maintenance/maintenance_card.dart';
import '../../../widgets/maintenance/maintenance_kpi_row.dart';

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

    return FloatingQuickActions(
      child: CampaignLauncher(
        screenId: 'admin_maintenance',
        enabled: kCampaignsEnabled,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F6F8),
          resizeToAvoidBottomInset: true,
          //floatingActionButton: const MaintenanceFAB(heroTag: 'adminMaintFab'),
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
                  .where(
                      (e) => e.type == 'programacion' || e.type == 'preventivo')
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

                    // Fila de 3 cards: Incidencias | Próximos mantenimientos | Fuera de servicio
                    // Bloque: Estado de flota (vertical con ListTile)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   'Estado de flota',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.w700,
                          //     color: Color(0xFF1E293B),
                          //   ),
                          // ),
                          // const SizedBox(height: 8),
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: Color(0xFFE0E3E7)),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFFEE2E2),
                                child: Icon(Icons.error_outline,
                                    color: Color(0xFF991B1B)),
                              ),
                              title: const Text('Incidencias'),
                              trailing: Text(
                                '$incidenciasCount activas',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              onTap: () {
                                // TODO: Navegación a incidencias
                              },
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: Color(0xFFE0E3E7)),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFFDE68A),
                                child: Icon(Icons.build_circle_rounded,
                                    color: Color(0xFF92400E)),
                              ),
                              title: const Text('Próximos mantenimientos'),
                              trailing: Text(
                                hasPreventivos
                                    ? '$preventivosCount en 7 días'
                                    : '—',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              onTap: () {
                                // TODO: Navegación a preventivos
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bloque gráfico: salud operativa + costo mensual
                    const MaintenanceAnalyticsBlock(),

                    // Lista filtrada
                    ...filtered.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
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
      ),
    );
  }

  List<QuickAction> _buildQuickActions() {
    return [
      QuickAction(
        icon: Icons.apartment_rounded,
        label: 'Activos',
        color: SemanticColors.success,
        showBadge: true,
        badgeCount: 6,
        badgeColor: SemanticColors.info,
        onTap: () {},
      ),
      QuickAction(
        icon: Icons.key_rounded,
        label: 'Propietarios',
        color: ColorPrimitives.primary,
        onTap: () {},
      ),
      QuickAction(
        icon: Icons.receipt_long_rounded,
        label: 'Arrendatarios',
        color: SemanticColors.info,
        onTap: () {},
      ),
      QuickAction(
        icon: Icons.groups_2_rounded,
        label: 'Contactos',
        color: SemanticColors.warning,
        onTap: () {},
      ),
    ];
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Mantenimientos',
          //   style: TextStyle(
          //     fontSize: 28,
          //     fontWeight: FontWeight.bold,
          //     color: Color(0xFF1E293B),
          //   ),
          // ),
          // const SizedBox(height: 4),
          GetBuilder<MaintenanceStatsController>(
            builder: (statsController) {
              final st = statsController.stats.value;
              final totalActivos = st.totalActivos;
              final lastUpdate = st.formattedUpdateTime;
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  '$totalActivos activos gestionados • Actualizado $lastUpdate',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// /// ---------------------------------------------------------------------------
// /// _MiniKpiCard
// /// ---------------------------------------------------------------------------
// /// Card compacta tipo KPI + CTA para accesos rápidos.
// /// ---------------------------------------------------------------------------
// class _MiniKpiCard extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//   final String value;
//   final String subtitle;
//   final VoidCallback onTap;

//   const _MiniKpiCard({
//     required this.color,
//     required this.icon,
//     required this.title,
//     required this.value,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: const Color(0xFFE0E3E7), width: 1),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x14000000),
//               blurRadius: 8,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Icono + Título
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, size: 20, color: const Color(0xFF111827)),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     title,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 15,
//                       color: Color(0xFF1E293B),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             // Valor grande
//             Column(
//               children: [
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 // Subtítulo
//                 Text(
//                   subtitle,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style:
//                       const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/// ===========================================================================
/// Bloque gráfico de analítica (Salud operativa + Costo mensual)
/// - Contenedor oscuro con dos paneles: donut 80/20 y barras simples
/// - Sin dependencias externas; usa CustomPaint y LayoutBuilder
/// ===========================================================================
class MaintenanceAnalyticsBlock extends StatelessWidget {
  const MaintenanceAnalyticsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Separación del resto del contenido
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        // Tarjeta oscura que contiene ambos gráficos
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: const Row(
          // Dos paneles en columnas iguales
          children: [
            Expanded(child: _DonutPanel(title: 'Salud Operativa', okPct: 0.80)),
            SizedBox(width: 12),
            Expanded(child: _BarsPanel(title: 'Costo mensual')),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Panel donut 80/20 (verde/rojo)
/// - okPct controla el porcentaje en verde (0..1)
/// - Leyenda compacta a la derecha del gráfico
/// ---------------------------------------------------------------------------
class _DonutPanel extends StatelessWidget {
  final String title;
  final double okPct; // 0..1
  const _DonutPanel({required this.title, required this.okPct});

  @override
  Widget build(BuildContext context) {
    final badPct = 1 - okPct;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _panelTitle(title),
        const SizedBox(height: 8),
        // Mantiene proporción visual del donut
        AspectRatio(
          aspectRatio: 1.6,
          child: Center(
            // Dibujo del donut
            child: CustomPaint(
              size: const Size(140, 140),
              painter: _DonutPainter(okPct: okPct),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Leyenda 80% / 20%
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _legendDot(Colors.green),
            const SizedBox(width: 4),
            const Text('80 %', style: TextStyle(color: Colors.white70)),
            const SizedBox(width: 12),
            _legendDot(Colors.redAccent),
            const SizedBox(width: 4),
            Text('${(badPct * 100).round()} %',
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  // Punto de color para la leyenda
  Widget _legendDot(Color c) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  // Título del panel
  Widget _panelTitle(String t) => Text(
        t,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Painter del donut:
/// - Traza un anillo de fondo y dos arcos: OK (verde) y BAD (rojo)
/// - Hace un “agujero” central para estilo donut
/// ---------------------------------------------------------------------------
class _DonutPainter extends CustomPainter {
  final double okPct; // 0..1
  _DonutPainter({required this.okPct});

  @override
  void paint(Canvas canvas, Size size) {
    // Centro y radio del círculo
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.45;

    // Pinceles: fondo, OK y BAD
    final bg = Paint()
      ..color = const Color(0xFF1F2937)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.35
      ..strokeCap = StrokeCap.round;

    final ok = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.35
      ..strokeCap = StrokeCap.round;

    final bad = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.35
      ..strokeCap = StrokeCap.round;

    // Rectángulo de referencia para los arcos
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Arco de fondo (360°)
    canvas.drawArc(rect, -90 * _deg, 360 * _deg, false, bg);
    // Arco OK en verde
    canvas.drawArc(rect, -90 * _deg, 360 * okPct * _deg, false, ok);
    // Arco BAD complementario
    canvas.drawArc(
      rect,
      -90 * _deg + 360 * okPct * _deg,
      360 * (1 - okPct) * _deg,
      false,
      bad,
    );

    // Agujero central para estilo donut
    final hole = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(center, radius * 0.45, hole);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => old.okPct != okPct;
}

// Conversión grados → radianes
const double _deg = 3.1415926535897932 / 180.0;

/// ---------------------------------------------------------------------------
/// Panel de barras simples (4 columnas)
/// - Datos de ejemplo embebidos; reemplaza _data por valores reales
/// - Altura de cada barra proporcional al valor máximo
/// ---------------------------------------------------------------------------
class _BarsPanel extends StatelessWidget {
  final String title;
  const _BarsPanel({required this.title});

  // TODO: reemplazar por datos reales de costo mensual
  List<double> get _data => const [12, 24, 36, 48];

  @override
  Widget build(BuildContext context) {
    final maxV = _data.isEmpty ? 1.0 : _data.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _panelTitle(title),
        const SizedBox(height: 8),
        // Área que calcula tamaños disponibles para las barras
        AspectRatio(
          aspectRatio: 1.6,
          child: LayoutBuilder(
            builder: (_, c) {
              final w = c.maxWidth;
              final h = c.maxHeight;
              const gap = 8.0; // separación entre barras
              final barW = (w - gap * (_data.length - 1)) / _data.length;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < _data.length; i++) ...[
                    _bar(
                      height: (_data[i] / maxV) * (h * 0.9), // 90% del alto
                      width: barW,
                    ),
                    if (i < _data.length - 1) const SizedBox(width: gap),
                  ]
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Dibujo de una barra individual
  Widget _bar({required double height, required double width}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(8),
        ),
      );

  // Título del panel
  Widget _panelTitle(String t) => Text(
        t,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );
}
