import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class ProviderAssetTypesPage extends StatefulWidget {
  const ProviderAssetTypesPage({super.key});
  @override
  State<ProviderAssetTypesPage> createState() => _ProviderAssetTypesPageState();
}

class _ProviderAssetTypesPageState extends State<ProviderAssetTypesPage> {
  final _sel = <String>{};
  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    final opts = const [
      {'id':'vehiculos','label':'Vehículos'},
      {'id':'inmuebles','label':'Inmuebles'},
      {'id':'maquinaria','label':'Maquinaria'},
      {'id':'equipos','label':'Equipos'},
      {'id':'otros','label':'Otros'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tipos de activo')),
      body: ListView(
        children: [
          for (final o in opts)
            CheckboxListTile(
              title: Text(o['label']!),
              value: _sel.contains(o['id']),
              onChanged: (v) => setState(() {
                v == true ? _sel.add(o['id']!) : _sel.remove(o['id']!);
              }),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () async {
                await reg.setAssetTypes(_sel.toList());
                Get.back(result: true);
              },
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}
