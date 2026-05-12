// ============================================================================
// test/presentation/view_models/network/v2/network_actor_summary_vm_test.dart
// NetworkActorSummaryVM.fromDto — adaptador UI con groupCategory + helpers
// ============================================================================

import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_actor_summary_vm.dart';
import 'package:flutter_test/flutter_test.dart';

NetworkActorSummaryDto _dto({
  String ref = 'platform:p-1',
  bool unresolved = false,
  List<String> categories = const ['workshop'],
  String primaryCategory = 'workshop',
  bool isRestricted = false,
  String? restrictionReason,
  String? primaryPhoneE164 = '+573001112233',
  String? primaryEmail = 'x@y.co',
  List<Map<String, dynamic>> availableActions = const [],
}) =>
    NetworkActorSummaryDto.fromJson({
      'ref': ref,
      'displayName': 'Taller',
      'avatarRef': null,
      'unresolved': unresolved,
      'categories': categories,
      'primaryCategory': primaryCategory,
      'isTeamMember': false,
      'isRestricted': isRestricted,
      'restrictionReason': restrictionReason,
      'primaryPhoneE164': primaryPhoneE164,
      'primaryEmail': primaryEmail,
      'hasWhatsApp': true,
      'relationshipState': 'vinculada',
      'providerProfileId': null,
      'availableActions': availableActions,
      'updatedAt': '2026-05-01T10:00:00.000Z',
    });

void main() {
  group('NetworkActorSummaryVM.fromDto — campos básicos', () {
    test('groupCategory == primaryCategory del DTO', () {
      final vm = NetworkActorSummaryVM.fromDto(_dto(
        categories: ['provider', 'workshop'],
        primaryCategory: 'provider',
      ));
      expect(vm.groupCategory, NetworkCategory.provider);
      expect(vm.categories,
          [NetworkCategory.provider, NetworkCategory.workshop]);
    });

    test('actions se mapean en orden preservado', () {
      final vm = NetworkActorSummaryVM.fromDto(_dto(
        availableActions: [
          {'type': 'call', 'enabled': true, 'domain': null, 'capability': null},
          {
            'type': 'whatsapp',
            'enabled': false,
            'domain': null,
            'capability': null,
            'reason': 'phone_not_available'
          },
        ],
      ));
      expect(vm.actions.map((a) => a.type).toList(), [
        NetworkActionType.call,
        NetworkActionType.whatsapp,
      ]);
      expect(vm.actions[1].showsDisabledHint, isTrue);
    });
  });

  group('NetworkActorSummaryVM — helpers UI', () {
    test('isPlatform / isLocal según ref kind', () {
      final platform = NetworkActorSummaryVM.fromDto(_dto(ref: 'platform:p-1'));
      final local = NetworkActorSummaryVM.fromDto(
          _dto(ref: 'local:contact:lc-9'));
      expect(platform.isPlatform, isTrue);
      expect(platform.isLocal, isFalse);
      expect(local.isPlatform, isFalse);
      expect(local.isLocal, isTrue);
    });

    test('hasContactChannel: true si phone o email', () {
      final con = NetworkActorSummaryVM.fromDto(_dto(
        primaryPhoneE164: '+573001112233',
        primaryEmail: null,
      ));
      expect(con.hasContactChannel, isTrue);
    });

    test('hasContactChannel: false cuando ambos null', () {
      final sin = NetworkActorSummaryVM.fromDto(_dto(
        primaryPhoneE164: null,
        primaryEmail: null,
      ));
      expect(sin.hasContactChannel, isFalse);
    });

    test('isRestricted=true ⇒ hasContactChannel=false (DTO ya forzó null)', () {
      final restricted = NetworkActorSummaryVM.fromDto(_dto(
        isRestricted: true,
        restrictionReason: 'suspended',
        primaryPhoneE164: null,
        primaryEmail: null,
      ));
      expect(restricted.isRestricted, isTrue);
      expect(restricted.restrictionReason,
          NetworkRestrictionReason.suspended);
      expect(restricted.hasContactChannel, isFalse);
    });

    test('requiresInvitationCta: solo local + unresolved', () {
      final platformResolved = NetworkActorSummaryVM.fromDto(_dto(
        ref: 'platform:p-1',
        unresolved: false,
      ));
      final localResolved = NetworkActorSummaryVM.fromDto(_dto(
        ref: 'local:contact:lc-1',
        unresolved: false,
      ));
      final localUnresolved = NetworkActorSummaryVM.fromDto(_dto(
        ref: 'local:contact:lc-2',
        unresolved: true,
      ));
      expect(platformResolved.requiresInvitationCta, isFalse);
      expect(localResolved.requiresInvitationCta, isFalse);
      expect(localUnresolved.requiresInvitationCta, isTrue);
    });
  });
}
