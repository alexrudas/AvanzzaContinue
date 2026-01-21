import 'package:get/get.dart';

import '../../../domain/entities/geo/city_entity.dart';
import '../../../domain/entities/geo/country_entity.dart';
import '../../../domain/entities/geo/region_entity.dart';
import '../../../domain/entities/location/location_selection.dart';
import '../../../domain/repositories/geo_repository.dart';

/// Controlador GetX especializado para gestionar la selección de localización geográfica.
///
/// Este controlador centraliza toda la lógica relacionada con:
/// - Carga de países, regiones y ciudades desde el repositorio
/// - Manejo de estados de selección y carga
/// - Gestión de cascada (cambio de país resetea región y ciudad)
/// - Interacción con GeoRepository sin acoplamiento directo en las vistas
///
/// Uso:
/// ```dart
/// final controller = Get.find<LocationController>();
/// await controller.loadCountries();
/// controller.selectCountry('col');
/// ```
class LocationController extends GetxController {
  final GeoRepository _geoRepository;

  LocationController(this._geoRepository);

  // ==================== Observables ====================

  /// Lista de países disponibles
  final RxList<CountryEntity> countries = <CountryEntity>[].obs;

  /// Lista de regiones filtradas por país seleccionado
  final RxList<RegionEntity> regions = <RegionEntity>[].obs;

  /// Lista de ciudades filtradas por país y región seleccionados
  final RxList<CityEntity> cities = <CityEntity>[].obs;

  /// ID del país actualmente seleccionado
  final Rxn<String> selectedCountryId = Rxn<String>();

  /// ID de la región actualmente seleccionada
  final Rxn<String> selectedRegionId = Rxn<String>();

  /// ID de la ciudad actualmente seleccionada
  final Rxn<String> selectedCityId = Rxn<String>();

  /// Indica si se está cargando la lista de países
  final RxBool isLoadingCountries = false.obs;

  /// Indica si se está cargando la lista de regiones
  final RxBool isLoadingRegions = false.obs;

  /// Indica si se está cargando la lista de ciudades
  final RxBool isLoadingCities = false.obs;

  /// Mensaje de error si alguna operación falla
  final RxString errorMessage = ''.obs;

  // ==================== Getters Computed ====================

  /// País seleccionado actualmente (entidad completa)
  CountryEntity? get selectedCountry {
    final id = selectedCountryId.value;
    if (id == null) return null;
    try {
      return countries.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Región seleccionada actualmente (entidad completa)
  RegionEntity? get selectedRegion {
    final id = selectedRegionId.value;
    if (id == null) return null;
    try {
      return regions.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Ciudad seleccionada actualmente (entidad completa)
  CityEntity? get selectedCity {
    final id = selectedCityId.value;
    if (id == null) return null;
    try {
      return cities.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==================== Métodos Públicos ====================

  /// Carga la lista de países activos desde el repositorio.
  ///
  /// Esta operación se ejecuta en background y actualiza el estado
  /// de carga automáticamente.
  Future<void> loadCountries() async {
    try {
      errorMessage.value = '';
      isLoadingCountries.value = true;

      final result = await _geoRepository.fetchCountries(isActive: true);
      countries.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Error al cargar países: ${e.toString()}';
    } finally {
      isLoadingCountries.value = false;
    }
  }

  /// Carga la lista de regiones para un país específico.
  ///
  /// [countryId] ID del país del cual se cargarán las regiones.
  ///
  /// Esta operación resetea la lista de regiones y ciudades antes de cargar.
  Future<void> loadRegions(String countryId) async {
    try {
      errorMessage.value = '';
      isLoadingRegions.value = true;

      // Resetear listas dependientes
      regions.clear();
      cities.clear();

      final result = await _geoRepository.fetchRegions(
        countryId: countryId,
        isActive: true,
      );
      regions.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Error al cargar regiones: ${e.toString()}';
    } finally {
      isLoadingRegions.value = false;
    }
  }

  /// Carga la lista de ciudades para un país y región específicos.
  ///
  /// [countryId] ID del país.
  /// [regionId] ID de la región.
  ///
  /// Esta operación resetea la lista de ciudades antes de cargar.
  Future<void> loadCities(String countryId, String regionId) async {
    try {
      errorMessage.value = '';
      isLoadingCities.value = true;

      // Resetear lista de ciudades
      cities.clear();

      final result = await _geoRepository.fetchCities(
        countryId: countryId,
        regionId: regionId,
        isActive: true,
      );
      cities.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Error al cargar ciudades: ${e.toString()}';
    } finally {
      isLoadingCities.value = false;
    }
  }

  /// Selecciona un país y resetea región y ciudad.
  ///
  /// [countryId] ID del país a seleccionar (null para deseleccionar).
  ///
  /// IMPORTANTE: Al cambiar de país, las selecciones de región y ciudad
  /// se resetean automáticamente (comportamiento cascada).
  void selectCountry(String? countryId) {
    selectedCountryId.value = countryId;

    // Cascada: resetear región y ciudad
    selectedRegionId.value = null;
    selectedCityId.value = null;

    // Limpiar listas dependientes
    regions.clear();
    cities.clear();

    // Cargar regiones automáticamente si hay país seleccionado
    if (countryId != null && countryId.isNotEmpty) {
      loadRegions(countryId);
    }
  }

  /// Selecciona una región y resetea ciudad.
  ///
  /// [regionId] ID de la región a seleccionar (null para deseleccionar).
  ///
  /// IMPORTANTE: Al cambiar de región, la selección de ciudad
  /// se resetea automáticamente (comportamiento cascada).
  void selectRegion(String? regionId) {
    selectedRegionId.value = regionId;

    // Cascada: resetear ciudad
    selectedCityId.value = null;

    // Limpiar lista de ciudades
    cities.clear();

    // Cargar ciudades automáticamente si hay región seleccionada
    final countryId = selectedCountryId.value;
    if (countryId != null &&
        regionId != null &&
        countryId.isNotEmpty &&
        regionId.isNotEmpty) {
      loadCities(countryId, regionId);
    }
  }

  /// Selecciona una ciudad.
  ///
  /// [cityId] ID de la ciudad a seleccionar (null para deseleccionar).
  void selectCity(String? cityId) {
    selectedCityId.value = cityId;
  }

  /// Retorna la selección actual como objeto LocationSelection.
  ///
  /// Útil para notificar cambios a callbacks o persistir el estado.
  LocationSelection getSelection() {
    return LocationSelection(
      countryId: selectedCountryId.value,
      regionId: selectedRegionId.value,
      cityId: selectedCityId.value,
    );
  }

  /// Establece la selección inicial desde valores externos.
  ///
  /// [countryId] ID del país inicial.
  /// [regionId] ID de la región inicial (opcional).
  /// [cityId] ID de la ciudad inicial (opcional).
  ///
  /// Este método carga automáticamente las listas necesarias
  /// para reflejar correctamente el estado inicial.
  Future<void> setInitialSelection({
    String? countryId,
    String? regionId,
    String? cityId,
  }) async {
    // Cargar países si la lista está vacía
    if (countries.isEmpty) {
      await loadCountries();
    }

    // Establecer país
    if (countryId != null && countryId.isNotEmpty) {
      selectedCountryId.value = countryId;
      await loadRegions(countryId);

      // Establecer región si existe
      if (regionId != null && regionId.isNotEmpty) {
        selectedRegionId.value = regionId;
        await loadCities(countryId, regionId);

        // Establecer ciudad si existe
        if (cityId != null && cityId.isNotEmpty) {
          selectedCityId.value = cityId;
        }
      }
    }
  }

  /// Limpia toda la selección y resetea las listas.
  ///
  /// Útil para reiniciar el flujo de selección.
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
