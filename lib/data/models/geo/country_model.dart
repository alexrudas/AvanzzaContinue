import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/country_entity.dart' as domain;

part 'country_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class CountryModel {
  Id? isarId; // Isar primary key

  @Index(unique: true, replace: true)
  final String id; // ISO-3166 alpha-2
  final String name;
  final String iso3;
  final String? phoneCode;
  final String? timezone;
  final String? currencyCode;
  final String? currencySymbol;
  final String? taxName;
  final double? taxRateDefault;
  final List<String> documentTypes;
  final String? plateFormatRegex;
  final List<String> nationalHolidays; // YYYY-MM-DD
  @Index()
  final bool isActive;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  CountryModel({
    this.isarId,
    required this.id,
    required this.name,
    required this.iso3,
    this.phoneCode,
    this.timezone,
    this.currencyCode,
    this.currencySymbol,
    this.taxName,
    this.taxRateDefault,
    this.documentTypes = const [],
    this.plateFormatRegex,
    this.nationalHolidays = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Firestore JSON
  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
  factory CountryModel.fromFirestore(String docId, Map<String, dynamic> json) =>
      CountryModel.fromJson({...json, 'id': docId});

  // Converters
  factory CountryModel.fromEntity(domain.CountryEntity e) => CountryModel(
        id: e.id,
        name: e.name,
        iso3: e.iso3,
        phoneCode: e.phoneCode,
        timezone: e.timezone,
        currencyCode: e.currencyCode,
        currencySymbol: e.currencySymbol,
        taxName: e.taxName,
        taxRateDefault: e.taxRateDefault,
        documentTypes: e.documentTypes,
        plateFormatRegex: e.plateFormatRegex,
        nationalHolidays: e.nationalHolidays,
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.CountryEntity toEntity() => domain.CountryEntity(
        id: id,
        name: name,
        iso3: iso3,
        phoneCode: phoneCode,
        timezone: timezone,
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
        taxName: taxName,
        taxRateDefault: taxRateDefault,
        documentTypes: documentTypes,
        plateFormatRegex: plateFormatRegex,
        nationalHolidays: nationalHolidays,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
