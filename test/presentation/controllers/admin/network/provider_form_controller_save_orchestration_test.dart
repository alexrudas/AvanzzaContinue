// ============================================================================
// test/presentation/controllers/admin/network/provider_form_controller_save_orchestration_test.dart
// ProviderFormController.save() — orquestación canónica (Hito 1)
// ============================================================================
// Cubre los 7 escenarios mínimos del flujo
//   LocalContact.save → match-candidate.probe → POST /v1/providers
//   → cache linkedProviderProfileId → PUT /v1/providers/:id/specialties
//
// 1. CREATE happy path (probe + POST + cache + PUT).
// 2. EDIT happy path (GET + PUT, sin POST, sin probe).
// 3. Kill-switch OFF (solo LocalContact, cero Core API calls).
// 4. AMBIGUOUS_PLATFORM_ACTOR_MATCH (log + propagate exception).
// 5. LOCAL_REF_NOT_FOUND (POST falla tras probe; no toca PUT ni cache).
// 6. GET 404 en EDIT (limpia cache + recursive a CREATE flow).
// 7. PUT specialties falla después de POST (linked id queda cacheado;
//    error informado al caller).
//
// Patrón: fakes manuales con `noSuchMethod` (mismo estilo del proyecto,
// ver `network_operational_controller_test.dart`). Cero mockito/mocktail.
// ============================================================================

import 'package:avanzza/domain/entities/catalog/specialty_entity.dart'
    show SpecialtyKind;
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/entities/core_common/match_candidate_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/normalized_key.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/verified_key_type.dart';
import 'package:avanzza/domain/entities/provider/provider_canonical_entity.dart';
import 'package:avanzza/domain/entities/workspace/workspace_asset_type_entity.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:avanzza/domain/repositories/core_common/local_contact_repository.dart';
import 'package:avanzza/domain/repositories/provider/provider_canonical_repository.dart';
import 'package:avanzza/domain/repositories/workspace/workspace_asset_type_repository.dart';
import 'package:avanzza/data/sources/remote/core_common/match_candidate_nestjs_ds.dart';
import 'package:avanzza/presentation/controllers/admin/network/provider_form_controller.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Constantes y helpers ──────────────────────────────────────────────────

const _orgId = 'ws-1';
const _providerProfileId = 'pp-1';
const _platformActorId = 'pa-1';
final _now = DateTime.utc(2026, 4, 26, 12);
final _later = DateTime.utc(2026, 4, 26, 12, 5);

ProviderCanonicalEntity _provider({
  String id = _providerProfileId,
  bool isActive = true,
  List<ProviderCanonicalSpecialty> specialties = const [],
  DateTime? updatedAt,
}) {
  return ProviderCanonicalEntity(
    providerProfileId: id,
    workspaceId: _orgId,
    platformActorId: _platformActorId,
    displayName: 'Lubricentro X',
    actorKind: ProviderActorKind.organization,
    legalName: 'Lubricentro X SAS',
    fullLegalName: null,
    isActive: isActive,
    responseRateAvg: null,
    notes: null,
    specialties: specialties,
    createdAt: _now,
    updatedAt: updatedAt ?? _now,
  );
}

ProviderCanonicalSpecialty _specialty(String id) =>
    ProviderCanonicalSpecialty(
      id: id,
      key: '$id.k',
      name: id,
      kind: SpecialtyKind.service,
    );

LocalContactEntity _existing({String? linkedProviderProfileId}) {
  return LocalContactEntity(
    id: 'lc-1',
    workspaceId: _orgId,
    displayName: 'Lubricentro X',
    createdAt: _now,
    updatedAt: _now,
    primaryPhoneE164: '+573001234567',
    primaryEmail: 'a@b.co',
    docId: '900123456',
    roleLabel: 'proveedor',
    linkedProviderProfileId: linkedProviderProfileId,
  );
}

// ─── Fakes ─────────────────────────────────────────────────────────────────

class _FakeContacts implements LocalContactRepository {
  /// Histórico de saves para verificar orden + payload.
  final List<LocalContactEntity> savedHistory = [];

  /// Resultado de `getById`. Inyectable.
  LocalContactEntity? getByIdResult;

  /// Tira al `save()`. Solo los tests específicos lo configuran.
  Object? saveWillThrow;

  @override
  Future<void> save(LocalContactEntity contact) async {
    if (saveWillThrow != null) throw saveWillThrow!;
    savedHistory.add(contact);
  }

  @override
  Future<LocalContactEntity?> getById(String id) async => getByIdResult;

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('LocalContactRepository.${invocation.memberName}');
}

class _FakeProviders implements ProviderCanonicalRepository {
  /// Llamadas registradas con argumentos (orden + count).
  final List<ProvisionProviderInput> provisionCalls = [];
  final List<String> getByIdCalls = [];
  final List<({String id, Set<String> ids, DateTime updatedAt})>
      replaceSpecialtiesCalls = [];

  Object? provisionWillThrow;
  Object? getByIdWillThrow;
  Object? replaceWillThrow;

  ProviderCanonicalEntity provisionResult = _provider();
  ProviderCanonicalEntity getByIdResult = _provider();
  ProviderCanonicalEntity replaceResult = _provider();

  @override
  Future<ProviderCanonicalEntity> provision(ProvisionProviderInput input) async {
    provisionCalls.add(input);
    if (provisionWillThrow != null) throw provisionWillThrow!;
    return provisionResult;
  }

  @override
  Future<ProviderCanonicalEntity> getById(String providerProfileId) async {
    getByIdCalls.add(providerProfileId);
    if (getByIdWillThrow != null) throw getByIdWillThrow!;
    return getByIdResult;
  }

  @override
  Future<ProviderCanonicalEntity> replaceSpecialties({
    required String providerProfileId,
    required Set<String> specialtyIds,
    required DateTime providerProfileUpdatedAt,
  }) async {
    replaceSpecialtiesCalls.add((
      id: providerProfileId,
      ids: specialtyIds,
      updatedAt: providerProfileUpdatedAt,
    ));
    if (replaceWillThrow != null) throw replaceWillThrow!;
    return replaceResult;
  }
}

class _FakeProbe implements MatchCandidateNestJsDataSource {
  final List<({TargetLocalKind localKind, String localId, List<NormalizedKey> probes})>
      calls = [];
  Object? willThrow;

  @override
  Future<List<MatchCandidateEntity>> probe({
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  }) async {
    calls.add((localKind: localKind, localId: localId, probes: probes));
    if (willThrow != null) throw willThrow!;
    return const [];
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(
          'MatchCandidateNestJsDataSource.${invocation.memberName}');
}

class _FakeWorkspaceAssetTypes implements WorkspaceAssetTypeRepository {
  /// Resultado de `listActive`. Por default lista vacía — no afecta los
  /// tests de orquestación que no ejercitan el dropdown.
  List<WorkspaceAssetTypeEntity> result = const [];

  /// Si se setea, `listActive` lanza este error en vez de retornar `result`.
  Object? willThrow;

  /// Conteo de invocaciones para asserts en tests específicos del loader.
  int callCount = 0;

  @override
  Future<List<WorkspaceAssetTypeEntity>> listActive() async {
    callCount++;
    if (willThrow != null) throw willThrow!;
    return result;
  }
}

// ─── Setup builder ──────────────────────────────────────────────────────────

ProviderFormController _makeController({
  required _FakeContacts contacts,
  required _FakeProviders providers,
  required _FakeProbe probe,
  _FakeWorkspaceAssetTypes? workspaceAssetTypes,
  String? editingProviderId,
  bool? enableCanonicalIntegrationOverride,
}) {
  return ProviderFormController(
    contacts: contacts,
    providers: providers,
    matchCandidateProbe: probe,
    workspaceAssetTypes: workspaceAssetTypes ?? _FakeWorkspaceAssetTypes(),
    orgId: _orgId,
    editingProviderId: editingProviderId,
    defaultCountryId: 'CO',
    enableCanonicalIntegrationOverride: enableCanonicalIntegrationOverride,
  );
}

void _seedFormState(ProviderFormController c, {Set<String> specialtyIds = const {}}) {
  // Mínimo necesario para pasar `validateForSave`.
  c.displayName.value = 'Lubricentro X';
  c.primaryPhone.value = '+573001234567';
  c.primaryEmail.value = 'a@b.co';
  c.docId.value = '900123456';
  if (specialtyIds.isNotEmpty) {
    c.applySelectedSpecialties(specialtyIds);
  }
}

// ─── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('ProviderFormController.save() — orquestación canónica (Hito 1)', () {
    late _FakeContacts contacts;
    late _FakeProviders providers;
    late _FakeProbe probe;

    setUp(() {
      contacts = _FakeContacts();
      providers = _FakeProviders();
      probe = _FakeProbe();
    });

    // ── 1. CREATE happy path ───────────────────────────────────────────────
    test('CREATE happy path: save → probe → POST → cache linked id → PUT', () async {
      providers.provisionResult = _provider(updatedAt: _now);
      providers.replaceResult = _provider(
        updatedAt: _later,
        specialties: [_specialty('sp-1'), _specialty('sp-2')],
      );

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
      );
      c.onInit();
      _seedFormState(c, specialtyIds: {'sp-1', 'sp-2'});

      final err = await c.save();

      expect(err, isNull);
      // Orden de saves de LocalContact: snapshot inicial + segundo save
      // tras POST con linkedProviderProfileId cacheado.
      expect(contacts.savedHistory, hasLength(2));
      expect(contacts.savedHistory[0].linkedProviderProfileId, isNull);
      expect(contacts.savedHistory[1].linkedProviderProfileId,
          equals(_providerProfileId));
      // Probe disparado con keyType correctos.
      expect(probe.calls, hasLength(1));
      expect(probe.calls[0].localKind, TargetLocalKind.contact);
      expect(probe.calls[0].probes.map((k) => k.keyType.wireName),
          containsAll(['phoneE164', 'email', 'docId']));
      // POST disparado UNA vez.
      expect(providers.provisionCalls, hasLength(1));
      expect(providers.provisionCalls[0].source.kind,
          ProvisionProviderSourceKind.localContact);
      // PUT disparado con specialtyIds + updatedAt del POST.
      expect(providers.replaceSpecialtiesCalls, hasLength(1));
      expect(providers.replaceSpecialtiesCalls[0].id, _providerProfileId);
      expect(providers.replaceSpecialtiesCalls[0].ids, {'sp-1', 'sp-2'});
      expect(providers.replaceSpecialtiesCalls[0].updatedAt, _now);
      // GET no debe haberse llamado (CREATE flow).
      expect(providers.getByIdCalls, isEmpty);
    });

    // ── 2. EDIT happy path ─────────────────────────────────────────────────
    test('EDIT happy path: linked existe → GET → PUT, sin POST ni probe', () async {
      final existing = _existing(linkedProviderProfileId: _providerProfileId);
      contacts.getByIdResult = existing;
      providers.getByIdResult = _provider(updatedAt: _now);
      providers.replaceResult = _provider(
        updatedAt: _later,
        specialties: [_specialty('sp-3')],
      );

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        editingProviderId: existing.id,
      );
      c.onInit();
      // Esperar la hidratación async post-onInit.
      await Future<void>.delayed(Duration.zero);
      _seedFormState(c, specialtyIds: {'sp-3'});

      final err = await c.save();

      expect(err, isNull);
      // POST NO debe llamarse en EDIT flow.
      expect(providers.provisionCalls, isEmpty,
          reason: 'EDIT flow no debe disparar POST');
      // Probe NO debe llamarse (provider ya vinculado).
      expect(probe.calls, isEmpty,
          reason: 'EDIT flow no debe disparar probe');
      // GET sí: una en hidratación + una en save = 2.
      expect(providers.getByIdCalls.length, greaterThanOrEqualTo(1));
      // PUT con specialtyIds correctos.
      expect(providers.replaceSpecialtiesCalls, hasLength(1));
      expect(providers.replaceSpecialtiesCalls[0].id, _providerProfileId);
      expect(providers.replaceSpecialtiesCalls[0].ids, {'sp-3'});
    });

    // ── 3. Kill-switch OFF ─────────────────────────────────────────────────
    test('Kill-switch OFF: solo LocalContact save, cero Core API calls', () async {
      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        enableCanonicalIntegrationOverride: false,
      );
      c.onInit();
      _seedFormState(c, specialtyIds: {'sp-x'});

      final err = await c.save();

      expect(err, isNull);
      // Una sola escritura local.
      expect(contacts.savedHistory, hasLength(1));
      // Cero llamadas a Core API.
      expect(providers.provisionCalls, isEmpty);
      expect(providers.getByIdCalls, isEmpty);
      expect(providers.replaceSpecialtiesCalls, isEmpty);
      expect(probe.calls, isEmpty);
    });

    // ── 4. AMBIGUOUS_PLATFORM_ACTOR_MATCH ──────────────────────────────────
    test('AMBIGUOUS: rethrow + cache NO se actualiza + PUT no se llama',
        () async {
      providers.provisionWillThrow = const AmbiguousPlatformActorException(
        'multiple matches',
        candidates: [
          AmbiguousPlatformActorCandidate(
            platformActorId: 'pa-A',
            displayName: 'A',
            matchedKeys: ['phoneE164'],
          ),
          AmbiguousPlatformActorCandidate(
            platformActorId: 'pa-B',
            displayName: 'B',
            matchedKeys: ['docId'],
          ),
        ],
      );

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
      );
      c.onInit();
      _seedFormState(c, specialtyIds: {'sp-1'});

      // El controller propaga la excepción para que la page la capture.
      AmbiguousPlatformActorException? captured;
      try {
        await c.save();
      } on AmbiguousPlatformActorException catch (e) {
        captured = e;
      }

      expect(captured, isNotNull,
          reason: 'AmbiguousPlatformActorException debe propagarse');
      expect(captured!.candidates, hasLength(2));
      // El primer save de LocalContact (snapshot inicial) sí ocurrió.
      // Pero NO debe haber un segundo save con linkedProviderProfileId.
      expect(contacts.savedHistory, hasLength(1));
      expect(contacts.savedHistory[0].linkedProviderProfileId, isNull);
      // Probe sí corrió (es antes del POST).
      expect(probe.calls, hasLength(1));
      // POST disparado pero falló con AMBIGUOUS.
      expect(providers.provisionCalls, hasLength(1));
      // PUT NO se llamó.
      expect(providers.replaceSpecialtiesCalls, isEmpty);
    });

    // ── 5. LOCAL_REF_NOT_FOUND ─────────────────────────────────────────────
    test('LOCAL_REF_NOT_FOUND tras provision: error humano + cero PUT', () async {
      providers.provisionWillThrow =
          const LocalRefNotFoundException('no attestation');

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
      );
      c.onInit();
      _seedFormState(c, specialtyIds: {'sp-1'});

      final err = await c.save();

      expect(err, isNotNull);
      expect(err!.toLowerCase(), contains('reintenta'));
      // Probe disparado (paso previo al POST).
      expect(probe.calls, hasLength(1));
      // POST disparado pero falló.
      expect(providers.provisionCalls, hasLength(1));
      // Cache linkedProviderProfileId NO se actualizó.
      expect(contacts.savedHistory, hasLength(1));
      expect(contacts.savedHistory[0].linkedProviderProfileId, isNull);
      // PUT NO se llamó.
      expect(providers.replaceSpecialtiesCalls, isEmpty);
    });

    // ── 6. GET 404 en EDIT → fallback a CREATE flow ────────────────────────
    test('GET 404 en EDIT: limpia cache + recursive CREATE flow', () async {
      // Setup: contacto existente vinculado a un providerProfileId obsoleto.
      // El GET en `save()` tira 404 → controller limpia el cache y
      // reintenta como CREATE (linkedProviderProfileId pasa a null).
      // En el segundo intento ya NO entra a EDIT branch, así que el GET
      // no se vuelve a invocar.
      final existing = _existing(linkedProviderProfileId: 'pp-stale');
      contacts.getByIdResult = existing;
      providers.provisionResult = _provider(
        id: 'pp-fresh',
        updatedAt: _now,
      );

      // GET tira 404 SIEMPRE en este test. Esto es seguro porque:
      //   - El primer save() entra a EDIT branch → GET → 404.
      //   - El controller limpia linkedProviderProfileId y RECURSE save().
      //   - El segundo save() entra a CREATE branch → no llama GET.
      providers.getByIdWillThrow =
          const ProviderProfileNotFoundException('gone');

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        editingProviderId: existing.id,
      );
      c.onInit();
      // Esperar hidratación async (también dispara GET y limpia cache).
      // Tras la hidratación, el `_original` ya quedó con
      // linkedProviderProfileId=null porque el método de hidratación
      // captura ProviderProfileNotFoundException y limpia.
      await Future<void>.delayed(Duration.zero);
      _seedFormState(c, specialtyIds: const {});

      // Reset histories para medir solo el save() del usuario.
      contacts.savedHistory.clear();
      providers.getByIdCalls.clear();
      providers.provisionCalls.clear();
      probe.calls.clear();

      final err = await c.save();

      expect(err, isNull,
          reason: 'tras limpiar cache obsoleto, el CREATE flow debe pasar');
      // POST disparado (CREATE flow tras limpieza).
      expect(providers.provisionCalls, hasLength(1),
          reason: 'CREATE flow tras limpieza disparó provision()');
      // Probe disparado en el CREATE flow.
      expect(probe.calls, hasLength(1));
      // Saves de LocalContact:
      //   1) snapshot inicial (linkedProviderProfileId=null tras hidratación)
      //   2) cache del nuevo provider id (pp-fresh) tras provision()
      expect(contacts.savedHistory.length, greaterThanOrEqualTo(2));
      final last = contacts.savedHistory.last;
      expect(last.linkedProviderProfileId, 'pp-fresh');
    });

    // ── 7. PUT specialties falla después de POST ───────────────────────────
    test('PUT falla tras POST: linked id queda cacheado + error informado',
        () async {
      providers.provisionResult = _provider(updatedAt: _now);
      providers.replaceWillThrow = const ServerException(503, 'gateway');

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
      );
      c.onInit();
      _seedFormState(c, specialtyIds: {'sp-1'});

      final err = await c.save();

      expect(err, isNotNull);
      expect(err!.toLowerCase(), contains('servidor'));
      // POST sí corrió.
      expect(providers.provisionCalls, hasLength(1));
      // PUT también se intentó (y falló).
      expect(providers.replaceSpecialtiesCalls, hasLength(1));
      // Cache de linkedProviderProfileId SÍ se persistió antes del PUT —
      // este es el invariante crítico: el siguiente save salta el POST y
      // reintenta solo el PUT (idempotente backend).
      expect(contacts.savedHistory.length, 2);
      expect(contacts.savedHistory[0].linkedProviderProfileId, isNull);
      expect(contacts.savedHistory[1].linkedProviderProfileId,
          _providerProfileId);
    });

    // ── Plan Nivel 2 — assetType dropdown + setAssetType semántica ────────
    //
    // Cubre el contrato del dropdown "Tipo de activo" introducido en el form
    // de proveedor. El dropdown invoca `controller.setAssetType(value)`.
    // Verifica:
    //   1. setAssetType cambia el valor reactivo y limpia specialtyIds.
    //   2. setAssetType al mismo valor es no-op (no borra specialties).
    //   3. Flow end-to-end: assetType vía dropdown + apply specialties +
    //      save() → invoca PUT replaceSpecialties.
    group('Plan Nivel 2 — assetType dropdown', () {
      test('setAssetType desde null cambia value y resetea specialtyIds',
          () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        // Simulación: el usuario tapeó specialties antes de elegir tipo
        // (ruta inalcanzable hoy en UI pero el contrato del controller
        // debe ser robusto). El siguiente setAssetType debe limpiarlas.
        c.applySelectedSpecialties({'sp-1', 'sp-2'});
        expect(c.specialtyIds, isNotEmpty);
        expect(c.assetType.value, isNull);

        c.setAssetType('vehicle.car');

        expect(c.assetType.value, 'vehicle.car');
        expect(
          c.specialtyIds,
          isEmpty,
          reason:
              'Cambiar el contexto del catálogo invalida selecciones previas.',
        );
      });

      test('setAssetType al mismo valor es no-op (preserva specialtyIds)',
          () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.setAssetType('vehicle.car');
        c.applySelectedSpecialties({'sp-1', 'sp-2'});
        expect(c.specialtyIds, hasLength(2));

        c.setAssetType('vehicle.car'); // mismo valor

        expect(c.specialtyIds, hasLength(2),
            reason: 'No-op: las specialties no deben perderse.');
      });

      test(
          'flow end-to-end: dropdown → applySpecialties → save dispara PUT',
          () async {
        providers.provisionResult = _provider(updatedAt: _now);
        providers.replaceResult = _provider(
          updatedAt: _later,
          specialties: [_specialty('sp-A')],
        );

        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        _seedFormState(c);

        // Simula la secuencia exacta de la UI:
        //   1. Usuario escoge tipo en el dropdown.
        c.setAssetType('vehicle.motorcycle');
        //   2. Usuario abre selector y elige specialties.
        c.applySelectedSpecialties({'sp-A'});
        //   3. Tap "Guardar".
        final err = await c.save();

        expect(err, isNull);
        // PUT debe haberse invocado con la specialty seleccionada.
        expect(providers.replaceSpecialtiesCalls, hasLength(1));
        expect(providers.replaceSpecialtiesCalls.single.ids, {'sp-A'});
      });
    });

    // ── Hito 1.x — setOfferKind semántica + save ─────────────────────────
    //
    // El form expone `offerKind` como single-source-of-truth del kind
    // (PRODUCT | SERVICE | BOTH). Reglas:
    //   1. Cambiar `offerKind` limpia `specialtyIds` (las del kind
    //      anterior no aplican al nuevo filtro).
    //   2. Asignar el mismo valor es no-op (preserva selección).
    //   3. `save()` con specialties seleccionadas dispara PUT
    //      independientemente del valor de `offerKind` (el kind es UX,
    //      NO se persiste).
    group('Hito 1.x — setOfferKind semántica + save', () {
      test('setOfferKind desde null cambia value y resetea specialtyIds',
          () async {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.setAssetType('vehicle.car');
        c.applySelectedSpecialties({'sp-1', 'sp-2'});
        expect(c.specialtyIds, isNotEmpty);
        expect(c.offerKind.value, isNull);

        c.setOfferKind(SpecialtyKind.product);

        expect(c.offerKind.value, SpecialtyKind.product);
        expect(
          c.specialtyIds,
          isEmpty,
          reason:
              'Cambiar offerKind invalida specialties seleccionadas bajo el filtro anterior',
        );
      });

      test('setOfferKind al mismo valor es no-op (preserva specialtyIds)',
          () async {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.setAssetType('vehicle.car');
        c.setOfferKind(SpecialtyKind.service);
        c.applySelectedSpecialties({'sp-1', 'sp-2'});
        expect(c.specialtyIds, hasLength(2));

        c.setOfferKind(SpecialtyKind.service); // mismo valor

        expect(c.offerKind.value, SpecialtyKind.service);
        expect(c.specialtyIds, hasLength(2),
            reason: 'mismo valor no debe limpiar el set');
      });

      test('setOfferKind cambiando entre PRODUCT/SERVICE/BOTH limpia cada vez',
          () async {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.setAssetType('vehicle.car');

        c.setOfferKind(SpecialtyKind.product);
        c.applySelectedSpecialties({'sp-prod-1'});
        expect(c.specialtyIds, hasLength(1));

        c.setOfferKind(SpecialtyKind.service); // distinto → limpia
        expect(c.specialtyIds, isEmpty);

        c.applySelectedSpecialties({'sp-svc-1'});
        c.setOfferKind(SpecialtyKind.both); // distinto → limpia
        expect(c.specialtyIds, isEmpty);
      });

      test('save sigue disparando PUT cuando hay specialties (offerKind no se persiste)',
          () async {
        // `offerKind` es estado UX, NO viaja al backend. El POST
        // `/v1/providers` no recibe kind y el PUT `/:id/specialties`
        // lleva solo los specialtyIds elegidos por el usuario.
        providers.provisionResult = _provider(updatedAt: _now);
        providers.replaceResult = _provider(
          updatedAt: _later,
          specialties: [_specialty('sp-prod-1')],
        );

        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        _seedFormState(c);
        c.setAssetType('vehicle.car');
        c.setOfferKind(SpecialtyKind.product);
        c.applySelectedSpecialties({'sp-prod-1'});

        final err = await c.save();

        expect(err, isNull);
        expect(providers.replaceSpecialtiesCalls, hasLength(1));
        expect(providers.replaceSpecialtiesCalls.single.ids, {'sp-prod-1'});
      });
    });

    // ── Hito 1.x — UX subtitle compacto + cache de nombres ───────────────
    //
    // El form construye el subtítulo del tile "Especialidades" desde
    // `specialtyIds` + `specialtyNames` (cache hidratado por el selector
    // vía `applySelectedSpecialtiesWithNames`). Reglas:
    //   - 0 specialties → copy genérico de invitación.
    //   - 1 con nombre cacheado → solo el nombre.
    //   - 1 sin nombre cacheado → "1 especialidad seleccionada".
    //   - N>1 con nombre cacheado → "<firstName> +${N-1}".
    //   - N>1 sin nombre cacheado → "$N especialidades seleccionadas".
    group('Hito 1.x — specialtiesSummarySubtitle (resumen compacto)', () {
      test('0 specialties → copy genérico de invitación', () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();

        expect(c.specialtyIds, isEmpty);
        expect(
          c.specialtiesSummarySubtitle,
          'Selecciona una o más especialidades',
        );
      });

      test('1 specialty con nombre cacheado → muestra el nombre', () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.applySelectedSpecialtiesWithNames(
          {'sp-1'},
          {'sp-1': 'Mecánica general'},
        );

        expect(c.specialtiesSummarySubtitle, 'Mecánica general');
      });

      test('1 specialty SIN nombre cacheado → fallback genérico', () {
        // Caso EDIT recién hidratado por `getById`: el set tiene IDs
        // pero el cache de nombres aún está vacío (el selector no se
        // ha abierto). El subtítulo NO debe mostrar el id en crudo.
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.applySelectedSpecialties({'sp-1'}); // sin nombres

        expect(c.specialtiesSummarySubtitle, '1 especialidad seleccionada');
      });

      test('3 specialties con nombre cacheado → "<firstName> +2"', () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.applySelectedSpecialtiesWithNames(
          {'sp-1', 'sp-2', 'sp-3'},
          {
            'sp-1': 'Mecánica general',
            'sp-2': 'Eléctrica',
            'sp-3': 'Frenos',
          },
        );

        // El "primer nombre" se elige iterando el set; cualquiera de
        // los 3 nombres es válido como first. Verificamos el patrón
        // "<algún nombre> +2".
        final subtitle = c.specialtiesSummarySubtitle;
        expect(subtitle, endsWith(' +2'));
        expect(
          ['Mecánica general', 'Eléctrica', 'Frenos']
              .any((n) => subtitle.startsWith(n)),
          isTrue,
          reason: 'subtitle debe empezar con uno de los nombres cacheados',
        );
      });

      test('N>1 specialties SIN nombre cacheado → fallback genérico', () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.applySelectedSpecialties({'sp-1', 'sp-2', 'sp-3'}); // sin nombres

        expect(c.specialtiesSummarySubtitle, '3 especialidades seleccionadas');
      });

      test(
          'applySelectedSpecialtiesWithNames reemplaza cache (no merge): '
          'specialties anteriores no quedan colgadas', () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        c.applySelectedSpecialtiesWithNames(
          {'sp-1', 'sp-2'},
          {'sp-1': 'Old A', 'sp-2': 'Old B'},
        );
        expect(c.specialtyNames, hasLength(2));

        c.applySelectedSpecialtiesWithNames(
          {'sp-3'},
          {'sp-3': 'New'},
        );
        expect(c.specialtyNames, hasLength(1),
            reason: 'cache se reemplaza, no acumula');
        expect(c.specialtyNames['sp-3'], 'New');
        expect(c.specialtyNames.containsKey('sp-1'), isFalse);
      });
    });

    // ── Hotfix B — UUID estable en CREATE mode ────────────────────────────
    //
    // Invariante: en CREATE mode, llamar `buildEntitySnapshot()` N veces
    // consecutivas debe retornar entities con el MISMO `id`. Esto garantiza
    // que un re-tap del botón "Guardar" tras un fallo parcial (LocalContact
    // ya persistido pero POST canónico KO) NO genere un duplicado, sino un
    // upsert por id sobre la misma fila.
    //
    // EDIT mode preserva el id existente (ya cubierto por tests de happy
    // path EDIT más arriba — `entity.id` viene de `_original` o
    // `_editingProviderId`, ambos estables por contrato).
    group('Hotfix B — UUID estable en CREATE mode', () {
      test('buildEntitySnapshot N veces en CREATE retorna mismo id', () {
        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        _seedFormState(c);

        final s1 = c.buildEntitySnapshot();
        final s2 = c.buildEntitySnapshot();
        final s3 = c.buildEntitySnapshot();

        expect(s1.id, isNotEmpty);
        expect(s1.id, equals(s2.id));
        expect(s1.id, equals(s3.id));
      });

      test(
          're-tap simulado (dos save() consecutivos en CREATE) reusa el mismo entity.id',
          () async {
        // Mismo setup mínimo del happy CREATE path: el fake de providers
        // ya retorna `provisionResult` por default; sólo lo refrescamos
        // por claridad. `mockResolvedValue` persiste entre llamadas, así
        // que el segundo save también pasa por el flujo completo.
        providers.provisionResult = _provider(updatedAt: _now);

        final c = _makeController(
          contacts: contacts,
          providers: providers,
          probe: probe,
        );
        c.onInit();
        _seedFormState(c, specialtyIds: const {});

        await c.save();
        // Snapshot tras primer save: registra entity.id usado.
        final firstId = contacts.savedHistory.first.id;

        await c.save();
        // Todos los saves de LocalContact deben usar exactamente el mismo
        // entity.id que el primero. Cualquier insert con id distinto
        // generaría un duplicado en Isar/Firestore.
        expect(
          contacts.savedHistory.every((entity) => entity.id == firstId),
          isTrue,
          reason:
              're-tap del botón Guardar NO debe generar entity.id distinto',
        );
      });
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // loadAvailableAssetTypes — selector dinámico (Hito 1.x, 2026-04-26)
  // ─────────────────────────────────────────────────────────────────────────
  group('ProviderFormController.loadAvailableAssetTypes()', () {
    late _FakeContacts contacts;
    late _FakeProviders providers;
    late _FakeProbe probe;

    setUp(() {
      contacts = _FakeContacts();
      providers = _FakeProviders();
      probe = _FakeProbe();
    });

    test('happy path: pobla availableAssetTypes con la lista del backend',
        () async {
      final assetTypes = _FakeWorkspaceAssetTypes()
        ..result = const [
          WorkspaceAssetTypeEntity(
            id: 'vehicle',
            name: 'Vehículos',
            parentId: null,
          ),
          WorkspaceAssetTypeEntity(
            id: 'vehicle.car',
            name: 'Automóvil',
            parentId: 'vehicle',
          ),
        ];

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        workspaceAssetTypes: assetTypes,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.availableAssetTypes, hasLength(2));
      expect(c.availableAssetTypes.first.id, 'vehicle');
      expect(c.availableAssetTypesError.value, isNull);
      expect(c.availableAssetTypesLoading.value, isFalse);
      expect(assetTypes.callCount, 1);
    });

    test('lista vacía: no setea error, deja availableAssetTypes vacía',
        () async {
      final assetTypes = _FakeWorkspaceAssetTypes()..result = const [];

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        workspaceAssetTypes: assetTypes,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.availableAssetTypes, isEmpty);
      expect(c.availableAssetTypesError.value, isNull);
      expect(c.availableAssetTypesLoading.value, isFalse);
    });

    test('NetworkException: setea error humano y deja availableAssetTypes vacía',
        () async {
      final assetTypes = _FakeWorkspaceAssetTypes()
        ..willThrow = const NetworkException('offline');

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        workspaceAssetTypes: assetTypes,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.availableAssetTypes, isEmpty);
      expect(c.availableAssetTypesError.value, 'Sin conexión.');
      expect(c.availableAssetTypesLoading.value, isFalse);
    });

    test('UnauthorizedException: copy "Tu sesión expiró."', () async {
      final assetTypes = _FakeWorkspaceAssetTypes()
        ..willThrow = const UnauthorizedException('expired');

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        workspaceAssetTypes: assetTypes,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.availableAssetTypesError.value, 'Tu sesión expiró.');
    });

    test('reintento (loadAvailableAssetTypes manual) limpia el error previo',
        () async {
      final assetTypes = _FakeWorkspaceAssetTypes()
        ..willThrow = const NetworkException('offline');

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        workspaceAssetTypes: assetTypes,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);
      expect(c.availableAssetTypesError.value, isNotNull);

      // Backend recuperado.
      assetTypes.willThrow = null;
      assetTypes.result = const [
        WorkspaceAssetTypeEntity(
          id: 'vehicle.car',
          name: 'Automóvil',
          parentId: null,
        ),
      ];
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypesError.value, isNull);
      expect(c.availableAssetTypes, hasLength(1));
      expect(assetTypes.callCount, 2);
    });

    test('kill-switch OFF: NO dispara la carga en onInit', () async {
      final assetTypes = _FakeWorkspaceAssetTypes();

      final c = _makeController(
        contacts: contacts,
        providers: providers,
        probe: probe,
        workspaceAssetTypes: assetTypes,
        enableCanonicalIntegrationOverride: false,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(assetTypes.callCount, 0);
      expect(c.availableAssetTypes, isEmpty);
      expect(c.availableAssetTypesLoading.value, isFalse);
    });
  });
}

