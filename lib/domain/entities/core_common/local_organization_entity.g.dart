// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_organization_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalOrganizationEntity _$LocalOrganizationEntityFromJson(
        Map<String, dynamic> json) =>
    _LocalOrganizationEntity(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      legalName: json['legalName'] as String?,
      taxId: json['taxId'] as String?,
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      website: json['website'] as String?,
      notesPrivate: json['notesPrivate'] as String?,
      tagsPrivate: (json['tagsPrivate'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      snapshotSourcePlatformActorId:
          json['snapshotSourcePlatformActorId'] as String?,
      snapshotAdoptedAt: json['snapshotAdoptedAt'] == null
          ? null
          : DateTime.parse(json['snapshotAdoptedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$LocalOrganizationEntityToJson(
        _LocalOrganizationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'displayName': instance.displayName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'legalName': instance.legalName,
      'taxId': instance.taxId,
      'primaryPhoneE164': instance.primaryPhoneE164,
      'primaryEmail': instance.primaryEmail,
      'website': instance.website,
      'notesPrivate': instance.notesPrivate,
      'tagsPrivate': instance.tagsPrivate,
      'snapshotSourcePlatformActorId': instance.snapshotSourcePlatformActorId,
      'snapshotAdoptedAt': instance.snapshotAdoptedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
