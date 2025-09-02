import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_vehiculo_entity.freezed.dart';
part 'asset_vehiculo_entity.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class AssetVehiculoEntity with _$AssetVehiculoEntity {
  const factory AssetVehiculoEntity({
    required String assetId,
    required String refCode, // 3 letters + 3 numbers
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AssetVehiculoEntity;

  factory AssetVehiculoEntity.fromJson(Map<String, dynamic> json) => _$AssetVehiculoEntityFromJson(json);
}
