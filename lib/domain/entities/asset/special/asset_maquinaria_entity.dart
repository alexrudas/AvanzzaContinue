import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_maquinaria_entity.freezed.dart';
part 'asset_maquinaria_entity.g.dart';

@freezed
abstract class AssetMaquinariaEntity with _$AssetMaquinariaEntity {
  const factory AssetMaquinariaEntity({
    required String assetId,
    required String serie,
    required String marca,
    required String capacidad,
    required String categoria,
    String? certificadoOperacion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AssetMaquinariaEntity;

  factory AssetMaquinariaEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetMaquinariaEntityFromJson(json);
}
