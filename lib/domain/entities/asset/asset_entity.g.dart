// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LegalOwner _$LegalOwnerFromJson(Map<String, dynamic> json) => _LegalOwner(
      documentType: json['documentType'] as String,
      documentNumber: json['documentNumber'] as String,
      name: json['name'] as String,
      source: json['source'] as String,
      verifiedAt:
          const SafeDateTimeConverter().fromJson(json['verifiedAt'] as Object),
    );

Map<String, dynamic> _$LegalOwnerToJson(_LegalOwner instance) =>
    <String, dynamic>{
      'documentType': instance.documentType,
      'documentNumber': instance.documentNumber,
      'name': instance.name,
      'source': instance.source,
      'verifiedAt': const SafeDateTimeConverter().toJson(instance.verifiedAt),
    };

_BeneficialOwner _$BeneficialOwnerFromJson(Map<String, dynamic> json) =>
    _BeneficialOwner(
      ownerType: $enumDecode(_$BeneficialOwnerTypeEnumMap, json['ownerType']),
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      relationship:
          $enumDecode(_$OwnershipRelationshipEnumMap, json['relationship']),
      assignedAt:
          const SafeDateTimeConverter().fromJson(json['assignedAt'] as Object),
      assignedBy: json['assignedBy'] as String,
    );

Map<String, dynamic> _$BeneficialOwnerToJson(_BeneficialOwner instance) =>
    <String, dynamic>{
      'ownerType': _$BeneficialOwnerTypeEnumMap[instance.ownerType]!,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'relationship': _$OwnershipRelationshipEnumMap[instance.relationship]!,
      'assignedAt': const SafeDateTimeConverter().toJson(instance.assignedAt),
      'assignedBy': instance.assignedBy,
    };

const _$BeneficialOwnerTypeEnumMap = {
  BeneficialOwnerType.user: 'user',
  BeneficialOwnerType.org: 'org',
};

const _$OwnershipRelationshipEnumMap = {
  OwnershipRelationship.owner: 'owner',
  OwnershipRelationship.manager: 'manager',
  OwnershipRelationship.operator_: 'operator',
  OwnershipRelationship.lessee: 'lessee',
};

_AssetEntity _$AssetEntityFromJson(Map<String, dynamic> json) => _AssetEntity(
      id: json['id'] as String,
      assetKey: json['assetKey'] as String,
      type: $enumDecode(_$AssetTypeEnumMap, json['type']),
      state: $enumDecodeNullable(_$AssetStateEnumMap, json['state']) ??
          AssetState.draft,
      content: AssetContent.fromJson(json['content'] as Map<String, dynamic>),
      legalOwner: json['legalOwner'] == null
          ? null
          : LegalOwner.fromJson(json['legalOwner'] as Map<String, dynamic>),
      beneficialOwner: json['beneficialOwner'] == null
          ? null
          : BeneficialOwner.fromJson(
              json['beneficialOwner'] as Map<String, dynamic>),
      snapshotId: json['snapshotId'] as String?,
      portfolioId: json['portfolioId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as Object),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as Object),
    );

Map<String, dynamic> _$AssetEntityToJson(_AssetEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetKey': instance.assetKey,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'state': _$AssetStateEnumMap[instance.state]!,
      'content': instance.content,
      'legalOwner': instance.legalOwner,
      'beneficialOwner': instance.beneficialOwner,
      'snapshotId': instance.snapshotId,
      'portfolioId': instance.portfolioId,
      'metadata': instance.metadata,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
    };

const _$AssetTypeEnumMap = {
  AssetType.vehicle: 'vehicle',
  AssetType.realEstate: 'real_estate',
  AssetType.machinery: 'machinery',
  AssetType.equipment: 'equipment',
};

const _$AssetStateEnumMap = {
  AssetState.draft: 'DRAFT',
  AssetState.pendingOwnership: 'PENDING_OWNERSHIP',
  AssetState.verified: 'VERIFIED',
  AssetState.active: 'ACTIVE',
  AssetState.archived: 'ARCHIVED',
};
