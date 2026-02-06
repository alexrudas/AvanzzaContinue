import 'package:freezed_annotation/freezed_annotation.dart';

import '../geo/address_entity.dart';

part 'insurance_purchase_entity.freezed.dart';
part 'insurance_purchase_entity.g.dart';

@freezed
abstract class InsurancePurchaseEntity with _$InsurancePurchaseEntity {
  const factory InsurancePurchaseEntity({
    required String id,
    required String assetId,
    required String compradorId,
    required String orgId,
    required String contactEmail,
    required AddressEntity address,
    required String currencyCode,
    required String estadoCompra, // pendiente | pagado | confirmado
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InsurancePurchaseEntity;

  factory InsurancePurchaseEntity.fromJson(Map<String, dynamic> json) =>
      _$InsurancePurchaseEntityFromJson(json);
}
