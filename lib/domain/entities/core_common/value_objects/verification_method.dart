// ============================================================================
// lib/domain/entities/core_common/value_objects/verification_method.dart
// Método de verificación de una VerifiedKey (Core Common v1).
// ============================================================================
// Qué hace:
//   - Registra cómo se verificó una llave (OTP, magic link, documento).
//   - Se usa como metadato de confianza por el TrustLevelEvaluator.
//
// Qué NO hace:
//   - No ejecuta verificación: es solo el catálogo tipado de métodos.
//   - No incluye métodos biométricos / firma digital (fuera de v1).
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//
// Enterprise Notes:
//   - OTP aplica a phoneE164.
//   - magicLink aplica a email.
//   - docCheck aplica a docId (verificación contra fuente oficial o manual).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Método con el que se verificó una VerifiedKey.
enum VerificationMethod {
  /// One-time password (SMS o canal equivalente), típico para phoneE164.
  @JsonValue('otp')
  otp,

  /// Link de verificación enviado por email.
  @JsonValue('magicLink')
  magicLink,

  /// Verificación de documento (cédula / NIT) contra fuente oficial o proceso manual.
  @JsonValue('docCheck')
  docCheck,
}

/// Extensión con wire names estables.
extension VerificationMethodX on VerificationMethod {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case VerificationMethod.otp:
        return 'otp';
      case VerificationMethod.magicLink:
        return 'magicLink';
      case VerificationMethod.docCheck:
        return 'docCheck';
    }
  }

  /// Parse estricto desde wire.
  static VerificationMethod fromWire(String raw) {
    switch (raw) {
      case 'otp':
        return VerificationMethod.otp;
      case 'magicLink':
        return VerificationMethod.magicLink;
      case 'docCheck':
        return VerificationMethod.docCheck;
      default:
        throw ArgumentError('VerificationMethod desconocido: $raw');
    }
  }
}
