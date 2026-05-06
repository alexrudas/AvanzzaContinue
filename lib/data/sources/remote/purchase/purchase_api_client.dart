// ============================================================================
// lib/data/sources/remote/purchase/purchase_api_client.dart
// PURCHASE API CLIENT — HTTP client contra Core API
// ============================================================================
// QUÉ HACE:
//   - Cliente HTTP único contra avanzza-core-api para el loop comercial
//     admin-captura mono-workspace end-to-end.
//   - Cubre los endpoints del loop completo:
//       POST   /v1/purchase-requests                         → crear
//       GET    /v1/purchase-requests                         → listar por org
//       GET    /v1/purchase-requests/:id                     → detalle con items/targets
//       POST   /v1/purchase-requests/:id/quotes              → registrar cotización
//       GET    /v1/purchase-requests/:id/comparison          → quotes ordenadas
//       POST   /v1/purchase-requests/:id/award               → crear award CONFIRMED
//       GET    /v1/purchase-requests/:id/award               → award activo
//       POST   /v1/sourcing-awards/:id/generate-documents    → emitir OC/OT
//       POST   /v1/purchase-requests/:id/close               → cerrar PR
//       GET    /v1/purchase-requests/:id/summary             → resumen operativo (canClose)
//   - Adjunta Authorization: Bearer <firebase-id-token>.
//   - Mapea DioException a excepciones tipadas (nestjs_exceptions.dart).
//
// QUÉ NO HACE:
//   - No crea interfaces/abstractos: Core API es la única fuente remota.
//   - No envía orgId, requestedBy, awardedBy, issuedBy, closedBy: el backend
//     los deriva del JWT. Enviarlos provocaría 400 por forbidNonWhitelisted.
//   - No encola offline: las escrituras son online-only (TX backend atómica).
//
// PRINCIPIOS:
//   - Contrato 1:1 con DTOs NestJS (sin inventar campos).
//   - Responses devuelven el JSON crudo del backend; el mapper traduce a
//     entidades dominio.
//   - Errores mapeados preservan `code` canónico de NestJS cuando existe.
//
// ENTERPRISE NOTES:
//   - vendorContactId (en submit-quote y create-award) es el mismo valor que
//     `PurchaseRequestTarget.vendorContactId` persistido en backend. Para
//     targets `ActorRef.local` el backend rellena esa columna con el `localId`
//     (≡ LocalContactEntity.id). Para targets `ActorRef.platform` es el
//     platformActorId. El caller Flutter solo reutiliza el mismo id que usó
//     al seleccionar el target en el picker.
//
// See docs/adr/0001-actor-canon.md (regla 2.13 — transición vendorContactIds).
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/core_common/actor_ref.dart';
import '../core_common/nestjs_exceptions.dart';

/// Firebase ID token provider. null si no hay sesión activa.
typedef GetIdToken = Future<String?> Function();

/// Body de POST /v1/purchase-requests (espejo del DTO backend canónico).
///
/// Contrato backend vigente (avanzza-core-api — ADR actor-canon fase 2):
///   title, type?, category?, originType?, assetId?, notes?, delivery?,
///   items[], [vendorActorRefs | vendorContactIds], attestSelf?.
///
/// REGLA DURA: `vendorActorRefs` y `vendorContactIds` son mutuamente
/// excluyentes en el body. Si vienen los dos, el backend responde 400
/// CONFLICTING_VENDOR_REFS. Si vienen vacíos, 400 EMPTY_VENDOR_REFS.
/// Los factories [withActorRefs] y [withLegacyContactIds] garantizan la
/// invariante; los callers nuevos deben usar [withActorRefs].
///
/// `attestSelf=true` autoriza crear LocalRefAttestation server-side en el
/// mismo request. Se envía por default cuando hay ActorRef.local (el
/// backend lo trata como no-op si ya existe attestation).
class CreatePurchaseRequestBody {
  final String title;
  final String? type; // 'PRODUCT' | 'SERVICE'
  final String? category;
  final String? originType; // 'ASSET' | 'INVENTORY' | 'GENERAL'
  final String? assetId;
  final String? notes;
  final CreatePurchaseRequestDelivery? delivery;
  final List<CreatePurchaseRequestItem> items;

  /// Destinatarios en contrato canónico. Null cuando se usa legacy o matching.
  final List<ActorRef>? vendorActorRefs;

  /// LEGACY — IDs opacos de LocalContact. Null cuando se usa canónico.
  /// @deprecated
  final List<String>? vendorContactIds;

  /// (PF2, 2026-04-27) Si true, el backend resuelve targets con
  /// `ProviderMatchingService` (excluye workspace solicitante; redirige
  /// CLAIMED al SELF). En ese modo, vendorActorRefs/vendorContactIds son
  /// ignorados. Null fuera del modo matching.
  final bool? useProviderMatching;

  /// (PF2) Specialty.id obligatoria cuando useProviderMatching=true.
  final String? matchSpecialtyId;

  /// (PF2) AssetType.id opcional para refinar el matching.
  final String? matchAssetTypeId;

  /// Flag de attestation implícita. Null = no enviar al backend.
  final bool? attestSelf;

  const CreatePurchaseRequestBody._({
    required this.title,
    this.type,
    this.category,
    this.originType,
    this.assetId,
    this.notes,
    this.delivery,
    required this.items,
    this.vendorActorRefs,
    this.vendorContactIds,
    this.useProviderMatching,
    this.matchSpecialtyId,
    this.matchAssetTypeId,
    this.attestSelf,
  });

  /// Factory canónico (preferido).
  factory CreatePurchaseRequestBody.withActorRefs({
    required String title,
    String? type,
    String? category,
    String? originType,
    String? assetId,
    String? notes,
    CreatePurchaseRequestDelivery? delivery,
    required List<CreatePurchaseRequestItem> items,
    required List<ActorRef> vendorActorRefs,
    bool? attestSelf,
  }) {
    assert(vendorActorRefs.isNotEmpty, 'vendorActorRefs no puede ser vacío');
    return CreatePurchaseRequestBody._(
      title: title,
      type: type,
      category: category,
      originType: originType,
      assetId: assetId,
      notes: notes,
      delivery: delivery,
      items: items,
      vendorActorRefs: vendorActorRefs,
      attestSelf: attestSelf,
    );
  }

  /// (PF2, 2026-04-27) Factory de matching canónico.
  ///
  /// Ignora `vendorActorRefs`/`vendorContactIds`: el backend
  /// (`ProviderMatchingService`) resuelve targets EXCLUYENDO el workspace
  /// solicitante y redirige automáticamente perfiles CLAIMED a su SELF
  /// dueño. Cumple el invariante multi-actor (target.targetWorkspaceId
  /// nunca igual al workspace del solicitante).
  ///
  /// `matchSpecialtyId` es obligatoria. `matchAssetTypeId` afina la
  /// resolución pero no es requerido.
  factory CreatePurchaseRequestBody.withMatching({
    required String title,
    String? type,
    String? category,
    String? originType,
    String? assetId,
    String? notes,
    CreatePurchaseRequestDelivery? delivery,
    required List<CreatePurchaseRequestItem> items,
    required String matchSpecialtyId,
    String? matchAssetTypeId,
  }) {
    assert(matchSpecialtyId.isNotEmpty, 'matchSpecialtyId no puede ser vacío');
    return CreatePurchaseRequestBody._(
      title: title,
      type: type,
      category: category,
      originType: originType,
      assetId: assetId,
      notes: notes,
      delivery: delivery,
      items: items,
      useProviderMatching: true,
      matchSpecialtyId: matchSpecialtyId,
      matchAssetTypeId: matchAssetTypeId,
    );
  }

  /// Factory legacy. Emitido por callers que aún no migraron.
  ///
  /// DEUDA CON FECHA: retirar antes de `2026-07-20` (ADR actor-canon fase 2).
  /// Enforcement por COMBINACIÓN (ver ADR §8.4): @Deprecated emite warning,
  /// constante + test-guardrail señalan la fecha, ADR ancla la obligación.
  /// Ningún eslabón individual bloquea por sí solo.
  @Deprecated(
    'Usar withActorRefs. '
    'Retirar antes de 2026-07-20 (ADR actor-canon fase 2).',
  )
  factory CreatePurchaseRequestBody.withLegacyContactIds({
    required String title,
    String? type,
    String? category,
    String? originType,
    String? assetId,
    String? notes,
    CreatePurchaseRequestDelivery? delivery,
    required List<CreatePurchaseRequestItem> items,
    required List<String> vendorContactIds,
  }) {
    assert(vendorContactIds.isNotEmpty, 'vendorContactIds no puede ser vacío');
    return CreatePurchaseRequestBody._(
      title: title,
      type: type,
      category: category,
      originType: originType,
      assetId: assetId,
      notes: notes,
      delivery: delivery,
      items: items,
      vendorContactIds: vendorContactIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        if (type != null) 'type': type,
        if (category != null) 'category': category,
        if (originType != null) 'originType': originType,
        if (assetId != null) 'assetId': assetId,
        if (notes != null) 'notes': notes,
        if (delivery != null) 'delivery': delivery!.toJson(),
        'items': items.map((i) => i.toJson()).toList(),
        if (vendorActorRefs != null)
          'vendorActorRefs':
              vendorActorRefs!.map((r) => r.toJson()).toList(),
        if (vendorContactIds != null) 'vendorContactIds': vendorContactIds,
        // (PF2) modo matching canónico — mutuamente excluyente con vendor*.
        if (useProviderMatching == true) 'useProviderMatching': true,
        if (matchSpecialtyId != null) 'matchSpecialtyId': matchSpecialtyId,
        if (matchAssetTypeId != null) 'matchAssetTypeId': matchAssetTypeId,
        // ADR: attestSelf es excepción. Solo viaja cuando es true explícito.
        // Si es null o false, se omite del wire (el backend trata ausencia
        // como default=false).
        if (attestSelf == true) 'attestSelf': true,
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
  static const _awardsBase = '/v1/sourcing-awards';

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
    // Preservar el `code` canónico del body NestJS cuando está presente.
    // Ver ADR 0001 §6 (tabla de errores del contrato).
    final code = body is Map && body['code'] is String
        ? body['code'] as String
        : null;
    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg, code: code);
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

  // ─────────────────────────────────────────────────────────────────────────
  // DETALLE DEL PURCHASE REQUEST (incluye items + targets)
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /v1/purchase-requests/:id — detalle con items y targets.
  /// Necesario para que la UI de detalle conozca `targets[*].id` (UUID del
  /// PurchaseRequestTarget) y `targets[*].vendorContactId`, que son inputs
  /// obligatorios al registrar cotizaciones y crear awards.
  Future<Map<String, dynamic>> fetchPurchaseRequest(String id) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>('$_base/$id', options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'fetchPurchaseRequest: respuesta inesperada ${data.runtimeType}');
    }
    return data;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // QUOTES (registrar cotización recibida off-platform)
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /v1/purchase-requests/:id/quotes — registra una cotización recibida.
  ///
  /// Contrato backend (SubmitQuoteDto):
  ///   - vendorContactId: debe coincidir con el `vendorContactId` del target
  ///     ya creado al enviar el PR. Para ActorRef.local ≡ LocalContactEntity.id.
  ///   - validUntil?: ISO-8601 opcional.
  ///   - currency?: default COP.
  ///   - notes?: libre.
  ///   - items[]: {purchaseRequestItemId, unitPrice, notes?}. Debe cubrir todos
  ///     los ítems del PR; el service valida cobertura total.
  ///
  /// Response: QuoteWithItems (Quote + items[]).
  Future<Map<String, dynamic>> submitQuote({
    required String requestId,
    required String vendorContactId,
    required List<Map<String, dynamic>> items,
    DateTime? validUntil,
    String? currency,
    String? notes,
  }) async {
    assert(vendorContactId.isNotEmpty, 'vendorContactId requerido');
    assert(items.isNotEmpty, 'items no puede ser vacío');

    final body = <String, dynamic>{
      'vendorContactId': vendorContactId,
      if (validUntil != null) 'validUntil': validUntil.toUtc().toIso8601String(),
      if (currency != null && currency.isNotEmpty) 'currency': currency,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      'items': items,
    };

    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/$requestId/quotes',
        data: body,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'submitQuote: respuesta inesperada ${data.runtimeType}');
    }
    return data;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AWARD (adjudicación)
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /v1/purchase-requests/:id/award — crea award CONFIRMED con líneas.
  ///
  /// Contrato (CreateAwardDto):
  ///   - notes?: libre.
  ///   - lines[]: cada línea exige purchaseRequestItemId (UUID), targetId
  ///     (UUID del PurchaseRequestTarget), vendorContactId (coincide con el
  ///     del target), awardedQuantity (positivo, ≤ item.quantity),
  ///     conversionType (OC | OT | OC_AND_OT, coherente con fulfillmentType
  ///     del ítem), poDescription?, otDescription?, notes?.
  ///
  /// Response: AwardWithLines (SourcingAward + lines[]).
  Future<Map<String, dynamic>> createAward({
    required String requestId,
    required List<Map<String, dynamic>> lines,
    String? notes,
  }) async {
    assert(lines.isNotEmpty, 'lines no puede ser vacío');

    final body = <String, dynamic>{
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      'lines': lines,
    };

    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/$requestId/award',
        data: body,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'createAward: respuesta inesperada ${data.runtimeType}');
    }
    return data;
  }

  /// GET /v1/purchase-requests/:id/award — award CONFIRMED activo.
  /// Retorna null si el backend responde 404 (aún no adjudicado).
  Future<Map<String, dynamic>?> fetchAward(String requestId) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        '$_base/$requestId/award',
        options: options,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404) return null;
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) return null;
    return data;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DOCUMENT GENERATION (OC / OT a partir de award)
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /v1/sourcing-awards/:id/generate-documents — emite OC/OT.
  ///
  /// Body vacío por diseño (DTO forbid non-whitelisted). El backend agrupa
  /// líneas por vendor, genera 1 PO por vendor (si tiene OC/OC_AND_OT) y 1 WO
  /// por vendor (si tiene OT/OC_AND_OT). Anti-duplicación server-side:
  /// segunda llamada sobre el mismo award responde 400 DOCUMENTS_ALREADY_GENERATED.
  ///
  /// Response: { awardId, purchaseOrders: [...], workOrders: [...] }.
  Future<Map<String, dynamic>> generateDocuments(String awardId) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_awardsBase/$awardId/generate-documents',
        data: const <String, dynamic>{},
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'generateDocuments: respuesta inesperada ${data.runtimeType}');
    }
    return data;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUMMARY (estado operativo + canClose)
  // ─────────────────────────────────────────────────────────────────────────

  /// GET /v1/purchase-requests/:id/summary — resumen operativo.
  ///
  /// Incluye items, awards, purchaseOrders, workOrders, y el bloque
  /// `completion` con `canClose`, `isOperationallyComplete`, `missingActions[]`.
  /// Es la única fuente para decidir si el botón "Cerrar PR" puede habilitarse.
  Future<Map<String, dynamic>> fetchSummary(String requestId) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        '$_base/$requestId/summary',
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'fetchSummary: respuesta inesperada ${data.runtimeType}');
    }
    return data;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CLOSE PR
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /v1/purchase-requests/:id/close — cierra el PR.
  ///
  /// Body vacío. Backend exige `summary.completion.canClose=true`; si no se
  /// cumple, responde 400 REQUEST_NOT_CLOSABLE con `missingActions[]`.
  ///
  /// Response: PurchaseRequest actualizado (status=closed, closedAt, closedBy).
  Future<Map<String, dynamic>> closePurchaseRequest(String requestId) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/$requestId/close',
        data: const <String, dynamic>{},
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'closePurchaseRequest: respuesta inesperada ${data.runtimeType}');
    }
    return data;
  }
}

class PurchaseRequestListPage {
  final List<Map<String, dynamic>> items;
  final String? nextCursor;
  const PurchaseRequestListPage({required this.items, this.nextCursor});
}
