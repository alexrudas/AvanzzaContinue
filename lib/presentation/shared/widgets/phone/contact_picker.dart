// ============================================================================
// lib/presentation/shared/widgets/phone/contact_picker.dart
// CONTACT PICKER — Seam para importar número desde la libreta del dispositivo
// ============================================================================
// QUÉ HACE:
//   - Define una interfaz `ContactPicker` consumida por `PhoneField` para
//     permitir al usuario importar un teléfono desde la libreta del sistema.
//   - Ofrece `NoOpContactPicker` como implementación por defecto: retorna
//     `PickedPhone.unavailable`, lo que hace que el widget muestre un
//     snackbar explicativo "Selector de contactos no disponible en esta
//     build". Esto permite que el widget se estrene HOY sin depender de
//     `flutter_contacts` (u otra lib que requiera aprobación de deps).
//
// CONTRATO:
//   - `pick(context)` retorna `PickedPhone`:
//       · `.success(phoneE164, label)` → el widget rellena el campo.
//       · `.cancelled`                 → no hace nada (el user cerró el picker).
//       · `.unavailable`               → el widget muestra snack explicativo.
//   - La impl debe ENCARGARSE de pedir permisos, mostrar su propia UI del
//     picker y NORMALIZAR el número antes de devolverlo (el widget asume
//     que recibe E.164 canónico).
//
// POR QUÉ ES UN SEAM:
//   - Añadir `flutter_contacts` (o equivalente) requiere aprobación explícita
//     del stack del proyecto. Mientras tanto, la UX del `PhoneField` queda
//     completa: el botón "Importar contactos" existe y es consistente; solo
//     la fuente de datos está stubbed.
//   - Cuando se apruebe la dep, basta con crear un adaptador que implemente
//     `ContactPicker`, registrarlo en `DIContainer`, y el widget gana la
//     funcionalidad sin cambios.
//
// ENTERPRISE NOTES:
//   - Este archivo es presentacional (shared/widgets) porque es la puerta
//     consumida por un widget. El adaptador concreto vivirá en `data/` o
//     `infrastructure/` cuando llegue la dep.
// ============================================================================

import 'package:flutter/widgets.dart';

/// Resultado de intentar importar un número desde la libreta del dispositivo.
class PickedPhone {
  /// Teléfono en formato E.164 canónico cuando el usuario eligió un contacto.
  /// Null si la variante es `cancelled` o `unavailable`.
  final String? phoneE164;

  /// Etiqueta humana del contacto (nombre) para UX (snackbar de éxito, etc.).
  /// Puede ser null incluso en `success` si el picker no provee nombre.
  final String? label;

  final _PickedPhoneKind _kind;

  const PickedPhone._(this._kind, {this.phoneE164, this.label});

  /// El usuario eligió un contacto con un teléfono válido.
  factory PickedPhone.success({required String phoneE164, String? label}) =>
      PickedPhone._(
        _PickedPhoneKind.success,
        phoneE164: phoneE164,
        label: label,
      );

  /// El usuario abrió el picker y lo cerró sin elegir nada, o eligió un
  /// contacto sin teléfono utilizable.
  factory PickedPhone.cancelled() => const PickedPhone._(_PickedPhoneKind.cancelled);

  /// No hay implementación de picker disponible (p. ej. la app corre sin la
  /// dep de contactos). El widget debe mostrar un snackbar explicativo.
  factory PickedPhone.unavailable() =>
      const PickedPhone._(_PickedPhoneKind.unavailable);

  bool get isSuccess => _kind == _PickedPhoneKind.success;
  bool get isCancelled => _kind == _PickedPhoneKind.cancelled;
  bool get isUnavailable => _kind == _PickedPhoneKind.unavailable;
}

enum _PickedPhoneKind { success, cancelled, unavailable }

/// Contrato del picker de contactos. La UI lo invoca; la implementación
/// (cuando exista) se encarga de permisos, picker nativo y normalización.
abstract class ContactPicker {
  /// Intenta abrir el picker nativo y devolver un teléfono canónico.
  Future<PickedPhone> pick(BuildContext context);
}

/// Implementación por defecto — siempre devuelve `unavailable` para que el
/// widget muestre el snack "Selector de contactos no disponible en esta
/// build". Esta es la que se registra en `DIContainer` mientras no se
/// apruebe la dependencia concreta.
class NoOpContactPicker implements ContactPicker {
  const NoOpContactPicker();

  @override
  Future<PickedPhone> pick(BuildContext context) async {
    return PickedPhone.unavailable();
  }
}
