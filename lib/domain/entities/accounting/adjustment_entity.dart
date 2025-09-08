import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adjustment_entity.freezed.dart';
part 'adjustment_entity.g.dart';

@freezed
abstract class AdjustmentEntity with _$AdjustmentEntity {
  const factory AdjustmentEntity({
    required String id,
    required String entryId,
    required String tipo, // descuento | recargo
    required double valor,
    required String motivo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdjustmentEntity;

  factory AdjustmentEntity.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentEntityFromJson(json);
}
