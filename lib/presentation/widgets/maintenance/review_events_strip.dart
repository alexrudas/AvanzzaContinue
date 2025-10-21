import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin/maintenance/review_events_controller.dart';

/// Panel colapsable de "Eventos por revisar"
/// - Inicia colapsado para ahorrar espacio.
/// - Muestra contador y punto rojo si hay urgentes.
/// - Al expandir, lista los eventos con acción rápida.
/// - Skeleton y early-return si no hay eventos.
class ReviewEventsStrip extends GetView<ReviewEventsController> {
  const ReviewEventsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isLoading.value) return _buildLoadingSkeleton();
      if (controller.events.isEmpty) return const SizedBox.shrink();

      final total = controller.events.length;
      final hasUrgent = controller.events.any((e) => e.isUrgent);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0), // orange 50
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB3E5FC)), // borde sutil
          boxShadow: const [
            BoxShadow(color: Color(0xFFFFCC80)),
          ],
        ),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.grey.shade100),
          child: ExpansionTile(
            // colapsado por defecto
            title: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Ícono circular con tono institucional
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Color(0xFFFFA000), // azul petróleo (marca Avanzza)
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    if (hasUrgent)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                const Text(
                  'Eventos por revisar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$total',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              if (total > 3)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Reemplaza por tu navegación real si aplica
                          Get.snackbar('Eventos', 'Abriendo vista completa...',
                              snackPosition: SnackPosition.BOTTOM);
                        },
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),
                ),
              const Divider(height: 1),
              ...controller.events
                  .map((event) => _buildEventTile(context, event)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, ReviewEvent event) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => controller.openEventDetail(event),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTypeColor(event.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(event.icon,
                      size: 20, color: _getTypeColor(event.type)),
                ),
                if (event.isUrgent)
                  const Positioned(
                    top: -4,
                    right: -4,
                    child: CircleAvatar(
                        backgroundColor: Color(0xFFEF4444), radius: 6),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => controller.markAsReviewed(event.id),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Revisar', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(ReviewEventType type) {
    switch (type) {
      case ReviewEventType.documentExpiry:
        return const Color(0xFFF97316);
      case ReviewEventType.maintenanceOverdue:
        return const Color(0xFFEF4444);
      case ReviewEventType.incidentPending:
        return const Color(0xFF2563EB);
      case ReviewEventType.approvalRequired:
        return const Color(0xFF10B981);
    }
  }
}
