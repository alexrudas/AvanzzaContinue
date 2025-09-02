import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/core/startup/bootstrap.dart';
import 'package:avanzza/domain/entities/asset/asset_entity.dart';
import 'package:avanzza/domain/entities/geo/city_entity.dart';
import 'package:avanzza/domain/entities/geo/country_entity.dart';
import 'package:avanzza/domain/entities/maintenance/incidencia_entity.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  final init = await Bootstrap.init();
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

  final city = CityEntity(
    id: 'bogota',
    countryId: 'CO',
    regionId: 'cund',
    name: 'Bogotá',
    lat: 4.71,
    lng: -74.07,
    isActive: true,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
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
  final asset1 = AssetEntity(
    id: 'asset_demo_1',
    orgId: 'org_demo',
    assetType: 'vehiculo',
    countryId: 'CO',
    regionId: 'cund',
    cityId: 'bogota',
    ownerType: 'org',
    ownerId: 'org_demo',
    estado: 'activo',
    etiquetas: const ['demo'],
    fotosUrls: const [],
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
  await di.assetRepository.upsertAsset(asset1);

  final asset2 = asset1.copyWith(id: 'asset_demo_2', assetType: 'inmueble');
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
