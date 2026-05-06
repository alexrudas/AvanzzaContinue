import 'package:isar_community/isar.dart';

import '../../models/geo/city_model.dart';
import '../../models/geo/country_model.dart';
import '../../models/geo/local_regulation_model.dart';
import '../../models/geo/region_model.dart';

class GeoLocalDataSource {
  final Isar isar;
  GeoLocalDataSource(this.isar);

  // Countries
  Future<List<CountryModel>> countries({bool? isActive}) async {
    final q = isar.countryModels
        .filter()
        .optional(isActive != null, (q) => q.isActiveEqualTo(isActive!));
    return q.findAll();
  }

  Future<void> upsertCountry(CountryModel m) async {
    await isar.writeTxn(() async {
      // CountryModel has replace:true on unique index, so just put it
      await isar.countryModels.put(m);
    });
  }

  // Regions
  Future<List<RegionModel>> regions(
      {required String countryId, bool? isActive}) async {
    final q = isar.regionModels
        .filter()
        .countryIdEqualTo(countryId)
        .optional(isActive != null, (q) => q.isActiveEqualTo(isActive!));
    return q.findAll();
  }

  Future<void> upsertRegion(RegionModel m) async {
    await isar.writeTxn(() async {
      // RegionModel has replace:true on unique index, so just put it
      await isar.regionModels.put(m);
    });
  }

  /// Inserción/upsert masivo de regiones en una sola writeTxn.
  /// Usado por el seeder de assets locales para evitar 32+ transacciones
  /// por país en cada arranque. Idempotente vía `replace:true` en el índice
  /// único de `id`.
  Future<void> upsertRegions(List<RegionModel> list) async {
    if (list.isEmpty) return;
    await isar.writeTxn(() async {
      await isar.regionModels.putAll(list);
    });
  }

  // Cities
  Future<List<CityModel>> cities(
      {required String countryId, String? regionId, bool? isActive}) async {
    final q = isar.cityModels
        .filter()
        .countryIdEqualTo(countryId)
        .optional(regionId != null, (q) => q.regionIdEqualTo(regionId!))
        .optional(isActive != null, (q) => q.isActiveEqualTo(isActive!));
    return q.findAll();
  }

  Future<void> upsertCity(CityModel m) async {
    await isar.writeTxn(() async {
      // CityModel has replace:true on unique index, so just put it
      await isar.cityModels.put(m);
    });
  }

  /// Inserción/upsert masivo de ciudades en una sola writeTxn.
  /// El catálogo de Colombia tiene ~1100 entradas: usar `upsertCity` por
  /// cada una abriría 1100 transacciones y bloqueaba el arranque varios
  /// segundos. `putAll` dentro de una sola writeTxn baja eso a ~ms.
  Future<void> upsertCities(List<CityModel> list) async {
    if (list.isEmpty) return;
    await isar.writeTxn(() async {
      await isar.cityModels.putAll(list);
    });
  }

  // Local Regulations
  Future<List<LocalRegulationModel>> localRegulations(
      {String? countryId, String? cityId}) async {
    final q = isar.localRegulationModels
        .filter()
        .optional(countryId != null, (q) => q.countryIdEqualTo(countryId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertLocalRegulation(LocalRegulationModel m) async {
    await isar.writeTxn(() async => isar.localRegulationModels.put(m));
  }
}
