import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_inmueble_entity.freezed.dart';
part 'asset_inmueble_entity.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class AssetInmuebleEntity with _$AssetInmuebleEntity {
  const factory AssetInmuebleEntity({
    required String assetId,
    required String matriculaInmobiliaria,
    int? estrato,
    double? metrosCuadrados,
    required String uso, // residencial | comercial
    double? valorCatastral,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AssetInmuebleEntity;

  factory AssetInmuebleEntity.fromJson(Map<String, dynamic> json) => _$AssetInmuebleEntityFromJson(json);
}
