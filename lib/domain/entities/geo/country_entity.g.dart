// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CountryEntity _$CountryEntityFromJson(Map<String, dynamic> json) =>
    _CountryEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      iso3: json['iso3'] as String,
      phoneCode: json['phoneCode'] as String?,
      timezone: json['timezone'] as String?,
      currencyCode: json['currencyCode'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      taxName: json['taxName'] as String?,
      taxRateDefault: (json['taxRateDefault'] as num?)?.toDouble(),
      documentTypes: (json['documentTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      plateFormatRegex: json['plateFormatRegex'] as String?,
      nationalHolidays: (json['nationalHolidays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CountryEntityToJson(_CountryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iso3': instance.iso3,
      'phoneCode': instance.phoneCode,
      'timezone': instance.timezone,
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
      'taxName': instance.taxName,
      'taxRateDefault': instance.taxRateDefault,
      'documentTypes': instance.documentTypes,
      'plateFormatRegex': instance.plateFormatRegex,
      'nationalHolidays': instance.nationalHolidays,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
