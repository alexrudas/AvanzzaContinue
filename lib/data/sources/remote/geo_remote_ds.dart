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
    try {
      q = q.orderBy('name');
    } catch (_) {}
    final snap = await q.get();
    return snap.docs
        .map((d) =>
            CountryModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  // Extendido: opciones (no rompe firmas públicas)
  Future<List<CountryModel>> countriesWithOptions(
      {bool? isActive, int? limit, bool orderByName = true}) async {
    Query q = db.collection('countries');
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    if (orderByName) {
      try {
        q = q.orderBy('name');
      } catch (_) {}
    }
    if (limit != null && limit > 0) q = q.limit(limit);
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

  Future<CountryModel?> countryById(String id) => getCountry(id);

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
    try {
      q = q.orderBy('name');
    } catch (_) {}
    var snap = await q.get();
    var docs = snap.docs;
    if (docs.isEmpty) {
      // Fallback Ref→Id
      final cRef = db.collection('countries').doc(countryId);
      Query q2 = db.collection('regions').where('countryRef', isEqualTo: cRef);
      if (isActive != null) q2 = q2.where('isActive', isEqualTo: isActive);
      try {
        q2 = q2.orderBy('name');
      } catch (_) {}
      docs = (await q2.get()).docs;
    }
    return docs
        .map((d) => RegionModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<List<RegionModel>> regionsByCountry(
      {required String countryId,
      bool? isActive,
      int? limit,
      bool orderByName = true}) async {
    Query q = db.collection('regions').where('countryId', isEqualTo: countryId);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    if (orderByName) {
      try {
        q = q.orderBy('name');
      } catch (_) {}
    }
    if (limit != null && limit > 0) q = q.limit(limit);
    var docs = (await q.get()).docs;
    if (docs.isEmpty) {
      final cRef = db.collection('countries').doc(countryId);
      Query q2 = db.collection('regions').where('countryRef', isEqualTo: cRef);
      if (isActive != null) q2 = q2.where('isActive', isEqualTo: isActive);
      if (orderByName) {
        try {
          q2 = q2.orderBy('name');
        } catch (_) {}
      }
      if (limit != null && limit > 0) q2 = q2.limit(limit);
      docs = (await q2.get()).docs;
    }
    return docs
        .map((d) => RegionModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<RegionModel?> getRegion(String id) async {
    final d = await db.collection('regions').doc(id).get();
    if (!d.exists) return null;
    return RegionModel.fromFirestore(d.id, d.data()!, db: db);
  }

  Future<RegionModel?> regionById(String regionId) => getRegion(regionId);

  Future<void> upsertRegion(RegionModel model) async {
    await db
        .collection('regions')
        .doc(model.id)
        .set(model.toFirestoreJson(), SetOptions(merge: true));
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
    try {
      q = q.orderBy('name');
    } catch (_) {}
    var snap = await q.get();
    var docs = snap.docs;
    if (docs.isEmpty) {
      final cRef = db.collection('countries').doc(countryId);
      Query q2 = db.collection('cities').where('countryRef', isEqualTo: cRef);
      if (regionId != null) {
        final rRef = db.collection('regions').doc(regionId);
        q2 = q2.where('regionRef', isEqualTo: rRef);
      }
      if (isActive != null) q2 = q2.where('isActive', isEqualTo: isActive);
      try {
        q2 = q2.orderBy('name');
      } catch (_) {}
      docs = (await q2.get()).docs;
    }
    return docs
        .map((d) => CityModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<List<CityModel>> citiesByRegion(
      {required String regionId,
      bool? isActive,
      int? limit,
      bool orderByName = true}) async {
    Query q = db.collection('cities').where('regionId', isEqualTo: regionId);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    if (orderByName) {
      try {
        q = q.orderBy('name');
      } catch (_) {}
    }
    if (limit != null && limit > 0) q = q.limit(limit);
    var docs = (await q.get()).docs;
    if (docs.isEmpty) {
      final rRef = db.collection('regions').doc(regionId);
      Query q2 = db.collection('cities').where('regionRef', isEqualTo: rRef);
      if (isActive != null) q2 = q2.where('isActive', isEqualTo: isActive);
      if (orderByName) {
        try {
          q2 = q2.orderBy('name');
        } catch (_) {}
      }
      if (limit != null && limit > 0) q2 = q2.limit(limit);
      docs = (await q2.get()).docs;
    }
    return docs
        .map((d) => CityModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<List<CityModel>> citiesByCountry(
      {required String countryId,
      bool? isActive,
      int? limit,
      bool orderByName = true}) async {
    Query q = db.collection('cities').where('countryId', isEqualTo: countryId);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    if (orderByName) {
      try {
        q = q.orderBy('name');
      } catch (_) {}
    }
    if (limit != null && limit > 0) q = q.limit(limit);
    var docs = (await q.get()).docs;
    if (docs.isEmpty) {
      final cRef = db.collection('countries').doc(countryId);
      Query q2 = db.collection('cities').where('countryRef', isEqualTo: cRef);
      if (isActive != null) q2 = q2.where('isActive', isEqualTo: isActive);
      if (orderByName) {
        try {
          q2 = q2.orderBy('name');
        } catch (_) {}
      }
      if (limit != null && limit > 0) q2 = q2.limit(limit);
      docs = (await q2.get()).docs;
    }
    return docs
        .map((d) => CityModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<CityModel?> getCity(String id) async {
    final d = await db.collection('cities').doc(id).get();
    if (!d.exists) return null;
    return CityModel.fromFirestore(d.id, d.data()!, db: db);
  }

  Future<CityModel?> cityById(String cityId) => getCity(cityId);

  Future<void> upsertCity(CityModel model) async {
    await db
        .collection('cities')
        .doc(model.id)
        .set(model.toFirestoreJson(), SetOptions(merge: true));
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
