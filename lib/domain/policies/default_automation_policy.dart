/// Default Automation Policy - Implementación por defecto de AutomationPolicy
///
/// Implementa las decisiones de automatización basándose en PolicyContext.
/// Lógica determinista y pura: sin side-effects, sin acceso a DB.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La automatización afecta SOLO ejecución, NUNCA el ledger.
/// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.
library;

import 'automation_policy.dart';
import 'policy_context.dart';
import 'policy_context_factory.dart';

/// Implementación por defecto de AutomationPolicy
///
/// Utiliza PolicyContextFactory para obtener el contexto actual
/// y toma decisiones deterministas basadas en ese contexto.
///
/// LÓGICA (Open/Closed - no modificar sin cambiar contrato):
/// - Si legalStatus == informal => false
/// - En cualquier otro caso => true
class DefaultAutomationPolicy implements AutomationPolicy {
  final PolicyContextFactory _factory;

  const DefaultAutomationPolicy(this._factory);

  @override
  bool canAutoCharge() {
    final ctx = _factory.fromCurrentSession();
    if (_isBlockedByLegalStatus(ctx)) return false;
    return true;
  }

  @override
  bool canCreateDebt() {
    final ctx = _factory.fromCurrentSession();
    if (_isBlockedByLegalStatus(ctx)) return false;
    return true;
  }

  bool _isBlockedByLegalStatus(PolicyContext ctx) {
    return ctx.legalStatus == LegalStatus.informal;
  }
}
