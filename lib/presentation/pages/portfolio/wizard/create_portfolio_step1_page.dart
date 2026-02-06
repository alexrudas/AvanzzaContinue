import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/create_portfolio_controller.dart';

/// Wizard Paso 1: Registrar Activo (crea portafolio internamente)
///
/// Recibe obligatoriamente `preselectedAssetType` desde ActionSheet.
/// El tipo de activo determina automáticamente el PortfolioType.
/// El usuario NO debe sentir que "crea un portafolio".
///
/// Campos:
/// - assetType (readonly, viene preseleccionado)
/// - portfolioName (sugerido automáticamente)
/// - country
/// - city
///
/// Al guardar:
/// - Controller crea portafolio con status = DRAFT y assetsCount = 0
/// - Navega a Paso 2 (agregar primer activo)
class CreatePortfolioStep1Page extends StatefulWidget {
  final AssetType? preselectedAssetType;

  const CreatePortfolioStep1Page({
    super.key,
    this.preselectedAssetType,
  });

  @override
  State<CreatePortfolioStep1Page> createState() =>
      _CreatePortfolioStep1PageState();
}

class _CreatePortfolioStep1PageState extends State<CreatePortfolioStep1Page> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(CreatePortfolioController());

  late AssetType _assetType;
  late PortfolioType _portfolioType;
  final _nameController = TextEditingController();
  String? _selectedCountryId;
  String? _selectedCityId;

  /// True si el tipo viene preseleccionado (readonly)
  bool get _isTypePreselected => widget.preselectedAssetType != null;

  @override
  void initState() {
    super.initState();

    // Usar tipo preseleccionado o default a vehículo
    _assetType = widget.preselectedAssetType ?? AssetType.vehiculo;
    _portfolioType = _assetType.portfolioType;

    // CRÍTICO: Persistir assetType en controller para Step2
    _controller.selectedAssetType.value = _assetType;

    // Pre-rellenar nombre sugerido
    _nameController.text = _assetType.suggestedPortfolioName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameController.text.isNotEmpty &&
      _selectedCountryId != null &&
      _selectedCityId != null;

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) return;

    HapticFeedback.lightImpact();

    try {
      // UI solo envía params al controller
      // Controller crea PortfolioEntity y maneja repo
      await _controller.createPortfolioStep1(
        portfolioType: _portfolioType,
        portfolioName: _nameController.text.trim(),
        countryId: _selectedCountryId!,
        cityId: _selectedCityId!,
      );

      // Navegar a Step 2 (controller ya tiene portfolioId)
      if (mounted) {
        Get.toNamed(Routes.createPortfolioStep2);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'No se pudo continuar: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Registrar activo'),
            Text(
              'Paso 1 de 2',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
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
              'Se creará un portafolio para organizar tus activos.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Tipo de Activo (readonly si viene preseleccionado)
            Text(
              'Tipo de activo',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildAssetTypeDisplay(theme, cs),
            const SizedBox(height: 24),

            // Nombre del Portafolio
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del portafolio *',
                hintText: _assetType.suggestedPortfolioName,
                border: const OutlineInputBorder(),
                helperText: 'Puedes personalizarlo como desees',
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

            // País
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'País *',
                border: OutlineInputBorder(),
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

            // Ciudad
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ciudad *',
                border: OutlineInputBorder(),
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

  /// Muestra el tipo de activo seleccionado.
  /// Si viene preseleccionado: chip único readonly (disabled).
  /// Si NO viene preseleccionado: selector interactivo.
  Widget _buildAssetTypeDisplay(ThemeData theme, ColorScheme cs) {
    if (_isTypePreselected) {
      // READONLY: Chip único, no interactivo
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _assetType.icon,
              color: cs.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _assetType.displayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.lock_outline,
              color: cs.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      );
    }

    // INTERACTIVO: Permite selección (caso raro, no debería ocurrir)
    return Wrap(
      spacing: 12,
      children: AssetType.values.map((type) {
        final isSelected = _assetType == type;
        return ChoiceChip(
          label: Text(type.displayName),
          avatar: Icon(type.icon, size: 18),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _assetType = type;
                _portfolioType = type.portfolioType;
                // Actualizar nombre sugerido si no fue modificado
                if (_nameController.text == _assetType.suggestedPortfolioName ||
                    _nameController.text.isEmpty) {
                  _nameController.text = type.suggestedPortfolioName;
                }
              });
              HapticFeedback.selectionClick();
            }
          },
        );
      }).toList(),
    );
  }
}
