import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin/maintenance/alert_recommender_controller.dart';

/// Banner inteligente contextual
///
/// Muestra alertas y recomendaciones personalizadas según el estado
/// de los activos y mantenimientos del usuario.
class SmartBannerWidget extends GetView<AlertRecommenderController> {
  const SmartBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final alert = controller.currentAlert.value;

      if (controller.isLoading.value) {
        return _buildLoadingSkeleton();
      }

      if (alert == null) {
        return const SizedBox.shrink();
      }

      return _buildAlertCard(context, alert);
    });
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, SmartAlert alert) {
    final bgColor = _getBackgroundColor(alert.type);
    final textColor = _getTextColor(alert.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo del proveedor (si existe)
          if (alert.providerName != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  alert.providerName![0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: bgColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (alert.providerName != null)
                  Text(
                    alert.providerName!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // CTA Button
          const SizedBox(width: 8),
          TextButton(
            onPressed: alert.onTap,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              alert.ctaText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Botón cerrar
          IconButton(
            icon: Icon(Icons.close, color: textColor, size: 18),
            onPressed: controller.dismissAlert,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(AlertType type) {
    switch (type) {
      case AlertType.critical:
        return const Color(0xFFEF4444);
      case AlertType.warning:
        return const Color(0xFFF97316);
      case AlertType.info:
        return const Color(0xFF2563EB);
      case AlertType.success:
        return const Color(0xFF10B981);
    }
  }

  Color _getTextColor(AlertType type) {
    return Colors.white;
  }
}
