import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class ProviderCoveragePage extends StatefulWidget {
  const ProviderCoveragePage({super.key});
  @override
  State<ProviderCoveragePage> createState() => _ProviderCoveragePageState();
}

class _ProviderCoveragePageState extends State<ProviderCoveragePage> {
  final _cities = <String>{};

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cobertura')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Fase 1: stub de ciudades predefinidas
                ListTile(
                  title: const Text('Medellín'),
                  trailing: Checkbox(
                    value: _cities.contains('CO/ANT/MEDELLIN'),
                    onChanged: (v) => setState(() {
                      v == true ? _cities.add('CO/ANT/MEDELLIN') : _cities.remove('CO/ANT/MEDELLIN');
                    }),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () async {
                await reg.setProviderCoverage(_cities.toList());
                Get.back(result: true);
              },
              child: const Text('Guardar'),
            ),
          )
        ],
      ),
    );
  }
}
