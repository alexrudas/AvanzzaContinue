// ============================================================================
// lib/data/remote/integrations_api_client.dart
//
// INTEGRATIONS API CLIENT
//
// Cliente HTTP Dio dedicado al módulo de integraciones externas (RUNT, SIMIT).
// Completamente aislado del Dio global de AppBindings.
//
// Responsabilidades:
// - Configurar baseUrl, timeouts y headers comunes.
// - Registrar el interceptor de API key.
// - Proveer logging básico en modo debug.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/integrations_api_config.dart';
import 'interceptors/api_key_interceptor.dart';

/// Fábrica para el cliente Dio del módulo Integrations.
///
/// Uso en binding:
/// ```dart
/// Get.lazyPut<Dio>(() => IntegrationsApiClient.create(), tag: 'integrations');
/// ```
abstract final class IntegrationsApiClient {
  /// Crea y configura la instancia de Dio lista para consumir la API de integraciones.
  ///
  /// Incluye:
  /// - Base URL desde [IntegrationsApiConfig.baseUrl]
  /// - Timeouts estándar del módulo
  /// - Header Content-Type: application/json
  /// - Interceptor de API key ([ApiKeyInterceptor])
  /// - Logger de requests/responses en modo debug
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: IntegrationsApiConfig.baseUrl,
        connectTimeout: IntegrationsApiConfig.connectTimeout,
        receiveTimeout: IntegrationsApiConfig.receiveTimeout,
        sendTimeout: IntegrationsApiConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Seguir redirects automáticamente (por si la API cambia de host).
        followRedirects: true,
        maxRedirects: 3,
      ),
    );

    // Inyecta la API key en cada request automáticamente.
    dio.interceptors.add(ApiKeyInterceptor());

    // Logger básico solo en debug para no exponer datos en producción.
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('[IntegrationsApiClient] $obj'),
        ),
      );
    }

    return dio;
  }
}
