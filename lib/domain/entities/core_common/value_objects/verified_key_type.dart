// ============================================================================
// lib/domain/entities/core_common/value_objects/verified_key_type.dart
// Tipos de llave verificada asociada a un PlatformActor (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara los tipos de llave que el matcher reconoce como evidencia de identidad.
//   - Expone la jerarquía de fortaleza por ActorKind (organización vs persona).
//
// Qué NO hace:
//   - No normaliza valores (eso es KeyNormalizer en F4.a).
//   - No valida formato (E.164 regex, email regex, etc.).
//   - No persiste ni consulta; es solo el catálogo tipado de tipos válidos.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Solo llaves verificables cuentan para el matcher: nombre/alias/dirección
//     NUNCA son llave (ni siquiera débil).
//
// Enterprise Notes:
//   - phoneE164 es la llave principal recomendada por la tesis madre.
//   - docId cubre cédula (person) y NIT sin DV (organization).
//   - email es fallback de confianza media verificada.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Tipo de llave verificada que el matcher reconoce.
enum VerifiedKeyType {
  /// Teléfono móvil normalizado a E.164, verificado por OTP.
  @JsonValue('phoneE164')
  phoneE164,

  /// Email verificado por magic link.
  @JsonValue('email')
  email,

  /// Documento de identidad (cédula) o tributario (NIT sin DV), verificado.
  @JsonValue('docId')
  docId,
}

/// Extensión con wire names estables y clasificación de fortaleza por ActorKind.
extension VerifiedKeyTypeX on VerifiedKeyType {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case VerifiedKeyType.phoneE164:
        return 'phoneE164';
      case VerifiedKeyType.email:
        return 'email';
      case VerifiedKeyType.docId:
        return 'docId';
    }
  }

  /// Parse estricto desde wire.
  static VerifiedKeyType fromWire(String raw) {
    switch (raw) {
      case 'phoneE164':
        return VerifiedKeyType.phoneE164;
      case 'email':
        return VerifiedKeyType.email;
      case 'docId':
        return VerifiedKeyType.docId;
      default:
        throw ArgumentError('VerifiedKeyType desconocido: $raw');
    }
  }
}
