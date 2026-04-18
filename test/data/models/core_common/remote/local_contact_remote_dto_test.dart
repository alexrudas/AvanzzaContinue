// ============================================================================
// test/data/models/core_common/remote/local_contact_remote_dto_test.dart
// LOCAL CONTACT REMOTE DTO — Tests contractuales (F3.a endurecido)
// ============================================================================

import 'package:avanzza/data/models/core_common/remote/local_contact_remote_dto.dart';
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 4, 17, 12, 0, 0);

  LocalContactEntity sampleEntity() => LocalContactEntity(
        id: 'contact-1',
        workspaceId: 'ws-1',
        displayName: 'Juan Pérez',
        createdAt: now,
        updatedAt: now,
        organizationId: 'org-local-1',
        roleLabel: 'vendedor',
        primaryPhoneE164: '+573009876543',
        primaryEmail: 'juan.perez@taller.co',
        docId: '1020304050',
        notesPrivate: 'Prefiere llamadas en la mañana',
        tagsPrivate: const ['preferido', 'motor'],
        isDeleted: false,
      );

  group('fromEntity descarta privados', () {
    test('toJson no contiene notesPrivate ni tagsPrivate', () {
      final dto = LocalContactRemoteDto.fromEntity(sampleEntity());
      final json = dto.toJson();

      expect(json.containsKey('notesPrivate'), isFalse);
      expect(json.containsKey('tagsPrivate'), isFalse);
    });

    test('preserva campos públicos, incluidos organizationId y roleLabel', () {
      final dto = LocalContactRemoteDto.fromEntity(sampleEntity());

      expect(dto.id, 'contact-1');
      expect(dto.organizationId, 'org-local-1');
      expect(dto.roleLabel, 'vendedor');
      expect(dto.primaryPhoneE164, '+573009876543');
      expect(dto.docId, '1020304050');
    });
  });

  group('contacto suelto (organizationId=null)', () {
    test('preserva organizationId null en el DTO', () {
      final e = sampleEntity().copyWith(organizationId: null);
      final dto = LocalContactRemoteDto.fromEntity(e);

      expect(dto.organizationId, isNull);
      // El toJson no lanza al serializar con nulls.
      expect(() => dto.toJson(), returnsNormally);
    });
  });

  group('no existe ruta insegura DTO → Entity', () {
    test('la clase NO expone toEntity()', () {
      final dto = LocalContactRemoteDto.fromEntity(sampleEntity());

      expect(
        () {
          final d = dto as dynamic;
          // ignore: unused_local_variable
          final _ = d.toEntity;
          fail('El DTO no debe exponer toEntity().');
        },
        throwsNoSuchMethodError,
      );
    });
  });
}
