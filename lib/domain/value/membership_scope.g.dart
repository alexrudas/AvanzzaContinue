// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MembershipScope _$MembershipScopeFromJson(Map<String, dynamic> json) =>
    _MembershipScope(
      type: $enumDecodeNullable(_$ScopeTypeEnumMap, json['type']) ??
          ScopeType.restricted,
      assignedAssetIds: (json['assignedAssetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      assignedGroupIds: (json['assignedGroupIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      granularOverrides: (json['granularOverrides'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$MembershipScopeToJson(_MembershipScope instance) =>
    <String, dynamic>{
      'type': _$ScopeTypeEnumMap[instance.type]!,
      'assignedAssetIds': instance.assignedAssetIds,
      'assignedGroupIds': instance.assignedGroupIds,
      'granularOverrides': instance.granularOverrides,
    };

const _$ScopeTypeEnumMap = {
  ScopeType.global: 'global',
  ScopeType.restricted: 'restricted',
  ScopeType.none: 'none',
};
