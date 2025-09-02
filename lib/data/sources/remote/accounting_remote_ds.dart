import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/accounting/accounting_entry_model.dart';
import '../../models/accounting/adjustment_model.dart';

class AccountingRemoteDataSource {
  final FirebaseFirestore db;
  AccountingRemoteDataSource(this.db);

  Future<List<AccountingEntryModel>> entriesByOrg(String orgId,
      {String? countryId, String? cityId}) async {
    Query q =
        db.collection('accounting_entries').where('orgId', isEqualTo: orgId);
    if (countryId != null) q = q.where('countryId', isEqualTo: countryId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => AccountingEntryModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<AccountingEntryModel?> getEntry(String id) async {
    final d = await db.collection('accounting_entries').doc(id).get();
    if (!d.exists) return null;
    return AccountingEntryModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertEntry(AccountingEntryModel m) async {
    await db
        .collection('accounting_entries')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<List<AdjustmentModel>> adjustments(String entryId) async {
    final snap = await db
        .collection('adjustments')
        .where('entryId', isEqualTo: entryId)
        .get();
    return snap.docs
        .map((d) => AdjustmentModel.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<void> upsertAdjustment(AdjustmentModel m) async {
    await db
        .collection('adjustments')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }
}
