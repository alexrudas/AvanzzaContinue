# Admin Maintenance Implementation - Parte 2

## 📋 8. ReviewEventsStrip

**Archivo**: `lib/presentation/widgets/maintenance/review_events_strip.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin/maintenance/review_events_controller.dart';

/// Tira horizontal de eventos pendientes de revisión
///
/// Muestra hasta 3 eventos más recientes con acciones rápidas
class ReviewEventsStrip extends GetView<ReviewEventsController> {
  const ReviewEventsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingSkeleton();
      }

      if (controller.events.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 20,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Eventos por revisar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (controller.events.length > 3)
                    TextButton(
                      onPressed: () {
                        Get.snackbar(
                          'Eventos',
                          'Abriendo vista completa...',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text('Ver todos'),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Lista de eventos (máximo 3)
            ...controller.events.take(3).map((event) {
              return _buildEventTile(context, event);
            }),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 150,
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
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100),
          ),
        ),
        child: Row(
          children: [
            // Icono con badge si es urgente
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTypeColor(event.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    event.icon,
                    size: 20,
                    color: _getTypeColor(event.type),
                  ),
                ),
                if (event.isUrgent)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Botón de acción
            TextButton(
              onPressed: () => controller.markAsReviewed(event.id),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Revisar',
                style: TextStyle(fontSize: 12),
              ),
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
```

---

## 🗂️ 9. MaintenanceCard

**Archivo**: `lib/presentation/widgets/maintenance/maintenance_card.dart`

```dart
import 'package:flutter/material.dart';

/// Modelo simplificado para item de mantenimiento en lista
class MaintenanceItem {
  final String id;
  final String assetName;
  final String? assetPlate;
  final String description;
  final DateTime date;
  final String status;
  final Color statusColor;
  final double? cost;
  final String? providerName;

  const MaintenanceItem({
    required this.id,
    required this.assetName,
    this.assetPlate,
    required this.description,
    required this.date,
    required this.status,
    required this.statusColor,
    this.cost,
    this.providerName,
  });
}

/// Card individual para items de mantenimiento
class MaintenanceCard extends StatelessWidget {
  final MaintenanceItem item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onFinalize;

  const MaintenanceCard({
    super.key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onFinalize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.assetName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.assetPlate != null)
                          Text(
                            item.assetPlate!,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(item.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (item.cost != null) ...[
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    Text(
                      _formatCurrency(item.cost!),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (item.providerName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.providerName!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              if (onEdit != null || onFinalize != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Editar'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    if (onEdit != null && onFinalize != null)
                      const SizedBox(width: 8),
                    if (onFinalize != null)
                      FilledButton.icon(
                        onPressed: onFinalize,
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text('Finalizar'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: const Color(0xFF10B981),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }
}
```

Continúa en el siguiente mensaje con MaintenanceOperationalPanel, FabActionsSheet y AdminMaintenancePage completa...