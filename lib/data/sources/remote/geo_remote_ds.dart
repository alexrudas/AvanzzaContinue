import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/geo/city_model.dart';
import '../../models/geo/country_model.dart';
import '../../models/geo/local_regulation_model.dart';
import '../../models/geo/region_model.dart';

class GeoRemoteDataSource {
  final FirebaseFirestore db;
  GeoRemoteDataSource(this.db);

  // Countries
  Future<List<CountryModel>> countries({bool? isActive}) async {
    Query q = db.collection('countries');
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    final snap = await q.get();
    return snap.docs
        .map((d) =>
            CountryModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<CountryModel?> getCountry(String id) async {
    final d = await db.collection('countries').doc(id).get();
    if (!d.exists) return null;
    return CountryModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertCountry(CountryModel model) async {
    await db
        .collection('countries')
        .doc(model.id)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteCountry(String id) async {
    await db.collection('countries').doc(id).delete();
  }

  // Regions
  Future<List<RegionModel>> regions(
      {required String countryId, bool? isActive}) async {
    Query q = db.collection('regions').where('countryId', isEqualTo: countryId);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    final snap = await q.get();
    return snap.docs
        .map((d) => RegionModel.fromFirestore(
              d.id,
              d.data() as Map<String, dynamic>,
              db: db,
            ))
        .toList();
  }

  Future<RegionModel?> getRegion(String id) async {
    final d = await db.collection('regions').doc(id).get();
    if (!d.exists) return null;
    return RegionModel.fromFirestore(d.id, d.data()!, db: db);
  }

  Future<void> upsertRegion(RegionModel model) async {
    await db
        .collection('regions')
        .doc(model.id)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteRegion(String id) async {
    await db.collection('regions').doc(id).delete();
  }

  // Cities
  Future<List<CityModel>> cities(
      {required String countryId, String? regionId, bool? isActive}) async {
    Query q = db.collection('cities').where('countryId', isEqualTo: countryId);
    if (regionId != null) q = q.where('regionId', isEqualTo: regionId);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    final snap = await q.get();
    return snap.docs
        .map((d) => CityModel.fromFirestore(
              d.id,
              d.data() as Map<String, dynamic>,
              db: db,
            ))
        .toList();
  }

  Future<CityModel?> getCity(String id) async {
    final d = await db.collection('cities').doc(id).get();
    if (!d.exists) return null;
    return CityModel.fromFirestore(d.id, d.data()!, db: db);
  }

  Future<void> upsertCity(CityModel model) async {
    await db
        .collection('cities')
        .doc(model.id)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteCity(String id) async {
    await db.collection('cities').doc(id).delete();
  }

  // Local regulations
  Future<List<LocalRegulationModel>> localRegulations(
      {String? countryId, String? cityId}) async {
    Query q = db.collection('local_regulations');
    if (countryId != null) q = q.where('countryId', isEqualTo: countryId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => LocalRegulationModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<LocalRegulationModel?> getLocalRegulation(String id) async {
    final d = await db.collection('local_regulations').doc(id).get();
    if (!d.exists) return null;
    return LocalRegulationModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertLocalRegulation(LocalRegulationModel model) async {
    await db
        .collection('local_regulations')
        .doc(model.id)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteLocalRegulation(String id) async {
    await db.collection('local_regulations').doc(id).delete();
  }
}
