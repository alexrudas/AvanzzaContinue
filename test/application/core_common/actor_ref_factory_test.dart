// ============================================================================
// test/application/core_common/actor_ref_factory_test.dart
// ActorRefFactory — disciplina de attestSelf (ADR actor-canon §8)
// ============================================================================
// Valida que attestSelf sea FALSE en flujo normal y TRUE solo en el método
// explícito "fresh". El controller y cualquier vertical consumen este
// factory; no deben decidir attestSelf por cuenta propia.
// ============================================================================

import 'package:avanzza/application/core_common/actor_ref_factory.dart';
import 'package:avanzza/domain/entities/core_common/actor_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActorRefFactory.fromKnownLocalContactIds — flujo normal', () {
    test('attestSelf=false (es la regla del ADR, no una decisión del caller)',
        () {
      final built = ActorRefFactory.fromKnownLocalContactIds(
        const ['ct-1', 'ct-2'],
      );
      expect(built.attestSelf, isFalse);
    });

    test('produce ActorRef.local(kind=contact) por cada id', () {
      final built = ActorRefFactory.fromKnownLocalContactIds(
        const ['ct-1', 'ct-2'],
      );
      expect(built.refs, hasLength(2));
      expect(
        built.refs.first,
        const ActorRef.local(localKind: LocalKind.contact, localId: 'ct-1'),
      );
      expect(
        built.refs.last,
        const ActorRef.local(localKind: LocalKind.contact, localId: 'ct-2'),
      );
    });

    test('colección vacía produce refs vacíos y attestSelf=false', () {
      final built = ActorRefFactory.fromKnownLocalContactIds(const []);
      expect(built.refs, isEmpty);
      expect(built.attestSelf, isFalse);
    });
  });

  group('ActorRefFactory.fromFreshlyCreatedLocalContactIds — excepción', () {
    test('attestSelf=true (uso acotado: primer write post-alta)', () {
      final built = ActorRefFactory.fromFreshlyCreatedLocalContactIds(
        const ['ct-new'],
      );
      expect(built.attestSelf, isTrue);
    });

    test('produce ActorRef.local(kind=contact) por cada id', () {
      final built = ActorRefFactory.fromFreshlyCreatedLocalContactIds(
        const ['ct-a'],
      );
      expect(built.refs, [
        const ActorRef.local(localKind: LocalKind.contact, localId: 'ct-a'),
      ]);
    });
  });

  group('Variantes de organización', () {
    test('fromKnownLocalOrganizationIds → attestSelf=false + kind=organization',
        () {
      final built = ActorRefFactory.fromKnownLocalOrganizationIds(
        const ['org-1'],
      );
      expect(built.attestSelf, isFalse);
      expect(
        built.refs.single,
        const ActorRef.local(
            localKind: LocalKind.organization, localId: 'org-1'),
      );
    });

    test(
        'fromFreshlyCreatedLocalOrganizationIds → attestSelf=true + kind=organization',
        () {
      final built = ActorRefFactory.fromFreshlyCreatedLocalOrganizationIds(
        const ['org-new'],
      );
      expect(built.attestSelf, isTrue);
      expect(built.refs.single.toJson()['localKind'], 'organization');
    });
  });
}
