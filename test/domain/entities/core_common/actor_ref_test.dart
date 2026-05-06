// ============================================================================
// test/domain/entities/core_common/actor_ref_test.dart
// ActorRef — serialización wire y helpers
// ============================================================================
// See docs/adr/0001-actor-canon.md (regla 2.5 — contrato ActorRef único).
// ============================================================================

import 'package:avanzza/domain/entities/core_common/actor_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActorRef.local', () {
    test('serializa con kind=local + localKind + localId', () {
      const ref = ActorRef.local(
        localKind: LocalKind.contact,
        localId: 'ct-123',
      );
      expect(ref.toJson(), {
        'kind': 'local',
        'localKind': 'contact',
        'localId': 'ct-123',
      });
    });

    test('variante organization serializa kind=local + localKind=organization', () {
      const ref = ActorRef.local(
        localKind: LocalKind.organization,
        localId: 'org-9',
      );
      expect(ref.toJson()['localKind'], 'organization');
      expect(ref.toJson()['kind'], 'local');
    });

    test('no incluye platformActorId en el JSON', () {
      const ref = ActorRef.local(
        localKind: LocalKind.contact,
        localId: 'ct-1',
      );
      expect(ref.toJson().containsKey('platformActorId'), isFalse);
    });

    test('roundtrip fromJson/toJson', () {
      const ref = ActorRef.local(
        localKind: LocalKind.contact,
        localId: 'ct-77',
      );
      final rebuilt = ActorRef.fromJson(ref.toJson());
      expect(rebuilt, ref);
    });
  });

  group('ActorRef.platform', () {
    test('serializa con kind=platform + platformActorId', () {
      const ref = ActorRef.platform(platformActorId: 'pa-42');
      expect(ref.toJson(), {
        'kind': 'platform',
        'platformActorId': 'pa-42',
      });
    });

    test('no incluye localKind/localId en el JSON', () {
      const ref = ActorRef.platform(platformActorId: 'pa-1');
      expect(ref.toJson().containsKey('localKind'), isFalse);
      expect(ref.toJson().containsKey('localId'), isFalse);
    });

    test('roundtrip fromJson/toJson', () {
      const ref = ActorRef.platform(platformActorId: 'pa-99');
      final rebuilt = ActorRef.fromJson(ref.toJson());
      expect(rebuilt, ref);
    });
  });

  group('Helpers', () {
    test('actorRefFromLocalContactId construye variante local/contact', () {
      final ref = actorRefFromLocalContactId('ct-abc');
      expect(ref.toJson(), {
        'kind': 'local',
        'localKind': 'contact',
        'localId': 'ct-abc',
      });
    });

    test('actorRefFromLocalOrganizationId construye variante local/organization',
        () {
      final ref = actorRefFromLocalOrganizationId('org-xyz');
      expect(ref.toJson(), {
        'kind': 'local',
        'localKind': 'organization',
        'localId': 'org-xyz',
      });
    });
  });

  group('LocalKind wireNames', () {
    test('wireName coincide con TargetLocalKind del backend', () {
      expect(LocalKind.contact.wireName, 'contact');
      expect(LocalKind.organization.wireName, 'organization');
    });

    test('fromWire parsea valores válidos', () {
      expect(LocalKind.fromWire('contact'), LocalKind.contact);
      expect(LocalKind.fromWire('organization'), LocalKind.organization);
    });

    test('fromWire lanza ArgumentError con valor desconocido', () {
      expect(() => LocalKind.fromWire('banana'), throwsArgumentError);
    });
  });
}
