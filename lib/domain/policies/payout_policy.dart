// Payout Policy - Contrato abstracto para decisiones de desembolso
//
// Define si los pagos y cobros de comisiones pueden ejecutarse automáticamente.
// El contexto se resuelve en la implementación (vía PolicyContextFactory)
// y se inyecta en el constructor.
//
// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
// La automatización afecta SOLO ejecución, NUNCA el ledger.
// El registro financiero (Event -> Impact -> Ledger) es SIEMPRE inmutable.

/// Contrato abstracto para políticas de desembolso y comisiones
///
/// Las políticas determinan si los movimientos de fondos (hacia terceros
/// o hacia la administración) pueden ejecutarse automáticamente.
///
/// Implementations must be deterministic and side-effect free.
///
/// REGLAS:
/// - NO preguntar "¿Es informal?" directamente
/// - Exponer decisiones abstractas diferenciadas
/// - NO acceder a bases de datos
/// - NO ejecutar side-effects
/// - NO modificar entidades
abstract class PayoutPolicy {
  /// Determina si se pueden ejecutar pagos automáticos a terceros
  /// (Propietarios, Proveedores).
  bool canAutoPayout();

  /// Determina si se puede ejecutar el cobro automático de comisiones
  /// hacia la propia organización administradora (Revenue Share).
  bool canAutoCommissionPayout();
}
