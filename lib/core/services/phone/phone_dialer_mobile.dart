// ============================================================================
// lib/core/services/phone/phone_dialer_mobile.dart
// Implementación móvil: llamada directa Android, dialer fallback iOS.
// ============================================================================

import 'dart:io' show Platform;

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'phone_dialer_service.dart';

class MobilePhoneDialerService implements PhoneDialerService {
  const MobilePhoneDialerService();

  @override
  Future<bool> dial(String phoneE164) async {
    if (Platform.isAndroid) {
      try {
        final ok = await FlutterPhoneDirectCaller.callNumber(phoneE164);
        if (ok == true) return true;
      } catch (_) {
        // Fall through al dialer.
      }
    }
    final uri = Uri(scheme: 'tel', path: phoneE164);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }
}
