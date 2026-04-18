// ============================================================================
// test/domain/services/core_common/local_contact_remote_merger_test.dart
// LOCAL CONTACT REMOTE MERGER — Tests (F3.a endurecimiento)
// ============================================================================

import 'package:avanzza/data/models/core_common/remote/local_contact_remote_dto.dart';
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/services/core_common/local_contact_remote_merger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime.utc(2026, 4, 17, 10, 0, 0);
  final t1 = DateTime.utc(2026, 4, 17, 12, 0, 0);

  LocalContactEntity localWithPrivates() => LocalContactEntity(
        id: 'c-1',
        workspaceId: 'ws-1',
        displayName: 'Vendedor viejo',
        createdAt: t0,
        updatedAt: t0,
        organizationId: 'org-local-1',
        roleLabel: 'vendedor',
        notesPrivate: 'Contactar después de las 10am',
        tagsPrivate: const ['preferido'],
      );

  LocalContactRemoteDto remoteWithFreshPublics() => LocalContactRemoteDto(
        id: 'c-1',
        workspaceId: 'ws-1',
        displayName: 'Vendedor actualizado',
        createdAt: t0,
        updatedAt: t1,
        organizationId: 'org-local-1',
        roleLabel: 'vendedor_senior',
        primaryPhoneE164: '+573002223344',
      );

  group('hydrateNewLocalContactFromRemote', () {
    test('privados vacíos por construcción', () {
      final e = hydrateNewLocalContactFromRemote(remoteWithFreshPublics());

      expect(e.notesPrivate, isNull);
      expect(e.tagsPrivate, isEmpty);
    });

    test('copia campos públicos del remoto', () {
      final e = hydrateNewLocalContactFromRemote(remoteWithFreshPublics());

      expect(e.id, 'c-1');
      expect(e.displayName, 'Vendedor actualizado');
      expect(e.roleLabel, 'vendedor_senior');
      expect(e.primaryPhoneE164, '+573002223344');
    });
  });

  group('mergeExistingLocalContactWithRemote', () {
    test('preserva privados del local', () {
      final merged = mergeExistingLocalContactWithRemote(
        remote: remoteWithFreshPublics(),
        existingLocal: localWithPrivates(),
      );

      expect(merged.notesPrivate, 'Contactar después de las 10am');
      expect(merged.tagsPrivate, ['preferido']);
    });

    test('actualiza campos públicos del remoto', () {
      final merged = mergeExistingLocalContactWithRemote(
        remote: remoteWithFreshPublics(),
        existingLocal: localWithPrivates(),
      );

      expect(merged.displayName, 'Vendedor actualizado');
      expect(merged.roleLabel, 'vendedor_senior');
      expect(merged.primaryPhoneE164, '+573002223344');
      expect(merged.updatedAt, t1);
    });

    test('lanza ArgumentError si id no coincide', () {
      final local = localWithPrivates().copyWith(id: 'otro');

      expect(
        () => mergeExistingLocalContactWithRemote(
          remote: remoteWithFreshPublics(),
          existingLocal: local,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lanza ArgumentError si workspaceId no coincide', () {
      final local = localWithPrivates().copyWith(workspaceId: 'otra');

      expect(
        () => mergeExistingLocalContactWithRemote(
          remote: remoteWithFreshPublics(),
          existingLocal: local,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('invariantes de privacidad (round-trip completo)', () {
    test('privados NO viajan al remoto vía DTO.toJson', () {
      final local = localWithPrivates();
      final dto = LocalContactRemoteDto.fromEntity(local);
      final json = dto.toJson();

      expect(json.containsKey('notesPrivate'), isFalse);
      expect(json.containsKey('tagsPrivate'), isFalse);
    });

    test('privados NO se pierden al hidratar via merger', () {
      final local = localWithPrivates();
      final dto = LocalContactRemoteDto.fromEntity(local);
      final roundTrip = LocalContactRemoteDto.fromJson(dto.toJson());

      final merged = mergeExistingLocalContactWithRemote(
        remote: roundTrip,
        existingLocal: local,
      );

      expect(merged.notesPrivate, local.notesPrivate);
      expect(merged.tagsPrivate, local.tagsPrivate);
    });
  });
}
