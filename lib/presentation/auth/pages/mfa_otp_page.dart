import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_password_controller.dart';

class MfaOtpPage extends StatefulWidget {
  const MfaOtpPage({super.key});

  @override
  State<MfaOtpPage> createState() => _MfaOtpPageState();
}

class _MfaOtpPageState extends State<MfaOtpPage> {
  final _codeCtrl = TextEditingController();
  late final LoginPasswordController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<LoginPasswordController>(tag: 'login_flow');
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segundo factor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Código de 6 dígitos'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final uid = await _ctrl.verifyMfa(_codeCtrl.text.trim());
                if (mounted) Get.offAllNamed('/home');
              },
              child: const Text('Verificar'),
            )
          ],
        ),
      ),
    );
  }
}
