// ============================================================================
// lib/presentation/bindings/alert_center_binding.dart
// ALERT CENTER BINDING — Binding GetX para AlertCenterPage
//
// QUÉ HACE:
// - Registra AlertCenterController via Get.lazyPut para la ruta /alerts/center.
//
// QUÉ NO HACE:
// - No registra repositorios ni servicios (eso es DIContainer).
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 5.5 — Ver ALERTS_SYSTEM_V4.md §18 Fase 5.5.
// ============================================================================

import 'package:get/get.dart';

import '../controllers/alerts/alert_center_controller.dart';

class AlertCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertCenterController>(() => AlertCenterController());
  }
}
