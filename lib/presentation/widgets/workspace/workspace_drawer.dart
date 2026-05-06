// ============================================================================
// lib/presentation/widgets/workspace/workspace_drawer.dart
// WORKSPACE DRAWER — Fase 2 (KILL SWITCH ROL LEGACY).
//
// QUÉ HACE:
// - Muestra hasta dos items canónicos derivados del Core API:
//     · "Administrador de activos" — siempre presente si hay sesión con
//       `Membership` activa en el orgId actual (capability `purchase_request.read`).
//     · "Proveedor" — presente si `ProviderContextStore.isProvider == true`
//       (resuelto desde `GET /v1/providers/me`).
// - Permite cerrar sesión y un atajo a la página de validación de tema en
//   modo debug.
//
// QUÉ NO HACE:
// - NO lee `Membership.roles[]` ni `ActiveContext.rol`. La identidad del
//   workspace no proviene de strings legacy.
// - NO ofrece "agregar/eliminar workspace": en el modelo Core API el binding
//   user→workspace es 1:1 vía `Membership`. La conversión a proveedor se hace
//   desde la pantalla de bootstrap del proveedor (POST /v1/providers/bootstrap),
//   no desde el drawer.
// - NO cambia de organización aquí: el switch cross-org canónico vive en
//   `SessionContextController.applyLocalActiveContext()` y debe invocarse desde
//   una UI dedicada de selección de organización (fuera del scope de este
//   drawer). Core API resuelve `activeOrgId` por inferencia server-side cuando
//   hay 1 membership viable.
//
// PRINCIPIOS:
// - Single source of truth: capabilities + isProvider — derivado de Core API.
// - Sin magic strings de roles ni mapeos legacy.
// - Reactividad GetX (`Obx`) sobre `RegistrationController`/`SessionContext`/
//   `SessionCapabilitiesStore`/`ProviderContextStore`.
// ============================================================================
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../application/services/access/provider_context_store.dart';
import '../../../application/services/access/session_capabilities_store.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/registration_controller.dart';
import '../../controllers/session_context_controller.dart';
import '../../themes/devtools/theming_sanity_page.dart';
import '../drawer/workspace_item.dart';

/// Identifica de forma estable cada item del drawer. Mapea 1:1 con la
/// navegación canónica post-bootstrap.
enum _DrawerWorkspace {
  /// Shell del administrador de activos (Routes.home).
  assetAdmin,

  /// Shell unificado del proveedor (Routes.providerWorkspaceServices).
  provider,
}

class WorkspaceDrawer extends StatelessWidget {
  const WorkspaceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.isRegistered<SessionContextController>()
        ? Get.find<SessionContextController>()
        : null;
    final reg = Get.isRegistered<RegistrationController>()
        ? Get.find<RegistrationController>()
        : null;
    final caps = Get.isRegistered<SessionCapabilitiesStore>()
        ? Get.find<SessionCapabilitiesStore>()
        : null;
    final providerCtx = Get.isRegistered<ProviderContextStore>()
        ? Get.find<ProviderContextStore>()
        : null;

    return Drawer(
      child: SafeArea(
        child: Obx(() {
          // Reactividad: enganchar a userRx + memberships bump + capabilities + isProvider.
          final user = session?.userRx.value;
          // Toques explícitos para que Obx vuelva a construir cuando cambien.
          session?.membershipsVersion.value;
          caps?.capabilitiesRx.length;
          final isProvider = providerCtx?.isProviderRx.value ?? false;
          final fromUser = user != null;

          // Items canónicos derivados de capabilities + isProvider.
          final items = _resolveItems(
            fromUser: fromUser,
            caps: caps,
            isProvider: isProvider,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(fromUser: fromUser, userName: user?.name),
              if (items.isEmpty)
                const _EmptyHint()
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final ws = items[i];
                      final tile = _tileFor(ws);
                      final isActive = _isActiveRoute(ws);
                      return WorkspaceItem(
                        roleLabel: tile.title,
                        icon: tile.icon,
                        subtitle: tile.subtitle,
                        isActive: isActive,
                        onTap: () => _goTo(ws),
                      );
                    },
                  ),
                ),
              const Divider(height: 1),
              if (fromUser)
                ..._buildFooterForUser(session)
              else
                ..._buildFooterForGuest(reg),
              if (kDebugMode) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Theming Sanity Page'),
                  subtitle: const Text('Validación visual de temas (solo dev)'),
                  dense: true,
                  onTap: () {
                    Get.back();
                    Get.to(() => const ThemingSanityPage());
                  },
                ),
              ],
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Acerca de'),
                dense: true,
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Avanzza 2.0',
                    'Workspaces canónicos por capabilities + isProvider',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          );
        }),
      ),
    );
  }

  // ─── Resolución de items ───────────────────────────────────────────────────

  /// Calcula los items visibles para el caller actual.
  /// - Asset Admin: si el usuario está autenticado.
  /// - Provider: si `ProviderContextStore.isProvider == true`.
  /// En modo guest (sin user logueado), muestra sólo Asset Admin como
  /// preview (Routes.home renderiza estado vacío).
  static List<_DrawerWorkspace> _resolveItems({
    required bool fromUser,
    required SessionCapabilitiesStore? caps,
    required bool isProvider,
  }) {
    final out = <_DrawerWorkspace>[];

    // Asset admin siempre se muestra cuando hay sesión. No requiere
    // capability específica: una `Membership` ACTIVE basta para que el shell
    // de admin sea válido. Para usuarios sin sesión (guest), también lo
    // mostramos como puerta a explorar.
    out.add(_DrawerWorkspace.assetAdmin);

    // Provider sólo si Core API confirmó isProvider=true en este workspace.
    if (fromUser && isProvider) {
      out.add(_DrawerWorkspace.provider);
    }

    // Nota: aunque un usuario tenga capability `provider.create`, el item
    // "Proveedor" sólo aparece tras hacer bootstrap (isProvider=true). Para
    // iniciar el bootstrap se navega manualmente a /provider/bootstrap.
    // No se expone esa puerta desde el drawer en MF1 para evitar UX confusa.

    return out;
  }

  static bool _isActiveRoute(_DrawerWorkspace ws) {
    final current = Get.currentRoute;
    switch (ws) {
      case _DrawerWorkspace.assetAdmin:
        return current == Routes.home;
      case _DrawerWorkspace.provider:
        return current == Routes.providerWorkspaceServices ||
            current == Routes.providerWorkspaceArticles ||
            current == Routes.providerMe ||
            current == Routes.providerBootstrap;
    }
  }

  static _TileData _tileFor(_DrawerWorkspace ws) {
    switch (ws) {
      case _DrawerWorkspace.assetAdmin:
        return const _TileData(
          title: 'Administrador de activos',
          subtitle: 'Gestiona activos, incidencias y compras',
          icon: Icons.dashboard_customize_outlined,
        );
      case _DrawerWorkspace.provider:
        return const _TileData(
          title: 'Proveedor',
          subtitle: 'Solicitudes recibidas y catálogo',
          icon: Icons.handyman_outlined,
        );
    }
  }

  // ─── Navegación ────────────────────────────────────────────────────────────

  Future<void> _goTo(_DrawerWorkspace ws) async {
    // Cerrar drawer primero (evita "No Overlay widget found" en post-frame).
    try {
      Get.back();
    } catch (_) {}

    final target = switch (ws) {
      _DrawerWorkspace.assetAdmin => Routes.home,
      _DrawerWorkspace.provider => Routes.providerWorkspaceServices,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != target) {
        Get.offAllNamed(target);
      }
    });
  }

  // ─── Footers ───────────────────────────────────────────────────────────────

  List<Widget> _buildFooterForUser(SessionContextController? session) => [
        // Crear nuevo workspace / perfil. Permite al usuario autenticado
        // arrancar un nuevo onboarding (otro perfil de negocio o cambio de
        // titular). NO interfiere con el workspace activo — entra al flow
        // de selección país/ciudad y desde ahí al onboarding canónico.
        ListTile(
          leading: const Icon(Icons.add_business_outlined),
          title: const Text('Crear nuevo workspace'),
          subtitle: const Text('Iniciar un perfil/empresa adicional'),
          dense: true,
          onTap: () {
            Get.back();
            Get.toNamed(Routes.countryCity);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar sesión'),
          dense: true,
          onTap: () => _logout(session),
        ),
      ];

  List<Widget> _buildFooterForGuest(RegistrationController? reg) => [
        ListTile(
          leading: const Icon(Icons.person_add_alt_1),
          title: const Text('Registrarme'),
          dense: true,
          onTap: () {
            Get.back();
            Get.toNamed(Routes.registerUsername);
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Salir'),
          dense: true,
          onTap: () => _exitToWelcome(reg),
        ),
      ];

  Future<void> _exitToWelcome(RegistrationController? reg) async {
    if (reg != null) {
      await reg.clear('current');
    }
    Get.offAllNamed(Routes.countryCity);
  }

  Future<void> _logout(SessionContextController? session) async {
    Get.offAllNamed(Routes.countryCity);
  }
}

class _Header extends StatelessWidget {
  final bool fromUser;
  final String? userName;

  const _Header({required this.fromUser, this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitle = fromUser
        ? (userName?.isNotEmpty == true
            ? '$userName • Mis workspaces'
            : 'Mis workspaces')
        : 'Workspaces disponibles';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          if (fromUser) ...[
            CircleAvatar(
              radius: 20,
              child: Text(
                (userName?.isNotEmpty == true ? userName![0] : 'U')
                    .toUpperCase(),
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workspaces', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                size: 64,
                color: theme.hintColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Sin workspaces activos',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Completa tu registro para habilitar workspaces',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall!
                    .copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileData {
  final String title;
  final String? subtitle;
  final IconData icon;
  const _TileData({
    required this.title,
    this.subtitle,
    required this.icon,
  });
}
