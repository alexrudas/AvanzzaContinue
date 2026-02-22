// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_access_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationAccessContract _$OrganizationAccessContractFromJson(
        Map<String, dynamic> json) =>
    _OrganizationAccessContract(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      schemaProfile: json['schemaProfile'] as String? ?? 'canonical',
      mode: $enumDecodeNullable(_$InfrastructureModeEnumMap, json['mode']) ??
          InfrastructureMode.localOnly,
      intelligence: $enumDecodeNullable(
              _$IntelligenceTierEnumMap, json['intelligence']) ??
          IntelligenceTier.none,
      capabilities: json['capabilities'] == null
          ? const StructuralCapabilities()
          : StructuralCapabilities.fromJson(
              json['capabilities'] as Map<String, dynamic>),
      maxAssets: json['maxAssets'] == null
          ? const QuantitativeLimit.limited(0)
          : QuantitativeLimit.fromJson(
              json['maxAssets'] as Map<String, dynamic>),
      maxMembers: json['maxMembers'] == null
          ? const QuantitativeLimit.limited(0)
          : QuantitativeLimit.fromJson(
              json['maxMembers'] as Map<String, dynamic>),
      maxOrganizations: json['maxOrganizations'] == null
          ? const QuantitativeLimit.limited(1)
          : QuantitativeLimit.fromJson(
              json['maxOrganizations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrganizationAccessContractToJson(
        _OrganizationAccessContract instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'schemaProfile': instance.schemaProfile,
      'mode': _$InfrastructureModeEnumMap[instance.mode]!,
      'intelligence': _$IntelligenceTierEnumMap[instance.intelligence]!,
      'capabilities': instance.capabilities,
      'maxAssets': instance.maxAssets,
      'maxMembers': instance.maxMembers,
      'maxOrganizations': instance.maxOrganizations,
    };

const _$InfrastructureModeEnumMap = {
  InfrastructureMode.localOnly: 'local_only',
  InfrastructureMode.cloudLite: 'cloud_lite',
  InfrastructureMode.cloudFull: 'cloud_full',
  InfrastructureMode.enterprise: 'enterprise',
};

const _$IntelligenceTierEnumMap = {
  IntelligenceTier.none: 'none',
  IntelligenceTier.basic: 'basic',
  IntelligenceTier.advanced: 'advanced',
};
