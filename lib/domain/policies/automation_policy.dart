/// Automation Policy - Contrato abstracto para decisiones de automatización
///
/// Define qué operaciones pueden ejecutarse automáticamente.
/// El contexto se resuelve en la implementación (vía PolicyContextFactory)
/// y se inyecta en el constructor.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La automatización afecta SOLO ejecución, NUNCA el ledger.
/// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.

/// Contrato abstracto para políticas de automatización
///
/// Las políticas de automatización determinan qué operaciones
/// pueden ejecutarse de forma automática sin intervención manual.
///
/// Implementations must be deterministic and side-effect free.
///
/// REGLAS:
/// - NO preguntar "¿Es informal?" directamente
/// - Exponer decisiones abstractas (canAutoCharge, canCreateDebt)
/// - NO acceder a bases de datos
/// - NO ejecutar side-effects
/// - NO modificar entidades
abstract class AutomationPolicy {
  bool canAutoCharge();
  bool canCreateDebt();
}
