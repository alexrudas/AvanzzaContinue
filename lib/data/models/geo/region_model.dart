import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/region_entity.dart' as domain;

part 'region_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class RegionModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String countryId;
  final String name;
  final String? code;
  @Index()
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RegionModel({
    this.isarId,
    required this.id,
    required this.countryId,
    required this.name,
    this.code,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionModelToJson(this);
  factory RegionModel.fromFirestore(String docId, Map<String, dynamic> json) =>
      RegionModel.fromJson({...json, 'id': docId});

  factory RegionModel.fromEntity(domain.RegionEntity e) => RegionModel(
        id: e.id,
        countryId: e.countryId,
        name: e.name,
        code: e.code,
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.RegionEntity toEntity() => domain.RegionEntity(
        id: id,
        countryId: countryId,
        name: name,
        code: code,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
