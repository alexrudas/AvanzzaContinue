import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _accepted = false;
  late final RegistrationController _reg;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Términos y condiciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: SingleChildScrollView(child: Text('Contenido de términos y condiciones...'))),
            Row(
              children: [
                Checkbox(value: _accepted, onChanged: (v) => setState(() => _accepted = v ?? false)),
                const Expanded(child: Text('Acepto los términos y condiciones')),
              ],
            ),
            ElevatedButton(
              onPressed: _accepted
                  ? () async {
                      await _reg.acceptTerms();
                      if (mounted) Get.toNamed('/auth/register/summary');
                    }
                  : null,
              child: const Text('Aceptar y continuar'),
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
