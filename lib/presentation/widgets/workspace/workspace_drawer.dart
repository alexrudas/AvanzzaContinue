// lib/presentation/widgets/nav/workspace_drawer.dart
import 'package:avanzza/domain/entities/user/active_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../core/utils/workspace_normalizer.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/registration_controller.dart';
import '../../controllers/session_context_controller.dart';
import '../../themes/devtools/theming_sanity_page.dart';
import '../drawer/workspace_item.dart';
import '../modal/confirmation_dialog.dart';
import '../modal/workspace_selector_sheet.dart';

class WorkspaceDrawer extends StatelessWidget {
  const WorkspaceDrawer({super.key});

  // Helper puro testeable
  static List<String> _buildActive(List<String> source) => source
      .map((w) => w.trim())
      .where((w) => w.isNotEmpty)
      .map(WorkspaceNormalizer.normalize)
      .toSet()
      // .where(_supported.contains)
      .toList()
    ..sort(_preferredOrder);

  @override
  Widget build(BuildContext context) {
    final session = Get.isRegistered<SessionContextController>()
        ? Get.find<SessionContextController>()
        : null;
    final reg = Get.isRegistered<RegistrationController>()
        ? Get.find<RegistrationController>()
        : null;

    return Drawer(
      child: SafeArea(
        child: Obx(() {
          // Fuente reactiva: userRx + membershipsRx + bump
          final user = session?.userRx.value;
          final _ = session?.membershipsVersion.value; // engancha a versión
          final fromUser = user != null;

          // 1) Usuario logueado → workspaces desde membershipsRx
          final userWorkspaces =
              fromUser ? _extractUserWorkspaces(session!) : const <String>[];

          // 2) Registro → resolvedWorkspaces
          final resolved =
              reg?.progress.value?.resolvedWorkspaces ?? const <String>[];

          // 3) Fuente final
          final List<String> source;

          if (fromUser && userWorkspaces.isNotEmpty) {
            source = userWorkspaces;
          } else if (resolved.isNotEmpty) {
            source = resolved;
            print(
                "fromUser $fromUser && ${userWorkspaces.isNotEmpty}, resolved $resolved");
          } else {
            source = _allWorkspaces;
          }

          final active = _buildActive(source);
          print("fromUser active $active");

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                fromUser: fromUser,
                userName: user?.name,
                activeContext: user?.activeContext?.rol,
              ),
              if (active.isEmpty)
                const _EmptyHint()
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    itemCount: active.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final ws = active[i];
                      final data = _tileFor(ws);
                      final isActive = WorkspaceNormalizer.normalize(
                              user?.activeContext?.rol ?? '') ==
                          ws;
                      return WorkspaceItem(
                        roleLabel: data.title,
                        icon: data.icon,
                        subtitle: data.subtitle,
                        isActive: isActive,
                        onTap: () => _goToWorkspace(ws, session, reg),
                        onDeleted: () {
                          // Trigger rebuild after deletion
                          if (session != null) {
                            session.membershipsVersion.value++;
                          }
                        },
                      );
                    },
                  ),
                ),
              const Divider(height: 1),
              if (fromUser)
                ..._buildFooterForUser(session)
              else
                ..._buildFooterForGuest(reg),

              // === DEBUG ONLY: Theming Sanity Page ===
              // Acceso oculto a la página de validación visual del sistema de themes
              // Solo visible en modo debug (kDebugMode)
              if (kDebugMode) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Theming Sanity Page'),
                  subtitle: const Text('Validación visual de temas (solo dev)'),
                  dense: true,
                  onTap: () {
                    Get.back(); // Cerrar drawer
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
                    'Workspaces por rol — Exploración/Registro diferido',
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

  // Footer usuario autenticado
  List<Widget> _buildFooterForUser(SessionContextController? session) => [
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Agregar workspace'),
          dense: true,
          onTap: () {
            Get.back();
            Get.toNamed(Routes.profile, parameters: {'append': '1'});
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Eliminar workspace'),
          dense: true,
          onTap: () => _handleDeleteWorkspace(session, isAuthenticated: true),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar sesión'),
          dense: true,
          onTap: () => _logout(session),
        ),
      ];

  // Footer invitado
  List<Widget> _buildFooterForGuest(RegistrationController? reg) => [
        ListTile(
          leading: const Icon(Icons.person_add_alt_1),
          title: const Text('Añadir workspace'),
          dense: true,
          onTap: () {
            Get.back();
            Get.toNamed(Routes.profile, parameters: {'append': '1'});
          },
        ),
        if (reg?.progress.value?.resolvedWorkspaces.isNotEmpty ?? false)
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar workspace'),
            dense: true,
            onTap: () => _handleDeleteWorkspace(reg, isAuthenticated: false),
          ),
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

  // ---- User helpers ----
  List<String> _extractUserWorkspaces(SessionContextController session) {
    final roles = session.membershipsRx
        .where((m) => m.estatus == 'activo')
        .expand((m) => m.roles)
        .map(WorkspaceNormalizer.normalize)
        .toSet();

    final activeCtx = session.userRx.value?.activeContext;
    final ordered = [
      if ((activeCtx?.rol ?? '').isNotEmpty)
        WorkspaceNormalizer.normalize(activeCtx!.rol),
      ...roles.where(
          (r) => r != WorkspaceNormalizer.normalize(activeCtx?.rol ?? '')),
    ];
    return ordered;
  }

  // ---- Normalización y orden ----
  static const _allWorkspaces = <String>[
    'Administrador',
    'Propietario',
    'Proveedor',
    'Arrendatario',
    'Aseguradora',
    'Abogado',
    'Asesor de seguros',
  ];

  // Evita drift
  static final _supported = _allWorkspaces.toSet();

  static int _preferredOrder(String a, String b) {
    const order = {
      'Administrador': 0,
      'Propietario': 1,
      'Proveedor': 2,
      'Arrendatario': 3,
      'Aseguradora': 4,
      'Asesor de seguros': 5,
      'Abogado': 6,
    };
    return (order[a] ?? 999).compareTo(order[b] ?? 999);
  }

  _TileData _tileFor(String ws) {
    switch (ws) {
      case 'Administrador':
        return const _TileData(
          title: 'Administrador',
          subtitle: 'Gestiona activos, incidencias y compras',
          icon: Icons.dashboard_customize_outlined,
        );
      case 'Propietario':
        return const _TileData(
          title: 'Propietario',
          subtitle: 'Control de activos y documentos',
          icon: Icons.domain_outlined,
        );
      case 'Proveedor':
        return const _TileData(
          title: 'Proveedor',
          subtitle: 'Servicios y artículos',
          icon: Icons.handyman_outlined,
        );
      case 'Arrendatario':
        return const _TileData(
          title: 'Arrendatario',
          subtitle: 'Uso y reportes del activo',
          icon: Icons.directions_car_filled_outlined,
        );
      case 'Aseguradora':
        return const _TileData(
          title: 'Aseguradora / Broker',
          subtitle: 'Pólizas y renovaciones',
          icon: Icons.policy_outlined,
        );
      case 'Abogado':
        return const _TileData(
          title: 'Abogado',
          subtitle: 'Casos y reclamaciones',
          icon: Icons.balance_outlined,
        );
      case 'Asesor de seguros':
        return const _TileData(
          title: 'Asesor de seguros',
          subtitle: 'Ventas y asesoría',
          icon: Icons.support_agent_outlined,
        );
      default:
        return _TileData(title: ws, icon: Icons.apps_outlined);
    }
  }

  Future<void> _waitDrawerClose(BuildContext ctx,
      {Duration timeout = const Duration(milliseconds: 500)}) async {
    final start = DateTime.now();
    while (Scaffold.maybeOf(ctx)?.isDrawerOpen == true) {
      await SchedulerBinding.instance.endOfFrame;
      if (DateTime.now().difference(start) > timeout) break;
    }
    await SchedulerBinding.instance.endOfFrame;
  }

  Future<void> _goToWorkspace(
    String ws,
    SessionContextController? session,
    RegistrationController? reg,
  ) async {
    if (session?.userRx.value != null) {
      final membership = session!.membershipsRx.firstWhereOrNull(
        (m) => m.roles.any((r) => WorkspaceNormalizer.normalize(r) == ws),
      );

      if (membership != null) {
        final role = membership.roles
            .firstWhere((r) => WorkspaceNormalizer.normalize(r) == ws);
        String? providerType;
        if (ws == 'Proveedor' && membership.providerProfiles.isNotEmpty) {
          providerType = membership.providerProfiles.first.providerType;
        }

        final current = session.userRx.value?.activeContext;
        final nextCtx = (current == null)
            ? ActiveContext(
                orgId: membership.orgId,
                orgName: membership.orgName,
                rol: role,
                providerType: providerType,
              )
            : current.copyWith(
                orgId: membership.orgId,
                orgName: membership.orgName,
                rol: role,
                providerType: providerType,
              );

        await session.setActiveContext(nextCtx);
      }

      final ctx = Get.context;
      if (ctx != null && Scaffold.maybeOf(ctx)?.isDrawerOpen == true) {
        Navigator.of(ctx).pop();
        await _waitDrawerClose(ctx);
      } else {
        try {
          Get.back();
        } catch (_) {}
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final target =
            (ws == 'Proveedor') ? Routes.providerProfile : Routes.home;
        if (Get.currentRoute != target) {
          Get.offAllNamed(target);
        }
      });

      return;
    }

    if (reg != null) {
      await _persistExploreSelection(ws, reg);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = (ws == 'Proveedor') ? Routes.providerProfile : Routes.home;
      Get.offAllNamed(target);
    });
  }

  Future<void> _persistExploreSelection(
      String ws, RegistrationController reg) async {
    String role;
    String titularType = 'persona';
    String? providerType;

    switch (ws) {
      case 'Administrador':
        role = 'admin_activos_ind';
        break;
      case 'Propietario':
        role = 'propietario';
        break;
      case 'Arrendatario':
        role = 'arrendatario';
        break;
      case 'Proveedor':
        role = 'proveedor';
        providerType = 'servicios';
        break;
      case 'Aseguradora':
        role = 'aseguradora';
        titularType = 'empresa';
        providerType = 'articulos';
        break;
      case 'Abogado':
        role = 'abogado';
        providerType = 'servicios';
        break;
      case 'Asesor de seguros':
        role = 'asesor_seguros';
        break;
      default:
        role = ws.toLowerCase();
    }

    await reg.setTitularType(titularType);
    await reg.setRole(role);
    if (providerType != null) {
      await reg.setProviderType(providerType);
    }
  }

  Future<void> _exitToWelcome(RegistrationController? reg) async {
    if (reg != null) {
      await reg.clear('current');
    }
    Get.offAllNamed(Routes.countryCity);
  }

  /// Maneja la eliminación de un workspace
  Future<void> _handleDeleteWorkspace(
    dynamic controller, {
    required bool isAuthenticated,
  }) async {
    final context = Get.context;
    if (context == null) return;

    // Obtener lista de workspaces disponibles
    final List<String> availableWorkspaces;
    if (isAuthenticated && controller is SessionContextController) {
      availableWorkspaces = _extractUserWorkspaces(controller);
    } else if (!isAuthenticated && controller is RegistrationController) {
      availableWorkspaces = controller.progress.value?.resolvedWorkspaces ?? [];
    } else {
      return;
    }

    // Si no hay workspaces, mostrar mensaje
    if (availableWorkspaces.isEmpty) {
      Get.back(); // Cerrar drawer
      Get.snackbar(
        'Sin workspaces',
        'No tienes workspaces para eliminar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Si solo hay un workspace, no permitir eliminarlo
    if (availableWorkspaces.length == 1) {
      Get.back(); // Cerrar drawer
      Get.snackbar(
        'Workspace único',
        'Debes tener al menos un workspace activo',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.back(); // Cerrar drawer

    // Convertir a WorkspaceSelectItem
    final workspaceItems = availableWorkspaces.map((ws) {
      final data = _tileFor(ws);
      final isActive = isAuthenticated &&
          controller is SessionContextController &&
          WorkspaceNormalizer.normalize(
                  controller.userRx.value?.activeContext?.rol ?? '') ==
              ws;

      return WorkspaceSelectItem(
        label: data.title,
        subtitle: data.subtitle,
        icon: data.icon,
        isActive: isActive,
      );
    }).toList();

    // Mostrar selector de workspace
    final selected = await WorkspaceSelectorSheet.show(
      context,
      title: 'Selecciona el workspace a eliminar',
      workspaces: workspaceItems,
    );

    if (selected == null) return; // Usuario canceló

    // Mostrar confirmación
    final confirmation = await ConfirmationDialog.show(
      context,
      ConfirmationDialogConfig(
        title: '¿Eliminar workspace?',
        message:
            '¿Estás seguro de que deseas eliminar el workspace "${selected.label}"?',
        confirmText: 'Eliminar',
        cancelText: 'Cancelar',
        isDestructive: true,
        icon: Icons.delete_outline,
      ),
    );

    if (confirmation != ConfirmationResult.confirmed) return;

    // Ejecutar eliminación (los controladores manejan notificaciones y telemetría)
    try {
      if (isAuthenticated && controller is SessionContextController) {
        await controller.removeWorkspaceFromActiveOrg(role: selected.label);
      } else if (!isAuthenticated && controller is RegistrationController) {
        await controller.removeWorkspaceFromProgress(selected.label);
      }
    } catch (e) {
      // Error ya logueado por controlador, solo mostrar mensaje genérico
      Get.snackbar(
        'Error',
        'No se pudo eliminar el workspace',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _logout(SessionContextController? session) async {
    Get.offAllNamed(Routes.countryCity);
  }
}

class _Header extends StatelessWidget {
  final bool fromUser;
  final String? userName;
  final String? activeContext;

  const _Header({
    required this.fromUser,
    this.userName,
    this.activeContext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String subtitle;
    if (fromUser) {
      if (userName != null && activeContext != null) {
        subtitle = '$userName • $activeContext';
      } else if (userName != null) {
        subtitle = '$userName • Mis workspaces';
      } else {
        subtitle = 'Mis workspaces';
      }
    } else {
      subtitle = 'Workspaces disponibles';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (fromUser) ...[
                CircleAvatar(
                  radius: 20,
                  child: Text(
                    userName?.substring(0, 1).toUpperCase() ?? 'U',
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
                style:
                    theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
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
