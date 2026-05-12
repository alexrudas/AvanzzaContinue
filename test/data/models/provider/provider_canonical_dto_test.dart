// ============================================================================
// test/data/models/provider/provider_canonical_dto_test.dart
// ProviderCanonicalDto — Mappers Wire ↔ Domain (Hito 1)
// ============================================================================
// Cubre:
//   - REQUEST serialization:
//       * source.kind LOCAL_CONTACT con localKind/localId.
//       * source.kind EXISTING_PLATFORM_ACTOR sin localKind/localId.
//       * identity.actorKind person ↔ organization (campos coherentes).
//       * probes presentes vs ausentes (omitidas cuando empty).
//       * ReplaceSpecialtiesRequestDto (specialtyIds + ISO updatedAt).
//   - RESPONSE parsing:
//       * Shape completa (POST + GET) → entity correcta.
//       * `resolution` / `identityConfidence` se DESCARTAN antes de domain.
//       * Specialties con kind PRODUCT/SERVICE/BOTH → entity poblada.
//       * Specialty con kind desconocido → SKIP (drift defensivo).
//       * Faltan campos requeridos → FormatException con mensaje.
//       * `actorKind` desconocido → ArgumentError (fail-fast).
//       * `responseRateAvg` num o null → double? correcto.
// ============================================================================

import 'package:avanzza/domain/entities/catalog/specialty_entity.dart'
    show SpecialtyKind;
import 'package:avanzza/domain/entities/provider/provider_canonical_entity.dart';
import 'package:avanzza/data/models/provider/provider_canonical_dto.dart';
import 'package:avanzza/domain/repositories/provider/provider_canonical_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ════════════════════════════════════════════════════════════════════════
  // REQUEST SERIALIZATION
  // ════════════════════════════════════════════════════════════════════════

  group('ProvisionProviderRequestDto.toJson', () {
    test('LOCAL_CONTACT con probes serializa en la shape exacta del backend', () {
      final input = ProvisionProviderInput(
        source: ProvisionProviderSource.localContact(localId: 'lc-1'),
        identity: const ProvisionProviderIdentity(
          displayName: 'Lubricentro X',
          actorKind: ProviderActorKind.organization,
          legalName: 'Lubricentro X SAS',
        ),
        probes: const [
          ProvisionProviderProbe(
            keyTypeWire: 'phoneE164',
            normalizedValue: '+573001234567',
          ),
          ProvisionProviderProbe(
            keyTypeWire: 'docId',
            normalizedValue: '900123456',
          ),
        ],
      );

      final json = ProvisionProviderRequestDto(input).toJson();

      expect(json['source'], {
        'kind': 'LOCAL_CONTACT',
        'localKind': 'contact',
        'localId': 'lc-1',
      });
      expect(json['identity'], {
        'displayName': 'Lubricentro X',
        'actorKind': 'organization',
        'legalName': 'Lubricentro X SAS',
      });
      expect(json['probes'], [
        {'keyType': 'phoneE164', 'normalizedValue': '+573001234567'},
        {'keyType': 'docId', 'normalizedValue': '900123456'},
      ]);
    });

    test('LOCAL_ORGANIZATION serializa con localKind=organization', () {
      final input = ProvisionProviderInput(
        source: ProvisionProviderSource.localOrganization(localId: 'lo-1'),
        identity: const ProvisionProviderIdentity(
          displayName: 'Acme',
          actorKind: ProviderActorKind.organization,
          legalName: 'Acme SAS',
        ),
      );

      final json = ProvisionProviderRequestDto(input).toJson();

      expect(json['source']['kind'], 'LOCAL_ORGANIZATION');
      expect(json['source']['localKind'], 'organization');
      expect(json['source']['localId'], 'lo-1');
      // Sin platformActorId (es LOCAL_*).
      expect(json['source'].containsKey('platformActorId'), isFalse);
      // Sin probes → key omitida del body.
      expect(json.containsKey('probes'), isFalse);
    });

    test('EXISTING_PLATFORM_ACTOR omite localKind/localId', () {
      final input = ProvisionProviderInput(
        source:
            ProvisionProviderSource.existingPlatformActor(platformActorId: 'pa-7'),
        identity: const ProvisionProviderIdentity(
          displayName: 'Acme',
          actorKind: ProviderActorKind.organization,
          legalName: 'Acme SAS',
        ),
      );

      final json = ProvisionProviderRequestDto(input).toJson();

      expect(json['source'], {
        'kind': 'EXISTING_PLATFORM_ACTOR',
        'platformActorId': 'pa-7',
      });
      expect(json['source'].containsKey('localKind'), isFalse);
      expect(json['source'].containsKey('localId'), isFalse);
    });

    test('actorKind=person serializa fullLegalName y omite legalName', () {
      final input = ProvisionProviderInput(
        source: ProvisionProviderSource.localContact(localId: 'lc-2'),
        identity: const ProvisionProviderIdentity(
          displayName: 'Juan',
          actorKind: ProviderActorKind.person,
          fullLegalName: 'Juan Carlos Pérez',
        ),
      );

      final json = ProvisionProviderRequestDto(input).toJson();

      expect(json['identity']['actorKind'], 'person');
      expect(json['identity']['fullLegalName'], 'Juan Carlos Pérez');
      expect(json['identity'].containsKey('legalName'), isFalse);
    });
  });

  group('ReplaceSpecialtiesRequestDto.toJson', () {
    test('serializa specialtyIds + providerProfileUpdatedAt en ISO 8601', () {
      final dto = ReplaceSpecialtiesRequestDto(
        specialtyIds: {'sp-1', 'sp-2'},
        providerProfileUpdatedAt: DateTime.utc(2026, 4, 26, 12, 0, 0),
      );
      final json = dto.toJson();

      // Set → List (orden no garantizado pero contenido sí).
      expect((json['specialtyIds'] as List).toSet(), {'sp-1', 'sp-2'});
      expect(json['providerProfileUpdatedAt'], '2026-04-26T12:00:00.000Z');
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // RESPONSE PARSING
  // ════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> validResponse({
    Map<String, dynamic>? overrides,
    List<Map<String, dynamic>>? specialties,
  }) {
    return {
      'providerProfileId': 'pp-1',
      'workspaceId': 'ws-1',
      'platformActorId': 'pa-1',
      'displayName': 'Lubricentro X',
      'actorKind': 'organization',
      'legalName': 'Lubricentro X SAS',
      'fullLegalName': null,
      'isActive': true,
      'responseRateAvg': null,
      'notes': null,
      'specialties': specialties ?? const [],
      'createdAt': '2026-04-26T12:00:00.000Z',
      'updatedAt': '2026-04-26T12:05:00.000Z',
      ...?overrides,
    };
  }

  group('ProviderCanonicalResponseDto.fromJson + toEntity', () {
    test('shape completa parsea a entity con specialties pobladas', () {
      final json = validResponse(specialties: const [
        {
          'id': 'sp-1',
          'key': 'vehicle.engine',
          'name': 'Engine repair',
          'kind': 'SERVICE',
        },
        {
          'id': 'sp-2',
          'key': 'vehicle.tires',
          'name': 'Tires',
          'kind': 'PRODUCT',
        },
      ]);

      final dto = ProviderCanonicalResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.providerProfileId, 'pp-1');
      expect(entity.workspaceId, 'ws-1');
      expect(entity.platformActorId, 'pa-1');
      expect(entity.actorKind, ProviderActorKind.organization);
      expect(entity.legalName, 'Lubricentro X SAS');
      expect(entity.fullLegalName, isNull);
      expect(entity.specialties, hasLength(2));
      expect(entity.specialties[0].id, 'sp-1');
      expect(entity.specialties[0].kind, SpecialtyKind.service);
      expect(entity.specialties[1].kind, SpecialtyKind.product);
      expect(entity.createdAt.toIso8601String(), '2026-04-26T12:00:00.000Z');
      expect(entity.updatedAt.toIso8601String(), '2026-04-26T12:05:00.000Z');
    });

    test('campos diagnostic-only NO cruzan a domain', () {
      final json = validResponse(overrides: {
        'resolution': 'CREATED_PROFILE',
        'identityConfidence': 'declared',
      });

      final dto = ProviderCanonicalResponseDto.fromJson(json);
      // El DTO sí los expone (data layer).
      expect(dto.resolution, 'CREATED_PROFILE');
      expect(dto.identityConfidence, 'declared');

      final entity = dto.toEntity();
      // La entity de domain NO tiene esos campos. La verificación es que
      // el toEntity no lanza ni los referencia. Cualquier consumidor del
      // domain NO puede leer `resolution`/`identityConfidence`.
      expect(entity.providerProfileId, 'pp-1');
    });

    test('actorKind=person poblado correctamente', () {
      final json = validResponse(overrides: {
        'actorKind': 'person',
        'legalName': null,
        'fullLegalName': 'Juan Carlos Pérez',
      });
      final entity = ProviderCanonicalResponseDto.fromJson(json).toEntity();

      expect(entity.actorKind, ProviderActorKind.person);
      expect(entity.legalName, isNull);
      expect(entity.fullLegalName, 'Juan Carlos Pérez');
    });

    test('responseRateAvg num → double, null → null', () {
      final entityWith =
          ProviderCanonicalResponseDto.fromJson(validResponse(overrides: {
        'responseRateAvg': 0.85,
      })).toEntity();
      expect(entityWith.responseRateAvg, 0.85);

      final entityNull = ProviderCanonicalResponseDto.fromJson(validResponse())
          .toEntity();
      expect(entityNull.responseRateAvg, isNull);
    });

    test('specialty con kind desconocido se DESCARTA (drift defensivo)', () {
      final json = validResponse(specialties: const [
        {
          'id': 'sp-1',
          'key': 'k1',
          'name': 'OK',
          'kind': 'SERVICE',
        },
        {
          'id': 'sp-2',
          'key': 'k2',
          'name': 'Drift',
          'kind': 'FUTURE_KIND', // backend introdujo un kind nuevo
        },
      ]);
      final entity = ProviderCanonicalResponseDto.fromJson(json).toEntity();

      // Solo sp-1 sobrevive — sp-2 se descartó silenciosamente.
      expect(entity.specialties, hasLength(1));
      expect(entity.specialties[0].id, 'sp-1');
    });

    test('falta campo requerido → FormatException', () {
      final base = validResponse();
      base.remove('providerProfileId');

      expect(
        () => ProviderCanonicalResponseDto.fromJson(base),
        throwsFormatException,
      );
    });

    test('campo requerido con tipo incorrecto → FormatException', () {
      final base = validResponse(overrides: {
        'isActive': 'true', // debería ser bool, no String
      });
      expect(
        () => ProviderCanonicalResponseDto.fromJson(base),
        throwsFormatException,
      );
    });

    test('actorKind desconocido → ArgumentError en toEntity (fail-fast)', () {
      final json = validResponse(overrides: {
        'actorKind': 'robot', // wire desconocido
      });
      final dto = ProviderCanonicalResponseDto.fromJson(json);
      // El DTO acepta el string opaco. La explosión ocurre en toEntity()
      // cuando se intenta resolver el enum — fail-fast deliberado.
      expect(() => dto.toEntity(), throwsA(isA<ArgumentError>()));
    });

    test('specialties ausente → FormatException', () {
      final base = validResponse();
      base.remove('specialties');
      expect(
        () => ProviderCanonicalResponseDto.fromJson(base),
        throwsFormatException,
      );
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // SPECIALTY DTO
  // ════════════════════════════════════════════════════════════════════════

  group('ProviderCanonicalSpecialtyDto.fromJson + toEntityOrNull', () {
    test('PRODUCT/SERVICE/BOTH se mapean correctamente', () {
      for (final entry in {
        'PRODUCT': SpecialtyKind.product,
        'SERVICE': SpecialtyKind.service,
        'BOTH': SpecialtyKind.both,
      }.entries) {
        final dto = ProviderCanonicalSpecialtyDto.fromJson({
          'id': 'sp-x',
          'key': 'k',
          'name': 'name',
          'kind': entry.key,
        });
        final entity = dto.toEntityOrNull();
        expect(entity, isNotNull);
        expect(entity!.kind, entry.value);
      }
    });

    test('id vacío → FormatException', () {
      expect(
        () => ProviderCanonicalSpecialtyDto.fromJson({
          'id': '',
          'key': 'k',
          'name': 'name',
          'kind': 'SERVICE',
        }),
        throwsFormatException,
      );
    });

    test('kind desconocido → toEntityOrNull retorna null (NO throws)', () {
      final dto = ProviderCanonicalSpecialtyDto.fromJson({
        'id': 'sp-1',
        'key': 'k',
        'name': 'name',
        'kind': 'NEW_FUTURE_KIND',
      });
      // El parseo del JSON pasa (kind es String).
      // toEntityOrNull captura el ArgumentError de fromWire → null.
      expect(dto.toEntityOrNull(), isNull);
    });
  });
}
