// ============================================================================
// lib/domain/value/accounting/collection_method.dart
// COLLECTION METHOD — Enterprise Ultra Pro (Domain / Value)
//
// QUÉ HACE:
// - Define el enum canónico CollectionMethod (método de cobro/pago).
// - Provee CollectionMethodPolicyX: extensión con getters de política (needs*).
// - Fuente única de verdad: CxC y CxP importan desde aquí.
//
// QUÉ NO HACE:
// - NO importa Flutter ni GetX (Dart puro — sin ciclos de importación).
// - NO contiene mensajes de error (viven en controller / presentation).
// - NO valida valores de campos (solo indica si el campo es requerido).
//
// POLÍTICA CANÓNICA (tabla definitiva):
// | Método        | banco | referencia | last4 | nota |
// |---------------|-------|------------|-------|------|
// | efectivo      |  —    |    —       |  —    |  —   |
// | transferencia |  ✓    |    ✓       |  —    |  —   |
// | debito        |  ✓    |    ✓       |  ✓    |  —   |
// | credito       |  ✓    |    ✓       |  ✓    |  —   |
// | cheque        |  ✓    |    ✓       |  —    |  —   |
// | otro          |  —    |    —       |  —    |  ✓   |
// ============================================================================

/// Método de cobro/pago. Enum canónico — único en todo el proyecto.
enum CollectionMethod {
  efectivo,
  transferencia,
  debito,
  credito,
  cheque,
  otro,
}

/// Extensión de política de campos por método.
///
/// Getters puros — sin efectos secundarios, sin estado.
/// Consumir como: `p.method.needsBanco`, `p.method.needsLast4`, etc.
extension CollectionMethodPolicyX on CollectionMethod {
  /// Banco requerido para: transferencia, débito, crédito, cheque.
  bool get needsBanco =>
      this == CollectionMethod.transferencia ||
      this == CollectionMethod.debito ||
      this == CollectionMethod.credito ||
      this == CollectionMethod.cheque;

  /// Referencia (No. transacción / No. cheque) requerida para los mismos
  /// que necesitan banco. "Otro" NO requiere referencia; su evidencia es nota.
  bool get needsReferencia =>
      this == CollectionMethod.transferencia ||
      this == CollectionMethod.debito ||
      this == CollectionMethod.credito ||
      this == CollectionMethod.cheque;

  /// Últimos 4 dígitos de tarjeta: solo débito y crédito.
  bool get needsLast4 =>
      this == CollectionMethod.debito || this == CollectionMethod.credito;

  /// Nota justificativa obligatoria: solo para método "Otro".
  bool get needsNota => this == CollectionMethod.otro;
}
