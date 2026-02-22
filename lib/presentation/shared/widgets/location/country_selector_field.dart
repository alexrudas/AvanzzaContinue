//lib\presentation\shared\widgets\location\country_selector_field.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/geo/country_entity.dart';
import '../../../location/controllers/location_controller.dart';
import '../../../widgets/wizard/bottom_sheet_selector.dart';

/// Widget para seleccionar un país de forma interactiva.
///
/// Este widget usa internamente el [LocationController] para obtener
/// la lista de países disponibles y gestionar el estado de selección.
///
/// Características:
/// - Carga automática de países al inicializarse
/// - Presenta un [BottomSheetSelector] con búsqueda
/// - Soporte para valor inicial
/// - Estados de carga y error gestionados automáticamente
///
/// Ejemplo de uso:
/// ```dart
/// CountrySelectorField(
///   initialValue: 'col',
///   onChanged: (country) {
///     print('País seleccionado: ${country.name}');
///   },
/// )
/// ```
class CountrySelectorField extends StatefulWidget {
  /// ID del país inicialmente seleccionado
  final String? initialValue;

  /// Si false, el campo aparece deshabilitado y no responde a taps
  final bool enabled;

  /// Callback invocado cuando el usuario selecciona un país
  final ValueChanged<CountryEntity>? onChanged;

  /// Texto de la etiqueta del campo (por defecto: 'País')
  final String? labelText;

  /// Padding del ListTile contenedor
  final EdgeInsetsGeometry? contentPadding;

  const CountrySelectorField({
    super.key,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.labelText = 'País',
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  State<CountrySelectorField> createState() => _CountrySelectorFieldState();
}

class _CountrySelectorFieldState extends State<CountrySelectorField> {
  late final LocationController _controller;
  String? _selectedLabel;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<LocationController>();

    // Cargar países si la lista está vacía
    if (_controller.countries.isEmpty) {
      _controller.loadCountries();
    }

    // Establecer label inicial si hay valor
    if (widget.initialValue != null) {
      _updateSelectedLabel(widget.initialValue!);
    }
  }

  void _updateSelectedLabel(String countryId) {
    final country =
        _controller.countries.where((c) => c.id == countryId).firstOrNull;
    if (country != null) {
      setState(() {
        _selectedLabel = country.name;
      });
    }
  }

  Future<void> _showSelector() async {
    if (!widget.enabled) return;

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => Obx(() {
          final countries = _controller.countries;
          final isLoading = _controller.isLoadingCountries.value;

          if (isLoading) {
            return const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return BottomSheetSelector<String>(
            title: 'Elige tu ${widget.labelText?.toLowerCase() ?? 'país'}',
            selectedValue: widget.initialValue,
            items: countries
                .map((c) => SelectorItem(value: c.id, label: c.name))
                .toList(),
            onSelect: (item) {
              final selectedCountry = countries.firstWhere(
                (c) => c.id == item.value,
              );

              setState(() {
                _selectedLabel = item.label;
              });

              widget.onChanged?.call(selectedCountry);
            },
          );
        }),
      );
    } catch (e) {
      debugPrint('[CountrySelectorField] Error showing selector: $e');
    }
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
            enabled: widget.enabled,
            title: Text(widget.labelText ?? 'País'),
            subtitle: Text(
              _selectedLabel ??
                  'Selecciona un ${widget.labelText?.toLowerCase() ?? 'país'}',
              style: TextStyle(
                color: widget.enabled
                    ? Theme.of(context).hintColor
                    : Theme.of(context).disabledColor,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _showSelector,
          ),
          if (hasError)
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
