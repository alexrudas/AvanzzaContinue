// ============================================================================
// lib/presentation/pages/portfolio/wizard/create_portfolio_step2_page.dart
//
// WIZARD PASO 2 — FORMULARIO DE CONSULTA RUNT (Enterprise-grade Ultra Pro)
//
// PROPÓSITO
// Recoger los datos mínimos para consultar el RUNT dentro del wizard de
// registro de activos y redirigir al flujo:
//
//   Step2 (form)
//     → RuntQueryProgressPage
//     → RuntQueryResultPage
//
// RESPONSABILIDAD
// - Renderizar el formulario de entrada.
// - Restaurar valores previos del draft del wizard.
// - Detectar si ya existe un job activo/finalizado y redirigir.
// - Lanzar la consulta RUNT asíncrona.
// - Mantener UX consistente con el design system del flujo.
//
// NO RESPONSABILIDAD
// - No hace polling.
// - No muestra resultados del RUNT.
// - No persiste directamente en infraestructura.
// - No decide reglas de negocio del registro del activo.
//
// DECISIONES DE DISEÑO
// - El campo "Tipo de documento" usa BottomSheet en lugar de dropdown clásico.
// - La navegación automática usa `offNamed` para evitar apilar pantallas
//   duplicadas cuando el draft ya tiene estado activo o finalizado.
// - El botón principal reacciona al formulario en tiempo real.
// - La redirección automática ocurre una sola vez por montaje para evitar
//   loops o dobles navegaciones.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../routes/app_routes.dart';
import '../../../controllers/runt/runt_query_controller.dart';
import '../controllers/create_portfolio_controller.dart';

class CreatePortfolioStep2Page extends StatefulWidget {
  const CreatePortfolioStep2Page({super.key});

  @override
  State<CreatePortfolioStep2Page> createState() =>
      _CreatePortfolioStep2PageState();
}

class _CreatePortfolioStep2PageState extends State<CreatePortfolioStep2Page> {
  final _formKey = GlobalKey<FormState>();

  late final CreatePortfolioController _portfolioCtrl;
  late final RuntQueryController _runtQueryCtrl;

  final _plateController = TextEditingController();
  final _docNumberController = TextEditingController();

  String? _selectedDocType;
  AssetRegistrationType? _assetType;

  bool _isBootstrapping = true;
  bool _didAutoRedirect = false;

  static const List<_DocTypeOption> _docTypeOptions = [
    _DocTypeOption(
      value: 'CC',
      title: 'Cédula de ciudadanía',
      icon: Icons.badge_outlined,
    ),
    _DocTypeOption(
      value: 'CE',
      title: 'Cédula de extranjería',
      icon: Icons.badge_outlined,
    ),
    _DocTypeOption(
      value: 'NIT',
      title: 'NIT (empresa)',
      icon: Icons.business_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _portfolioCtrl = Get.find<CreatePortfolioController>();
    _runtQueryCtrl = Get.find<RuntQueryController>();

    _assetType = _portfolioCtrl.selectedAssetType.value;

    _restoreLocalDraftFields();
    _wireFormListeners();
    _bootstrapDraftState();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _docNumberController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Bootstrap / restauración
  // ───────────────────────────────────────────────────────────────────────────

  void _restoreLocalDraftFields() {
    _plateController.text = _portfolioCtrl.draftPlate.value;
    _selectedDocType = _portfolioCtrl.draftDocType.value;
    _docNumberController.text = _portfolioCtrl.draftDocNumber.value;
  }

  void _wireFormListeners() {
    _plateController.addListener(() {
      _portfolioCtrl.draftPlate.value = _plateController.text;
      if (mounted) setState(() {});
    });

    _docNumberController.addListener(() {
      _portfolioCtrl.draftDocNumber.value = _docNumberController.text;
      if (mounted) setState(() {});
    });
  }

  Future<void> _bootstrapDraftState() async {
    final draftId = _portfolioCtrl.portfolioId;
    if (draftId != null && draftId.trim().isNotEmpty) {
      await _runtQueryCtrl.loadDraft(draftId);

      if (!mounted) return;

      final state = _runtQueryCtrl.viewState.value;
      _redirectIfNeeded(state);
    }

    if (!mounted) return;
    setState(() {
      _isBootstrapping = false;
    });
  }

  void _redirectIfNeeded(RuntViewState state) {
    if (_didAutoRedirect || !mounted) return;

    switch (state) {
      case RuntViewState.pending:
      case RuntViewState.running:
      case RuntViewState.connectionInterrupted:
      case RuntViewState.jobUnavailable:
        _didAutoRedirect = true;
        Get.offNamed(Routes.runtQueryProgress);
        return;

      case RuntViewState.completed:
      case RuntViewState.partial:
        _didAutoRedirect = true;
        Get.offNamed(Routes.runtQueryResult);
        return;

      case RuntViewState.idle:
      case RuntViewState.failed:
        return;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Form state
  // ───────────────────────────────────────────────────────────────────────────

  bool get _canConsult {
    return _plateController.text.trim().isNotEmpty &&
        (_selectedDocType?.trim().isNotEmpty ?? false) &&
        _docNumberController.text.trim().isNotEmpty;
  }

  Future<void> _openDocTypeBottomSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selecciona el tipo de documento',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ..._docTypeOptions.map(
                  (option) => ListTile(
                    leading: Icon(option.icon, color: colors.primary),
                    title: Text(option.title),
                    trailing: _selectedDocType == option.value
                        ? Icon(Icons.check, color: colors.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(option.value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || !mounted) return;

    setState(() {
      _selectedDocType = selected;
      _portfolioCtrl.draftDocType.value = selected;
    });
  }

  Future<void> _handleConsult() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final portfolioId = _portfolioCtrl.portfolioId;
    if (portfolioId == null || portfolioId.trim().isEmpty) {
      Get.snackbar(
        'Error de flujo',
        'No hay portafolio activo. Regresa al paso 1.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    HapticFeedback.lightImpact();

    await _runtQueryCtrl.startQuery(
      draftId: portfolioId,
      plate: _plateController.text.trim().toUpperCase(),
      portfolioId: portfolioId,
      portfolioName: _portfolioCtrl.createdPortfolioName ?? portfolioId,
      documentType: _selectedDocType!,
      documentNumber: _docNumberController.text.trim(),
    );

    if (!mounted) return;

    final state = _runtQueryCtrl.viewState.value;
    if (state == RuntViewState.failed) return;

    Get.toNamed(Routes.runtQueryProgress);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Build
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isBootstrapping) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar activo'),
        centerTitle: true,
      ),
      body: _assetType == AssetRegistrationType.vehiculo
          ? _VehicleFormBody(
              formKey: _formKey,
              plateController: _plateController,
              docNumberController: _docNumberController,
              selectedDocType: _selectedDocType,
              canConsult: _canConsult,
              onOpenDocTypeSelector: _openDocTypeBottomSheet,
              onConsult: _handleConsult,
              runtQueryCtrl: _runtQueryCtrl,
            )
          : const _PlaceholderBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORMULARIO VEHÍCULO
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController plateController;
  final TextEditingController docNumberController;
  final String? selectedDocType;
  final bool canConsult;
  final VoidCallback onOpenDocTypeSelector;
  final VoidCallback onConsult;

  final RuntQueryController runtQueryCtrl;

  const _VehicleFormBody({
    required this.formKey,
    required this.plateController,
    required this.docNumberController,
    required this.selectedDocType,
    required this.canConsult,
    required this.onOpenDocTypeSelector,
    required this.onConsult,
    required this.runtQueryCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consulta RUNT',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingresa la placa y los datos del propietario para verificar la información del vehículo antes de registrarlo en Avanzza.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            const _SectionLabel(label: 'Placa del vehículo'),
            const SizedBox(height: 8),
            TextFormField(
              controller: plateController,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(7),
                _UpperCaseFormatter(),
              ],
              decoration: const InputDecoration(
                hintText: 'ABC123',
                prefixIcon: Icon(Icons.directions_car_outlined),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Ingresa la placa del vehículo';
                }
                if (val.trim().length < 5) {
                  return 'La placa debe tener al menos 5 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const _SectionLabel(label: 'Tipo de documento del propietario'),
            const SizedBox(height: 8),
            _BottomSheetSelectorField(
              label: _docTypeLabel(selectedDocType),
              isEmpty: selectedDocType == null,
              icon: Icons.badge_outlined,
              onTap: onOpenDocTypeSelector,
              validator: () {
                if (selectedDocType == null ||
                    selectedDocType!.trim().isEmpty) {
                  return 'Selecciona el tipo de documento';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const _SectionLabel(label: 'Número de documento'),
            const SizedBox(height: 8),
            TextFormField(
              controller: docNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: const InputDecoration(
                hintText: '1234567890',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Ingresa el número de documento';
                }
                if (val.trim().length < 5) {
                  return 'El número de documento es muy corto';
                }
                return null;
              },
            ),
            const SizedBox(height: 36),
            Obx(() {
              final state = runtQueryCtrl.viewState.value;
              if (state != RuntViewState.failed) {
                return const SizedBox.shrink();
              }

              return _ErrorBanner(
                message: runtQueryCtrl.errorMessage.value,
              );
            }),
            Obx(() {
              final state = runtQueryCtrl.viewState.value;
              final isLoading = state == RuntViewState.pending ||
                  state == RuntViewState.running;

              return SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: (!canConsult || isLoading) ? null : onConsult,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search_rounded),
                  label: Text(
                    isLoading ? 'Consultando...' : 'CONSULTAR RUNT',
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 16,
                  color: colors.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Consulta oficial al sistema RUNT. La información se usa únicamente para validar el registro del activo.',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.outline,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _docTypeLabel(String? value) {
    switch (value) {
      case 'CC':
        return 'Cédula de ciudadanía';
      case 'CE':
        return 'Cédula de extranjería';
      case 'NIT':
        return 'NIT (empresa)';
      default:
        return 'Selecciona un tipo';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER NO VEHÍCULO
// ─────────────────────────────────────────────────────────────────────────────

class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 72,
              color: colors.outline,
            ),
            const SizedBox(height: 20),
            Text(
              'Próximamente',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'El registro de este tipo de activo estará disponible en una próxima versión.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('VOLVER'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APOYO UI
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String? message;

  const _ErrorBanner({
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message ??
                  'La consulta anterior no pudo completarse. Verifica los datos e intenta nuevamente.',
              style: TextStyle(
                color: colors.onErrorContainer,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetSelectorField extends StatelessWidget {
  final String label;
  final bool isEmpty;
  final IconData icon;
  final VoidCallback onTap;
  final String? Function() validator;

  const _BottomSheetSelectorField({
    required this.label,
    required this.isEmpty,
    required this.icon,
    required this.onTap,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FormField<void>(
      validator: (_) => validator(),
      builder: (state) {
        final borderColor = state.hasError
            ? colors.error
            : Theme.of(context)
                .inputDecorationTheme
                .enabledBorder
                ?.borderSide
                .color;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor ?? colors.outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: colors.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isEmpty
                              ? colors.onSurfaceVariant
                              : colors.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: colors.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DocTypeOption {
  final String value;
  final String title;
  final IconData icon;

  const _DocTypeOption({
    required this.value,
    required this.title,
    required this.icon,
  });
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
    );
  }
}
