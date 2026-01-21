import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/geo/city_entity.dart';
import '../../../location/controllers/location_controller.dart';
import '../../../widgets/wizard/bottom_sheet_selector.dart';

/// Widget para seleccionar una ciudad de forma interactiva.
///
/// Este widget depende de que existan un país y una región seleccionados previamente.
/// Si [countryId] o [regionId] son null, el campo aparecerá deshabilitado.
///
/// Usa internamente el [LocationController] para obtener las ciudades
/// filtradas por el país y región especificados.
///
/// Características:
/// - Deshabilitado automáticamente si no hay país o región
/// - Carga automática de ciudades cuando se proporcionan countryId y regionId
/// - Presenta un [BottomSheetSelector] con búsqueda
/// - Soporte para valor inicial
///
/// Ejemplo de uso:
/// ```dart
/// CitySelectorField(
///   countryId: 'col',
///   regionId: 'col-ant',
///   initialValue: 'col-ant-med',
///   onChanged: (city) {
///     print('Ciudad seleccionada: ${city.name}');
///   },
/// )
/// ```
class CitySelectorField extends StatefulWidget {
  /// ID del país del cual se cargarán las ciudades.
  /// Si es null, el campo se deshabilita.
  final String? countryId;

  /// ID de la región de la cual se cargarán las ciudades.
  /// Si es null, el campo se deshabilita.
  final String? regionId;

  /// ID de la ciudad inicialmente seleccionada
  final String? initialValue;

  /// Si false, el campo aparece deshabilitado y no responde a taps
  final bool enabled;

  /// Callback invocado cuando el usuario selecciona una ciudad
  final ValueChanged<CityEntity>? onChanged;

  /// Texto de la etiqueta del campo (por defecto: 'Ciudad')
  final String? labelText;

  /// Padding del ListTile contenedor
  final EdgeInsetsGeometry? contentPadding;

  const CitySelectorField({
    super.key,
    this.countryId,
    this.regionId,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.labelText = 'Ciudad',
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  State<CitySelectorField> createState() => _CitySelectorFieldState();
}

class _CitySelectorFieldState extends State<CitySelectorField> {
  late final LocationController _controller;
  String? _selectedLabel;
  String? _previousCountryId;
  String? _previousRegionId;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<LocationController>();

    // Cargar ciudades si hay país y región
    if (_hasRequiredIds) {
      _loadCitiesIfNeeded(widget.countryId!, widget.regionId!);
    }

    // Establecer label inicial si hay valor
    if (widget.initialValue != null) {
      _updateSelectedLabel(widget.initialValue!);
    }
  }

  @override
  void didUpdateWidget(CitySelectorField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si cambió el país o la región, recargar ciudades
    if (widget.countryId != oldWidget.countryId ||
        widget.regionId != oldWidget.regionId) {
      _selectedLabel = null;

      if (_hasRequiredIds) {
        _loadCitiesIfNeeded(widget.countryId!, widget.regionId!);
      } else {
        // Si no hay país o región, limpiar lista
        setState(() {});
      }
    }
  }

  bool get _hasRequiredIds =>
      widget.countryId != null &&
      widget.countryId!.isNotEmpty &&
      widget.regionId != null &&
      widget.regionId!.isNotEmpty;

  void _loadCitiesIfNeeded(String countryId, String regionId) {
    // Solo cargar si cambió el país/región o la lista está vacía
    if (_previousCountryId != countryId ||
        _previousRegionId != regionId ||
        _controller.cities.isEmpty) {
      _previousCountryId = countryId;
      _previousRegionId = regionId;
      _controller.loadCities(countryId, regionId);
    }
  }

  void _updateSelectedLabel(String cityId) {
    final city = _controller.cities
        .where((c) => c.id == cityId)
        .firstOrNull;
    if (city != null) {
      setState(() {
        _selectedLabel = city.name;
      });
    }
  }

  Future<void> _showSelector() async {
    if (!_isEnabled) return;

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => Obx(() {
          final cities = _controller.cities;
          final isLoading = _controller.isLoadingCities.value;

          if (isLoading) {
            return const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return BottomSheetSelector<String>(
            title: 'Elige tu ${widget.labelText?.toLowerCase() ?? 'ciudad'}',
            selectedValue: widget.initialValue,
            items: cities
                .map((c) => SelectorItem(value: c.id, label: c.name))
                .toList(),
            onSelect: (item) {
              final selectedCity = cities.firstWhere(
                (c) => c.id == item.value,
              );

              setState(() {
                _selectedLabel = item.label;
              });

              widget.onChanged?.call(selectedCity);
            },
          );
        }),
      );
    } catch (e) {
      debugPrint('[CitySelectorField] Error showing selector: $e');
    }
  }

  bool get _isEnabled =>
      widget.enabled &&
      widget.countryId != null &&
      widget.countryId!.isNotEmpty &&
      widget.regionId != null &&
      widget.regionId!.isNotEmpty;

  String get _subtitleText {
    if (widget.countryId == null || widget.countryId!.isEmpty) {
      return 'Primero selecciona un país';
    }
    if (widget.regionId == null || widget.regionId!.isEmpty) {
      return 'Primero selecciona una región';
    }
    return _selectedLabel ??
        'Selecciona una ${widget.labelText?.toLowerCase() ?? 'ciudad'}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError = _controller.errorMessage.value.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: widget.contentPadding,
            enabled: _isEnabled,
            title: Text(widget.labelText ?? 'Ciudad'),
            subtitle: Text(
              _subtitleText,
              style: TextStyle(
                color: _isEnabled
                    ? Theme.of(context).hintColor
                    : Theme.of(context).disabledColor,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _showSelector,
          ),
          if (hasError && _isEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _controller.errorMessage.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }
}
