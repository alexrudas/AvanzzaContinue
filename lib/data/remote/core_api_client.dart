// ============================================================================
// lib/data/remote/core_api_client.dart
// CORE API CLIENT — Cliente Dio para Avanzza Core API.
//
// QUÉ HACE:
// - Provee una instancia Dio configurada para consumir Avanzza Core API.
// - Aplica la base URL desde ApiEndpoints.coreBaseUrl.
// - Agrega Content-Type y Accept application/json.
// - Logger de requests/responses en modo debug.
//
// QUÉ NO HACE:
// - No agrega X-API-Key (Avanzza Core no requiere auth por API key hoy).
// - No reutiliza IntegrationsApiClient.
// - No inyecta el Firebase Bearer token aquí — cada Api Client (AccessApiClient,
//   ProviderSelfApiClient, etc.) firma sus requests con `getIdToken()` en sus
//   propios `Options.headers` para conservar control granular y skip flags.
//
// ENTERPRISE NOTES:
// - CREADO (2026-03): Fase 2 monetización SRCE.
// - MODIFICADO (2026-04): Eliminado OrgSwitchInterceptor + dependencia de la
//   Cloud Function `switchActiveOrganization`. Core API resuelve `activeOrgId`
//   por inferencia server-side cuando hay 1 membership viable.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/api_endpoints.dart';

abstract final class CoreApiClient {
  /// Crea y configura la instancia Dio para Avanzza Core API.
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
