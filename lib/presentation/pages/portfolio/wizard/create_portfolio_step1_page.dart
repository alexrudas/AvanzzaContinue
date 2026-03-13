// lib/presentation/pages/portfolio/wizard/create_portfolio_step1_page.dart
//
// Wizard Paso 1: Registrar Activo (crea portafolio internamente)
//
// DISEÑO DE ESTADO:
// Todo el estado del formulario se persiste en CreatePortfolioController.draft*.
// Esto garantiza que al navegar al Paso 2 y volver, los campos no se reseteen.
// El widget solo lee el draft en initState y escribe de vuelta en cada cambio.
//
// Campos:
// - assetType (null hasta que el usuario elige; readonly si viene preseleccionado)
// - portfolioName (opcional: se auto-genera si está vacío)
// - country
// - city

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../routes/app_routes.dart';
import '../../../widgets/selectors/asset_type_selector.dart';
import '../controllers/create_portfolio_controller.dart';

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

  // Controller compartido del wizard; persistido en GetX durante todo el flujo.
  late final CreatePortfolioController _ctrl;

  // TextEditingController sincronizado con ctrl.draftPortfolioName.
  final _nameController = TextEditingController();

  bool get _isTypePreselected => widget.preselectedAssetType != null;

  @override
  void initState() {
    super.initState();

    // Crear o recuperar el controller compartido del wizard.
    _ctrl = Get.put(CreatePortfolioController());

    // Si viene tipo preseleccionado, persistirlo en el draft.
    if (_isTypePreselected) {
      _ctrl.selectedAssetType.value = widget.preselectedAssetType;
    }
    // Si NO hay preselección Y el draft ya tiene un tipo (usuario regresó
    // desde Step2), conservar el valor del draft sin sobreescribir.

    // Inicializar campo de nombre desde el draft del controller.
    _nameController.text = _ctrl.draftPortfolioName.value;

    // Sincronizar cambios del campo → draft del controller.
    _nameController.addListener(() {
      _ctrl.draftPortfolioName.value = _nameController.text;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// País y ciudad son obligatorios; el nombre se auto-genera si está vacío.
  /// El tipo de activo es obligatorio solo cuando no hay preselección.
  bool get _canContinue {
    final hasType = _ctrl.selectedAssetType.value != null;
    final hasLocation = _ctrl.draftCountryId.value != null &&
        _ctrl.draftCityId.value != null;
    return hasType && hasLocation;
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) return;

    HapticFeedback.lightImpact();

    final assetType = _ctrl.selectedAssetType.value!;

    // Si el usuario no escribió un nombre, usar el sugerido del tipo.
    final portfolioName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : assetType.suggestedPortfolioName;

    try {
      await _ctrl.createPortfolioStep1(
        portfolioType: assetType.portfolioType,
        portfolioName: portfolioName,
        countryId: _ctrl.draftCountryId.value!,
        cityId: _ctrl.draftCityId.value!,
      );

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

  /// Actualiza el tipo en el draft y fuerza rebuild (canContinue depende de él).
  void _onAssetTypeChanged(AssetType type) {
    _ctrl.selectedAssetType.value = type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Leer del draft para inicializar los dropdowns localmente.
    // Los dropdowns de Material requieren estado local para funcionar.
    final countryId = _ctrl.draftCountryId.value;
    final cityId = _ctrl.draftCityId.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            MediaQuery.of(context).padding.bottom + AppSpacing.xl,
          ),
          children: [
            // ── Encabezado ─────────────────────────────────────────────
            Text(
              'Registrar activo',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Paso 1 de 2',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Sección: Información básica ────────────────────────────
            Text(
              'Información básica',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Se creará un portafolio para organizar tus activos.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Tipo de activo ─────────────────────────────────────────
            Text(
              'Tipo de activo',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Selecciona el tipo de activo que deseas registrar.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Usa el widget existente del proyecto (selectors/).
            // selected: null → muestra placeholder hasta que el usuario elige.
            // enabled: false cuando hay preselección (no debe poder cambiarlo).
            AssetTypeSelector(
              selected: _ctrl.selectedAssetType.value,
              onChanged: _onAssetTypeChanged,
              enabled: !_isTypePreselected,
              subtitle: 'Categoría del activo a registrar',
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Nombre del portafolio ──────────────────────────────────
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del portafolio',
                // Sugerencia dinámica: cambia con el tipo de activo.
                hintText: _ctrl.selectedAssetType.value?.suggestedPortfolioName
                    ?? 'Nombre del portafolio',
                border: const OutlineInputBorder(),
                helperText: 'Puedes personalizarlo si lo deseas.',
                constraints: const BoxConstraints(minHeight: 56),
              ),
              // onChange se maneja via listener en initState.
            ),
            const SizedBox(height: AppSpacing.md),

            // ── País ───────────────────────────────────────────────────
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'País *',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(minHeight: 56),
              ),
              value: countryId,
              items: const [
                DropdownMenuItem(value: 'CO', child: Text('Colombia')),
                DropdownMenuItem(value: 'MX', child: Text('México')),
              ],
              onChanged: (value) {
                _ctrl.draftCountryId.value = value;
                _ctrl.draftCityId.value = null; // reset ciudad al cambiar país
                setState(() {});
              },
              validator: (value) {
                if (value == null) return 'Selecciona un país';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Ciudad ─────────────────────────────────────────────────
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ciudad *',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(minHeight: 56),
              ),
              value: cityId,
              items: countryId == 'CO'
                  ? const [
                      DropdownMenuItem(value: 'BOG', child: Text('Bogotá')),
                      DropdownMenuItem(value: 'MED', child: Text('Medellín')),
                    ]
                  : countryId == 'MX'
                      ? const [
                          DropdownMenuItem(
                              value: 'CDMX', child: Text('CDMX')),
                          DropdownMenuItem(
                              value: 'GDL', child: Text('Guadalajara')),
                        ]
                      : null,
              onChanged: countryId == null
                  ? null
                  : (value) {
                      _ctrl.draftCityId.value = value;
                      setState(() {});
                    },
              validator: (value) {
                if (value == null) return 'Selecciona una ciudad';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Botón Continuar ────────────────────────────────────────
            Obx(() {
              final canGo = _ctrl.selectedAssetType.value != null &&
                  _ctrl.draftCountryId.value != null &&
                  _ctrl.draftCityId.value != null &&
                  !_ctrl.isLoading.value;

              return FilledButton(
                onPressed: canGo ? _handleContinue : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _ctrl.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
