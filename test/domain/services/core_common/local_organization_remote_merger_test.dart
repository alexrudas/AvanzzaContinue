// ============================================================================
// test/domain/services/core_common/local_organization_remote_merger_test.dart
// LOCAL ORGANIZATION REMOTE MERGER — Tests (F3.a endurecimiento)
// ============================================================================
// Foco:
//   - hydrateNew retorna entity con notesPrivate=null y tagsPrivate=[].
//   - mergeExisting preserva notesPrivate y tagsPrivate del local.
//   - mergeExisting actualiza campos públicos con los valores del remoto.
//   - mergeExisting lanza ArgumentError si id o workspaceId no coinciden.
//   - Los privados NO viajan al remoto (via DTO.toJson()).
//   - Los privados NO se pierden al hidratar desde remoto (via merger).
// ============================================================================

import 'package:avanzza/data/models/core_common/remote/local_organization_remote_dto.dart';
import 'package:avanzza/domain/entities/core_common/local_organization_entity.dart';
import 'package:avanzza/domain/services/core_common/local_organization_remote_merger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime.utc(2026, 4, 17, 10, 0, 0);
  final t1 = DateTime.utc(2026, 4, 17, 12, 0, 0);

  LocalOrganizationEntity localWithPrivates() => LocalOrganizationEntity(
        id: 'org-1',
        workspaceId: 'ws-1',
        displayName: 'Taller local (viejo)',
        createdAt: t0,
        updatedAt: t0,
        primaryPhoneE164: '+573000000000',
        notesPrivate: 'Nota privada del admin: descuento 10%',
        tagsPrivate: const ['vip', 'descuento'],
        isDeleted: false,
      );

  LocalOrganizationRemoteDto remoteWithFreshPublics() =>
      LocalOrganizationRemoteDto(
        id: 'org-1',
        workspaceId: 'ws-1',
        displayName: 'Taller actualizado',
        createdAt: t0,
        updatedAt: t1,
        legalName: 'Taller S.A.S.',
        taxId: '900999999',
        primaryPhoneE164: '+573001111111',
        isDeleted: false,
      );

  group('hydrateNewLocalOrganizationFromRemote', () {
    test('retorna Entity con privados vacíos por construcción', () {
      final remote = remoteWithFreshPublics();
      final e = hydrateNewLocalOrganizationFromRemote(remote);

      expect(e.notesPrivate, isNull);
      expect(e.tagsPrivate, isEmpty);
    });

    test('copia los campos públicos del remoto', () {
      final remote = remoteWithFreshPublics();
      final e = hydrateNewLocalOrganizationFromRemote(remote);

      expect(e.id, 'org-1');
      expect(e.workspaceId, 'ws-1');
      expect(e.displayName, 'Taller actualizado');
      expect(e.legalName, 'Taller S.A.S.');
      expect(e.taxId, '900999999');
      expect(e.primaryPhoneE164, '+573001111111');
      expect(e.updatedAt, t1);
    });
  });

  group('mergeExistingLocalOrganizationWithRemote', () {
    test('preserva notesPrivate y tagsPrivate del local', () {
      final local = localWithPrivates();
      final remote = remoteWithFreshPublics();

      final merged = mergeExistingLocalOrganizationWithRemote(
        remote: remote,
        existingLocal: local,
      );

      expect(merged.notesPrivate, 'Nota privada del admin: descuento 10%');
      expect(merged.tagsPrivate, ['vip', 'descuento']);
    });

    test('toma los campos públicos del remoto (autoridad)', () {
      final local = localWithPrivates();
      final remote = remoteWithFreshPublics();

      final merged = mergeExistingLocalOrganizationWithRemote(
        remote: remote,
        existingLocal: local,
      );

      expect(merged.displayName, 'Taller actualizado');
      expect(merged.primaryPhoneE164, '+573001111111');
      expect(merged.legalName, 'Taller S.A.S.');
      expect(merged.taxId, '900999999');
      expect(merged.updatedAt, t1);
    });

    test('lanza ArgumentError si ids no coinciden', () {
      final local = localWithPrivates().copyWith(id: 'otro-id');
      final remote = remoteWithFreshPublics();

      expect(
        () => mergeExistingLocalOrganizationWithRemote(
          remote: remote,
          existingLocal: local,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lanza ArgumentError si workspaceId no coincide', () {
      final local = localWithPrivates().copyWith(workspaceId: 'ws-otra');
      final remote = remoteWithFreshPublics();

      expect(
        () => mergeExistingLocalOrganizationWithRemote(
          remote: remote,
          existingLocal: local,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('invariantes de privacidad (round-trip contrato completo)', () {
    test('los privados NO viajan al remoto (vía DTO.toJson)', () {
      final local = localWithPrivates();
      final dto = LocalOrganizationRemoteDto.fromEntity(local);
      final json = dto.toJson();

      expect(json.containsKey('notesPrivate'), isFalse);
      expect(json.containsKey('tagsPrivate'), isFalse);
    });

    test('los privados NO se pierden al hidratar desde remoto (vía merger)',
        () {
      final local = localWithPrivates();
      // Simulamos: entity local → DTO → viaja por red → vuelve DTO →
      // fusión con local preserva privados.
      final dto = LocalOrganizationRemoteDto.fromEntity(local);
      final roundTrip = LocalOrganizationRemoteDto.fromJson(dto.toJson());

      final merged = mergeExistingLocalOrganizationWithRemote(
        remote: roundTrip,
        existingLocal: local,
      );

      expect(merged.notesPrivate, local.notesPrivate);
      expect(merged.tagsPrivate, local.tagsPrivate);
    });
  });
}
