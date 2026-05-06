// ============================================================================
// DEMO REGISTRATION V2 — P6: ASSET REGISTER (Owner / Admin) — TEMPORARY
//
// Pantalla de configuración para Owner/Admin: registra el primer activo.
// Vehículo destacado con autofill RUNT mock + fallback "no tengo placa".
// Otros tipos: form simple inline.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../demo_state.dart';
import '../widgets/demo_step_scaffold.dart';

/// Tipos de documento aceptados en Colombia para el demo.
enum _DocType {
  cc('CC', 'Cédula de ciudadanía'),
  nit('NIT', 'NIT'),
  ce('CE', 'Cédula de extranjería'),
  ppt('PPT', 'Permiso por Protección Temporal'),
  pas('PAS', 'Pasaporte'),
  rc('RC', 'Registro civil'),
  ti('TI', 'Tarjeta de identidad');

  final String code;
  final String label;
  const _DocType(this.code, this.label);
}

/// Tipos de maquinaria. `otra` activa un campo de texto libre ("¿Cuál?").
/// Selección curada para v1: sectores con alto ticket + alquiler frecuente.
/// (Eliminados Textil/Agrícola/Industrial — ver memoria de decisiones.)
///
/// Sobre los iconos:
/// - Logística usa `inventory_2_rounded` (cajas apiladas) — NO un camión:
///   los camiones son vehículos, no maquinaria. Usar un icono de transporte
///   acá confunde al usuario sobre dónde registrar su camión.
enum _MaquinariaType {
  construccion('construccion', 'Construcción', Icons.construction_rounded),
  logistica('logistica', 'Logística / Carga', Icons.inventory_2_rounded),
  generadores('generadores', 'Generadores eléctricos', Icons.bolt_rounded),
  refrigeracion(
    'refrigeracion',
    'Refrigeración industrial',
    Icons.ac_unit_rounded,
  ),
  compresion(
    'compresion',
    'Compresión industrial',
    Icons.compress_rounded,
  ),
  otra('otra', 'Otra', Icons.more_horiz_rounded);

  final String code;
  final String label;
  final IconData icon;
  const _MaquinariaType(this.code, this.label, this.icon);
}

/// Tipos de equipo. `otra` activa un campo de texto libre ("¿Cuál?").
/// Selección curada para mix de alta frecuencia (audiovisual, seguridad)
/// + tickets recurrentes (climatización, refrigeración, tecnología).
///
/// Sobre "Equipos de construcción":
/// - Es OBRA MENOR / HERRAMIENTAS PORTÁTILES (mezcladoras pequeñas, andamios,
///   cerchas, gatos hidráulicos, etc.).
/// - Distinto de Maquinaria → Construcción que captura equipo PESADO
///   (excavadoras, mixers grandes, grúas).
/// - Por eso usa `hardware_rounded` (martillo/clavos = herramienta de mano)
///   vs `construction_rounded` que ya usa Maquinaria.
enum _EquipoType {
  climatizacion('climatizacion', 'Climatización', Icons.air_rounded),
  seguridadElectronica(
    'seguridad_electronica',
    'Seguridad electrónica',
    Icons.security_rounded,
  ),
  tecnologia('tecnologia', 'Tecnología', Icons.computer_rounded),
  refrigeracion(
    'refrigeracion',
    'Refrigeración (Hogar / Comercial)',
    Icons.kitchen_rounded,
  ),
  equiposConstruccion(
    'equipos_construccion',
    'Equipos de construcción',
    Icons.hardware_rounded,
  ),
  audiovisual(
    'audiovisual',
    'Audiovisual / Producción',
    Icons.videocam_rounded,
  ),
  otra('otra', 'Otra', Icons.more_horiz_rounded);

  final String code;
  final String label;
  final IconData icon;
  const _EquipoType(this.code, this.label, this.icon);
}

/// Tipos de inmueble. `otros` activa un campo de texto libre ("¿Cuál?").
/// Orden: unidades (casa, apartamento) → estructuras completas (edificio,
/// conjunto residencial) → terreno (lote) → escape (otros).
enum _InmuebleType {
  casa('casa', 'Casa', Icons.home_rounded),
  apartamento('apartamento', 'Apartamento', Icons.apartment_rounded),
  edificio('edificio', 'Edificio', Icons.corporate_fare_rounded),
  conjuntoResidencial(
    'conjunto_residencial',
    'Conjunto residencial',
    Icons.location_city_rounded,
  ),
  lote('lote', 'Lote', Icons.landscape_rounded),
  otros('otros', 'Otros', Icons.more_horiz_rounded);

  final String code;
  final String label;
  final IconData icon;
  const _InmuebleType(this.code, this.label, this.icon);
}

class P6AssetRegister extends StatefulWidget {
  final DemoRegistrationState state;
  final VoidCallback onComplete;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const P6AssetRegister({
    super.key,
    required this.state,
    required this.onComplete,
    required this.onSkip,
    required this.onBack,
  });

  @override
  State<P6AssetRegister> createState() => _P6AssetRegisterState();
}

class _P6AssetRegisterState extends State<P6AssetRegister> {
  DemoAssetType? _selected;
  final _formData = <String, String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DemoStepScaffold(
      currentStep: 4,
      totalSteps: 5,
      eyebrow: _roleLabel(widget.state.role),
      title: 'Tu primer activo',
      onBack: widget.onBack,
      // Cada form trae su propio botón Continuar inline; sin botón global.
      primaryAction: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Qué tipo de activo quieres registrar?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // ── Card destacada: Vehículo ─────────────────────────────────────
          _AssetTypeCard(
            type: DemoAssetType.vehiculo,
            icon: Icons.directions_car_rounded,
            label: 'Vehículo',
            tagline: 'Solo la placa. Autocompletamos desde RUNT.',
            featured: true,
            selected: _selected == DemoAssetType.vehiculo,
            onTap: () => _selectType(DemoAssetType.vehiculo),
            expandedChild: _formFor(DemoAssetType.vehiculo),
          ),

          const SizedBox(height: 10),

          // ── Cards compactas: resto de tipos ──────────────────────────────
          _AssetTypeCard(
            type: DemoAssetType.inmueble,
            icon: Icons.home_work_rounded,
            label: 'Inmueble',
            tagline: 'Casa, apartamento o lote',
            selected: _selected == DemoAssetType.inmueble,
            onTap: () => _selectType(DemoAssetType.inmueble),
            expandedChild: _formFor(DemoAssetType.inmueble),
          ),
          const SizedBox(height: 10),
          _AssetTypeCard(
            type: DemoAssetType.maquinaria,
            icon: Icons.precision_manufacturing_rounded,
            label: 'Maquinaria',
            tagline: 'Maquinaria pesada o industrial',
            selected: _selected == DemoAssetType.maquinaria,
            onTap: () => _selectType(DemoAssetType.maquinaria),
            expandedChild: _formFor(DemoAssetType.maquinaria),
          ),
          const SizedBox(height: 10),
          _AssetTypeCard(
            type: DemoAssetType.equipo,
            icon: Icons.handyman_rounded,
            label: 'Equipo',
            tagline: 'Herramientas, equipos electrónicos',
            selected: _selected == DemoAssetType.equipo,
            onTap: () => _selectType(DemoAssetType.equipo),
            expandedChild: _formFor(DemoAssetType.equipo),
          ),
          const SizedBox(height: 10),
          _AssetTypeCard(
            type: DemoAssetType.otro,
            icon: Icons.category_rounded,
            label: 'Otro',
            tagline: 'Cualquier otro activo',
            selected: _selected == DemoAssetType.otro,
            onTap: () => _selectType(DemoAssetType.otro),
            expandedChild: _formFor(DemoAssetType.otro),
          ),

          const SizedBox(height: 24),

          // ── Skip disuasivo ───────────────────────────────────────────────
          Center(
            child: TextButton(
              onPressed: widget.onSkip,
              child: Text(
                'Saltar (mi espacio de trabajo estará vacío)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectType(DemoAssetType t) {
    setState(() {
      // Tap sobre la card seleccionada → colapsar.
      if (_selected == t) {
        _selected = null;
      } else {
        _selected = t;
      }
      _formData.clear();
    });
  }

  /// Label legible del rol seleccionado en P3, usado como eyebrow.
  /// Solo Owner / Admin llegan a esta pantalla.
  static String _roleLabel(DemoRoleCode? role) {
    return switch (role) {
      DemoRoleCode.assetAdmin => 'Administrador de activos',
      DemoRoleCode.owner => 'Propietario de activos',
      _ => 'Mi negocio',
    };
  }

  /// Devuelve el form correspondiente al tipo. Solo se renderiza cuando la card
  /// está seleccionada (decisión que toma `_AssetTypeCard` vía AnimatedSize).
  /// Cada form trae su propio botón Continuar inline; el padre conecta el
  /// callback a `_confirm()` para avanzar al siguiente paso.
  Widget _formFor(DemoAssetType type) {
    return _AssetForm(
      type: type,
      initial: _formData,
      onChanged: (data, _) {
        _formData
          ..clear()
          ..addAll(data);
      },
      onContinue: _confirm,
    );
  }

  void _confirm() {
    widget.state.update(() {
      widget.state.assetType = _selected;
      widget.state.assetData
        ..clear()
        ..addAll(_formData);
      widget.state.configCompleted = true;
      widget.state.configSkipped = false;
    });
    widget.onComplete();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CARD DE TIPO DE ACTIVO
// ════════════════════════════════════════════════════════════════════════════

class _AssetTypeCard extends StatelessWidget {
  final DemoAssetType type;
  final IconData icon;
  final String label;
  final String tagline;
  final bool selected;
  final bool featured;
  final VoidCallback onTap;

  /// Form que se renderiza inline debajo del header de la card cuando está
  /// seleccionada. Auto-colapsa con animación cuando otra card se abre.
  final Widget? expandedChild;

  const _AssetTypeCard({
    required this.type,
    required this.icon,
    required this.label,
    required this.tagline,
    required this.selected,
    required this.onTap,
    this.featured = false,
    this.expandedChild,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bgColor = selected
        ? cs.primaryContainer.withValues(alpha: 0.5)
        : (featured
            ? cs.primary.withValues(alpha: 0.06)
            : cs.surfaceContainerHighest.withValues(alpha: 0.4));
    final padding = featured ? 16.0 : 12.0;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? cs.primary
                : (featured
                    ? cs.primary.withValues(alpha: 0.4)
                    : Colors.transparent),
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header tappable ─────────────────────────────────────────
              InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    children: [
                      Container(
                        width: featured ? 52 : 44,
                        height: featured ? 52 : 44,
                        decoration: BoxDecoration(
                          color: selected
                              ? cs.primary.withValues(alpha: 0.15)
                              : cs.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: selected || featured
                              ? cs.primary
                              : cs.onSurfaceVariant,
                          size: featured ? 28 : 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  label,
                                  style: (featured
                                          ? theme.textTheme.titleMedium
                                          : theme.textTheme.titleSmall)
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                if (featured) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'RÁPIDO',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: cs.onPrimary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              tagline,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chevron animado: rota cuando está expandido.
                      AnimatedRotation(
                        turns: selected ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: selected
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Form expandible inline ──────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOut,
                child: (selected && expandedChild != null)
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          0,
                          padding,
                          padding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Divider(
                              color: cs.outlineVariant.withValues(alpha: 0.6),
                              height: 1,
                            ),
                            const SizedBox(height: 14),
                            expandedChild!,
                          ],
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// FORMS POR TIPO
// ════════════════════════════════════════════════════════════════════════════

class _AssetForm extends StatelessWidget {
  final DemoAssetType type;
  final Map<String, String> initial;
  final void Function(Map<String, String> data, bool valid) onChanged;

  /// Disparado por el botón Continuar inline de cada form.
  /// El padre lo conecta a `_confirm()` para avanzar al siguiente paso.
  final VoidCallback onContinue;

  const _AssetForm({
    required this.type,
    required this.initial,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      DemoAssetType.vehiculo => _VehicleForm(
          initial: initial,
          onChanged: onChanged,
          onContinue: onContinue,
        ),
      DemoAssetType.inmueble => InmuebleForm(
          initial: initial,
          onChanged: onChanged,
          onContinue: onContinue,
        ),
      DemoAssetType.maquinaria => MaquinariaForm(
          initial: initial,
          onChanged: onChanged,
          onContinue: onContinue,
        ),
      DemoAssetType.equipo => EquipoForm(
          initial: initial,
          onChanged: onChanged,
          onContinue: onContinue,
        ),
      DemoAssetType.otro => _GenericForm(
          initial: initial,
          onChanged: onChanged,
          onContinue: onContinue,
          fields: const [
            _FormFieldDef(
              key: 'descripcion',
              label: 'Descripción del activo',
              hint: 'Describe brevemente el activo',
              multiline: true,
            ),
          ],
        ),
    };
  }
}

// ── Form genérico (inmueble/maquinaria/equipo/otro) ──────────────────────────

class _FormFieldDef {
  final String key;
  final String label;
  final String? hint;
  final bool multiline;
  const _FormFieldDef({
    required this.key,
    required this.label,
    this.hint,
    this.multiline = false,
  });
}

class _GenericForm extends StatefulWidget {
  final Map<String, String> initial;
  final List<_FormFieldDef> fields;
  final void Function(Map<String, String> data, bool valid) onChanged;
  final VoidCallback onContinue;

  const _GenericForm({
    required this.initial,
    required this.fields,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  State<_GenericForm> createState() => _GenericFormState();
}

class _GenericFormState extends State<_GenericForm> {
  late final Map<String, TextEditingController> _ctrls;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _ctrls = {
      for (final f in widget.fields)
        f.key: TextEditingController(text: widget.initial[f.key] ?? ''),
    };
    for (final c in _ctrls.values) {
      c.addListener(_emit);
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final data = {for (final e in _ctrls.entries) e.key: e.value.text.trim()};
    final valid = data.values.every((v) => v.length >= 2);
    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
    widget.onChanged(data, valid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final f in widget.fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: _ctrls[f.key],
              maxLines: f.multiline ? 3 : 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: f.label,
                hintText: f.hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

        // ── Botón Continuar inline ───────────────────────────────────────
        const SizedBox(height: 4),
        FilledButton(
          onPressed: _isValid ? widget.onContinue : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}

// ── Form de maquinaria: tipo (BottomSheet) + nombre + marca + modelo + serial
// El tipo abre un picker de categorías cerradas (Construcción, Textil…) con
// escape "Otra" que despliega un campo "¿Cuál?" inline (mismo patrón que
// Inmueble).
// ────────────────────────────────────────────────────────────────────────────

class MaquinariaForm extends StatefulWidget {
  final Map<String, String> initial;
  final void Function(Map<String, String> data, bool valid) onChanged;
  final VoidCallback onContinue;

  const MaquinariaForm({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  State<MaquinariaForm> createState() => _MaquinariaFormState();
}

class _MaquinariaFormState extends State<MaquinariaForm> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _marcaCtrl;
  late final TextEditingController _modeloCtrl;
  late final TextEditingController _serialCtrl;
  late final TextEditingController _otroTipoCtrl;
  _MaquinariaType? _tipo;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl =
        TextEditingController(text: widget.initial['nombre'] ?? '');
    _marcaCtrl = TextEditingController(text: widget.initial['marca'] ?? '');
    _modeloCtrl =
        TextEditingController(text: widget.initial['modelo'] ?? '');
    _serialCtrl =
        TextEditingController(text: widget.initial['serial'] ?? '');
    _otroTipoCtrl = TextEditingController(
      text: widget.initial['tipoMaquinariaOtro'] ?? '',
    );

    final initialTipo = widget.initial['tipoMaquinaria'];
    if (initialTipo != null && initialTipo.isNotEmpty) {
      _tipo = _MaquinariaType.values.firstWhere(
        (e) => e.code == initialTipo,
        orElse: () => _MaquinariaType.construccion,
      );
    }

    _nombreCtrl.addListener(_emit);
    _marcaCtrl.addListener(_emit);
    _modeloCtrl.addListener(_emit);
    _serialCtrl.addListener(_emit);
    _otroTipoCtrl.addListener(_emit);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _serialCtrl.dispose();
    _otroTipoCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    final data = {
      'tipoMaquinaria': _tipo?.code ?? '',
      'tipoMaquinariaLabel': _tipo?.label ?? '',
      'tipoMaquinariaOtro':
          _tipo == _MaquinariaType.otra ? _otroTipoCtrl.text.trim() : '',
      'nombre': _nombreCtrl.text.trim(),
      'marca': _marcaCtrl.text.trim(),
      'modelo': _modeloCtrl.text.trim(),
      'serial': _serialCtrl.text.trim(),
    };
    final valid = _isValid(data);
    if (valid != _canContinue) {
      setState(() => _canContinue = valid);
    }
    widget.onChanged(data, valid);
  }

  bool _isValid(Map<String, String> data) {
    if (data['tipoMaquinaria']!.isEmpty) return false;
    if (data['tipoMaquinaria'] == 'otra' &&
        data['tipoMaquinariaOtro']!.length < 2) {
      return false;
    }
    if (data['nombre']!.length < 2) return false;
    if (data['marca']!.length < 2) return false;
    if (data['modelo']!.length < 2) return false;
    if (data['serial']!.length < 2) return false;
    return true;
  }

  Future<void> _pickTipo() async {
    final picked = await showModalBottomSheet<_MaquinariaType>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _MaquinariaTypePickerSheet(selected: _tipo),
    );
    if (picked != null && mounted) {
      setState(() => _tipo = picked);
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final showOtroField = _tipo == _MaquinariaType.otra;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Tipo de maquinaria (BottomSheet) ─────────────────────────────
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _pickTipo,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Tipo de maquinaria',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            child: Row(
              children: [
                if (_tipo != null) ...[
                  Icon(_tipo!.icon, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  _tipo?.label ?? 'Selecciona…',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color:
                        _tipo == null ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── "¿Cuál?" inline cuando elige Otra ────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: showOtroField
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _otroTipoCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: '¿Cuál?',
                      hintText: 'Describe el tipo de maquinaria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),

        const SizedBox(height: 12),

        // ── Nombre ───────────────────────────────────────────────────────
        TextField(
          controller: _nombreCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Nombre de la maquinaria',
            hintText: 'Retroexcavadora, cargador, grúa…',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Marca ────────────────────────────────────────────────────────
        TextField(
          controller: _marcaCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Marca',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Modelo ───────────────────────────────────────────────────────
        TextField(
          controller: _modeloCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Modelo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Serial ───────────────────────────────────────────────────────
        TextField(
          controller: _serialCtrl,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Serial / N° identificación',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Botón Continuar inline ───────────────────────────────────────
        FilledButton(
          onPressed: _canContinue ? widget.onContinue : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}

// ── BottomSheet selector de tipo de maquinaria ──────────────────────────────

class _MaquinariaTypePickerSheet extends StatelessWidget {
  final _MaquinariaType? selected;
  const _MaquinariaTypePickerSheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Tipo de maquinaria',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                shrinkWrap: true,
                itemCount: _MaquinariaType.values.length,
                itemBuilder: (ctx, i) {
                  final t = _MaquinariaType.values[i];
                  final isSelected = t == selected;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary.withValues(alpha: 0.15)
                            : cs.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        t.icon,
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      t.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form de equipo: tipo (BottomSheet) + nombre + marca/modelo/serial opc. ──
// Mismo patrón que Maquinaria. Marca/Modelo/Serial son opcionales porque un
// andamio o una hidrolavadora no siempre tienen serial/modelo registrable.
// ────────────────────────────────────────────────────────────────────────────

class EquipoForm extends StatefulWidget {
  final Map<String, String> initial;
  final void Function(Map<String, String> data, bool valid) onChanged;
  final VoidCallback onContinue;

  const EquipoForm({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  State<EquipoForm> createState() => _EquipoFormState();
}

class _EquipoFormState extends State<EquipoForm> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _marcaCtrl;
  late final TextEditingController _modeloCtrl;
  late final TextEditingController _serialCtrl;
  late final TextEditingController _otroTipoCtrl;
  _EquipoType? _tipo;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl =
        TextEditingController(text: widget.initial['nombre'] ?? '');
    _marcaCtrl = TextEditingController(text: widget.initial['marca'] ?? '');
    _modeloCtrl =
        TextEditingController(text: widget.initial['modelo'] ?? '');
    _serialCtrl =
        TextEditingController(text: widget.initial['serial'] ?? '');
    _otroTipoCtrl = TextEditingController(
      text: widget.initial['tipoEquipoOtro'] ?? '',
    );

    final initialTipo = widget.initial['tipoEquipo'];
    if (initialTipo != null && initialTipo.isNotEmpty) {
      _tipo = _EquipoType.values.firstWhere(
        (e) => e.code == initialTipo,
        orElse: () => _EquipoType.audiovisual,
      );
    }

    _nombreCtrl.addListener(_emit);
    _marcaCtrl.addListener(_emit);
    _modeloCtrl.addListener(_emit);
    _serialCtrl.addListener(_emit);
    _otroTipoCtrl.addListener(_emit);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _serialCtrl.dispose();
    _otroTipoCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    final data = {
      'tipoEquipo': _tipo?.code ?? '',
      'tipoEquipoLabel': _tipo?.label ?? '',
      'tipoEquipoOtro':
          _tipo == _EquipoType.otra ? _otroTipoCtrl.text.trim() : '',
      'nombre': _nombreCtrl.text.trim(),
      'marca': _marcaCtrl.text.trim(),
      'modelo': _modeloCtrl.text.trim(),
      'serial': _serialCtrl.text.trim(),
    };
    final valid = _isValid(data);
    if (valid != _canContinue) {
      setState(() => _canContinue = valid);
    }
    widget.onChanged(data, valid);
  }

  bool _isValid(Map<String, String> data) {
    if (data['tipoEquipo']!.isEmpty) return false;
    if (data['tipoEquipo'] == 'otra' &&
        data['tipoEquipoOtro']!.length < 2) {
      return false;
    }
    if (data['nombre']!.length < 2) return false;
    // Marca/Modelo/Serial son opcionales para Equipo.
    return true;
  }

  Future<void> _pickTipo() async {
    final picked = await showModalBottomSheet<_EquipoType>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _EquipoTypePickerSheet(selected: _tipo),
    );
    if (picked != null && mounted) {
      setState(() => _tipo = picked);
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final showOtroField = _tipo == _EquipoType.otra;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Tipo de equipo (BottomSheet) ─────────────────────────────────
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _pickTipo,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Tipo de equipo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            child: Row(
              children: [
                if (_tipo != null) ...[
                  Icon(_tipo!.icon, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  _tipo?.label ?? 'Selecciona…',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color:
                        _tipo == null ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── "¿Cuál?" inline cuando elige Otra ────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: showOtroField
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _otroTipoCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: '¿Cuál?',
                      hintText: 'Describe el tipo de equipo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),

        const SizedBox(height: 12),

        // ── Nombre ───────────────────────────────────────────────────────
        TextField(
          controller: _nombreCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Nombre del equipo',
            hintText: 'Cámara Sony A7, Hidrolavadora Karcher…',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Marca (opcional) ─────────────────────────────────────────────
        TextField(
          controller: _marcaCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Marca (opcional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Modelo (opcional) ────────────────────────────────────────────
        TextField(
          controller: _modeloCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Modelo (opcional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Serial (opcional) ────────────────────────────────────────────
        TextField(
          controller: _serialCtrl,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Serial / N° identificación (opcional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Botón Continuar inline ───────────────────────────────────────
        FilledButton(
          onPressed: _canContinue ? widget.onContinue : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}

// ── BottomSheet selector de tipo de equipo ──────────────────────────────────

class _EquipoTypePickerSheet extends StatelessWidget {
  final _EquipoType? selected;
  const _EquipoTypePickerSheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Tipo de equipo',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                shrinkWrap: true,
                itemCount: _EquipoType.values.length,
                itemBuilder: (ctx, i) {
                  final t = _EquipoType.values[i];
                  final isSelected = t == selected;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary.withValues(alpha: 0.15)
                            : cs.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        t.icon,
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      t.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form de inmueble: tipo (BottomSheet) + dirección + complemento ──────────

class InmuebleForm extends StatefulWidget {
  final Map<String, String> initial;
  final void Function(Map<String, String> data, bool valid) onChanged;
  final VoidCallback onContinue;

  const InmuebleForm({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  State<InmuebleForm> createState() => _InmuebleFormState();
}

class _InmuebleFormState extends State<InmuebleForm> {
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _complementoCtrl;
  late final TextEditingController _otroTipoCtrl;
  _InmuebleType? _tipo;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _direccionCtrl =
        TextEditingController(text: widget.initial['direccion'] ?? '');
    _complementoCtrl =
        TextEditingController(text: widget.initial['complemento'] ?? '');
    _otroTipoCtrl =
        TextEditingController(text: widget.initial['tipoInmuebleOtro'] ?? '');

    final initialTipo = widget.initial['tipoInmueble'];
    if (initialTipo != null && initialTipo.isNotEmpty) {
      _tipo = _InmuebleType.values.firstWhere(
        (e) => e.code == initialTipo,
        orElse: () => _InmuebleType.casa,
      );
    }

    _direccionCtrl.addListener(_emit);
    _complementoCtrl.addListener(_emit);
    _otroTipoCtrl.addListener(_emit);
  }

  @override
  void dispose() {
    _direccionCtrl.dispose();
    _complementoCtrl.dispose();
    _otroTipoCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    final data = {
      'tipoInmueble': _tipo?.code ?? '',
      'tipoInmuebleLabel': _tipo?.label ?? '',
      'tipoInmuebleOtro':
          _tipo == _InmuebleType.otros ? _otroTipoCtrl.text.trim() : '',
      'direccion': _direccionCtrl.text.trim(),
      'complemento': _complementoCtrl.text.trim(),
    };
    final valid = _isValid(data);
    if (valid != _canContinue) {
      setState(() => _canContinue = valid);
    }
    widget.onChanged(data, valid);
  }

  bool _isValid(Map<String, String> data) {
    if (data['tipoInmueble']!.isEmpty) return false;
    if (data['tipoInmueble'] == 'otros' &&
        data['tipoInmuebleOtro']!.length < 2) {
      return false;
    }
    if (data['direccion']!.length < 5) return false;
    return true;
  }

  Future<void> _pickTipo() async {
    final picked = await showModalBottomSheet<_InmuebleType>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _InmuebleTypePickerSheet(selected: _tipo),
    );
    if (picked != null && mounted) {
      setState(() => _tipo = picked);
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final showOtroField = _tipo == _InmuebleType.otros;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Tipo de inmueble (BottomSheet) ───────────────────────────────
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _pickTipo,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Tipo de inmueble',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            child: Row(
              children: [
                if (_tipo != null) ...[
                  Icon(_tipo!.icon, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  _tipo?.label ?? 'Selecciona…',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _tipo == null
                        ? cs.onSurfaceVariant
                        : cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── "¿Cuál?" inline cuando elige Otros ───────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: showOtroField
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _otroTipoCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: '¿Cuál?',
                      hintText: 'Describe el tipo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),

        const SizedBox(height: 12),

        // ── Dirección ────────────────────────────────────────────────────
        TextField(
          controller: _direccionCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Dirección',
            hintText: 'Cra 7 # 12-34',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Complemento dirección (opcional) ─────────────────────────────
        TextField(
          controller: _complementoCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Complemento (opcional)',
            hintText: 'Apto 301, Bloque B, Conjunto…',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Botón Continuar inline ───────────────────────────────────────
        FilledButton(
          onPressed: _canContinue ? widget.onContinue : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}

// ── BottomSheet selector de tipo de inmueble ────────────────────────────────

class _InmuebleTypePickerSheet extends StatelessWidget {
  final _InmuebleType? selected;
  const _InmuebleTypePickerSheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Tipo de inmueble',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                shrinkWrap: true,
                itemCount: _InmuebleType.values.length,
                itemBuilder: (ctx, i) {
                  final t = _InmuebleType.values[i];
                  final isSelected = t == selected;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary.withValues(alpha: 0.15)
                            : cs.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        t.icon,
                        color:
                            isSelected ? cs.primary : cs.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      t.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form de vehículo: tipo doc + número doc + placa + Continuar inline ──────

class _VehicleForm extends StatefulWidget {
  final Map<String, String> initial;
  final void Function(Map<String, String> data, bool valid) onChanged;
  final VoidCallback onContinue;

  const _VehicleForm({
    required this.initial,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  State<_VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<_VehicleForm> {
  late final TextEditingController _docNumberCtrl;
  late final TextEditingController _placaCtrl;
  _DocType? _docType;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _docNumberCtrl = TextEditingController(
      text: widget.initial['docNumber'] ?? '',
    );
    _placaCtrl = TextEditingController(text: widget.initial['placa'] ?? '');
    final initialType = widget.initial['docType'];
    if (initialType != null && initialType.isNotEmpty) {
      _docType = _DocType.values.firstWhere(
        (e) => e.code == initialType,
        orElse: () => _DocType.cc,
      );
    }
    _docNumberCtrl.addListener(_emit);
    _placaCtrl.addListener(_emit);
  }

  @override
  void dispose() {
    _docNumberCtrl.dispose();
    _placaCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    final data = {
      'docType': _docType?.code ?? '',
      'docTypeLabel': _docType?.label ?? '',
      'docNumber': _docNumberCtrl.text.trim(),
      'placa': _placaCtrl.text.trim().toUpperCase(),
    };
    final valid = _isValid(data);
    // setState para que el botón Continuar se habilite cuando cambia la
    // validez. Cambios en los TextField (placa, doc number) llegan acá vía
    // listeners de los controllers — sin este setState el botón quedaba
    // atrapado en disabled aunque los datos fueran válidos.
    if (valid != _canContinue) {
      setState(() => _canContinue = valid);
    }
    widget.onChanged(data, valid);
  }

  bool _isValid(Map<String, String> data) {
    // Validación CO: placa exactamente 6 caracteres.
    return data['docType']!.isNotEmpty &&
        data['docNumber']!.length >= 5 &&
        data['placa']!.length == 6;
  }

  Future<void> _pickDocType() async {
    final picked = await showModalBottomSheet<_DocType>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _DocTypePickerSheet(selected: _docType),
    );
    if (picked != null && mounted) {
      setState(() => _docType = picked);
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Tipo de documento (selector con BottomSheet) ─────────────────
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _pickDocType,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Tipo de documento',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            child: Text(
              _docType?.label ?? 'Selecciona…',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _docType == null ? cs.onSurfaceVariant : cs.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Número de documento ──────────────────────────────────────────
        TextField(
          controller: _docNumberCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
            LengthLimitingTextInputFormatter(15),
          ],
          decoration: InputDecoration(
            labelText: 'Número de documento',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Placa ────────────────────────────────────────────────────────
        TextField(
          controller: _placaCtrl,
          textCapitalization: TextCapitalization.characters,
          // Placa CO: exactamente 6 caracteres alfanuméricos.
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
          ],
          decoration: InputDecoration(
            labelText: 'Placa',
            hintText: 'ABC123',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Botón Continuar inline ───────────────────────────────────────
        FilledButton(
          onPressed: _canContinue ? widget.onContinue : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}

// ── BottomSheet selector de tipo de documento ────────────────────────────────

class _DocTypePickerSheet extends StatelessWidget {
  final _DocType? selected;
  const _DocTypePickerSheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Tipo de documento',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                shrinkWrap: true,
                itemCount: _DocType.values.length,
                itemBuilder: (ctx, i) {
                  final t = _DocType.values[i];
                  final isSelected = t == selected;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary.withValues(alpha: 0.15)
                            : cs.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        t.code,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color:
                              isSelected ? cs.primary : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      t.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
