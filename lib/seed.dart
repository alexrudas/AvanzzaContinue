import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/domain/entities/asset/asset_content.dart';
import 'package:avanzza/domain/entities/asset/asset_entity.dart';
import 'package:avanzza/domain/entities/geo/country_entity.dart';
import 'package:avanzza/domain/entities/maintenance/incidencia_entity.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedMain() async {
  // await Bootstrap.init();
  final di = DIContainer();

  // GEO: country + city
  final country = CountryEntity(
    id: 'CO',
    name: 'Colombia',
    iso3: 'COL',
    documentTypes: const ['CC', 'NIT'],
    nationalHolidays: const [],
    isActive: true,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
  await di.geoRepository.upsertCountry(country);

  // final city = CityEntity(
  //   id: 'bogota',
  //   countryId: 'CO',
  //   regionId: 'cund',
  //   name: 'Bogotá',
  //   lat: 4.71,
  //   lng: -74.07,
  //   isActive: true,
  //   createdAt: DateTime.now().toUtc(),
  //   updatedAt: DateTime.now().toUtc(),
  // );

  // No direct upsert on cities; simulate via local DS through repository fetch to trigger sync
  await di.geoRepository.fetchCities(countryId: 'CO');

  // Organization
  final org = OrganizationEntity(
    id: 'org_demo',
    nombre: 'Org Demo',
    tipo: 'empresa',
    countryId: 'CO',
    regionId: 'cund',
    cityId: 'bogota',
    ownerUid: 'user_demo',
    logoUrl: null,
    metadata: const {'seed': true},
    isActive: true,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
  await di.orgRepository.upsertOrg(org);

  // Membership
  final membership = MembershipEntity(
    userId: 'user_demo',
    orgId: 'org_demo',
    orgName: 'Org Demo',
    roles: const ['admin'],
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO', 'cityId': 'bogota'},
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
  // No dedicated upsert; insert via remote by creating document directly
  await FirebaseFirestore.instance
      .collection('memberships')
      .doc('${membership.userId}_${membership.orgId}')
      .set({
    'userId': membership.userId,
    'orgId': membership.orgId,
    'orgName': membership.orgName,
    'roles': membership.roles,
    'estatus': membership.estatus,
    'primaryLocation': membership.primaryLocation,
    'createdAt': membership.createdAt,
    'updatedAt': membership.updatedAt,
  }, SetOptions(merge: true));

  // Assets
  // Assets (V2)
  // Nota: orgId/countryId/regionId/cityId/etiquetas/fotosUrls ahora van en metadata legacy.
  final asset1 = AssetEntity.create(
    id: 'asset_demo_1',
    state: AssetState.active,
    content: const AssetContent.vehicle(
      assetKey: 'ABC123', // placa (CO = 6 chars)
      brand: 'PENDIENTE',
      model: '2024', // V2: String
      color: 'PENDIENTE',
      engineDisplacement: 0, // default seguro
      mileage: 0,
    ),
    beneficialOwner: BeneficialOwner(
      ownerType: BeneficialOwnerType.org,
      ownerId: 'org_demo',
      ownerName: 'Org Demo',
      relationship: OwnershipRelationship.owner,
      assignedAt: DateTime.now().toUtc(),
      assignedBy: 'seed',
    ),
    metadata: {
      'orgId': 'org_demo',
      'countryId': 'CO',
      'regionId': 'cund',
      'cityId': 'bogota',
      'etiquetas': ['demo'],
      'fotosUrls': <String>[],
      'seed': true,
    },
  );
  await di.assetRepository.upsertAsset(asset1);

  final asset2 = AssetEntity.create(
    id: 'asset_demo_2',
    state: AssetState.active,
    content: const AssetContent.realEstate(
      assetKey: 'MATRICULA-123456', // NO 6 chars, ok (solo vehículos son 6)
      address: 'PENDIENTE',
      city: 'BOGOTA',
      area: 0,
      usage: 'PENDIENTE',
    ),
    beneficialOwner: BeneficialOwner(
      ownerType: BeneficialOwnerType.org,
      ownerId: 'org_demo',
      ownerName: 'Org Demo',
      relationship: OwnershipRelationship.owner,
      assignedAt: DateTime.now().toUtc(),
      assignedBy: 'seed',
    ),
    metadata: {
      'orgId': 'org_demo',
      'countryId': 'CO',
      'regionId': 'cund',
      'cityId': 'bogota',
      'etiquetas': ['demo'],
      'fotosUrls': <String>[],
      'seed': true,
    },
  );
  await di.assetRepository.upsertAsset(asset2);

  // Incidencia
  final incidencia = IncidenciaEntity(
    id: 'inc_demo_1',
    orgId: 'org_demo',
    assetId: 'asset_demo_1',
    descripcion: 'Golpe leve en puerta',
    fotosUrls: const [],
    prioridad: 'baja',
    estado: 'abierta',
    reportedBy: 'user_demo',
    cityId: 'bogota',
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
  await di.maintenanceRepository.upsertIncidencia(incidencia);

  // Done
  // ignore: avoid_print
  print('Seed completed');
}
