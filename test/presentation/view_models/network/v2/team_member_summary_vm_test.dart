// ============================================================================
// test/presentation/view_models/network/v2/team_member_summary_vm_test.dart
// TeamMemberSummaryVM — adaptador UI del equipo interno
// ============================================================================

import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:avanzza/presentation/view_models/network/v2/team_member_summary_vm.dart';
import 'package:flutter_test/flutter_test.dart';

TeamMemberSummaryDto _dto({
  String ref = 'user:u-1',
  List<String> teamRoleKeys = const [],
  String? primaryPhoneE164,
  String? primaryEmail,
}) =>
    TeamMemberSummaryDto.fromJson({
      'ref': ref,
      'membershipId': 'm-1',
      'displayName': 'Juan',
      'avatarRef': null,
      'teamRoleKeys': teamRoleKeys,
      'primaryPhoneE164': primaryPhoneE164,
      'primaryEmail': primaryEmail,
      'hasWhatsApp': false,
      'availableActions': const [],
      'updatedAt': '2026-05-01T10:00:00.000Z',
    });

void main() {
  group('TeamMemberSummaryVM.fromDto — campos básicos', () {
    test('mapea campos canónicos', () {
      final vm = TeamMemberSummaryVM.fromDto(_dto(ref: 'user:u-99'));
      expect(vm.ref.id, 'u-99');
      expect(vm.membershipId, 'm-1');
      expect(vm.displayName, 'Juan');
    });

    test('preserva teamRoleKeys en orden recibido', () {
      final vm = TeamMemberSummaryVM.fromDto(_dto(
        teamRoleKeys: ['admin', 'asset_manager'],
      ));
      expect(vm.teamRoleKeys, ['admin', 'asset_manager']);
    });
  });

  group('TeamMemberSummaryVM — groupKey', () {
    test('null cuando teamRoleKeys vacío', () {
      final vm = TeamMemberSummaryVM.fromDto(_dto(teamRoleKeys: const []));
      expect(vm.groupKey, isNull);
    });

    test('primer teamRoleKey cuando hay roles', () {
      final vm = TeamMemberSummaryVM.fromDto(_dto(
        teamRoleKeys: ['admin', 'finance'],
      ));
      expect(vm.groupKey, 'admin');
    });
  });

  group('TeamMemberSummaryVM — hasContactChannel', () {
    test('true con phone', () {
      final vm = TeamMemberSummaryVM.fromDto(_dto(
        primaryPhoneE164: '+573001112233',
      ));
      expect(vm.hasContactChannel, isTrue);
    });

    test('false sin phone ni email', () {
      final vm = TeamMemberSummaryVM.fromDto(_dto());
      expect(vm.hasContactChannel, isFalse);
    });
  });
}
