import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_password_controller.dart';
import '../../../core/di/app_bindings.dart';

class LoginUsernamePasswordPage extends StatefulWidget {
  const LoginUsernamePasswordPage({super.key});

  @override
  State<LoginUsernamePasswordPage> createState() => _LoginUsernamePasswordPageState();
}

class _LoginUsernamePasswordPageState extends State<LoginUsernamePasswordPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late final LoginPasswordController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = LoginPasswordController(
      signInUC: Get.find(),
      sendMfaUC: Get.find(),
      verifyMfaUC: Get.find(),
    );
    Get.put<LoginPasswordController>(_ctrl, tag: 'login_flow');
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
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final status = _ctrl.status.value;
          return Column(
            children: [
              TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Usuario')),
              const SizedBox(height: 8),
              TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _ctrl.signIn(_userCtrl.text.trim(), _passCtrl.text.trim());
                  if (_ctrl.status.value == 'awaiting_mfa' && mounted) {
                    Get.toNamed('/auth/login/mfa');
                  }
                },
                child: Text(status == 'signing' ? 'Ingresando...' : 'Ingresar'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
