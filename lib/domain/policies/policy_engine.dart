/// Policy Engine - Agregador de políticas del sistema
///
/// Agrupa todas las políticas en un único punto de acceso.
/// SIN lógica de negocio, solo composición.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La automatización afecta SOLO ejecución, NUNCA el ledger.
/// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.
library;

import 'automation_policy.dart';
import 'payout_policy.dart';
import 'access_policy.dart';

/// Agregador de políticas del sistema
///
/// Provee acceso centralizado a todas las políticas.
/// Registrado como singleton en DIContainer.
class PolicyEngine {
  final AutomationPolicy automationPolicy;
  final PayoutPolicy payoutPolicy;
  final AccessPolicy accessPolicy;

  const PolicyEngine({
    required this.automationPolicy,
    required this.payoutPolicy,
    required this.accessPolicy,
  });
}
