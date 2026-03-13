// ============================================================================
// lib/data/remote/interceptors/api_key_interceptor.dart
//
// API KEY INTERCEPTOR
//
// Inyecta automáticamente el header X-API-Key en cada request que pasa
// por el cliente HTTP del módulo Integrations.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../core/config/integrations_api_config.dart';

/// Interceptor de Dio que agrega el header de autenticación [X-API-Key]
/// a todas las requests salientes del cliente de integraciones.
///
/// Se registra una sola vez en [IntegrationsApiClient] y aplica
/// automáticamente a RUNT, SIMIT y cualquier futuro endpoint del módulo.
class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Agrega la API key como header estándar antes de enviar la request.
    options.headers['X-API-Key'] = IntegrationsApiConfig.apiKey;
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Propaga el error sin modificarlo — el manejo de errores
    // le corresponde al datasource/repository.
    handler.next(err);
  }
}
