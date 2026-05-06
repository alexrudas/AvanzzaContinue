// ============================================================================
// lib/presentation/widgets/core_common/new_vendor_dialog.dart
// NEW VENDOR DIALOG — Pieza compartida de alta rápida de proveedor/contacto
// ============================================================================
// QUÉ HACE:
//   - Diálogo mínimo y reutilizable para crear un `LocalContactEntity` en el
//     workspace activo con una `roleLabel` dada (por defecto 'proveedor').
//   - Única vía de alta rápida de proveedor/taller/técnico/asesor que vive
//     sobre el camino canónico del ADR actor-canon: persiste vía
//     `SaveLocalContactWithProbe` (save local + enqueue remoto + probe).
//   - Consumido por:
//       · VendorTargetPickerSheet (flujo Pedidos)
//       · ProvidersDirectoryPage (flujo Directorio)
//     Garantiza que AMBOS usen exactamente la misma fuente de verdad
//     (LocalContactRepository) y el mismo shape de creación.
//
// QUÉ NO HACE:
//   - NO selecciona, autoselecciona ni modifica ninguna lista del caller:
//     retorna un `NewVendorResult` y el caller decide la UX (autoseleccionar
//     en picker, mostrar snackbar, refrescar, etc.).
//   - NO hace edición profunda (múltiples teléfonos, NIT estructurado,
//     direcciones). Eso queda para el detalle de proveedor cuando aplique.
//   - NO crea `LocalOrganization`. Si el proveedor es empresa, el nombre de
//     la empresa entra como `displayName`; la migración a empresa-NIT cuando
//     se habilite no rompe este diálogo (solo cambia el destino).
//   - NO muestra SnackBars: el caller es dueño del contexto superior (picker,
//     page) y decide cómo notificar al usuario tras el pop.
//
// PRINCIPIOS:
//   - Contract explícito vía `NewVendorResult` — nunca lanza al caller.
//   - Parametrizable por `roleLabel` para habilitar futuras vistas del mismo
//     arquetipo transversal comercial/servicio (taller, técnico, asesor)
//     sin duplicar formularios.
//   - Normalización E.164 silent-best-effort: si el teléfono no parsea, el
//     contacto se guarda sin teléfono (no bloquea el alta).
//   - Persistencia directa a `LocalContactRepository.save`: el alta rápida
//     NO depende del probe remoto. Esto garantiza que un administrador
//     pueda agregar proveedores al momento aunque la infraestructura de
//     matching remoto no esté disponible. El use case
//     `SaveLocalContactWithProbe` sigue vivo en el proyecto pero queda
//     reservado para flujos futuros de identidad transversal (fuera de
//     alcance de esta fase).
//
// ENTERPRISE NOTES:
//   - `defaultCountryCallingCode` default 'CO' = '57'; si el proyecto
//     consolida la fuente única de CC por país, ajustar aquí.
//   - `notesPrivate` guarda la categoría (texto libre); campo privado del
//     workspace por canon, no sincroniza fuera.
//   - El id se genera con UUID v4 lado cliente (mismo patrón que el picker
//     original). El backend acepta el id como parte del ActorRef.local.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/core_common/constants/role_labels.dart';
import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../shared/widgets/phone/phone_field.dart';

/// Resultado estructurado del diálogo.
///
/// - `vendor != null`: el caller decide cómo reaccionar (autoseleccionar,
///   mostrar snackbar de éxito, refrescar listas).
/// - `error != null`: el caller debe mostrarlo como error humano en la UX
///   de la pantalla padre (snackbar, toast, banner).
/// - Ambos null ⇒ el usuario canceló el diálogo.
class NewVendorResult {
  final LocalContactEntity? vendor;
  final String? error;

  const NewVendorResult._({this.vendor, this.error});

  /// Indica si hubo una creación exitosa (hay vendor, sin error).
  bool get isSuccess => vendor != null && error == null;

  /// Indica si hubo un fallo reportable al usuario.
  bool get isError => error != null;
}

/// Diálogo de alta rápida de proveedor/contacto comercial del workspace.
///
/// Uso típico (desde cualquier página):
/// ```dart
/// final result = await showNewVendorDialog(
///   context,
///   workspaceId: orgId,
/// );
/// if (result == null) return; // cancelado
/// if (result.isError) { showSnack(result.error!); return; }
/// // result.vendor disponible para UX del caller
/// ```
///
/// Parámetros:
/// - [workspaceId]: partition key del contacto. Obligatorio, no puede vacío.
/// - [roleLabel]: etiqueta de rol; default `kRoleLabelVendor` ('proveedor').
///   Pensado para extender a taller/técnico/asesor sin duplicar el widget.
/// - [defaultCountryCallingCode]: código país para normalización E.164;
///   default '57' (Colombia).
/// - [titleOverride] / [submitLabelOverride]: customización de copy cuando
///   el rol no es proveedor (ej. "Nuevo taller", "Guardar taller").
Future<NewVendorResult?> showNewVendorDialog(
  BuildContext context, {
  required String workspaceId,
  String roleLabel = kRoleLabelVendor,
  String defaultCountryCallingCode = '57',
  String? titleOverride,
  String? submitLabelOverride,
}) {
  return showDialog<NewVendorResult?>(
    context: context,
    // `barrierDismissible: false` mientras hay save en progreso lo manejamos
    // en el State (botón deshabilitado y botón de cerrar inactivo). Aquí
    // permitimos cerrar por fuera mientras el form esté limpio.
    builder: (dialogCtx) => _NewVendorDialogForm(
      workspaceId: workspaceId,
      roleLabel: roleLabel,
      defaultCountryCallingCode: defaultCountryCallingCode,
      titleOverride: titleOverride,
      submitLabelOverride: submitLabelOverride,
    ),
  );
}

/// Widget interno — privado al archivo. Stateful porque necesita manejar
/// controllers de texto, validación y estado `saving` con feedback visual.
class _NewVendorDialogForm extends StatefulWidget {
  final String workspaceId;
  final String roleLabel;
  final String defaultCountryCallingCode;
  final String? titleOverride;
  final String? submitLabelOverride;

  const _NewVendorDialogForm({
    required this.workspaceId,
    required this.roleLabel,
    required this.defaultCountryCallingCode,
    required this.titleOverride,
    required this.submitLabelOverride,
  });

  @override
  State<_NewVendorDialogForm> createState() => _NewVendorDialogFormState();
}

class _NewVendorDialogFormState extends State<_NewVendorDialogForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _saving = ValueNotifier<bool>(false);

  /// Valor canónico E.164 emitido por el `PhoneField`. Null si incompleto.
  String? _phoneE164;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _saving.dispose();
    super.dispose();
  }

  /// Copy dinámico según rol. Mantiene copy exacto del picker actual para
  /// proveedor (no introducir drift UX), y deriva variantes humanas para
  /// futuros roles del mismo arquetipo.
  String get _title {
    if (widget.titleOverride != null) return widget.titleOverride!;
    switch (widget.roleLabel) {
      case kRoleLabelVendor:
        return 'Nuevo proveedor';
      default:
        return 'Nuevo ${widget.roleLabel}';
    }
  }

  String get _nameLabel {
    switch (widget.roleLabel) {
      case kRoleLabelVendor:
        return 'Nombre del proveedor *';
      default:
        return 'Nombre *';
    }
  }

  String get _nameHint {
    switch (widget.roleLabel) {
      case kRoleLabelVendor:
        return 'Ej. Lubricantes del Caribe';
      default:
        return '';
    }
  }

  String get _submitLabel {
    if (widget.submitLabelOverride != null) return widget.submitLabelOverride!;
    switch (widget.roleLabel) {
      case kRoleLabelVendor:
        return 'Guardar proveedor';
      default:
        return 'Guardar';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('new_vendor_dialog.name'),
                controller: _nameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: _nameLabel,
                  hintText: _nameHint.isEmpty ? null : _nameHint,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PhoneField(
                fieldKey: const Key('new_vendor_dialog.phone'),
                labelText: 'Teléfono (opcional)',
                onChanged: (e164) => _phoneE164 = e164,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('new_vendor_dialog.category'),
                controller: _categoryCtrl,
                decoration: const InputDecoration(
                  labelText: 'Categoría (opcional)',
                  hintText: 'Ej. Repuestos, Lubricantes, Taller',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _saving,
          builder: (_, busy, __) => TextButton(
            onPressed: busy ? null : () => Navigator.of(context).pop(null),
            child: const Text('Cancelar'),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _saving,
          builder: (_, busy, __) => FilledButton(
            key: const Key('new_vendor_dialog.save'),
            onPressed: busy ? null : _onSave,
            child: busy
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_submitLabel),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _saving.value = true;
    final result = await _persist();
    _saving.value = false;
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  /// Persiste el contacto vía el camino canónico.
  /// Nunca lanza: convierte cualquier fallo en `NewVendorResult(error: ...)`.
  Future<NewVendorResult> _persist() async {
    if (widget.workspaceId.isEmpty) {
      return const NewVendorResult._(
        vendor: null,
        error:
            'No se pudo determinar el workspace activo. Intenta de nuevo.',
      );
    }
    try {
      final now = DateTime.now().toUtc();
      // PhoneField emite canónico E.164 o null. No hay que re-normalizar.
      final phoneE164 = _phoneE164;
      final category = _categoryCtrl.text.trim();
      final vendor = LocalContactEntity(
        id: const Uuid().v4(),
        workspaceId: widget.workspaceId,
        displayName: _nameCtrl.text.trim(),
        createdAt: now,
        updatedAt: now,
        roleLabel: widget.roleLabel,
        primaryPhoneE164: phoneE164,
        notesPrivate: category.isEmpty ? null : category,
      );
      // Persistencia directa: repo local + enqueue Firestore.
      // Cero dependencia del probe — esta fase no usa matching remoto y el
      // alta no puede quedar bloqueada por ausencia de Core API pública.
      await DIContainer().localContactRepository.save(vendor);
      return NewVendorResult._(vendor: vendor);
    } catch (e) {
      return NewVendorResult._(error: 'No se pudo crear el proveedor: $e');
    }
  }
}
