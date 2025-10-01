// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveContext _$ActiveContextFromJson(Map<String, dynamic> json) =>
    _ActiveContext(
      orgId: json['orgId'] as String,
      orgName: json['orgName'] as String,
      rol: json['rol'] as String,
      providerType: json['providerType'] as String?,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      assetTypes: (json['assetTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ActiveContextToJson(_ActiveContext instance) =>
    <String, dynamic>{
      'orgId': instance.orgId,
      'orgName': instance.orgName,
      'rol': instance.rol,
      'providerType': instance.providerType,
      'categories': instance.categories,
      'assetTypes': instance.assetTypes,
    };
