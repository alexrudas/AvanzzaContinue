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

  /// Retorna la póliza más reciente (mayor [InsurancePolicyEntity.fechaFin])
  /// del [assetId] con el [tipo] dado, o null si no existe ninguna.
  ///
  /// Usar para los tiles del grid de estado del vehículo, donde solo interesa
  /// la póliza activa/más reciente por tipo. Para historial completo, usar
  /// [fetchPoliciesByAsset] y filtrar client-side por [policyType].
  Future<InsurancePolicyEntity?> latestPolicyByTipo({
    required String assetId,
    required InsurancePolicyType tipo,
  });

  // Purchases
  Stream<List<InsurancePurchaseEntity>> watchPurchasesByOrg(String orgId);
  Future<List<InsurancePurchaseEntity>> fetchPurchasesByOrg(String orgId);
  Stream<InsurancePurchaseEntity?> watchPurchase(String id);
  Future<InsurancePurchaseEntity?> getPurchase(String id);
  Future<void> upsertPurchase(InsurancePurchaseEntity purchase);
}
