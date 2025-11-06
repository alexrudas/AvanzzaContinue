import '../entities/insurance/insurance_policy_entity.dart';
import '../entities/insurance/insurance_purchase_entity.dart';

abstract class InsuranceRepository {
  // Policies
  Stream<List<InsurancePolicyEntity>> watchPoliciesByAsset(String assetId,
      {String? countryId, String? cityId});
  Future<List<InsurancePolicyEntity>> fetchPoliciesByAsset(String assetId,
      {String? countryId, String? cityId});
  Stream<InsurancePolicyEntity?> watchPolicy(String id);
  Future<InsurancePolicyEntity?> getPolicy(String id);
  Future<void> upsertPolicy(InsurancePolicyEntity policy);

  // Purchases
  Stream<List<InsurancePurchaseEntity>> watchPurchasesByOrg(String orgId);
  Future<List<InsurancePurchaseEntity>> fetchPurchasesByOrg(String orgId);
  Stream<InsurancePurchaseEntity?> watchPurchase(String id);
  Future<InsurancePurchaseEntity?> getPurchase(String id);
  Future<void> upsertPurchase(InsurancePurchaseEntity purchase);
}
