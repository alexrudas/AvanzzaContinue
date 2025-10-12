import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class GeoSeeder {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  GeoSeeder();

  Future<void> seedRegionsAndCities({
    required String regionsAssetJson, // v1 (id/code) o v3 (regionCode)
    required String citiesAssetJson, // v3
  }) async {
    print("Init seedRegionsAndCities");
    final regions =
        jsonDecode(await rootBundle.loadString(regionsAssetJson)) as List;
    final cities =
        jsonDecode(await rootBundle.loadString(citiesAssetJson)) as List;

    await _seedRegions(regions);
    await _seedCities(cities);
    print("finished seedRegionsAndCities");
  }

  // ---------------- REGIONS ----------------
  Future<void> _seedRegions(List regions) async {
    final chunks = _chunk(regions, 450);
    for (final chunk in chunks) {
      final batch = db.batch();
      for (final raw in chunk) {
        final m = Map<String, dynamic>.from(raw as Map);

        // Acepta v1 (id/code) o v3 (regionCode)
        final docId = (m['regionCode'] ?? m['id'] ?? m['code'])?.toString();
        if (docId == null || docId.isEmpty) {
          throw StateError('Region sin regionCode/id/code en JSON.');
        }

        // countryRef path -> DocumentReference
        final String countryRefPath =
            (m['countryRef'] ?? '/countries/CO') as String;
        m['countryRef'] = db.doc(countryRefPath);

        // server timestamps
        m['createdAt'] = FieldValue.serverTimestamp();
        m['updatedAt'] = FieldValue.serverTimestamp();

        // limpieza
        m.remove('id');
        m.remove('regionCode'); // el ID queda en la clave del doc

        batch.set(
            db.collection('regions').doc(docId), m, SetOptions(merge: true));
      }
      await batch.commit();
    }
  }

  // ---------------- CITIES ----------------
  Future<void> _seedCities(List cities) async {
    final chunks = _chunk(cities, 450);
    for (final chunk in chunks) {
      final batch = db.batch();
      for (final raw in chunk) {
        final m = Map<String, dynamic>.from(raw as Map);

        // ID ciudad: usa 'id' o compón COUNTRY-REGIONCODE-CITYCODE
        String? docId = (m['id'] as String?);
        if (docId == null || docId.isEmpty) {
          final String country = (m['countryRef'] ?? '/countries/CO')
              .toString()
              .split('/')
              .last
              .toUpperCase();
          final String region =
              (m['regionCode'] ?? '').toString().toUpperCase();
          final String city = (m['cityCode'] ?? '').toString().toUpperCase();
          if (region.isEmpty || city.isEmpty) {
            throw StateError('City sin id y sin regionCode/cityCode.');
          }
          docId = '$region-$city';
        }

        // refs
        m['countryRef'] =
            db.doc((m['countryRef'] ?? '/countries/CO') as String);
        final String regionCode = (m['regionCode'] ?? '').toString();
        m['regionRef'] =
            db.doc((m['regionRef'] ?? '/regions/$regionCode') as String);

        // timestamps
        m['createdAt'] = FieldValue.serverTimestamp();
        m['updatedAt'] = FieldValue.serverTimestamp();

        // limpieza
        m.remove('id');

        batch.set(
            db.collection('cities').doc(docId), m, SetOptions(merge: true));
      }
      await batch.commit();
    }
  }

  // --------------- helper ---------------
  List<List<T>> _chunk<T>(List<T> list, int size) {
    final out = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      out.add(list.sublist(i, i + size > list.length ? list.length : i + size));
    }
    return out;
  }
}
