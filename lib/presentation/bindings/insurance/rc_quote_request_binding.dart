// ============================================================================
// lib/presentation/bindings/insurance/rc_quote_request_binding.dart
// RC QUOTE REQUEST BINDING — Binding de la página de solicitud de cotización.
//
// QUÉ HACE:
// - Extiende InsuranceBinding para garantizar que la infraestructura del flujo
//   esté registrada antes de registrar el controller de esta página.
// - Registra RcQuoteRequestController sin fenix: la página lo destruye al salir.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE.
// ============================================================================

import 'package:get/get.dart';

import '../../../domain/repositories/insurance_lead_repository.dart';
import '../../controllers/insurance/rc_quote_request_controller.dart';
import '../../controllers/session_context_controller.dart';
import 'insurance_binding.dart';

class RcQuoteRequestBinding extends InsuranceBinding {
  @override
  void dependencies() {
    super.dependencies(); // infraestructura compartida
    Get.lazyPut<RcQuoteRequestController>(
      () => RcQuoteRequestController(
        Get.find<InsuranceLeadRepository>(),
        Get.find<SessionContextController>(),
      ),
    );
  }
}
