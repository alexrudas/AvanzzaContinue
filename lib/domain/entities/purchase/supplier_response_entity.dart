import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_response_entity.freezed.dart';
part 'supplier_response_entity.g.dart';

@freezed
abstract class SupplierResponseEntity with _$SupplierResponseEntity {
  const factory SupplierResponseEntity({
    required String id,
    required String purchaseRequestId,
    required String proveedorId,
    required double precio,
    required String disponibilidad,
    required String currencyCode,
    String? catalogoUrl,
    String? notas,
    int? leadTimeDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SupplierResponseEntity;

  factory SupplierResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$SupplierResponseEntityFromJson(json);
}
