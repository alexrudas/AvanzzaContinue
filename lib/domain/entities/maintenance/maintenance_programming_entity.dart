import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_programming_entity.freezed.dart';
part 'maintenance_programming_entity.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class MaintenanceProgrammingEntity with _$MaintenanceProgrammingEntity {
  const factory MaintenanceProgrammingEntity({
    required String id,
    required String orgId,
    required String assetId,
    @Default(<String>[]) List<String> incidenciasIds,
    @Default(<DateTime>[]) List<DateTime> programmingDates,
    String? assignedToTechId,
    String? notes,
    String? cityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MaintenanceProgrammingEntity;

  factory MaintenanceProgrammingEntity.fromJson(Map<String, dynamic> json) => _$MaintenanceProgrammingEntityFromJson(json);
}
