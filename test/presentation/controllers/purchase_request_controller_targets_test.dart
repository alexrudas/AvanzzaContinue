// ============================================================================
// test/presentation/controllers/purchase_request_controller_targets_test.dart
// PURCHASE REQUEST CONTROLLER — canonical create path + target selection
// ============================================================================
// VALIDA:
//   - canSubmit es false si falta cualquiera de los requisitos canónicos
//     (title, items válidos, destinatarios).
//   - toggleVendor añade/remueve y deduplica.
//   - submitRequest() construye un CreatePurchaseRequestInput coherente y
//     lo pasa a PurchaseRepository.createRequest.
//   - submitRequest() con selección vacía retorna false SIN invocar el repo.
//   - Si se provee originType=ASSET pero assetId vacío, validate() lo bloquea.
//   - availableContacts se alimenta desde LocalContactRepository.watchByWorkspace.
//   - Si un contacto seleccionado sale del workspace, se retira automáticamente.
// ============================================================================

import 'dart:async';

import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/entities/purchase/create_purchase_request_input.dart';
import 'package:avanzza/domain/entities/user/active_context.dart';
import 'package:avanzza/domain/entities/user/user_entity.dart';
import 'package:avanzza/domain/repositories/core_common/local_contact_repository.dart';
import 'package:avanzza/domain/repositories/purchase_repository.dart';
import 'package:avanzza/presentation/controllers/purchase_request_controller.dart';
import 'package:avanzza/presentation/controllers/session_context_controller.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _FakePurchaseRepo implements PurchaseRepository {
  final List<CreatePurchaseRequestInput> saved = [];
  Object? willThrow;

  @override
  Future<void> createRequest(CreatePurchaseRequestInput input) async {
    final err = willThrow;
    if (err != null) throw err;
    saved.add(input);
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

void _fillValidForm(PurchaseRequestController c) {
  c.title.value = 'Insumos mensuales';
  c.type.value = PurchaseRequestTypeInput.product;
  c.category.value = 'medicamentos';
  c.originType.value = PurchaseRequestOriginInput.general;
  c.items[0]
    ..description = 'Guantes nitrilo'
    ..quantityText = '2'
    ..unit = 'caja';
  c.items.refresh();
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
    controller.onInit();
  });

  tearDown(() async {
    controller.onClose();
    await contactsRepo.dispose();
  });

  test('canSubmit false sin destinatarios aunque campos estén completos', () {
    _fillValidForm(controller);
    expect(controller.canSubmit, isFalse);
    expect(controller.selectedVendorIds, isEmpty);
  });

  test('canSubmit true al completar form + seleccionar 1 destinatario',
      () async {
    _fillValidForm(controller);
    contactsRepo.emit([_contact(id: 'ct-1', name: 'Alice')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    controller.toggleVendor('ct-1');
    expect(controller.canSubmit, isTrue);
  });

  test('toggleVendor añade y remueve sin duplicar', () async {
    contactsRepo.emit([_contact(id: 'ct-1'), _contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-1'); // toggle off
    expect(controller.selectedVendorIds, isEmpty);

    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-2');
    expect(controller.selectedVendorIds, containsAll(['ct-1', 'ct-2']));
    expect(controller.selectedVendorIds, hasLength(2));
  });

  test('submitRequest propaga input canónico al repo', () async {
    _fillValidForm(controller);
    contactsRepo.emit([_contact(id: 'ct-1'), _contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-2');

    final ok = await controller.submitRequest();

    expect(ok, isTrue);
    expect(purchaseRepo.saved, hasLength(1));
    final input = purchaseRepo.saved.first;
    expect(input.title, 'Insumos mensuales');
    expect(input.type, PurchaseRequestTypeInput.product);
    expect(input.category, 'medicamentos');
    expect(input.originType, PurchaseRequestOriginInput.general);
    expect(input.vendorContactIds, ['ct-1', 'ct-2']);
    expect(input.items, hasLength(1));
    expect(input.items.first.description, 'Guantes nitrilo');
    expect(input.items.first.quantity, 2);
    expect(input.items.first.unit, 'caja');
    expect(input.delivery, isNull);
    expect(controller.selectedVendorIds, isEmpty);
  });

  test('submitRequest con selección vacía → false y NO toca el repo',
      () async {
    _fillValidForm(controller);
    final ok = await controller.submitRequest();

    expect(ok, isFalse);
    expect(purchaseRepo.saved, isEmpty);
  });

  test('originType=ASSET sin assetId → canSubmit false, validate humano', () {
    _fillValidForm(controller);
    controller.originType.value = PurchaseRequestOriginInput.asset;
    // assetId vacío (default)
    expect(controller.canSubmit, isFalse);
    final err = controller.validate();
    expect(err, isNotNull);
    expect(err!.toLowerCase(), contains('activo'));
  });

  test('delivery activado sin address → bloquea con mensaje de dirección',
      () async {
    _fillValidForm(controller);
    contactsRepo.emit([_contact(id: 'ct-1')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    controller.setDeliveryEnabled(true);
    controller.deliveryCity.value = 'Barranquilla';
    // address queda vacío
    final err = controller.validate();
    expect(err, isNotNull);
    expect(err!.toLowerCase(), contains('dirección'));
  });

  test('delivery NO activado → payload sin delivery aunque haya texto',
      () async {
    _fillValidForm(controller);
    contactsRepo.emit([_contact(id: 'ct-1')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    // Usuario escribió algo pero NO activó el switch: debe omitirse.
    controller.deliveryCity.value = 'Barranquilla';
    controller.deliveryAddress.value = 'Cra 45 # 10-20';

    final ok = await controller.submitRequest();
    expect(ok, isTrue);
    expect(purchaseRepo.saved.first.delivery, isNull);
  });

  test('delivery activado + completo viaja al input canónico', () async {
    _fillValidForm(controller);
    contactsRepo.emit([_contact(id: 'ct-1')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    controller.setDeliveryEnabled(true);
    controller.deliveryCity.value = 'Barranquilla';
    controller.deliveryAddress.value = 'Cra 45 # 10-20';
    controller.deliveryDepartment.value = 'Atlántico';
    controller.deliveryInfo.value = 'Piso 3';

    final ok = await controller.submitRequest();
    expect(ok, isTrue);
    final delivery = purchaseRepo.saved.first.delivery;
    expect(delivery, isNotNull);
    expect(delivery!.city, 'Barranquilla');
    expect(delivery.address, 'Cra 45 # 10-20');
    expect(delivery.department, 'Atlántico');
    expect(delivery.info, 'Piso 3');
  });

  test(
      'si un contacto seleccionado sale del workspace, se retira automáticamente',
      () async {
    contactsRepo.emit([_contact(id: 'ct-1'), _contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    controller.toggleVendor('ct-1');
    controller.toggleVendor('ct-2');

    contactsRepo.emit([_contact(id: 'ct-2')]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(controller.selectedVendorIds, ['ct-2']);
    expect(controller.availableContacts.map((e) => e.id), ['ct-2']);
  });

  test('validate() devuelve mensaje claro sin destinatarios', () {
    _fillValidForm(controller);
    final err = controller.validate();
    expect(err, isNotNull);
    expect(err!.toLowerCase(), contains('destinatario'));
  });
}
