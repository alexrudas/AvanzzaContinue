// ============================================================================
// lib/domain/repositories/capability/regulator_license_validator.dart
// RegulatorLicenseValidator — contrato de validación semántica para
// RegulatorLicenseRef contra el regulador externo del país correspondiente.
// ============================================================================
// QUÉ HACE:
//   - Define el contrato que el dominio espera para validar que una licencia
//     regulatoria está vigente ante el regulador del país aplicable
//     (ej: SFC en CO, NAIC en US).
//   - Retorna un resultado discriminado: vigente / no encontrada / suspendida /
//     revocada / no aplica para el país.
//
// QUÉ NO HACE:
//   - NO define la implementación. La impl vive en data layer y consulta el
//     servicio externo correspondiente (con cacheo offline si aplica).
//   - NO valida la sintaxis de la licencia; eso ya lo garantiza
//     RegulatorLicenseRef en su constructor.
//   - NO infiere el regulador desde la licencia. El countryId se pasa como
//     contexto explícito.
//
// CICLO DE VALIDACIÓN (canónico):
//   1. Construir RegulatorLicenseRef(...) → garantiza sintaxis.
//   2. Llamar validator.validate(ref, countryId: ...) antes de promover el
//      workspace a aseguradora autorizada (CapabilityProfile.kind == insurer).
//   3. Si status != active, rechazar la operación con el error apropiado.
// ============================================================================

import '../../value/capability/refs/regulator_license_ref.dart';

enum RegulatorLicenseStatus {
  /// Licencia vigente ante el regulador.
  active,

  /// No encontrada en el registro del regulador.
  notFound,

  /// Encontrada pero suspendida temporalmente.
  suspended,

  /// Encontrada pero revocada / cancelada.
  revoked,

  /// El regulador del país especificado no tiene/expone este tipo de
  /// licencia, o la consulta no aplica para ese countryId.
  notApplicable,

  /// El servicio del regulador no respondió y la verificación quedó pendiente.
  /// El consumidor decide si encolar reintento o aceptar provisionalmente.
  unavailable,
}

class RegulatorLicenseValidationResult {
  final RegulatorLicenseRef ref;
  final String countryId;
  final RegulatorLicenseStatus status;
  final DateTime checkedAt;

  /// Mensaje crudo del regulador / impl, opcional. Útil para soporte.
  final String? regulatorMessage;

  const RegulatorLicenseValidationResult({
    required this.ref,
    required this.countryId,
    required this.status,
    required this.checkedAt,
    this.regulatorMessage,
  });

  bool get isActive => status == RegulatorLicenseStatus.active;
}

abstract class RegulatorLicenseValidator {
  /// Valida que [ref] esté vigente ante el regulador correspondiente al
  /// [countryId]. Nunca lanza por errores de red — esos casos retornan
  /// [RegulatorLicenseStatus.unavailable] para que el consumidor decida.
  ///
  /// Solo lanza si [countryId] no está soportado por la implementación o
  /// si la pre-condición sintáctica falla (en cuyo caso es bug del caller,
  /// no error operativo).
  Future<RegulatorLicenseValidationResult> validate(
    RegulatorLicenseRef ref, {
    required String countryId,
  });
}
