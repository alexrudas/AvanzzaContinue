import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurance_policy_entity.freezed.dart';
part 'insurance_policy_entity.g.dart';

@freezed
abstract class InsurancePolicyEntity with _$InsurancePolicyEntity {
  const factory InsurancePolicyEntity({
    required String id,
    required String assetId,
    required String tipo, // SOAT | todo_riesgo | inmueble
    required String aseguradora,
    required double tarifaBase,
    required String currencyCode,
    required String countryId,
    String? cityId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String estado, // vigente | vencido | por_vencer
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InsurancePolicyEntity;

  factory InsurancePolicyEntity.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyEntityFromJson(json);
}
