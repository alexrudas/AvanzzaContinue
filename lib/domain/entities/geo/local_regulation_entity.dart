import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_regulation_entity.freezed.dart';
part 'local_regulation_entity.g.dart';

@freezed
abstract class PicoYPlacaRule with _$PicoYPlacaRule {
  const factory PicoYPlacaRule({
    required int dayOfWeek, // 1=Mon .. 7=Sun
    @Default(<String>[]) List<String> digitsRestricted,
    required String startTime, // HH:mm
    required String endTime, // HH:mm
    String? notes,
  }) = _PicoYPlacaRule;

  factory PicoYPlacaRule.fromJson(Map<String, dynamic> json) =>
      _$PicoYPlacaRuleFromJson(json);
}

@freezed
abstract class LocalRegulationEntity with _$LocalRegulationEntity {
  const factory LocalRegulationEntity({
    required String id,
    required String countryId,
    required String cityId,
    @Default(<PicoYPlacaRule>[]) List<PicoYPlacaRule> picoYPlacaRules,
    @Default(<String>[]) List<String> circulationExceptions,
    @Default(<String>[]) List<String> maintenanceBlackoutDates, // YYYY-MM-DD
    required String updatedBy,
    String? sourceUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LocalRegulationEntity;

  factory LocalRegulationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalRegulationEntityFromJson(json);
}
