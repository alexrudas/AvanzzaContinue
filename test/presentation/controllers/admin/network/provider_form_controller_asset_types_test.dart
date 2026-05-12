// ============================================================================
// test/presentation/controllers/admin/network/provider_form_controller_asset_types_test.dart
// ProviderFormController — loadAvailableAssetTypes() local-first merge
// ============================================================================
// Cubre el fix local-first del dropdown "Especialidades":
//
//   1. Workspace con vehículos en Isar + wire [] → muestra vehículos
//      (sin error). El usuario que ya registró activos puede asignar
//      especialidades aunque AssetActorLink no haya sincronizado.
//
//   2. Wire + local con tipos solapados → no duplica; wire gana en
//      name/parentId (es la versión canónica con subtipos jerárquicos).
//
//   3. Wire cae con NetworkException + local presente → no error, lista
//      local intacta. El usuario sigue operativo sin conexión.
//
//   4. Wire cae + local vacío → error humano "Sin conexión." con
//      lista vacía (UX legacy preservado).
//
//   5. Local + wire ambos vacíos → empty real, sin error (copy guía
//      "registra un activo primero").
//
//   6. _assetRepository = null (path legacy/test) → solo wire (no
//      regresión de los tests existentes que no inyectan repo).
//
//   7. Orden: synth respeta orden del enum AssetType y se ubica
//      después de los items de wire en el merge.
// ============================================================================

import 'package:avanzza/domain/entities/asset/asset_content.dart';
import 'package:avanzza/domain/entities/asset/asset_entity.dart';
import 'package:avanzza/domain/entities/asset/asset_document_entity.dart';
import 'package:avanzza/domain/entities/asset/special/asset_inmueble_entity.dart';
import 'package:avanzza/domain/entities/asset/special/asset_maquinaria_entity.dart';
import 'package:avanzza/domain/entities/asset/special/asset_vehiculo_entity.dart';
import 'package:avanzza/domain/entities/workspace/workspace_asset_type_entity.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:avanzza/domain/repositories/asset_repository.dart';
import 'package:avanzza/domain/repositories/core_common/local_contact_repository.dart';
import 'package:avanzza/domain/repositories/provider/provider_canonical_repository.dart';
import 'package:avanzza/domain/repositories/workspace/workspace_asset_type_repository.dart';
import 'package:avanzza/domain/value/purchase/vehicle_spec.dart';
import 'package:avanzza/data/sources/remote/core_common/match_candidate_nestjs_ds.dart';
import 'package:avanzza/presentation/controllers/admin/network/provider_form_controller.dart';
import 'package:flutter_test/flutter_test.dart';

const _orgId = 'ws-1';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _NoopContacts implements LocalContactRepository {
  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(
          'LocalContactRepository.${invocation.memberName}');
}

class _NoopProviders implements ProviderCanonicalRepository {
  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(
          'ProviderCanonicalRepository.${invocation.memberName}');
}

class _NoopProbe implements MatchCandidateNestJsDataSource {
  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(
          'MatchCandidateNestJsDataSource.${invocation.memberName}');
}

class _FakeWorkspaceAssetTypes implements WorkspaceAssetTypeRepository {
  List<WorkspaceAssetTypeEntity> result = const [];
  Object? willThrow;
  int callCount = 0;

  @override
  Future<List<WorkspaceAssetTypeEntity>> listActive() async {
    callCount++;
    if (willThrow != null) throw willThrow!;
    return result;
  }
}

class _FakeAssets implements AssetRepository {
  List<AssetEntity> assetsResult = const [];
  Object? fetchWillThrow;
  int fetchCallCount = 0;

  @override
  Future<List<AssetEntity>> fetchAssetsByOrg(
    String orgId, {
    String? assetType,
    String? cityId,
  }) async {
    fetchCallCount++;
    if (fetchWillThrow != null) throw fetchWillThrow!;
    return assetsResult;
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('AssetRepository.${invocation.memberName}');
}

// ─── Helpers ────────────────────────────────────────────────────────────────

AssetEntity _vehicle(String id, {String plate = 'ABC123'}) {
  final now = DateTime.utc(2026, 5, 11);
  return AssetEntity(
    id: id,
    assetKey: plate,
    type: AssetType.vehicle,
    content: AssetContent.vehicle(
      assetKey: plate,
      brand: 'TOYOTA',
      model: '2024',
      color: 'BLANCO',
      engineDisplacement: 1600,
    ),
    createdAt: now,
    updatedAt: now,
  );
}

AssetEntity _equipment(String id, {String serial = 'EQ-001'}) {
  final now = DateTime.utc(2026, 5, 11);
  return AssetEntity(
    id: id,
    assetKey: serial,
    type: AssetType.equipment,
    content: AssetContent.equipment(
      assetKey: serial,
      name: 'Compresor',
    ),
    createdAt: now,
    updatedAt: now,
  );
}

ProviderFormController _makeController({
  required _FakeWorkspaceAssetTypes workspaceAssetTypes,
  _FakeAssets? assets,
}) {
  return ProviderFormController(
    contacts: _NoopContacts(),
    providers: _NoopProviders(),
    matchCandidateProbe: _NoopProbe(),
    workspaceAssetTypes: workspaceAssetTypes,
    assetRepository: assets,
    orgId: _orgId,
    defaultCountryId: 'CO',
    // Kill-switch ON para que el lifecycle dispare loadAvailableAssetTypes,
    // aunque los tests invocan el método manualmente para determinismo.
    enableCanonicalIntegrationOverride: true,
  );
}

// Silenciador: las referencias indirectas a tipos del dominio (no
// instanciados directamente en este file) las preserva el analizador
// si se usan al menos una vez.
// ignore: unused_element
void _typeRefs() {
  AssetDocumentEntity;
  AssetVehiculoEntity;
  AssetInmuebleEntity;
  AssetMaquinariaEntity;
  VehicleSpec;
}

void main() {
  group('loadAvailableAssetTypes — local-first merge', () {
    test('local con vehículos + wire vacío → muestra vehículos sin error',
        () async {
      final assets = _FakeAssets()
        ..assetsResult = [_vehicle('v1'), _vehicle('v2', plate: 'XYZ789')];
      final wire = _FakeWorkspaceAssetTypes()..result = const [];

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypesLoading.value, isFalse);
      expect(c.availableAssetTypesError.value, isNull);
      expect(c.availableAssetTypes.map((e) => e.id).toList(), ['vehicle']);
      expect(c.availableAssetTypes.first.name, 'Vehículos');
      expect(assets.fetchCallCount, 1);
      expect(wire.callCount, 1);
    });

    test('wire enriquece synth: id solapado → wire gana (name/parentId)',
        () async {
      final assets = _FakeAssets()..assetsResult = [_vehicle('v1')];
      final wire = _FakeWorkspaceAssetTypes()
        ..result = const [
          // Mismo id raíz que synth → wire gana.
          WorkspaceAssetTypeEntity(
              id: 'vehicle', name: 'Vehículos (oficial)', parentId: null),
          // Subtipo solo en wire → se preserva.
          WorkspaceAssetTypeEntity(
              id: 'vehicle.car', name: 'Auto', parentId: 'vehicle'),
        ];

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      final ids = c.availableAssetTypes.map((e) => e.id).toList();
      expect(ids, ['vehicle', 'vehicle.car']);
      expect(
        c.availableAssetTypes.firstWhere((e) => e.id == 'vehicle').name,
        'Vehículos (oficial)',
        reason: 'wire gana en el solapamiento',
      );
      expect(c.availableAssetTypesError.value, isNull);
    });

    test('synth aporta tipos ausentes en wire (después de wire en orden)',
        () async {
      final assets = _FakeAssets()
        ..assetsResult = [_vehicle('v1'), _equipment('e1')];
      final wire = _FakeWorkspaceAssetTypes()
        ..result = const [
          // wire solo trae vehicle → synth debe aportar equipment al final
          WorkspaceAssetTypeEntity(
              id: 'vehicle', name: 'Vehículos', parentId: null),
        ];

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      expect(
        c.availableAssetTypes.map((e) => e.id).toList(),
        ['vehicle', 'equipment'],
        reason: 'wire primero, synth no presente después',
      );
    });

    test('wire cae con NetworkException + local presente → no error', () async {
      final assets = _FakeAssets()..assetsResult = [_vehicle('v1')];
      final wire = _FakeWorkspaceAssetTypes()
        ..willThrow = const NetworkException('offline');

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypesError.value, isNull,
          reason: 'local cubre, no se muestra error');
      expect(c.availableAssetTypes.map((e) => e.id).toList(), ['vehicle']);
    });

    test('wire cae + local vacío → error humano', () async {
      final assets = _FakeAssets()..assetsResult = const [];
      final wire = _FakeWorkspaceAssetTypes()
        ..willThrow = const NetworkException('offline');

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypesError.value, 'Sin conexión.');
      expect(c.availableAssetTypes, isEmpty);
    });

    test('wire cae con ServerException + local vacío → error humano', () async {
      final assets = _FakeAssets()..assetsResult = const [];
      final wire = _FakeWorkspaceAssetTypes()
        ..willThrow = const ServerException(500, 'boom');

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypesError.value, 'Error del servidor.');
    });

    test('local + wire ambos vacíos → empty sin error', () async {
      final assets = _FakeAssets()..assetsResult = const [];
      final wire = _FakeWorkspaceAssetTypes()..result = const [];

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypes, isEmpty);
      expect(c.availableAssetTypesError.value, isNull,
          reason: 'workspace sin activos: empty real, NO es error');
    });

    test('_assetRepository = null → solo wire (path legacy)', () async {
      final wire = _FakeWorkspaceAssetTypes()
        ..result = const [
          WorkspaceAssetTypeEntity(
              id: 'vehicle.car', name: 'Auto', parentId: 'vehicle'),
        ];

      final c = _makeController(workspaceAssetTypes: wire, assets: null);
      await c.loadAvailableAssetTypes();

      expect(c.availableAssetTypes.map((e) => e.id).toList(), ['vehicle.car']);
      expect(c.availableAssetTypesError.value, isNull);
    });

    test('fetchAssetsByOrg lanza → synth queda vacío, wire decide', () async {
      final assets = _FakeAssets()..fetchWillThrow = Exception('isar boom');
      final wire = _FakeWorkspaceAssetTypes()
        ..result = const [
          WorkspaceAssetTypeEntity(
              id: 'vehicle', name: 'Vehículos', parentId: null),
        ];

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      // Synth falla silenciosamente, wire suple. Sin error humano.
      expect(c.availableAssetTypes.map((e) => e.id).toList(), ['vehicle']);
      expect(c.availableAssetTypesError.value, isNull);
    });

    test('orden de synth respeta AssetType enum', () async {
      // Equipment + Vehicle desordenados en el input
      final assets = _FakeAssets()
        ..assetsResult = [_equipment('e1'), _vehicle('v1')];
      final wire = _FakeWorkspaceAssetTypes()..result = const [];

      final c = _makeController(workspaceAssetTypes: wire, assets: assets);
      await c.loadAvailableAssetTypes();

      // AssetType.values order: vehicle, realEstate, machinery, equipment
      expect(c.availableAssetTypes.map((e) => e.id).toList(),
          ['vehicle', 'equipment']);
    });
  });
}
