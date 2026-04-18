// ============================================================================
// lib/data/models/core_common/match_candidate_model.dart
// MATCH CANDIDATE MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste localmente los MatchCandidate visibles al workspace
//     (exposedToWorkspace / confirmedIntoRelationship).
//   - Guarda enums como String wire-stable; List<CollisionKind> como List<String>.
//
// QUÉ NO HACE:
//   - NO almacena candidatos 'detectedInternal': el cliente nunca los ve.
//   - NO ejecuta el matcher (vive en NestJS).
//   - NO resuelve colisiones; solo las lleva como hook D8.
//
// PRINCIPIOS:
//   - Wire-stable.
//   - Índices por workspace + state (listExposedByWorkspace) y por
//     workspace + isConflictMarked (listWithConflictsByWorkspace).
//
// ENTERPRISE NOTES:
//   - sourceWorkspaceId se persiste aunque sea derivable del local, para
//     queries O(1) sin join en Isar.
// ============================================================================

// NOTA: import de isar_community sin alias. El codegen (isar_community_generator)
// emite en el .g.dart referencias a 'Isar', 'Id', 'FilterCondition',
// 'IsarCollection', etc. sin prefijo, por lo que el `part of` solo compila si
// estos símbolos están disponibles top-level en el archivo padre.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/match_candidate_entity.dart';
import '../../../domain/entities/core_common/value_objects/collision_kind.dart';
import '../../../domain/entities/core_common/value_objects/match_candidate_state.dart';
import '../../../domain/entities/core_common/value_objects/match_trust_level.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/entities/core_common/value_objects/verified_key_type.dart';

part 'match_candidate_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class MatchCandidateModel {
  /// ID interno Isar (auto). NO es trazable con el backend.
  Id? isarId;

  /// backendId — UUID emitido por NestJS (avanzza-core-api).
  /// Con índice único: imposibilita duplicados locales para el mismo registro
  /// remoto. Es el vínculo de identidad cross-system (Isar ↔ NestJS).
  /// Guardrail F5 Hito 1: NO usar hash del UUID; usar isarId auto + este
  /// índice único sobre el UUID real.
  @Index(unique: true)
  final String id;

  /// Partition key del workspace dueño del registro local.
  @Index(composite: [CompositeIndex('stateWire')])
  @Index(composite: [
    CompositeIndex('isConflictMarked'),
  ], name: 'sourceWorkspaceId_isConflictMarked')
  @Index(composite: [
    CompositeIndex('localKindWire'),
    CompositeIndex('localId'),
  ], name: 'sourceWorkspaceId_localKind_localId')
  final String sourceWorkspaceId;

  final String localKindWire;
  final String localId;

  final String platformActorId;

  final String matchedKeyTypeWire;
  final String matchedKeyValue;

  final String trustLevelWire;
  final String stateWire;

  final DateTime detectedAt;
  final DateTime updatedAt;

  final DateTime? exposedAt;
  final DateTime? dismissedAt;
  final DateTime? confirmedAt;

  final String? resultingRelationshipId;

  /// Hook D8: wireNames de las colisiones detectadas sobre este candidato.
  final List<String> collisionKindWires;

  final bool isConflictMarked;
  final bool isCriticalConflict;

  MatchCandidateModel({
    this.isarId,
    required this.id,
    required this.sourceWorkspaceId,
    required this.localKindWire,
    required this.localId,
    required this.platformActorId,
    required this.matchedKeyTypeWire,
    required this.matchedKeyValue,
    required this.trustLevelWire,
    required this.stateWire,
    required this.detectedAt,
    required this.updatedAt,
    this.exposedAt,
    this.dismissedAt,
    this.confirmedAt,
    this.resultingRelationshipId,
    this.collisionKindWires = const <String>[],
    this.isConflictMarked = false,
    this.isCriticalConflict = false,
  });

  MatchCandidateEntity toEntity() => MatchCandidateEntity(
        id: id,
        sourceWorkspaceId: sourceWorkspaceId,
        localKind: TargetLocalKindX.fromWire(localKindWire),
        localId: localId,
        platformActorId: platformActorId,
        matchedKeyType: VerifiedKeyTypeX.fromWire(matchedKeyTypeWire),
        matchedKeyValue: matchedKeyValue,
        trustLevel: MatchTrustLevelX.fromWire(trustLevelWire),
        state: MatchCandidateStateX.fromWire(stateWire),
        detectedAt: detectedAt,
        updatedAt: updatedAt,
        exposedAt: exposedAt,
        dismissedAt: dismissedAt,
        confirmedAt: confirmedAt,
        resultingRelationshipId: resultingRelationshipId,
        collisionKinds: collisionKindWires
            .map((w) => CollisionKindX.fromWire(w))
            .toList(growable: false),
        isConflictMarked: isConflictMarked,
        isCriticalConflict: isCriticalConflict,
      );

  factory MatchCandidateModel.fromEntity(MatchCandidateEntity e) =>
      MatchCandidateModel(
        id: e.id,
        sourceWorkspaceId: e.sourceWorkspaceId,
        localKindWire: e.localKind.wireName,
        localId: e.localId,
        platformActorId: e.platformActorId,
        matchedKeyTypeWire: e.matchedKeyType.wireName,
        matchedKeyValue: e.matchedKeyValue,
        trustLevelWire: e.trustLevel.wireName,
        stateWire: e.state.wireName,
        detectedAt: e.detectedAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        exposedAt: e.exposedAt?.toUtc(),
        dismissedAt: e.dismissedAt?.toUtc(),
        confirmedAt: e.confirmedAt?.toUtc(),
        resultingRelationshipId: e.resultingRelationshipId,
        collisionKindWires:
            e.collisionKinds.map((k) => k.wireName).toList(growable: false),
        isConflictMarked: e.isConflictMarked,
        isCriticalConflict: e.isCriticalConflict,
      );

  factory MatchCandidateModel.fromJson(Map<String, dynamic> json) =>
      _$MatchCandidateModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchCandidateModelToJson(this);
}
