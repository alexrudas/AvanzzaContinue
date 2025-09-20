import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/registration_controller.dart';

class UsernamePasswordPage extends StatefulWidget {
  const UsernamePasswordPage({super.key});

  @override
  State<UsernamePasswordPage> createState() => _UsernamePasswordPageState();
}

class _UsernamePasswordPageState extends State<UsernamePasswordPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late final RegistrationController _reg;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
    _reg.loadProgress();
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crea tu usuario y contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final msg = _reg.message.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _userCtrl,
                decoration: const InputDecoration(labelText: 'Usuario único'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final u = _userCtrl.text.trim();
                  final p = _passCtrl.text.trim();
                  if (u.isEmpty || p.length < 8) {
                    _reg.message.value = 'Usuario y contraseña (>=8) requeridos';
                    return;
                  }
                  final ok = await _reg.isUsernameAvailable(u);
                  if (!ok) return;
                  // Nota: el phone debería venir del paso OTP ya realizado; para el demo, usamos el del progreso si estuviera
                  final current = _reg.progress.value;
                  final phone = current?.phone ?? '';
                  await _reg.createAccount(username: u, password: p, phone: phone);
                  if (mounted) Get.toNamed('/auth/register/email');
                },
                child: const Text('Continuar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Volver'),
              ),
              if (msg.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(msg, style: const TextStyle(color: Colors.red)),
              ],
            ],
          );
        }),
      ),
    );
  }
}
