import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_entity.freezed.dart';
part 'income_entity.g.dart';

/// Tipo de ingreso
enum IncomeType {
  @JsonValue('ALQUILER')
  alquiler,
  @JsonValue('VENTA')
  venta,
  @JsonValue('SERVICIO')
  servicio,
  @JsonValue('OTRO')
  otro,
}

/// Entidad de Ingreso
/// Registra ingresos asociados a un portafolio
/// Validaciones:
/// - amount > 0 (validar en repository/usecase)
/// - portfolioId debe existir y estar ACTIVE (validar en repository/usecase)
/// - createdAt = DateTime.now() al crear (no null en persistencia)
@freezed
abstract class IncomeEntity with _$IncomeEntity {
  const factory IncomeEntity({
    required String id,
    required String portfolioId,
    required double amount,
    required DateTime date,
    required IncomeType incomeType,
    String? description,
    required String createdBy,
    required DateTime createdAt,
  }) = _IncomeEntity;

  factory IncomeEntity.fromJson(Map<String, dynamic> json) =>
      _$IncomeEntityFromJson(json);
}
