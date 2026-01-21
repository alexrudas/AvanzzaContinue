import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../controllers/create_portfolio_controller.dart';

/// Wizard Paso 1: Crear Portafolio
/// Campos obligatorios:
/// - portfolioType (VEHICULOS | INMUEBLES)
/// - portfolioName
/// - country
/// - city
///
/// Al guardar:
/// - Controller crea portafolio con status = DRAFT y assetsCount = 0
/// - Navega a Paso 2 (agregar primer activo)
class CreatePortfolioStep1Page extends StatefulWidget {
  final PortfolioType? preselectedType;

  const CreatePortfolioStep1Page({
    super.key,
    this.preselectedType,
  });

  @override
  State<CreatePortfolioStep1Page> createState() =>
      _CreatePortfolioStep1PageState();
}

class _CreatePortfolioStep1PageState extends State<CreatePortfolioStep1Page> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(CreatePortfolioController());

  PortfolioType? _selectedType;
  final _nameController = TextEditingController();
  String? _selectedCountryId;
  String? _selectedCityId;

  @override
  void initState() {
    super.initState();
    // Preseleccionar tipo si viene del parámetro
    if (widget.preselectedType != null) {
      _selectedType = widget.preselectedType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedType != null &&
      _nameController.text.isNotEmpty &&
      _selectedCountryId != null &&
      _selectedCityId != null;

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) return;

    HapticFeedback.lightImpact();

    // UI solo envía params al controller
    // Controller crea PortfolioEntity y maneja repo
    await _controller.createPortfolioStep1(
      portfolioType: _selectedType!,
      portfolioName: _nameController.text.trim(),
      countryId: _selectedCountryId!,
      cityId: _selectedCityId!,
    );

    // TODO: Navegar a Step 2 con portfolioId real
    // Get.to(() => CreatePortfolioStep2Page(portfolioId: _controller.portfolioId));

    // PLACEHOLDER: Snackbar temporal
    if (mounted) {
      Get.snackbar(
        'Paso 1 Completado',
        'Portafolio creado. Ir a Paso 2 para agregar primer activo.',
        snackPosition: SnackPosition.BOTTOM,
      );
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
            const Text('Crear Portafolio'),
            Text(
              'Paso 1 de 2',
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
              'Información básica',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comienza creando tu portafolio. Luego agregarás tu primer activo.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Tipo de Portafolio
            Text(
              'Tipo de portafolio *',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('Vehículos'),
                  selected: _selectedType == PortfolioType.vehiculos,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? PortfolioType.vehiculos : null;
                    });
                    HapticFeedback.selectionClick();
                  },
                ),
                ChoiceChip(
                  label: const Text('Inmuebles'),
                  selected: _selectedType == PortfolioType.inmuebles,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? PortfolioType.inmuebles : null;
                    });
                    HapticFeedback.selectionClick();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nombre del Portafolio
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del portafolio *',
                hintText: 'Ej: Mi Flota de Vehículos',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // País - TODO: Usar selector real (Country Selector)
            // MOCK temporal con dropdown hardcoded
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'País *',
                border: OutlineInputBorder(),
                helperText: 'TODO: Usar selector real de países',
              ),
              value: _selectedCountryId,
              items: const [
                DropdownMenuItem(value: 'CO', child: Text('Colombia')),
                DropdownMenuItem(value: 'MX', child: Text('México')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCountryId = value;
                  _selectedCityId = null; // reset city
                });
              },
              validator: (value) {
                if (value == null) return 'Selecciona un país';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Ciudad - TODO: Usar selector real (City Selector)
            // MOCK temporal con dropdown hardcoded
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ciudad *',
                border: OutlineInputBorder(),
                helperText: 'TODO: Usar selector real de ciudades',
              ),
              value: _selectedCityId,
              items: _selectedCountryId == 'CO'
                  ? const [
                      DropdownMenuItem(value: 'BOG', child: Text('Bogotá')),
                      DropdownMenuItem(value: 'MED', child: Text('Medellín')),
                    ]
                  : _selectedCountryId == 'MX'
                      ? const [
                          DropdownMenuItem(value: 'CDMX', child: Text('CDMX')),
                          DropdownMenuItem(
                              value: 'GDL', child: Text('Guadalajara')),
                        ]
                      : null,
              onChanged: (value) {
                setState(() => _selectedCityId = value);
              },
              validator: (value) {
                if (value == null) return 'Selecciona una ciudad';
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Botón Continuar
            Obx(() => FilledButton(
                  onPressed: _canContinue && !_controller.isLoading.value
                      ? _handleContinue
                      : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continuar'),
                )),
          ],
        ),
      ),
    );
  }
}
