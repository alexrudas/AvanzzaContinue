// ============================================================================
// lib/data/remote/interceptors/access_interceptor.dart
// ACCESS INTERCEPTOR — flujo reactivo del subsistema de acceso para Core API.
// ============================================================================
// QUÉ HACE:
// - Lee `body.code` de cada respuesta no-2xx del coreDio y aplica el árbol
//   de decisión canónico del contrato §6:
//     · 401 INVALID_AUTH_TOKEN         → refresh token + 1 retry.
//     · 401 USER_NOT_PROVISIONED       → bootstrap + (refresh si aplica) + 1 retry.
//     · 401 WORKSPACE_CONTEXT_MISSING  → misma rama que USER_NOT_PROVISIONED.
//     · 403 MEMBERSHIP_NOT_FOUND_OR_INACTIVE → bootstrap (1er intento) o bloqueo.
//     · 403 USER_SUSPENDED/INACTIVE/PENDING/MEMBERSHIP_INACTIVE → bloqueo terminal.
//     · 403 CAPABILITY_NOT_GRANTED     → "sin permiso" (nunca bootstrap).
//     · 403 WORKSPACE_NOT_ACTIVE       → workspace picker (nunca bootstrap).
//     · 429 CIRCUIT_READ_RATE_LIMIT    → wait Retry-After + 1 retry.
//     · 5xx                            → surface. NO auto-retry.
// - Respeta los invariantes anti-loop §7:
//     · bootstrap máx 1 vez por sesión (flag en AccessSessionState).
//     · refresh de token máx 1 vez por request (`Options.extra`).
//     · retry original máx 1 vez por request (`Options.extra`).
//     · escudo anti-recursión (`Options.extra[kAccessSkipInterceptorExtra]`).
//     · single-flight mutex en bootstrap.
//
// QUÉ NO HACE:
// - NO intercepta `/v1/auth/bootstrap` ni `/v1/access/me/context`. Esos
//   requests se construyen en `AccessApiClient` con el flag
//   `skipAccessInterceptor: true` (contrato §7.4).
// - NO refresca tokens proactivamente. El SDK de Firebase lo hace; solo
//   refrescamos reactivamente cuando el backend lo pide o cuando un
//   INVALID_AUTH_TOKEN lo justifica.
// - NO navega ni muestra banners. Solo traduce el error HTTP a excepción
//   tipada de dominio; la UI decide UX.
// - NO imprime tokens en logs.
//
// PRINCIPIOS:
// - Determinista: un mismo (status, code, flags) siempre produce la misma
//   rama, sin estado oculto fuera de `AccessSessionState` + `Options.extra`.
// - Deny-by-default: códigos desconocidos se degradan a excepción genérica
//   (la del `remote_exceptions.dart`) sin asumir recuperación.
// - Thin: toda la semántica está en el árbol de decisión; no hay caches ni
//   mapas auxiliares.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §6 + §7.
// - El interceptor se registra al `coreDio` (tag:'core') en `container.dart`.
//   NO se registra al `integrationsDio` (otro contrato de auth).
// ============================================================================

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../application/services/access/access_session_state.dart';
import '../../../domain/entities/access/access_enums.dart';
import '../../../domain/errors/access_exceptions.dart';
import '../../../domain/errors/remote_exceptions.dart';
import '../../../domain/repositories/access_repository.dart';
import '../../sources/remote/access/access_api_client.dart'
    show kAccessSkipInterceptorExtra;

/// Callback que entrega el ID token Firebase actual, refrescándolo si el
/// caller lo pide (`forceRefresh: true`). Sin dependencia directa a
/// `firebase_auth` aquí para mantener el interceptor testeable.
typedef RefreshIdToken = Future<String?> Function({bool forceRefresh});

/// Callback que resuelve el `orgId` local conocido por la app (p. ej. desde
/// `SessionContextController.user.activeContext.orgId`). Retorna null si el
/// cliente no tiene ninguna fuente fiable; en ese caso el interceptor NO
/// envía `orgId` en el body y el servidor decide con el claim o responde
/// 400 ACTIVE_ORG_ID_MISSING (que es manejado como workspace selection).
typedef ResolveLocalOrgId = String? Function();

// Claves internas de `Options.extra` para los contadores por request.
const String _kRetryAttemptExtra = 'accessRetryAttempt';
const String _kRefreshAttemptExtra = 'accessRefreshAttempt';

class AccessInterceptor extends Interceptor {
  final Dio _dio;
  final AccessRepository _repository;
  final AccessSessionState _sessionState;
  final RefreshIdToken _refreshIdToken;
  final ResolveLocalOrgId _resolveLocalOrgId;

  /// [dio] DEBE ser el mismo `coreDio` al que se suscribe este interceptor.
  /// Se usa para `dio.fetch(clonedOptions)` al reintentar, de modo que el
  /// retry pase por los demás interceptores del cliente (p. ej. el bearer
  /// injector) en vez de un Dio paralelo que perdería esa cadena.
  AccessInterceptor({
    required Dio dio,
    required AccessRepository repository,
    required AccessSessionState sessionState,
    required RefreshIdToken refreshIdToken,
    required ResolveLocalOrgId resolveLocalOrgId,
  })  : _dio = dio,
        _repository = repository,
        _sessionState = sessionState,
        _refreshIdToken = refreshIdToken,
        _resolveLocalOrgId = resolveLocalOrgId;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;

    // ── Escudo anti-recursión: bootstrap/context nunca entran aquí ────────
    if (req.extra[kAccessSkipInterceptorExtra] == true) {
      handler.next(err);
      return;
    }

    final status = err.response?.statusCode;
    if (status == null) {
      // Sin respuesta HTTP (timeout, DNS, etc.). Dejar pasar al mapper del
      // caller — no es del dominio de acceso.
      handler.next(err);
      return;
    }

    final body = err.response?.data;
    final code = _readCode(body);

    // ── 401 ────────────────────────────────────────────────────────────────
    if (status == 401) {
      if (code == AccessErrorCode.invalidAuthToken) {
        await _handleInvalidAuthToken(req, err, handler);
        return;
      }
      if (code == AccessErrorCode.userNotProvisioned ||
          code == AccessErrorCode.workspaceContextMissing) {
        await _handleBootstrapRecoverable(req, err, handler, code!);
        return;
      }
      // MISSING_AUTH_TOKEN / UNAUTHENTICATED / TENANT_* → sin recuperación
      // automática aquí: son bug del interceptor upstream o del cliente.
      handler.next(err);
      return;
    }

    // ── 403 ────────────────────────────────────────────────────────────────
    if (status == 403) {
      if (code != null &&
          AccessErrorCode.blockingUserState.contains(code)) {
        _log('blocked state code=$code');
        handler.reject(_wrap(err, AccessBlockedException(_msg(err), code: code)));
        return;
      }
      if (code == AccessErrorCode.capabilityNotGranted) {
        _log('capability denied');
        handler.reject(_wrap(err,
            AccessCapabilityDeniedException.withCode(code!, _msg(err))));
        return;
      }
      if (code == AccessErrorCode.workspaceNotActive) {
        _log('workspace not active');
        handler.reject(_wrap(
            err,
            AccessWorkspaceSelectionRequiredException(_msg(err),
                code: code)));
        return;
      }
      if (code == AccessErrorCode.membershipNotFoundOrInactive) {
        await _handleBootstrapRecoverable(req, err, handler, code!);
        return;
      }
      // PERMISSION_EVALUATION_FAILED y otros 403: surface sin retry.
      handler.next(err);
      return;
    }

    // ── 429 ────────────────────────────────────────────────────────────────
    if (status == 429 && code == AccessErrorCode.circuitReadRateLimit) {
      await _handleRateLimit(req, err, handler);
      return;
    }

    // Resto (400, 404, 5xx, …): surface.
    handler.next(err);
  }

  // --------------------------------------------------------------------------
  // Branch: 401 INVALID_AUTH_TOKEN — refresh + 1 retry.
  // --------------------------------------------------------------------------
  Future<void> _handleInvalidAuthToken(
    RequestOptions req,
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if ((req.extra[_kRefreshAttemptExtra] as int? ?? 0) >= 1) {
      _log('token refresh exhausted');
      handler.reject(_wrap(
          err,
          const AccessTokenRefreshExhaustedException(
              'Firebase ID token refresh exhausted for this request.')));
      return;
    }

    try {
      final newToken = await _refreshIdToken(forceRefresh: true);
      if (newToken == null || newToken.isEmpty) {
        handler.reject(_wrap(
            err,
            const AccessTokenRefreshExhaustedException(
                'getIdToken(forceRefresh) returned null.')));
        return;
      }
      _log('token refreshed; replaying request');
      final response = await _retry(
        req,
        extraOverrides: {_kRefreshAttemptExtra: 1},
        authOverride: 'Bearer $newToken',
      );
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Branch: bootstrap-recoverable (USER_NOT_PROVISIONED,
  // WORKSPACE_CONTEXT_MISSING, MEMBERSHIP_NOT_FOUND_OR_INACTIVE).
  // --------------------------------------------------------------------------
  Future<void> _handleBootstrapRecoverable(
    RequestOptions req,
    DioException err,
    ErrorInterceptorHandler handler,
    String code,
  ) async {
    // ── Terminal: bootstrap ya fue exitoso en esta sesión. Si el backend
    //    sigue reportando el código recuperable, es corrupción de estado.
    if (_sessionState.bootstrapSucceeded) {
      _log('backend still returns $code after successful bootstrap — terminal');
      handler.reject(_wrap(
          err,
          AccessBootstrapExhaustedException(
              'Backend still returns $code after successful bootstrap.',
              code: code)));
      return;
    }

    // ── Terminal: intento previo fue policy blocker u otro error no
    //    recuperable. No hay retry posible hasta logout.
    if (_sessionState.bootstrapTerminal) {
      _log('previous bootstrap terminal — not retrying (code=$code)');
      handler.reject(_wrap(
          err,
          AccessBootstrapExhaustedException(
              'Previous bootstrap attempt was terminal; cannot recover from '
              '$code.',
              code: code)));
      return;
    }

    // Retry counter per-request: solo 1 replay tras bootstrap.
    if ((req.extra[_kRetryAttemptExtra] as int? ?? 0) >= 1) {
      _log('retry already consumed; terminal (code=$code)');
      handler.reject(_wrap(
          err,
          AccessBootstrapExhaustedException(
              'Original request already retried once; aborting.',
              code: code)));
      return;
    }

    // ── PRE-CHECK de orgId: si no tenemos orgId local resoluble, NO podemos
    //    hacer bootstrap. Golpear al backend sólo devolvería 400
    //    ACTIVE_ORG_ID_MISSING y quemaríamos flag bloqueando reintentos
    //    legítimos tras onboarding. Mejor surface a AccessMissingActiveOrg
    //    con outcome RECUPERABLE — cuando el orgId aparezca (membership
    //    hidratada, onboarding completado, workspace switch), el próximo 401
    //    del mismo request o de otros podrá reintentar.
    final localOrgId = _resolveLocalOrgId();
    if (localOrgId == null || localOrgId.isEmpty) {
      _log('cannot bootstrap: no local orgId (code=$code, recoverable)');
      _sessionState.markBootstrapFailedMissingOrgId();
      handler.reject(_wrap(err, const AccessMissingActiveOrgException()));
      return;
    }

    try {
      await _ensureBootstrap();
    } on AccessException catch (accessErr) {
      _log('bootstrap failed: $accessErr');
      handler.reject(_wrap(err, accessErr));
      return;
    } catch (e) {
      _log('bootstrap raw error: $e');
      handler.next(err);
      return;
    }

    try {
      _log('bootstrap complete; replaying original request');
      final response = await _retry(
        req,
        extraOverrides: {_kRetryAttemptExtra: 1},
      );
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Single-flight bootstrap: N requests paralelos disparan 1 bootstrap.
  // El outcome se marca discriminando la causa del fallo — ACTIVE_ORG_ID_MISSING
  // es RECUPERABLE (no cierra la puerta a reintentos), mientras que 401/403
  // (policy blockers) y errores genéricos son TERMINALES.
  // --------------------------------------------------------------------------
  Future<void> _ensureBootstrap() async {
    final inFlight = _sessionState.bootstrapInFlight;
    if (inFlight != null) {
      _log('bootstrap awaiting in-flight future');
      await inFlight;
      return;
    }

    final completer = Completer<void>();
    _sessionState.setBootstrapInFlight(completer.future);

    try {
      final orgId = _resolveLocalOrgId();
      final normalizedOrgId =
          (orgId != null && orgId.isNotEmpty) ? orgId : null;

      // Double-check de orgId: el pre-check del handler ya corta cuando falta,
      // pero si por alguna ruta alternativa llegamos aquí sin orgId, NO
      // golpear al backend — marcar recuperable y salir.
      if (normalizedOrgId == null) {
        _log('cannot bootstrap: no local orgId (double-check)');
        _sessionState.markBootstrapFailedMissingOrgId();
        const err = AccessMissingActiveOrgException();
        completer.completeError(err);
        throw err;
      }

      _log('bootstrap required; calling POST /v1/auth/bootstrap '
          '(orgId=$normalizedOrgId)');
      final result = await _repository.bootstrap(orgId: normalizedOrgId);
      _log('bootstrap completed (orgIdSource=${result.orgIdSource.name})');

      // Contrato §4.4: si el backend pide refresh, hacerlo ANTES del retry.
      if (result.requiresTokenRefresh) {
        _log('token refresh required post-bootstrap');
        await _refreshIdToken(forceRefresh: true);
      }

      _sessionState.markBootstrapSucceeded();
      completer.complete();
    } on BadRequestException catch (e, st) {
      if (e.code == AccessErrorCode.activeOrgIdMissing) {
        // Backend reportó missing orgId → RECUPERABLE. Surface como
        // AccessMissingActiveOrg para mensaje UX claro.
        _log('bootstrap 400 ACTIVE_ORG_ID_MISSING — recoverable');
        _sessionState.markBootstrapFailedMissingOrgId();
        const missing = AccessMissingActiveOrgException();
        completer.completeError(missing, st);
        throw missing;
      }
      // Otras 400 (validation errors) → TERMINAL (bug del cliente).
      _log('bootstrap 400 code=${e.code} — terminal');
      _sessionState.markBootstrapFailedOther();
      completer.completeError(e, st);
      rethrow;
    } on UnauthorizedException catch (e, st) {
      // 401/403 durante bootstrap = policy blocker (USER_SUSPENDED/INACTIVE/
      // PENDING/MEMBERSHIP_INACTIVE). TERMINAL por sesión.
      _log('bootstrap 401/403 — policy blocker, terminal: $e');
      _sessionState.markBootstrapFailedBlockingPolicy();
      completer.completeError(e, st);
      rethrow;
    } catch (e, st) {
      // Red caída, 5xx, shape inválido, timeout, etc. TERMINAL para evitar
      // loops. Logout/workspace switch resetea.
      _log('bootstrap unexpected error — terminal: $e');
      _sessionState.markBootstrapFailedOther();
      completer.completeError(e, st);
      rethrow;
    } finally {
      _sessionState.clearBootstrapInFlight();
    }
  }

  // --------------------------------------------------------------------------
  // Branch: 429 CIRCUIT_READ_RATE_LIMIT — wait Retry-After + 1 retry.
  // --------------------------------------------------------------------------
  Future<void> _handleRateLimit(
    RequestOptions req,
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if ((req.extra[_kRetryAttemptExtra] as int? ?? 0) >= 1) {
      final retryAfter = _readRetryAfterSeconds(err.response) ?? 1;
      _log('rate limit retry exhausted (retryAfter=${retryAfter}s)');
      handler.reject(_wrap(
          err,
          AccessRateLimitedException(
            retryAfterSeconds: retryAfter,
            message: _msg(err),
          )));
      return;
    }

    final retryAfter = _readRetryAfterSeconds(err.response) ?? 1;
    _log('rate limited; waiting ${retryAfter}s before retry');
    await Future<void>.delayed(Duration(seconds: retryAfter));

    try {
      final response = await _retry(
        req,
        extraOverrides: {_kRetryAttemptExtra: 1},
      );
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Retry helper: clona el RequestOptions original con el nuevo token/extras
  // y delega en `_dio.fetch()` para que el replay pase por toda la cadena de
  // interceptores del coreDio (bearer injector, logger, etc.).
  // --------------------------------------------------------------------------
  Future<Response<dynamic>> _retry(
    RequestOptions original, {
    required Map<String, Object> extraOverrides,
    String? authOverride,
  }) async {
    final newHeaders = Map<String, dynamic>.from(original.headers);
    if (authOverride != null) {
      newHeaders['Authorization'] = authOverride;
    }
    final newExtra = Map<String, dynamic>.from(original.extra)
      ..addAll(extraOverrides);

    final cloned = original.copyWith(
      headers: newHeaders,
      extra: newExtra,
    );
    return _dio.fetch<dynamic>(cloned);
  }

  // --------------------------------------------------------------------------
  // Internals puros
  // --------------------------------------------------------------------------

  String? _readCode(Object? body) {
    if (body is Map && body['code'] is String) return body['code'] as String;
    return null;
  }

  String _msg(DioException err) {
    final body = err.response?.data;
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    return err.message ?? 'HTTP ${err.response?.statusCode ?? "?"}';
  }

  int? _readRetryAfterSeconds(Response<dynamic>? res) {
    if (res == null) return null;
    final headers = res.headers;
    final raw = headers.value('retry-after') ?? headers.value('Retry-After');
    if (raw == null) {
      // El backend puede emitirlo también en el body (`retryAfterSeconds`).
      final body = res.data;
      if (body is Map && body['retryAfterSeconds'] is int) {
        return body['retryAfterSeconds'] as int;
      }
      return null;
    }
    return int.tryParse(raw.trim());
  }

  DioException _wrap(DioException original, Object error) =>
      DioException(
        requestOptions: original.requestOptions,
        response: original.response,
        type: original.type,
        error: error,
        stackTrace: original.stackTrace,
        message: original.message,
      );

  void _log(String msg) {
    if (kDebugMode) debugPrint('[ACCESS] $msg');
  }
}
