// ============================================================================
// lib/presentation/pages/admin/network/provider_form_page.dart
// PROVIDER FORM PAGE — Alta / edición COMPLETA o POR SECCIÓN del proveedor
// ============================================================================
// QUÉ HACE:
//   - Formulario de seis secciones (Datos básicos, Contacto, Ubicación, Tipo
//     y categorías, Cobertura, Observaciones) para crear o editar un proveedor
//     en la red local del workspace.
//   - Reutiliza la infraestructura geo del proyecto (`RegionSelectorField`,
//     `CitySelectorField`) alimentada por `LocationController` + assets
//     `regions_entities_co.v3.json` / `cities_entities_co.v3.json`. Cero
//     duplicación del catálogo.
//   - Reutiliza la taxonomía de categorías producto/servicio compartida con
//     pedidos: `categoriesForSupplier(supplierType)` vía el controller.
//   - Cobertura condicional: toggle "Envíos a todo el país" → oculta selector
//     manual. Cuando está apagado → lista de ciudades con selección múltiple.
//   - Hidratación idempotente en edit mode: `_maybeHydrate()` corre tanto
//     sincrónicamente (si el controller ya cargó) como vía `ever` (si carga
//     después). Resuelve el bug histórico "edición abre formulario vacío"
//     que ocurría cuando el controller terminaba antes de que el State se
//     suscribiera al stream de loading.
//   - Edición por sección: si el binding recibe `section`, la página puede
//     enfatizar esa sección scrolleando hasta ella; persiste la entidad
//     completa (cero divergencia de datos).
//
// QUÉ NO HACE:
//   - NO depende del probe ni de `SaveLocalContactWithProbe`. La persistencia
//     va directa al `LocalContactRepository` vía `ProviderFormController.save`.
//   - NO implementa selector de departamento/ciudad paralelo.
//   - NO crea `LocalOrganization` ni entidad paralela; el proveedor ES un
//     `LocalContact` con `roleLabel='proveedor'`.
//   - NO bloquea el guardado si el perfil no está "completo": la regla de
//     completitud es UX, no contrato de persistencia.
//
// CONTRACT DE NAVEGACIÓN:
//   Get.toNamed(Routes.providerForm) → modo create.
//   Get.toNamed(Routes.providerForm, arguments: {'providerId': '<id>'}) → edit completo.
//   Get.toNamed(Routes.providerForm, arguments: {
//     'providerId': '<id>',
//     'section': ProviderFormSection.location,
//   }) → edit con foco en una sección (scroll + highlight).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../domain/entities/catalog/specialty_entity.dart' show SpecialtyKind;
import '../../../../domain/entities/core_common/provider_branch_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/services/core_common/local_contact_completeness.dart';
import '../../../../routes/app_routes.dart';
import '../../../controllers/admin/network/provider_form_controller.dart';
import '../../../controllers/admin/network/provider_form_section.dart';
import '../../../controllers/provider/specialties/specialties_selection_result.dart';
import '../../../location/controllers/location_controller.dart';
import '../../../shared/widgets/location/city_selector_field.dart';
import '../../../shared/widgets/location/region_selector_field.dart';
import '../../../shared/widgets/phone/phone_field.dart';
import 'widgets/provider_branch_editor_sheet.dart';

class ProviderFormPage extends StatefulWidget {
  const ProviderFormPage({super.key});

  @override
  State<ProviderFormPage> createState() => _ProviderFormPageState();
}

class _ProviderFormPageState extends State<ProviderFormPage> {
  late final ProviderFormController _controller;
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _docIdCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  /// `PhoneField` mantiene su propio TextEditingController — aquí solo
  /// cacheamos el valor canónico que emite para hidratar el `initialValue`
  /// al cambiar de modo/section.
  String? _primaryPhoneInitial;
  String? _secondaryPhoneInitial;

  /// Anchor keys por sección — permiten scroll-to-section cuando el binding
  /// recibe un `focusedSection` desde el detalle.
  final _sectionKeys = <ProviderFormSection, GlobalKey>{
    for (final s in ProviderFormSection.values) s: GlobalKey(),
  };

  /// Flag idempotente: evita re-escribir los TextEditingController cuando el
  /// stream vuelve a emitir (p. ej. si el repo refresca datos mientras el
  /// user ya está escribiendo).
  bool _hydrated = false;

  /// Worker para escuchar el fin de la carga y ejecutar `_maybeHydrate` una
  /// sola vez. Se cancela en dispose.
  Worker? _loadingWorker;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProviderFormController>();
    // 1) Intento sincrónico: si el controller ya cargó (o está en create),
    //    hidratamos inmediatamente.
    _maybeHydrate();
    // 2) Backup async: si aún estaba cargando, esperamos la primera
    //    transición a `!isLoading` y hidratamos.
    _loadingWorker = ever<bool>(_controller.isLoading, (loading) {
      if (!loading) _maybeHydrate();
    });

    // 3) Scroll a sección enfocada (si venimos con argumento `section`).
    final focused = _controller.focusedSection;
    if (focused != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection(focused);
      });
    }
  }

  @override
  void dispose() {
    _loadingWorker?.dispose();
    _nameCtrl.dispose();
    _docIdCtrl.dispose();
    _emailCtrl.dispose();
    _websiteCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  /// Copia los valores `.obs` del controller a los TextEditingController una
  /// sola vez (flag `_hydrated`). Si está en modo edit y aún loading, no
  /// hace nada; el worker lo reintentará cuando termine.
  void _maybeHydrate() {
    if (_hydrated) return;
    if (_controller.mode.value == ProviderFormMode.edit &&
        _controller.isLoading.value) {
      return;
    }
    _nameCtrl.text = _controller.displayName.value;
    _docIdCtrl.text = _controller.docId.value;
    _emailCtrl.text = _controller.primaryEmail.value;
    _websiteCtrl.text = _controller.website.value;
    _addressCtrl.text = _controller.addressLine.value;
    _notesCtrl.text = _controller.notesPrivate.value;
    // PhoneField lee `initialValue` una sola vez — lo pasamos ya hidratado
    // desde el .obs del controller.
    _primaryPhoneInitial = _controller.primaryPhone.value;
    _secondaryPhoneInitial = _controller.secondaryPhone.value;
    _hydrated = true;
    if (mounted) setState(() {});
  }

  void _scrollToSection(ProviderFormSection s) {
    final key = _sectionKeys[s];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      alignment: 0.05,
      curve: Curves.easeOutCubic,
    );
  }

  // ── SUBMIT ──────────────────────────────────────────────────────────────

  /// Orquesta el guardado canónico delegando en `controller.save()`.
  ///
  /// Captura `AmbiguousPlatformActorException` para mostrar snackbar
  /// técnico — Hito 1 NO implementa picker de candidatos (eso aterriza
  /// en Hito 1.5). El log estructurado con `candidates` lo emite el
  /// controller antes de propagar la excepción.
  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final messenger = ScaffoldMessenger.maybeOf(context);

    String? err;
    try {
      err = await _controller.save();
    } on AmbiguousPlatformActorException {
      // El controller ya logueó con candidates. Aquí solo bloqueamos el
      // flujo y NO cerramos el form — el usuario puede modificar datos y
      // reintentar, o cerrar manualmente.
      if (!mounted) return;
      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
            'No pudimos identificar este proveedor de forma única. '
            'Contacta soporte.',
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 6),
        ),
      );
      return;
    }

    if (!mounted) return;
    if (err != null) {
      messenger?.showSnackBar(
        SnackBar(content: Text(err), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    final isCreate = _controller.mode.value == ProviderFormMode.create;
    final complete = _controller.isComplete;
    // Mensaje único separado solo por acción (crear vs editar) y
    // completitud del perfil. El flujo canónico ya persiste specialties
    // en backend (`PUT /v1/providers/:id/specialties`), así que no hay
    // nota de "aún no se guardan".
    final message = isCreate
        ? (complete
            ? 'Proveedor creado con perfil completo.'
            : 'Proveedor creado. Completa su registro cuando quieras.')
        : (complete
            ? 'Proveedor actualizado. Perfil completo.'
            : 'Proveedor actualizado. Aún faltan datos para marcarlo como completo.');
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
    Get.back(result: true);
  }

  // ── BUILD ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Obx(() {
          final focused = _controller.focusedSection;
          if (focused != null &&
              _controller.mode.value == ProviderFormMode.edit) {
            return Text('Editar ${focused.humanLabel.toLowerCase()}');
          }
          return Text(
            _controller.mode.value == ProviderFormMode.create
                ? 'Nuevo proveedor'
                : 'Editar proveedor',
          );
        }),
      ),
      body: Obx(() {
        if (_controller.mode.value == ProviderFormMode.edit &&
            _controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.error.value != null &&
            _controller.mode.value == ProviderFormMode.edit) {
          return _ErrorState(message: _controller.error.value!);
        }
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              _CompletenessBanner(controller: _controller),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KeyedSubtree(
                      key: _sectionKeys[ProviderFormSection.basics],
                      child: _SectionCard(
                        title: ProviderFormSection.basics.humanLabel,
                        child: _buildBasicFields(),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[ProviderFormSection.contact],
                      child: _SectionCard(
                        title: ProviderFormSection.contact.humanLabel,
                        child: _buildContactFields(),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[ProviderFormSection.location],
                      child: _SectionCard(
                        title: ProviderFormSection.location.humanLabel,
                        child: _buildLocationFields(),
                      ),
                    ),
                    // SPECIALTIES — selector multi-select del catálogo global.
                    //
                    // Plan Nivel 2 (2026-04-26): la sección es SIEMPRE visible
                    // bajo el flag, sin condicionar al `assetType`. Dentro de
                    // la sección hay un dropdown autónomo "Tipo de activo"
                    // que el usuario debe elegir antes de poder abrir el
                    // selector de specialties. Esto desacopla el form del
                    // contexto del caller (workspaces multi-assetType ya
                    // funcionan sin pasar `assetType` por args).
                    //
                    // El flag sigue siendo el kill-switch absoluto: si está
                    // OFF, toda la sección desaparece sin tocar el resto del
                    // form (legacy "Tipo y categorías" intacto).
                    if (AppConfig.enableProviderSpecialtiesUI)
                      _SectionCard(
                        title: 'Especialidades',
                        child: _buildSpecialtiesField(theme),
                      ),
                    KeyedSubtree(
                      key: _sectionKeys[ProviderFormSection.coverage],
                      child: _SectionCard(
                        title: ProviderFormSection.coverage.humanLabel,
                        child: _buildCoverageFields(theme),
                      ),
                    ),
                    _SectionCard(
                      title: 'Otras sedes',
                      child: _buildBranchesSection(theme),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[ProviderFormSection.notes],
                      child: _SectionCard(
                        title: ProviderFormSection.notes.humanLabel,
                        child: _buildNotesFields(theme),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Obx(() {
            final saving = _controller.isSaving.value;
            return FilledButton.icon(
              key: const Key('provider_form.save'),
              icon: saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(saving ? 'Guardando…' : 'Guardar proveedor'),
              onPressed: saving ? null : _onSave,
            );
          }),
        ),
      ),
    );
  }

  // ── SECCIONES ───────────────────────────────────────────────────────────

  Widget _buildBasicFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('provider_form.displayName'),
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nombre o razón comercial *',
            hintText: 'Ej. Lubricantes del Caribe',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (v) => _controller.displayName.value = v,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'El nombre es obligatorio.';
            }
            if (v.trim().length < 2) {
              return 'Usa al menos 2 caracteres.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('provider_form.docId'),
          controller: _docIdCtrl,
          decoration: const InputDecoration(
            labelText: 'NIT / Documento (opcional)',
            hintText: 'Ej. 900123456',
            border: OutlineInputBorder(),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z\-\s]')),
          ],
          onChanged: (v) => _controller.docId.value = v,
        ),
      ],
    );
  }

  Widget _buildContactFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PhoneField(
          fieldKey: const Key('provider_form.primaryPhone'),
          initialValue: _primaryPhoneInitial,
          labelText: 'Teléfono principal *',
          required: true,
          showCallAction: false,
          onChanged: (e164) => _controller.primaryPhone.value = e164 ?? '',
        ),
        const SizedBox(height: 12),
        PhoneField(
          fieldKey: const Key('provider_form.secondaryPhone'),
          initialValue: _secondaryPhoneInitial,
          labelText: 'Teléfono alterno (opcional)',
          showImportFromContacts: false,
          showCallAction: false,
          onChanged: (e164) => _controller.secondaryPhone.value = e164 ?? '',
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('provider_form.email'),
          controller: _emailCtrl,
          decoration: const InputDecoration(
            labelText: 'Correo (opcional)',
            hintText: 'Ej. ventas@proveedor.com',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => _controller.primaryEmail.value = v,
          validator: (v) {
            final value = (v ?? '').trim();
            if (value.isEmpty) return null;
            if (!value.contains('@') || !value.contains('.')) {
              return 'Correo con formato inválido.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('provider_form.website'),
          controller: _websiteCtrl,
          decoration: const InputDecoration(
            labelText: 'Sitio web (opcional)',
            hintText: 'Ej. proveedor.com',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
          onChanged: (v) => _controller.website.value = v,
          validator: (v) {
            final value = (v ?? '').trim();
            if (value.isEmpty) return null;
            if (value.contains(' ') || !value.contains('.')) {
              return 'URL con formato inválido.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationFields() {
    return Obx(() {
      final country = _controller.countryId.value;
      final region = _controller.regionId.value;
      final city = _controller.cityId.value;
      // Los tres selectores geo se renderizan con `ListTile` internamente.
      // Envolverlos en un `ListTileTheme` compacto reduce `minVerticalPadding`
      // y la densidad visual para que País → Departamento → Ciudad se vean
      // apilados como un grupo, no como tres tarjetas espaciadas.
      const compactPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 0);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTileTheme.merge(
            dense: true,
            visualDensity: VisualDensity.compact,
            minVerticalPadding: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CountryReadOnlyTile(
                  countryId: country,
                  contentPadding: compactPadding,
                ),
                RegionSelectorField(
                  key: ValueKey('provider_form.region.$country'),
                  countryId: country,
                  initialValue: region,
                  labelText: 'Departamento',
                  contentPadding: compactPadding,
                  onChanged: (r) => _controller.onRegionChanged(r.id),
                ),
                CitySelectorField(
                  key: ValueKey('provider_form.city.$country.$region'),
                  countryId: country,
                  regionId: region,
                  initialValue: city,
                  contentPadding: compactPadding,
                  onChanged: (c) => _controller.onCityChanged(c.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('provider_form.address'),
            controller: _addressCtrl,
            decoration: const InputDecoration(
              labelText: 'Dirección (opcional)',
              hintText: 'Ej. Cra 45 #23-15, local 3',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (v) => _controller.addressLine.value = v,
          ),
        ],
      );
    });
  }

  // ── ESPECIALIDADES ──────────────────────────────────────────────────────

  /// Sección de selección de specialties.
  ///
  /// Layout (Hito 1.x, 2026-04-26):
  ///   1. Selector "Tipo de activo" — alimentado dinámicamente desde
  ///      `GET /v1/core-common/workspaces/me/asset-types` (los assetTypes
  ///      que el workspace activo realmente opera, derivados de
  ///      `AssetActorLink`). Tres estados:
  ///        · loading → spinner inline + label deshabilitado.
  ///        · error    → caja con mensaje + botón "Reintentar".
  ///        · empty    → mensaje "Tu workspace aún no opera activos.
  ///                     Registra uno para asignar especialidades.".
  ///        · con datos → DropdownButtonFormField dinámico.
  ///   2. Tile "N especialidades seleccionadas" / "Seleccionar
  ///      especialidades" con chevron. **Deshabilitado** mientras el
  ///      assetType sea `null`/vacío. Hit area completa.
  ///   3. Helper text de contexto.
  ///
  /// Reactivo: `Obx` lee `assetType`, `specialtyIds`, `availableAssetTypes`,
  /// `availableAssetTypesLoading` y `availableAssetTypesError` para
  /// regenerar el árbol cuando cualquiera cambie.
  ///
  /// El kill-switch `AppConfig.enableProviderSpecialtiesUI` envuelve toda
  /// esta sección en el ListView padre — si está OFF, este método no se
  /// invoca. El legacy "Tipo y categorías" sigue intacto en otra sección.
  Widget _buildSpecialtiesField(ThemeData theme) {
    return Obx(() {
      final at = _controller.assetType.value;
      final assetTypeChosen = at != null && at.isNotEmpty;
      final kind = _controller.offerKind.value;
      final offerKindChosen = kind != null;
      // El tile de Especialidades se habilita SOLO cuando ambos pre-filtros
      // están definidos: tipo de activo y tipo de oferta. Esto evita abrir
      // el catálogo sin contexto y forzar al usuario a navegar 31 ítems
      // mezclados (productos + servicios).
      final canPickSpecialties = assetTypeChosen && offerKindChosen;
      final n = _controller.specialtyIds.length;
      // Tocar el cache de nombres dentro del Obx para que cambios en
      // `specialtyNames` (post-submit del selector) disparen rebuild
      // del subtítulo. El getter `specialtiesSummarySubtitle` los lee
      // pero GetX solo registra suscripción si el `.value`/`.length`
      // se accede DENTRO del closure del Obx.
      _controller.specialtyNames.length;
      final String specialtiesSubtitle;
      if (n > 0) {
        // Resumen compacto Hito 1.x:
        //   1   → "<firstName>"
        //   N>1 → "<firstName> +<N-1>"
        // Si no hay nombres cacheados (caso EDIT antes de abrir el
        // selector), el getter cae al copy genérico "N especialidades
        // seleccionadas".
        specialtiesSubtitle = _controller.specialtiesSummarySubtitle;
      } else if (!assetTypeChosen) {
        specialtiesSubtitle = 'Elige primero un tipo de activo';
      } else if (!offerKindChosen) {
        specialtiesSubtitle = 'Elige primero un tipo de oferta';
      } else {
        // 0 specialties + ambos pre-filtros listos → copy del spec UX.
        specialtiesSubtitle = 'Selecciona una o más especialidades';
      }
      final cs = theme.colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Selector de Tipo de activo (3 estados) ────────────────
          _buildAssetTypeSelector(theme, at),
          const SizedBox(height: 12),
          // ── Tile: Tipo de Oferta (BottomSheet) ────────────────────
          // Deshabilitado hasta que el usuario haya elegido tipo de
          // activo (decisión secuencial). Al cambiar, `setOfferKind`
          // limpia las specialties seleccionadas (regla del controller)
          // para evitar conservar referencias incompatibles con el
          // nuevo filtro.
          _buildOfferKindTile(theme, kind, enabled: assetTypeChosen),
          const SizedBox(height: 12),
          // ── Tile: tap para abrir selector ─────────────────────────
          // Deshabilitado hasta que ambos pre-filtros estén definidos.
          // Visualmente atenuado y sin onTap → no responde a toques.
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('provider_form.specialties.tile'),
              borderRadius: BorderRadius.circular(8),
              onTap: canPickSpecialties ? _onPickSpecialties : null,
              child: Opacity(
                opacity: canPickSpecialties ? 1.0 : 0.4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        color: cs.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Especialidades',
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              specialtiesSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: n == 0
                                    ? theme.hintColor
                                    : cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.hintColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Helper text — explica al usuario por qué se le pide elegir.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Text(
              'Define qué ofrece este proveedor según el catálogo del activo.',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
        ],
      );
    });
  }

  /// Tile que abre el BottomSheet de "Tipo de Oferta".
  ///
  /// 3 opciones (PRODUCT | SERVICE | BOTH) con título + subtítulo.
  /// Cambiar el valor invoca `controller.setOfferKind(...)` que limpia
  /// `specialtyIds` si el kind cambió (single-source-of-truth).
  ///
  /// El tile se deshabilita visualmente cuando [enabled] es false (ej.
  /// el usuario aún no eligió tipo de activo). Sin onTap → no responde.
  Widget _buildOfferKindTile(
    ThemeData theme,
    SpecialtyKind? kind, {
    required bool enabled,
  }) {
    final cs = theme.colorScheme;
    String subtitle;
    if (!enabled) {
      subtitle = 'Elige primero un tipo de activo';
    } else if (kind == null) {
      subtitle = 'Elige el tipo de oferta';
    } else {
      subtitle = _offerKindHumanLabel(kind);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('provider_form.offerKind.tile'),
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? () => _showOfferKindBottomSheet(theme) : null,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.sell_outlined,
                  color: cs.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de oferta *',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: kind == null
                              ? theme.hintColor
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.expand_more_rounded, color: theme.hintColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Copy humano para cada SpecialtyKind. NO se usa en logs ni wire.
  String _offerKindHumanLabel(SpecialtyKind kind) {
    switch (kind) {
      case SpecialtyKind.product:
        return 'Productos';
      case SpecialtyKind.service:
        return 'Servicios';
      case SpecialtyKind.both:
        return 'Productos y servicios';
    }
  }

  /// Subtítulo descriptivo de cada opción del BottomSheet.
  String _offerKindDescription(SpecialtyKind kind) {
    switch (kind) {
      case SpecialtyKind.product:
        return 'Repuestos, lubricantes, llantas, baterías, filtros…';
      case SpecialtyKind.service:
        return 'Mantenimiento, reparaciones, latonería, diagnóstico…';
      case SpecialtyKind.both:
        return 'Ofrece tanto productos como servicios.';
    }
  }

  /// Abre el BottomSheet con las 3 opciones de tipo de oferta. El
  /// elemento elegido se aplica vía `setOfferKind()`, que internamente
  /// limpia `specialtyIds` si cambió el kind (regla de invalidación).
  Future<void> _showOfferKindBottomSheet(ThemeData theme) async {
    final cs = theme.colorScheme;
    final current = _controller.offerKind.value;
    final picked = await showModalBottomSheet<SpecialtyKind>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'Tipo de oferta',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              for (final option in const [
                SpecialtyKind.product,
                SpecialtyKind.service,
                SpecialtyKind.both,
              ])
                ListTile(
                  key: Key('provider_form.offerKind.option.${option.wireName}'),
                  leading: Icon(
                    current == option
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: current == option ? cs.primary : theme.hintColor,
                  ),
                  title: Text(_offerKindHumanLabel(option)),
                  subtitle: Text(_offerKindDescription(option)),
                  onTap: () => Navigator.of(ctx).pop(option),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      _controller.setOfferKind(picked);
    }
  }

  /// Selector de assetType del workspace, con UI distinta para cada estado:
  ///
  /// - **Loading**: contenedor con spinner pequeño + texto. Sin dropdown.
  /// - **Error**: contenedor de error con mensaje y botón "Reintentar"
  ///   que invoca `controller.loadAvailableAssetTypes()`.
  /// - **Empty** (lista vacía y sin error): mensaje informativo en una
  ///   caja con borde — el workspace no opera assetTypes todavía. Sin
  ///   dropdown porque no hay nada que elegir.
  /// - **Datos**: `DropdownButtonFormField` poblado con `availableAssetTypes`.
  ///   `value` solo se setea si el actual `assetType` está presente en la
  ///   lista (evita el assert de Material que rompe cuando el valor no
  ///   pertenece al set de items).
  Widget _buildAssetTypeSelector(ThemeData theme, String? currentAssetType) {
    final cs = theme.colorScheme;
    final loading = _controller.availableAssetTypesLoading.value;
    final loadError = _controller.availableAssetTypesError.value;
    final list = _controller.availableAssetTypes;

    if (loading) {
      return Container(
        key: const Key('provider_form.specialties.assetType.loading'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Cargando tipos de activo…',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    }

    if (loadError != null) {
      return Container(
        key: const Key('provider_form.specialties.assetType.error'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: cs.error.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: cs.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                loadError,
                style: theme.textTheme.bodySmall?.copyWith(color: cs.error),
              ),
            ),
            TextButton(
              onPressed: _controller.loadAvailableAssetTypes,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (list.isEmpty) {
      return Container(
        key: const Key('provider_form.specialties.assetType.empty'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: theme.hintColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tu workspace aún no opera activos. Registra uno para '
                'asignar especialidades.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── Datos: dropdown dinámico ──────────────────────────────────────
    // El backend devuelve la lista ordenada por (parentId NULLS FIRST,
    // name ASC). Respetamos ese orden tal cual.
    //
    // `currentAssetType` puede no estar en la lista (workspace cambió
    // su asset-types y un edit antiguo dejó el id obsoleto). En ese
    // caso pasamos `null` al field para evitar el assert de Material.
    final values = list.map((e) => e.id).toSet();
    final selected = (currentAssetType != null && values.contains(currentAssetType))
        ? currentAssetType
        : null;
    return DropdownButtonFormField<String>(
      key: const Key('provider_form.specialties.assetType'),
      initialValue: selected,
      decoration: InputDecoration(
        labelText: 'Tipo de activo *',
        border: const OutlineInputBorder(),
        isDense: true,
        helperText: selected != null
            ? null
            : 'Requerido para mostrar el catálogo de especialidades.',
        helperStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.hintColor,
        ),
      ),
      items: list
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.id,
              child: Text(e.name),
            ),
          )
          .toList(growable: false),
      onChanged: (value) {
        // `setAssetType` es no-op si el valor coincide. Si cambia,
        // limpia `specialtyIds` y resetea el flag (correcto: las
        // specialties del catálogo previo no aplican a otro tipo
        // de activo). Ver INVARIANT del controller.
        _controller.setAssetType(value);
      },
    );
  }

  /// Abre el selector y aplica el resultado al controller.
  ///
  /// Reglas (ver prompt del flujo):
  ///   - Si `result == null` (usuario salió sin guardar) → NO modificar
  ///     estado del form. Es la regla "cancelar = no cambiar nada".
  ///   - Si `result != null` → reemplazo TOTAL del set vía
  ///     `applySelectedSpecialties()` (NO merge parcial).
  ///   - El selector recibe el set actual como `initialSelection` para
  ///     que el usuario vea su elección previa pre-marcada.
  Future<void> _onPickSpecialties() async {
    final at = _controller.assetType.value;
    if (at == null || at.isEmpty) return; // defensivo: no debería ocurrir.
    // NOTA: usamos `Get.toNamed` SIN parámetro genérico y casteamos el
    // `dynamic` resultante. `Get.toNamed<T>(...)` revienta con
    //   _TypeError: 'GetPageRoute<dynamic>' is not a subtype of
    //   'Route<T?>?'
    // por un bug de GetX 4.6.x al construir el `Route<T?>` interno con
    // tipos genéricos no triviales. El cast posterior preserva tipo y es
    // null-safe contra cancelación (Get.back() sin result → null).
    //
    // Args que viajan al binding del selector:
    //   - assetType: contexto del catálogo (vehicle.car, etc.).
    //   - initialSelection: rehidratar la selección previa.
    //   - initialKind: pre-filtro single-source-of-truth desde el form.
    //     El selector lo aplica al primer fetch y NO permite cambiarlo
    //     dentro (toggle interno eliminado).
    //   - providerName: copy del AppBar para dar contexto.
    //
    // Si `offerKind` es null aquí, sería un bug del gating del tile;
    // defendemos con assert + fallback null al backend.
    final kind = _controller.offerKind.value;
    assert(
      kind != null,
      '_onPickSpecialties invocado sin offerKind — el gating del tile '
      'falló. Revisar `canPickSpecialties` en _buildSpecialtiesField.',
    );
    final raw = await Get.toNamed(
      Routes.selectSpecialties,
      arguments: <String, dynamic>{
        'assetType': at,
        'initialSelection': _controller.specialtyIds.toSet(),
        if (kind != null) 'initialKind': kind.wireName,
        'providerName': _controller.displayName.value,
      },
    );
    // Resultado canónico del selector: `SpecialtiesSelectionResult`
    // (Hito 1.x — UX). Lleva ids + (id, name) details para que el
    // form construya el subtítulo compacto sin re-consultar catálogo.
    if (raw is SpecialtiesSelectionResult) {
      _controller.applySelectedSpecialtiesWithNames(
        raw.ids,
        raw.namesById(),
      );
    }
  }

  Widget _buildCoverageFields(ThemeData theme) {
    return Obx(() {
      final all = _controller.coverageAllCountry.value;
      final country = _controller.countryId.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile.adaptive(
            key: const Key('provider_form.coverage.allCountry'),
            contentPadding: EdgeInsets.zero,
            title: const Text('Envíos a todo el país'),
            subtitle: Text(
              all
                  ? 'Entrega/servicio disponible en todo el territorio nacional.'
                  : 'Selecciona ciudades específicas para acotar la cobertura.',
              style: theme.textTheme.bodySmall,
            ),
            value: all,
            onChanged: _controller.setCoverageAllCountry,
          ),
          if (!all) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const Key('provider_form.coverage.add'),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Agregar ciudad de cobertura'),
              onPressed: (country == null || country.isEmpty)
                  ? null
                  : () => _showCoveragePicker(country),
            ),
            const SizedBox(height: 8),
            _CoverageChips(controller: _controller),
          ],
        ],
      );
    });
  }

  Future<void> _showCoveragePicker(String countryId) async {
    String? pickedCityId;
    await Get.bottomSheet<void>(
      _CoverageBottomSheet(
        countryId: countryId,
        onCityPicked: (c) {
          pickedCityId = c;
        },
      ),
      isScrollControlled: true,
    );
    if (pickedCityId != null && pickedCityId!.isNotEmpty) {
      final added = _controller.addCoverageCity(pickedCityId!);
      if (!mounted) return;
      if (!added) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('Esa ciudad ya estaba en la cobertura.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildBranchesSection(ThemeData theme) {
    return Obx(() {
      final branches = _controller.additionalBranches;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Aquí aparecen las sedes adicionales del proveedor. La sede '
            'principal ya vive en la sección "Ubicación" de arriba.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 12),
          if (branches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Este proveedor opera solo desde la sede principal.',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            )
          else
            Column(
              children: [
                for (final b in branches)
                  _BranchTile(
                    branch: b,
                    onEdit: () => _onEditBranch(b),
                    onDelete: () => _onDeleteBranch(b),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('provider_form.branches.add'),
            icon: const Icon(Icons.add_business_outlined),
            label: const Text('Agregar sede'),
            onPressed: _onAddBranch,
          ),
        ],
      );
    });
  }

  Future<void> _onAddBranch() async {
    final newBranch = await showProviderBranchEditorSheet(
      context,
      defaultCountryId: _controller.countryId.value ?? '',
    );
    if (newBranch != null) {
      _controller.upsertBranch(newBranch);
    }
  }

  Future<void> _onEditBranch(ProviderBranchEntity b) async {
    final updated = await showProviderBranchEditorSheet(
      context,
      initial: b,
      defaultCountryId: _controller.countryId.value ?? '',
    );
    if (updated != null) {
      _controller.upsertBranch(updated);
    }
  }

  Future<void> _onDeleteBranch(ProviderBranchEntity b) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar sede'),
        content: Text(
          '¿Eliminar "${b.label ?? 'esta sede'}"? Esta acción se aplica al '
          'guardar el proveedor.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _controller.removeBranch(b.id);
    }
  }

  Widget _buildNotesFields(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('provider_form.notes'),
          controller: _notesCtrl,
          decoration: const InputDecoration(
            labelText: 'Notas privadas (no se comparten)',
            hintText: 'Ej. mejor trato los lunes, pedir factura...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (v) => _controller.notesPrivate.value = v,
        ),
        const SizedBox(height: 8),
        Text(
          'Las notas privadas viven solo en este dispositivo y no se sincronizan.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SUB-WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletenessBanner extends StatelessWidget {
  final ProviderFormController controller;
  const _CompletenessBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Obx(() {
      // Evaluamos la regla de completitud LOCALMENTE leyendo SOLO los 4 Rx
      // canónicos. NO llamar `controller.missingFields` aquí: ese getter
      // ejecuta `buildEntitySnapshot()` que internamente lee ~16 Rx (todos
      // los campos del form). GetX suscribe este Obx a cada `.value`
      // leído, así que pasar por el snapshot suscribe el banner a tooodo
      // el estado del form y dispara rebuilds en cascada con cada
      // keystroke — degradando la UX hasta volver el form inusable. La
      // regla canónica vive en `local_contact_completeness.dart`; aquí
      // replicamos los 4 chequeos contra los Rx raw para mantener al
      // banner desacoplado del resto del estado.
      final missing = <String>[];
      if (controller.displayName.value.trim().isEmpty) {
        missing.add(ProviderProfileField.displayName);
      }
      if (controller.primaryPhone.value.trim().isEmpty) {
        missing.add(ProviderProfileField.primaryPhoneE164);
      }
      if ((controller.regionId.value ?? '').trim().isEmpty) {
        missing.add(ProviderProfileField.regionId);
      }
      if ((controller.cityId.value ?? '').trim().isEmpty) {
        missing.add(ProviderProfileField.cityId);
      }
      if (missing.isEmpty) {
        // Perfil completo: banner neutro, sin ruido.
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_rounded, color: cs.onPrimaryContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Perfil del proveedor completo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.tertiaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, color: cs.onTertiaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completa el registro',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.onTertiaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Faltan: ${missing.map(providerProfileFieldHumanLabel).join(', ')}.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onTertiaryContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _BranchTile extends StatelessWidget {
  final ProviderBranchEntity branch;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _BranchTile({
    required this.branch,
    required this.onEdit,
    required this.onDelete,
  });

  String _title() {
    final l = branch.label?.trim();
    if (l != null && l.isNotEmpty) return l;
    final city = branch.cityId;
    if (city != null && city.isNotEmpty) {
      // Intentamos resolver nombre de ciudad desde el cache del
      // LocationController; si no está en cache, mostramos un label
      // genérico. El form siempre carga el LocationController porque
      // los selectores geo lo hidratan al montar la sección Ubicación.
      try {
        final loc = Get.find<LocationController>();
        final match =
            loc.cities.where((c) => c.id == city).toList(growable: false);
        if (match.isNotEmpty) return 'Sede en ${match.first.name}';
      } catch (_) {}
    }
    return 'Sede sin nombre';
  }

  String? _subtitle() {
    final parts = <String>[];
    final addr = branch.addressLine?.trim();
    if (addr != null && addr.isNotEmpty) parts.add(addr);
    if ((branch.phoneE164 ?? '').isNotEmpty) parts.add(branch.phoneE164!);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final subtitle = _subtitle();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        leading: Icon(Icons.store_outlined, color: cs.primary),
        title: Text(_title()),
        subtitle: subtitle == null ? null : Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: Key('provider_form.branch.edit.${branch.id}'),
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'Editar sede',
              onPressed: onEdit,
            ),
            IconButton(
              key: Key('provider_form.branch.delete.${branch.id}'),
              icon: Icon(Icons.delete_outline, size: 20, color: cs.error),
              tooltip: 'Eliminar sede',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryReadOnlyTile extends StatelessWidget {
  final String? countryId;
  final EdgeInsetsGeometry? contentPadding;
  const _CountryReadOnlyTile({
    required this.countryId,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      title: const Text('País'),
      subtitle: Text(
        (countryId == null || countryId!.isEmpty)
            ? 'No definido'
            : _humanCountry(countryId!),
        style: TextStyle(color: theme.hintColor),
      ),
      trailing: const Icon(Icons.lock_outline_rounded, size: 18),
    );
  }

  String _humanCountry(String id) {
    switch (id.toLowerCase()) {
      case 'col':
        return 'Colombia';
      case 'pan':
        return 'Panamá';
      case 'mex':
        return 'México';
      default:
        return id.toUpperCase();
    }
  }
}

class _CoverageChips extends StatelessWidget {
  final ProviderFormController controller;
  const _CoverageChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.coverageCityIds;
      if (list.isEmpty) {
        final theme = Theme.of(context);
        return Text(
          'Sin ciudades de cobertura adicionales.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        );
      }
      return Wrap(
        spacing: 8,
        runSpacing: 4,
        children: list
            .map(
              (cityId) => InputChip(
                key: Key('provider_form.coverage.$cityId'),
                avatar: const Icon(Icons.location_city_outlined, size: 18),
                label: Text(_labelFor(cityId)),
                onDeleted: () => controller.removeCoverageCity(cityId),
              ),
            )
            .toList(),
      );
    });
  }

  String _labelFor(String cityId) {
    try {
      final loc = Get.find<LocationController>();
      final match =
          loc.cities.where((c) => c.id == cityId).toList(growable: false);
      if (match.isNotEmpty) return match.first.name;
    } catch (_) {}
    return cityId;
  }
}

class _CoverageBottomSheet extends StatefulWidget {
  final String countryId;
  final ValueChanged<String> onCityPicked;
  const _CoverageBottomSheet({
    required this.countryId,
    required this.onCityPicked,
  });

  @override
  State<_CoverageBottomSheet> createState() => _CoverageBottomSheetState();
}

class _CoverageBottomSheetState extends State<_CoverageBottomSheet> {
  String? _regionId;
  String? _cityId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 4, bottom: 12),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Agregar ciudad de cobertura',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          RegionSelectorField(
            countryId: widget.countryId,
            initialValue: _regionId,
            labelText: 'Departamento',
            onChanged: (r) {
              setState(() {
                _regionId = r.id;
                _cityId = null;
              });
            },
          ),
          CitySelectorField(
            countryId: widget.countryId,
            regionId: _regionId,
            initialValue: _cityId,
            onChanged: (c) {
              setState(() => _cityId = c.id);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: (_cityId == null || _cityId!.isEmpty)
                      ? null
                      : () {
                          widget.onCityPicked(_cityId!);
                          Navigator.of(context).pop();
                        },
                  child: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 56, color: cs.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
