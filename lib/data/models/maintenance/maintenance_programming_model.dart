import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/maintenance/maintenance_programming_entity.dart'
    as domain;

part 'maintenance_programming_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class MaintenanceProgrammingModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String assetId;
  final List<String> incidenciasIds;
  final List<DateTime> programmingDates;
  final String? assignedToTechId;
  final String? notes;
  @Index()
  final String? cityId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MaintenanceProgrammingModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetId,
    this.incidenciasIds = const [],
    this.programmingDates = const [],
    this.assignedToTechId,
    this.notes,
    this.cityId,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceProgrammingModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceProgrammingModelFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceProgrammingModelToJson(this);
  factory MaintenanceProgrammingModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      MaintenanceProgrammingModel.fromJson({...json, 'id': docId});

  factory MaintenanceProgrammingModel.fromEntity(
          domain.MaintenanceProgrammingEntity e) =>
      MaintenanceProgrammingModel(
        id: e.id,
        orgId: e.orgId,
        assetId: e.assetId,
        incidenciasIds: e.incidenciasIds,
        programmingDates: e.programmingDates,
        assignedToTechId: e.assignedToTechId,
        notes: e.notes,
        cityId: e.cityId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.MaintenanceProgrammingEntity toEntity() =>
      domain.MaintenanceProgrammingEntity(
        id: id,
        orgId: orgId,
        assetId: assetId,
        incidenciasIds: incidenciasIds,
        programmingDates: programmingDates,
        assignedToTechId: assignedToTechId,
        notes: notes,
        cityId: cityId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
