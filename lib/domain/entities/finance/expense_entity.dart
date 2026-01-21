import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_entity.freezed.dart';
part 'expense_entity.g.dart';

/// Tipo de gasto
enum ExpenseType {
  @JsonValue('MANTENIMIENTO')
  mantenimiento,
  @JsonValue('SEGURO')
  seguro,
  @JsonValue('SERVICIO')
  servicio,
  @JsonValue('IMPUESTO')
  impuesto,
  @JsonValue('OTRO')
  otro,
}

/// Entidad de Gasto
/// Registra gastos asociados a un portafolio
/// Validaciones:
/// - amount > 0 (validar en repository/usecase)
/// - portfolioId debe existir y estar ACTIVE (validar en repository/usecase)
/// - createdAt = DateTime.now() al crear (no null en persistencia)
@freezed
abstract class ExpenseEntity with _$ExpenseEntity {
  const factory ExpenseEntity({
    required String id,
    required String portfolioId,
    required double amount,
    required DateTime date,
    required ExpenseType expenseType,
    String? description,
    required String createdBy,
    required DateTime createdAt,
  }) = _ExpenseEntity;

  factory ExpenseEntity.fromJson(Map<String, dynamic> json) =>
      _$ExpenseEntityFromJson(json);
}
