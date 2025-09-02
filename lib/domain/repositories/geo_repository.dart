import '../entities/geo/country_entity.dart';
import '../entities/geo/region_entity.dart';
import '../entities/geo/city_entity.dart';
import '../entities/geo/local_regulation_entity.dart';

abstract class GeoRepository {
  // Countries
  Stream<List<CountryEntity>> watchCountries({bool? isActive});
  Future<List<CountryEntity>> fetchCountries({bool? isActive});
  Stream<CountryEntity?> watchCountry(String id);
  Future<CountryEntity?> getCountry(String id);
  Future<void> upsertCountry(CountryEntity country);

  // Regions
  Stream<List<RegionEntity>> watchRegions({required String countryId, bool? isActive});
  Future<List<RegionEntity>> fetchRegions({required String countryId, bool? isActive});
  Stream<RegionEntity?> watchRegion(String id);
  Future<RegionEntity?> getRegion(String id);
  Future<void> upsertRegion(RegionEntity region);

  // Cities
  Stream<List<CityEntity>> watchCities({required String countryId, String? regionId, bool? isActive});
  Future<List<CityEntity>> fetchCities({required String countryId, String? regionId, bool? isActive});
  Stream<CityEntity?> watchCity(String id);
  Future<CityEntity?> getCity(String id);
  Future<void> upsertCity(CityEntity city);

  // Local Regulations
  Stream<List<LocalRegulationEntity>> watchLocalRegulations({String? countryId, String? cityId});
  Future<List<LocalRegulationEntity>> fetchLocalRegulations({String? countryId, String? cityId});
  Stream<LocalRegulationEntity?> watchLocalRegulation(String id);
  Future<LocalRegulationEntity?> getLocalRegulation(String id);
  Future<void> upsertLocalRegulation(LocalRegulationEntity regulation);
}
