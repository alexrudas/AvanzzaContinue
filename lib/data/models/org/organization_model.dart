import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/org/organization_entity.dart' as domain;

part 'organization_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class OrganizationModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  String id;
  String nombre;
  String tipo;
  @Index()
  String countryId;
  String? regionId;
  String? cityId;
  String? ownerUid;
  String? logoUrl;

  // antes: Map<String, dynamic>? metadata;
  String? metadataJson;

  @Index()
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrganizationModel({
    this.isarId,
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.countryId,
    this.regionId,
    this.cityId,
    this.ownerUid,
    this.logoUrl,
    this.metadataJson,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);
  factory OrganizationModel.fromFirestore(String docId, Map<String, dynamic> json) =>
      OrganizationModel.fromJson({...json, 'id': docId});

  factory OrganizationModel.fromEntity(domain.OrganizationEntity e) =>
      OrganizationModel(
        id: e.id,
        nombre: e.nombre,
        tipo: e.tipo,
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        ownerUid: e.ownerUid,
        logoUrl: e.logoUrl,
        metadataJson: e.metadata == null ? null : jsonEncode(e.metadata),
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.OrganizationEntity toEntity() => domain.OrganizationEntity(
        id: id,
        nombre: nombre,
        tipo: tipo,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        ownerUid: ownerUid,
        logoUrl: logoUrl,
        metadata: (() {
          if (metadataJson == null || metadataJson!.isEmpty) return null;
          final m = jsonDecode(metadataJson!);
          return m is Map<String, dynamic>
              ? m
              : Map<String, dynamic>.from(m as Map);
        })(),
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
