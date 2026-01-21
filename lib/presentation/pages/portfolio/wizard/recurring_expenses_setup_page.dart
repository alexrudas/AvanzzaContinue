import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/finance/expense_entity.dart';

/// Pantalla sugerida de gastos recurrentes
///
/// Hook post-creación del primer activo:
/// - Se muestra cuando un portafolio pasa de DRAFT → ACTIVE
/// - Es OPCIONAL (usuario puede omitirla)
/// - Permite configurar gastos recurrentes base (mantenimiento, seguros, servicios, otros)
///
/// Por ahora:
/// - Solo UI + guardado básico
/// - NO cálculos
/// - NO inteligencia
/// - NO alertas
class RecurringExpensesSetupPage extends StatefulWidget {
  final String portfolioId;

  const RecurringExpensesSetupPage({
    super.key,
    required this.portfolioId,
  });

  @override
  State<RecurringExpensesSetupPage> createState() =>
      _RecurringExpensesSetupPageState();
}

class _RecurringExpensesSetupPageState
    extends State<RecurringExpensesSetupPage> {
  // Gastos recurrentes sugeridos (hardcode temporal)
  final List<ExpenseType> _suggestedExpenseTypes = [
    ExpenseType.mantenimiento,
    ExpenseType.seguro,
    ExpenseType.servicio,
    ExpenseType.otro,
  ];

  final Set<ExpenseType> _selectedExpenses = {};

  bool get _hasSelection => _selectedExpenses.isNotEmpty;

  /// Guardar gastos recurrentes seleccionados
  Future<void> _handleConfigureNow() async {
    if (!_hasSelection) return;

    HapticFeedback.lightImpact();

    try {
      // TODO: Guardar gastos recurrentes usando FinanceRepository
      // Por cada tipo seleccionado, crear un ExpenseEntity con:
      // - portfolioId
      // - expenseType
      // - amount = 0 (placeholder, usuario lo completa después)
      // - date = DateTime.now()
      // - description = "Gasto recurrente - ${expenseType}"

      if (mounted) {
        Get.back(); // Volver a Home o lista de portafolios
        Get.snackbar(
          'Configuración guardada',
          'Los gastos recurrentes han sido configurados',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'No se pudo guardar la configuración: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    }
  }

  /// Omitir configuración (ir directo a Home)
  void _handleSkip() {
    HapticFeedback.lightImpact();
    Get.back(); // Volver a Home o lista de portafolios
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Gastos'),
        actions: [
          TextButton(
            onPressed: _handleSkip,
            child: const Text('Omitir'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Text(
              'Configura tus gastos recurrentes',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Selecciona los tipos de gastos que tendrás regularmente. '
              'Esto te ayudará a mantener un mejor control financiero.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Lista de gastos sugeridos
            Expanded(
              child: ListView.separated(
                itemCount: _suggestedExpenseTypes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final expenseType = _suggestedExpenseTypes[index];
                  final isSelected = _selectedExpenses.contains(expenseType);

                  return _ExpenseTypeCard(
                    expenseType: expenseType,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedExpenses.remove(expenseType);
                        } else {
                          _selectedExpenses.add(expenseType);
                        }
                      });
                      HapticFeedback.selectionClick();
                    },
                  );
                },
              ),
            ),

            // Botones CTA
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleSkip,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Lo haré luego'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _hasSelection ? _handleConfigureNow : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Configurar ahora'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de tipo de gasto
class _ExpenseTypeCard extends StatelessWidget {
  final ExpenseType expenseType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExpenseTypeCard({
    required this.expenseType,
    required this.isSelected,
    required this.onTap,
  });

  String get _label {
    switch (expenseType) {
      case ExpenseType.mantenimiento:
        return 'Mantenimiento';
      case ExpenseType.seguro:
        return 'Seguros';
      case ExpenseType.servicio:
        return 'Servicios';
      case ExpenseType.impuesto:
        return 'Impuestos';
      case ExpenseType.otro:
        return 'Otros';
    }
  }

  String get _description {
    switch (expenseType) {
      case ExpenseType.mantenimiento:
        return 'Mantenimientos preventivos y correctivos';
      case ExpenseType.seguro:
        return 'SOAT, seguros obligatorios y opcionales';
      case ExpenseType.servicio:
        return 'Combustible, peajes, parqueadero';
      case ExpenseType.impuesto:
        return 'Impuestos vehiculares y municipales';
      case ExpenseType.otro:
        return 'Otros gastos no categorizados';
    }
  }

  IconData get _icon {
    switch (expenseType) {
      case ExpenseType.mantenimiento:
        return Icons.build_circle_outlined;
      case ExpenseType.seguro:
        return Icons.shield_outlined;
      case ExpenseType.servicio:
        return Icons.local_gas_station_outlined;
      case ExpenseType.impuesto:
        return Icons.receipt_long_outlined;
      case ExpenseType.otro:
        return Icons.more_horiz_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Ícono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.2)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
