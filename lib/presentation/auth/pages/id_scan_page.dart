import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/registration_controller.dart';

class IdScanPage extends StatefulWidget {
  const IdScanPage({super.key});

  @override
  State<IdScanPage> createState() => _IdScanPageState();
}

class _IdScanPageState extends State<IdScanPage> {
  final _docTypeCtrl = TextEditingController();
  final _docNumberCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  late final RegistrationController _reg;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
  }

  @override
  void dispose() {
    _docTypeCtrl.dispose();
    _docNumberCtrl.dispose();
    _barcodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear documento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _docTypeCtrl, decoration: const InputDecoration(labelText: 'Tipo de documento')),
            const SizedBox(height: 8),
            TextField(controller: _docNumberCtrl, decoration: const InputDecoration(labelText: 'Número de documento')),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeCtrl,
                    decoration: const InputDecoration(labelText: 'Código/QR leído'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: MobileScanner(
                          onDetect: (capture) {
                            final barcodes = capture.barcodes;
                            if (barcodes.isNotEmpty) {
                              final raw = barcodes.first.rawValue ?? '';
                              _barcodeCtrl.text = raw;
                              Navigator.of(ctx).pop();
                            }
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _reg.setIdentity(
                  docType: _docTypeCtrl.text.trim(),
                  docNumber: _docNumberCtrl.text.trim(),
                  barcodeRaw: _barcodeCtrl.text.trim(),
                );
                if (mounted) Get.toNamed('/auth/country-city');
              },
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
    );
  }
}
