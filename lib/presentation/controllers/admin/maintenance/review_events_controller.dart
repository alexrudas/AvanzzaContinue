import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modelo para un evento pendiente de revisión
class ReviewEvent {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime timestamp;
  final ReviewEventType type;
  final bool isUrgent;

  const ReviewEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.timestamp,
    required this.type,
    this.isUrgent = false,
  });
}

enum ReviewEventType {
  documentExpiry,     // Documento por vencer
  maintenanceOverdue, // Mantenimiento atrasado
  incidentPending,    // Incidencia sin asignar
  approvalRequired,   // Requiere aprobación
}

/// Controlador para eventos/alertas que requieren revisión
///
/// Muestra notificaciones y acciones pendientes del administrador
class ReviewEventsController extends GetxController {
  final events = <ReviewEvent>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock: Simula 3 eventos
    events.value = [
      ReviewEvent(
        id: 'evt_001',
        title: 'SOAT próximo a vencer',
        description: 'Vehículo ABC-123 - Vence en 5 días',
        icon: Icons.description_outlined,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: ReviewEventType.documentExpiry,
        isUrgent: true,
      ),
      ReviewEvent(
        id: 'evt_002',
        title: 'Incidencia sin asignar',
        description: 'Cambio de aceite - Sin proveedor asignado',
        icon: Icons.assignment_late_outlined,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: ReviewEventType.incidentPending,
      ),
      ReviewEvent(
        id: 'evt_003',
        title: 'Aprobación de cotización',
        description: 'Mantenimiento correctivo \$2,500,000',
        icon: Icons.check_circle_outline,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: ReviewEventType.approvalRequired,
      ),
    ];

    isLoading.value = false;
  }

  /// Marca evento como revisado
  void markAsReviewed(String eventId) {
    events.removeWhere((e) => e.id == eventId);
  }

  /// Abre vista detallada de un evento
  void openEventDetail(ReviewEvent event) {
    Get.snackbar(
      'Evento',
      event.title,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Refresca eventos
  Future<void> refreshEvents() async {
    await _loadEvents();
  }
}
