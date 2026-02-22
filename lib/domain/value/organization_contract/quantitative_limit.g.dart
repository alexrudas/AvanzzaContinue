// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quantitative_limit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuantitativeLimitUnlimited _$QuantitativeLimitUnlimitedFromJson(
        Map<String, dynamic> json) =>
    QuantitativeLimitUnlimited(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$QuantitativeLimitUnlimitedToJson(
        QuantitativeLimitUnlimited instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

QuantitativeLimitLimited _$QuantitativeLimitLimitedFromJson(
        Map<String, dynamic> json) =>
    QuantitativeLimitLimited(
      (json['value'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$QuantitativeLimitLimitedToJson(
        QuantitativeLimitLimited instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };
