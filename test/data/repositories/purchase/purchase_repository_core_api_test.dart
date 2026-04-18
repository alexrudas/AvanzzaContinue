// ============================================================================
// test/data/repositories/purchase/purchase_repository_core_api_test.dart
// PURCHASE REPOSITORY — Core API migration tests (F5 Hito 17)
// ============================================================================
// Valida:
//   - upsertRequest llama a PurchaseApiClient.createPurchaseRequest con el
//     payload correcto (title, notes, items[0], vendorContactIds) y NO
//     envía orgId ni requestedBy.
//   - upsertRequest hidrata el cache local con el PR canónico devuelto por
//     el backend (no con el id del cliente).
//   - upsertRequest falla explícitamente si vendorContactIds está vacío.
//   - fetchRequestsByOrg refresca desde Core API y devuelve cache local.
//   - fetchResponsesByRequest mapea quotes del backend a
//     SupplierResponseEntity y llena cache local.
// ============================================================================

import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/models/purchase/supplier_response_model.dart';
import 'package:avanzza/data/repositories/purchase_repository_impl.dart';
import 'package:avanzza/data/sources/local/purchase_local_ds.dart';
import 'package:avanzza/data/sources/remote/purchase/purchase_api_client.dart';
import 'package:avanzza/domain/entities/purchase/purchase_request_entity.dart';
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
    'title': 'Filtro',
    'notes': null,
    'status': 'sent',
    'createdAt': '2026-04-18T00:00:00Z',
    'updatedAt': '2026-04-18T00:00:00Z',
    'items': [
      {
        'id': 'it-1',
        'description': 'Filtro',
        'quantity': 2,
        'unit': 'und',
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

PurchaseRequestEntity _entity({
  String id = 'pr-client-99',
  List<String> vendors = const ['v-1'],
}) {
  final now = DateTime.utc(2026, 4, 18);
  return PurchaseRequestEntity(
    id: id,
    orgId: 'ws-1',
    assetId: null,
    tipoRepuesto: 'Filtro',
    specs: 'SAE 15W-40',
    cantidad: 2,
    ciudadEntrega: 'Bogotá',
    proveedorIdsInvitados: vendors,
    estado: 'abierta',
    respuestasCount: 0,
    currencyCode: 'COP',
    createdAt: now,
    updatedAt: now,
  );
}

// ─── Tests ─────────────────────────────────────────────────────────────────

void main() {
  group('upsertRequest (Core API)', () {
    test('envía title + items + vendorContactIds; NO envía orgId/requestedBy',
        () async {
      final api = _FakeApiClient();
      final local = _FakeLocal();
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      await repo.upsertRequest(_entity());

      expect(api.lastCreate, isNotNull);
      final body = api.lastCreate!.body.toJson();
      expect(body['title'], 'Filtro');
      expect(body['vendorContactIds'], ['v-1']);
      expect(body['items'], hasLength(1));
      final item = (body['items'] as List).first as Map;
      expect(item['description'], 'Filtro');
      expect(item['quantity'], 2);
      expect(item['unit'], 'und');

      // Claves prohibidas: el JWT las deriva server-side.
      expect(body.containsKey('orgId'), isFalse);
      expect(body.containsKey('requestedBy'), isFalse);
    });

    test('notes concatena specs + ciudad cuando hay ambos', () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.upsertRequest(_entity());
      final body = api.lastCreate!.body.toJson();
      expect(body['notes'], contains('SAE 15W-40'));
      expect(body['notes'], contains('Ciudad: Bogotá'));
    });

    test('hidrata cache local con el id SERVER-SIDE, no con el del cliente',
        () async {
      final api = _FakeApiClient();
      final local = _FakeLocal();
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      await repo.upsertRequest(_entity(id: 'pr-client-99'));

      expect(local.requests, hasLength(1));
      expect(local.requests.first.id, 'pr-server-1');
      // Y NO quedó el id del cliente.
      expect(local.requests.any((r) => r.id == 'pr-client-99'), isFalse);
    });

    test('vendorContactIds vacío → ArgumentError, sin llamar al API',
        () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await expectLater(
        repo.upsertRequest(_entity(vendors: const [])),
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
            'title': 'Repuesto A',
            'notes': null,
            'status': 'sent',
            'createdAt': '2026-04-18T00:00:00Z',
            'updatedAt': '2026-04-18T00:00:00Z',
            'items': [
              {'id': 'it', 'description': 'Repuesto A', 'quantity': 1, 'unit': 'und'},
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
      expect(result.first.tipoRepuesto, 'Repuesto A');
      expect(result.first.estado, 'abierta'); // sent → abierta
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
      final api = _FakeApiClient();
      // Simular fallo interceptando fetchComparison
      final local = _FakeLocal()
        ..responses.add(SupplierResponseModel(
          id: 'cached-1',
          purchaseRequestId: 'pr-1',
          proveedorId: 'v-x',
          precio: 99.0,
          disponibilidad: 'cotizado',
          currencyCode: 'COP',
        ));
      final repo = PurchaseRepositoryImpl(local: local, remote: _ThrowingApi(api));

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
  Future<PurchaseRequestListPage> listPurchaseRequests({int? limit, String? cursor}) =>
      inner.listPurchaseRequests(limit: limit, cursor: cursor);

  @override
  Future<List<Map<String, dynamic>>> fetchComparison(String requestId) async {
    throw Exception('network fail');
  }
}
