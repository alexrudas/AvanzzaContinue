import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_document_entity.freezed.dart';
part 'asset_document_entity.g.dart';

@freezed
abstract class AssetDocumentEntity with _$AssetDocumentEntity {
  const factory AssetDocumentEntity({
    required String id,
    required String assetId,
    required String tipoDoc,
    required String countryId,
    String? cityId,
    DateTime? fechaEmision,
    DateTime? fechaVencimiento,
    required String estado, // vigente | vencido | por_vencer
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AssetDocumentEntity;

  factory AssetDocumentEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetDocumentEntityFromJson(json);
}
