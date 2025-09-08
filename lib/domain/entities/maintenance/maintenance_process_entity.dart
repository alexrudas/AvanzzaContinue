import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_process_entity.freezed.dart';
part 'maintenance_process_entity.g.dart';

@freezed
abstract class MaintenanceProcessEntity with _$MaintenanceProcessEntity {
  const factory MaintenanceProcessEntity({
    required String id,
    required String orgId,
    required String assetId,
    required String descripcion,
    required String tecnicoId,
    @Default('en_proceso') String estado,
    required DateTime startedAt,
    String? purchaseRequestId,
    String? cityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MaintenanceProcessEntity;

  factory MaintenanceProcessEntity.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceProcessEntityFromJson(json);
}
