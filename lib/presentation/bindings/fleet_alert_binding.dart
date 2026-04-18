// ============================================================================
// lib/presentation/bindings/fleet_alert_binding.dart
// FLEET ALERT BINDING — Binding GetX para FleetAlertListPage
//
// QUÉ HACE:
// - Registra FleetAlertController via Get.lazyPut para la ruta /alerts/fleet.
//
// QUÉ NO HACE:
// - No registra repositorios ni servicios (eso es DIContainer).
//
// PRINCIPIOS:
// - fenix: true → el controller sobrevive pops a Niveles 2 y 3 sin destruirse.
//   Al volver al Nivel 1, el controller sigue activo y el cache TTL evita
//   re-fetch innecesario.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'package:get/get.dart';

import '../controllers/alerts/fleet_alert_controller.dart';

class FleetAlertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FleetAlertController>(
      () => FleetAlertController(),
      fenix: true,
    );
  }
}
