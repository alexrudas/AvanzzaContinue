import 'package:isar_community/isar.dart';

import '../../models/insurance/insurance_policy_model.dart';
import '../../models/insurance/insurance_purchase_model.dart';

class InsuranceLocalDataSource {
  final Isar isar;
  InsuranceLocalDataSource(this.isar);

  Future<List<InsurancePolicyModel>> policiesByAsset(String assetId,
      {String? countryId, String? cityId}) async {
    final q = isar.insurancePolicyModels
        .filter()
        .assetIdEqualTo(assetId)
        .optional(countryId != null, (q) => q.countryIdEqualTo(countryId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertPolicy(InsurancePolicyModel m) async =>
      isar.writeTxn(() async => isar.insurancePolicyModels.put(m));

  Future<List<InsurancePurchaseModel>> purchasesByOrg(String orgId) async =>
      isar.insurancePurchaseModels.filter().orgIdEqualTo(orgId).findAll();

  Future<void> upsertPurchase(InsurancePurchaseModel m) async =>
      isar.writeTxn(() async => isar.insurancePurchaseModels.put(m));
}
