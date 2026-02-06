import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_finished_entity.freezed.dart';
part 'maintenance_finished_entity.g.dart';

@freezed
abstract class MaintenanceFinishedEntity with _$MaintenanceFinishedEntity {
  const factory MaintenanceFinishedEntity({
    required String id,
    required String orgId,
    required String assetId,
    required String descripcion,
    required DateTime fechaFin,
    required double costoTotal,
    @Default(<String>[]) List<String> itemsUsados,
    @Default(<String>[]) List<String> comprobantesUrls,
    String? cityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MaintenanceFinishedEntity;

  factory MaintenanceFinishedEntity.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFinishedEntityFromJson(json);
}
