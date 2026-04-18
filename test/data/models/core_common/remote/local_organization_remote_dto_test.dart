// ============================================================================
// test/data/models/core_common/remote/local_organization_remote_dto_test.dart
// LOCAL ORGANIZATION REMOTE DTO — Tests contractuales (F3.a endurecido)
// ============================================================================
// Foco:
//   - fromEntity descarta notesPrivate y tagsPrivate.
//   - toJson NO emite notesPrivate ni tagsPrivate.
//   - fromJson tolera ausencia de esos campos.
//   - NO existe método toEntity() en el DTO (se testea por construcción:
//     la clase no expone tal API).
//   - Soft delete viaja al remoto.
// ============================================================================

import 'package:avanzza/data/models/core_common/remote/local_organization_remote_dto.dart';
import 'package:avanzza/domain/entities/core_common/local_organization_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 4, 17, 12, 0, 0);

  LocalOrganizationEntity sampleEntity() => LocalOrganizationEntity(
        id: 'org-local-1',
        workspaceId: 'ws-1',
        displayName: 'Taller La Roca',
        createdAt: now,
        updatedAt: now,
        legalName: 'Taller La Roca S.A.S.',
        taxId: '900123456',
        primaryPhoneE164: '+573001234567',
        primaryEmail: 'contacto@laroca.co',
        website: 'https://laroca.co',
        notesPrivate: 'Cliente VIP — condiciones especiales',
        tagsPrivate: const ['vip', 'repuestos_motor'],
        snapshotSourcePlatformActorId: 'actor-42',
        snapshotAdoptedAt: now,
        isDeleted: false,
      );

  group('fromEntity descarta privados', () {
    test('toJson no contiene notesPrivate ni tagsPrivate', () {
      final dto = LocalOrganizationRemoteDto.fromEntity(sampleEntity());
      final json = dto.toJson();

      expect(json.containsKey('notesPrivate'), isFalse);
      expect(json.containsKey('tagsPrivate'), isFalse);
    });

    test('preserva los campos públicos', () {
      final dto = LocalOrganizationRemoteDto.fromEntity(sampleEntity());

      expect(dto.id, 'org-local-1');
      expect(dto.workspaceId, 'ws-1');
      expect(dto.displayName, 'Taller La Roca');
      expect(dto.legalName, 'Taller La Roca S.A.S.');
      expect(dto.taxId, '900123456');
      expect(dto.primaryPhoneE164, '+573001234567');
      expect(dto.primaryEmail, 'contacto@laroca.co');
      expect(dto.website, 'https://laroca.co');
      expect(dto.snapshotSourcePlatformActorId, 'actor-42');
      expect(dto.isDeleted, isFalse);
    });
  });

  group('fromJson tolera ausencia de privados', () {
    test('JSON sin privados se deserializa sin error', () {
      final payload = <String, dynamic>{
        'id': 'org-x',
        'workspaceId': 'ws-x',
        'displayName': 'Proveedor X',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'isDeleted': false,
      };

      final dto = LocalOrganizationRemoteDto.fromJson(payload);

      expect(dto.id, 'org-x');
      expect(dto.displayName, 'Proveedor X');
      expect(dto.legalName, isNull);
    });
  });

  group('soft delete se preserva en el contrato remoto', () {
    test('isDeleted=true y deletedAt viajan al DTO', () {
      final e = sampleEntity().copyWith(isDeleted: true, deletedAt: now);

      final dto = LocalOrganizationRemoteDto.fromEntity(e);
      final json = dto.toJson();

      expect(json['isDeleted'], isTrue);
      expect(json['deletedAt'], isNotNull);
    });
  });

  group('no existe ruta insegura DTO → Entity', () {
    test('la clase NO expone toEntity(): obliga a pasar por el merger', () {
      // Verificación de contrato por construcción: si alguien agrega toEntity()
      // en el futuro, este aserto se vuelve trivial de mantener — pero el
      // test principal es el TIPOADO: el editor/análisis estático no debe
      // ofrecer el método. Aquí solo dejamos una nota explícita y el test
      // de soporte en el merger.
      final dto = LocalOrganizationRemoteDto.fromEntity(sampleEntity());

      // ignore: avoid_dynamic_calls
      expect(
        () {
          // Intentar llamar un método inexistente vía dynamic.
          // Si alguien agrega toEntity(), este test pasaría y el guard debe
          // complementarse con el test en el merger.
          final d = dto as dynamic;
          // Llamada dinámica que DEBE lanzar NoSuchMethodError en runtime.
          // ignore: unused_local_variable
          final _ = d.toEntity;
          // Si llegamos aquí sin excepción, el DTO recuperó toEntity — fallar.
          fail('El DTO no debe exponer toEntity().');
        },
        throwsNoSuchMethodError,
      );
    });
  });
}
