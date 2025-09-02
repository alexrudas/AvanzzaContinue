import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/common/date_range.dart' as domain;

part 'date_range_model.g.dart';

@embedded
@JsonSerializable()
class DateRangeModel {
  DateTime? start;
  DateTime? end;

  DateRangeModel({this.start, this.end});

  // JSON
  factory DateRangeModel.fromJson(Map<String, dynamic> json) =>
      _$DateRangeModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateRangeModelToJson(this);

  // Converters
  factory DateRangeModel.fromEntity(domain.DateRange e) =>
      DateRangeModel(start: e.start, end: e.end);

  domain.DateRange toEntity() => domain.DateRange(
        start: start!, // asegúrate de asignarlos antes de persistir
        end: end!,
      );
}
