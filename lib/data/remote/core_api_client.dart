// ============================================================================
// lib/data/remote/core_api_client.dart
// CORE API CLIENT — Cliente Dio para Avanzza Core API.
//
// QUÉ HACE:
// - Provee un Dio configurado para consumir Avanzza Core API
//   (insurance/leads, y futuros endpoints propios del backend).
// - Aplica la base URL desde ApiEndpoints._baseApiUrl (misma que RUNT/SIMIT).
// - Agrega Content-Type y Accept application/json.
// - Agrega logger de requests/responses en modo debug.
//
// QUÉ NO HACE:
// - No agrega X-API-Key (Avanzza Core no requiere auth por API key hoy).
// - No reutiliza IntegrationsApiClient (diferente propósito y auth).
// - No gestiona tokens de usuario (no hay auth en estos endpoints hoy).
//
// PRINCIPIOS:
// - Aislado de IntegrationsApiClient — cliente dedicado a recursos propios.
// - Misma base URL que el global Dio de AppBindings pero instancia separada
//   para no contaminar el Dio global con futura auth de Core.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE — cliente HTTP para
//   /insurance/leads y endpoints futuros de Avanzza Core.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/api_endpoints.dart';

abstract final class CoreApiClient {
  /// Crea y configura la instancia Dio para Avanzza Core API.
  ///
  /// Sin autenticación adicional — los endpoints Core no requieren
  /// X-API-Key ni Authorization header en esta versión.
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.coreBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
        maxRedirects: 3,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('[CoreApiClient] $obj'),
        ),
      );
    }

    return dio;
  }
}
