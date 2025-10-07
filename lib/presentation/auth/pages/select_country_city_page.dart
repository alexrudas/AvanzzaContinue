import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/telemetry/telemetry_service.dart';
import '../../../core/di/container.dart';
import '../../../domain/repositories/geo_repository.dart';
import '../../../routes/app_pages.dart';
import '../../widgets/wizard/bottom_sheet_selector.dart';
import '../../widgets/wizard/wizard_bottom_bar.dart';
import '../controllers/registration_controller.dart';

class SelectCountryCityPage extends StatefulWidget {
  const SelectCountryCityPage({super.key});

  @override
  State<SelectCountryCityPage> createState() => _SelectCountryCityPageState();
}

class _SelectCountryCityPageState extends State<SelectCountryCityPage> {
  String? _countryId;
  String? _regionId;
  String? _cityId;
  String? _countryLabel;
  String? _regionLabel;
  String? _cityLabel;

  late final RegistrationController _reg;
  late final GeoRepository _geo;
  TelemetryService? _telemetry;
  DateTime? _sheetOpenedAt;

  @override
  void initState() {
    super.initState();
    assert(Get.isRegistered<RegistrationController>(),
        'RegistrationController not registered');
    _reg = Get.find<RegistrationController>();
    _geo = DIContainer().geoRepository;
    _telemetry = Get.isRegistered<TelemetryService>()
        ? Get.find<TelemetryService>()
        : null;
    // Rehidratación básica
    final p = _reg.progress.value;
    _countryId = p?.countryId;
    _regionId = p?.regionId;
    _cityId = p?.cityId;
  }

  void _log(String event, Map<String, Object?> extra) {
    try {
      _telemetry?.log(event, {
        'country': _countryId,
        'region': _regionId,
        'city': _cityId,
        ...extra,
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final canContinue =
        (_countryId != null && _regionId != null && _cityId != null);

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona país y ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // País selector
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              title: const Text('País'),
              subtitle: Text(_countryLabel ?? 'Selecciona un país',
                  style: TextStyle(color: Theme.of(context).hintColor)),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () async {
                try {
                  _sheetOpenedAt = DateTime.now();
                  final list = await _geo.fetchCountries(isActive: true);
                  _log('sheet_open',
                      {'step': 'country', 'items_count': list.length});
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => BottomSheetSelector<String>(
                      title: 'Elige tu país',
                      selectedValue: _countryId,
                      items: list
                          .map((c) => SelectorItem(value: c.id, label: c.name))
                          .toList(),
                      onSelect: (item) async {
                        setState(() {
                          _countryId = item.value;
                          _countryLabel = item.label;
                          _regionId = null;
                          _regionLabel = null;
                          _cityId = null;
                          _cityLabel = null;
                        });
                        await _reg.setLocation(
                            countryId: _countryId!,
                            regionId: null,
                            cityId: null);
                        final elapsed = DateTime.now()
                            .difference(_sheetOpenedAt!)
                            .inMilliseconds;
                        _log('sheet_select', {
                          'step': 'country',
                          'selected_id': item.value,
                          'selected_label': item.label,
                          'duration_ms': elapsed
                        });
                      },
                    ),
                  );
                } catch (e) {
                  _log('sheet_error',
                      {'step': 'country', 'cause': e.toString()});
                }
              },
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Región selector
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              title: const Text('Región/Estado'),
              subtitle: Text(
                _regionLabel ??
                    (_countryId == null
                        ? 'Primero selecciona un país'
                        : 'Selecciona una región'),
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: (_countryId == null)
                  ? null
                  : () async {
                      try {
                        _sheetOpenedAt = DateTime.now();
                        final list = await _geo.fetchRegions(
                            countryId: _countryId!, isActive: true);
                        _log('sheet_open',
                            {'step': 'region', 'items_count': list.length});
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) => BottomSheetSelector<String>(
                            title: 'Elige tu región/estado',
                            selectedValue: _regionId,
                            items: list
                                .map((r) =>
                                    SelectorItem(value: r.id, label: r.name))
                                .toList(),
                            onSelect: (item) async {
                              setState(() {
                                _regionId = item.value;
                                _regionLabel = item.label;
                                _cityId = null;
                                _cityLabel = null;
                              });
                              await _reg.setLocation(
                                  countryId: _countryId!,
                                  regionId: _regionId!,
                                  cityId: null);
                              final elapsed = DateTime.now()
                                  .difference(_sheetOpenedAt!)
                                  .inMilliseconds;
                              _log('sheet_select', {
                                'step': 'region',
                                'selected_id': item.value,
                                'selected_label': item.label,
                                'duration_ms': elapsed
                              });
                            },
                          ),
                        );
                      } catch (e) {
                        _log('sheet_error',
                            {'step': 'region', 'cause': e.toString()});
                      }
                    },
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Ciudad selector
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              title: const Text('Ciudad'),
              subtitle: Text(
                _cityLabel ??
                    (_regionId == null
                        ? 'Primero selecciona una región'
                        : 'Selecciona una ciudad'),
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: (_countryId == null || _regionId == null)
                  ? null
                  : () async {
                      try {
                        _sheetOpenedAt = DateTime.now();
                        final list = await _geo.fetchCities(
                            countryId: _countryId!,
                            regionId: _regionId!,
                            isActive: true);
                        _log('sheet_open',
                            {'step': 'city', 'items_count': list.length});
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) => BottomSheetSelector<String>(
                            title: 'Elige tu ciudad',
                            selectedValue: _cityId,
                            items: list
                                .map((c) =>
                                    SelectorItem(value: c.id, label: c.name))
                                .toList(),
                            onSelect: (item) async {
                              setState(() {
                                _cityId = item.value;
                                _cityLabel = item.label;
                              });
                              await _reg.setLocation(
                                  countryId: _countryId!,
                                  regionId: _regionId!,
                                  cityId: _cityId!);
                              final elapsed = DateTime.now()
                                  .difference(_sheetOpenedAt!)
                                  .inMilliseconds;
                              _log('sheet_select', {
                                'step': 'city',
                                'selected_id': item.value,
                                'selected_label': item.label,
                                'duration_ms': elapsed
                              });
                            },
                          ),
                        );
                      } catch (e) {
                        _log('sheet_error',
                            {'step': 'city', 'cause': e.toString()});
                      }
                    },
            ),
            const Divider(height: 1),
          ],
        ),
      ),
      bottomNavigationBar: WizardBottomBar(
        onBack: () => Get.back(),
        onContinue: () => Get.offNamed(Routes.profile),
        continueEnabled: canContinue,
      ),
    );
  }
}
