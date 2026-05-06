// ============================================================================
// lib/data/datasources/local/registration_intent_ds.dart
// REGISTRATION INTENT DS — persistencia transitoria de intención de onboarding.
//
// QUÉ HACE:
// - Persiste señales locales de "intención" capturadas durante el wizard de
//   registro que deben sobrevivir al `clear()` del `RegistrationProgressModel`
//   y al restart del proceso.
// - Hoy expone una sola intención: `providerOnboardingIntent`. Significado:
//   "el usuario seleccionó proveedor en el wizard; tras /v1/auth/bootstrap
//   debe ir a /provider/bootstrap aunque /v1/providers/me devuelva
//   isProvider=false (todavía no ha hecho provider bootstrap)".
//
// QUÉ NO HACE:
// - NO es un rol, NO es una capability, NO es un permiso. Es metadata de
//   ROUTING POST-REGISTER.
// - NO se escribe a Firestore, NO se escribe a `users.roles`, NO se escribe
//   a `activeContext.rol`.
// - NO sobrevive al éxito de `/v1/providers/bootstrap`: el caller debe
//   llamar a `clear()` cuando ese flow termine.
//
// PRINCIPIOS:
// - Backed por SharedPreferences (paquete del stack aprobado).
// - Singleton sin DI complicada — el llamador hace `RegistrationIntentDS()`.
// - Tolerante a fallos de IO: si SharedPreferences falla, getters retornan
//   `false` (degradación segura: usuario verá el flujo default).
//
// ENTERPRISE NOTES:
// - Almacenado bajo namespace `avanzza.registration_intent.*` para no
//   colisionar con otras prefs de la app.
// - Si en el futuro hay más intenciones (ej. assetManagerOnboardingIntent),
//   ampliar este DS — NO crear stores paralelos.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationIntentDS {
  static const String _kProviderOnboardingIntent =
      'avanzza.registration_intent.provider_onboarding';

  /// Marca que el usuario seleccionó "proveedor" durante el wizard. El
  /// splash leerá esto para enviar al wizard `/provider/bootstrap` aunque
  /// `/v1/providers/me` devuelva `isProvider=false`.
  Future<void> setProviderOnboardingIntent(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kProviderOnboardingIntent, value);
      if (kDebugMode) {
        debugPrint('[RegistrationIntent] providerOnboardingIntent=$value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RegistrationIntent] setProviderOnboardingIntent error: $e');
      }
    }
  }

  /// Lee la intención. `false` si no existe o si SharedPreferences falla
  /// (degradación segura — el splash usa el fallback default).
  Future<bool> getProviderOnboardingIntent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kProviderOnboardingIntent) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RegistrationIntent] getProviderOnboardingIntent error: $e');
      }
      return false;
    }
  }

  /// Limpia TODAS las intenciones de onboarding. Llamar tras completar
  /// `/v1/providers/bootstrap` (cuando el caller ya es proveedor real) o
  /// tras logout.
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kProviderOnboardingIntent);
      if (kDebugMode) {
        debugPrint('[RegistrationIntent] cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RegistrationIntent] clear error: $e');
      }
    }
  }
}
