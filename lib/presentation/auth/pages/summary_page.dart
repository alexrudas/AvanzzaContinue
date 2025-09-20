import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    final p = reg.progress.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen de registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Usuario: ${p?.username ?? ''}'),
            Text('Email: ${p?.email ?? ''}'),
            Text('Documento: ${p?.docType ?? ''} ${p?.docNumber ?? ''}'),
            Text('Código/QR: ${p?.barcodeRaw ?? ''}'),
            Text('País: ${p?.countryId ?? ''}'),
            Text('Región: ${p?.regionId ?? ''}'),
            Text('Ciudad: ${p?.cityId ?? ''}'),
            Text('Rol inicial: ${p?.selectedRole ?? ''}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await reg.finalizeRegistration();
                if (context.mounted) Get.offAllNamed('/home');
              },
              child: const Text('Finalizar y entrar'),
            )
          ],
        ),
      ),
    );
  }
}
