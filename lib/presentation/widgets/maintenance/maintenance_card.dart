import 'package:flutter/material.dart';
import 'package:avanzza/presentation/controllers/admin/maintenance/maintenance_item.dart' as model;

/// Card individual para items de mantenimiento
///
/// Muestra información resumida y botones de acción
class MaintenanceCard extends StatelessWidget {
  final model.MaintenanceItem item;
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

  // Helper para obtener color según status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
      case 'abierta':
        return const Color(0xFFF97316); // Orange
      case 'en_proceso':
      case 'proceso':
        return const Color(0xFF3B82F6); // Blue
      case 'finalizado':
      case 'completado':
        return const Color(0xFF10B981); // Green
      case 'cancelado':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF64748B); // Gray
    }
  }

  // Helper para obtener color según prioridad
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'alta':
      case 'high':
        return const Color(0xFFEF4444); // Red
      case 'media':
      case 'medium':
        return const Color(0xFFF97316); // Orange
      case 'baja':
      case 'low':
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFF64748B); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(item.status);

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
              // Header: Activo + Status chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.assetName ?? 'Sin activo',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.subtitle != null)
                          Text(
                            item.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Descripción (title)
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer: Fecha, tipo, prioridad
              Row(
                children: [
                  // Fecha
                  if (item.date != null) ...[
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(item.date!),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],

                  const SizedBox(width: 16),

                  // Tipo de mantenimiento
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.type,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Prioridad
                  if (item.priority != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(item.priority!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.priority!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(item.priority!),
                        ),
                      ),
                    ),
                ],
              ),

              // Botones de acción
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
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
