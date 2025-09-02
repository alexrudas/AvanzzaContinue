import '../entities/org/organization_entity.dart';

abstract class OrgRepository {
  // Orgs by user
  Stream<List<OrganizationEntity>> watchOrgsByUser(String uid, {String? countryId, String? cityId});
  Future<List<OrganizationEntity>> fetchOrgsByUser(String uid, {String? countryId, String? cityId});

  // Single org CRUD
  Stream<OrganizationEntity?> watchOrg(String orgId);
  Future<OrganizationEntity?> getOrg(String orgId);
  Future<void> upsertOrg(OrganizationEntity org);

  // Location update
  Future<void> updateOrgLocation(String orgId, {required String countryId, String? regionId, String? cityId});
}
