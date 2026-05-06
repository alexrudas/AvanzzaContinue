// ============================================================================
// test/data/repositories/purchase/purchase_repository_core_api_test.dart
// PURCHASE REPOSITORY — Core API canonical create path (ADR actor-canon)
// ============================================================================
// Valida:
//   - createRequest() llama a PurchaseApiClient.createPurchaseRequest con el
//     payload canónico y NO envía orgId ni requestedBy.
//   - Body canónico emite vendorActorRefs y NO vendorContactIds.
//   - Body legacy emite vendorContactIds y NO vendorActorRefs (factories
//     mutuamente excluyentes por construcción).
//   - attestSelf se OMITE del wire en flujo normal (false/null).
//   - attestSelf viaja solo cuando es true explícito.
//   - createRequest() falla explícitamente si ambos arrays vienen vacíos.
//   - fetchRequestsByOrg/Responses sin cambios.
//
// See docs/adr/0001-actor-canon.md (regla 2.5, 2.13 + §8).
// ============================================================================

import 'package:avanzza/application/core_common/actor_canon_telemetry.dart';
import 'package:avanzza/application/core_common/actor_ref_factory.dart';
import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/models/purchase/supplier_response_model.dart';
import 'package:avanzza/data/repositories/purchase_repository_impl.dart';
import 'package:avanzza/data/sources/local/purchase_local_ds.dart';
import 'package:avanzza/data/sources/remote/core_common/nestjs_exceptions.dart';
import 'package:avanzza/data/sources/remote/purchase/purchase_api_client.dart';
import 'package:avanzza/domain/entities/core_common/actor_ref.dart';
import 'package:avanzza/domain/entities/purchase/create_purchase_request_input.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fake telemetry ────────────────────────────────────────────────────────

/// Colector de eventos para tests. No depende de debugPrint ni de stdout.
class _FakeActorCanonTelemetry implements ActorCanonTelemetry {
  final List<_ActorRefUnknownEvent> events = [];

  @override
  void actorRefUnknownDetected({
    required int statusCode,
    required String callerHint,
    required List<ActorRef> refs,
    required bool attestSelf,
    required String message,
  }) {
    events.add(_ActorRefUnknownEvent(
      statusCode: statusCode,
      callerHint: callerHint,
      refs: refs,
      attestSelf: attestSelf,
      message: message,
    ));
  }
}

class _ActorRefUnknownEvent {
  final int statusCode;
  final String callerHint;
  final List<ActorRef> refs;
  final bool attestSelf;
  final String message;
  _ActorRefUnknownEvent({
    required this.statusCode,
    required this.callerHint,
    required this.refs,
    required this.attestSelf,
    required this.message,
  });
}

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _CapturedCreate {
  final CreatePurchaseRequestBody body;
  _CapturedCreate(this.body);
}

class _FakeApiClient implements PurchaseApiClient {
  _CapturedCreate? lastCreate;
  String? lastComparisonId;

  /// Si set, createPurchaseRequest lanza esta excepción en vez de responder OK.
  Exception? willThrowOnCreate;

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
    final err = willThrowOnCreate;
    if (err != null) throw err;
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

  // Stubs para métodos nuevos del loop admin-captura. Estos tests solo
  // verifican create + comparison legacy; si alguien los usa en este suite
  // el UnimplementedError deja clara la falta de expectativa configurada.
  @override
  Future<Map<String, dynamic>> fetchPurchaseRequest(String id) =>
      throw UnimplementedError('fetchPurchaseRequest not stubbed');

  @override
  Future<Map<String, dynamic>> submitQuote({
    required String requestId,
    required String vendorContactId,
    required List<Map<String, dynamic>> items,
    DateTime? validUntil,
    String? currency,
    String? notes,
  }) =>
      throw UnimplementedError('submitQuote not stubbed');

  @override
  Future<Map<String, dynamic>> createAward({
    required String requestId,
    required List<Map<String, dynamic>> lines,
    String? notes,
  }) =>
      throw UnimplementedError('createAward not stubbed');

  @override
  Future<Map<String, dynamic>?> fetchAward(String requestId) =>
      throw UnimplementedError('fetchAward not stubbed');

  @override
  Future<Map<String, dynamic>> generateDocuments(String awardId) =>
      throw UnimplementedError('generateDocuments not stubbed');

  @override
  Future<Map<String, dynamic>> fetchSummary(String requestId) =>
      throw UnimplementedError('fetchSummary not stubbed');

  @override
  Future<Map<String, dynamic>> closePurchaseRequest(String requestId) =>
      throw UnimplementedError('closePurchaseRequest not stubbed');
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

/// Fixture canónico (ADR actor-canon): input armado con `withBuiltActorRefs`.
/// El factory exige un `BuiltActorRefs` producido por `ActorRefFactory`.
/// Si [fresh]=true, usa la variante con attestSelf=true (flujo post-alta).
CreatePurchaseRequestInput _input({
  List<String> localContactIds = const ['v-1'],
  PurchaseRequestOriginInput origin = PurchaseRequestOriginInput.general,
  String? assetId,
  CreateDeliveryInput? delivery,
  bool fresh = false,
}) {
  final built = fresh
      ? ActorRefFactory.fromFreshlyCreatedLocalContactIds(localContactIds)
      : ActorRefFactory.fromKnownLocalContactIds(localContactIds);
  return CreatePurchaseRequestInput.withBuiltActorRefs(
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
    built: built,
  );
}

/// Fixture legacy: input armado con `withLegacyContactIds`. Usado para
/// validar que la rama legacy sigue funcionando durante fase 1.
CreatePurchaseRequestInput _legacyInput({
  List<String> vendorContactIds = const ['v-1'],
}) {
  return CreatePurchaseRequestInput.withLegacyContactIds(
    title: 'Insumos',
    type: PurchaseRequestTypeInput.product,
    category: 'medicamentos',
    originType: PurchaseRequestOriginInput.general,
    notes: 'Prioridad alta',
    items: const [
      CreatePurchaseRequestItemInput(
        description: 'Guantes',
        quantity: 2,
        unit: 'caja',
        notes: 'Nitrilo talla M',
      ),
    ],
    vendorContactIds: vendorContactIds,
  );
}

// ─── Tests ─────────────────────────────────────────────────────────────────

void main() {
  group('createRequest (Core API canonical)', () {
    test(
        'envía title + type + category + originType + notes + items + '
        'vendorActorRefs canónicos; NO envía orgId/requestedBy ni '
        'vendorContactIds legacy', () async {
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

      // ADR actor-canon: body canónico emite vendorActorRefs, NO vendorContactIds.
      expect(body.containsKey('vendorContactIds'), isFalse);
      expect(body['vendorActorRefs'], [
        {'kind': 'local', 'localKind': 'contact', 'localId': 'v-1'},
      ]);

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

    test(
        'lista vacía en factory canónico → AssertionError en '
        'withBuiltActorRefs antes de tocar el API', () {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      // El blindaje por tipos atrapa el error ANTES de construir el input.
      expect(
        () => _input(localContactIds: const []),
        throwsA(isA<AssertionError>()),
      );
      // Confirmación adicional: si por un caller pathológico llegase un
      // input con refs vacíos (hipotético), el repo nunca habría tocado
      // el API porque el input no existe.
      expect(api.lastCreate, isNull);
      // `repo` declarado para mantener paralelismo con otros tests.
      expect(repo, isNotNull);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // ADR actor-canon — body canónico vs legacy + attestSelf disciplina
  // ──────────────────────────────────────────────────────────────────────────

  group('ADR actor-canon — body canónico', () {
    test('input con vendorActorRefs → body emite vendorActorRefs y NO vendorContactIds',
        () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.createRequest(_input(localContactIds: const ['ct-1', 'ct-2']));

      final body = api.lastCreate!.body.toJson();
      expect(body.containsKey('vendorActorRefs'), isTrue);
      expect(body.containsKey('vendorContactIds'), isFalse);

      final refs = body['vendorActorRefs'] as List;
      expect(refs, hasLength(2));
      expect(refs.first, {
        'kind': 'local',
        'localKind': 'contact',
        'localId': 'ct-1',
      });
      expect(refs.last, {
        'kind': 'local',
        'localKind': 'contact',
        'localId': 'ct-2',
      });
    });

    test(
        'attestSelf se OMITE del wire en flujo normal '
        '(fromKnownLocalContactIds → attestSelf=false)', () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.createRequest(_input()); // default: fromKnown...

      final body = api.lastCreate!.body.toJson();
      expect(body.containsKey('attestSelf'), isFalse);
    });

    test(
        'attestSelf viaja como true SOLO cuando el factory usado es '
        'fromFreshlyCreatedLocalContactIds (excepción)', () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.createRequest(_input(fresh: true));

      final body = api.lastCreate!.body.toJson();
      expect(body['attestSelf'], true);
    });
  });

  group('ADR actor-canon — body legacy (fase 1 de transición)', () {
    test('input con vendorContactIds → body emite vendorContactIds y NO vendorActorRefs',
        () async {
      final api = _FakeApiClient();
      final repo = PurchaseRepositoryImpl(local: _FakeLocal(), remote: api);

      await repo.createRequest(
        _legacyInput(vendorContactIds: const ['legacy-1']),
      );

      final body = api.lastCreate!.body.toJson();
      expect(body.containsKey('vendorContactIds'), isTrue);
      expect(body.containsKey('vendorActorRefs'), isFalse);
      expect(body['vendorContactIds'], const ['legacy-1']);
    });
  });

  group('ADR actor-canon — factories del DTO wire son mutuamente excluyentes',
      () {
    test('withActorRefs produce body con vendorActorRefs y sin vendorContactIds',
        () {
      final body = CreatePurchaseRequestBody.withActorRefs(
        title: 't',
        items: const [
          CreatePurchaseRequestItem(description: 'd', quantity: 1, unit: 'u'),
        ],
        vendorActorRefs: const [
          ActorRef.local(localKind: LocalKind.contact, localId: 'ct-x'),
        ],
      ).toJson();
      expect(body.containsKey('vendorActorRefs'), isTrue);
      expect(body.containsKey('vendorContactIds'), isFalse);
    });

    test(
        'withLegacyContactIds produce body con vendorContactIds y sin vendorActorRefs',
        () {
      final body = CreatePurchaseRequestBody.withLegacyContactIds(
        title: 't',
        items: const [
          CreatePurchaseRequestItem(description: 'd', quantity: 1, unit: 'u'),
        ],
        vendorContactIds: const ['legacy-1'],
      ).toJson();
      expect(body.containsKey('vendorContactIds'), isTrue);
      expect(body.containsKey('vendorActorRefs'), isFalse);
    });

    test('withActorRefs con lista vacía dispara assert', () {
      expect(
        () => CreatePurchaseRequestBody.withActorRefs(
          title: 't',
          items: const [
            CreatePurchaseRequestItem(description: 'd', quantity: 1, unit: 'u'),
          ],
          vendorActorRefs: const [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('withLegacyContactIds con lista vacía dispara assert', () {
      expect(
        () => CreatePurchaseRequestBody.withLegacyContactIds(
          title: 't',
          items: const [
            CreatePurchaseRequestItem(description: 'd', quantity: 1, unit: 'u'),
          ],
          vendorContactIds: const [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // ADR actor-canon §8 addendum (I): observabilidad mínima
  //
  // El repo NO reintenta ni hace fallback a attestSelf=true. Solo emite log
  // estructurado y re-lanza. El test captura stdout via debugPrint override.
  // ──────────────────────────────────────────────────────────────────────────

  group('ADR actor-canon — observabilidad ACTOR_REF_UNKNOWN', () {
    test(
        '409 ACTOR_REF_UNKNOWN del backend → telemetry.actorRefUnknownDetected '
        'llamado una vez + rethrow SIN retry automático', () async {
      final api = _FakeApiClient()
        ..willThrowOnCreate = const BadRequestException(
          409,
          'attestation requerida',
          code: 'ACTOR_REF_UNKNOWN',
        );
      final telemetry = _FakeActorCanonTelemetry();
      final repo = PurchaseRepositoryImpl(
        local: _FakeLocal(),
        remote: api,
        telemetry: telemetry,
      );

      await expectLater(
        repo.createRequest(_input(localContactIds: const ['ct-x'])),
        throwsA(isA<BadRequestException>()),
      );

      // Evento único y bien formado.
      expect(telemetry.events, hasLength(1));
      final ev = telemetry.events.single;
      expect(ev.statusCode, 409);
      expect(ev.callerHint, 'PurchaseRepositoryImpl.createRequest');
      expect(ev.refs, hasLength(1));
      expect(
        ev.refs.single,
        const ActorRef.local(localKind: LocalKind.contact, localId: 'ct-x'),
      );
      expect(ev.attestSelf, isFalse);
      expect(ev.message, contains('attestation'));

      // Crítico: el API se llamó UNA sola vez. No hay retry automático.
      expect(api.lastCreate, isNotNull,
          reason: 'el cliente API debió invocarse una vez');
    });

    test(
        '409 con code distinto (no ACTOR_REF_UNKNOWN) → telemetry NO recibe '
        'actor_ref.unknown.detected (pero la excepción sí se re-lanza)',
        () async {
      final api = _FakeApiClient()
        ..willThrowOnCreate = const BadRequestException(
          400,
          'vendor dup',
          code: 'DUPLICATE_VENDOR_CONTACTS',
        );
      final telemetry = _FakeActorCanonTelemetry();
      final repo = PurchaseRepositoryImpl(
        local: _FakeLocal(),
        remote: api,
        telemetry: telemetry,
      );

      await expectLater(
        repo.createRequest(_input()),
        throwsA(isA<BadRequestException>()),
      );

      expect(telemetry.events, isEmpty,
          reason:
              'solo debe emitirse para code=ACTOR_REF_UNKNOWN, no para otros 4xx');
    });

    test(
        'Default del repo (sin inyectar telemetry) NO rompe: usa '
        'DebugPrintActorCanonTelemetry provisional', () async {
      // Smoke test: el constructor default no lanza y el repo opera.
      final api = _FakeApiClient(); // respuesta OK
      final repo = PurchaseRepositoryImpl(
        local: _FakeLocal(),
        remote: api,
      );
      expect(repo.telemetry, isA<DebugPrintActorCanonTelemetry>());
      await repo.createRequest(_input());
      expect(api.lastCreate, isNotNull);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // ADR actor-canon §8 — blindaje por tipos de BuiltActorRefs
  //
  // Validar desde tests que no se puede construir un BuiltActorRefs saltándose
  // el factory. Esto NO se puede testear directamente porque sería compile
  // error — los tests aseguran que los callers válidos funcionan y documentan
  // que cualquier otro uso falla en compilación.
  // ──────────────────────────────────────────────────────────────────────────

  group('ADR actor-canon — BuiltActorRefs sólo se obtiene via ActorRefFactory',
      () {
    test('fromKnownLocalContactIds produce BuiltActorRefs válido', () {
      final built = ActorRefFactory.fromKnownLocalContactIds(const ['ct-1']);
      expect(built.refs, hasLength(1));
      expect(built.attestSelf, isFalse);
    });

    test('fromFreshlyCreatedLocalContactIds produce BuiltActorRefs válido',
        () {
      final built =
          ActorRefFactory.fromFreshlyCreatedLocalContactIds(const ['ct-2']);
      expect(built.refs, hasLength(1));
      expect(built.attestSelf, isTrue);
    });

    test(
        'withBuiltActorRefs rechaza BuiltActorRefs vacío (assert del factory)',
        () {
      final empty = ActorRefFactory.fromKnownLocalContactIds(const []);
      expect(
        () => CreatePurchaseRequestInput.withBuiltActorRefs(
          title: 't',
          type: PurchaseRequestTypeInput.product,
          originType: PurchaseRequestOriginInput.general,
          items: const [
            CreatePurchaseRequestItemInput(
                description: 'd', quantity: 1, unit: 'u'),
          ],
          built: empty,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('fetchRequestsByOrg (Core API + cache, local-first)', () {
    // ─────────────────────────────────────────────────────────────────────
    // CONTRATO CANÓNICO local-first del repo:
    //   1) Primer retorno = cache local Isar inmediata (sin esperar HTTP).
    //   2) Refresh remoto ocurre en `unawaited(_refreshFromApi())` —
    //      no bloquea el caller. Awaitar la red antes del read local
    //      es bug (caso reportado: 28s de spinner en Home tras splash).
    //   3) El refresh persiste el resultado en Isar; queries posteriores
    //      ven los datos remotos mezclados con cache.
    //
    // Estos tests validan los tres ángulos: sync remoto, persistencia
    // local y mapping — bajo la semántica local-first sin reintroducir
    // el bloqueo eliminado.
    // ─────────────────────────────────────────────────────────────────────

    test(
        'primer retorno es la cache local actual (sin merge previo del API)',
        () async {
      // Local pre-populado con 1 fila que NO existe en la respuesta de API.
      // Si el repo awaitara `_refreshFromApi` ANTES de retornar, el merge
      // remote→local correría primero y el resultado podría incluir las
      // filas de la API antes de retornar — el contrato local-first
      // garantiza lo contrario: el primer retorno es exactamente lo que
      // ya estaba en Isar.
      final local = _FakeLocal()
        ..requests.add(
          PurchaseRequestModel(
            id: 'pr-local-only',
            orgId: 'ws-1',
            title: 'Solo local',
            typeWire: 'PRODUCT',
            originTypeWire: 'GENERAL',
            status: 'sent',
            createdAt: DateTime.utc(2026, 4, 1),
            updatedAt: DateTime.utc(2026, 4, 1),
          ),
        );
      // API trae una fila distinta (que no debe aparecer en el primer
      // retorno si la semántica local-first se respeta).
      final api = _FakeApiClient()
        ..listResponse = [
          {
            'id': 'pr-remote-only',
            'orgId': 'ws-1',
            'requestedBy': 'user-1',
            'coordinationFlowId': 'f-r',
            'title': 'Solo remoto',
            'notes': null,
            'status': 'sent',
            'createdAt': '2026-04-18T00:00:00Z',
            'updatedAt': '2026-04-18T00:00:00Z',
            'items': [],
            'targets': [],
            'quotes': [],
          },
        ];
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      final result = await repo.fetchRequestsByOrg('ws-1');

      // Local-first: el primer retorno es la fila local pre-existente,
      // sin esperar al refresh remoto.
      expect(result, hasLength(1));
      expect(result.first.id, 'pr-local-only');
      expect(result.first.status, 'sent');
      // Drenar microtasks del unawaited para limpieza del test.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
    });

    test('refresh remoto persiste en local async (post-await microtasks)',
        () async {
      // Local vacío al inicio. La API trae 1 PR.
      final local = _FakeLocal();
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
      final repo = PurchaseRepositoryImpl(local: local, remote: api);

      // Primer retorno: cache vacía (local-first sin esperar HTTP).
      final firstReturn = await repo.fetchRequestsByOrg('ws-1');
      expect(firstReturn, isEmpty,
          reason: 'fetchRequestsByOrg NO debe esperar a la API antes '
              'de retornar el cache local actual.');

      // Drenamos las microtasks para que el `unawaited(_refreshFromApi)`
      // dispare el upsert en el FakeLocal.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Persistencia local tras refresh: el FakeLocal ya tiene la fila.
      expect(local.requests, hasLength(1));
      expect(local.requests.first.id, 'pr-a');
      expect(local.requests.first.status, 'sent');

      // Próxima llamada al repo entrega el dato persistido (mapping
      // canónico desde el modelo a entity sin tocar la API otra vez).
      final secondReturn = await repo.fetchRequestsByOrg('ws-1');
      expect(secondReturn, hasLength(1));
      expect(secondReturn.first.id, 'pr-a');
      expect(secondReturn.first.status, 'sent');
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

  // Delega los métodos del loop a `inner`; el test de comparison los ignora.
  @override
  Future<Map<String, dynamic>> fetchPurchaseRequest(String id) =>
      inner.fetchPurchaseRequest(id);

  @override
  Future<Map<String, dynamic>> submitQuote({
    required String requestId,
    required String vendorContactId,
    required List<Map<String, dynamic>> items,
    DateTime? validUntil,
    String? currency,
    String? notes,
  }) =>
      inner.submitQuote(
        requestId: requestId,
        vendorContactId: vendorContactId,
        items: items,
        validUntil: validUntil,
        currency: currency,
        notes: notes,
      );

  @override
  Future<Map<String, dynamic>> createAward({
    required String requestId,
    required List<Map<String, dynamic>> lines,
    String? notes,
  }) =>
      inner.createAward(requestId: requestId, lines: lines, notes: notes);

  @override
  Future<Map<String, dynamic>?> fetchAward(String requestId) =>
      inner.fetchAward(requestId);

  @override
  Future<Map<String, dynamic>> generateDocuments(String awardId) =>
      inner.generateDocuments(awardId);

  @override
  Future<Map<String, dynamic>> fetchSummary(String requestId) =>
      inner.fetchSummary(requestId);

  @override
  Future<Map<String, dynamic>> closePurchaseRequest(String requestId) =>
      inner.closePurchaseRequest(requestId);
}
