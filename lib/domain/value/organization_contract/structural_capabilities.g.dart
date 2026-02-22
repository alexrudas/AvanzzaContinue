// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'structural_capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StructuralCapabilities _$StructuralCapabilitiesFromJson(
        Map<String, dynamic> json) =>
    _StructuralCapabilities(
      cloudSyncEnabled: json['cloudSyncEnabled'] as bool? ?? false,
      rbacAdvancedEnabled: json['rbacAdvancedEnabled'] as bool? ?? false,
      multiOrganizationEnabled:
          json['multiOrganizationEnabled'] as bool? ?? false,
      advancedReportingEnabled:
          json['advancedReportingEnabled'] as bool? ?? false,
      publicApiEnabled: json['publicApiEnabled'] as bool? ?? false,
      auditLogEnabled: json['auditLogEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$StructuralCapabilitiesToJson(
        _StructuralCapabilities instance) =>
    <String, dynamic>{
      'cloudSyncEnabled': instance.cloudSyncEnabled,
      'rbacAdvancedEnabled': instance.rbacAdvancedEnabled,
      'multiOrganizationEnabled': instance.multiOrganizationEnabled,
      'advancedReportingEnabled': instance.advancedReportingEnabled,
      'publicApiEnabled': instance.publicApiEnabled,
      'auditLogEnabled': instance.auditLogEnabled,
    };
