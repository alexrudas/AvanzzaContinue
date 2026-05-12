// ============================================================================
// lib/core/config/api_endpoints.dart
// API ENDPOINTS — Hosts (origin) por dominio. Fuente única de verdad.
//
// QUÉ HACE:
// - Expone el origin (scheme + host + port) de cada API de Avanzza.
// - Cada origin es configurable por `--dart-define` propio.
//
// QUÉ NO HACE:
// - No define path prefixes (`/api`, `/v1`): eso es responsabilidad del
//   consumer que conoce el endpoint concreto.
// - No define aliases por servicio (`runtBaseUrl`, `simitBaseUrl`): el
//   consumer pasa path absoluto explícito (`/api/runt/...`, `/v1/vrc/...`).
// - No define timeouts ni headers ni api keys.
//
// PRINCIPIOS:
// - Una API = un origin = una variable de entorno.
// - Prefijos de ruta viven en el código del service, no acá.
// - Cero workarounds: nada de `Uri.parse(...).origin` ni aliases débiles.
//
// ENTERPRISE NOTES:
// MODIFICADO (2026-04): Eliminado workaround `_integrationsOrigin` y aliases
// `runtBaseUrl`/`simitBaseUrl`. Consumers migrados a paths absolutos.
// ============================================================================

class ApiEndpoints {
  // ==================== CORE API ====================

  /// Core API — dominio principal (Pedidos, Proveedores, Coordinación).
  /// Auth: Bearer Firebase. Endpoints nativos bajo `/v1/...`.
  ///
  /// Ejemplos de uso:
  /// - POST `{coreBaseUrl}/v1/purchase-requests`
  /// - GET  `{coreBaseUrl}/v1/sourcing-awards/:id`
  static String get coreBaseUrl {
    return const String.fromEnvironment(
      'AVANZZA_CORE_URL',
      defaultValue: 'http://192.168.1.57:3000',
    );
  }

  // ==================== INTEGRATIONS API ====================

  /// Integrations API — RUNT / SIMIT / VRC (scraping externo).
  /// Auth: X-API-Key. **Origin puro, sin path prefix.**
  ///
  /// El consumer arma el path completo con su prefijo:
  /// - RUNT Persona:   `{integrationsBaseUrl}/api/runt/person/consult/...`
  /// - SIMIT:          `{integrationsBaseUrl}/api/simit/multas/...`
  /// - VRC individual: `{integrationsBaseUrl}/api/vrc/...`
  /// - RUNT Query:     `{integrationsBaseUrl}/api/runt/query/...`
  /// - VRC Batches:    `{integrationsBaseUrl}/v1/vrc-batches/...`
  ///
  /// Validado en el primer acceso: el valor NO debe terminar en `/api`,
  /// `/api/` ni en `/` (trailing slash) — cualquiera de esos casos produciría
  /// URLs deformadas (`/api/api/...` o `//api/...`) y 404 silenciosos en
  /// release. Si la variable está mal configurada, la app falla al arrancar
  /// con un mensaje accionable en vez de romperse a mitad de una consulta.
  static String get integrationsBaseUrl => _integrationsBaseUrl;

  /// Cached + validated al primer acceso. `static final` garantiza una sola
  /// evaluación; si la validación lanza, se relanza en cada acceso posterior.
  static final String _integrationsBaseUrl = _resolveIntegrationsBaseUrl();

  static String _resolveIntegrationsBaseUrl() {
    const url = String.fromEnvironment(
      'AVANZZA_INTEGRATIONS_URL',
      defaultValue: 'http://178.156.227.90',
    );

    if (url.isEmpty) {
      throw StateError(
        'AVANZZA_INTEGRATIONS_URL está vacío. '
        'Debe ser el origin del host (ej: "http://178.156.227.90").',
      );
    }

    if (url.endsWith('/api') || url.endsWith('/api/')) {
      throw StateError(
        'AVANZZA_INTEGRATIONS_URL mal configurado: "$url".\n'
        'NO debe terminar en "/api" — ese prefijo lo agrega cada service '
        'explícitamente en su path (/api/runt/..., /api/simit/..., '
        '/api/vrc/..., /v1/vrc-batches/...).\n'
        'Valor correcto: "http://host" (sin /api).\n'
        'Si sigues viendo este error, revisa tu flag '
        '--dart-define=AVANZZA_INTEGRATIONS_URL=...',
      );
    }

    if (url.endsWith('/')) {
      throw StateError(
        'AVANZZA_INTEGRATIONS_URL no debe terminar en "/": "$url". '
        'Produce URLs con doble slash ("//api/..."). '
        'Valor correcto: "http://host" (sin slash final).',
      );
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      throw StateError(
        'AVANZZA_INTEGRATIONS_URL debe empezar con http:// o https://: "$url".',
      );
    }

    return url;
  }

  // ==================== FIREBASE FUNCTIONS ====================

  /// Firebase Cloud Functions. Auth: Bearer Firebase (automático).
  static String get firebaseBackendUrl {
    return const String.fromEnvironment(
      'AVANZZA_FUNCTIONS_URL',
      defaultValue:
          'https://southamerica-east1-avanzzaplus-98e47.cloudfunctions.net',
    );
  }

  // ==================== NOTAS DE DESARROLLO ====================

  /// CONFIGURACIÓN POR AMBIENTE
  ///
  /// Dispositivo físico contra Core local + Integrations público:
  ///   flutter run \
  ///     --dart-define=AVANZZA_CORE_URL=http://192.168.1.57:3000 \
  ///     --dart-define=AVANZZA_INTEGRATIONS_URL=http://178.156.227.90
  ///
  /// Emulador Android:
  ///   AVANZZA_CORE_URL=http://10.0.2.2:3000
  ///
  /// Producción:
  ///   AVANZZA_CORE_URL=https://core.avanzza.com
  ///   AVANZZA_INTEGRATIONS_URL=https://integrations.avanzza.com
  ///
  /// ⚠️ MIGRACIÓN: `AVANZZA_INTEGRATIONS_URL` ya NO debe incluir `/api`.
  /// Antes: `http://178.156.227.90/api`
  /// Ahora: `http://178.156.227.90`
  /// El prefijo `/api` lo agrega cada consumer en su path.
}
