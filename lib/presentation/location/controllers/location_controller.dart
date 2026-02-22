// lib\presentation\location\controllers\location_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../domain/entities/geo/city_entity.dart';
import '../../../domain/entities/geo/country_entity.dart';
import '../../../domain/entities/geo/region_entity.dart';
import '../../../domain/entities/location/location_selection.dart';
import '../../../domain/repositories/geo_repository.dart';

class LocationController extends GetxController {
  final GeoRepository _geoRepository;

  LocationController(this._geoRepository);

  // ==================== Observables ====================

  final RxList<CountryEntity> countries = <CountryEntity>[].obs;
  final RxList<RegionEntity> regions = <RegionEntity>[].obs;
  final RxList<CityEntity> cities = <CityEntity>[].obs;

  final Rxn<String> selectedCountryId = Rxn<String>();
  final Rxn<String> selectedRegionId = Rxn<String>();
  final Rxn<String> selectedCityId = Rxn<String>();

  final RxBool isLoadingCountries = false.obs;
  final RxBool isLoadingRegions = false.obs;
  final RxBool isLoadingCities = false.obs;

  final RxString errorMessage = ''.obs;

  // StreamSubscriptions para cleanup en onClose
  StreamSubscription<List<CountryEntity>>? _countriesSub;
  StreamSubscription<List<RegionEntity>>? _regionsSub;
  StreamSubscription<List<CityEntity>>? _citiesSub;

  // ==================== Getters Computed ====================

  CountryEntity? get selectedCountry {
    final id = selectedCountryId.value;
    if (id == null) return null;
    return countries.firstWhereOrNull((c) => c.id == id);
  }

  RegionEntity? get selectedRegion {
    final id = selectedRegionId.value;
    if (id == null) return null;
    return regions.firstWhereOrNull((r) => r.id == id);
  }

  CityEntity? get selectedCity {
    final id = selectedCityId.value;
    if (id == null) return null;
    return cities.firstWhereOrNull((c) => c.id == id);
  }

  // ==================== Lifecycle ====================

  @override
  void onClose() {
    _countriesSub?.cancel();
    _regionsSub?.cancel();
    _citiesSub?.cancel();
    super.onClose();
  }

  // ==================== Métodos Públicos ====================

  /// Carga países usando watchCountries (local-first + sync remoto).
  ///
  /// Usa StreamSubscription + Completer en vez de await for para:
  /// - Evitar bloqueo indefinido si el stream nunca cierra (error remoto).
  /// - Garantizar que isLoadingCountries se apague siempre.
  /// - Timeout de 10s para proteger contra cuelgues de red.
  /// - Cancelación limpia en onClose().
  Future<void> loadCountries() async {
    await _countriesSub?.cancel();

    errorMessage.value = '';
    isLoadingCountries.value = true;

    final completer = Completer<void>();

    _countriesSub = _geoRepository
        .watchCountries(isActive: true)
        .timeout(const Duration(seconds: 10))
        .listen(
      (list) {
        debugPrint(
            '[LocationCtrl] watchCountries emitió: ${list.length} países');
        countries.assignAll(list);
      },
      onError: (Object e) {
        debugPrint('[LocationCtrl] watchCountries ERROR: $e');
        if (countries.isEmpty) {
          errorMessage.value =
              'Error al cargar países. Verifica tu conexión e intenta de nuevo.';
        }
        isLoadingCountries.value = false;
        if (!completer.isCompleted) completer.complete();
      },
      onDone: () {
        debugPrint(
            '[LocationCtrl] watchCountries DONE. countries: ${countries.length}');
        if (countries.isEmpty) {
          errorMessage.value =
              'No se encontraron países. Verifica tu conexión e intenta de nuevo.';
        }
        isLoadingCountries.value = false;
        if (!completer.isCompleted) completer.complete();
      },
    );

    return completer.future;
  }

  /// Carga regiones para un país. Local-first + sync remoto.
  Future<void> loadRegions(String countryId) async {
    await _regionsSub?.cancel();

    errorMessage.value = '';
    isLoadingRegions.value = true;
    regions.clear();
    cities.clear();

    final completer = Completer<void>();

    _regionsSub = _geoRepository
        .watchRegions(countryId: countryId, isActive: true)
        .timeout(const Duration(seconds: 10))
        .listen(
      (list) {
        debugPrint(
            '[LocationCtrl] watchRegions emitió: ${list.length} regiones');
        regions.assignAll(list);
      },
      onError: (Object e) {
        debugPrint('[LocationCtrl] watchRegions ERROR: $e');
        isLoadingRegions.value = false;
        if (!completer.isCompleted) completer.complete();
      },
      onDone: () {
        isLoadingRegions.value = false;
        if (!completer.isCompleted) completer.complete();
      },
    );

    return completer.future;
  }

  /// Carga ciudades para un país y región. Local-first + sync remoto.
  Future<void> loadCities(String countryId, String regionId) async {
    await _citiesSub?.cancel();

    errorMessage.value = '';
    isLoadingCities.value = true;
    cities.clear();

    final completer = Completer<void>();

    _citiesSub = _geoRepository
        .watchCities(
            countryId: countryId, regionId: regionId, isActive: true)
        .timeout(const Duration(seconds: 10))
        .listen(
      (list) {
        debugPrint(
            '[LocationCtrl] watchCities emitió: ${list.length} ciudades');
        cities.assignAll(list);
      },
      onError: (Object e) {
        debugPrint('[LocationCtrl] watchCities ERROR: $e');
        isLoadingCities.value = false;
        if (!completer.isCompleted) completer.complete();
      },
      onDone: () {
        isLoadingCities.value = false;
        if (!completer.isCompleted) completer.complete();
      },
    );

    return completer.future;
  }

  /// Selecciona un país y resetea región y ciudad (cascada).
  void selectCountry(String? countryId) {
    selectedCountryId.value = countryId;
    selectedRegionId.value = null;
    selectedCityId.value = null;
    regions.clear();
    cities.clear();

    if (countryId != null && countryId.isNotEmpty) {
      loadRegions(countryId);
    }
  }

  /// Selecciona una región y resetea ciudad (cascada).
  void selectRegion(String? regionId) {
    selectedRegionId.value = regionId;
    selectedCityId.value = null;
    cities.clear();

    final countryId = selectedCountryId.value;
    if (countryId != null &&
        regionId != null &&
        countryId.isNotEmpty &&
        regionId.isNotEmpty) {
      loadCities(countryId, regionId);
    }
  }

  /// Selecciona una ciudad.
  void selectCity(String? cityId) {
    selectedCityId.value = cityId;
  }

  /// Retorna la selección actual como LocationSelection.
  LocationSelection getSelection() {
    return LocationSelection(
      countryId: selectedCountryId.value,
      regionId: selectedRegionId.value,
      cityId: selectedCityId.value,
    );
  }

  /// Establece la selección inicial desde valores externos.
  Future<void> setInitialSelection({
    String? countryId,
    String? regionId,
    String? cityId,
  }) async {
    if (countries.isEmpty) {
      await loadCountries();
    }

    if (countryId != null && countryId.isNotEmpty) {
      selectedCountryId.value = countryId;
      await loadRegions(countryId);

      if (regionId != null && regionId.isNotEmpty) {
        selectedRegionId.value = regionId;
        await loadCities(countryId, regionId);

        if (cityId != null && cityId.isNotEmpty) {
          selectedCityId.value = cityId;
        }
      }
    }
  }

  /// Limpia toda la selección y resetea las listas.
  void clearSelection() {
    selectedCountryId.value = null;
    selectedRegionId.value = null;
    selectedCityId.value = null;
    regions.clear();
    cities.clear();
    errorMessage.value = '';
  }

  /// Limpia el mensaje de error actual.
  void clearError() {
    errorMessage.value = '';
  }
}
