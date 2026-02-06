/// Access Policy - Contrato abstracto para decisiones de acceso y visibilidad
///
/// Define qué información es visible según el contexto.
/// El contexto se resuelve en la implementación (vía PolicyContextFactory)
/// y se inyecta en el constructor.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La automatización afecta SOLO ejecución, NUNCA el ledger.
/// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.
library;

/// Contrato abstracto para políticas de acceso
///
/// Las políticas de acceso determinan qué información
/// puede ser visible para el usuario.
///
/// Implementations must be deterministic and side-effect free.
///
/// REGLAS:
/// - NO preguntar "¿Es informal?" directamente
/// - Exponer decisiones abstractas
/// - NO acceder a bases de datos
/// - NO ejecutar side-effects
/// - NO modificar entidades
abstract class AccessPolicy {
  /// Determina si el usuario puede ver el resumen financiero.
  bool canSeeFinancialSummary();
}
