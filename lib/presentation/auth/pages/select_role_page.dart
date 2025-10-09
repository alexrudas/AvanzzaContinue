import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
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

  List<DropdownMenuItem<String>> _itemsForTitular(String tipo) {
    if (tipo == 'empresa') {
      return const [
        DropdownMenuItem(
            value: 'propietario_emp', child: Text('Propietario de activos')),
        DropdownMenuItem(
            value: 'admin_activos_org',
            child: Text('Administrador de activos')),
        DropdownMenuItem(
            value: 'arrendatario_emp', child: Text('Arrendatario de activos')),
        DropdownMenuItem(value: 'proveedor', child: Text('Proveedor')),
        DropdownMenuItem(
            value: 'aseguradora', child: Text('Aseguradora / Broker')),
        DropdownMenuItem(
            value: 'abogados_firma',
            child: Text('Abogados (firmas/despachos)')),
      ];
    }
    return const [
      DropdownMenuItem(
          value: 'propietario', child: Text('Propietario de activos')),
      DropdownMenuItem(
          value: 'admin_activos_ind', child: Text('Administrador de activos')),
      DropdownMenuItem(
          value: 'arrendatario', child: Text('Arrendatario de activos')),
      DropdownMenuItem(value: 'proveedor', child: Text('Proveedor')),
      DropdownMenuItem(
          value: 'asesor_seguros', child: Text('Asesor de seguros')),
      DropdownMenuItem(value: 'abogado', child: Text('Abogado')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tipo = _reg.titularType.value.isNotEmpty
        ? _reg.titularType.value
        : (_reg.progress.value?.titularType ?? 'persona');
    final items = _itemsForTitular(tipo);

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona rol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _role,
              items: items,
              onChanged: (v) => setState(() => _role = v),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _role == null
                  ? null
                  : () async {
                      final role = _role!;
                      await _reg.setRole(role);

                      if (role == 'proveedor') {
                        // Proveedor sigue el wizard de segmentación
                        Get.toNamed(Routes.providerProfile);
                        return;
                      }

                      // Aseguradora y Asesor de seguros usan providerType 'articulos'
                      if (role == 'aseguradora' || role == 'asesor_seguros') {
                        await _reg.setProviderType('articulos');
                      }

                      // Legal (abogado / firma) usa providerType 'servicios'
                      if (role == 'abogado' || role == 'abogados_firma') {
                        await _reg.setProviderType('servicios');
                      }

                      // Entrar a workspace sin registrarse (exploración)
                      Get.offAllNamed(Routes.home);
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
