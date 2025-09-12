import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key});
  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final codeCtrl = TextEditingController();
  late final AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar código')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final s = controller.state.value;
          final seconds = controller.secondsToResend;
          final verifying = s.status == 'verifying';
          final canSubmit = codeCtrl.text.trim().length == 6 && !verifying;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (s.verificationId != null)
                Text('ID verificación: ${s.verificationId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: codeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration:
                    const InputDecoration(labelText: 'Código de 6 dígitos'),
                onChanged: (_) => setState(() {}), // actualiza canSubmit
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: canSubmit
                    ? () => controller.onVerifyCode(codeCtrl.text.trim())
                    : null,
                child: Text(verifying ? 'Verificando...' : 'Verificar'),
              ),
              const SizedBox(height: 8),
              Text(seconds > 0
                  ? 'Reenviar en $seconds s'
                  : 'Puedes reenviar el código'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: controller.canResend ? controller.resendOtp : null,
                child: const Text('Reenviar código'),
              ),
              if (s.message != null) ...[
                const SizedBox(height: 8),
                Text(s.message!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          );
        }),
      ),
    );
  }
}
