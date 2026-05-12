// ============================================================================
// test/data/models/network/team_member_summary_dto_test.dart
// TeamMemberSummaryDto — invariante ref=user:* + parse teamRoleKeys
// ============================================================================

import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:avanzza/data/models/network/network_actor_ref.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _member({
  String ref = 'user:u-1',
  String membershipId = 'm-1',
  String? displayName = 'Juan Pérez',
  String? avatarRef,
  List<String> teamRoleKeys = const [],
  String? primaryPhoneE164 = '+573001112233',
  String? primaryEmail = 'juan@x.co',
  bool hasWhatsApp = true,
  List<Map<String, dynamic>> availableActions = const [],
  String updatedAt = '2026-05-01T10:00:00.000Z',
}) =>
    {
      'ref': ref,
      'membershipId': membershipId,
      'displayName': displayName,
      'avatarRef': avatarRef,
      'teamRoleKeys': teamRoleKeys,
      'primaryPhoneE164': primaryPhoneE164,
      'primaryEmail': primaryEmail,
      'hasWhatsApp': hasWhatsApp,
      'availableActions': availableActions,
      'updatedAt': updatedAt,
    };

void main() {
  group('TeamMemberSummaryDto — parse válido', () {
    test('miembro con campos básicos', () {
      final dto = TeamMemberSummaryDto.fromJson(_member());
      expect(dto.ref.kind, NetworkActorRefKind.user);
      expect(dto.ref.id, 'u-1');
      expect(dto.membershipId, 'm-1');
      expect(dto.displayName, 'Juan Pérez');
      expect(dto.teamRoleKeys, isEmpty);
    });

    test('miembro con teamRoleKeys preserva orden y claves opacas', () {
      final dto = TeamMemberSummaryDto.fromJson(_member(
        teamRoleKeys: ['admin', 'asset_manager', 'role_x_custom'],
      ));
      expect(dto.teamRoleKeys, ['admin', 'asset_manager', 'role_x_custom']);
    });

    test('miembro con availableActions de contacto', () {
      final dto = TeamMemberSummaryDto.fromJson(_member(
        availableActions: [
          {'type': 'call', 'enabled': true, 'domain': null, 'capability': null},
          {
            'type': 'email',
            'enabled': false,
            'domain': null,
            'capability': null,
            'reason': 'email_not_available'
          },
        ],
      ));
      expect(dto.availableActions, hasLength(2));
      expect(dto.availableActions[0].type, NetworkActionType.call);
      expect(dto.availableActions[1].enabled, isFalse);
      expect(
        dto.availableActions[1].reason,
        NetworkActionDisabledReason.emailNotAvailable,
      );
    });
  });

  group('TeamMemberSummaryDto — invariante ref=user:*', () {
    test('rechaza ref platform:*', () {
      expect(
        () => TeamMemberSummaryDto.fromJson(_member(ref: 'platform:p-1')),
        throwsFormatException,
      );
    });

    test('rechaza ref local:contact:*', () {
      expect(
        () =>
            TeamMemberSummaryDto.fromJson(_member(ref: 'local:contact:lc-1')),
        throwsFormatException,
      );
    });

    test('rechaza ref local:organization:*', () {
      expect(
        () => TeamMemberSummaryDto.fromJson(
            _member(ref: 'local:organization:lo-1')),
        throwsFormatException,
      );
    });

    test('rechaza ref con kind desconocido', () {
      expect(
        () => TeamMemberSummaryDto.fromJson(_member(ref: 'alien:x-1')),
        throwsFormatException,
      );
    });
  });

  group('TeamMemberSummaryDto — campos opcionales', () {
    test('displayName y avatarRef pueden ser null', () {
      final dto = TeamMemberSummaryDto.fromJson(_member(
        displayName: null,
        avatarRef: null,
      ));
      expect(dto.displayName, isNull);
      expect(dto.avatarRef, isNull);
    });

    test('phone y email pueden ser null', () {
      final dto = TeamMemberSummaryDto.fromJson(_member(
        primaryPhoneE164: null,
        primaryEmail: null,
      ));
      expect(dto.primaryPhoneE164, isNull);
      expect(dto.primaryEmail, isNull);
    });
  });

  group('TeamMemberSummaryDto — round-trip', () {
    test('toJson preserva campos canónicos', () {
      final dto = TeamMemberSummaryDto.fromJson(_member(
        ref: 'user:u-99',
        teamRoleKeys: ['admin'],
      ));
      final json = dto.toJson();
      expect(json['ref'], 'user:u-99');
      expect(json['teamRoleKeys'], ['admin']);
    });
  });
}
