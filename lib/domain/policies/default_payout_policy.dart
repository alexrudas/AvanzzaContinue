/// Default Payout Policy - Implementación por defecto de PayoutPolicy
///
/// Implementa las decisiones de desembolso y comisiones basándose en PolicyContext.
/// Lógica determinista y pura: sin side-effects, sin acceso a DB.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La automatización afecta SOLO ejecución, NUNCA el ledger.
/// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.
library;

import 'payout_policy.dart';
import 'policy_context.dart';
import 'policy_context_factory.dart';

/// Implementación por defecto de PayoutPolicy
///
/// Utiliza PolicyContextFactory para obtener el contexto actual
/// y toma decisiones deterministas basadas en ese contexto.
///
/// LÓGICA (Open/Closed - no modificar sin cambiar contrato):
/// - canAutoPayout: informal => false, else => true
/// - canAutoCommissionPayout: hasActiveContract => true, else => false
///
/// NOTA: Es válido que un informal NO reciba pagos automáticos
/// pero SÍ se le pueda cobrar comisión automática (si tiene contrato).
class DefaultPayoutPolicy implements PayoutPolicy {
  final PolicyContextFactory _factory;

  const DefaultPayoutPolicy(this._factory);

  @override
  bool canAutoPayout() {
    final ctx = _factory.fromCurrentSession();
    if (ctx.legalStatus == LegalStatus.informal) return false;
    return true;
  }

  @override
  bool canAutoCommissionPayout() {
    final ctx = _factory.fromCurrentSession();
    if (ctx.hasActiveContract) return true;
    return false;
  }
}
