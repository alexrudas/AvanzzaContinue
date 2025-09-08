import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/maintenance/maintenance_process_entity.dart'
    as domain;

part 'maintenance_process_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class MaintenanceProcessModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String assetId;
  final String descripcion;
  final String tecnicoId;
  @Index()
  final String estado;
  @DateTimeTimestampConverter()
  final DateTime startedAt;
  final String? purchaseRequestId;
  @Index()
  final String? cityId;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  MaintenanceProcessModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetId,
    required this.descripcion,
    required this.tecnicoId,
    this.estado = 'en_proceso',
    required this.startedAt,
    this.purchaseRequestId,
    this.cityId,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceProcessModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceProcessModelFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceProcessModelToJson(this);
  factory MaintenanceProcessModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      MaintenanceProcessModel.fromJson({...json, 'id': docId});

  factory MaintenanceProcessModel.fromEntity(
          domain.MaintenanceProcessEntity e) =>
      MaintenanceProcessModel(
        id: e.id,
        orgId: e.orgId,
        assetId: e.assetId,
        descripcion: e.descripcion,
        tecnicoId: e.tecnicoId,
        estado: e.estado,
        startedAt: e.startedAt,
        purchaseRequestId: e.purchaseRequestId,
        cityId: e.cityId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.MaintenanceProcessEntity toEntity() => domain.MaintenanceProcessEntity(
        id: id,
        orgId: orgId,
        assetId: assetId,
        descripcion: descripcion,
        tecnicoId: tecnicoId,
        estado: estado,
        startedAt: startedAt,
        purchaseRequestId: purchaseRequestId,
        cityId: cityId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
