// ============================================================================
// lib/core/services/phone/phone_dialer_desktop.dart
// Implementación desktop: solo `tel:` vía url_launcher (handler del sistema).
// ============================================================================

import 'package:url_launcher/url_launcher.dart';

import 'phone_dialer_service.dart';

class DesktopPhoneDialerService implements PhoneDialerService {
  const DesktopPhoneDialerService();

  @override
  Future<bool> dial(String phoneE164) async {
    final uri = Uri(scheme: 'tel', path: phoneE164);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }
}
