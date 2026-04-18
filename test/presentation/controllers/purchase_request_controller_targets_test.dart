// ============================================================================
// test/presentation/controllers/purchase_request_controller_targets_test.dart
// PURCHASE REQUEST CONTROLLER — target selection (F5 Hito 18)
// ============================================================================
// VALIDA:
//   - canSubmit es false si selectedVendorIds está vacío, aunque los otros
//     campos estén llenos (el usuario NO llega al backend con []).
//   - toggleVendor añade/remueve ids correctamente y deduplica.
//   - submitRequest propaga los selected ids al repo como
//     proveedorIdsInvitados; NO envía un array vacío.
//   - submitRequest con selección vacía retorna false SIN invocar el repo.
//   - availableContacts se alimenta desde LocalContactRepository.watchByWorkspace.
//   - Si un contacto seleccionado se elimina del workspace, se retira de
//     selectedVendorIds automáticamente (estado coherente).
//   - validate() devuelve mensaje humano sin destinatarios.
//
// INFRA:
//   Usa el ctor inyectable del controller real (repo + contactsRepo +
//   session). Sin subclases: se testea la lógica de producción.
// ============================================================================

import 'dart:async';

import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/entities/purchase/purchase_request_entity.dart';
import 'package:avanzza/domain/entities/user/active_context.dart';
import 'package:avanzza/domain/entities/user/user_entity.dart';
import 'package:avanzza/domain/repositories/core_common/local_contact_repository.dart';
import 'package:avanzza/domain/repositories/purchase_repository.dart';
import 'package:avanzza/presentation/controllers/purchase_request_controller.dart';
import 'package:avanzza/presentation/controllers/session_context_controller.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _FakePurchaseRepo implements PurchaseRepository {
  final List<PurchaseRequestEntity> saved = [];
  Object? willThrow;

  @override
  Future<void> upsertRequest(PurchaseRequestEntity request) async {
    final err = willThrow;
    if (err != null) throw err;
    saved.add(request);
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('PurchaseRepository.${invocation.memberName}');
}

class _FakeContactsRepo implements LocalContactRepository {
  final _controller = StreamController<List<LocalContactEntity>>.broadcast();

  void emit(List<LocalContactEntity> list) {
    _controller.add(list);
  }

  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  Stream<List<LocalContactEntity>> watchByWorkspace(String workspaceId) =>
      _controller.stream;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'LocalContactRepository.${invocation.memberName}');
}

class _FakeSession implements SessionContextController {
  @override
  UserEntity? get user => const UserEntity(
        uid: 'user-1',
        name: 'Alex',
        email: 'a@b.com',
        activeContext: ActiveContext(
          orgId: 'ws-1',
          orgName: 'WS',
          rol: 'administrador',
        ),
      );

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'SessionContextController.${invocation.memberName}');
}

// ─── Fixtures ──────────────────────────────────────────────────────────────

LocalContactEntity _contact({
  required String id,
  String name = 'Contacto',
}) {
  final now = DateTime.utc(2026, 4, 18);
  return LocalContactEntity(
    id: id,
    workspaceId: 'ws-1',
    displayName: name,
    createdAt: now,
    updatedAt: now,
  );
}

// ─── Tests ─────────────────────────────────────────────────────────────────

void main() {
  late _FakePurchaseRepo purchaseRepo;
  late _FakeContactsRepo contactsRepo;
  late _FakeSession session;
  late PurchaseRequestController controller;

  setUp(() {
    purchaseRepo = _FakePurchaseRepo();
    contactsRepo = _FakeContactsRepo();
    session = _FakeSession();
    controller = PurchaseRequestController(
      repo: purchaseRepo,
      contactsRepo: contactsRepo,
      session: session,
    );
    // Replicamos solo lo que onInit hace en producción (sin Get.lazyPut).
    controller.onInit();
    controller.tipoRepuesto.value = 'Filtro';
    controller.cantidadText.value = '2';
    controller.ciudadEntrega.value = 'Bogotá';
  });

  tearDown(() async {
    controller.onClose();
    await contactsRepo.dispose();
  });

  test('canSubmit false sin destinatarios aunque campos estén completos', () {
    expect(controller.canSubmit, isFalse);
    expect(controller.selectedVendorIds, isEmpty);
  });

  test('canSubmit true al seleccionar al menos 1 destinatario', () async {
    contactsRepo.emit([_contact(id: 'ct-1', name: 'Alice')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    controller.toggleVendor('ct-1');
    expect(controller.canSubmit, isTrue);
  });

  test('toggleVendor añade y remueve sin duplicar', () async {
    contactsRepo.emit([_contact(id: 'ct-1'), _contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-1'); // duplicate toggle → remove
    expect(controller.selectedVendorIds, isEmpty);

    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-2');
    expect(controller.selectedVendorIds, containsAll(['ct-1', 'ct-2']));
    expect(controller.selectedVendorIds, hasLength(2));
  });

  test('submitRequest propaga proveedorIdsInvitados al repo', () async {
    contactsRepo.emit([_contact(id: 'ct-1'), _contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-2');

    final ok = await controller.submitRequest(
      tipoRepuesto: 'Filtro',
      cantidad: 2,
      ciudadEntrega: 'Bogotá',
    );

    expect(ok, isTrue);
    expect(purchaseRepo.saved, hasLength(1));
    expect(purchaseRepo.saved.first.proveedorIdsInvitados, ['ct-1', 'ct-2']);
    expect(controller.selectedVendorIds, isEmpty);
  });

  test('submitRequest con selección vacía → false y NO toca el repo',
      () async {
    final ok = await controller.submitRequest(
      tipoRepuesto: 'Filtro',
      cantidad: 2,
      ciudadEntrega: 'Bogotá',
    );

    expect(ok, isFalse);
    expect(purchaseRepo.saved, isEmpty);
  });

  test(
      'si un contacto seleccionado sale del workspace, se retira '
      'automáticamente', () async {
    contactsRepo.emit([_contact(id: 'ct-1'), _contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-2');

    // ct-1 eliminado del stream (soft-delete, o cambio de workspace).
    contactsRepo.emit([_contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(controller.selectedVendorIds, ['ct-2']);
    expect(controller.availableContacts.map((e) => e.id), ['ct-2']);
  });

  test('validate() devuelve mensaje claro sin destinatarios', () {
    final err = controller.validate(
      tipoRepuesto: 'Filtro',
      cantidad: '2',
      ciudadEntrega: 'Bogotá',
    );
    expect(err, isNotNull);
    expect(err!.toLowerCase(), contains('destinatario'));
  });
}
