import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_entity.freezed.dart';
part 'country_entity.g.dart';

@freezed
abstract class CountryEntity with _$CountryEntity {
  const factory CountryEntity({
    @Default('') String id, // se rellena por doc.id/path
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
    @Default(<String>[]) List<String> nationalHolidays,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CountryEntity;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id;

  factory CountryEntity.fromJson(Map<String, dynamic> json) =>
      _$CountryEntityFromJson(json);
}
