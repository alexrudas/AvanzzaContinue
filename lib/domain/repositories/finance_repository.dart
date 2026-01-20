import '../entities/finance/income_entity.dart';
import '../entities/finance/expense_entity.dart';
import '../entities/finance/account_receivable_entity.dart';

/// Repositorio de Finanzas
/// Gestiona ingresos, gastos y cuentas por cobrar
///
/// Validaciones comunes:
/// - amount > 0
/// - portfolioId debe existir y estar ACTIVE
/// - createdAt = DateTime.now() al crear
abstract class FinanceRepository {
  // ==================== INGRESOS ====================

  /// Crear un ingreso
  /// Validaciones:
  /// - amount > 0
  /// - portfolioId existe y está ACTIVE
  Future<IncomeEntity> createIncome(IncomeEntity income);

  /// Obtener ingresos de un portafolio
  Future<List<IncomeEntity>> getIncomesByPortfolio(String portfolioId);

  // ==================== GASTOS ====================

  /// Crear un gasto
  /// Validaciones:
  /// - amount > 0
  /// - portfolioId existe y está ACTIVE
  Future<ExpenseEntity> createExpense(ExpenseEntity expense);

  /// Obtener gastos de un portafolio
  Future<List<ExpenseEntity>> getExpensesByPortfolio(String portfolioId);

  // ==================== CUENTAS POR COBRAR ====================

  /// Crear una cuenta por cobrar
  /// Validaciones:
  /// - amount > 0
  /// - portfolioId existe y está ACTIVE
  /// - debtorActorId obligatorio
  /// - dueDate >= issueDate
  Future<AccountReceivableEntity> createAccountReceivable(
      AccountReceivableEntity accountReceivable);

  /// Obtener cuentas por cobrar de un portafolio
  Future<List<AccountReceivableEntity>> getAccountReceivablesByPortfolio(
      String portfolioId);

  /// Actualizar estado de cuenta por cobrar
  /// Retorna la entidad actualizada para mantener consistencia
  Future<AccountReceivableEntity> updateAccountReceivableStatus(
      String id, AccountReceivableStatus status);
}
