import 'package:isar_community/isar.dart';

import '../../models/accounting/accounting_entry_model.dart';
import '../../models/accounting/adjustment_model.dart';

class AccountingLocalDataSource {
  final Isar isar;
  AccountingLocalDataSource(this.isar);

  Future<List<AccountingEntryModel>> entriesByOrg(String orgId,
      {String? countryId, String? cityId}) async {
    final q = isar.accountingEntryModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(countryId != null, (q) => q.countryIdEqualTo(countryId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertEntry(AccountingEntryModel m) async =>
      isar.writeTxn(() async => isar.accountingEntryModels.put(m));

  Future<List<AdjustmentModel>> adjustments(String entryId) async =>
      isar.adjustmentModels.filter().entryIdEqualTo(entryId).findAll();

  Future<void> upsertAdjustment(AdjustmentModel m) async =>
      isar.writeTxn(() async => isar.adjustmentModels.put(m));
}
