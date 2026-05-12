// ============================================================================
// lib/core/services/phone/phone_dialer_service.dart
// PHONE DIALER SERVICE — Interfaz cross-platform
// ============================================================================
// QUÉ HACE:
//   - Define el contrato para iniciar una llamada telefónica desde la app.
//   - Reemplaza el uso directo de `FlutterPhoneDirectCaller` en widgets,
//     permitiendo que en Windows la acción caiga a `tel:` vía url_launcher
//     (Skype/Teams) sin crash de MissingPluginException.
//
// CONTRATO:
//   - `dial(phoneE164)` retorna `true` si la app pudo iniciar la llamada o
//     abrir el dialer. `false` si no hay handler disponible.
//
// PHASE 0:
//   - Mobile impl: usa FlutterPhoneDirectCaller en Android con fallback
//     `url_launcher`. (Para iOS solo url_launcher porque iOS no permite
//     llamada directa sin prompt).
//   - Windows impl: url_launcher con `tel:` — Windows resuelve a Skype/
//     Teams/handler asociado. Si no hay handler, retorna false.
// ============================================================================

abstract class PhoneDialerService {
  /// Inicia una llamada al número en formato E.164 (`+57XXXXXXXXXX`).
  /// Retorna true si se pudo iniciar la llamada o abrir el dialer.
  Future<bool> dial(String phoneE164);
}
