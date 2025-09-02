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
    await isar.writeTxn(() async => isar.countryModels.put(m));
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
    await isar.writeTxn(() async => isar.regionModels.put(m));
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
    await isar.writeTxn(() async => isar.cityModels.put(m));
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
