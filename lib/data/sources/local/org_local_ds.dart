import 'package:isar_community/isar.dart';

import '../../models/org/organization_model.dart';

class OrgLocalDataSource {
  final Isar isar;
  OrgLocalDataSource(this.isar);

  Future<List<OrganizationModel>> orgsByUser(String uid,
      {String? countryId, String? cityId}) async {
    final q = isar.organizationModels
        .filter()
        .ownerUidEqualTo(uid)
        .optional(countryId != null, (q) => q.countryIdEqualTo(countryId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<OrganizationModel?> getOrg(String id) async {
    return isar.organizationModels.filter().idEqualTo(id).findFirst();
  }

  Future<void> upsertOrg(OrganizationModel m) async {
    await isar.writeTxn(() async => isar.organizationModels.put(m));
  }
}
