// ============================================================================
// test/data/models/network/network_envelope_test.dart
// NetworkPageEnvelope + summary envelopes — schemaVersion + paginación
// ============================================================================
// Cubre:
//   - kNetworkSchemaVersion=2 vs kTeamSchemaVersion=1 (independientes).
//   - Mismatch entre versión recibida y esperada lanza tipado.
//   - schemaVersion ausente o no-int lanza FormatException.
//   - items vacío + nextCursor null es válido (lista vacía).
//   - serverTime se parsea como DateTime.
//   - Summary envelopes (network categories + team summary) heredan la
//     política de schemaVersion del endpoint que cada uno representa.
// ============================================================================

import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_envelope.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:avanzza/data/models/network/unsupported_schema_version_exception.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _validNetworkActor({String ref = 'platform:p-1'}) => {
      'ref': ref,
      'displayName': 'Taller Central',
      'avatarRef': null,
      'unresolved': false,
      'categories': ['workshop'],
      'primaryCategory': 'workshop',
      'isTeamMember': false,
      'isRestricted': false,
      'restrictionReason': null,
      'primaryPhoneE164': '+573001112233',
      'primaryEmail': 'x@y.co',
      'hasWhatsApp': true,
      'relationshipState': 'vinculada',
      'providerProfileId': null,
      'availableActions': const [],
      'updatedAt': '2026-05-01T10:00:00.000Z',
    };

Map<String, dynamic> _validTeamMember({String ref = 'user:u-1'}) => {
      'ref': ref,
      'membershipId': 'm-1',
      'displayName': 'Juan',
      'avatarRef': null,
      'teamRoleKeys': const <String>[],
      'primaryPhoneE164': null,
      'primaryEmail': null,
      'hasWhatsApp': false,
      'availableActions': const [],
      'updatedAt': '2026-05-01T10:00:00.000Z',
    };

void main() {
  group('NetworkPageEnvelope — schemaVersion network (esperado v2)', () {
    test('schemaVersion=2 parsea correctamente', () {
      final env = NetworkPageEnvelope.fromJson(
        {
          'schemaVersion': kNetworkSchemaVersion,
          'items': [_validNetworkActor()],
          'nextCursor': 'c2Vjb25k',
          'serverTime': '2026-05-01T10:00:00.000Z',
        },
        parseItem: NetworkActorSummaryDto.fromJson,
        endpoint: 'GET /v1/network',
        expectedSchemaVersion: kNetworkSchemaVersion,
      );
      expect(env.schemaVersion, kNetworkSchemaVersion);
      expect(env.items, hasLength(1));
      expect(env.nextCursor, 'c2Vjb25k');
      expect(env.isLastPage, isFalse);
    });

    test('schemaVersion=999 lanza UnsupportedSchemaVersionException tipado',
        () {
      expect(
        () => NetworkPageEnvelope.fromJson(
          {
            'schemaVersion': 999,
            'items': const [],
            'nextCursor': null,
            'serverTime': '2026-05-01T10:00:00.000Z',
          },
          parseItem: NetworkActorSummaryDto.fromJson,
          endpoint: 'GET /v1/network',
          expectedSchemaVersion: kNetworkSchemaVersion,
        ),
        throwsA(isA<UnsupportedSchemaVersionException>()
            .having((e) => e.received, 'received', 999)
            .having((e) => e.endpoint, 'endpoint', 'GET /v1/network')
            .having((e) => e.supported, 'supported', [kNetworkSchemaVersion])),
      );
    });

    test('si backend regresa al v1 con expected=v2 también lanza tipado', () {
      // Defensa contra rollback no coordinado del backend.
      expect(
        () => NetworkPageEnvelope.fromJson(
          {
            'schemaVersion': 1,
            'items': const [],
            'nextCursor': null,
            'serverTime': '2026-05-01T10:00:00.000Z',
          },
          parseItem: NetworkActorSummaryDto.fromJson,
          endpoint: 'GET /v1/network',
          expectedSchemaVersion: kNetworkSchemaVersion,
        ),
        throwsA(isA<UnsupportedSchemaVersionException>()
            .having((e) => e.received, 'received', 1)),
      );
    });
  });

  group('NetworkPageEnvelope — schemaVersion team (esperado v1)', () {
    test('schemaVersion=1 parsea correctamente con expected=team', () {
      final env = NetworkPageEnvelope.fromJson(
        {
          'schemaVersion': kTeamSchemaVersion,
          'items': [_validTeamMember()],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        },
        parseItem: TeamMemberSummaryDto.fromJson,
        endpoint: 'GET /v1/team',
        expectedSchemaVersion: kTeamSchemaVersion,
      );
      expect(env.schemaVersion, kTeamSchemaVersion);
      expect(env.items, hasLength(1));
    });

    test('si team responde con v2 y expected=v1 lanza tipado', () {
      // Network y team evolucionan independientes: si team bumpeara a v2
      // sin que esta build se actualice, debemos detectarlo.
      expect(
        () => NetworkPageEnvelope.fromJson(
          {
            'schemaVersion': 2,
            'items': const [],
            'nextCursor': null,
            'serverTime': '2026-05-01T10:00:00.000Z',
          },
          parseItem: TeamMemberSummaryDto.fromJson,
          endpoint: 'GET /v1/team',
          expectedSchemaVersion: kTeamSchemaVersion,
        ),
        throwsA(isA<UnsupportedSchemaVersionException>()
            .having((e) => e.received, 'received', 2)),
      );
    });
  });

  group('NetworkPageEnvelope — schemaVersion ausente o malformado', () {
    test('schemaVersion ausente lanza FormatException', () {
      expect(
        () => NetworkPageEnvelope.fromJson(
          {
            'items': const [],
            'nextCursor': null,
            'serverTime': '2026-05-01T10:00:00.000Z',
          },
          parseItem: NetworkActorSummaryDto.fromJson,
          endpoint: 'GET /v1/network',
          expectedSchemaVersion: kNetworkSchemaVersion,
        ),
        throwsFormatException,
      );
    });

    test('schemaVersion como string lanza FormatException', () {
      expect(
        () => NetworkPageEnvelope.fromJson(
          {
            'schemaVersion': '2',
            'items': const [],
            'nextCursor': null,
            'serverTime': '2026-05-01T10:00:00.000Z',
          },
          parseItem: NetworkActorSummaryDto.fromJson,
          endpoint: 'GET /v1/network',
          expectedSchemaVersion: kNetworkSchemaVersion,
        ),
        throwsFormatException,
      );
    });
  });

  group('NetworkPageEnvelope — items y paginación', () {
    test('items vacío + nextCursor null es válido (lista vacía)', () {
      final env = NetworkPageEnvelope.fromJson(
        {
          'schemaVersion': kNetworkSchemaVersion,
          'items': const [],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        },
        parseItem: NetworkActorSummaryDto.fromJson,
        endpoint: 'GET /v1/network',
        expectedSchemaVersion: kNetworkSchemaVersion,
      );
      expect(env.items, isEmpty);
      expect(env.isLastPage, isTrue);
    });

    test('nextCursor=null marca última página', () {
      final env = NetworkPageEnvelope.fromJson(
        {
          'schemaVersion': kNetworkSchemaVersion,
          'items': [_validNetworkActor()],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        },
        parseItem: NetworkActorSummaryDto.fromJson,
        endpoint: 'GET /v1/network',
        expectedSchemaVersion: kNetworkSchemaVersion,
      );
      expect(env.isLastPage, isTrue);
    });

    test('items se parsea con el callback genérico (TeamMember)', () {
      final env = NetworkPageEnvelope.fromJson(
        {
          'schemaVersion': kTeamSchemaVersion,
          'items': [_validTeamMember(), _validTeamMember(ref: 'user:u-2')],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        },
        parseItem: TeamMemberSummaryDto.fromJson,
        endpoint: 'GET /v1/team',
        expectedSchemaVersion: kTeamSchemaVersion,
      );
      expect(env.items, hasLength(2));
      expect(env.items[0].ref.id, 'u-1');
      expect(env.items[1].ref.id, 'u-2');
    });

    test('serverTime se parsea como DateTime', () {
      final env = NetworkPageEnvelope.fromJson(
        {
          'schemaVersion': kNetworkSchemaVersion,
          'items': const [],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        },
        parseItem: NetworkActorSummaryDto.fromJson,
        endpoint: 'GET /v1/network',
        expectedSchemaVersion: kNetworkSchemaVersion,
      );
      expect(env.serverTime.year, 2026);
      expect(env.serverTime.month, 5);
      expect(env.serverTime.day, 1);
    });
  });

  group('NetworkCategoriesSummaryEnvelope (network — espera v2)', () {
    test('schemaVersion=2 + externalActiveCount parsea', () {
      final env = NetworkCategoriesSummaryEnvelope.fromJson({
        'schemaVersion': kNetworkSchemaVersion,
        'externalActiveCount': 42,
        'serverTime': '2026-05-01T10:00:00.000Z',
      });
      expect(env.externalActiveCount, 42);
    });

    test('schemaVersion incompatible lanza tipado', () {
      expect(
        () => NetworkCategoriesSummaryEnvelope.fromJson({
          'schemaVersion': 99,
          'externalActiveCount': 0,
          'serverTime': '2026-05-01T10:00:00.000Z',
        }),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });
  });

  group('TeamSummaryEnvelope (team — espera v1)', () {
    test('schemaVersion=1 + activeCount parsea', () {
      final env = TeamSummaryEnvelope.fromJson({
        'schemaVersion': kTeamSchemaVersion,
        'activeCount': 7,
        'serverTime': '2026-05-01T10:00:00.000Z',
      });
      expect(env.activeCount, 7);
    });

    test('schemaVersion incompatible lanza tipado', () {
      expect(
        () => TeamSummaryEnvelope.fromJson({
          'schemaVersion': 0,
          'activeCount': 0,
          'serverTime': '2026-05-01T10:00:00.000Z',
        }),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });
  });
}
