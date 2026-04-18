// ============================================================================
// lib/domain/entities/core_common/value_objects/normalized_key.dart
// NORMALIZED KEY — Core Common v1 / Value Object (F4.a)
// ============================================================================
// QUÉ HACE:
//   - Par tipado (keyType, normalizedValue) que el matcher consume para
//     cruzar llaves entre registro local y actor de plataforma.
//
// QUÉ NO HACE:
//   - No normaliza (eso es KeyNormalizer).
//   - No almacena metadatos (fechas, verificación); esos viven en VerifiedKey.
//
// PRINCIPIOS:
//   - Dominio puro. Sin mutabilidad. Sin dependencias externas.
//   - Reusable por el cliente y por la lógica espejada en el backend.
// ============================================================================

import 'verified_key_type.dart';

/// Par tipado de llave ya normalizada, apto para comparación exacta.
class NormalizedKey {
  final VerifiedKeyType keyType;

  /// Valor ya normalizado por KeyNormalizer (E.164 para phone, lowercase+trim
  /// para email, solo dígitos para docId/taxId).
  final String normalizedValue;

  const NormalizedKey({
    required this.keyType,
    required this.normalizedValue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NormalizedKey &&
          other.keyType == keyType &&
          other.normalizedValue == normalizedValue);

  @override
  int get hashCode => Object.hash(keyType, normalizedValue);

  @override
  String toString() =>
      'NormalizedKey(${keyType.wireName}|$normalizedValue)';
}
