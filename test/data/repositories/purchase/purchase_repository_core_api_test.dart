// ============================================================================
// test/data/repositories/purchase/purchase_repository_core_api_test.dart
// PURCHASE REPOSITORY — Core API canonical create path
// ============================================================================
// Valida:
//   - createRequest() llama a PurchaseApiClient.createPurchaseRequest con el
//     payload canónico (title, type, category, originType, assetId, notes,
//     delivery, items[], vendorContactIds) y NO envía orgId ni requestedBy.
//   - createRequest() hidrata el cache local con el PR canónico devuelto por
//     el backend (no con un id cliente).
//   - createRequest() falla explícitamente si vendorContactIds está vacío.
//   - fetchRequestsByOrg refresca desde Core API y devuelve cache local.
//   - fetchResponsesByRequest mapea quotes del backend a
//     SupplierResponseEntity y llena cache local.
// ============================================================================

import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/models/purchase/supplier_response_model.dart';
import 'package:avanzza/data/repositories/purchase_repository_impl.dart';
import 'package:avanzza/data/sources/local/purchase_local_ds.dart';
import 'package:avanzza/data/sources/remote/purchase/purchase_api_client.dart';
import 'package:avanzza/domain/entities/purchase/create_purchase_request_input.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _CapturedCreate {
  final CreatePurchaseRequestBody body;
  _CapturedCreate(this.body);
}

class _FakeApiClient implements PurchaseApiClient {
  _CapturedCreate? lastCreate;
  String? lastComparisonId;

  Map<String, dynamic> createResponseFlow = {
    'id': 'flow-1',
    'sourceWorkspaceId': 'ws-1',
    'relationshipId': null,
    'startedBy': 'user-1',
    'status': 'active',
    'createdAt': '2026-04-18T00:00:00Z',
    'updatedAt': '2026-04-18T00:00:00Z',
  };

  Map<String, dynamic> createResponseRequest = {
    'id': 'pr-server-1',
    'orgId': 'ws-1',
    'requestedBy': 'user-1',
    'coordinationFlowId': 'flow-1',
    'title': 'Insumos',
    'notes': null,
    'status': 'sent',
    'createdAt': '2026-04-18T00:00:00Z',
    'updatedAt': '2026-04-18T00:00:00Z',
    'items': [
      {
        'id': 'it-1',
        'description': 'Guantes',
        'quantity': 2,
        'unit': 'caja',
      },
    ],
    'targets': [
      {'id': 't-1', 'vendorContactId': 'v-1', 'status': 'pending'},
    ],
    'quotes': [],
  };

  List<Map<String, dynamic>> listResponse = [];
  List<Map<String, dynamic>> comparisonResponse = [];

  @override
  Future<StartPurchaseRequestResponse> createPurchaseRequest(
    CreatePurchaseRequestBody body,
  ) async {
    lastCreate = _CapturedCreate(body);
    return StartPurchaseRequestResponse(
      flow: createResponseFlow,
      request: createResponseRequest,
    );
  }

  @override
  Future<PurchaseRequestListPage> listPurchaseRequests({
    int? limit,
    String? cursor,
  }) async {
    return PurchaseRequestListPage(items: listResponse, nextCursor: null);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchComparison(String requestId) async {
    lastComparisonId = requestId;
    return comparisonResponse;
  }
}

class _FakeLocal implements PurchaseLocalDataSource {
  final List<PurchaseRequestModel> requests = [];
  final List<SupplierResponseModel> responses = [];

  @override
  Future<void> upsertRequest(PurchaseRequestModel m) async {
    requests.removeWhere((r) => r.id == m.id);
    requests.add(m);
  }

  @override
  Future<List<PurchaseRequestModel>> requestsByOrg(
    String orgId, {
    String? cityId,
    String? assetId,
  }) async {
    return requests
        .where((r) => orgId.isEmpty || r.orgId == orgId)
        .toList(growable: false);
  }

  @override
  Stream<List<PurchaseRequestModel>> watchRequestsByOrg(String orgId) async* {
    yield requests
        .where((r) => orgId.isEmpty || r.orgId == orgId)
        .toList(growable: false);
  }

  @override
  Future<void> upsertSupplierResponse(SupplierResponseModel m) async {
    responses.removeWhere((r) => r.id == m.id);
    responses.add(m);
  }

  @override
  Future<List<SupplierResponseModel>> responsesByRequest(
    String requestId,
  ) async {
    return responses
        .where((r) => r.purchaseRequestId == requestId)
        .toList(growable: false);
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('PurchaseLocalDataSource.${invocation.memberName}');
}

// ─── Fixtures ──────────────────────────────────────────────────────────────

CreatePurchaseRequestInput _input({
  List<String> vendors = const ['v-1'],
  PurchaseRequestOriginInput origin = PurchaseRequestOriginInput.general,
  String? assetId,
  CreateDeliveryInput? delivery,
}) {
  return CreatePurchaseRequestInput(
    title: 'Insumos',
    type: PurchaseRequestTypeInput.product,
    category: 'medicamentos',
    originType: origin,
    assetId: assetId,
    notes: 'Prioridad alta',
    delivery: delivery,
    items: const [
      CreatePurchaseRequestItemInput(
        description: 'Guantes',
        quantity: 2,
        unit: 'caja',
        notes: 'Nitrilo talla M',
      ),
    ],
    vendorContactIds: vendors,
  );
}

// ─── Tests ─────────────────────────────────────────────────────────────────

void main() {
  group('createRequest (Core API canonical)', () {
    test('envía title + type + category + originType + notes + items + vendors; '
        'NO envía orgId/requestedBy', () async {
      final api = _FakeApiClient();
      final local = _FakeLocal();
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      await repo.createRequest(_input());

      expect(api.lastCreate, isNotNull);
      final body = api.lastCreate!.body.toJson();
      expect(body['title'], 'Insumos');
      expect(body['type'], 'PRODUCT');
      expect(body['category'], 'medicamentos');
      expect(body['originType'], 'GENERAL');
      expect(body['notes'], 'Prioridad alta');
      expect(body['vendorContactIds'], ['v-1']);
      expect(body['items'], hasLength(1));
      final item = (body['items'] as List).first as Map;
      expect(item['description'], 'Guantes');
      expect(item['quantity'], 2);
      expect(item['unit'], 'caja');
      expect(item['notes'], 'Nitrilo talla M');

      // Sin delivery ni assetId cuando no se proveen.
      expect(body.containsKey('delivery'), isFalse);
      expect(body.containsKey('assetId'), isFalse);

      // Claves prohibidas: el JWT las deriva server-side.
      expect(body.containsKey('orgId'), isFalse);
      expect(body.containsKey('requestedBy'), isFalse);
    });

    test('incluye delivery estructurada cuando se provee', () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.createRequest(_input(
        delivery: const CreateDeliveryInput(
          department: 'Atlántico',
          city: 'Barranquilla',
          address: 'Cra 45 # 10-20',
          info: 'Piso 3',
        ),
      ));

      final body = api.lastCreate!.body.toJson();
      final delivery = body['delivery'] as Map<String, dynamic>;
      expect(delivery['city'], 'Barranquilla');
      expect(delivery['address'], 'Cra 45 # 10-20');
      expect(delivery['department'], 'Atlántico');
      expect(delivery['info'], 'Piso 3');
    });

    test('incluye assetId cuando originType=ASSET', () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.createRequest(_input(
        origin: PurchaseRequestOriginInput.asset,
        assetId: '11111111-1111-1111-1111-111111111111',
      ));

      final body = api.lastCreate!.body.toJson();
      expect(body['originType'], 'ASSET');
      expect(body['assetId'], '11111111-1111-1111-1111-111111111111');
    });

    test('hidrata cache local con el id SERVER-SIDE', () async {
      final api = _FakeApiClient();
      final local = _FakeLocal();
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      await repo.createRequest(_input());

      expect(local.requests, hasLength(1));
      expect(local.requests.first.id, 'pr-server-1');
    });

    test('vendorContactIds vacío → ArgumentError, sin llamar al API',
        () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await expectLater(
        repo.createRequest(_input(vendors: const [])),
        throwsArgumentError,
      );
      expect(api.lastCreate, isNull);
    });
  });

  group('fetchRequestsByOrg (Core API + cache)', () {
    test('refresca desde API y devuelve cache local mapeado', () async {
      final api = _FakeApiClient()
        ..listResponse = [
          {
            'id': 'pr-a',
            'orgId': 'ws-1',
            'requestedBy': 'user-1',
            'coordinationFlowId': 'f-a',
            'title': 'Solicitud A',
            'notes': null,
            'status': 'sent',
            'createdAt': '2026-04-18T00:00:00Z',
            'updatedAt': '2026-04-18T00:00:00Z',
            'items': [
              {'id': 'it', 'description': 'Item A', 'quantity': 1, 'unit': 'und'},
            ],
            'targets': [
              {'id': 't-a', 'vendorContactId': 'v-a', 'status': 'pending'},
            ],
            'quotes': [],
          },
        ];
      final local = _FakeLocal();
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      final result = await repo.fetchRequestsByOrg('ws-1');

      expect(result, hasLength(1));
      expect(result.first.id, 'pr-a');
      expect(result.first.status, 'sent');
      expect(local.requests, hasLength(1));
    });
  });

  group('fetchResponsesByRequest (Core API comparison)', () {
    test('mapea quotes del backend a SupplierResponseEntity y cachea',
        () async {
      final api = _FakeApiClient()
        ..comparisonResponse = [
          {
            'id': 'q-1',
            'purchaseRequestId': 'pr-1',
            'vendorContactId': 'v-1',
            'total': '150.00',
            'currency': 'COP',
            'notes': 'Disponible 48h',
            'createdAt': '2026-04-18T00:00:00Z',
            'updatedAt': '2026-04-18T00:00:00Z',
          },
        ];
      final local = _FakeLocal();
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      final result = await repo.fetchResponsesByRequest('pr-1');

      expect(api.lastComparisonId, 'pr-1');
      expect(result, hasLength(1));
      expect(result.first.id, 'q-1');
      expect(result.first.proveedorId, 'v-1');
      expect(result.first.precio, 150.0);
      expect(result.first.currencyCode, 'COP');
      expect(local.responses, hasLength(1));
    });

    test('si API falla, devuelve cache local (no excepción)', () async {
      final inner = _FakeApiClient();
      final local = _FakeLocal()
        ..responses.add(SupplierResponseModel(
          id: 'cached-1',
          purchaseRequestId: 'pr-1',
          proveedorId: 'v-x',
          precio: 99.0,
          disponibilidad: 'cotizado',
          currencyCode: 'COP',
        ));
      final repo =
          PurchaseRepositoryImpl(local: local, remote: _ThrowingApi(inner));

      final result = await repo.fetchResponsesByRequest('pr-1');

      expect(result, hasLength(1));
      expect(result.first.id, 'cached-1');
    });
  });
}

/// Wrapper que fuerza fallo en fetchComparison.
class _ThrowingApi implements PurchaseApiClient {
  final _FakeApiClient inner;
  _ThrowingApi(this.inner);

  @override
  Future<StartPurchaseRequestResponse> createPurchaseRequest(body) =>
      inner.createPurchaseRequest(body);

  @override
  Future<PurchaseRequestListPage> listPurchaseRequests(
          {int? limit, String? cursor}) =>
      inner.listPurchaseRequests(limit: limit, cursor: cursor);

  @override
  Future<List<Map<String, dynamic>>> fetchComparison(String requestId) async {
    throw Exception('network fail');
  }
}
