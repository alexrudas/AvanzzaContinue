// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderProfile _$ProviderProfileFromJson(Map<String, dynamic> json) =>
    _ProviderProfile(
      providerType: json['providerType'] as String,
      assetTypeIds: (json['assetTypeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      businessCategoryId: json['businessCategoryId'] as String,
      assetSegmentIds: (json['assetSegmentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      offeringLineIds: (json['offeringLineIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      coverageCities: (json['coverageCities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      branchId: json['branchId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProviderProfileToJson(_ProviderProfile instance) =>
    <String, dynamic>{
      'providerType': instance.providerType,
      'assetTypeIds': instance.assetTypeIds,
      'businessCategoryId': instance.businessCategoryId,
      'assetSegmentIds': instance.assetSegmentIds,
      'offeringLineIds': instance.offeringLineIds,
      'coverageCities': instance.coverageCities,
      'branchId': instance.branchId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
