// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchEntity _$BranchEntityFromJson(Map<String, dynamic> json) =>
    _BranchEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      coverageCities: (json['coverageCities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BranchEntityToJson(_BranchEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'name': instance.name,
      'address': instance.address,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'coverageCities': instance.coverageCities,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
