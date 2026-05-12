// ============================================================================
// lib/core/config/integrations_api_config.dart
// INTEGRATIONS API CONFIG — Credencial + TTLs del módulo Integrations.
//
// QUÉ HACE:
// - Expone la API Key compartida del módulo Integrations (RUNT/SIMIT/VRC).
// - Define TTLs de cache local (Isar) para resultados de RUNT y SIMIT.
//
// QUÉ NO HACE:
// - No define baseUrl — `ApiEndpoints.integrationsBaseUrl` es la única fuente.
// - No define timeouts HTTP — los Dios los configuran inline en
//   `container.dart` (`Duration(seconds: 30)` por defecto).
// - No define paths ni endpoints.
//
// PRINCIPIOS:
// - Scope estricto: credencial (secreta) + TTLs (comportamiento de cache).
// - Nada que sea URL vive acá: eso es `ApiEndpoints`.
//
// ENTERPRISE NOTES:
// MODIFICADO (2026-04): Sunset de `baseUrl` y timeouts. `ApiEndpoints` es
// ahora la única fuente de URLs de Integrations. Este archivo queda solo
// con credencial y TTLs de cache.
// ============================================================================

/// Configuración del módulo Integrations (RUNT, SIMIT, VRC).
abstract final class IntegrationsApiConfig {
  /// API Key requerida en el header `X-API-Key` de todas las requests a
  /// Integrations. Inyectada por `ApiKeyInterceptor`.
  ///
  /// TODO enterprise: sacar a `--dart-define=AVANZZA_INTEGRATIONS_API_KEY`
  /// en una sesión futura. Hoy se mantiene hardcoded por compatibilidad.
  static const String apiKey =
      '4d5c8d89c628309a906002166a8b399d8c3227ed13c065896b8048c10d7c578b';

  // ── TTL de cache Isar ──────────────────────────────────────────────────────

  /// Tiempo de vida del cache de consultas RUNT Persona (24 horas).
  static const Duration runtPersonTtl = Duration(hours: 24);

  /// Tiempo de vida del cache de consultas SIMIT (6 horas).
  static const Duration simitTtl = Duration(hours: 6);
}
