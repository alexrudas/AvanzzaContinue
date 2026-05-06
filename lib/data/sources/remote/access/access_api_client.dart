// ============================================================================
// lib/data/sources/remote/access/access_api_client.dart
// ACCESS API CLIENT — Dio HTTP contra Core API del subsistema de acceso.
// ============================================================================
// QUÉ HACE:
//   - Llama GET  /v1/access/me/context y parsea a `AccessContext`.
//   - Llama POST /v1/auth/bootstrap y parsea a `AccessBootstrapResult`.
//   - Inyecta Authorization: Bearer <firebase-id-token>.
//   - Marca ambos requests con `Options.extra['skipAccessInterceptor'] = true`
//     para evitar recursión del `AccessInterceptor` sobre sí mismo (el propio
//     bootstrap no puede disparar otro bootstrap).
//   - Mapea `DioException` a excepciones tipadas del dominio, preservando
//     `body.code`.
//
// QUÉ NO HACE:
//   - No decide si llamar bootstrap. Eso lo decide `AccessGateway` /
//     `AccessInterceptor`.
//   - No reintenta. Un fallo de este cliente es TERMINAL para el llamador.
//   - No imprime tokens. Los logs excluyen headers.
//
// PRINCIPIOS:
//   - Parsing tolerante: claves ausentes → null; enums desconocidos → null.
//     Sólo se lanza `ServerException` si la shape es irrecuperable (p. ej.
//     `requiresAction` ausente o no-string: contrato garantiza que nunca es
//     null, así que tratarlo como error del backend es correcto).
//   - Zero side-effects fuera de la request HTTP.
//
// ENTERPRISE NOTES:
//   - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §1.1 + §1.2 + §7.4.
//   - `skipAccessInterceptor` es el escudo anti-recursión descrito en §7.4
//     del contrato. El interceptor DEBE respetar este flag.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/access/access_bootstrap_result.dart';
import '../../../../domain/entities/access/access_context.dart';
import '../../../../domain/entities/access/access_enums.dart';
import '../../../../domain/errors/remote_exceptions.dart';

typedef GetIdToken = Future<String?> Function();

/// Clave `Options.extra` reconocida por `AccessInterceptor` para saltar la
/// lógica reactiva y evitar recursión. Expuesta como constante pública para
/// que el interceptor y el cliente compartan el mismo identificador.
const String kAccessSkipInterceptorExtra = 'skipAccessInterceptor';

class AccessApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const String _contextPath = '/v1/access/me/context';
  static const String _bootstrapPath = '/v1/auth/bootstrap';

  AccessApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  // --------------------------------------------------------------------------
  // GET /v1/access/me/context
  // --------------------------------------------------------------------------
  Future<AccessContext> getContext() async {
    final options = await _buildOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(_contextPath, options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'getContext: respuesta inesperada ${data.runtimeType}',
      );
    }
    return _parseAccessContext(data, res.statusCode);
  }

  // --------------------------------------------------------------------------
  // POST /v1/auth/bootstrap
  // --------------------------------------------------------------------------
  Future<AccessBootstrapResult> bootstrap({
    String? orgId,
    String? workspaceName,
  }) async {
    final options = await _buildOptions();
    final body = <String, dynamic>{
      if (orgId != null) 'orgId': orgId,
      if (workspaceName != null) 'workspaceName': workspaceName,
    };
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        _bootstrapPath,
        data: body,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'bootstrap: respuesta inesperada ${data.runtimeType}',
      );
    }
    return _parseBootstrapResult(data, res.statusCode);
  }

  // --------------------------------------------------------------------------
  // Internals
  // --------------------------------------------------------------------------

  Future<Options> _buildOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException(
        'No active Firebase session (no ID token).',
      );
    }
    return Options(
      headers: {'Authorization': 'Bearer $token'},
      // Escudo anti-recursión: el AccessInterceptor debe saltar estos dos
      // endpoints. Sin este flag se entraría en bucle al intentar bootstrapear
      // el propio bootstrap (ver contrato §7.4).
      extra: const {kAccessSkipInterceptorExtra: true},
    );
  }

  CoreCommonRemoteException _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == null) {
      return NetworkException(
        'Network failure: ${e.type.name}'
        '${e.message != null ? ' — ${e.message}' : ''}',
      );
    }
    final body = e.response?.data;
    final msg = body is Map && body['message'] is String
        ? body['message'] as String
        : (body?.toString() ?? 'HTTP $status');
    final code = body is Map && body['code'] is String
        ? body['code'] as String
        : null;
    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg, code: code);
  }

  AccessContext _parseAccessContext(Map<String, dynamic> json, int? status) {
    final requiresActionWire = json['requiresAction'] as String?;
    final requiresAction = RequiresAction.fromWire(requiresActionWire);
    if (requiresAction == null) {
      throw ServerException(
        status ?? 0,
        'getContext: "requiresAction" desconocido o ausente '
        '(raw=${requiresActionWire ?? "null"})',
      );
    }

    final capabilities = _parseCapabilities(json['capabilities']);

    return AccessContext(
      isProvisioned: json['isProvisioned'] == true,
      user: _parseUser(json['user']),
      activeOrgId: _optString(json['activeOrgId']),
      activeWorkspace: _parseWorkspace(json['activeWorkspace']),
      membership: _parseMembership(json['membership']),
      capabilities: capabilities,
      requiresAction: requiresAction,
      requiresTokenRefresh: json['requiresTokenRefresh'] == true,
    );
  }

  AccessUser? _parseUser(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final id = _optString(raw['id']);
    final status = AccessUserStatus.fromWire(_optString(raw['status']));
    if (id == null || status == null) return null;
    return AccessUser(id: id, status: status);
  }

  AccessWorkspace? _parseWorkspace(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final id = _optString(raw['id']);
    final orgId = _optString(raw['orgId']);
    final state = AccessWorkspaceState.fromWire(_optString(raw['state']));
    if (id == null || orgId == null || state == null) return null;
    return AccessWorkspace(id: id, orgId: orgId, state: state);
  }

  AccessMembership? _parseMembership(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final id = _optString(raw['id']);
    final status = AccessMembershipStatus.fromWire(_optString(raw['status']));
    if (id == null || status == null) return null;
    return AccessMembership(id: id, status: status);
  }

  List<String> _parseCapabilities(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<String>()
        .toList(growable: false);
  }

  AccessBootstrapResult _parseBootstrapResult(
    Map<String, dynamic> json,
    int? status,
  ) {
    final userId = _optString(json['userId']);
    final workspaceId = _optString(json['workspaceId']);
    final activeOrgId = _optString(json['activeOrgId']);
    final membershipId = _optString(json['membershipId']);
    final orgIdSource = BootstrapOrgIdSource.fromWire(
      _optString(json['orgIdSource']),
    );

    if (userId == null ||
        workspaceId == null ||
        activeOrgId == null ||
        membershipId == null ||
        orgIdSource == null) {
      throw ServerException(
        status ?? 0,
        'bootstrap: shape inesperada — '
        'userId=$userId, workspaceId=$workspaceId, '
        'activeOrgId=$activeOrgId, membershipId=$membershipId, '
        'orgIdSource=${json['orgIdSource']}',
      );
    }

    return AccessBootstrapResult(
      userId: userId,
      workspaceId: workspaceId,
      activeOrgId: activeOrgId,
      orgIdSource: orgIdSource,
      membershipId: membershipId,
      capabilities: _parseCapabilities(json['capabilities']),
      requiresTokenRefresh: json['requiresTokenRefresh'] == true,
    );
  }

  String? _optString(Object? raw) {
    if (raw is String && raw.isNotEmpty) return raw;
    return null;
  }
}
