import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/accounting/accounting_entry_model.dart';
import '../../models/accounting/adjustment_model.dart';

class AccountingRemoteDataSource {
  final FirebaseFirestore db;
  AccountingRemoteDataSource(this.db);

  Future<PaginatedResult<AccountingEntryModel>> entriesByOrg(
    String orgId, {
    String? countryId,
    String? cityId,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 200) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 200. Use pagination with startAfter instead.',
      );
    }

    Query q = db
        .collection('accounting_entries')
        .where('orgId', isEqualTo: orgId);

    if (countryId != null) q = q.where('countryId', isEqualTo: countryId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    return PaginatedResult(
      items: snap.docs
          .map((d) => AccountingEntryModel.fromFirestore(
              d.id, d.data() as Map<String, dynamic>))
          .toList(),
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  @Deprecated('Use entriesByOrg() with pagination instead')
  Future<List<AccountingEntryModel>> entriesByOrgLegacy(
    String orgId, {
    String? countryId,
    String? cityId,
  }) async {
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

  Future<PaginatedResult<AdjustmentModel>> adjustments(
    String entryId, {
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 100) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 100 for adjustments.',
      );
    }

    Query q = db
        .collection('adjustments')
        .where('entryId', isEqualTo: entryId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    return PaginatedResult(
      items: snap.docs
          .map((d) => AdjustmentModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList(),
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  @Deprecated('Use adjustments() with pagination instead')
  Future<List<AdjustmentModel>> adjustmentsLegacy(String entryId) async {
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
