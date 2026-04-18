// ============================================================================
// lib/domain/entities/core_common/verified_key_entity.dart
// VERIFIED KEY ENTITY — Core Common v1 / Capa de Plataforma
// ============================================================================
// QUÉ HACE:
//   - Representa una llave de contacto verificada asociada a un PlatformActor.
//   - Es el sustrato sobre el que opera el matcher (F4).
//
// QUÉ NO HACE:
//   - No normaliza valores (KeyNormalizer los trae ya normalizados).
//   - No ejecuta verificación: asume que el flujo de verificación ya ocurrió.
//   - No guarda secretos (OTP, códigos, etc.): solo el resultado verificado.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - A cada PlatformActor le debe corresponder al menos una VerifiedKey con
//     isPrimary=true (invariante de creación; se valida en la capa de servicio).
//   - Las llaves revocadas permanecen para auditoría (revokedAt != null) pero
//     NO son elegibles para el matcher.
//   - Enums serializados vía @JsonValue (wire-stable).
//
// ENTERPRISE NOTES:
//   - keyValueNormalized: E.164 para phoneE164, lowercase para email,
//     sin puntuación ni DV para docId (NIT o cédula).
//   - verificationMethod documenta cómo se obtuvo la verificación.
//   - revokedReason es texto libre para auditoría humana; sin semántica técnica.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/verification_method.dart';
import 'value_objects/verified_key_type.dart';

part 'verified_key_entity.freezed.dart';
part 'verified_key_entity.g.dart';

/// Llave verificada asociada a un PlatformActor.
/// SSOT global. El workspace nunca escribe sobre esta entidad.
@freezed
abstract class VerifiedKeyEntity with _$VerifiedKeyEntity {
  const factory VerifiedKeyEntity({
    required String id,

    /// FK al PlatformActor dueño de la llave.
    required String platformActorId,

    /// Tipo de llave (phoneE164 / email / docId).
    required VerifiedKeyType keyType,

    /// Valor normalizado de la llave (input estable del matcher).
    required String keyValueNormalized,

    required DateTime verifiedAt,

    /// Método con el que se verificó.
    required VerificationMethod verificationMethod,

    /// Flag de llave principal del actor. Exactamente una por actor = true.
    required bool isPrimary,

    /// Timestamp de revocación. Null = llave vigente.
    DateTime? revokedAt,

    /// Motivo humano-legible de revocación (auditoría).
    String? revokedReason,
  }) = _VerifiedKeyEntity;

  factory VerifiedKeyEntity.fromJson(Map<String, dynamic> json) =>
      _$VerifiedKeyEntityFromJson(json);
}
