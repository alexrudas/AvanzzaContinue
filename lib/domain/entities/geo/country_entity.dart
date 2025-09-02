import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_entity.freezed.dart';
part 'country_entity.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class CountryEntity with _$CountryEntity {
  const factory CountryEntity({
    required String id, // ISO-3166 alpha-2
    required String name,
    required String iso3,
    String? phoneCode,
    String? timezone,
    String? currencyCode,
    String? currencySymbol,
    String? taxName,
    double? taxRateDefault,
    @Default(<String>[]) List<String> documentTypes,
    String? plateFormatRegex,
    @Default(<String>[]) List<String> nationalHolidays, // YYYY-MM-DD
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CountryEntity;

  factory CountryEntity.fromJson(Map<String, dynamic> json) => _$CountryEntityFromJson(json);
}
