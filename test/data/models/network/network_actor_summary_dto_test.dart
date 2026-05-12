// ============================================================================
// test/data/models/network/network_actor_summary_dto_test.dart
// NetworkActorSummaryDto — invariantes y parse contractual
// ============================================================================

import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:avanzza/data/models/network/network_actor_ref.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _actor({
  String ref = 'platform:p-1',
  String? displayName = 'Taller Central',
  String? avatarRef,
  bool unresolved = false,
  List<String> categories = const ['workshop'],
  String primaryCategory = 'workshop',
  bool isTeamMember = false,
  bool isRestricted = false,
  String? restrictionReason,
  String? primaryPhoneE164 = '+573001112233',
  String? primaryEmail = 'taller@x.co',
  bool hasWhatsApp = true,
  String relationshipState = 'vinculada',
  String? providerProfileId,
  List<Map<String, dynamic>> availableActions = const [],
  String updatedAt = '2026-05-01T10:00:00.000Z',
}) =>
    {
      'ref': ref,
      'displayName': displayName,
      'avatarRef': avatarRef,
      'unresolved': unresolved,
      'categories': categories,
      'primaryCategory': primaryCategory,
      'isTeamMember': isTeamMember,
      'isRestricted': isRestricted,
      'restrictionReason': restrictionReason,
      'primaryPhoneE164': primaryPhoneE164,
      'primaryEmail': primaryEmail,
      'hasWhatsApp': hasWhatsApp,
      'relationshipState': relationshipState,
      'providerProfileId': providerProfileId,
      'availableActions': availableActions,
      'updatedAt': updatedAt,
    };

void main() {
  group('NetworkActorSummaryDto — parse mínimo válido', () {
    test('actor con 1 categoría y campos básicos', () {
      final dto = NetworkActorSummaryDto.fromJson(_actor());
      expect(dto.ref.kind, NetworkActorRefKind.platform);
      expect(dto.categories, [NetworkCategory.workshop]);
      expect(dto.primaryCategory, NetworkCategory.workshop);
      expect(dto.isRestricted, isFalse);
      expect(dto.relationshipState, NetworkRelationshipState.vinculada);
      expect(dto.availableActions, isEmpty);
    });

    test('actor con múltiples categorías', () {
      final dto = NetworkActorSummaryDto.fromJson(_actor(
        categories: ['owner', 'driver'],
        primaryCategory: 'owner',
      ));
      expect(dto.categories, [NetworkCategory.owner, NetworkCategory.driver]);
      expect(dto.primaryCategory, NetworkCategory.owner);
    });

    test('actor con ref local:contact:', () {
      final dto =
          NetworkActorSummaryDto.fromJson(_actor(ref: 'local:contact:lc-9'));
      expect(dto.ref.kind, NetworkActorRefKind.local);
      expect(dto.ref.localSubKind, NetworkLocalRefKind.contact);
    });
  });

  group('NetworkActorSummaryDto — invariantes', () {
    test('rechaza ref user:* (reservado a /v1/team)', () {
      expect(
        () => NetworkActorSummaryDto.fromJson(_actor(ref: 'user:u-1')),
        throwsFormatException,
      );
    });

    test('rechaza categories vacío', () {
      expect(
        () => NetworkActorSummaryDto.fromJson(_actor(categories: const [])),
        throwsFormatException,
      );
    });

    test('rechaza primaryCategory fuera de categories', () {
      expect(
        () => NetworkActorSummaryDto.fromJson(_actor(
          categories: ['workshop'],
          primaryCategory: 'legal',
        )),
        throwsFormatException,
      );
    });

    test('isRestricted=true requiere phone y email null', () {
      expect(
        () => NetworkActorSummaryDto.fromJson(_actor(
          isRestricted: true,
          restrictionReason: 'suspended',
          primaryPhoneE164: '+573001112233',
          primaryEmail: null,
        )),
        throwsFormatException,
      );
      expect(
        () => NetworkActorSummaryDto.fromJson(_actor(
          isRestricted: true,
          restrictionReason: 'suspended',
          primaryPhoneE164: null,
          primaryEmail: 'x@y.co',
        )),
        throwsFormatException,
      );
    });

    test('isRestricted=true requiere restrictionReason', () {
      expect(
        () => NetworkActorSummaryDto.fromJson(_actor(
          isRestricted: true,
          restrictionReason: null,
          primaryPhoneE164: null,
          primaryEmail: null,
        )),
        throwsFormatException,
      );
    });

    test('isRestricted=true válido con phone/email null', () {
      final dto = NetworkActorSummaryDto.fromJson(_actor(
        isRestricted: true,
        restrictionReason: 'closed',
        primaryPhoneE164: null,
        primaryEmail: null,
      ));
      expect(dto.isRestricted, isTrue);
      expect(dto.restrictionReason, NetworkRestrictionReason.closed);
      expect(dto.primaryPhoneE164, isNull);
      expect(dto.primaryEmail, isNull);
    });
  });

  group('NetworkActorSummaryDto — availableActions orden preservado', () {
    test('acciones se preservan en el orden recibido', () {
      final dto = NetworkActorSummaryDto.fromJson(_actor(
        availableActions: [
          {'type': 'call', 'enabled': true, 'domain': null, 'capability': null},
          {
            'type': 'whatsapp',
            'enabled': false,
            'domain': null,
            'capability': null,
            'reason': 'phone_not_available'
          },
          {
            'type': 'request_quote',
            'enabled': true,
            'domain': 'purchase-request',
            'capability': 'purchase_request.create',
          },
        ],
      ));
      expect(dto.availableActions.map((a) => a.type).toList(), [
        NetworkActionType.call,
        NetworkActionType.whatsapp,
        NetworkActionType.requestQuote,
      ]);
    });
  });

  group('NetworkActorSummaryDto — forward-compat', () {
    test('categoría desconocida cae a unclassified', () {
      final dto = NetworkActorSummaryDto.fromJson(_actor(
        categories: ['unclassified'],
        primaryCategory: 'unclassified',
      ));
      expect(dto.primaryCategory, NetworkCategory.unclassified);
    });
  });

  group('NetworkActorSummaryDto — round-trip', () {
    test('toJson preserva campos canónicos', () {
      final json = _actor(
        ref: 'local:organization:lo-7',
        categories: ['provider', 'workshop'],
        primaryCategory: 'provider',
        providerProfileId: 'pp-22',
      );
      final dto = NetworkActorSummaryDto.fromJson(json);
      final back = dto.toJson();
      expect(back['ref'], 'local:organization:lo-7');
      expect(back['categories'], ['provider', 'workshop']);
      expect(back['primaryCategory'], 'provider');
      expect(back['providerProfileId'], 'pp-22');
    });
  });
}
