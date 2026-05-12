// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_contact_remote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalContactRemoteDto _$LocalContactRemoteDtoFromJson(
        Map<String, dynamic> json) =>
    LocalContactRemoteDto(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      organizationId: json['organizationId'] as String?,
      roleLabel: json['roleLabel'] as String?,
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      docId: json['docId'] as String?,
      snapshotSourcePlatformActorId:
          json['snapshotSourcePlatformActorId'] as String?,
      snapshotAdoptedAt: json['snapshotAdoptedAt'] == null
          ? null
          : DateTime.parse(json['snapshotAdoptedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      supplierTypeWire: json['supplierTypeWire'] as String?,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      countryId: json['countryId'] as String?,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      addressLine: json['addressLine'] as String?,
      secondaryPhoneE164: json['secondaryPhoneE164'] as String?,
      website: json['website'] as String?,
      coverageCityIds: (json['coverageCityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      coverageAllCountry: json['coverageAllCountry'] as bool? ?? false,
      additionalBranches: (json['additionalBranches'] as List<dynamic>?)
              ?.map((e) =>
                  ProviderBranchEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProviderBranchEntity>[],
    );

Map<String, dynamic> _$LocalContactRemoteDtoToJson(
        LocalContactRemoteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'displayName': instance.displayName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'organizationId': instance.organizationId,
      'roleLabel': instance.roleLabel,
      'primaryPhoneE164': instance.primaryPhoneE164,
      'primaryEmail': instance.primaryEmail,
      'docId': instance.docId,
      'snapshotSourcePlatformActorId': instance.snapshotSourcePlatformActorId,
      'snapshotAdoptedAt': instance.snapshotAdoptedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'supplierTypeWire': instance.supplierTypeWire,
      'categories': instance.categories,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'addressLine': instance.addressLine,
      'secondaryPhoneE164': instance.secondaryPhoneE164,
      'website': instance.website,
      'coverageCityIds': instance.coverageCityIds,
      'coverageAllCountry': instance.coverageAllCountry,
      'additionalBranches':
          instance.additionalBranches.map((e) => e.toJson()).toList(),
    };
