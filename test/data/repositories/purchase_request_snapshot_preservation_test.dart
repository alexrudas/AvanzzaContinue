// ============================================================================
// test/data/repositories/purchase_request_snapshot_preservation_test.dart
// PURCHASE REQUEST SNAPSHOT PRESERVATION — blinda el riesgo real detectado
//
// RIESGO CUBIERTO:
// El bloque VehicleSpec vive LOCAL-ONLY en Isar (el backend canónico aún no
// lo transporta). Ante un refresh/sync, el modelo mapeado desde el servidor
// llega con vehicleSpec* = null. Sin merge, el row local con snapshot sería
// sobrescrito y el snapshot se perdería.
//
// Este test fija el contrato de
// `PurchaseRepositoryImpl.mergeLocalSnapshotInto(remote, existing)`:
//
//  1) remote sin spec + local CON spec  → conserva spec local
//  2) remote CON spec                   → respeta remoto (cuando el backend
//                                         adopte el bloque, el merge queda
//                                         neutralizado sin cambios)
//  3) remote sin spec + local sin spec  → no introduce falsos positivos
//
// NOTAS:
// - No necesita Isar real: la función es pura sobre el modelo.
// - Los campos "no snapshot" deben salir siempre de remote (status, title,
//   updatedAt, etc.) para no revertir cambios de servidor.
// ============================================================================

import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/repositories/purchase_repository_impl.dart';
import 'package:avanzza/data/sources/local/purchase_local_ds.dart';
import 'package:avanzza/data/sources/remote/purchase/purchase_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

class _FakeLocalDs implements PurchaseLocalDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Isar get isar => throw UnimplementedError();
}

class _FakeRemote implements PurchaseApiClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PurchaseRequestModel _baseModel({
  required String id,
  required String updatedAtIso,
  String status = 'sent',
}) {
  return PurchaseRequestModel(
    id: id,
    orgId: 'org-1',
    title: 'PR',
    typeWire: 'PRODUCT',
    originTypeWire: 'INVENTORY',
    itemsCount: 1,
    status: status,
    respuestasCount: 0,
    updatedAt: DateTime.parse(updatedAtIso),
  );
}

PurchaseRequestModel _withSpec(
  PurchaseRequestModel base, {
  String id = 'toyota|hilux|2022',
  String label = 'Toyota Hilux 2022',
}) {
  return PurchaseRequestModel(
    id: base.id,
    orgId: base.orgId,
    title: base.title,
    typeWire: base.typeWire,
    category: base.category,
    originTypeWire: base.originTypeWire,
    assetId: base.assetId,
    notes: base.notes,
    deliveryCity: base.deliveryCity,
    deliveryDepartment: base.deliveryDepartment,
    deliveryAddress: base.deliveryAddress,
    deliveryInfo: base.deliveryInfo,
    itemsCount: base.itemsCount,
    status: base.status,
    respuestasCount: base.respuestasCount,
    createdAt: base.createdAt,
    updatedAt: base.updatedAt,
    vehicleSpecId: id,
    vehicleSpecLabel: label,
    vehicleSpecMake: 'Toyota',
    vehicleSpecModel: 'Hilux',
    vehicleSpecYear: 2022,
    vehicleSpecLinkedAssetsCount: 3,
  );
}

void main() {
  late PurchaseRepositoryImpl repo;

  setUp(() {
    // El helper mergeLocalSnapshotInto no toca local/remote; los fakes existen
    // solo para satisfacer el constructor.
    repo = PurchaseRepositoryImpl(
      local: _FakeLocalDs(),
      remote: _FakeRemote(),
    );
  });

  group('mergeLocalSnapshotInto — protección del snapshot local-only', () {
    test('remote sin spec + local CON spec → conserva spec local', () {
      final remote = _baseModel(
        id: 'pr-1',
        updatedAtIso: '2026-04-21T10:00:00Z',
        status: 'responded', // cambio legítimo de estado desde backend
      );
      final existing = _withSpec(
        _baseModel(id: 'pr-1', updatedAtIso: '2026-04-20T09:00:00Z'),
      );

      final merged = repo.mergeLocalSnapshotInto(remote, existing);

      // Snapshot preservado.
      expect(merged.vehicleSpecId, 'toyota|hilux|2022');
      expect(merged.vehicleSpecLabel, 'Toyota Hilux 2022');
      expect(merged.vehicleSpecMake, 'Toyota');
      expect(merged.vehicleSpecModel, 'Hilux');
      expect(merged.vehicleSpecYear, 2022);
      expect(merged.vehicleSpecLinkedAssetsCount, 3);

      // Campos no-snapshot provienen del remoto (status actualizado).
      expect(merged.status, 'responded');
      expect(merged.updatedAt, DateTime.parse('2026-04-21T10:00:00Z'));
    });

    test('remote CON spec → respeta el remoto (merge neutral a futuro)', () {
      final existing = _withSpec(
        _baseModel(id: 'pr-2', updatedAtIso: '2026-04-20T09:00:00Z'),
        id: 'old|spec|2020',
        label: 'Old Spec 2020',
      );
      final remoteWithSpec = _withSpec(
        _baseModel(id: 'pr-2', updatedAtIso: '2026-04-21T11:00:00Z'),
        id: 'kia|picanto|2023',
        label: 'Kia Picanto 2023',
      );

      final merged = repo.mergeLocalSnapshotInto(remoteWithSpec, existing);

      expect(merged.vehicleSpecId, 'kia|picanto|2023');
      expect(merged.vehicleSpecLabel, 'Kia Picanto 2023');
    });

    test('remote sin spec + local sin spec → sale sin spec (no inventa)', () {
      final remote = _baseModel(id: 'pr-3', updatedAtIso: '2026-04-21T10:00:00Z');
      final existing =
          _baseModel(id: 'pr-3', updatedAtIso: '2026-04-20T09:00:00Z');

      final merged = repo.mergeLocalSnapshotInto(remote, existing);

      expect(merged.vehicleSpecId, isNull);
      expect(merged.vehicleSpecLabel, isNull);
      expect(merged.vehicleSpecMake, isNull);
    });
  });
}
