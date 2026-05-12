// ============================================================================
// lib/core/services/platform_services_factory.dart
// FACTORY ÚNICA — selecciona implementaciones de servicios por plataforma.
// ============================================================================
// QUÉ HACE:
//   - Centraliza la decisión "qué implementación usar en esta plataforma"
//     para todos los servicios con contrato cross-platform.
//   - Es el único archivo (junto con PlatformCapabilities) donde se mira
//     `Platform.isXxx`. El resto del código habla con las interfaces.
//
// CÓMO SE USA:
//   - `AppBindings.dependencies()` invoca cada factory y registra el
//     resultado en GetX (o en DIContainer si aplica). Los widgets y
//     controllers consumen la interfaz, no la impl concreta.
// ============================================================================

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'auth/federated_auth_service.dart';
import 'notifications/notification_registration_service.dart';
import 'phone/phone_dialer_desktop.dart';
import 'phone/phone_dialer_mobile.dart';
import 'phone/phone_dialer_service.dart';
import 'scanner/barcode_scanner_service.dart';

bool _isMobile() {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}

class PlatformServicesFactory {
  PlatformServicesFactory._();

  static PhoneDialerService createPhoneDialer() {
    if (_isMobile()) return const MobilePhoneDialerService();
    return const DesktopPhoneDialerService();
  }

  /// Phase 0: el scanner real vive en `presentation/auth/scanners/` y se
  /// invoca directamente desde las pantallas existentes. Aquí solo
  /// inyectamos el stub Windows; el wiring móvil completo llegará en Phase 1
  /// cuando se extraiga la impl real detrás de la interfaz.
  static BarcodeScannerService createBarcodeScanner() {
    // Phase 0: aún no extraemos la impl móvil real. La UI móvil sigue
    // usando MobileScanner directamente; la interfaz se usa solo en
    // pantallas/widgets nuevos o en desktop, donde retorna unsupported.
    return const UnsupportedBarcodeScannerService();
  }

  /// Phase 0: la impl móvil real de FederatedAuth sigue siendo
  /// `FirebaseAuthDS`. La interfaz se usa para consultar
  /// `availableProviders` y gatear UI en desktop. Cuando se haga refactor
  /// completo (Phase 1+), `MobileFederatedAuthService` puede envolver a
  /// `FirebaseAuthDS`.
  static FederatedAuthService createFederatedAuth() {
    if (_isMobile()) {
      // Lista de proveedores efectivamente soportados por la impl actual
      // (`FirebaseAuthDS`). Se usa solo para que la UI sepa qué mostrar.
      return const _MobileAvailableProvidersOnly();
    }
    return const UnsupportedFederatedAuthService();
  }

  static NotificationRegistrationService createNotificationRegistration() {
    // FCM aún no integrado. Siempre Noop hasta Phase 1.
    return const NoopNotificationRegistrationService();
  }
}

/// Anuncia los proveedores que la impl móvil real puede ejecutar. El
/// `signIn()` queda como `unsupported` hasta que se mueva la lógica
/// concreta desde `FirebaseAuthDS` detrás de esta interfaz. La UI usa
/// `availableProviders` para decidir qué botones renderizar.
class _MobileAvailableProvidersOnly implements FederatedAuthService {
  const _MobileAvailableProvidersOnly();

  @override
  Set<FederatedProvider> get availableProviders {
    if (kIsWeb) return const {};
    if (Platform.isIOS) {
      return const {
        FederatedProvider.google,
        FederatedProvider.apple,
        FederatedProvider.facebook,
      };
    }
    if (Platform.isAndroid) {
      return const {
        FederatedProvider.google,
        FederatedProvider.facebook,
      };
    }
    return const {};
  }

  @override
  Future<FederatedAuthResult> signIn(FederatedProvider provider) async {
    // Phase 0: la ejecución sigue saliendo desde
    // `FirebaseAuthDS.signInWithGoogle/Apple/Facebook` llamados por
    // EnhancedRegistrationController. Esta clase no ejecuta el flujo;
    // su único papel hoy es exponer `availableProviders` a la UI.
    return FederatedAuthResult.unsupported();
  }
}
