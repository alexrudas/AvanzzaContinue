// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetDraft _$AssetDraftFromJson(Map<String, dynamic> json) => _AssetDraft(
      id: json['id'] as String,
      assetType: $enumDecode(_$AssetTypeEnumMap, json['assetType']),
      status: $enumDecodeNullable(_$DraftStatusEnumMap, json['status']) ??
          DraftStatus.identification,
      primaryIdentifier: json['primaryIdentifier'] as String?,
      content: json['content'] == null
          ? null
          : AssetContent.fromJson(json['content'] as Map<String, dynamic>),
      snapshot: json['snapshot'] == null
          ? null
          : AssetSnapshot.fromJson(json['snapshot'] as Map<String, dynamic>),
      legalOwner: json['legalOwner'] == null
          ? null
          : LegalOwner.fromJson(json['legalOwner'] as Map<String, dynamic>),
      beneficialOwner: json['beneficialOwner'] == null
          ? null
          : BeneficialOwner.fromJson(
              json['beneficialOwner'] as Map<String, dynamic>),
      targetPortfolioId: json['targetPortfolioId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as Object),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as Object),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$AssetDraftToJson(_AssetDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetType': _$AssetTypeEnumMap[instance.assetType]!,
      'status': _$DraftStatusEnumMap[instance.status]!,
      'primaryIdentifier': instance.primaryIdentifier,
      'content': instance.content,
      'snapshot': instance.snapshot,
      'legalOwner': instance.legalOwner,
      'beneficialOwner': instance.beneficialOwner,
      'targetPortfolioId': instance.targetPortfolioId,
      'metadata': instance.metadata,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'createdBy': instance.createdBy,
    };

const _$AssetTypeEnumMap = {
  AssetType.vehicle: 'vehicle',
  AssetType.realEstate: 'real_estate',
  AssetType.machinery: 'machinery',
  AssetType.equipment: 'equipment',
};

const _$DraftStatusEnumMap = {
  DraftStatus.identification: 'IDENTIFICATION',
  DraftStatus.dataCaptured: 'DATA_CAPTURED',
  DraftStatus.ownershipPending: 'OWNERSHIP_PENDING',
  DraftStatus.readyToFinalize: 'READY_TO_FINALIZE',
  DraftStatus.abandoned: 'ABANDONED',
};
