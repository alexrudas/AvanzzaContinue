import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/maintenance/maintenance_finished_entity.dart'
    as domain;

part 'maintenance_finished_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class MaintenanceFinishedModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String assetId;
  final String descripcion;
  @DateTimeTimestampConverter()
  final DateTime fechaFin;
  final double costoTotal;
  final List<String> itemsUsados;
  final List<String> comprobantesUrls;
  @Index()
  final String? cityId;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  MaintenanceFinishedModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetId,
    required this.descripcion,
    required this.fechaFin,
    required this.costoTotal,
    this.itemsUsados = const [],
    this.comprobantesUrls = const [],
    this.cityId,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceFinishedModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFinishedModelFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceFinishedModelToJson(this);
  factory MaintenanceFinishedModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      MaintenanceFinishedModel.fromJson({...json, 'id': docId});

  factory MaintenanceFinishedModel.fromEntity(
          domain.MaintenanceFinishedEntity e) =>
      MaintenanceFinishedModel(
        id: e.id,
        orgId: e.orgId,
        assetId: e.assetId,
        descripcion: e.descripcion,
        fechaFin: e.fechaFin,
        costoTotal: e.costoTotal,
        itemsUsados: e.itemsUsados,
        comprobantesUrls: e.comprobantesUrls,
        cityId: e.cityId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.MaintenanceFinishedEntity toEntity() =>
      domain.MaintenanceFinishedEntity(
        id: id,
        orgId: orgId,
        assetId: assetId,
        descripcion: descripcion,
        fechaFin: fechaFin,
        costoTotal: costoTotal,
        itemsUsados: itemsUsados,
        comprobantesUrls: comprobantesUrls,
        cityId: cityId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
