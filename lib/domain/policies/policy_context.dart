/// Policy Context - Contexto inmutable para evaluación de políticas
///
/// Este archivo define el contexto necesario para que las políticas
/// tomen decisiones de automatización, pago y acceso.
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La informalidad NO afecta el registro financiero (ledger).
/// La informalidad SOLO afecta automatización, ejecución y visibilidad.
library;

import 'policy_types.dart';

export 'policy_types.dart' show Role, LegalStatus;

/// Contexto inmutable para evaluación de políticas
///
/// Contiene toda la información necesaria para que las políticas
/// tomen decisiones sin acceder a bases de datos ni servicios externos.
///
/// INMUTABLE: Una vez creado, no puede modificarse.
/// WIRE-STABLE: Todos los campos son serializables.
class PolicyContext {
  /// Rol del usuario en el contexto actual
  final Role role;

  /// Estado legal del propietario del activo
  ///
  /// NOTA: Afecta SOLO automatización, NUNCA el ledger.
  final LegalStatus legalStatus;

  /// Código ISO del país (ej: 'CO', 'MX', 'US')
  final String countryCode;

  /// Indica si existe un contrato activo
  final bool hasActiveContract;

  const PolicyContext({
    required this.role,
    required this.legalStatus,
    required this.countryCode,
    required this.hasActiveContract,
  });

  /// Contexto por defecto (fail-safe)
  ///
  /// Usado cuando no hay sesión activa o datos incompletos.
  /// Retorna valores que bloquean automatización por seguridad.
  factory PolicyContext.failSafe() {
    return const PolicyContext(
      role: Role.tenant,
      legalStatus: LegalStatus.informal,
      countryCode: 'XX',
      hasActiveContract: false,
    );
  }

  @override
  String toString() {
    return 'PolicyContext('
        'role: ${role.wireName}, '
        'legalStatus: ${legalStatus.wireName}, '
        'countryCode: $countryCode, '
        'hasActiveContract: $hasActiveContract)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PolicyContext &&
        other.role == role &&
        other.legalStatus == legalStatus &&
        other.countryCode == countryCode &&
        other.hasActiveContract == hasActiveContract;
  }

  @override
  int get hashCode {
    return Object.hash(role, legalStatus, countryCode, hasActiveContract);
  }
}
