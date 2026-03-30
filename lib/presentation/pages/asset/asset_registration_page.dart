// ============================================================================
// lib/presentation/pages/asset/asset_registration_page.dart
// ASSET REGISTRATION PAGE — Formulario de consulta RUNT para registro de activo
//
// QUÉ HACE:
// - Recibe AssetRegistrationContext como argumento de navegación.
// - Presenta el formulario RUNT (placa, tipo doc, número doc) para iniciar
//   una consulta antes de registrar el activo.
// - Restaura campos del formulario desde AssetRegistrationController (draft en
//   memoria del controller).
// - Bootstrap: llama loadDraft(registrationSessionId) en initState. Si existe
//   un job activo (app suspendida mid-query), redirige a la pantalla correcta.
// - Cold-start recovery: si el draft de la sesión actual está idle (UUID fresco)
//   llama checkForOrphanedRuntJob() para detectar un job huérfano de la sesión
//   anterior. Si existe, muestra _RuntRecoveryBottomSheet con las opciones
//   correspondientes según el tipo de oferta.
// - Al consultar: navega a runtQueryProgress via toNamed (AssetRegistrationPage
//   queda en stack para que el controller sobreviva).
//
// QUÉ NO HACE:
// - No crea portafolios.
// - No importa CreatePortfolioController ni CreatePortfolioStep2Page.
// - No hace polling RUNT (delegado a RuntQueryController).
// - No registra el activo (delegado a AssetRegistrationController.registerVehicle).
// - No hace más de un check al backend por recovery (lo hace el controller).
//
// PRINCIPIOS:
// - Página nueva e independiente: sin acoplamiento estructural con Step2.
// - Guard de contexto en build(): si registrationContext es null, muestra error.
// - Switch expression exhaustivo sobre AssetRegistrationType: sin default.
// - Listeners de texto actualizan observables del controller sin setState.
//   La reactividad del botón principal se gestiona con Obx sobre observables.
// - Back navigation simple (Get.back()) — no requiere PopScope complejo.
// - Bottom sheet de recovery es isDismissible:true — dismiss = nueva consulta.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 separación Portfolio / Asset Registration.
// Canonical entry point para todos los flujos de registro de activo.
// Cold-start recovery añadido (2026-03): cubre el gap de registrationSessionId
// siempre UUID fresco. El snapshot vive en SharedPreferences, no en Isar.
// Duplicate vehicle detection añadido (2026-03): antes de lanzar la consulta
// RUNT se verifica si la placa ya existe en el portafolio (Isar, offline-first).
// Si existe, se muestra un bottom sheet con opciones: ver activo, actualizar, cancelar.
// Fail-open: si el check falla, la consulta procede normalmente.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/asset/asset_content.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../domain/shared/enums/asset_type.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/asset/asset_registration_controller.dart';
import '../../controllers/runt/runt_query_controller.dart';

class AssetRegistrationPage extends StatefulWidget {
  const AssetRegistrationPage({super.key});

  @override
  State<AssetRegistrationPage> createState() => _AssetRegistrationPageState();
}

class _AssetRegistrationPageState extends State<AssetRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  late final AssetRegistrationController _assetRegCtrl;
  late final RuntQueryController _runtQueryCtrl;

  final _plateController = TextEditingController();
  final _docNumberController = TextEditingController();

  /// Tipo de documento seleccionado en el bottom sheet.
  /// También sincronizado en _assetRegCtrl.draftDocType para sobrevivir
  /// reconstrucciones del widget.
  String? _selectedDocType;

  bool _isBootstrapping = true;

  /// Bandera que impide múltiples redirects automáticos en el mismo montaje.
  bool _didAutoRedirect = false;

  /// Flag de sesión: evita mostrar el bottom sheet cross-portfolio más de
  /// una vez por instancia de esta página (sin persistir en SharedPreferences).
  bool _hasShownCrossPortfolioWarning = false;

  static const List<_DocTypeOption> _docTypeOptions = [
    _DocTypeOption(value: 'CC', title: 'Cédula de ciudadanía', icon: Icons.badge_outlined),
    _DocTypeOption(value: 'CE', title: 'Cédula de extranjería', icon: Icons.badge_outlined),
    _DocTypeOption(value: 'NIT', title: 'NIT (empresa)', icon: Icons.business_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _assetRegCtrl = Get.find<AssetRegistrationController>();
    _runtQueryCtrl = Get.find<RuntQueryController>();

    _restoreFormFields();
    _wireFormListeners();
    _bootstrapDraftState();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _docNumberController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Bootstrap / restauración
  // ──────────────────────────────────────────────────────────────────────────

  /// Restaura los campos del formulario desde el draft en memoria del controller.
  void _restoreFormFields() {
    _plateController.text = _assetRegCtrl.draftPlate.value;
    _selectedDocType = _assetRegCtrl.draftDocType.value;
    _docNumberController.text = _assetRegCtrl.draftDocNumber.value;
  }

  /// Sincroniza cambios del formulario con los observables del controller.
  ///
  /// No llama setState — la reactividad del botón principal se gestiona
  /// por Obx sobre los observables del controller, evitando rebuilds del
  /// árbol completo en cada tecla.
  void _wireFormListeners() {
    _plateController.addListener(() {
      _assetRegCtrl.draftPlate.value = _plateController.text;
    });
    _docNumberController.addListener(() {
      _assetRegCtrl.draftDocNumber.value = _docNumberController.text;
    });
  }

  /// Carga el draft de Isar para el registrationSessionId.
  ///
  /// Para un UUID fresco (flujo normal), no hay draft — controller queda idle.
  /// En ese caso busca un job huérfano de la sesión anterior en SharedPreferences
  /// y muestra el bottom sheet de recovery si existe.
  ///
  /// Solo redirige automáticamente si la app fue suspendida mid-query (misma
  /// sesión) y el draft tiene un job activo o completado.
  Future<void> _bootstrapDraftState() async {
    final ctx = _assetRegCtrl.registrationContext;
    if (ctx != null) {
      await _runtQueryCtrl.loadDraft(ctx.registrationSessionId);
      if (!mounted) return;

      final state = _runtQueryCtrl.viewState.value;
      if (state != RuntViewState.idle) {
        // Sesión activa encontrada en Isar — redirigir directamente.
        setState(() => _isBootstrapping = false);
        _redirectIfNeeded(state);
        return;
      }

      // Draft idle (UUID fresco): buscar job huérfano de sesión anterior.
      // Se pasa el portfolioId actual para detectar mismatch de portafolio.
      final offer =
          await _runtQueryCtrl.checkForOrphanedRuntJob(ctx.portfolioId);
      if (!mounted) return;

      setState(() => _isBootstrapping = false);

      if (offer != null) {
        if (offer.isPortfolioMismatch) {
          // ── PORTAFOLIO INCORRECTO ────────────────────────────────────────
          // Guardrail de permisos: verificar que el portafolio origen aún
          // existe para este usuario. Si no existe → limpiar snapshot.
          if (!_hasShownCrossPortfolioWarning) {
            final sourcePortfolio = await DIContainer()
                .portfolioRepository
                .getPortfolioById(offer.portfolioId);
            if (!mounted) return;

            if (sourcePortfolio == null) {
              // Portafolio ya no accesible (permisos revocados o eliminado).
              // Limpiar snapshot silenciosamente — evita loop.
              _runtQueryCtrl.dismissRecovery();
            } else {
              _hasShownCrossPortfolioWarning = true;
              await _showCrossPortfolioBottomSheet(offer, sourcePortfolio);
            }
          }
        } else {
          await _showRecoveryBottomSheet(offer);
        }
      }
      return;
    }
    if (!mounted) return;
    setState(() => _isBootstrapping = false);
  }

  /// Muestra el bottom sheet de portafolio incorrecto y maneja la decisión.
  ///
  /// - "Ir a {portfolioName}": navega con [Get.offAllNamed] al flujo de
  ///   registro del portafolio correcto. El snapshot NO se limpia — la nueva
  ///   página llamará [checkForOrphanedRuntJob] con el portfolioId correcto
  ///   y el recovery normal se activa automáticamente.
  /// - "Más tarde" / drag-dismiss: no hace nada. El snapshot se preserva.
  Future<void> _showCrossPortfolioBottomSheet(
    RuntRecoveryOffer offer,
    PortfolioEntity sourcePortfolio,
  ) async {
    if (!mounted) return;

    final goToPortfolio = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isDismissible: true,
      builder: (ctx) => _CrossPortfolioBottomSheet(
        portfolioName: offer.portfolioName,
        onGoToPortfolio: () => Navigator.of(ctx).pop(true),
        onLater: () => Navigator.of(ctx).pop(false),
      ),
    );

    if (!mounted) return;

    if (goToPortfolio == true) {
      // Navegar al portafolio correcto. Snapshot preservado — el recovery
      // normal se activa al abrir la nueva AssetRegistrationPage.
      final newCtx = AssetRegistrationContext(
        portfolioId: sourcePortfolio.id,
        portfolioName: sourcePortfolio.portfolioName,
        countryId: sourcePortfolio.countryId,
        cityId: sourcePortfolio.cityId,
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: const Uuid().v4(),
        initialPlate: offer.plate,
      );
      Get.offAllNamed(Routes.assetRegister, arguments: newCtx);
    }
    // "Más tarde" → no action. Snapshot preservado para sesión futura.
  }

  /// Muestra el bottom sheet de cold-start recovery y maneja la decisión.
  ///
  /// - Aceptar: llama [RuntQueryController.acceptRecovery] y navega al
  ///   destino correspondiente según el tipo de oferta.
  /// - Descartar (botón o drag-to-dismiss): llama [dismissRecovery] y
  ///   permanece en el formulario para una nueva consulta.
  Future<void> _showRecoveryBottomSheet(RuntRecoveryOffer offer) async {
    if (!mounted) return;

    final accepted = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) => _RuntRecoveryBottomSheet(
        offer: offer,
        onAccept: () => Navigator.of(ctx).pop(true),
        onDismiss: () => Navigator.of(ctx).pop(false),
      ),
    );

    if (!mounted) return;

    if (accepted == true) {
      await _runtQueryCtrl.acceptRecovery(offer);
      if (!mounted) return;
      _navigateAfterRecovery(offer.type);
    } else {
      // null (drag dismiss) o false (botón descartar) → nueva consulta.
      _runtQueryCtrl.dismissRecovery();
    }
  }

  /// Navega al destino correcto tras aceptar la oferta de recovery.
  void _navigateAfterRecovery(RuntRecoveryType type) {
    if (!mounted) return;
    switch (type) {
      case RuntRecoveryType.readyToRegister:
      case RuntRecoveryType.partialToReview:
        // toNamed — AssetRegistrationPage permanece en stack (controller vive).
        Get.toNamed(Routes.runtQueryResult);
      case RuntRecoveryType.runningRecoverable:
        Get.toNamed(Routes.runtQueryProgress);
    }
  }

  /// Redirige automáticamente si el draft tiene un job activo o completado.
  /// Solo ejecuta una vez por montaje del widget.
  void _redirectIfNeeded(RuntViewState state) {
    if (_didAutoRedirect || !mounted) return;

    switch (state) {
      case RuntViewState.pending:
      case RuntViewState.running:
      case RuntViewState.connectionInterrupted:
      case RuntViewState.jobUnavailable:
        _didAutoRedirect = true;
        // toNamed (no offNamed) — AssetRegistrationPage queda en stack
        // para que el controller no sea destruido.
        Get.toNamed(Routes.runtQueryProgress);
        return;

      case RuntViewState.completed:
      case RuntViewState.partial:
        _didAutoRedirect = true;
        Get.toNamed(Routes.runtQueryResult);
        return;

      case RuntViewState.idle:
      case RuntViewState.failed:
        // Permanecer en el formulario. Si failed, el banner de error se muestra.
        return;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Formulario
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> _openDocTypeBottomSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        final textTheme = Theme.of(ctx).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selecciona el tipo de documento',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ..._docTypeOptions.map(
                  (option) => ListTile(
                    leading: Icon(option.icon, color: colors.primary),
                    title: Text(option.title),
                    trailing: _selectedDocType == option.value
                        ? Icon(Icons.check, color: colors.primary)
                        : null,
                    onTap: () => Navigator.of(ctx).pop(option.value),
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

    // setState necesario aquí: actualiza _BottomSheetSelectorField que
    // depende de _selectedDocType como estado local del widget.
    setState(() {
      _selectedDocType = selected;
      _assetRegCtrl.draftDocType.value = selected;
    });
  }

  Future<void> _handleConsult() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ctx = _assetRegCtrl.registrationContext;
    if (ctx == null) return; // guard — build() ya muestra la pantalla de error

    HapticFeedback.lightImpact();

    // Pre-flight: verificar si la placa ya existe en el portafolio (offline-first).
    final plate = _plateController.text.trim().toUpperCase();
    final duplicate = await _findDuplicateVehicle(plate, ctx.portfolioId);

    if (!mounted) return;

    if (duplicate != null) {
      // Existe un activo con esta placa — mostrar bottom sheet de opciones.
      final action = await _showDuplicateVehicleSheet(duplicate);
      if (!mounted) return;

      switch (action) {
        case _DuplicateVehicleAction.view:
          // Navegar al detalle del activo existente.
          Get.toNamed(Routes.assetDetail, arguments: duplicate.id);
          return;
        case _DuplicateVehicleAction.update:
          // Proceder con la consulta RUNT de todos modos (modo actualización).
          break;
        case _DuplicateVehicleAction.cancel:
        case null:
          return;
      }
    }

    await _runtQueryCtrl.startQuery(
      draftId: ctx.registrationSessionId,
      plate: plate,
      portfolioId: ctx.portfolioId,
      portfolioName: ctx.portfolioName,
      documentType: _selectedDocType!,
      documentNumber: _docNumberController.text.trim(),
    );

    if (!mounted) return;

    final state = _runtQueryCtrl.viewState.value;
    if (state == RuntViewState.failed) return; // banner de error visible en UI

    // toNamed: AssetRegistrationPage queda en stack → controller vive.
    Get.toNamed(Routes.runtQueryProgress);
  }

  /// Busca un activo vehicular activo con la placa dada en el portafolio.
  ///
  /// Usa [AssetRepository.getAssetsByPortfolio] — datos Isar (offline-first).
  /// Normaliza la placa igual que [AssetContent._normalizeAssetKey]:
  /// uppercase + strip de caracteres no alfanuméricos (excepto guión).
  ///
  /// Fail-open: si el repositorio lanza, retorna null y la consulta procede.
  Future<AssetEntity?> _findDuplicateVehicle(
    String plate,
    String portfolioId,
  ) async {
    try {
      final normalized = plate.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');
      if (normalized.isEmpty) return null;

      final assets = await DIContainer().assetRepository.getAssetsByPortfolio(portfolioId);
      return assets.where((a) => !a.isArchived && a.assetKey == normalized).firstOrNull;
    } catch (_) {
      // Fail-open: ante cualquier error el flujo de consulta RUNT continúa.
      return null;
    }
  }

  /// Muestra el bottom sheet de vehículo duplicado y retorna la acción elegida.
  ///
  /// null si el usuario descarta el sheet sin elegir (drag-to-dismiss).
  Future<_DuplicateVehicleAction?> _showDuplicateVehicleSheet(
    AssetEntity asset,
  ) async {
    if (!mounted) return null;

    return showModalBottomSheet<_DuplicateVehicleAction>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) => _DuplicateVehicleBottomSheet(
        asset: asset,
        onView: () => Navigator.of(ctx).pop(_DuplicateVehicleAction.view),
        onUpdate: () => Navigator.of(ctx).pop(_DuplicateVehicleAction.update),
        onCancel: () => Navigator.of(ctx).pop(_DuplicateVehicleAction.cancel),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Guard: contexto inválido → pantalla de error con back.
    final ctx = _assetRegCtrl.registrationContext;
    if (ctx == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registrar activo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text('No se pudo iniciar el registro.'),
              const SizedBox(height: 16),
              FilledButton(onPressed: Get.back, child: const Text('Volver')),
            ],
          ),
        ),
      );
    }

    if (_isBootstrapping) {
      return Scaffold(
        appBar: AppBar(title: Text('Nuevo activo · ${ctx.portfolioName}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo activo · ${ctx.portfolioName}'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
      ),
      body: _buildBody(ctx),
    );
  }

  /// Renderiza el cuerpo según el tipo de activo.
  ///
  /// Switch expression exhaustivo — sin default. Todos los casos de
  /// [AssetRegistrationType] deben ser tratados explícitamente.
  Widget _buildBody(AssetRegistrationContext ctx) => switch (ctx.assetType) {
        AssetRegistrationType.vehiculo => _VehicleFormBody(
            formKey: _formKey,
            plateController: _plateController,
            docNumberController: _docNumberController,
            selectedDocType: _selectedDocType,
            assetRegCtrl: _assetRegCtrl,
            runtQueryCtrl: _runtQueryCtrl,
            onOpenDocTypeSelector: _openDocTypeBottomSheet,
            onConsult: _handleConsult,
          ),
        AssetRegistrationType.inmueble ||
        AssetRegistrationType.maquinaria ||
        AssetRegistrationType.equipo ||
        AssetRegistrationType.otro =>
          _NonVehiclePlaceholder(assetType: ctx.assetType),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// FORMULARIO VEHÍCULO
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController plateController;
  final TextEditingController docNumberController;
  final String? selectedDocType;
  final AssetRegistrationController assetRegCtrl;
  final RuntQueryController runtQueryCtrl;
  final VoidCallback onOpenDocTypeSelector;
  final VoidCallback onConsult;

  const _VehicleFormBody({
    required this.formKey,
    required this.plateController,
    required this.docNumberController,
    required this.selectedDocType,
    required this.assetRegCtrl,
    required this.runtQueryCtrl,
    required this.onOpenDocTypeSelector,
    required this.onConsult,
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
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingresa la placa y los datos del propietario para verificar la '
              'información del vehículo antes de registrarlo en Avanzza.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // ── Placa ─────────────────────────────────────────────────────────
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

            // ── Tipo de documento ─────────────────────────────────────────────
            const _SectionLabel(label: 'Tipo de documento del propietario'),
            const SizedBox(height: 8),
            _BottomSheetSelectorField(
              label: _docTypeLabel(selectedDocType),
              isEmpty: selectedDocType == null,
              icon: Icons.badge_outlined,
              onTap: onOpenDocTypeSelector,
              validator: () {
                if (selectedDocType == null || selectedDocType!.trim().isEmpty) {
                  return 'Selecciona el tipo de documento';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ── Número de documento ───────────────────────────────────────────
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

            // ── Banner de error (si la consulta anterior falló) ───────────────
            Obx(() {
              if (runtQueryCtrl.viewState.value != RuntViewState.failed) {
                return const SizedBox.shrink();
              }
              return _ErrorBanner(message: runtQueryCtrl.errorMessage.value);
            }),

            // ── Botón principal ───────────────────────────────────────────────
            // Reactividad fina: Obx reconstruye solo este bloque cuando
            // viewState o los observables de draft cambian. No requiere
            // setState en los listeners de los TextEditingControllers.
            Obx(() {
              final state = runtQueryCtrl.viewState.value;
              final isLoading =
                  state == RuntViewState.pending || state == RuntViewState.running;

              // canConsult se computa desde observables del controller.
              final canConsult =
                  assetRegCtrl.draftPlate.value.trim().isNotEmpty &&
                  (assetRegCtrl.draftDocType.value?.trim().isNotEmpty ?? false) &&
                  assetRegCtrl.draftDocNumber.value.trim().isNotEmpty;

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
                  label: Text(isLoading ? 'Consultando...' : 'CONSULTAR RUNT'),
                ),
              );
            }),
            const SizedBox(height: 16),

            // ── Nota de privacidad ────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, size: 16, color: colors.outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Consulta oficial al sistema RUNT. La información se usa '
                    'únicamente para validar el registro del activo.',
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

  String _docTypeLabel(String? value) => switch (value) {
        'CC' => 'Cédula de ciudadanía',
        'CE' => 'Cédula de extranjería',
        'NIT' => 'NIT (empresa)',
        _ => 'Selecciona un tipo',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER TIPOS NO-VEHÍCULO
// ─────────────────────────────────────────────────────────────────────────────

/// Placeholder para tipos de activo sin flujo RUNT disponible aún.
/// Se mostrará hasta que se implementen flujos específicos por tipo.
class _NonVehiclePlaceholder extends StatelessWidget {
  final AssetRegistrationType assetType;
  const _NonVehiclePlaceholder({required this.assetType});

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
            Icon(Icons.construction_rounded, size: 72, color: colors.outline),
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
              'El registro de ${assetType.displayName.toLowerCase()} '
              'estará disponible en una próxima versión.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: Get.back,
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
// HELPERS DE UI (privados, autocontenidos)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.w700),
      );
}

class _ErrorBanner extends StatelessWidget {
  final String? message;
  const _ErrorBanner({this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: colors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message ??
                  'La consulta anterior no pudo completarse. '
                  'Verifica los datos e intenta nuevamente.',
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
                  border: Border.all(color: borderColor ?? colors.outlineVariant),
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
                  style: TextStyle(color: colors.error, fontSize: 12),
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
  ) =>
      newValue.copyWith(text: newValue.text.toUpperCase());
}

// ─────────────────────────────────────────────────────────────────────────────
// COLD-START RECOVERY BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

/// Bottom sheet de recuperación de job RUNT huérfano.
///
/// Muestra copy contextual según el tipo de oferta y expone dos acciones:
/// - [onAccept]: continuar con la consulta recuperada.
/// - [onDismiss]: descartar y hacer una consulta nueva.
///
/// No gestiona navegación ni mutación de estado — delega al caller.
class _RuntRecoveryBottomSheet extends StatelessWidget {
  final RuntRecoveryOffer offer;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  const _RuntRecoveryBottomSheet({
    required this.offer,
    required this.onAccept,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(_iconFor(offer.type), size: 52, color: _accentColor(offer.type, colors)),
            const SizedBox(height: 16),
            Text(
              _titleFor(offer.type),
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _bodyFor(offer),
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // CTA primario
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onAccept,
                child: Text(_acceptLabel(offer.type)),
              ),
            ),
            const SizedBox(height: 10),

            // CTA secundario — descartar
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: onDismiss,
                child: Text(
                  _dismissLabel(offer.type),
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(RuntRecoveryType type) => switch (type) {
        RuntRecoveryType.readyToRegister => Icons.check_circle_outline_rounded,
        RuntRecoveryType.partialToReview => Icons.info_outline_rounded,
        RuntRecoveryType.runningRecoverable => Icons.sync_rounded,
      };

  Color _accentColor(RuntRecoveryType type, ColorScheme colors) => switch (type) {
        RuntRecoveryType.readyToRegister => colors.primary,
        RuntRecoveryType.partialToReview => colors.tertiary,
        RuntRecoveryType.runningRecoverable => colors.secondary,
      };

  String _titleFor(RuntRecoveryType type) => switch (type) {
        RuntRecoveryType.readyToRegister => 'Consulta RUNT lista',
        RuntRecoveryType.partialToReview => 'Datos parciales disponibles',
        RuntRecoveryType.runningRecoverable => 'Consulta en proceso',
      };

  String _bodyFor(RuntRecoveryOffer o) => switch (o.type) {
        RuntRecoveryType.readyToRegister =>
          'La consulta para el vehículo ${o.plate} se completó correctamente.\n'
          '¿Deseas continuar con el registro?',
        RuntRecoveryType.partialToReview =>
          'Se obtuvieron datos parciales para el vehículo ${o.plate}.\n'
          '¿Deseas revisar los datos disponibles?',
        RuntRecoveryType.runningRecoverable =>
          'La consulta RUNT para ${o.plate} sigue en proceso.\n'
          '¿Retomamos el seguimiento?',
      };

  String _acceptLabel(RuntRecoveryType type) => switch (type) {
        RuntRecoveryType.readyToRegister => 'CONTINUAR REGISTRO',
        RuntRecoveryType.partialToReview => 'VER DATOS PARCIALES',
        RuntRecoveryType.runningRecoverable => 'RETOMAR SEGUIMIENTO',
      };

  String _dismissLabel(RuntRecoveryType type) => switch (type) {
        RuntRecoveryType.readyToRegister ||
        RuntRecoveryType.partialToReview =>
          'Descartar y hacer nueva consulta',
        RuntRecoveryType.runningRecoverable => 'Nueva consulta',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// CROSS-PORTFOLIO RECOVERY BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

/// Bottom sheet que se muestra cuando el job RUNT huérfano pertenece a un
/// portafolio distinto al contexto actual.
///
/// Presenta dos opciones:
/// - "Ir a {portfolioName}": navega al portafolio correcto para continuar.
/// - "Más tarde": cierra sin acción; snapshot preservado.
///
/// NO gestiona navegación — delega al caller.
class _CrossPortfolioBottomSheet extends StatelessWidget {
  final String portfolioName;
  final VoidCallback onGoToPortfolio;
  final VoidCallback onLater;

  const _CrossPortfolioBottomSheet({
    required this.portfolioName,
    required this.onGoToPortfolio,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(Icons.swap_horiz_rounded, size: 52, color: colors.secondary),
            const SizedBox(height: 16),
            Text(
              'Consulta pendiente en otro portafolio',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Esta consulta fue iniciada en "$portfolioName".\n'
              'Para continuar con el registro, debes ir a ese portafolio.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onGoToPortfolio,
                child: Text('IR A "$portfolioName"'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: onLater,
                child: Text(
                  'Más tarde',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DUPLICATE VEHICLE DETECTION
// ─────────────────────────────────────────────────────────────────────────────

/// Acciones disponibles cuando se detecta un vehículo duplicado en el portafolio.
enum _DuplicateVehicleAction {
  /// Navegar al detalle del activo existente.
  view,

  /// Proceder con la consulta RUNT de todos modos (modo actualización).
  update,

  /// Cancelar — permanecer en el formulario.
  cancel,
}

/// Bottom sheet que se muestra cuando la placa ingresada ya existe en el portafolio.
///
/// Presenta el nombre del activo existente y tres opciones:
/// - Ver vehículo (navega a AssetDetailPage).
/// - Actualizar información (procede con la consulta RUNT).
/// - Cancelar (permanece en el formulario).
///
/// No gestiona navegación — delega todas las acciones al caller.
class _DuplicateVehicleBottomSheet extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onView;
  final VoidCallback onUpdate;
  final VoidCallback onCancel;

  const _DuplicateVehicleBottomSheet({
    required this.asset,
    required this.onView,
    required this.onUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(
              Icons.directions_car_rounded,
              size: 52,
              color: colors.tertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Vehículo ya registrado',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'La placa ${asset.assetKey} ya existe en este portafolio '
              'como "${asset.content.displayName}". '
              '¿Qué deseas hacer?',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Ver vehículo
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('VER VEHÍCULO'),
              ),
            ),
            const SizedBox(height: 10),

            // Actualizar información
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onUpdate,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('ACTUALIZAR INFORMACIÓN'),
              ),
            ),
            const SizedBox(height: 8),

            // Cancelar
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
