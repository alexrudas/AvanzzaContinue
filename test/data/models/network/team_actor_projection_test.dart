import 'dart:convert';

import 'package:avanzza/data/models/network/team_actor_projection.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:flutter_test/flutter_test.dart';

TeamMemberSummaryDto _makeTeamDto({
  String ref = 'user:user-uuid-1',
  String membershipId = 'mem-aaa-111',
  String? displayName = 'Alex Rudas',
  String? avatarRef,
  List<String> teamRoleKeys = const ['owner'],
  String? primaryPhoneE164 = '+573001234567',
  String? primaryEmail = 'alex@avanzza.co',
  bool hasWhatsApp = true,
  List<Map<String, dynamic>> availableActions = const [
    {'type': 'call', 'enabled': true},
    {'type': 'email', 'enabled': true},
  ],
  String? updatedAt,
}) {
  return TeamMemberSummaryDto.fromJson({
    'ref': ref,
    'membershipId': membershipId,
    'displayName': displayName,
    'avatarRef': avatarRef,
    'teamRoleKeys': teamRoleKeys,
    'primaryPhoneE164': primaryPhoneE164,
    'primaryEmail': primaryEmail,
    'hasWhatsApp': hasWhatsApp,
    'availableActions': availableActions,
    'updatedAt': updatedAt ?? '2026-05-10T22:42:42.594870Z',
  });
}

void main() {
  group('TeamActorProjection.fromSummaryDto — mapeo de campos', () {
    test('campos principales se preservan exactamente', () {
      final dto = _makeTeamDto(
        ref: 'user:user-abc',
        membershipId: 'mem-zzz',
        displayName: 'José Núñez',
        avatarRef: 'avatars/jose.png',
        teamRoleKeys: const ['owner', 'admin'],
        primaryPhoneE164: '+573009998888',
        primaryEmail: 'jose@avanzza.co',
        hasWhatsApp: false,
      );

      final p = TeamActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'jose nunez',
      );

      expect(p.actorRefRaw, 'user:user-abc');
      expect(p.userId, 'user-abc');
      expect(p.membershipId, 'mem-zzz');
      expect(p.displayName, 'José Núñez');
      expect(p.displayNameNormalized, 'jose nunez');
      expect(p.avatarRef, 'avatars/jose.png');
      expect(p.teamRoleKeys, ['owner', 'admin']);
      expect(p.primaryPhoneE164, '+573009998888');
      expect(p.primaryEmail, 'jose@avanzza.co');
      expect(p.hasWhatsApp, isFalse);
      expect(p.updatedAt, DateTime.parse('2026-05-10T22:42:42.594870Z'));
    });

    test('displayName null → "" en projection', () {
      final dto = _makeTeamDto(displayName: null);
      final p = TeamActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: '',
      );
      expect(p.displayName, '');
    });

    test('teamRoleKeys vacío se preserva como lista vacía', () {
      final dto = _makeTeamDto(teamRoleKeys: const []);
      final p = TeamActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(p.teamRoleKeys, isEmpty);
    });

    test('teamRoleKeys es inmutable (no permite mutación externa)', () {
      final dto = _makeTeamDto(teamRoleKeys: const ['owner']);
      final p = TeamActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      expect(() => p.teamRoleKeys.add('admin'), throwsUnsupportedError);
    });
  });

  group('TeamActorProjection — drops explícitos (anti-bloat)', () {
    test('availableActions del DTO NO aparece en projection', () {
      final dto = _makeTeamDto(
        availableActions: const [
          {'type': 'call', 'enabled': true},
          {'type': 'whatsapp', 'enabled': false, 'reason': 'phone_not_available'},
          {'type': 'email', 'enabled': true},
        ],
      );
      final p = TeamActorProjection.fromSummaryDto(
        dto,
        displayNameNormalized: 'x',
      );
      final json = p.toJson();
      expect(json.containsKey('availableActions'), isFalse,
          reason: 'availableActions debe recalcularse en runtime, no cachearse');
      expect(json.containsKey('availableActionsCompact'), isFalse);
    });
  });

  group('TeamActorProjection.toJson — guardrail de claves permitidas', () {
    const allowedKeys = <String>{
      'actorRefRaw',
      'userId',
      'membershipId',
      'displayName',
      'displayNameNormalized',
      'avatarRef',
      'teamRoleKeys',
      'primaryPhoneE164',
      'primaryEmail',
      'hasWhatsApp',
      'updatedAt',
    };

    test('toJson solo expone claves del allowlist', () {
      final p = TeamActorProjection.fromSummaryDto(
        _makeTeamDto(),
        displayNameNormalized: 'alex rudas',
      );
      final keys = p.toJson().keys.toSet();
      final unexpected = keys.difference(allowedKeys);
      expect(unexpected, isEmpty,
          reason: 'Claves no aprobadas en team projectionJson: $unexpected');
    });

    test('cada clave del allowlist aparece en toJson (no missing)', () {
      final p = TeamActorProjection.fromSummaryDto(
        _makeTeamDto(),
        displayNameNormalized: 'alex rudas',
      );
      final keys = p.toJson().keys.toSet();
      final missing = allowedKeys.difference(keys);
      expect(missing, isEmpty,
          reason: 'Claves del contrato faltan en toJson: $missing');
    });

    test('cardinalidad exacta del allowlist', () {
      expect(allowedKeys.length, 11,
          reason: 'Si añades/quitas un campo, actualiza la cardinalidad y '
              'justifica el cambio en el doc-comment del invariante.');
    });
  });

  group('TeamActorProjection — JSON codec roundtrip', () {
    test('projection → json → projection preserva todos los campos', () {
      final original = TeamActorProjection.fromSummaryDto(
        _makeTeamDto(
          ref: 'user:user-abc',
          membershipId: 'mem-zzz',
          displayName: 'José Núñez',
          teamRoleKeys: const ['owner', 'admin'],
        ),
        displayNameNormalized: 'jose nunez',
      );

      final json = original.toJson();
      final encoded = jsonEncode(json);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      final back = TeamActorProjection.fromJson(decoded);

      expect(back.actorRefRaw, original.actorRefRaw);
      expect(back.userId, original.userId);
      expect(back.membershipId, original.membershipId);
      expect(back.displayName, original.displayName);
      expect(back.displayNameNormalized, original.displayNameNormalized);
      expect(back.avatarRef, original.avatarRef);
      expect(back.teamRoleKeys, original.teamRoleKeys);
      expect(back.primaryPhoneE164, original.primaryPhoneE164);
      expect(back.primaryEmail, original.primaryEmail);
      expect(back.hasWhatsApp, original.hasWhatsApp);
      expect(back.updatedAt.toUtc(), original.updatedAt.toUtc());
    });

    test('roundtrip con valores null sobrevive', () {
      final original = TeamActorProjection.fromSummaryDto(
        _makeTeamDto(
          avatarRef: null,
          displayName: null,
          primaryPhoneE164: null,
          primaryEmail: null,
          teamRoleKeys: const [],
        ),
        displayNameNormalized: '',
      );
      final json = jsonDecode(jsonEncode(original.toJson()))
          as Map<String, dynamic>;
      final back = TeamActorProjection.fromJson(json);
      expect(back.avatarRef, isNull);
      expect(back.displayName, '');
      expect(back.primaryPhoneE164, isNull);
      expect(back.primaryEmail, isNull);
      expect(back.teamRoleKeys, isEmpty);
    });
  });

  group('Anti-bloat — tamaño serializado', () {
    test('team projection típica serializada < 1 KB', () {
      final p = TeamActorProjection.fromSummaryDto(
        _makeTeamDto(),
        displayNameNormalized: 'alex rudas',
      );
      final size = jsonEncode(p.toJson()).length;
      expect(size, lessThan(1024),
          reason: 'team projectionJson típico debe ser <1 KB; obtenido $size bytes');
    });
  });
}
