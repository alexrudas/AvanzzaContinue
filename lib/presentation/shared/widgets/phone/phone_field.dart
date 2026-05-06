// ============================================================================
// lib/presentation/shared/widgets/phone/phone_field.dart
// PHONE FIELD — Widget ÚNICO y reusable para teléfonos en toda la app
// ============================================================================
// QUÉ HACE:
//   - Campo de teléfono operativo pensado para Colombia (+57) con validación
//     estricta de 10 dígitos y persistencia en formato canónico E.164.
//   - Modos: `edit` (TextField editable) y `readOnly` (display con acciones).
//   - Acciones integradas:
//       · Botón "Llamar" → abre el dialer nativo vía `launchUrl(tel:...)`.
//         Solo habilitado si el valor actual es canónicamente válido.
//       · Botón "Importar contacto" → delega a `ContactPicker` (seam). Si
//         no hay picker real registrado, muestra snackbar amable.
//   - Hidratación correcta: acepta `initialValue` (canónico o raw); lo
//     convierte a los 10 dígitos del input automáticamente.
//   - Persistencia canónica: `onChanged` emite SIEMPRE E.164 válido o `null`.
//     NUNCA emite un valor parcial o "tal como lo escribió el usuario".
//
// QUÉ NO HACE:
//   - NO soporta multi-país en esta fase: prefijo fijo +57. El widget de
//     onboarding `PhoneInputField` sigue vivo para ese caso multi-país;
//     cuando aparezca un requerimiento real de multi-país en formularios
//     operativos, este widget se promueve al patrón de PhoneInputField
//     sin romper el callsite (solo cambia el constructor).
//   - NO guarda nada por su cuenta: es un input controlado puro.
//   - NO mide formato nacional especializado (libphonenumber). La regla
//     operativa CO es simple: 10 dígitos → `+57XXXXXXXXXX`.
//
// PRINCIPIOS:
//   - Reusa `normalizePhoneE164` del dominio (ya probado y replicado en
//     backend).
//   - Formato visual `XXX XXX XXXX` puro de display — el valor emitido es
//     siempre el canónico.
//   - La acción de llamar se dispara con el valor canónico actual; si el
//     usuario está escribiendo y aún no hay 10 dígitos, el botón queda
//     deshabilitado. NUNCA se dispara el dialer con un número inválido.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/services/core_common/key_normalizer.dart';
import 'contact_picker.dart';

/// Modo de operación del widget.
enum PhoneFieldMode { edit, readOnly }

/// Widget ÚNICO de teléfono operativo.
///
/// Uso típico en un form:
/// ```dart
/// PhoneField(
///   initialValue: _controller.primaryPhone.value,
///   labelText: 'Teléfono principal *',
///   required: true,
///   onChanged: (e164) => _controller.primaryPhone.value = e164 ?? '',
/// )
/// ```
///
/// Uso en lectura (detalle):
/// ```dart
/// PhoneField(
///   initialValue: provider.primaryPhoneE164,
///   mode: PhoneFieldMode.readOnly,
///   labelText: 'Teléfono principal',
/// )
/// ```
class PhoneField extends StatefulWidget {
  /// Valor inicial (canónico `+57XXXXXXXXXX` o raw). Si el raw es parseable
  /// con `normalizePhoneE164`, se extraen los 10 dígitos para el input.
  final String? initialValue;

  /// Copy del label. Requerido para consistencia con otros inputs.
  final String labelText;

  /// Callback con el E.164 canónico o null si está incompleto/inválido.
  /// Emite en cada cambio del input.
  final ValueChanged<String?>? onChanged;

  /// Si `true`, marca el campo como requerido en el validator interno.
  final bool required;

  /// Modo del campo: `edit` (default) o `readOnly`.
  final PhoneFieldMode mode;

  /// Clave de test opcional (para que el caller pueda targetear el input).
  final Key? fieldKey;

  /// Si se provee, habilita el botón "Importar desde contactos". Si es null,
  /// el botón no se renderiza (ahorra espacio cuando el caller sabe que
  /// la acción no aporta — p. ej. sedes adicionales donde el usuario escribe
  /// un teléfono local).
  final bool showImportFromContacts;

  /// Si `true` (default), renderiza el IconButton "Copiar" en modo readOnly.
  /// Puede ponerse en `false` cuando la página huésped prefiere reservar el
  /// trailing exclusivamente para la acción principal (p. ej. "Llamar") y
  /// evitar ruido visual en fichas de lectura.
  final bool showCopyAction;

  /// Si `true` (default), renderiza el IconButton "Llamar" tanto en modo
  /// edit como readOnly. Puede ponerse en `false` cuando el contexto es de
  /// captura/edición de datos y la acción de llamar no aporta — p. ej. un
  /// formulario de alta/edición donde el usuario está digitando el número.
  final bool showCallAction;

  const PhoneField({
    super.key,
    this.initialValue,
    required this.labelText,
    this.onChanged,
    this.required = false,
    this.mode = PhoneFieldMode.edit,
    this.fieldKey,
    this.showImportFromContacts = true,
    this.showCopyAction = true,
    this.showCallAction = true,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late final TextEditingController _ctrl;
  String? _currentE164;
  bool _busyImport = false;

  @override
  void initState() {
    super.initState();
    final digits = _digitsFromInitial(widget.initialValue);
    _ctrl = TextEditingController(text: _visualFormat(digits));
    // HIDRATACIÓN: NO emitimos `onChanged` aquí. El parent YA conoce el
    // valor (fue quien lo pasó como `initialValue`). Emitir durante el
    // initState del hijo invocaría un `setState` aguas arriba mientras el
    // árbol se monta y, en parents que reconstruyen al recibir el
    // callback (p. ej. `_BranchEditorSheet` en el detalle de proveedor),
    // produce un rebuild → nuevo initState → emit → rebuild → ANR.
    _recomputeCanonical(digits, emit: false);
  }

  @override
  void didUpdateWidget(covariant PhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el caller cambia el initialValue externamente (p. ej. por
    // hidratación tardía del controller GetX), re-sincronizamos el texto
    // solo si el usuario NO ha tocado el campo todavía (detectado comparando
    // la canónica actual con la derivada del nuevo initial).
    if (oldWidget.initialValue != widget.initialValue) {
      final newDigits = _digitsFromInitial(widget.initialValue);
      final currentDigits = _ctrl.text.replaceAll(RegExp(r'\D'), '');
      if (currentDigits != newDigits) {
        _ctrl.text = _visualFormat(newDigits);
        _ctrl.selection =
            TextSelection.collapsed(offset: _ctrl.text.length);
        // Mismo razonamiento que en initState: el parent acaba de empujar
        // el valor — emitir de vuelta solo genera ruido y potencial loop.
        _recomputeCanonical(newDigits, emit: false);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Deriva los 10 dígitos operativos a partir del valor inicial (canónico
  /// o raw). Si no se pueden derivar, devuelve string vacío.
  String _digitsFromInitial(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    // Normalizamos usando la misma regla que el dominio. Si el input ya es
    // canónico CO (`+57XXXXXXXXXX`), devuelve los 10 dígitos locales.
    final canonical =
        normalizePhoneE164(raw, defaultCountryCallingCode: '57');
    if (canonical == null) {
      // Último recurso: tomar los últimos 10 dígitos del input.
      final digits = raw.replaceAll(RegExp(r'\D'), '');
      return digits.length >= 10
          ? digits.substring(digits.length - 10)
          : digits;
    }
    // Canónico esperado: `+57XXXXXXXXXX` → cortamos los 10 dígitos finales.
    final digits = canonical.substring(1); // quita '+'
    if (digits.startsWith('57') && digits.length >= 12) {
      return digits.substring(digits.length - 10);
    }
    return digits.length >= 10
        ? digits.substring(digits.length - 10)
        : digits;
  }

  /// Aplica el formato visual `XXX XXX XXXX` a un string de dígitos. Los
  /// trimmers son pragmáticos: si hay menos de 10, se muestran los que hay
  /// con espacios parciales. NO altera el valor canónico — es cosmético.
  String _visualFormat(String digits) {
    final buf = StringBuffer();
    for (var i = 0; i < digits.length && i < 10; i++) {
      if (i == 3 || i == 6) buf.write(' ');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  void _onTextChanged(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;
    final visual = _visualFormat(limited);
    if (visual != _ctrl.text) {
      _ctrl.value = TextEditingValue(
        text: visual,
        selection: TextSelection.collapsed(offset: visual.length),
      );
    }
    _recomputeCanonical(limited);
  }

  /// Recomputa el valor canónico E.164 a partir de los dígitos locales.
  ///
  /// - `emit=true` (default): notifica al parent vía `onChanged` y rebuilds
  ///   este widget. Úsalo SOLO cuando el cambio viene del usuario
  ///   (tecleo / importar contacto).
  /// - `emit=false`: actualiza el estado interno en silencio. Obligatorio
  ///   cuando la llamada proviene de `initState` o `didUpdateWidget`,
  ///   porque el parent acaba de pasar el valor y un `setState` aguas
  ///   arriba durante el mount del hijo puede provocar loops / ANR
  ///   (visto en el BottomSheet de edición de sede del detalle de
  ///   proveedor).
  void _recomputeCanonical(String digits, {bool emit = true}) {
    final canonical = digits.length == 10 ? '+57$digits' : null;
    if (canonical == _currentE164) return;
    _currentE164 = canonical;
    if (!emit) return;
    widget.onChanged?.call(canonical);
    if (mounted) setState(() {});
  }

  bool get _isValid => _currentE164 != null;

  /// Dispara la llamada INMEDIATA al número canónico actual.
  ///
  /// Política de plataforma:
  ///   - Android con permiso `CALL_PHONE` concedido → llamada directa
  ///     (sin prompt intermedio) vía `FlutterPhoneDirectCaller.callNumber`.
  ///     El paquete se encarga de pedir el permiso al usuario la primera
  ///     vez; si el usuario lo niega, el call devuelve `false` y caemos
  ///     al dialer como fallback graceful.
  ///   - iOS → el sistema intercepta la llamada directa y muestra el
  ///     prompt nativo "¿Llamar a X?". NO se puede evitar (limitación de
  ///     la plataforma, no del widget). Se usa el mismo entry point para
  ///     aprovechar ese prompt.
  ///   - Cualquier otro OS / fallo → fallback al dialer vía `tel:`.
  ///
  /// Retorna cuando la acción terminó (no espera al fin de la llamada).
  Future<void> _onCall() async {
    if (!_isValid) return;
    final number = _currentE164!;
    try {
      final success = await FlutterPhoneDirectCaller.callNumber(number);
      if (success == true) return;
      // Permiso denegado o plataforma sin soporte nativo → fallback
      // al dialer. Mantiene la UX operativa aunque no sea "directa".
      await _fallbackToDialer(number);
    } catch (_) {
      await _fallbackToDialer(number);
    }
  }

  Future<void> _fallbackToDialer(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    try {
      final ok = await launchUrl(uri);
      if (!ok && mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('No se pudo iniciar la llamada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('No se pudo iniciar la llamada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Copia el teléfono canónico al portapapeles. Se dispara solo desde el
  /// IconButton explícito de "Copiar" del widget; nunca desde el tap de
  /// la tarjeta/celda que contenga este widget (regla de UX explícita).
  Future<void> _onCopy() async {
    if (!_isValid) return;
    await Clipboard.setData(ClipboardData(text: _currentE164!));
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Teléfono copiado.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onImportFromContacts() async {
    setState(() => _busyImport = true);
    ContactPicker picker;
    try {
      picker = Get.find<ContactPicker>();
    } catch (_) {
      picker = const NoOpContactPicker();
    }
    final result = await picker.pick(context);
    if (!mounted) return;
    setState(() => _busyImport = false);
    if (result.isSuccess) {
      final digits = _digitsFromInitial(result.phoneE164);
      _ctrl.text = _visualFormat(digits);
      _ctrl.selection =
          TextSelection.collapsed(offset: _ctrl.text.length);
      _recomputeCanonical(digits);
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            result.label == null
                ? 'Número importado desde contactos.'
                : 'Número de ${result.label} importado.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (result.isUnavailable) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text(
            'Selector de contactos no disponible en esta build.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // cancelled → no hacemos nada
  }

  // ── BUILD ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (widget.mode == PhoneFieldMode.readOnly) {
      return _buildReadOnly(context);
    }
    return _buildEdit(context);
  }

  Widget _buildReadOnly(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = _isValid;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.phone_outlined, size: 20, color: theme.hintColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.labelText, style: theme.textTheme.labelSmall),
              const SizedBox(height: 2),
              // NOTA: el teléfono se muestra como Text NORMAL (no InkWell).
              // Copiar se hace SOLO desde el IconButton explícito de la
              // derecha — no al tocar el valor ni la tarjeta superior.
              Text(
                hasValue
                    ? '+57 ${_ctrl.text}'
                    : '—',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasValue
                      ? theme.colorScheme.onSurface
                      : theme.hintColor,
                  fontWeight:
                      hasValue ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        if (hasValue) ...[
          if (widget.showCopyAction)
            IconButton(
              key: const Key('phone_field.copy.readOnly'),
              icon: const Icon(Icons.copy_rounded),
              tooltip: 'Copiar número',
              color: theme.hintColor,
              onPressed: _onCopy,
            ),
          if (widget.showCallAction)
            IconButton(
              key: const Key('phone_field.call.readOnly'),
              icon: const Icon(Icons.phone_rounded),
              tooltip: 'Llamar',
              color: theme.colorScheme.primary,
              onPressed: _onCall,
            ),
        ],
      ],
    );
  }

  Widget _buildEdit(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showImportFromContacts)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: IconButton.outlined(
              key: const Key('phone_field.import'),
              icon: _busyImport
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.person_add_alt_1_outlined),
              tooltip: 'Importar desde contactos',
              onPressed: _busyImport ? null : _onImportFromContacts,
            ),
          ),
        Expanded(
          child: TextFormField(
            key: widget.fieldKey,
            controller: _ctrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: '300 123 4567',
              prefixText: '+57 ',
              prefixStyle: theme.textTheme.bodyMedium,
              border: const OutlineInputBorder(),
              helperText: _isValid
                  ? null
                  : (_ctrl.text.isEmpty
                      ? null
                      : 'Debe tener 10 dígitos.'),
            ),
            onChanged: _onTextChanged,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
              LengthLimitingTextInputFormatter(12), // 10 dígitos + 2 espacios
            ],
            validator: (_) {
              if (!widget.required && _ctrl.text.isEmpty) return null;
              if (!_isValid) {
                return 'Ingresa un teléfono colombiano de 10 dígitos.';
              }
              return null;
            },
          ),
        ),
        if (widget.showCallAction)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: IconButton.filledTonal(
              key: const Key('phone_field.call.edit'),
              icon: const Icon(Icons.phone_rounded),
              tooltip: _isValid
                  ? 'Llamar'
                  : 'Completa el número para llamar',
              onPressed: _isValid ? _onCall : null,
            ),
          ),
      ],
    );
  }
}
