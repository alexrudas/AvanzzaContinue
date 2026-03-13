// ============================================================================
// lib/domain/errors/asset_creation_exception.dart
// ASSET CREATION EXCEPTION — Enterprise Ultra Pro (Domain / Errors)
//
// QUÉ HACE:
// - Define la excepción de dominio para fallos en la creación de activos.
// - Expone un [code] semántico estable para ramificación segura en capas
//   superiores (UseCases, Controllers).
// - Centraliza mensajes mediante factory constructors canónicos.
// - Evita duplicación de strings en repositorios y capa de aplicación.
//
// QUÉ NO HACE:
// - No depende de Flutter, GetX, Isar ni infraestructura.
// - No expone detalles técnicos internos.
// - No hereda de Error (no es fallo de programación).
//
// PRINCIPIO:
// - El dominio nunca filtra errores técnicos crudos.
// - Los códigos son el contrato estable; los mensajes pueden evolucionar.
//
// ============================================================================

/// Excepción de dominio para fallos en la creación de activos.
///
/// El [code] permite que capas superiores reaccionen de forma determinística
/// sin hacer pattern-matching de strings.
///
/// USO RECOMENDADO:
/// ```dart
/// throw AssetCreationException.duplicatePlate();
/// throw AssetCreationException.validationError('portfolioId vacío.');
/// ```
///
/// CAPTURA:
/// ```dart
/// } on AssetCreationException catch (e) {
///   if (e.code == AssetCreationExceptionCode.duplicatePlate) { ... }
/// }
/// ```
class AssetCreationException implements Exception {
  /// Mensaje legible por humanos.
  /// NUNCA debe contener detalles técnicos internos.
  final String message;

  /// Código semántico estable.
  /// Usar siempre valores definidos en [AssetCreationExceptionCode].
  final String code;

  const AssetCreationException._(this.message, this.code);

  // ---------------------------------------------------------------------------
  // FACTORY CONSTRUCTORS CANÓNICOS
  // ---------------------------------------------------------------------------

  /// La placa ya existe en la base local.
  factory AssetCreationException.duplicatePlate() =>
      const AssetCreationException._(
        'Ya existe un activo registrado con esta placa.',
        AssetCreationExceptionCode.duplicatePlate,
      );

  /// Error genérico de escritura en almacenamiento local.
  factory AssetCreationException.isarWriteFailed() =>
      const AssetCreationException._(
        'No fue posible guardar el activo en la base local.',
        AssetCreationExceptionCode.isarWriteFailed,
      );

  /// El portafolio no pudo actualizarse o no existe.
  factory AssetCreationException.portfolioUpdateFailed() =>
      const AssetCreationException._(
        'El portafolio no pudo actualizarse correctamente.',
        AssetCreationExceptionCode.portfolioUpdateFailed,
      );

  /// Error de validación previo a iniciar la transacción.
  factory AssetCreationException.validationError(String message) =>
      AssetCreationException._(
        message,
        AssetCreationExceptionCode.validationError,
      );

  /// Error no previsto.
  factory AssetCreationException.unknown([String? message]) =>
      AssetCreationException._(
        message ?? 'Ocurrió un error inesperado al crear el activo.',
        AssetCreationExceptionCode.unknownError,
      );

  // ---------------------------------------------------------------------------
  // EQUALITY — Útil para testing determinístico
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetCreationException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  // ---------------------------------------------------------------------------
  // DEBUG REPRESENTATION
  // ---------------------------------------------------------------------------

  @override
  String toString() => 'AssetCreationException[$code]: $message';
}

// ============================================================================
// CÓDIGOS CANÓNICOS (CONTRATO ESTABLE)
// ============================================================================

/// Contrato estable de códigos.
/// Mantener estos valores inmutables para evitar romper integraciones.
abstract final class AssetCreationExceptionCode {
  static const String validationError = 'validation_error';
  static const String duplicatePlate = 'duplicate_plate';
  static const String isarWriteFailed = 'isar_write_failed';
  static const String portfolioUpdateFailed = 'portfolio_update_failed';
  static const String unknownError = 'unknown_error';
}
