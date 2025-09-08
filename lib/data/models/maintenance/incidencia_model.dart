import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/maintenance/incidencia_entity.dart' as domain;

part 'incidencia_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class IncidenciaModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String assetId;
  final String descripcion;
  final List<String> fotosUrls;
  final String? prioridad;
  @Index()
  final String estado;
  final String reportedBy;
  @Index()
  final String? cityId;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  IncidenciaModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetId,
    required this.descripcion,
    this.fotosUrls = const [],
    this.prioridad,
    required this.estado,
    required this.reportedBy,
    this.cityId,
    this.createdAt,
    this.updatedAt,
  });

  factory IncidenciaModel.fromJson(Map<String, dynamic> json) =>
      _$IncidenciaModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncidenciaModelToJson(this);
  factory IncidenciaModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      IncidenciaModel.fromJson({...json, 'id': docId});

  factory IncidenciaModel.fromEntity(domain.IncidenciaEntity e) =>
      IncidenciaModel(
        id: e.id,
        orgId: e.orgId,
        assetId: e.assetId,
        descripcion: e.descripcion,
        fotosUrls: e.fotosUrls,
        prioridad: e.prioridad,
        estado: e.estado,
        reportedBy: e.reportedBy,
        cityId: e.cityId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.IncidenciaEntity toEntity() => domain.IncidenciaEntity(
        id: id,
        orgId: orgId,
        assetId: assetId,
        descripcion: descripcion,
        fotosUrls: fotosUrls,
        prioridad: prioridad,
        estado: estado,
        reportedBy: reportedBy,
        cityId: cityId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
