import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/geo/region_entity.dart';
import '../../../location/controllers/location_controller.dart';
import '../../../widgets/wizard/bottom_sheet_selector.dart';

/// Widget para seleccionar una región/estado de forma interactiva.
///
/// Este widget depende de que exista un país seleccionado previamente.
/// Si [countryId] es null, el campo aparecerá deshabilitado.
///
/// Usa internamente el [LocationController] para obtener las regiones
/// filtradas por el país especificado.
///
/// Características:
/// - Deshabilitado automáticamente si no hay país
/// - Carga automática de regiones cuando se proporciona countryId
/// - Presenta un [BottomSheetSelector] con búsqueda
/// - Soporte para valor inicial
///
/// Ejemplo de uso:
/// ```dart
/// RegionSelectorField(
///   countryId: 'col',
///   initialValue: 'col-ant',
///   onChanged: (region) {
///     print('Región seleccionada: ${region.name}');
///   },
/// )
/// ```
class RegionSelectorField extends StatefulWidget {
  /// ID del país del cual se cargarán las regiones.
  /// Si es null, el campo se deshabilita.
  final String? countryId;

  /// ID de la región inicialmente seleccionada
  final String? initialValue;

  /// Si false, el campo aparece deshabilitado y no responde a taps
  final bool enabled;

  /// Callback invocado cuando el usuario selecciona una región
  final ValueChanged<RegionEntity>? onChanged;

  /// Texto de la etiqueta del campo (por defecto: 'Región/Estado')
  final String? labelText;

  /// Padding del ListTile contenedor
  final EdgeInsetsGeometry? contentPadding;

  const RegionSelectorField({
    super.key,
    this.countryId,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.labelText = 'Región/Estado',
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  State<RegionSelectorField> createState() => _RegionSelectorFieldState();
}

class _RegionSelectorFieldState extends State<RegionSelectorField> {
  late final LocationController _controller;
  String? _selectedLabel;
  String? _previousCountryId;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<LocationController>();

    // Cargar regiones si hay país
    if (widget.countryId != null && widget.countryId!.isNotEmpty) {
      _loadRegionsIfNeeded(widget.countryId!);
    }

    // Establecer label inicial si hay valor
    if (widget.initialValue != null) {
      _updateSelectedLabel(widget.initialValue!);
    }
  }

  @override
  void didUpdateWidget(RegionSelectorField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si cambió el país, recargar regiones
    if (widget.countryId != oldWidget.countryId) {
      _selectedLabel = null;

      if (widget.countryId != null && widget.countryId!.isNotEmpty) {
        _loadRegionsIfNeeded(widget.countryId!);
      } else {
        // Si no hay país, limpiar lista
        setState(() {});
      }
    }
  }

  void _loadRegionsIfNeeded(String countryId) {
    // Solo cargar si cambió el país o la lista está vacía
    if (_previousCountryId != countryId || _controller.regions.isEmpty) {
      _previousCountryId = countryId;
      _controller.loadRegions(countryId);
    }
  }

  void _updateSelectedLabel(String regionId) {
    final region = _controller.regions
        .where((r) => r.id == regionId)
        .firstOrNull;
    if (region != null) {
      setState(() {
        _selectedLabel = region.name;
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
          final regions = _controller.regions;
          final isLoading = _controller.isLoadingRegions.value;

          if (isLoading) {
            return const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return BottomSheetSelector<String>(
            title: 'Elige tu ${widget.labelText?.toLowerCase() ?? 'región'}',
            selectedValue: widget.initialValue,
            items: regions
                .map((r) => SelectorItem(value: r.id, label: r.name))
                .toList(),
            onSelect: (item) {
              final selectedRegion = regions.firstWhere(
                (r) => r.id == item.value,
              );

              setState(() {
                _selectedLabel = item.label;
              });

              widget.onChanged?.call(selectedRegion);
            },
          );
        }),
      );
    } catch (e) {
      debugPrint('[RegionSelectorField] Error showing selector: $e');
    }
  }

  bool get _isEnabled =>
      widget.enabled &&
      widget.countryId != null &&
      widget.countryId!.isNotEmpty;

  String get _subtitleText {
    if (widget.countryId == null || widget.countryId!.isEmpty) {
      return 'Primero selecciona un país';
    }
    return _selectedLabel ??
        'Selecciona una ${widget.labelText?.toLowerCase() ?? 'región'}';
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
            title: Text(widget.labelText ?? 'Región/Estado'),
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
