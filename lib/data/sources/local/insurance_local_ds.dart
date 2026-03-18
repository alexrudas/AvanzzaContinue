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

  /// Retorna la póliza más reciente (mayor fechaFin) para el [assetId] y
  /// [tipoWire] dados, o null si no existe ninguna.
  ///
  /// Usa el índice compuesto assetId + @Index(tipo) para la query eficiente;
  /// el sort por fechaFin descendente selecciona la más reciente.
  Future<InsurancePolicyModel?> latestPolicyByTipo(
      String assetId, String tipoWire) async {
    final results = await isar.insurancePolicyModels
        .filter()
        .assetIdEqualTo(assetId)
        .tipoEqualTo(tipoWire)
        .sortByFechaFinDesc()
        .limit(1)
        .findAll();
    return results.isEmpty ? null : results.first;
  }

  Future<void> upsertPolicy(InsurancePolicyModel m) async =>
      isar.writeTxn(() async => isar.insurancePolicyModels.put(m));

  Future<List<InsurancePurchaseModel>> purchasesByOrg(String orgId) async =>
      isar.insurancePurchaseModels.filter().orgIdEqualTo(orgId).findAll();

  Future<void> upsertPurchase(InsurancePurchaseModel m) async =>
      isar.writeTxn(() async => isar.insurancePurchaseModels.put(m));
}
