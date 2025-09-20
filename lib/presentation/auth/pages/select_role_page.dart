import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  String? _role;
  late final RegistrationController _reg;

  @override
  void initState() {
    super.initState();
    _reg = Get.find<RegistrationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona rol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'propietario', child: Text('Propietario')),
                DropdownMenuItem(value: 'conductor', child: Text('Conductor')),
                DropdownMenuItem(value: 'administrador', child: Text('Administrador')),
                DropdownMenuItem(value: 'proveedor', child: Text('Proveedor')),
                DropdownMenuItem(value: 'técnico', child: Text('Técnico')),
                DropdownMenuItem(value: 'manager', child: Text('Manager')),
              ],
              onChanged: (v) => setState(() => _role = v),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _role == null
                  ? null
                  : () async {
                      await _reg.setRole(_role!);
                      if (mounted) Get.toNamed('/auth/register/terms');
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
