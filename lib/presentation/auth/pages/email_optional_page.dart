import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class EmailOptionalPage extends StatefulWidget {
  const EmailOptionalPage({super.key});

  @override
  State<EmailOptionalPage> createState() => _EmailOptionalPageState();
}

class _EmailOptionalPageState extends State<EmailOptionalPage> {
  final _emailCtrl = TextEditingController();
  late final RegistrationController _reg;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correo opcional')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo (opcional)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _reg.setEmail(_emailCtrl.text.trim());
                if (mounted) Get.toNamed('/auth/register/id-scan');
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
