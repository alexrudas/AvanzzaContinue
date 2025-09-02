import '../entities/accounting/accounting_entry_entity.dart';
import '../entities/accounting/adjustment_entity.dart';

abstract class AccountingRepository {
  // Entries
  Stream<List<AccountingEntryEntity>> watchEntriesByOrg(String orgId, {String? countryId, String? cityId});
  Future<List<AccountingEntryEntity>> fetchEntriesByOrg(String orgId, {String? countryId, String? cityId});
  Stream<AccountingEntryEntity?> watchEntry(String id);
  Future<AccountingEntryEntity?> getEntry(String id);
  Future<void> upsertEntry(AccountingEntryEntity entry);

  // Adjustments
  Stream<List<AdjustmentEntity>> watchAdjustments(String entryId);
  Future<List<AdjustmentEntity>> fetchAdjustments(String entryId);
  Future<void> upsertAdjustment(AdjustmentEntity adjustment);
}
