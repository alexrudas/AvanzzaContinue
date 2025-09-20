import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';
import '../../../core/di/container.dart';
import '../../../domain/repositories/geo_repository.dart';
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
  final _countries = <DropdownMenuItem<String>>[].obs;
  final _regions = <DropdownMenuItem<String>>[].obs;
  final _cities = <DropdownMenuItem<String>>[].obs;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
    _geo = DIContainer().geoRepository;
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final list = await _geo.fetchCountries(isActive: true);
    _countries.assignAll(list.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList());
  }

  Future<void> _loadRegions(String countryId) async {
    final list = await _geo.fetchRegions(countryId: countryId, isActive: true);
    _regions.assignAll(list.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList());
  }

  Future<void> _loadCities(String countryId, String? regionId) async {
    final list = await _geo.fetchCities(countryId: countryId, regionId: regionId, isActive: true);
    _cities.assignAll(list.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona país y ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _countryId,
              items: _countries,
              decoration: const InputDecoration(labelText: 'País'),
              onChanged: (v) async {
                setState(() {
                  _countryId = v;
                  _regionId = null;
                  _cityId = null;
                  _regions.clear();
                  _cities.clear();
                });
                if (v != null) await _loadRegions(v);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _regionId,
              items: _regions,
              decoration: const InputDecoration(labelText: 'Región (opcional)'),
              onChanged: (v) async {
                setState(() {
                  _regionId = v;
                  _cityId = null;
                  _cities.clear();
                });
                if (_countryId != null) await _loadCities(_countryId!, _regionId);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _cityId,
              items: _cities,
              decoration: const InputDecoration(labelText: 'Ciudad'),
              onChanged: (v) => setState(() => _cityId = v),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (_countryId != null && _cityId != null)
                  ? () async {
                      await _reg.setLocation(
                        countryId: _countryId!,
                        regionId: _regionId,
                        cityId: _cityId!,
                      );
                      if (mounted) Get.toNamed('/auth/role');
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
        )),
      ),
    );
  }
}
