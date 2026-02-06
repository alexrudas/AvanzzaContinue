/// Default Access Policy - Implementación por defecto de AccessPolicy
///
/// Implementa las decisiones de visibilidad basándose en PolicyContext.
/// Lógica determinista y pura: sin side-effects, sin acceso a DB.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La automatización afecta SOLO ejecución, NUNCA el ledger.
/// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.
///
/// NOTA ARQUITECTÓNICA (Offline-First):
/// En arquitectura Offline-First, la falta de contrato puede bloquear
/// Sincronización y Ejecución, pero NO la Visibilidad de datos históricos
/// locales (Isar). Bloquear visibilidad local por contrato es anti-patrón
/// ("Data Hostage"). Por tanto, AccessPolicy depende EXCLUSIVAMENTE del Rol.
library;

import 'access_policy.dart';
import 'policy_context.dart';
import 'policy_context_factory.dart';

/// Implementación por defecto de AccessPolicy
///
/// Utiliza PolicyContextFactory para obtener el contexto actual
/// y toma decisiones deterministas basadas en ese contexto.
///
/// LÓGICA (Open/Closed - no modificar sin cambiar contrato):
/// - Si role == owner OR role == admin => true
/// - else => false
class DefaultAccessPolicy implements AccessPolicy {
  final PolicyContextFactory _factory;

  const DefaultAccessPolicy(this._factory);

  @override
  bool canSeeFinancialSummary() {
    final ctx = _factory.fromCurrentSession();
    return ctx.role == Role.owner || ctx.role == Role.admin;
  }
}
