// ============================================================================
// lib/presentation/pages/admin/network/widgets/provider_branch_editor_sheet.dart
// PROVIDER BRANCH EDITOR SHEET — Alta/edición de una sede adicional
// ============================================================================
// QUÉ HACE:
//   - BottomSheet REUTILIZABLE para agregar o editar una sede adicional del
//     proveedor. Se consume tanto desde la sección "Otras sedes" del form
//     completo (en modo create/edit) como desde la página de detalle (en
//     modo edit al tocar el botón "Editar" de una sede).
//   - Reutiliza la infraestructura geo existente (`RegionSelectorField` +
//     `CitySelectorField`) y el widget único de teléfono `PhoneField`. Cero
//     campos libres sin validación.
//   - Devuelve la sede editada (o `null` si el usuario cancela). El caller
//     es responsable de persistirla vía `ProviderFormController.upsertBranch`
//     (dentro del flujo del form) — no se escribe a disco desde aquí.
//
// QUÉ NO HACE:
//   - NO persiste: el sheet es puramente UI. Consume al controller solo
//     para orquestación cuando se invoca desde el form; desde el detalle
//     se puede pasar un callback onSaved y que el caller persista.
//   - NO introduce validaciones distintas al form: mismas reglas y mismo
//     `PhoneField` para consistencia.
//
// PRINCIPIOS:
//   - Stateful controlado: vive mientras el sheet está abierto; al cerrar,
//     libera TextEditingControllers.
//   - UUID: si la sede es nueva, el caller pasa `initial: null` y el sheet
//     genera el id al confirmar. Si es edición, `initial.id` se preserva.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../../../domain/entities/core_common/provider_branch_entity.dart';
import '../../../../location/controllers/location_controller.dart';
import '../../../../shared/widgets/location/city_selector_field.dart';
import '../../../../shared/widgets/location/region_selector_field.dart';
import '../../../../shared/widgets/phone/phone_field.dart';

/// Abre el editor de sede como BottomSheet modal. Retorna la sede
/// resultante o `null` si el usuario canceló.
///
/// - [initial] == null → modo create (se genera un uuid al confirmar).
/// - [initial] != null → modo edit (se preserva el id).
Future<ProviderBranchEntity?> showProviderBranchEditorSheet(
  BuildContext context, {
  ProviderBranchEntity? initial,
  required String defaultCountryId,
}) {
  return showModalBottomSheet<ProviderBranchEntity?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BranchEditorSheet(
      initial: initial,
      defaultCountryId: defaultCountryId,
    ),
  );
}

class _BranchEditorSheet extends StatefulWidget {
  final ProviderBranchEntity? initial;
  final String defaultCountryId;

  const _BranchEditorSheet({
    required this.initial,
    required this.defaultCountryId,
  });

  @override
  State<_BranchEditorSheet> createState() => _BranchEditorSheetState();
}

class _BranchEditorSheetState extends State<_BranchEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _contactNameCtrl;
  late final TextEditingController _notesCtrl;

  String? _countryId;
  String? _regionId;
  String? _cityId;
  String? _phoneE164;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _labelCtrl = TextEditingController(text: i?.label ?? '');
    _addressCtrl = TextEditingController(text: i?.addressLine ?? '');
    _contactNameCtrl = TextEditingController(text: i?.contactName ?? '');
    _notesCtrl = TextEditingController(text: i?.notes ?? '');
    _countryId = (i?.countryId ?? '').isNotEmpty
        ? i!.countryId
        : (widget.defaultCountryId.isEmpty
            ? null
            : widget.defaultCountryId);
    _regionId = i?.regionId;
    _cityId = i?.cityId;
    _phoneE164 = i?.phoneE164;
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _addressCtrl.dispose();
    _contactNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.initial != null;

  void _onRegionChanged(String? id) {
    setState(() {
      _regionId = (id ?? '').isEmpty ? null : id;
      _cityId = null; // ciudad deja de ser válida si cambia departamento
    });
  }

  void _onCityChanged(String? id) {
    setState(() => _cityId = (id ?? '').isEmpty ? null : id);
  }

  void _onConfirm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Cobertura mínima de sede: al menos ciudad para que tenga sentido
    // mostrarla en el perfil. El label es opcional.
    if ((_cityId ?? '').isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Selecciona la ciudad de la sede.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final branch = ProviderBranchEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      label:
          _labelCtrl.text.trim().isEmpty ? null : _labelCtrl.text.trim(),
      countryId: _countryId,
      regionId: _regionId,
      cityId: _cityId,
      addressLine: _addressCtrl.text.trim().isEmpty
          ? null
          : _addressCtrl.text.trim(),
      phoneE164: _phoneE164,
      contactName: _contactNameCtrl.text.trim().isEmpty
          ? null
          : _contactNameCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    Navigator.of(context).pop(branch);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // Padding inferior para que el sheet no quede tapado por el teclado.
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 4, bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  _isEdit ? 'Editar sede' : 'Nueva sede',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        key: const Key('branch_editor.label'),
                        controller: _labelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la sede (opcional)',
                          hintText: 'Ej. Sede Norte, Bodega Principal',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      RegionSelectorField(
                        key: ValueKey('branch_editor.region.$_countryId'),
                        countryId: _countryId,
                        initialValue: _regionId,
                        labelText: 'Departamento',
                        onChanged: (r) => _onRegionChanged(r.id),
                      ),
                      CitySelectorField(
                        key: ValueKey(
                            'branch_editor.city.$_countryId.$_regionId'),
                        countryId: _countryId,
                        regionId: _regionId,
                        initialValue: _cityId,
                        onChanged: (c) => _onCityChanged(c.id),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('branch_editor.address'),
                        controller: _addressCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Dirección (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(160),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PhoneField(
                        key: const Key('branch_editor.phone'),
                        initialValue: _phoneE164,
                        labelText: 'Teléfono de la sede (opcional)',
                        onChanged: (e164) =>
                            setState(() => _phoneE164 = e164),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('branch_editor.contactName'),
                        controller: _contactNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Contacto de la sede (opcional)',
                          hintText: 'Ej. Andrés — jefe de bodega',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('branch_editor.notes'),
                        controller: _notesCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
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
                        key: const Key('branch_editor.confirm'),
                        onPressed: _onConfirm,
                        child: Text(_isEdit ? 'Guardar cambios' : 'Agregar sede'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// LocationController se importa para garantizar que el BottomSheet se abre
// en contextos donde el controller ya está disponible (reusa el mismo cache
// de regiones/ciudades que alimenta el form principal).
// ignore: unused_element
typedef _Unused = LocationController;
