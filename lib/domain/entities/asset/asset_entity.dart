import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_entity.freezed.dart';
part 'asset_entity.g.dart';

@freezed
abstract class AssetEntity with _$AssetEntity {
  const factory AssetEntity({
    required String id,
    required String orgId,
    required String
        assetType, // vehiculos | inmuebles | maquinaria | equipos | otros (normalizado)
    String? assetSegmentId, // NUEVO: 'moto'|'auto'|'camion'|...
    required String countryId,
    String? regionId,
    String? cityId,
    required String ownerType, // org | user
    required String ownerId,
    required String estado, // activo | inactivo
    @Default(<String>[]) List<String> etiquetas,
    @Default(<String>[]) List<String> fotosUrls,
    @Default(<Map<String, dynamic>>[])
    List<Map<String, dynamic>> access, // NUEVO: ACL de acceso
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AssetEntity;

  factory AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);
}
