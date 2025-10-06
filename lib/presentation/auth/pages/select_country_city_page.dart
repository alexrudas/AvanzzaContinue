import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/repositories/geo_repository.dart';
import '../../../routes/app_pages.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona país y ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // País
              DropdownButtonFormField<String>(
                key: const ValueKey('country'),
                value: _countryId,
                items: _countries,
                decoration: const InputDecoration(labelText: 'País'),
                onChanged: _loadingCountries.value
                    ? null
                    : (v) async {
                        setState(() {
                          _countryId = v;
                          _regionId = null;
                          _cityId = null;
                          _regions.clear();
                          _cities.clear();
                        });
                        if (v != null) {
                          await _loadRegions(v); // Solo regiones aquí
                          // NO cargar ciudades aquí
                        }
                      },
              ),
              if (_loadingCountries.value) ...[
                const SizedBox(height: 6),
                const _LoadingHint(text: 'Cargando países...'),
              ],
              const SizedBox(height: 12),

              // Región
              DropdownButtonFormField<String>(
                key: ValueKey('region-${_countryId ?? 'x'}'),
                value: _regionId,
                items: _regions,
                decoration: const InputDecoration(labelText: 'Región'),
                onChanged: (_countryId == null || _loadingRegions.value)
                    ? null
                    : (v) async {
                        setState(() {
                          _regionId = v;
                          _cityId = null;
                          _cities.clear();
                        });
                        if (v != null) {
                          await _loadCities(_countryId!, v); // Ciudades aquí
                        }
                      },
              ),
              if (_loadingRegions.value) ...[
                const SizedBox(height: 6),
                const _LoadingHint(text: 'Cargando regiones...'),
              ],
              const SizedBox(height: 12),

              // Ciudad
              DropdownButtonFormField<String>(
                key: ValueKey(
                    'city-${_countryId ?? 'x'}-${_regionId ?? 'none'}'),
                value: _cityId,
                items: _cities,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                onChanged: (_countryId == null ||
                        _regionId == null ||
                        _loadingCities.value)
                    ? null
                    : (v) => setState(() => _cityId = v),
              ),
              if (_loadingCities.value) ...[
                const SizedBox(height: 6),
                const _LoadingHint(text: 'Cargando ciudades...'),
              ],
              const SizedBox(height: 16),

              // Continuar
              ElevatedButton(
                onPressed: (_countryId != null &&
                        _regionId != null &&
                        _cityId != null &&
                        !_loadingCountries.value &&
                        !_loadingRegions.value &&
                        !_loadingCities.value)
                    ? () async {
                        await _reg.setLocation(
                          countryId: _countryId!,
                          regionId: _regionId!,
                          cityId: _cityId!,
                        );
                        final titular = _reg.titularType.value.isNotEmpty
                            ? _reg.titularType.value
                            : (_reg.progress.value?.titularType ?? '');
                        if (titular.isEmpty) {
                          Get.offNamed(Routes.holderType);
                        } else {
                          Get.offNamed(Routes.role);
                        }
                      }
                    : null,
                child: const Text('Continuar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
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
