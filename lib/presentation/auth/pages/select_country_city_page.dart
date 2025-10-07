import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Datos para selects
  final _countries = <DropdownMenuItem<String>>[].obs;
  final _regions = <DropdownMenuItem<String>>[].obs;
  final _cities = <DropdownMenuItem<String>>[].obs;

  // Loading states
  final _loadingCountries = true.obs;
  final _loadingRegions = false.obs;
  final _loadingCities = false.obs;

  // Tokens anti-carreras
  int _regionsReqToken = 0;
  int _citiesReqToken = 0;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
    _geo = DIContainer().geoRepository;
    // Rehidratación básica
    final p = _reg.progress.value;
    _countryId = p?.countryId;
    _regionId = p?.regionId;
    _cityId = p?.cityId;
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    _loadingCountries.value = true;
    _countries.clear();
    try {
      final list = await _geo.fetchCountries(isActive: true);
      _countries.assignAll(
        list.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
      );
    } finally {
      _loadingCountries.value = false;
    }
  }

  Future<void> _loadRegions(String countryId) async {
    _loadingRegions.value = true;
    _regions.clear();
    final myToken = ++_regionsReqToken;
    try {
      final list =
          await _geo.fetchRegions(countryId: countryId, isActive: true);
      if (myToken != _regionsReqToken) return;
      _regions.assignAll(
        list.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))),
      );
    } finally {
      if (myToken == _regionsReqToken) {
        _loadingRegions.value = false;
      }
    }
  }

  Future<void> _loadCities(String countryId, String regionId) async {
    _loadingCities.value = true;
    _cities.clear();
    final myToken = ++_citiesReqToken;
    try {
      final list = await _geo.fetchCities(
        countryId: countryId,
        regionId: regionId,
        isActive: true,
      );
      if (myToken != _citiesReqToken) return;
      _cities.assignAll(
        list.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
      );
    } finally {
      if (myToken == _citiesReqToken) {
        _loadingCities.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = (_countryId != null &&
        _regionId != null &&
        _cityId != null &&
        !_loadingCountries.value &&
        !_loadingRegions.value &&
        !_loadingCities.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona país y ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // País selector estilo unified
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                title: const Text('País'),
                subtitle: Text(_countryLabel ?? 'Selecciona un país',
                    style: TextStyle(color: Theme.of(context).hintColor)),
                trailing: const Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  if (_loadingCountries.value) return;
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
                      asyncLoader: (q) async {
                        final list = await _geo.fetchCountries(isActive: true);
                        final items = list
                            .map(
                                (c) => SelectorItem(value: c.id, label: c.name))
                            .toList();
                        if (q.isEmpty) return items;
                        return items
                            .where((e) =>
                                e.label.toLowerCase().contains(q.toLowerCase()))
                            .toList();
                      },
                      onSelect: (item) async {
                        setState(() {
                          _countryId = item.value;
                          _countryLabel = item.label;
                          _regionId = null;
                          _regionLabel = null;
                          _cityId = null;
                          _cityLabel = null;
                        });
                        await _loadRegions(item.value);
                      },
                    ),
                  );
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
                            asyncLoader: (q) async {
                              final list = await _geo.fetchRegions(
                                  countryId: _countryId!, isActive: true);
                              final items = list
                                  .map((r) =>
                                      SelectorItem(value: r.id, label: r.name))
                                  .toList();
                              if (q.isEmpty) return items;
                              return items
                                  .where((e) => e.label
                                      .toLowerCase()
                                      .contains(q.toLowerCase()))
                                  .toList();
                            },
                            onSelect: (item) async {
                              setState(() {
                                _regionId = item.value;
                                _regionLabel = item.label;
                                _cityId = null;
                                _cityLabel = null;
                              });
                              await _loadCities(_countryId!, item.value);
                            },
                          ),
                        );
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
                            asyncLoader: (q) async {
                              final list = await _geo.fetchCities(
                                  countryId: _countryId!,
                                  regionId: _regionId!,
                                  isActive: true);
                              final items = list
                                  .map((c) =>
                                      SelectorItem(value: c.id, label: c.name))
                                  .toList();
                              if (q.isEmpty) return items;
                              return items
                                  .where((e) => e.label
                                      .toLowerCase()
                                      .contains(q.toLowerCase()))
                                  .toList();
                            },
                            onSelect: (item) async {
                              setState(() {
                                _cityId = item.value;
                                _cityLabel = item.label;
                              });
                            },
                          ),
                        );
                      },
              ),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WizardBottomBar(
        onBack: () => Get.back(),
        onContinue: () async {
          await _reg.setLocation(
            countryId: _countryId!,
            regionId: _regionId!,
            cityId: _cityId!,
          );
          Get.offNamed(Routes.profile);
        },
        continueEnabled: canContinue,
      ),
    );
  }
}

class _LoadingHint extends StatelessWidget {
  final String text;
  const _LoadingHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
