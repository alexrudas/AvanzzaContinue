import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_receivable_entity.freezed.dart';
part 'account_receivable_entity.g.dart';

/// Estado de la cuenta por cobrar
enum AccountReceivableStatus {
  @JsonValue('PENDIENTE')
  pendiente,
  @JsonValue('PAGADA')
  pagada,
  @JsonValue('VENCIDA')
  vencida,
  @JsonValue('CANCELADA')
  cancelada,
}

/// Entidad de Cuenta por Cobrar (CxC)
/// Registra deudas de terceros asociadas a un portafolio
/// Validaciones:
/// - amount > 0 (validar en repository/usecase)
/// - portfolioId debe existir y estar ACTIVE (validar en repository/usecase)
/// - debtorActorId obligatorio (validar en repository/usecase)
/// - dueDate >= issueDate (validar en repository/usecase)
/// - createdAt = DateTime.now() al crear (no null en persistencia)
@freezed
abstract class AccountReceivableEntity with _$AccountReceivableEntity {
  const factory AccountReceivableEntity({
    required String id,
    required String portfolioId,
    required String debtorActorId,
    required double amount,
    required DateTime issueDate,
    required DateTime dueDate,
    @Default(AccountReceivableStatus.pendiente) AccountReceivableStatus status,
    String? description,
    required String createdBy,
    required DateTime createdAt,
  }) = _AccountReceivableEntity;

  factory AccountReceivableEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountReceivableEntityFromJson(json);
}
