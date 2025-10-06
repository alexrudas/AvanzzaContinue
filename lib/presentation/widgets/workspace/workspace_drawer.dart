import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../data/datasources/local/registration_progress_ds.dart';
import '../../../data/models/auth/registration_progress_model.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/registration_controller.dart';
import '../../controllers/session_context_controller.dart';

class WorkspaceDrawer extends StatelessWidget {
  const WorkspaceDrawer({super.key});

  // Persiste selección de exploración (rol/providerType) usando RegistrationController si existe,
  // de lo contrario escribe directamente en Isar (RegistrationProgressDS).
  Future<void> _persistExploreSelection({
    RegistrationController? reg,
    required String titularType,
    required String role,
    String? providerType,
  }) async {
    if (reg != null) {
      await reg.setTitularType(titularType);
      await reg.setRole(role);
      if (providerType != null && providerType.isNotEmpty) {
        await reg.setProviderType(providerType);
      }
    } else {
      final ds = RegistrationProgressDS(DIContainer().isar);
      final current = await ds.get('current') ??
          (RegistrationProgressModel()..id = 'current');
      current.titularType = titularType;
      current.selectedRole = role;
      if (providerType != null && providerType.isNotEmpty) {
        current.providerType = providerType;
      }
      await ds.upsert(current);
    }
  }

  // Limpia el preview y navega a la vista inicial
  Future<void> _exitToWelcome() async {
    if (Get.isRegistered<RegistrationController>()) {
      final reg = Get.find<RegistrationController>();
      await reg.clear('current');
    } else {
      final ds = RegistrationProgressDS(DIContainer().isar);
      await ds.clear('current');
    }
    Get.offAllNamed(Routes.countryCity);
  }

  // Ir al flujo de registro de usuario
  void _goToRegister() {
    Get.toNamed(Routes.registerUsername);
  }

  @override
  Widget build(BuildContext context) {
    final session = Get.isRegistered<SessionContextController>()
        ? Get.find<SessionContextController>()
        : null;
    final reg = Get.isRegistered<RegistrationController>()
        ? Get.find<RegistrationController>()
        : null;
    final user = session?.user;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (user == null) ..._buildExploreSection(reg),
            if (user != null) ..._buildSessionSection(session!),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Salir'),
              onTap: _exitToWelcome,
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text('Registrarme'),
              onTap: _goToRegister,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () => Get.snackbar('Avanzza 2.0',
                  'Workspaces por rol – Exploración/Registro diferido'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExploreSection(RegistrationController? reg) {
    return [
      const DrawerHeader(
          child: Text('Explorar roles', style: TextStyle(fontSize: 18))),
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Administrador de activos'),
        onTap: () async {
          await _persistExploreSelection(
            reg: reg,
            titularType: 'persona',
            role: 'admin_activos_ind',
          );
          Get.offAllNamed(Routes.home);
        },
      ),
      ListTile(
        leading: const Icon(Icons.manage_accounts_outlined),
        title: const Text('Propietario de activos'),
        onTap: () async {
          await _persistExploreSelection(
            reg: reg,
            titularType: 'persona',
            role: 'propietario',
          );
          Get.offAllNamed(Routes.home);
        },
      ),
      ListTile(
        leading: const Icon(Icons.vpn_key_outlined),
        title: const Text('Arrendatario de activos'),
        onTap: () async {
          await _persistExploreSelection(
            reg: reg,
            titularType: 'persona',
            role: 'arrendatario',
          );
          Get.offAllNamed(Routes.home);
        },
      ),
      ExpansionTile(
        leading: const Icon(Icons.handyman_outlined),
        title: const Text('Proveedor'),
        children: [
          ListTile(
            leading: const Icon(Icons.build_outlined),
            title: const Text('Servicios'),
            onTap: () async {
              await _persistExploreSelection(
                reg: reg,
                titularType: 'persona',
                role: 'proveedor',
                providerType: 'servicios',
              );
              Get.offAllNamed(Routes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Artículos'),
            onTap: () async {
              await _persistExploreSelection(
                reg: reg,
                titularType: 'persona',
                role: 'proveedor',
                providerType: 'articulos',
              );
              Get.offAllNamed(Routes.home);
            },
          ),
        ],
      ),
      ListTile(
        leading: const Icon(Icons.shield_outlined),
        title: const Text('Aseguradora / Broker'),
        onTap: () async {
          await _persistExploreSelection(
            reg: reg,
            titularType: 'empresa',
            role: 'aseguradora',
            providerType: 'articulos',
          );
          Get.offAllNamed(Routes.home);
        },
      ),
      ListTile(
        leading: const Icon(Icons.gavel_outlined),
        title: const Text('Legal'),
        onTap: () async {
          await _persistExploreSelection(
            reg: reg,
            titularType: 'persona',
            role: 'abogado',
            providerType: 'servicios',
          );
          Get.offAllNamed(Routes.home);
        },
      ),
    ];
  }

  List<Widget> _buildSessionSection(SessionContextController session) {
    final user = session.user!;
    final active = user.activeContext;
    final activeLabel =
        active != null ? '${active.orgName} • ${active.rol}' : 'Sin activo';

    return [
      UserAccountsDrawerHeader(
        accountName: Text(user.name),
        accountEmail: Text(activeLabel),
        currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
      ),
      ListTile(
        leading: const Icon(Icons.add_circle_outline),
        title: const Text('Agregar workspace'),
        onTap: () async {
          Get.toNamed(Routes.holderType);
        },
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('Mis workspaces',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      ...session.memberships.expand((m) => m.roles.map((role) {
            final label = '${m.orgName} • $role';
            return ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text(label),
              onTap: () async {
                String? providerType;
                if (role.toLowerCase().contains('proveedor') &&
                    m.providerProfiles.isNotEmpty) {
                  providerType = m.providerProfiles.first.providerType;
                }
                final current = session.user?.activeContext;
                if (current == null) return;
                await session.setActiveContext(
                  current.copyWith(
                    orgId: m.orgId,
                    orgName: m.orgName,
                    rol: role,
                    providerType: providerType,
                  ),
                );
                Get.offAllNamed(Routes.home);
              },
            );
          })),
    ];
  }
}
