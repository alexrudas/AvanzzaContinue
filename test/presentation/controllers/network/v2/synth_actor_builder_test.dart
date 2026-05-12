// ============================================================================
// test/presentation/controllers/network/v2/synth_actor_builder_test.dart
// SYNTH ACTOR BUILDER — Tests de la matriz de acciones por datos disponibles.
// ============================================================================

import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/supplier_type.dart';
import 'package:avanzza/presentation/controllers/network/v2/synth_actor_builder.dart';
import 'package:flutter_test/flutter_test.dart';

LocalContactModel _contact({
  required String id,
  SupplierType? supplier,
  String? linkedProviderProfileId,
  String displayName = 'Synth',
  String? primaryPhoneE164,
  String? primaryEmail,
}) {
  final now = DateTime.utc(2026, 5, 11, 10);
  return LocalContactModel(
    id: id,
    workspaceId: 'ws-1',
    displayName: displayName,
    createdAt: now,
    updatedAt: now,
    supplierTypeWire: supplier?.wireName,
    linkedProviderProfileId: linkedProviderProfileId,
    primaryPhoneE164: primaryPhoneE164,
    primaryEmail: primaryEmail,
  );
}

bool _hasAction(
  List actions,
  NetworkActionType type, {
  required bool enabled,
}) {
  return actions.any((a) => a.type == type && a.enabled == enabled);
}

void main() {
  group('buildSynthActorVM — campos base', () {
    test('ref = local:contact:<id>', () {
      final vm = buildSynthActorVM(_contact(id: 'X'));
      expect(vm.ref.raw, 'local:contact:X');
      expect(vm.ref.kind.wireName, 'local');
    });

    test('supplierType viene del LocalContact', () {
      final vm = buildSynthActorVM(
        _contact(id: 'X', supplier: SupplierType.services),
      );
      expect(vm.supplierType, SupplierType.services);
    });

    test('supplierType null si LocalContact no lo tiene', () {
      final vm = buildSynthActorVM(_contact(id: 'X', supplier: null));
      expect(vm.supplierType, isNull);
    });

    test('providerProfileId viene del link (puede ser null)', () {
      final withLink = buildSynthActorVM(
        _contact(id: 'X', linkedProviderProfileId: 'prov-1'),
      );
      expect(withLink.providerProfileId, 'prov-1');

      final noLink = buildSynthActorVM(_contact(id: 'Y'));
      expect(noLink.providerProfileId, isNull);
    });

    test('unresolved = !hasLink', () {
      final withLink = buildSynthActorVM(
        _contact(id: 'X', linkedProviderProfileId: 'prov-1'),
      );
      expect(withLink.unresolved, isFalse);

      final noLink = buildSynthActorVM(_contact(id: 'Y'));
      expect(noLink.unresolved, isTrue);
    });

    test('hasWhatsApp = false aunque haya teléfono (V1 conservador)', () {
      final vm = buildSynthActorVM(
        _contact(id: 'X', primaryPhoneE164: '+573001234567'),
      );
      expect(vm.hasWhatsApp, isFalse,
          reason:
              'V1 NO infiere hasWhatsApp=true por tener teléfono. Backend lo '
              'confirma tras refresh exitoso vía dedupe real ↔ synth.');
    });

    test('sectionKeys = [] (synth no carga señal wire)', () {
      final vm = buildSynthActorVM(_contact(id: 'X'));
      expect(vm.sectionKeys, isEmpty,
          reason:
              'La clasificación viene de supplierType local (priority 1), no '
              'de sectionKeys. Synth deja la lista vacía.');
    });

    test('assert falla si LocalContact está archivado', () {
      expect(
        () => buildSynthActorVM(
          LocalContactModel(
            id: 'X',
            workspaceId: 'ws-1',
            displayName: 'X',
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
            isDeleted: true,
          ),
        ),
        throwsA(isA<AssertionError>()),
        reason: 'merger filtra archived antes; sintetizar uno es bug',
      );
    });
  });

  group('buildSynthActorVM — matriz de acciones', () {
    test('phone + email + link → todas habilitadas', () {
      final vm = buildSynthActorVM(_contact(
        id: 'X',
        primaryPhoneE164: '+573001234567',
        primaryEmail: 'x@y.co',
        linkedProviderProfileId: 'prov-1',
      ));

      expect(_hasAction(vm.actions, NetworkActionType.call, enabled: true), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.whatsapp, enabled: true), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.email, enabled: true), isTrue);
      expect(
        _hasAction(vm.actions, NetworkActionType.viewProviderProfile,
            enabled: true),
        isTrue,
        reason: 'viewProfile habilitado solo con link',
      );
    });

    test('phone + email + SIN link → viewProfile disabled', () {
      final vm = buildSynthActorVM(_contact(
        id: 'X',
        primaryPhoneE164: '+573001234567',
        primaryEmail: 'x@y.co',
      ));

      expect(_hasAction(vm.actions, NetworkActionType.call, enabled: true), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.whatsapp, enabled: true), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.email, enabled: true), isTrue);
      expect(
        _hasAction(vm.actions, NetworkActionType.viewProviderProfile,
            enabled: false),
        isTrue,
        reason: 'sin link: viewProfile disabled con tooltip futuro '
            '"Disponible al sincronizar"',
      );
    });

    test('phone SIN email → email disabled', () {
      final vm = buildSynthActorVM(_contact(
        id: 'X',
        primaryPhoneE164: '+573001234567',
        primaryEmail: null,
      ));

      expect(_hasAction(vm.actions, NetworkActionType.call, enabled: true), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.whatsapp, enabled: true), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.email, enabled: false), isTrue);
    });

    test('SIN phone → call y whatsapp disabled (phoneNotAvailable)', () {
      final vm = buildSynthActorVM(_contact(
        id: 'X',
        primaryPhoneE164: null,
        primaryEmail: 'x@y.co',
      ));

      final call =
          vm.actions.firstWhere((a) => a.type == NetworkActionType.call);
      final wa =
          vm.actions.firstWhere((a) => a.type == NetworkActionType.whatsapp);

      expect(call.enabled, isFalse);
      expect(call.disabledReason, NetworkActionDisabledReason.phoneNotAvailable);
      expect(wa.enabled, isFalse);
      expect(wa.disabledReason, NetworkActionDisabledReason.phoneNotAvailable);
    });

    test('email vacío string "" → email disabled', () {
      final vm = buildSynthActorVM(_contact(
        id: 'X',
        primaryEmail: '',
      ));
      expect(_hasAction(vm.actions, NetworkActionType.email, enabled: false), isTrue);
    });

    test('phone vacío string "" → call y whatsapp disabled', () {
      final vm = buildSynthActorVM(_contact(
        id: 'X',
        primaryPhoneE164: '',
      ));
      expect(_hasAction(vm.actions, NetworkActionType.call, enabled: false), isTrue);
      expect(_hasAction(vm.actions, NetworkActionType.whatsapp, enabled: false), isTrue);
    });

    test('todas las acciones siempre presentes (enabled o disabled)', () {
      final vm = buildSynthActorVM(_contact(id: 'X')); // sin nada
      final types = vm.actions.map((a) => a.type).toSet();
      expect(types, contains(NetworkActionType.call));
      expect(types, contains(NetworkActionType.whatsapp));
      expect(types, contains(NetworkActionType.email));
      expect(types, contains(NetworkActionType.viewProviderProfile));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // visualStableKey — synth ancla UI al LocalContact.id
  // ──────────────────────────────────────────────────────────────────────────
  group('visualStableKey', () {
    test('synth siempre tiene visualStableKey = contact:<localContact.id>', () {
      final vm = buildSynthActorVM(_contact(id: 'XYZ-123'));
      expect(vm.visualStableKey, 'contact:XYZ-123',
          reason: 'synth ancla la key UI al LocalContact.id estable para '
              'que la transición synth → real no destruya el tile en Flutter');
    });

    test(
        'visualStableKey idéntico aunque cambien otros campos del contacto',
        () {
      final v1 = buildSynthActorVM(_contact(
        id: 'STABLE',
        displayName: 'Nombre A',
        supplier: SupplierType.services,
        primaryPhoneE164: '+1',
      ));
      final v2 = buildSynthActorVM(_contact(
        id: 'STABLE',
        displayName: 'Nombre B',
        supplier: SupplierType.products,
        primaryPhoneE164: '+2',
      ));
      expect(v1.visualStableKey, v2.visualStableKey,
          reason: 'la key estable solo depende de LocalContact.id, no del '
              'contenido — protege el tile contra rebuilds por edits');
    });
  });
}
