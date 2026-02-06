// =============================================================================
// test/data/mappers/sample_mapper_test.dart
// =============================================================================

import 'package:avanzza/data/models/asset/asset_model.dart' as model;
import 'package:avanzza/domain/entities/asset/asset_content.dart' as content;
import 'package:avanzza/domain/entities/asset/asset_entity.dart' as entity;
import 'package:flutter_test/flutter_test.dart';

abstract final class AssetLegacyKeys {
  static const String orgId = 'orgId';
  static const String countryId = 'countryId';
  static const String regionId = 'regionId';
  static const String cityId = 'cityId';
  static const String etiquetas = 'etiquetas';
  static const String fotosUrls = 'fotosUrls';
}

abstract final class LegacyEstadoValues {
  static const String borrador = 'borrador';
  static const String pendiente = 'pendiente';
  static const String verificado = 'verificado';
  static const String activo = 'activo';
  static const String archivado = 'archivado';
}

Matcher get isNonNegativeNum => predicate<num>((v) => v >= 0, '>= 0');
Matcher get isNonEmptyString =>
    predicate<String>((v) => v.trim().isNotEmpty, 'non-empty string');

/// CO: placa/assetKey de vehículo debe ser 6 chars alfanuméricos uppercase.
Matcher get isAlphaNum6Upper => predicate<String>(
      (v) => RegExp(r'^[A-Z0-9]{6}$').hasMatch(v),
      'exactly 6 uppercase alphanumeric characters',
    );

void _assertIdIsDerivableTo6(String id) {
  expect(
    id.trim().length,
    greaterThanOrEqualTo(6),
    reason:
        'Vehicle placeholder derives 6 chars; provide id length >= 6 in fixtures.',
  );
}

void main() {
  group('AssetModel ↔ AssetEntity — Domain Mapping Contract (V2)', () {
    group('Round-trip preserves id, type and state', () {
      test('preserves id across Domain → Data → Domain', () {
        const expectedId = 'asset-uuid-001';
        final domainEntity = _createMinimalVehicleEntity(id: expectedId);

        final dataModel = model.AssetModel.fromEntity(domainEntity);
        final roundtrip = dataModel.toEntity();

        expect(roundtrip.id, equals(expectedId));
      });

      test('preserves AssetType across Domain → Data → Domain', () {
        final vehicleEntity = _createMinimalVehicleEntity();
        final realEstateEntity = _createMinimalRealEstateEntity();

        final vehicleRoundtrip =
            model.AssetModel.fromEntity(vehicleEntity).toEntity();
        final realEstateRoundtrip =
            model.AssetModel.fromEntity(realEstateEntity).toEntity();

        expect(vehicleRoundtrip.type, equals(entity.AssetType.vehicle));
        expect(realEstateRoundtrip.type, equals(entity.AssetType.realEstate));
      });

      test('preserves AssetState across Domain → Data → Domain', () {
        final activeEntity =
            _createMinimalVehicleEntity(state: entity.AssetState.active);
        final draftEntity =
            _createMinimalVehicleEntity(state: entity.AssetState.draft);

        final activeRoundtrip =
            model.AssetModel.fromEntity(activeEntity).toEntity();
        final draftRoundtrip =
            model.AssetModel.fromEntity(draftEntity).toEntity();

        expect(activeRoundtrip.state, equals(entity.AssetState.active));
        expect(draftRoundtrip.state, equals(entity.AssetState.draft));
      });
    });

    group('Legacy metadata transport', () {
      test('fromEntity extracts legacy fields from Domain metadata', () {
        final domainEntity = _createEntityWithLegacyMetadata(
          orgId: 'org-enterprise-001',
          countryId: 'CO',
          regionId: 'cundinamarca',
          cityId: 'bogota',
          etiquetas: const ['fleet', 'corporate'],
          fotosUrls: const ['https://cdn.example.com/asset1.jpg'],
        );

        final dataModel = model.AssetModel.fromEntity(domainEntity);

        expect(dataModel.orgId, equals('org-enterprise-001'));
        expect(dataModel.countryId, equals('CO'));
        expect(dataModel.regionId, equals('cundinamarca'));
        expect(dataModel.cityId, equals('bogota'));
        expect(dataModel.etiquetas, equals(['fleet', 'corporate']));
        expect(
          dataModel.fotosUrls,
          equals(['https://cdn.example.com/asset1.jpg']),
        );
      });

      test('toEntity reconstructs legacy fields back into Domain metadata', () {
        final dataModel = model.AssetModel(
          id: 'test-metadata-001',
          orgId: 'org-recon-001',
          assetType: 'vehicle',
          countryId: 'MX',
          regionId: 'cdmx',
          cityId: 'miguel-hidalgo',
          ownerType: 'org',
          ownerId: 'org-recon-001',
          estado: LegacyEstadoValues.activo,
          etiquetas: const ['imported', 'verified'],
          fotosUrls: const ['https://storage.example.com/photo.png'],
        );

        final domainEntity = dataModel.toEntity();

        expect(domainEntity.metadata[AssetLegacyKeys.orgId],
            equals('org-recon-001'));
        expect(domainEntity.metadata[AssetLegacyKeys.countryId], equals('MX'));
        expect(domainEntity.metadata[AssetLegacyKeys.regionId], equals('cdmx'));
        expect(domainEntity.metadata[AssetLegacyKeys.cityId],
            equals('miguel-hidalgo'));
        expect(domainEntity.metadata[AssetLegacyKeys.etiquetas],
            equals(['imported', 'verified']));
        expect(domainEntity.metadata[AssetLegacyKeys.fotosUrls],
            equals(['https://storage.example.com/photo.png']));
      });

      test('handles null optional legacy fields gracefully (no keys injected)',
          () {
        final dataModel = model.AssetModel(
          id: 'test-nullable-001',
          orgId: 'org-001',
          assetType: 'equipment',
          countryId: 'CO',
          regionId: null,
          cityId: null,
          ownerType: 'org',
          ownerId: 'org-001',
          estado: LegacyEstadoValues.borrador,
        );

        final domainEntity = dataModel.toEntity();

        expect(domainEntity.metadata.containsKey(AssetLegacyKeys.regionId),
            isFalse);
        expect(domainEntity.metadata.containsKey(AssetLegacyKeys.cityId), isFalse);
      });
    });

    group('BeneficialOwner mapping', () {
      test('fromEntity extracts ownerType and ownerId from BeneficialOwner', () {
        final beneficialOwner = entity.BeneficialOwner(
          ownerType: entity.BeneficialOwnerType.user,
          ownerId: 'user-enterprise-456',
          ownerName: 'María González',
          relationship: entity.OwnershipRelationship.owner,
          assignedAt: DateTime.utc(2024, 6, 15),
          assignedBy: 'admin-system',
        );

        final domainEntity = entity.AssetEntity.create(
          id: 'asset-with-owner-001',
          content: _createMinimalVehicleContent(),
          beneficialOwner: beneficialOwner,
          state: entity.AssetState.verified,
        );

        final dataModel = model.AssetModel.fromEntity(domainEntity);

        expect(dataModel.ownerType, equals('user'));
        expect(dataModel.ownerId, equals('user-enterprise-456'));
      });

      test('toEntity reconstructs BeneficialOwner when ownerId is present', () {
        final dataModel = model.AssetModel(
          id: 'test-owner-recon-001',
          orgId: 'org-001',
          assetType: 'vehicle',
          countryId: 'CO',
          ownerType: 'user',
          ownerId: 'user-reconstructed-789',
          estado: LegacyEstadoValues.activo,
        );

        final domainEntity = dataModel.toEntity();

        expect(domainEntity.beneficialOwner, isNotNull);
        expect(domainEntity.beneficialOwner!.ownerType,
            equals(entity.BeneficialOwnerType.user));
        expect(domainEntity.beneficialOwner!.ownerId,
            equals('user-reconstructed-789'));
        expect(domainEntity.beneficialOwner!.relationship,
            equals(entity.OwnershipRelationship.owner));
      });

      test('toEntity returns null BeneficialOwner when ownerId is empty', () {
        final dataModel = model.AssetModel(
          id: 'test-no-owner-001',
          orgId: 'org-001',
          assetType: 'machinery',
          countryId: 'CO',
          ownerType: 'org',
          ownerId: '',
          estado: LegacyEstadoValues.borrador,
        );

        final domainEntity = dataModel.toEntity();
        expect(domainEntity.beneficialOwner, isNull);
      });
    });

    group('Placeholder AssetContent creation (toEntity)', () {
      test('vehicle: assetKey is 6-char alphanum uppercase (CO rule)', () {
        final dataModel = _createDataModelForType('vehicle', 'VEH001');
        _assertIdIsDerivableTo6(dataModel.id);

        final domainEntity = dataModel.toEntity();
        expect(domainEntity.content, isA<content.VehicleContent>());

        final vehicle = domainEntity.content as content.VehicleContent;

        expect(vehicle.assetKey, equals('VEH001'));
        expect(vehicle.assetKey, isAlphaNum6Upper);

        expect(vehicle.brand, isNonEmptyString);
        expect(vehicle.model, isNonEmptyString);
        expect(vehicle.color, isNonEmptyString);
        expect(vehicle.engineDisplacement, isNonNegativeNum);
        expect(vehicle.mileage, isNonNegativeNum);
      });

      test('real_estate: assetKey keeps full identifier (variable length)', () {
        final dataModel =
            _createDataModelForType('real_estate', 'MAT-123456-789');

        final domainEntity = dataModel.toEntity();
        expect(domainEntity.content, isA<content.RealEstateContent>());

        final realEstate = domainEntity.content as content.RealEstateContent;

        expect(realEstate.assetKey, equals('MAT-123456-789'));
        // NO imponemos 6 chars aquí (regla tuya).
        expect(realEstate.address, isNonEmptyString);
        expect(realEstate.city, isNonEmptyString);
        expect(realEstate.area, isNonNegativeNum);
        expect(realEstate.usage, isNonEmptyString);
      });

      test('machinery: assetKey keeps full identifier (variable length)', () {
        final dataModel = _createDataModelForType('machinery', 'SERIAL-XYZ-99');

        final domainEntity = dataModel.toEntity();
        expect(domainEntity.content, isA<content.MachineryContent>());

        final machinery = domainEntity.content as content.MachineryContent;

        expect(machinery.assetKey, equals('SERIAL-XYZ-99'));
        expect(machinery.brand, isNonEmptyString);
        expect(machinery.model, isNonEmptyString);
      });

      test('equipment: assetKey keeps full identifier (variable length)', () {
        final dataModel = _createDataModelForType('equipment', 'INV-00001234');

        final domainEntity = dataModel.toEntity();
        expect(domainEntity.content, isA<content.EquipmentContent>());

        final equipment = domainEntity.content as content.EquipmentContent;

        expect(equipment.assetKey, equals('INV-00001234'));
        expect(equipment.name, isNonEmptyString);
      });
    });

    group('Legacy Spanish estado → AssetState mapping', () {
      final mapping = <String, entity.AssetState>{
        LegacyEstadoValues.borrador: entity.AssetState.draft,
        LegacyEstadoValues.pendiente: entity.AssetState.pendingOwnership,
        LegacyEstadoValues.verificado: entity.AssetState.verified,
        LegacyEstadoValues.activo: entity.AssetState.active,
        LegacyEstadoValues.archivado: entity.AssetState.archived,
      };

      for (final entry in mapping.entries) {
        test('maps "${entry.key}" to AssetState.${entry.value.name}', () {
          final dataModel = model.AssetModel(
            id: 'test-estado-${entry.key}',
            orgId: 'org-001',
            assetType: 'vehicle',
            countryId: 'CO',
            ownerType: 'org',
            ownerId: 'org-001',
            estado: entry.key,
          );

          final domainEntity = dataModel.toEntity();

          expect(domainEntity.state, equals(entry.value));
        });
      }
    });

    group('AssetState → legacy Spanish estado mapping', () {
      final mapping = <entity.AssetState, String>{
        entity.AssetState.draft: LegacyEstadoValues.borrador,
        entity.AssetState.pendingOwnership: LegacyEstadoValues.pendiente,
        entity.AssetState.verified: LegacyEstadoValues.verificado,
        entity.AssetState.active: LegacyEstadoValues.activo,
        entity.AssetState.archived: LegacyEstadoValues.archivado,
      };

      for (final entry in mapping.entries) {
        test('maps AssetState.${entry.key.name} to "${entry.value}"', () {
          final domainEntity = _createMinimalVehicleEntity(state: entry.key);
          final dataModel = model.AssetModel.fromEntity(domainEntity);
          expect(dataModel.estado, equals(entry.value));
        });
      }
    });
  });
}

// =============================================================================
// FIXTURES V2
// =============================================================================

content.AssetContent _createMinimalVehicleContent() {
  return const content.AssetContent.vehicle(
    assetKey: 'ABC123',
    brand: 'TOYOTA',
    model: '2024',
    color: 'BLANCO',
    engineDisplacement: 1600.0,
    mileage: 0,
  );
}

content.AssetContent _createMinimalRealEstateContent() {
  return const content.AssetContent.realEstate(
    assetKey: 'MAT-987654-321',
    address: 'Calle 1 # 2-3',
    city: 'BOGOTA',
    area: 80.0,
    usage: 'RESIDENCIAL',
    propertyType: 'CASA',
  );
}

entity.AssetEntity _createMinimalVehicleEntity({
  String id = 'test-vehicle-001',
  entity.AssetState state = entity.AssetState.active,
}) {
  return entity.AssetEntity.create(
    id: id,
    content: _createMinimalVehicleContent(),
    state: state,
  );
}

entity.AssetEntity _createMinimalRealEstateEntity({
  String id = 'test-realestate-001',
  entity.AssetState state = entity.AssetState.active,
}) {
  return entity.AssetEntity.create(
    id: id,
    content: _createMinimalRealEstateContent(),
    state: state,
  );
}

entity.AssetEntity _createEntityWithLegacyMetadata({
  required String orgId,
  required String countryId,
  String? regionId,
  String? cityId,
  List<String> etiquetas = const [],
  List<String> fotosUrls = const [],
}) {
  return entity.AssetEntity.create(
    id: 'test-with-metadata-001',
    content: _createMinimalVehicleContent(),
    state: entity.AssetState.active,
    metadata: {
      AssetLegacyKeys.orgId: orgId,
      AssetLegacyKeys.countryId: countryId,
      if (regionId != null) AssetLegacyKeys.regionId: regionId,
      if (cityId != null) AssetLegacyKeys.cityId: cityId,
      AssetLegacyKeys.etiquetas: etiquetas,
      AssetLegacyKeys.fotosUrls: fotosUrls,
    },
  );
}

model.AssetModel _createDataModelForType(String assetType, String id) {
  return model.AssetModel(
    id: id,
    orgId: 'org-fixture',
    assetType: assetType,
    countryId: 'CO',
    ownerType: 'org',
    ownerId: 'org-fixture',
    estado: LegacyEstadoValues.activo,
  );
}
