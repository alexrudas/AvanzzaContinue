import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/create_portfolio_controller.dart';
import 'recurring_expenses_setup_page.dart';

/// Wizard Paso 2: Agregar Vehículo desde RUNT
///
/// Inputs mínimos:
/// - plate
/// - ownerDocType
/// - ownerDocNumber
///
/// Flujo:
/// 1. Consultar RUNT (usa RuntController existente)
/// 2. Mostrar datos del vehículo
/// 3. Confirmar y crear
/// 4. Vincular al portfolioId del controller (Paso 1)
/// 5. Transición DRAFT → ACTIVE del portfolio
/// 6. Mostrar pantalla sugerida de gastos recurrentes (hook)
class CreatePortfolioStep2Page extends StatefulWidget {
  const CreatePortfolioStep2Page({super.key});

  @override
  State<CreatePortfolioStep2Page> createState() =>
      _CreatePortfolioStep2PageState();
}

class _CreatePortfolioStep2PageState extends State<CreatePortfolioStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<CreatePortfolioController>();

  final _plateController = TextEditingController();
  String? _selectedDocType;
  final _docNumberController = TextEditingController();

  bool _isConsulting = false;
  Map<String, dynamic>? _runtData; // Datos consultados del RUNT

  @override
  void dispose() {
    _plateController.dispose();
    _docNumberController.dispose();
    super.dispose();
  }

  bool get _canConsult =>
      _plateController.text.isNotEmpty &&
      _selectedDocType != null &&
      _docNumberController.text.isNotEmpty;

  bool get _canConfirm => _runtData != null;

  /// Consultar RUNT (usa RuntController existente)
  Future<void> _handleConsultRunt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isConsulting = true);

    try {
      // TODO: Usar RuntController existente
      // await runtController.consultVehicle(
      //   plate: _plateController.text.trim().toUpperCase(),
      //   ownerDocType: _selectedDocType!,
      //   ownerDocNumber: _docNumberController.text.trim(),
      // );
      // _runtData = runtController.vehicleData;

      throw UnimplementedError('RuntController integration not implemented yet');
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'No se pudo consultar el vehículo en RUNT: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } finally {
      setState(() => _isConsulting = false);
    }
  }

  /// Confirmar y crear vehículo vinculado al portfolio
  Future<void> _handleConfirm() async {
    if (_runtData == null) return;
    if (_controller.portfolioId == null) {
      throw Exception('No portfolio ID. Complete Step 1 first.');
    }

    HapticFeedback.lightImpact();

    try {
      // TODO: Obtener countryId y cityId del portfolio creado en Paso 1
      // final portfolio = await portfolioRepo.getPortfolioById(_controller.portfolioId!);
      // final countryId = portfolio.countryId;
      // final cityId = portfolio.cityId;

      // TODO: Extraer anio del RUNT
      // final anio = _runtData!['modelo'] as int;

      // Vincular vehículo al portfolio
      await _controller.linkFirstAssetToPortfolio(
        plate: _runtData!['placa'],
        marca: _runtData!['marca'],
        modelo: _runtData!['linea'] ?? _runtData!['modelo'].toString(),
        anio: _runtData!['modelo'], // TODO: Validar formato correcto del RUNT
        countryId: 'PLACEHOLDER', // TODO: Obtener del portfolio
        cityId: 'PLACEHOLDER', // TODO: Obtener del portfolio
      );

      // Hook: Mostrar pantalla sugerida de gastos recurrentes
      if (mounted) {
        Get.off(() => RecurringExpensesSetupPage(
              portfolioId: _controller.portfolioId!,
            ));
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'No se pudo crear el vehículo: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agregar Vehículo'),
            Text(
              'Paso 2 de 2',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Título
            Text(
              'Consulta RUNT',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingresa la placa y los datos del propietario para consultar el vehículo en RUNT.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Placa
            TextFormField(
              controller: _plateController,
              decoration: const InputDecoration(
                labelText: 'Placa *',
                hintText: 'ABC123',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La placa es obligatoria';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Tipo de Documento
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipo de documento del propietario *',
                border: OutlineInputBorder(),
              ),
              value: _selectedDocType,
              items: const [
                DropdownMenuItem(value: 'CC', child: Text('Cédula de Ciudadanía')),
                DropdownMenuItem(value: 'CE', child: Text('Cédula de Extranjería')),
                DropdownMenuItem(value: 'NIT', child: Text('NIT')),
              ],
              onChanged: (value) => setState(() => _selectedDocType = value),
              validator: (value) {
                if (value == null) return 'Selecciona un tipo de documento';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Número de Documento
            TextFormField(
              controller: _docNumberController,
              decoration: const InputDecoration(
                labelText: 'Número de documento *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El número de documento es obligatorio';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Botón Consultar
            FilledButton(
              onPressed: _canConsult && !_isConsulting ? _handleConsultRunt : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isConsulting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Consultar RUNT'),
            ),

            // Datos del vehículo (si se consultó)
            if (_runtData != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Datos del vehículo',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _InfoTile(label: 'Placa', value: _runtData!['placa']),
              _InfoTile(label: 'Marca', value: _runtData!['marca']),
              _InfoTile(label: 'Línea', value: _runtData!['linea'] ?? 'N/A'),
              _InfoTile(label: 'Modelo', value: _runtData!['modelo'].toString()),
              const SizedBox(height: 24),

              // Botón Confirmar
              FilledButton.tonal(
                onPressed: _canConfirm ? _handleConfirm : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirmar y Agregar a Portafolio'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget auxiliar para mostrar info del vehículo
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
