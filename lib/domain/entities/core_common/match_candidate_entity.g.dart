// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_candidate_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchCandidateEntity _$MatchCandidateEntityFromJson(
        Map<String, dynamic> json) =>
    _MatchCandidateEntity(
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      localKind: $enumDecode(_$TargetLocalKindEnumMap, json['localKind']),
      localId: json['localId'] as String,
      platformActorId: json['platformActorId'] as String,
      matchedKeyType:
          $enumDecode(_$VerifiedKeyTypeEnumMap, json['matchedKeyType']),
      matchedKeyValue: json['matchedKeyValue'] as String,
      trustLevel: $enumDecode(_$MatchTrustLevelEnumMap, json['trustLevel']),
      state: $enumDecode(_$MatchCandidateStateEnumMap, json['state']),
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      exposedAt: json['exposedAt'] == null
          ? null
          : DateTime.parse(json['exposedAt'] as String),
      dismissedAt: json['dismissedAt'] == null
          ? null
          : DateTime.parse(json['dismissedAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      resultingRelationshipId: json['resultingRelationshipId'] as String?,
      collisionKinds: (json['collisionKinds'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CollisionKindEnumMap, e))
              .toList() ??
          const <CollisionKind>[],
      isConflictMarked: json['isConflictMarked'] as bool? ?? false,
      isCriticalConflict: json['isCriticalConflict'] as bool? ?? false,
    );

Map<String, dynamic> _$MatchCandidateEntityToJson(
        _MatchCandidateEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'localKind': _$TargetLocalKindEnumMap[instance.localKind]!,
      'localId': instance.localId,
      'platformActorId': instance.platformActorId,
      'matchedKeyType': _$VerifiedKeyTypeEnumMap[instance.matchedKeyType]!,
      'matchedKeyValue': instance.matchedKeyValue,
      'trustLevel': _$MatchTrustLevelEnumMap[instance.trustLevel]!,
      'state': _$MatchCandidateStateEnumMap[instance.state]!,
      'detectedAt': instance.detectedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'exposedAt': instance.exposedAt?.toIso8601String(),
      'dismissedAt': instance.dismissedAt?.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'resultingRelationshipId': instance.resultingRelationshipId,
      'collisionKinds': instance.collisionKinds
          .map((e) => _$CollisionKindEnumMap[e]!)
          .toList(),
      'isConflictMarked': instance.isConflictMarked,
      'isCriticalConflict': instance.isCriticalConflict,
    };

const _$TargetLocalKindEnumMap = {
  TargetLocalKind.organization: 'organization',
  TargetLocalKind.contact: 'contact',
};

const _$VerifiedKeyTypeEnumMap = {
  VerifiedKeyType.phoneE164: 'phoneE164',
  VerifiedKeyType.email: 'email',
  VerifiedKeyType.docId: 'docId',
};

const _$MatchTrustLevelEnumMap = {
  MatchTrustLevel.alto: 'alto',
  MatchTrustLevel.medio: 'medio',
  MatchTrustLevel.bajo: 'bajo',
};

const _$MatchCandidateStateEnumMap = {
  MatchCandidateState.detectedInternal: 'detectedInternal',
  MatchCandidateState.exposedToWorkspace: 'exposedToWorkspace',
  MatchCandidateState.dismissedByWorkspace: 'dismissedByWorkspace',
  MatchCandidateState.confirmedIntoRelationship: 'confirmedIntoRelationship',
};

const _$CollisionKindEnumMap = {
  CollisionKind.duplicateLocalMatch: 'duplicateLocalMatch',
  CollisionKind.platformKeyReassigned: 'platformKeyReassigned',
  CollisionKind.localToMultiplePlatform: 'localToMultiplePlatform',
  CollisionKind.lowConfidenceAmbiguous: 'lowConfidenceAmbiguous',
};
