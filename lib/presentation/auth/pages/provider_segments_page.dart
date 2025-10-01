import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class ProviderSegmentsPage extends StatefulWidget {
  const ProviderSegmentsPage({super.key});
  @override
  State<ProviderSegmentsPage> createState() => _ProviderSegmentsPageState();
}

class _ProviderSegmentsPageState extends State<ProviderSegmentsPage> {
  final _sel = <String>{};
  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    final opts = const [
      {'id':'moto','label':'Moto'},
      {'id':'auto','label':'Auto'},
      {'id':'camion','label':'Camión'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Segmentos (vehículos)')),
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
                await reg.setAssetSegments(_sel.toList());
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
