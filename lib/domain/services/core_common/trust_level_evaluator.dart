// ============================================================================
// lib/domain/services/core_common/trust_level_evaluator.dart
// TRUST LEVEL EVALUATOR — Core Common v1 / Función pura (F4.a)
// ============================================================================
// QUÉ HACE:
//   - Decide el MatchTrustLevel (alto | medio | bajo) al cruzar las llaves
//     verificadas de un candidato (actor en plataforma) con las llaves
//     probadas de un registro local.
//
// QUÉ NO HACE:
//   - No normaliza (eso es KeyNormalizer).
//   - No decide exposición al workspace (eso es la regla de exposición en
//     MatchTrustLevelX.promotesToExposure + el servicio del matcher).
//   - No tiene estado. No hace I/O. Sin heurísticas opacas. Sin ML.
//
// PRINCIPIOS:
//   - Función pura. Mismas entradas → mismo output, siempre.
//   - Reglas explícitas por actorKind + keyType. Sin combo-boost:
//     el trust level resultante es el MÁXIMO individual entre las
//     coincidencias; dos llaves 'medio' NO escalan a 'alto'.
//   - Las entradas deben estar pre-normalizadas (NormalizedKey).
//
// TABLA DE REGLAS (exhaustiva):
//   | candidateActorKind | matchedKeyType | trustLevel |
//   | ------------------ | -------------- | ---------- |
//   | organization       | docId (NIT)    | alto       |
//   | organization       | phoneE164      | medio      |
//   | organization       | email          | medio      |
//   | person             | phoneE164      | alto       |
//   | person             | docId          | medio      |
//   | person             | email          | medio      |
//   | cualquiera         | sin match      | bajo       |
//
// REUSO BACKEND:
//   - Esta lógica debe replicarse idéntica en el matcher de NestJS para que
//     cliente y backend evalúen con la misma autoridad.
// ============================================================================

import '../../entities/core_common/value_objects/actor_kind.dart';
import '../../entities/core_common/value_objects/match_trust_level.dart';
import '../../entities/core_common/value_objects/normalized_key.dart';
import '../../entities/core_common/value_objects/verified_key_type.dart';

/// Cruza [candidateKeys] (llaves verificadas del actor en plataforma) con
/// [localProbes] (llaves probadas del registro local) y retorna el trust
/// level resultante.
///
/// Semántica:
///   - Si alguna llave del mismo tipo y valor coincide exactamente, aplica
///     la regla de la tabla según [candidateActorKind] + keyType.
///   - Si no hay coincidencias, retorna MatchTrustLevel.bajo.
///   - Si hay múltiples coincidencias, retorna el nivel más alto entre ellas.
MatchTrustLevel evaluateTrust({
  required ActorKind candidateActorKind,
  required List<NormalizedKey> candidateKeys,
  required List<NormalizedKey> localProbes,
}) {
  if (candidateKeys.isEmpty || localProbes.isEmpty) {
    return MatchTrustLevel.bajo;
  }

  // Índice O(1) de llaves del candidato.
  final candidateSet = <NormalizedKey>{...candidateKeys};

  var best = MatchTrustLevel.bajo;
  for (final probe in localProbes) {
    if (!candidateSet.contains(probe)) continue;
    final level = _levelForKey(candidateActorKind, probe.keyType);
    if (_rank(level) > _rank(best)) {
      best = level;
      if (best == MatchTrustLevel.alto) return best; // early exit
    }
  }
  return best;
}

/// Mapeo explícito actorKind + keyType → trust level.
/// Sin heurísticas: toda combinación tiene una salida determinística.
MatchTrustLevel _levelForKey(ActorKind kind, VerifiedKeyType keyType) {
  switch (kind) {
    case ActorKind.organization:
      switch (keyType) {
        case VerifiedKeyType.docId:
          return MatchTrustLevel.alto;
        case VerifiedKeyType.phoneE164:
        case VerifiedKeyType.email:
          return MatchTrustLevel.medio;
      }
    case ActorKind.person:
      switch (keyType) {
        case VerifiedKeyType.phoneE164:
          return MatchTrustLevel.alto;
        case VerifiedKeyType.docId:
        case VerifiedKeyType.email:
          return MatchTrustLevel.medio;
      }
  }
}

/// Orden total de MatchTrustLevel para comparación.
int _rank(MatchTrustLevel level) {
  switch (level) {
    case MatchTrustLevel.alto:
      return 3;
    case MatchTrustLevel.medio:
      return 2;
    case MatchTrustLevel.bajo:
      return 1;
  }
}
