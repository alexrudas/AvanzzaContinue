// ============================================================================
// lib/infrastructure/contacts/flutter_contacts_picker.dart
// FLUTTER CONTACTS PICKER — Implementación real del seam ContactPicker
// ============================================================================
// QUÉ HACE:
//   - Implementa `ContactPicker` apoyándose en el paquete `flutter_contacts`.
//   - Pide permisos al vuelo (Android/iOS) y abre el picker NATIVO del
//     sistema (no una lista propia), lo que garantiza UX nativa, soporte de
//     múltiples cuentas (Google/iCloud) y cero mantenimiento de UI.
//   - Normaliza el teléfono seleccionado a E.164 canónico vía el normalizer
//     de dominio (`normalizePhoneE164` con país por defecto 57). Si el
//     contacto no tiene un teléfono utilizable, retorna `cancelled` — NUNCA
//     devuelve un número inválido.
//
// QUÉ NO HACE:
//   - NO construye una UI propia de contactos. Usa `openExternalPick` para
//     lanzar el Contacts app del sistema. Menos fricción, menos bugs.
//   - NO escribe en contactos. Solo lectura de UN contacto específico.
//   - NO persiste nada. Es un puente de "traer un número" a `PhoneField`.
//
// PRINCIPIOS:
//   - Fail graceful: si falla el permiso, retorna `unavailable` para que
//     el widget muestre un snackbar con copy explicativo.
//   - Selección de número: si el contacto tiene varios teléfonos, toma el
//     PRIMERO que normalice con éxito a E.164 CO. Si ninguno normaliza,
//     `cancelled`. Nunca devuelve un "raw" que luego el widget tenga que
//     saber manejar.
// ============================================================================

import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../domain/services/core_common/key_normalizer.dart';
import '../../presentation/shared/widgets/phone/contact_picker.dart';

class FlutterContactsPicker implements ContactPicker {
  /// Código país por defecto para normalizar teléfonos sin prefijo
  /// internacional. La app opera Colombia, así que 57 es el default
  /// pragmático; si en el futuro la UI multi-país llega, se inyecta vía
  /// constructor.
  final String defaultCountryCallingCode;

  const FlutterContactsPicker({this.defaultCountryCallingCode = '57'});

  @override
  Future<PickedPhone> pick(BuildContext context) async {
    try {
      // Pide permisos y abre el picker nativo. `openExternalPick` hace
      // ambas cosas en una sola llamada. Si el usuario no acepta permisos,
      // retorna `null`.
      final granted = await FlutterContacts.requestPermission(readonly: true);
      if (!granted) {
        return PickedPhone.unavailable();
      }
      final contact = await FlutterContacts.openExternalPick();
      if (contact == null) {
        return PickedPhone.cancelled();
      }
      // `openExternalPick` devuelve un Contact con info limitada; si trae
      // teléfonos, están ahí. Si no, consultamos la versión completa para
      // obtenerlos.
      final phones = contact.phones.isNotEmpty
          ? contact.phones
          : (await FlutterContacts.getContact(contact.id))?.phones ??
              const [];
      if (phones.isEmpty) {
        return PickedPhone.cancelled();
      }
      for (final p in phones) {
        final normalized = normalizePhoneE164(
          p.number,
          defaultCountryCallingCode: defaultCountryCallingCode,
        );
        if (normalized != null) {
          return PickedPhone.success(
            phoneE164: normalized,
            label: contact.displayName.isEmpty ? null : contact.displayName,
          );
        }
      }
      return PickedPhone.cancelled();
    } catch (e) {
      debugPrint('[FlutterContactsPicker] pick fail: $e');
      return PickedPhone.unavailable();
    }
  }
}
