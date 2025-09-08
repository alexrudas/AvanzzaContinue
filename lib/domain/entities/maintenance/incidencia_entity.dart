import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incidencia_entity.freezed.dart';
part 'incidencia_entity.g.dart';

@freezed
abstract class IncidenciaEntity with _$IncidenciaEntity {
  const factory IncidenciaEntity({
    required String id,
    required String orgId,
    required String assetId,
    required String descripcion,
    @Default(<String>[]) List<String> fotosUrls,
    String? prioridad,
    required String estado, // abierta | cerrada
    required String reportedBy,
    String? cityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _IncidenciaEntity;

  factory IncidenciaEntity.fromJson(Map<String, dynamic> json) =>
      _$IncidenciaEntityFromJson(json);
}
