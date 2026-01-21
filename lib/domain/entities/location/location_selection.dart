/// Modelo para encapsular la selección completa de localización.
///
/// Representa los IDs seleccionados de país, región y ciudad durante
/// el flujo de selección de ubicación geográfica.
///
/// Ejemplo de uso:
/// ```dart
/// final selection = LocationSelection(
///   countryId: 'col',
///   regionId: 'col-ant',
///   cityId: 'col-ant-med',
/// );
///
/// if (selection.isComplete) {
///   // Procesar selección completa
/// }
/// ```
class LocationSelection {
  /// ID del país seleccionado (puede ser null si no se ha seleccionado)
  final String? countryId;

  /// ID de la región seleccionada (puede ser null si no se ha seleccionado)
  final String? regionId;

  /// ID de la ciudad seleccionada (puede ser null si no se ha seleccionado)
  final String? cityId;

  const LocationSelection({
    this.countryId,
    this.regionId,
    this.cityId,
  });

  /// Retorna true si los tres niveles están seleccionados (país, región y ciudad)
  bool get isComplete =>
      countryId != null && regionId != null && cityId != null;

  /// Retorna true si ningún nivel está seleccionado
  bool get isEmpty => countryId == null && regionId == null && cityId == null;

  /// Retorna true si al menos el país está seleccionado
  bool get hasCountry => countryId != null;

  /// Retorna true si país y región están seleccionados
  bool get hasRegion => countryId != null && regionId != null;

  /// Crea una copia con valores opcionales actualizados
  LocationSelection copyWith({
    String? countryId,
    String? regionId,
    String? cityId,
  }) {
    return LocationSelection(
      countryId: countryId ?? this.countryId,
      regionId: regionId ?? this.regionId,
      cityId: cityId ?? this.cityId,
    );
  }

  /// Crea una selección vacía
  static const LocationSelection empty = LocationSelection();

  @override
  String toString() {
    return 'LocationSelection(countryId: $countryId, regionId: $regionId, cityId: $cityId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationSelection &&
        other.countryId == countryId &&
        other.regionId == regionId &&
        other.cityId == cityId;
  }

  @override
  int get hashCode =>
      countryId.hashCode ^ regionId.hashCode ^ cityId.hashCode;
}
