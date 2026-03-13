// ============================================================================
// lib/presentation/auth/pages/phone_input_page.dart
// PHONE INPUT PAGE — Enterprise Ultra Pro (Presentation / Auth / Pages)
//
// QUÉ HACE:
// - Captura el número de teléfono y dispara onSendOtp via AuthController.
// - Escucha AuthState: navega a OtpVerifyPage cuando status == 'sent'.
// - Muestra error inline cuando status == 'error'.
//
// QUÉ NO HACE:
// - No accede a verificationId (implementación privada en AuthController).
// - No navega directamente; delega a AuthController.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/registration_controller.dart';
import 'otp_verify_page.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({super.key});
  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final textCtrl = TextEditingController();
  late final AuthController controller;
  late final RegistrationController reg;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
    reg = Get.find<RegistrationController>();
    ever<AuthState>(controller.state, (s) {
      if (s.status == 'sent') {
        reg.setPhone(textCtrl.text.trim());
        Get.to(() => const OtpVerifyPage());
      }
      if (s.status == 'authenticated') {
        // El controlador ya hace Get.offAllNamed(Routes.home)
      }
    });
  }

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación por SMS')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Número de teléfono (e.g., +57 300 123 4567)',
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final s = controller.state.value;
              final busy = s.status == 'sending';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: busy ? null : () => controller.onSendOtp(textCtrl.text.trim()),
                    child: Text(busy ? 'Enviando...' : 'Enviar código'),
                  ),
                  if (s.message != null) ...[
                    const SizedBox(height: 8),
                    Text(s.message!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
