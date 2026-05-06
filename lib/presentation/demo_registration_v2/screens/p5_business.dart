// ============================================================================
// DEMO REGISTRATION V2 — P5: TU NEGOCIO (TEMPORARY) — Enterprise UI/UX
//
// Captura la identidad del negocio:
//   - Tipo de registro: Persona | Empresa (toggle pill custom estilo iOS)
//   - Persona  → Nombre completo
//   - Empresa  → Razón social + NIT (DV módulo 11 calculado en vivo)
//   - Departamento + Ciudad (pickers compactos conectados al catálogo CO)
//   - Microcopy de privacidad (solo Empresa)
//
// País: NO se pide aquí — viene fijado desde la pantalla anterior del flujo
// (countryCode='CO' en DemoRegistrationState).
//
// Diseño optimizado para que toda la información quepa SIN scroll en pantallas
// de 800dp+ (mobile portrait moderno). Paddings y gaps comprimidos.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../domain/entities/geo/city_entity.dart';
import '../../../domain/entities/geo/region_entity.dart';
import '../../location/controllers/location_controller.dart';
import '../../widgets/wizard/bottom_sheet_selector.dart';
import '../demo_state.dart';
import '../widgets/demo_step_scaffold.dart';

class P5Business extends StatefulWidget {
  final DemoRegistrationState state;
  final VoidCallback onContinue;

  /// Acción "Lo configuraré después". OPCIONAL — si es null, no se renderiza
  /// el link disuasivo. Demo 2 fusionado la pasa null porque la identidad es
  /// commitment obligatorio del paso 4 de 5 (sin nombre/ciudad/NIT no hay
  /// matching downstream ni facturación CO). Demo 1 la pasa para conservar
  /// el escape opcional.
  final VoidCallback? onSkip;

  final VoidCallback onBack;

  /// Override del eyebrow. Default 'Tu negocio'. Pasar `''` (string vacío)
  /// para ocultar el eyebrow completamente. Usado por Demo 2 fusionado.
  final String eyebrow;

  /// Override del título prominente. Default = `_roleLabel(state.role)`.
  /// Demo 2 fusionado pasa un título contextual con el tipo de activo
  /// (ej. "Propietario de vehículos").
  final String? titleOverride;

  /// Override del subtítulo del cuerpo. Default = copy genérico.
  /// Demo 2 fusionado pasa un subtítulo asset-aware.
  final String? subtitleOverride;

  /// Subtítulo FUERTE contextual (ej. "Conductor de vehículo", "Operador de
  /// maquinaria", "Vendedor de productos para vehículos"). Se renderiza
  /// debajo del título con `titleMedium w700 primary` — más prominente que
  /// el subtítulo descriptivo. NULL → no se renderiza.
  ///
  /// Demo 2 fusionado lo computa con `_q4StrongSubtitle` según
  /// rol + sub-rol + mercado/especialidad.
  final String? strongSubtitle;

  /// Total de pasos a mostrar en el indicador "Paso N de M".
  /// Default 5 = Demo 1 legacy. FusionadoFlow pasa 4 (Q5 fue eliminado).
  final int totalSteps;

  /// Texto del botón primario. Default 'Continuar' (Demo 1).
  /// FusionadoFlow pasa 'Ingresar a mi cuenta' porque Q4 es el último paso
  /// y al confirmar dispara directamente el commit + navegación al workspace.
  final String submitLabel;

  /// `true` mientras el commit final está en curso (FusionadoFlow). El botón
  /// se deshabilita y muestra spinner. Sin efecto en Demo 1 (siempre `false`).
  final bool isCommitting;

  const P5Business({
    super.key,
    required this.state,
    required this.onContinue,
    this.onSkip,
    required this.onBack,
    this.eyebrow = 'Tu negocio',
    this.titleOverride,
    this.subtitleOverride,
    this.strongSubtitle,
    this.totalSteps = 5,
    this.submitLabel = 'Continuar',
    this.isCommitting = false,
  });

  @override
  State<P5Business> createState() => _P5BusinessState();
}

class _P5BusinessState extends State<P5Business> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nitCtrl;
  late final LocationController _locationCtrl;

  /// Dirección del slide al cambiar Persona ↔ Empresa.
  ///  +1 → Empresa entra desde la derecha, Persona sale a la derecha
  ///  -1 → Persona entra desde la izquierda, Empresa sale a la izquierda
  /// Se actualiza ANTES del setState en el toggle.
  int _slideDir = 1;

  /// Altura fija reservada para el área de identidad (form Persona/Empresa).
  /// Equivale a la altura del form de Empresa (el más alto: Razón social +
  /// NIT con helper). Persona ocupa solo la parte superior y debajo queda
  /// espacio vacío reservado — esto evita el SALTO VERTICAL al togglear.
  ///
  /// 192dp incluye margen para variaciones de fontFamily/scale entre devices
  /// (line-heights de bodySmall y bodyMedium pueden diferir ±1dp por OS).
  static const double _identityAreaHeight = 192;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.state.fullNameOrCompany);
    _nitCtrl = TextEditingController(text: widget.state.nit);
    _locationCtrl = Get.find<LocationController>();
    // Pre-cargar regiones del país actual.
    if (widget.state.countryCode.isNotEmpty) {
      _locationCtrl.loadRegions(widget.state.countryCode);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nitCtrl.dispose();
    super.dispose();
  }

  bool get _isEmpresa => widget.state.titularType == DemoTitularType.empresa;

  bool get _canContinue {
    final nameOk = _nameCtrl.text.trim().length >= 2;
    final cityOk = widget.state.cityId != null;
    if (!_isEmpresa) return nameOk && cityOk;
    final nitClean = _nitCtrl.text.replaceAll(RegExp(r'\D'), '');
    return nameOk && cityOk && nitClean.length == 9;
  }

  void _submit() {
    if (!_canContinue) return;
    widget.state.update(() {
      widget.state.fullNameOrCompany = _nameCtrl.text.trim();
      if (_isEmpresa) {
        widget.state.nit = _nitCtrl.text.replaceAll(RegExp(r'\D'), '');
      } else {
        widget.state.nit = '';
      }
    });
    widget.onContinue();
  }

  // ── Region picker ────────────────────────────────────────────────────────
  // Patrón fire-and-forget + Obx reactivo (idem RegionSelectorField).
  // NO await sobre loadRegions: el stream `watchRegions` no cierra, así que
  // un await colgaría hasta el timeout de 10s. En su lugar disparamos la
  // carga y dejamos que Obx pinte cuando lleguen los datos.

  Future<void> _openRegionPicker() async {
    _locationCtrl.loadRegions(widget.state.countryCode);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => Obx(() {
        final isLoading = _locationCtrl.isLoadingRegions.value;
        final regions = _locationCtrl.regions;
        if (isLoading && regions.isEmpty) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final items = regions
            .map((r) => SelectorItem<RegionEntity>(value: r, label: r.name))
            .toList();
        final selected = regions.firstWhereOrNull(
          (r) => r.id == widget.state.regionId,
        );
        return BottomSheetSelector<RegionEntity>(
          title: 'Región / Estado',
          items: items,
          selectedValue: selected,
          emptyStateText: 'Sin regiones',
          onSelect: (item) {
            // NO popear el sheet aquí — BottomSheetSelector ya lo hace
            // internamente después de invocar onSelect. Doble pop crashea
            // el flujo demo (saca al usuario al inicio).
            if (!mounted) return;
            setState(() {
              widget.state.regionId = item.value.id;
              widget.state.regionName = item.value.name;
              // Cascada: resetear ciudad al cambiar región.
              widget.state.cityId = null;
              widget.state.city = '';
            });
          },
        );
      }),
    );
  }

  // ── City picker ──────────────────────────────────────────────────────────

  Future<void> _openCityPicker() async {
    final regionId = widget.state.regionId;
    if (regionId == null) return;
    _locationCtrl.loadCities(widget.state.countryCode, regionId);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => Obx(() {
        final isLoading = _locationCtrl.isLoadingCities.value;
        final cities = _locationCtrl.cities;
        if (isLoading && cities.isEmpty) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final items = cities
            .map((c) => SelectorItem<CityEntity>(value: c, label: c.name))
            .toList();
        final selected = cities.firstWhereOrNull(
          (c) => c.id == widget.state.cityId,
        );
        return BottomSheetSelector<CityEntity>(
          title: 'Ciudad',
          items: items,
          selectedValue: selected,
          emptyStateText: 'Sin ciudades',
          onSelect: (item) {
            // BottomSheetSelector hace el pop internamente; no popear aquí.
            if (!mounted) return;
            setState(() {
              widget.state.cityId = item.value.id;
              widget.state.city = item.value.name;
            });
          },
        );
      }),
    );
  }

  /// Label legible del rol seleccionado en P3.
  static String _roleLabel(DemoRoleCode? role) {
    return switch (role) {
      DemoRoleCode.assetAdmin => 'Administrador de activos',
      DemoRoleCode.owner => 'Propietario de activos',
      DemoRoleCode.renter => 'Arrendatario',
      DemoRoleCode.provider => 'Proveedor',
      DemoRoleCode.asesor => 'Asesor comercial',
      DemoRoleCode.insurer => 'Asegurador / Broker',
      DemoRoleCode.broker => 'Gestor de activos',
      DemoRoleCode.legal => 'Abogado / Firma legal',
      null => 'Mi negocio',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DemoStepScaffold(
      currentStep: 3,
      totalSteps: widget.totalSteps,
      eyebrow: widget.eyebrow.isEmpty ? null : widget.eyebrow,
      title: widget.titleOverride ?? _roleLabel(widget.state.role),
      // Strong subtitle como headerExtra → queda PEGADO al título (gap 4px),
      // no nadando en el body con gap 12px del scaffold.
      headerExtra:
          (widget.strongSubtitle != null && widget.strongSubtitle!.isNotEmpty)
              ? Text(
                  widget.strongSubtitle!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
      onBack: widget.onBack,
      primaryAction: FilledButton(
        onPressed: (widget.isCommitting || !_canContinue) ? null : _submit,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: widget.isCommitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(widget.submitLabel),
      ),
      secondaryAction: widget.onSkip == null
          ? null
          : TextButton(
              onPressed: widget.onSkip,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: Text(
                'Lo configuraré después',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Strong subtitle se renderiza vía `headerExtra` del scaffold para
          // quedar pegado al título (gap 4px), no en el body con gap 12px.

          // Subtítulo conditional descriptivo. Solo se renderiza si NO es vacío.
          // fusionado pasa subtitleOverride asset-aware; pasar '' lo oculta.
          if ((widget.subtitleOverride ??
                  'Cuéntanos cómo opera para conectarte con la red de Avanzza.')
              .isNotEmpty) ...[
            Text(
              widget.subtitleOverride ??
                  'Cuéntanos cómo opera para conectarte con la red de Avanzza.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // ── Tipo de registro ─────────────────────────────────────────────
          const _SectionLabel('Tipo de registro'),
          const SizedBox(height: 6),
          _TitularToggle(
            selected: widget.state.titularType,
            onChanged: (v) {
              // Capturar dirección del slide ANTES del rebuild:
              // Persona → Empresa: dir = +1 (Empresa entra desde la derecha)
              // Empresa → Persona: dir = -1 (Persona entra desde la izquierda)
              _slideDir = (v == DemoTitularType.empresa) ? 1 : -1;
              setState(() {
                widget.state.titularType = v;
              });
            },
          ),
          const SizedBox(height: 10),

          // ── Identidad (Persona / Empresa) ────────────────────────────────
          // Altura FIJA reservada para evitar salto vertical al togglear.
          // El form de Empresa es más alto (Razón social + NIT + helper);
          // Persona ocupa solo la parte superior y debajo queda espacio
          // reservado pero invisible.
          //
          // Slide horizontal direccional: cada form entra desde un lado
          // distinto según la dirección capturada en el toggle.
          SizedBox(
            height: _identityAreaHeight,
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) {
                  final beginOffset = Offset(_slideDir.toDouble(), 0);
                  return SlideTransition(
                    position: anim.drive(
                      Tween<Offset>(
                        begin: beginOffset,
                        end: Offset.zero,
                      ),
                    ),
                    child: FadeTransition(opacity: anim, child: child),
                  );
                },
                child: _isEmpresa
                    ? Column(
                        key: const ValueKey('empresa-fields'),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _CompactField(
                            label: 'Razón social',
                            child: TextField(
                              controller: _nameCtrl,
                              textCapitalization: TextCapitalization.words,
                              autofillHints: const [
                                AutofillHints.organizationName
                              ],
                              decoration:
                                  _denseInput(hintText: 'Mi Empresa S.A.S.'),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _CompactField(
                            label: 'NIT',
                            helper: _nitHelperText(_nitCtrl.text),
                            child: TextField(
                              controller: _nitCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              decoration: _denseInput(hintText: '900123456'),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      )
                    : _CompactField(
                        key: const ValueKey('persona-fields'),
                        label: 'Nombre completo',
                        child: TextField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.name],
                          decoration: _denseInput(hintText: 'Juan Pérez'),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Ubicación ────────────────────────────────────────────────────
          const _SectionLabel('Ubicación'),
          const SizedBox(height: 2),
          Text(
            'Selecciona el lugar de tu actividad.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 8),
          _CompactGeoPicker(
            label: 'Región / Estado',
            hint: 'Selecciona una región',
            valueLabel: widget.state.regionName,
            enabled: true,
            onTap: _openRegionPicker,
          ),
          const SizedBox(height: 10),
          _CompactGeoPicker(
            label: 'Ciudad',
            hint: widget.state.regionId == null
                ? 'Selecciona primero una región'
                : 'Selecciona una ciudad',
            valueLabel:
                widget.state.cityId != null ? widget.state.city : null,
            enabled: widget.state.regionId != null,
            onTap: _openCityPicker,
          ),

          // ── Privacidad (solo Empresa) ────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(sizeFactor: anim, child: child),
            ),
            child: _isEmpresa
                ? Padding(
                    key: const ValueKey('privacy-microcopy'),
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Datos cifrados, solo se usan para tu workspace.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('privacy-empty')),
          ),

          // Skip "Lo configuraré después" se renderiza vía `secondaryAction`
          // del scaffold (queda debajo del Continuar, no aquí en el body).
        ],
      ),
    );
  }

  /// Decoración compacta común para los TextField del form.
  /// `isDense: true` reduce la altura del input ~16px sin perder usabilidad.
  InputDecoration _denseInput({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Helper text dinámico del NIT.
  String _nitHelperText(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) return '9 dígitos. El DV se calcula automáticamente.';
    if (clean.length < 9) return '${clean.length} de 9 dígitos.';
    final dv = _NitValidator.calculateDV(clean);
    return dv != null ? 'DV: $dv  →  $clean-$dv' : 'NIT inválido.';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION LABEL — etiqueta de sección compacta (uppercase opcional)
// ════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// COMPACT FIELD — etiqueta arriba + child + helper opcional, gaps tight
// Reduce el espacio vertical sin sacrificar legibilidad.
// ════════════════════════════════════════════════════════════════════════════

class _CompactField extends StatelessWidget {
  final String label;
  final String? helper;
  final Widget child;

  const _CompactField({
    super.key,
    required this.label,
    required this.child,
    this.helper,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        child,
        if (helper != null && helper!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.85),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// COMPACT GEO PICKER — input outlined que abre BottomSheet on tap.
// Mucho más compacto (~52dp) que el RegionSelectorField/CitySelectorField
// estándar (~72dp con ListTile título+subtítulo).
// ════════════════════════════════════════════════════════════════════════════

class _CompactGeoPicker extends StatelessWidget {
  final String label;
  final String hint;
  final String? valueLabel;
  final bool enabled;
  final VoidCallback onTap;

  const _CompactGeoPicker({
    required this.label,
    required this.hint,
    required this.valueLabel,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasValue = valueLabel != null && valueLabel!.isNotEmpty;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          isEmpty: !hasValue,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabled: enabled,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: enabled
                  ? cs.onSurfaceVariant
                  : cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            hasValue ? valueLabel! : '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled ? null : cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TITULAR TOGGLE — selector Persona / Empresa estilo "iOS pill"
// ════════════════════════════════════════════════════════════════════════════

class _TitularToggle extends StatelessWidget {
  final DemoTitularType selected;
  final ValueChanged<DemoTitularType> onChanged;

  const _TitularToggle({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _TitularSegment(
              icon: Icons.person_outline_rounded,
              label: 'Persona',
              isSelected: selected == DemoTitularType.persona,
              onTap: () => onChanged(DemoTitularType.persona),
            ),
          ),
          Expanded(
            child: _TitularSegment(
              icon: Icons.business_rounded,
              label: 'Empresa',
              isSelected: selected == DemoTitularType.empresa,
              onTap: () => onChanged(DemoTitularType.empresa),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitularSegment extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TitularSegment({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? cs.primary : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? cs.primary : cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: cs.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// VALIDADOR NIT — algoritmo módulo 11 (DIAN Colombia)
// ════════════════════════════════════════════════════════════════════════════

class _NitValidator {
  static const _weights = [
    3, 7, 13, 17, 19, 23, 29, 37, 41, 43, 47, 53, 59, 67, 71,
  ];

  /// Calcula el dígito de verificación módulo 11 para un NIT (sin DV).
  /// Retorna null si la entrada no es numérica o excede el largo soportado.
  static int? calculateDV(String digits) {
    if (digits.isEmpty || digits.length > _weights.length) return null;
    if (!RegExp(r'^\d+$').hasMatch(digits)) return null;

    var sum = 0;
    for (var i = 0; i < digits.length; i++) {
      sum += int.parse(digits[digits.length - 1 - i]) * _weights[i];
    }
    final remainder = sum % 11;
    return remainder < 2 ? remainder : 11 - remainder;
  }
}
