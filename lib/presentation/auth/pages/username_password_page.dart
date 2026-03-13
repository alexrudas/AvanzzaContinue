import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/registration_controller.dart';

class UsernamePasswordPage extends StatefulWidget {
  const UsernamePasswordPage({super.key});

  @override
  State<UsernamePasswordPage> createState() => _UsernamePasswordPageState();
}

class _UsernamePasswordPageState extends State<UsernamePasswordPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late final RegistrationController _reg;

  /// null = detectando, '' = sin username previo, non-empty = username existente
  String? _existingUsername;
  bool _detecting = true;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
    _runResumeDetection();
  }

  /// Detecta si hay un registro en curso usando progress.step como fuente de verdad.
  /// step >= 1 → mostrar UI de "Continúa tu registro" (sin llamada Firestore).
  Future<void> _runResumeDetection() async {
    await _reg.loadProgress();
    final step = _reg.progress.value?.step ?? 0;
    if (mounted) {
      setState(() {
        _existingUsername = step >= 1
            ? (_reg.progress.value?.username ?? 'registered')
            : '';
        _detecting = false;
      });
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Acción: continuar registro reanudado ────────────────────────────────────
  Future<void> _onResumeContinue() async {
    await _reg.resumeRegistration();
  }

  // ── Acción: continuar con nuevo username ────────────────────────────────────
  Future<void> _onSubmitNew() async {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text.trim();
    if (u.isEmpty || p.length < 8) {
      _reg.message.value = 'Usuario y contraseña (>=8) requeridos';
      return;
    }
    final ok = await _reg.isUsernameAvailable(u);
    if (!ok) return;
    final current = _reg.progress.value;
    final phone = current?.phone ?? '';
    await _reg.createAccount(username: u, password: p, phone: phone);
    if (mounted) Get.toNamed(Routes.registerEmail);
  }

  @override
  Widget build(BuildContext context) {
    if (_detecting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ── ContinueRegistration UI ────────────────────────────────────────────
    final hasExisting =
        _existingUsername != null && _existingUsername!.isNotEmpty;
    if (hasExisting) {
      return Scaffold(
        appBar: AppBar(title: const Text('Continúa tu registro')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person_pin_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                'Continúa tu registro',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Parece que dejaste tu registro a mitad. Puedes continuarlo ahora.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onResumeContinue,
                child: const Text('Continuar'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Más tarde'),
              ),
            ],
          ),
        ),
      );
    }

    // ── Formulario normal (username + password) ────────────────────────────
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
                onPressed: _onSubmitNew,
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
