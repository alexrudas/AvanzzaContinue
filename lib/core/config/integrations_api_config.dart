// ============================================================================
// lib/core/config/integrations_api_config.dart
//
// INTEGRATIONS API CONFIG
//
// Constantes de configuración para la API Avanzza Integrations (RUNT + SIMIT).
// Módulo aislado — no modifica ninguna configuración existente.
// ============================================================================

/// Configuración de la API de integraciones externas (RUNT, SIMIT).
///
/// Usa [IntegrationsApiConfig.baseUrl] como host y [IntegrationsApiConfig.apiKey]
/// como credencial. Todos los servicios del módulo consumen estas constantes.
abstract final class IntegrationsApiConfig {
  /// URL base de la API de integraciones en producción.
  static const String baseUrl = 'http://178.156.227.90/api';

  /// API Key requerida en el header [X-API-Key] de todas las requests.
  static const String apiKey =
      '4d5c8d89c628309a906002166a8b399d8c3227ed13c065896b8048c10d7c578b';

  // ── Timeouts ──────────────────────────────────────────────────────────────

  /// Tiempo máximo para establecer la conexión TCP.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Tiempo máximo para recibir la respuesta completa.
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Tiempo máximo para enviar la request.
  static const Duration sendTimeout = Duration(seconds: 30);

  // ── TTL de cache Isar ─────────────────────────────────────────────────────

  /// Tiempo de vida del cache de consultas RUNT Persona (24 horas).
  static const Duration runtPersonTtl = Duration(hours: 24);

  /// Tiempo de vida del cache de consultas SIMIT (6 horas).
  static const Duration simitTtl = Duration(hours: 6);
}
