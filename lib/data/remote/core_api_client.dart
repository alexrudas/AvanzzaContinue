// ============================================================================
// lib/data/remote/core_api_client.dart
// CORE API CLIENT — Cliente Dio para Avanzza Core API.
//
// QUÉ HACE:
// - Provee un Dio configurado para consumir Avanzza Core API.
// - Aplica la base URL desde ApiEndpoints.coreBaseUrl.
// - Agrega Content-Type y Accept application/json.
// - [OrgSwitchInterceptor]: bloquea requests org-scoped sensibles durante
//   switching/validating y adjunta el CancelToken compartido para cancelación.
// - Logger de requests/responses en modo debug.
//
// QUÉ NO HACE:
// - No agrega X-API-Key (Avanzza Core no requiere auth por API key hoy).
// - No reutiliza IntegrationsApiClient ni FirebaseBackendClient.
// - No gestiona tokens de usuario (no hay auth en estos endpoints hoy).
//
// PRINCIPIOS:
// - OrgSwitchInterceptor es la única barrera de bloqueo de requests; no se
//   duplica lógica de bloqueo en repositorios individuales.
// - Cancelaciones de org switch se propagan como OrgContextSwitchingException,
//   distinguible de errores reales de red para que UI no muestre mensajes engañosos.
//
// ENTERPRISE NOTES:
// - CREADO (2026-03): Fase 2 monetización SRCE.
// - MODIFICADO (2026-04): Agregado OrgSwitchInterceptor — deuda sync activeContext.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../core/session/org_switch_exceptions.dart';
import '../../../core/session/org_switch_state.dart';

abstract final class CoreApiClient {
  /// Crea y configura la instancia Dio para Avanzza Core API.
  ///
  /// Incluye [OrgSwitchInterceptor] que bloquea requests org-scoped sensibles
  /// durante cambios de organización activa o validación de contexto en startup.
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

    // Org switch interceptor: bloquea/cancela requests durante switching/validating.
    // Se agrega ANTES del logger para que las requests rechazadas también se logueen.
    dio.interceptors.add(OrgSwitchInterceptor());

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

/// Interceptor que bloquea requests org-scoped sensibles durante cambios de contexto.
///
/// Comportamiento por estado:
/// - [OrgSwitchState.switching]: bloquea TODOS los requests (contexto cambiando).
/// - [OrgSwitchState.validating]: bloquea solo escrituras (POST/PUT/PATCH/DELETE).
///   Las lecturas (GET) se permiten para no degradar la UX de startup.
/// - [OrgSwitchState.idle] / [OrgSwitchState.failed]: requests normales.
///
/// Además, cuando el estado es [idle], adjunta el [OrgSwitchStateHolder.currentCancelToken]
/// a cada request. Esto permite cancelar en masa todas las requests in-flight al inicio
/// del siguiente switch mediante [OrgSwitchStateHolder.cancelAndRotateToken].
///
/// Las requests rechazadas lanzan una [DioException] con
/// [error] = [OrgContextSwitchingException] — distinguible de errores reales de red.
class OrgSwitchInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final holder = OrgSwitchStateHolder();
    final state = holder.state.value;

    if (_shouldBlock(options, state)) {
      debugPrint(
        '[OrgSwitchInterceptor] Blocked ${options.method} ${options.path} '
        '(orgSwitchState=${state.name})',
      );
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: OrgContextSwitchingException(
            'Request blocked by OrgSwitchInterceptor — state=${state.name}',
          ),
        ),
        true,
      );
      return;
    }

    // Adjuntar cancel token compartido cuando el estado es idle.
    // Permite cancelar en masa los requests in-flight al iniciar el siguiente switch.
    if (state == OrgSwitchState.idle) {
      options.cancelToken ??= holder.currentCancelToken;
    }

    handler.next(options);
  }

  /// Determina si la request debe ser bloqueada según el estado actual.
  bool _shouldBlock(RequestOptions options, OrgSwitchState state) {
    switch (state) {
      case OrgSwitchState.switching:
        // Bloquear todas las requests durante un switch activo — ningún request
        // puede mezclarse con contexto viejo y nuevo simultáneamente.
        return true;

      case OrgSwitchState.validating:
        // Solo bloquear escrituras durante la validación de contexto en startup.
        // Las lecturas son seguras con contexto tentativo.
        final method = options.method.toUpperCase();
        return method == 'POST' ||
            method == 'PUT' ||
            method == 'PATCH' ||
            method == 'DELETE';

      case OrgSwitchState.idle:
      case OrgSwitchState.failed:
        // idle: requests normales.
        // failed: el switch falló; contexto previo está intacto — requests normales.
        return false;
    }
  }
}
