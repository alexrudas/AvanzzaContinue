// ============================================================================
// lib/data/sources/remote/purchase/purchase_api_client.dart
// PURCHASE API CLIENT — HTTP client contra Core API (F5 Hito 17)
// ============================================================================
// QUÉ HACE:
//   - Cliente HTTP único contra avanzza-core-api para compras.
//   - Cubre los endpoints que los callers vivos necesitan:
//       POST   /v1/purchase-requests                    → crear
//       GET    /v1/purchase-requests                    → listar por org
//       GET    /v1/purchase-requests/:id/comparison     → respuestas/quotes
//   - Adjunta Authorization: Bearer <firebase-id-token>.
//   - Mapea DioException a excepciones tipadas (nestjs_exceptions.dart).
//
// QUÉ NO HACE:
//   - No crea interfaces/abstractos: Core API es la única fuente remota.
//   - No envía orgId ni requestedBy: el backend los deriva del JWT.
//     Enviarlos provocaría 400 por forbidNonWhitelisted del backend.
//   - No encola offline: la creación es online-only (transacción backend
//     crea CoordinationFlow + PurchaseRequest atómicamente).
// ============================================================================

import 'package:dio/dio.dart';

import '../core_common/nestjs_exceptions.dart';

/// Firebase ID token provider. null si no hay sesión activa.
typedef GetIdToken = Future<String?> Function();

/// Body de POST /v1/purchase-requests (espejo del DTO backend canónico).
///
/// Contrato backend vigente (avanzza-core-api — PurchaseRequest canonical fields):
///   title, type?, category?, originType?, assetId?, notes?, delivery?,
///   items[], vendorContactIds[].
///
/// type y originType son opcionales en el DTO (defaults backend PRODUCT/GENERAL);
/// el cliente los envía siempre que vienen del controller — el backend hace
/// cross-check `originType=ASSET ⇔ assetId`.
class CreatePurchaseRequestBody {
  final String title;
  final String? type; // 'PRODUCT' | 'SERVICE'
  final String? category;
  final String? originType; // 'ASSET' | 'INVENTORY' | 'GENERAL'
  final String? assetId;
  final String? notes;
  final CreatePurchaseRequestDelivery? delivery;
  final List<CreatePurchaseRequestItem> items;
  final List<String> vendorContactIds;

  const CreatePurchaseRequestBody({
    required this.title,
    this.type,
    this.category,
    this.originType,
    this.assetId,
    this.notes,
    this.delivery,
    required this.items,
    required this.vendorContactIds,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        if (type != null) 'type': type,
        if (category != null) 'category': category,
        if (originType != null) 'originType': originType,
        if (assetId != null) 'assetId': assetId,
        if (notes != null) 'notes': notes,
        if (delivery != null) 'delivery': delivery!.toJson(),
        'items': items.map((i) => i.toJson()).toList(),
        'vendorContactIds': vendorContactIds,
      };
}

/// Delivery estructurada. Espejo del `CreateDeliveryDto` backend: cuando se
/// envía, `city` y `address` son obligatorios; `department` e `info` opcionales.
class CreatePurchaseRequestDelivery {
  final String? department;
  final String city;
  final String address;
  final String? info;

  const CreatePurchaseRequestDelivery({
    this.department,
    required this.city,
    required this.address,
    this.info,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (department != null) 'department': department,
        'city': city,
        'address': address,
        if (info != null) 'info': info,
      };
}

class CreatePurchaseRequestItem {
  final String description;
  final num quantity;
  final String unit;
  final String? notes;

  const CreatePurchaseRequestItem({
    required this.description,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'quantity': quantity,
        'unit': unit,
        if (notes != null) 'notes': notes,
      };
}

/// Respuesta del POST (incluye flow + request tras Hito 15).
class StartPurchaseRequestResponse {
  final Map<String, dynamic> flow;
  final Map<String, dynamic> request;
  const StartPurchaseRequestResponse({
    required this.flow,
    required this.request,
  });
}

class PurchaseApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  PurchaseApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  static const _base = '/v1/purchase-requests';

  Future<Options> _authOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException(
        'No active Firebase session (no ID token).',
      );
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  CoreCommonRemoteException _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == null) {
      return NetworkException(
        'Network failure: ${e.type.name}${e.message != null ? ' — ${e.message}' : ''}',
      );
    }
    final body = e.response?.data;
    final msg = body is Map && body['message'] is String
        ? body['message'] as String
        : (body?.toString() ?? 'HTTP $status');
    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg);
  }

  /// POST /v1/purchase-requests — retorna { flow, request }.
  Future<StartPurchaseRequestResponse> createPurchaseRequest(
    CreatePurchaseRequestBody body,
  ) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        _base,
        data: body.toJson(),
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'createPurchaseRequest: respuesta inesperada ${data.runtimeType}',
      );
    }
    final flow = data['flow'];
    final request = data['request'];
    if (flow is! Map<String, dynamic> || request is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'createPurchaseRequest: "flow" o "request" ausente/inválido');
    }
    return StartPurchaseRequestResponse(flow: flow, request: request);
  }

  /// GET /v1/purchase-requests?limit=&cursor= — lista paginada del workspace.
  Future<PurchaseRequestListPage> listPurchaseRequests({
    int? limit,
    String? cursor,
  }) async {
    final options = await _authOptions();
    final query = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (cursor != null) 'cursor': cursor,
    };
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        _base,
        queryParameters: query,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'listPurchaseRequests: respuesta inesperada ${data.runtimeType}');
    }
    final rawItems = data['items'];
    if (rawItems is! List) {
      throw ServerException(res.statusCode ?? 0,
          'listPurchaseRequests: "items" ausente o no es List');
    }
    final items = rawItems.cast<Map<String, dynamic>>();
    final nextCursor = data['nextCursor'] as String?;
    return PurchaseRequestListPage(items: items, nextCursor: nextCursor);
  }

  /// GET /v1/purchase-requests/:id/comparison — quotes ordenadas por total ASC.
  /// Backend puede devolver 400 NO_QUOTES_TO_COMPARE si no hay cotizaciones;
  /// este cliente lo traduce a lista vacía en lugar de excepción (UX coherente
  /// con supplier_responses_sheet que muestra "sin cotizaciones").
  Future<List<Map<String, dynamic>>> fetchComparison(String requestId) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        '$_base/$requestId/comparison',
        options: options,
      );
    } on DioException catch (e) {
      final mapped = _mapDioError(e);
      // Caso común: el PR aún no tiene quotes. No es error de red — UI lo
      // muestra como lista vacía.
      if (mapped is BadRequestException) {
        final body = e.response?.data;
        final code = body is Map ? body['code'] : null;
        if (code == 'NO_QUOTES_TO_COMPARE') return const <Map<String, dynamic>>[];
      }
      throw mapped;
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'fetchComparison: respuesta inesperada ${data.runtimeType}');
    }
    final rawQuotes = data['quotes'];
    if (rawQuotes is! List) return const <Map<String, dynamic>>[];
    return rawQuotes.cast<Map<String, dynamic>>();
  }
}

class PurchaseRequestListPage {
  final List<Map<String, dynamic>> items;
  final String? nextCursor;
  const PurchaseRequestListPage({required this.items, this.nextCursor});
}
