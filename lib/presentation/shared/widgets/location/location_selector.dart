import 'package:flutter/material.dart';

import '../../../../domain/entities/location/location_selection.dart';
import 'city_selector_field.dart';
import 'country_selector_field.dart';
import 'region_selector_field.dart';

/// Widget orquestador que compone los selectores de país, región y ciudad.
///
/// Este widget gestiona internamente la cascada de selección (cuando cambia
/// el país se resetean región y ciudad; cuando cambia la región se resetea ciudad).
///
/// Permite configurar qué niveles mostrar mediante [showCountry], [showRegion]
/// y [showCity], lo que permite casos de uso como:
/// - Solo país
/// - País + Región
/// - País + Región + Ciudad (completo)
///
/// Características:
/// - Gestión automática de cascada de resets
/// - Soporte para valores iniciales
/// - Notificación unificada de cambios vía [onChanged]
/// - Configuración flexible de niveles a mostrar
///
/// Ejemplo de uso:
/// ```dart
/// LocationSelector(
///   initialCountryId: 'col',
///   initialRegionId: 'col-ant',
///   initialCityId: 'col-ant-med',
///   onChanged: (selection) {
///     print('Selección actual: ${selection.countryId}, ${selection.regionId}, ${selection.cityId}');
///     if (selection.isComplete) {
///       // Procesar selección completa
///     }
///   },
/// )
/// ```
class LocationSelector extends StatefulWidget {
  /// Si true, muestra el selector de país (default: true)
  final bool showCountry;

  /// Si true, muestra el selector de región (default: true)
  final bool showRegion;

  /// Si true, muestra el selector de ciudad (default: true)
  final bool showCity;

  /// ID del país inicialmente seleccionado
  final String? initialCountryId;

  /// ID de la región inicialmente seleccionada
  final String? initialRegionId;

  /// ID de la ciudad inicialmente seleccionada
  final String? initialCityId;

  /// Callback invocado cuando cambia cualquier parte de la selección.
  /// Recibe un [LocationSelection] con el estado completo actual.
  final ValueChanged<LocationSelection> onChanged;

  /// Espacio entre los selectores (default: 8.0)
  final double spacing;

  /// Si false, todos los selectores aparecen deshabilitados
  final bool enabled;

  const LocationSelector({
    super.key,
    this.showCountry = true,
    this.showRegion = true,
    this.showCity = true,
    this.initialCountryId,
    this.initialRegionId,
    this.initialCityId,
    required this.onChanged,
    this.spacing = 8.0,
    this.enabled = true,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _currentCountryId;
  String? _currentRegionId;
  String? _currentCityId;

  @override
  void initState() {
    super.initState();
    _currentCountryId = widget.initialCountryId;
    _currentRegionId = widget.initialRegionId;
    _currentCityId = widget.initialCityId;
  }

  void _notifyChange() {
    widget.onChanged(LocationSelection(
      countryId: _currentCountryId,
      regionId: _currentRegionId,
      cityId: _currentCityId,
    ));
  }

  void _handleCountryChange(country) {
    setState(() {
      _currentCountryId = country.id;
      // Cascada: resetear región y ciudad
      _currentRegionId = null;
      _currentCityId = null;
    });
    _notifyChange();
  }

  void _handleRegionChange(region) {
    setState(() {
      _currentRegionId = region.id;
      // Cascada: resetear ciudad
      _currentCityId = null;
    });
    _notifyChange();
  }

  void _handleCityChange(city) {
    setState(() {
      _currentCityId = city.id;
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    // País
    if (widget.showCountry) {
      widgets.add(
        CountrySelectorField(
          initialValue: _currentCountryId,
          enabled: widget.enabled,
          onChanged: _handleCountryChange,
        ),
      );
    }

    // Divider después del país
    if (widget.showCountry && (widget.showRegion || widget.showCity)) {
      widgets.add(const Divider(height: 1));
      widgets.add(SizedBox(height: widget.spacing));
    }

    // Región
    if (widget.showRegion) {
      widgets.add(
        RegionSelectorField(
          countryId: _currentCountryId,
          initialValue: _currentRegionId,
          enabled: widget.enabled,
          onChanged: _handleRegionChange,
        ),
      );
    }

    // Divider después de la región
    if (widget.showRegion && widget.showCity) {
      widgets.add(const Divider(height: 1));
      widgets.add(SizedBox(height: widget.spacing));
    }

    // Ciudad
    if (widget.showCity) {
      widgets.add(
        CitySelectorField(
          countryId: _currentCountryId,
          regionId: _currentRegionId,
          initialValue: _currentCityId,
          enabled: widget.enabled,
          onChanged: _handleCityChange,
        ),
      );
    }

    // Divider final
    if (widgets.isNotEmpty) {
      widgets.add(const Divider(height: 1));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }
}
