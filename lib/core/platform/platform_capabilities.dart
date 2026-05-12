// ============================================================================
// lib/core/platform/platform_capabilities.dart
// PLATFORM CAPABILITIES — Contrato mínimo, estático, determinístico.
// ============================================================================
// QUÉ ES:
//   Una clase de SOLO getters constantes que responden a una sola pregunta:
//   "¿esta plataforma/dispositivo es capaz de ejecutar X?".
//
//   Es la única superficie por la que la UI y los servicios consultan
//   capacidades de plataforma. No hay otro `Platform.isXxx` en widgets.
//
// QUÉ NO ES:
//   - NO es ChangeNotifier. Los valores no cambian en runtime.
//   - NO depende del usuario, sesión, workspace ni permisos runtime.
//   - NO hace llamadas async. Cada getter resuelve sin I/O.
//   - NO produce rebuilds: como los valores son estables durante la vida del
//     proceso, leer un getter dentro de `build()` es seguro y no necesita Obx.
//   - NO sustituye a Membership/Capabilities del backend. Ver sección D del
//     informe de Phase 0: PlatformCapabilities = qué puede el DISPOSITIVO.
//     Membership/Capabilities = qué puede el USUARIO en su workspace.
//
// REGLAS DE EVOLUCIÓN:
//   - Añadir getters semánticos (`supportsX`), no plataforma (`isAndroid`).
//   - Si un caso necesita comportamiento divergente (no solo "mostrar/ocultar"),
//     extrae un servicio con interfaz en `core/services/`, no un getter aquí.
//   - Web y macOS: hoy no son targets. Los getters devuelven valores
//     conservadores para no crashear si alguien corre la app ahí, pero no
//     se diseña arquitectura extensible todavía.
// ============================================================================

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformCapabilities {
  PlatformCapabilities._();

  // ---------------------------------------------------------------------------
  // FAMILIA DE PLATAFORMA
  // ---------------------------------------------------------------------------

  /// Android o iOS. No incluye Web ni desktop.
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Windows, macOS o Linux nativo. No incluye Web.
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// La build actual es un companion administrativo de escritorio.
  /// Hoy es alias semántico de `isDesktop`; existe para permitir copy
  /// específico ("Esta función está disponible en la app móvil") sin
  /// acoplar la UI al nombre `isDesktop` que es más estructural.
  static bool get isDesktopCompanion => isDesktop;

  // ---------------------------------------------------------------------------
  // CAPTURA / SENSORES
  // ---------------------------------------------------------------------------

  /// Escáner de código de barras vía cámara (mobile_scanner + MLKit).
  /// MLKit no tiene Windows/Linux/Web; Phase 0 mantiene la feature solo
  /// en móvil nativo.
  static bool get supportsCameraBarcodeScanner => isMobile;

  /// OCR de documentos (google_mlkit_text_recognition).
  /// MLKit solo Android/iOS.
  static bool get supportsTextRecognitionOcr => isMobile;

  // ---------------------------------------------------------------------------
  // CONTACTO / TELEFONÍA
  // ---------------------------------------------------------------------------

  /// Selector nativo de contactos del dispositivo (flutter_contacts).
  /// Solo Android/iOS. En desktop el usuario teclea el número.
  static bool get supportsNativeContactsPicker => isMobile;

  /// Llamada directa sin pasar por dialer (flutter_phone_direct_caller).
  /// Solo Android tiene llamada realmente directa; iOS cae a prompt
  /// nativo del sistema. Desktop no aplica.
  static bool get supportsDirectPhoneCall {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Apertura de URLs `tel:` vía url_launcher.
  /// Funciona en mobile nativo y desktop (donde el OS resuelve a
  /// Skype/Teams/handler asociado). En Web depende del navegador y no es
  /// target hoy, así que reportamos false conservador.
  static bool get supportsTelUrlLaunch => !kIsWeb;

  // ---------------------------------------------------------------------------
  // AUTENTICACIÓN
  // ---------------------------------------------------------------------------

  /// Auth federada nativa (Google/Facebook). Phase 0: solo móvil.
  /// Desktop requiere flujo OAuth manual (Phase 1+).
  static bool get supportsFederatedAuth => isMobile;

  /// Apple Sign-In: solo iOS y macOS. Aunque macOS no sea target activo,
  /// el getter reporta el valor correcto para evitar mostrar el botón
  /// donde la API no existe.
  static bool get supportsAppleSignIn {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  // ---------------------------------------------------------------------------
  // NOTIFICACIONES / PERMISOS
  // ---------------------------------------------------------------------------

  /// Push vía FCM (firebase_messaging). Aún sin integrar; el getter
  /// existe para que cuando se integre, los call sites no toquen
  /// Platform.isXxx para gatear.
  static bool get supportsPushNotifications => isMobile;

  /// La plataforma requiere permisos runtime (Android/iOS). Windows/macOS/
  /// Linux no piden permisos para los flujos de Phase 0.
  static bool get requiresRuntimePermissions => isMobile;

  // ---------------------------------------------------------------------------
  // ARCHIVOS
  // ---------------------------------------------------------------------------

  /// Selector de archivos (file_selector). Disponible en todas las
  /// plataformas nativas; en Web sí existe vía file_selector_web pero
  /// no es target hoy, así que reportamos solo nativo.
  static bool get supportsFilePicker => !kIsWeb;
}
