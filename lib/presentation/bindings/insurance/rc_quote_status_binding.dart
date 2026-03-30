// ============================================================================
// lib/presentation/bindings/insurance/rc_quote_status_binding.dart
// RC QUOTE STATUS BINDING — Binding de la página de estado del lead.
//
// QUÉ HACE:
// - Extiende InsuranceBinding para garantizar que la infraestructura del flujo
//   esté registrada antes de registrar el controller de esta página.
// - Registra RcQuoteStatusController sin fenix: la página lo destruye al salir.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE.
// ============================================================================

import 'package:get/get.dart';

import '../../../domain/repositories/insurance_lead_repository.dart';
import '../../controllers/insurance/rc_quote_status_controller.dart';
import '../../controllers/session_context_controller.dart';
import 'insurance_binding.dart';

class RcQuoteStatusBinding extends InsuranceBinding {
  @override
  void dependencies() {
    super.dependencies(); // infraestructura compartida
    Get.lazyPut<RcQuoteStatusController>(
      () => RcQuoteStatusController(
        Get.find<InsuranceLeadRepository>(),
        Get.find<SessionContextController>(),
      ),
    );
  }
}
