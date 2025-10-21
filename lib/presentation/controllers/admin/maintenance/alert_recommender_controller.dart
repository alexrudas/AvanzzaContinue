import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modelo para una alerta/recomendación contextual
class SmartAlert {
  final String id;
  final String title;
  final String description;
  final String? providerName;
  final String? providerLogo; // URL o asset path
  final String ctaText;
  final VoidCallback? onTap;
  final AlertType type;

  const SmartAlert({
    required this.id,
    required this.title,
    required this.description,
    this.providerName,
    this.providerLogo,
    this.ctaText = 'Ver más',
    this.onTap,
    this.type = AlertType.info,
  });
}

enum AlertType {
  critical, // Rojo - Requiere acción inmediata
  warning,  // Naranja - Atención requerida
  info,     // Azul - Informativo
  success,  // Verde - Positivo
}

/// Controlador para banner inteligente contextual
///
/// Gestiona alertas dinámicas basadas en:
/// - Kilometraje próximo a mantenimiento
/// - Vencimientos de documentos
/// - Recomendaciones de proveedores
class AlertRecommenderController extends GetxController {
  final Rxn<SmartAlert> currentAlert = Rxn<SmartAlert>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentAlert();
  }

  Future<void> _loadCurrentAlert() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock: Simula una alerta de proveedor aliado
    currentAlert.value = SmartAlert(
      id: 'alert_001',
      title: 'Mantenimiento preventivo próximo',
      description: 'Te faltan 1.200 km para cambio de llantas 185/65 R15',
      providerName: 'Goodyear',
      providerLogo: null, // En producción: URL del logo
      ctaText: 'Cotizar ahora',
      type: AlertType.warning,
      onTap: () {
        Get.snackbar(
          'Cotización',
          'Abriendo cotización con Goodyear...',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );

    isLoading.value = false;
  }

  /// Descarta alerta actual (el usuario la cerró)
  void dismissAlert() {
    currentAlert.value = null;
  }

  /// Refresca alertas manualmente
  Future<void> refreshAlerts() async {
    await _loadCurrentAlert();
  }
}
