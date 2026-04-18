// ============================================================================
// lib/data/remote/firebase_backend_client.dart
// FIREBASE BACKEND CLIENT — Cliente Dio para Firebase Cloud Functions de Avanzza.
//
// QUÉ HACE:
// - Provee una instancia Dio configurada para consumir Firebase Cloud Functions.
// - Inyecta automáticamente Authorization: Bearer <firebase-id-token> en cada
//   request vía [_BearerTokenInterceptor].
// - El token se obtiene en tiempo de request (no cacheado aquí — el SDK de
//   Firebase Auth gestiona el refresh automático del token string).
//
// QUÉ NO HACE:
// - No gestiona org switch state ni cancelación de requests (eso es CoreApiClient).
// - No reutiliza CoreApiClient ni IntegrationsApiClient.
// - No cachea el token internamente.
//
// PRINCIPIOS:
// - Cliente dedicado para Firebase Functions — URL y auth scheme distintos a Core API.
// - Bearer token lazy: se obtiene justo antes de despachar cada request.
// - Si no hay usuario autenticado, la request se despacha sin header Authorization
//   y el backend responde 401 (el caller lo maneja como error normal).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04): Deuda de sync activeContext — cliente para llamar
//   switchActiveOrganization y futuros endpoints de Firebase Functions.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/api_endpoints.dart';

abstract final class FirebaseBackendClient {
  /// Crea y configura la instancia Dio para Firebase Cloud Functions.
  ///
  /// La URL base se lee de [ApiEndpoints.firebaseBackendUrl].
  /// En desarrollo con emulador: configurar via --dart-define=AVANZZA_FUNCTIONS_URL=...
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.firebaseBackendUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Bearer token: inyectado automáticamente antes de cada request.
    dio.interceptors.add(_BearerTokenInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('[FirebaseBackendClient] $obj'),
        ),
      );
    }

    return dio;
  }
}

/// Interceptor que inyecta el Firebase ID token como Bearer Authorization header.
///
/// Obtiene el token via [FirebaseAuth.instance.currentUser?.getIdToken()].
/// No fuerza refresh aquí — el SDK de Firebase lo refresca automáticamente
/// cuando expira. El force refresh explícito lo hace el use case en el flujo
/// de switch, ANTES de llamar al backend.
class _BearerTokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Token fetch no-fatal: el backend devolverá 401 si no hay auth.
      // El caller maneja DioException normalmente.
      debugPrint('[FirebaseBackendClient] Warning: token fetch failed — $e');
    }
    handler.next(options);
  }
}
