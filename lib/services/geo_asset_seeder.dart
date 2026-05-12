// ============================================================================
// lib/services/geo_asset_seeder.dart
// GEO ASSET SEEDER — Hidratación offline-first del catálogo geo (CO) en Isar
// ============================================================================
// QUÉ HACE:
//   - Lee los assets locales `assets/regions_entities_co.v3.json` y
//     `assets/cities_entities_co.v3.json` y siembra Isar con el catálogo
//     completo de regiones y ciudades de Colombia (más el país CO).
//   - Idempotente: persiste la versión del asset cargada en
//     SharedPreferences (`geo_assets_co_version`) y solo re-procesa cuando:
//        · La versión cambia (subida del bundle), o
//        · Isar está vacío para esa partición (clean install, wipe parcial,
//          colección Firebase eliminada y caché local borrado).
//   - Usa `upsertRegions` / `upsertCities` en batch (1 writeTxn por colección)
//     para que el arranque no se bloquee con ~1100 transacciones individuales.
//
// QUÉ NO HACE:
//   - NO escribe a Firestore. La sincronización remota sigue ocurriendo en
//     `GeoRepositoryImpl.watchRegions/watchCities` con LWW por `updatedAt`.
//     Si Firebase tiene datos más nuevos, ganan. Si está vacío, el catálogo
//     local sigue intacto (ese es justamente el bug que esto resuelve).
//   - NO toca colecciones que no estén en el alcance del fix (sólo CO).
//   - NO depende de Firebase ni de conectividad: corre 100% local en el
//     bootstrap antes de levantar observers.
//
// PRINCIPIOS:
//   - Offline-first real: la fuente de verdad para el SELECTOR es el asset
//     local. Firebase sólo añade/actualiza, nunca puede "vaciar" el catálogo.
//   - Sin re-trabajo en arranque normal: la versión cacheada evita reprocesar
//     1100+ ciudades en cada cold start.
//   - Sin acoplamiento a UI ni a GetX: recibe el `GeoLocalDataSource` por
//     constructor y se invoca desde `Bootstrap._doInit()`.
//
// ENTERPRISE NOTES:
//   - Para forzar re-hidratación tras subir un bundle nuevo (ej. v4), incrementa
//     `_coAssetVersion`. Los clientes existentes detectarán el cambio en el
//     siguiente cold start y reprocesarán.
//   - El `regionId` canónico de una ciudad es el `regionCode` del asset
//     (ej. `CO-ATL`). El `cityId` canónico es `<regionCode>-<cityCode>`
//     (ej. `CO-ATL-BARRANQUILLA`). Mismo formato que produce `GeoSeeder`
//     al subir a Firestore — los IDs locales y remotos coinciden.
// ============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/geo/city_model.dart';
import '../data/models/geo/country_model.dart';
import '../data/models/geo/region_model.dart';
import '../data/sources/local/geo_local_ds.dart';

class GeoAssetSeeder {
  // Versión del bundle de assets. Subir esta constante invalida el cache
  // local en clientes ya instalados y fuerza reprocesar los JSON.
  static const String _coAssetVersion = 'co.v3.r1';
  static const String _prefKey = 'geo_assets_co_version';

  static const String _regionsAsset = 'assets/regions_entities_co.v3.json';
  static const String _citiesAsset = 'assets/cities_entities_co.v3.json';
  static const String _countryId = 'CO';

  final GeoLocalDataSource _local;

  GeoAssetSeeder(this._local);

  /// Punto de entrada. Idempotente y silencioso: si ya está cargado y al día,
  /// retorna en milisegundos. Si necesita sembrar, lo hace en batch.
  Future<void> seedColombiaIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedVersion = prefs.getString(_prefKey);

      // Defensa contra wipe parcial de Isar: incluso si la versión está
      // marcada, si la tabla quedó vacía, re-sembramos.
      final regionsCount =
          (await _local.regions(countryId: _countryId)).length;
      final citiesCount =
          (await _local.cities(countryId: _countryId)).length;

      final upToDate = cachedVersion == _coAssetVersion &&
          regionsCount > 0 &&
          citiesCount > 0;

      if (upToDate) return;

      await _seedCountry();
      final regions = await _seedRegions();
      final cities = await _seedCities();

      await prefs.setString(_prefKey, _coAssetVersion);

      debugPrint(
        '[GeoAssetSeeder] CO seeded: country=1, regions=$regions, cities=$cities '
        '(version=$_coAssetVersion)',
      );
    } catch (e, st) {
      // No bloqueamos el arranque por un fallo de seed: la app puede seguir
      // funcionando con catálogo parcial; el remote sync intentará llenar.
      debugPrint('[GeoAssetSeeder] seed failed: $e\n$st');
    }
  }

  Future<void> _seedCountry() async {
    final now = DateTime.now().toUtc();
    await _local.upsertCountry(CountryModel(
      id: _countryId,
      name: 'Colombia',
      iso3: 'COL',
      phoneCode: '+57',
      currencyCode: 'COP',
      currencySymbol: '\$',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ));
  }

  Future<int> _seedRegions() async {
    final raw = await rootBundle.loadString(_regionsAsset);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final now = DateTime.now().toUtc();
    final models = <RegionModel>[];
    for (final m in list) {
      final regionCode = (m['regionCode'] ?? '').toString();
      if (regionCode.isEmpty) continue;
      final countryRefPath =
          (m['countryRef'] ?? '/countries/$_countryId').toString();
      final countryId = _idFromRefPath(countryRefPath, fallback: _countryId);
      models.add(RegionModel(
        id: regionCode,
        countryRefPath: countryRefPath,
        countryId: countryId,
        name: (m['name'] as String?) ?? '',
        code: regionCode,
        isActive: (m['isActive'] as bool?) ?? true,
        createdAt: now,
        updatedAt: now,
      ));
    }
    await _local.upsertRegions(models);
    return models.length;
  }

  Future<int> _seedCities() async {
    final raw = await rootBundle.loadString(_citiesAsset);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final now = DateTime.now().toUtc();
    final models = <CityModel>[];
    for (final m in list) {
      final cityCode = (m['cityCode'] ?? '').toString();
      final regionCode = (m['regionCode'] ?? '').toString();
      if (cityCode.isEmpty || regionCode.isEmpty) continue;

      // Mismo esquema de ID que `GeoSeeder` para Firestore: alinea local↔remoto.
      final id = '$regionCode-$cityCode';

      final countryRefPath =
          (m['countryRef'] ?? '/countries/$_countryId').toString();
      final regionRefPath =
          (m['regionRef'] ?? '/regions/$regionCode').toString();
      final countryId = _idFromRefPath(countryRefPath, fallback: _countryId);

      models.add(CityModel(
        id: id,
        countryRefPath: countryRefPath,
        countryId: countryId,
        regionRefPath: regionRefPath,
        regionId: regionCode,
        regionCode: regionCode,
        cityCode: cityCode,
        name: (m['name'] as String?) ?? '',
        lat: _toDouble(m['lat']),
        lng: _toDouble(m['lng']),
        isActive: (m['isActive'] as bool?) ?? true,
        createdAt: now,
        updatedAt: now,
      ));
    }
    await _local.upsertCities(models);
    return models.length;
  }

  static String _idFromRefPath(String path, {required String fallback}) {
    final segs = path.split('/').where((s) => s.isNotEmpty).toList();
    return segs.isEmpty ? fallback : segs.last;
  }

  static double? _toDouble(Object? v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
