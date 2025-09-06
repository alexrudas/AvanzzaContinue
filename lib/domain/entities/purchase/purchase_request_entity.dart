import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_request_entity.freezed.dart';
part 'purchase_request_entity.g.dart';

@freezed
abstract class PurchaseRequestEntity with _$PurchaseRequestEntity {
  const factory PurchaseRequestEntity({
    required String id,
    required String orgId,
    String? assetId,
    required String tipoRepuesto,
    String? specs,
    required int cantidad,
    required String ciudadEntrega, // cityId
    @Default(<String>[]) List<String> proveedorIdsInvitados,
    required String estado, // abierta | cerrada | asignada
    @Default(0) int respuestasCount,
    required String currencyCode,
    DateTime? expectedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PurchaseRequestEntity;

  factory PurchaseRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestEntityFromJson(json);
}
