// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_branch_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderBranchEntity _$ProviderBranchEntityFromJson(
        Map<String, dynamic> json) =>
    _ProviderBranchEntity(
      id: json['id'] as String,
      label: json['label'] as String?,
      countryId: json['countryId'] as String?,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      addressLine: json['addressLine'] as String?,
      phoneE164: json['phoneE164'] as String?,
      contactName: json['contactName'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ProviderBranchEntityToJson(
        _ProviderBranchEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'addressLine': instance.addressLine,
      'phoneE164': instance.phoneE164,
      'contactName': instance.contactName,
      'notes': instance.notes,
    };
