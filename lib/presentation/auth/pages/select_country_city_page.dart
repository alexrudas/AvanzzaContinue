import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/telemetry/telemetry_service.dart';
import '../../../domain/entities/location/location_selection.dart';
import '../../../routes/app_pages.dart';
import '../../shared/widgets/location/location_selector.dart';
import '../../widgets/wizard/wizard_bottom_bar.dart';
import '../controllers/registration_controller.dart';

/// Página para seleccionar país, región y ciudad durante el registro.
///
/// Esta página usa el widget [LocationSelector] para gestionar toda la lógica
/// de selección geográfica de forma desacoplada.
///
/// El estado se persiste en [RegistrationController] para mantenerlo entre
/// navegaciones durante el flujo de registro.
class SelectCountryCityPage extends StatefulWidget {
  const SelectCountryCityPage({super.key});

  @override
  State<SelectCountryCityPage> createState() => _SelectCountryCityPageState();
}

class _SelectCountryCityPageState extends State<SelectCountryCityPage> {
  late final RegistrationController _reg;
  TelemetryService? _telemetry;

  // Estado local de la selección actual
  LocationSelection _currentSelection = const LocationSelection();

  @override
  void initState() {
    super.initState();

    assert(Get.isRegistered<RegistrationController>(),
        'RegistrationController not registered');

    _reg = Get.find<RegistrationController>();
    _telemetry = Get.isRegistered<TelemetryService>()
        ? Get.find<TelemetryService>()
        : null;

    // Cargar selección inicial desde el progreso de registro
    final p = _reg.progress.value;
    if (p != null) {
      _currentSelection = LocationSelection(
        countryId: p.countryId,
        regionId: p.regionId,
        cityId: p.cityId,
      );
    }
  }

  /// Registra eventos en telemetría si el servicio está disponible
  void _log(String event, Map<String, Object?> extra) {
    try {
      _telemetry?.log(event, {
        'country': _currentSelection.countryId,
        'region': _currentSelection.regionId,
        'city': _currentSelection.cityId,
        ...extra,
      });
    } catch (_) {
      // Silenciosamente ignorar errores de telemetría
    }
  }

  /// Maneja cambios en la selección de localización
  Future<void> _handleLocationChange(LocationSelection selection) async {
    setState(() {
      _currentSelection = selection;
    });

    // Persistir en el controlador de registro
    try {
      await _reg.setLocation(
        countryId: selection.countryId ?? '',
        regionId: selection.regionId,
        cityId: selection.cityId,
      );

      // Log de telemetría
      if (selection.countryId != null) {
        _log('location_country_selected', {'countryId': selection.countryId});
      }
      if (selection.regionId != null) {
        _log('location_region_selected', {'regionId': selection.regionId});
      }
      if (selection.cityId != null) {
        _log('location_city_selected', {'cityId': selection.cityId});
      }
    } catch (e) {
      _log('location_save_error', {'error': e.toString()});
      debugPrint('[SelectCountryCityPage] Error saving location: $e');
    }
  }

  void _handleContinue() {
    if (_currentSelection.isComplete) {
      _log('location_flow_complete', {
        'countryId': _currentSelection.countryId,
        'regionId': _currentSelection.regionId,
        'cityId': _currentSelection.cityId,
      });
      Get.toNamed(Routes.profile);
    }
  }

  void _handleBack() {
    _log('location_back', {});
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _currentSelection.isComplete;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Dinos dónde se encuentra tu negocio o actividad",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // Widget orquestador de localización
            LocationSelector(
              initialCountryId: _currentSelection.countryId,
              initialRegionId: _currentSelection.regionId,
              initialCityId: _currentSelection.cityId,
              onChanged: _handleLocationChange,
            ),
          ],
        ),
      ),
      bottomNavigationBar: WizardBottomBar(
        onBack: _handleBack,
        onContinue: _handleContinue,
        continueEnabled: canContinue,
      ),
    );
  }
}
