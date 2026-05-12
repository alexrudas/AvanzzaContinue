// ============================================================================
// lib/presentation/pages/account/account_profile_page.dart
// Pantalla global /account.
//
// Es la capa visible de:
//   - identidad de cuenta (nombre, teléfono, email),
//   - acceso y seguridad (verificación + activar acceso desktop),
//   - contexto operativo (workspace activo + memberships),
//   - preferencias mínimas (tema; idioma/notificaciones reservados).
//
// REGLAS:
//   - Cero lógica de plataforma en widgets: usar PlatformCapabilities.
//   - Cero subscripciones partition-by-orgId aquí (esto es identidad global).
//   - Toda mutación pasa por AccountProfileController / DesktopAccessController.
//   - Responsive: cuerpo limitado a 720px en pantallas anchas.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/platform/platform_capabilities.dart';
import '../../../domain/entities/account/desktop_access_status.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/entities/workspace/workspace_context.dart';
import '../../../domain/entities/workspace/workspace_type.dart';
import '../../controllers/account/account_profile_controller.dart';
import '../../controllers/app_theme_controller.dart';
import 'widgets/desktop_access_setup_sheet.dart';
import 'widgets/edit_personal_data_sheet.dart';

class AccountProfilePage extends StatelessWidget {
  const AccountProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
      ),
      body: Obx(() {
        final user = controller.userRx.value;
        if (user == null) {
          return const _EmptyAccount();
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AccountHeader(
                    user: user,
                    workspace: controller.activeWorkspaceRx.value,
                  ),
                  const SizedBox(height: 8),
                  _PersonalDataSection(user: user),
                  _SecuritySection(controller: controller),
                  _OperationalContextSection(
                    workspace: controller.activeWorkspaceRx.value,
                    memberships: controller.membershipsRx,
                  ),
                  const _PreferencesSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _AccountHeader extends StatelessWidget {
  final UserEntity user;
  final WorkspaceContext? workspace;
  const _AccountHeader({required this.user, required this.workspace});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initialsFrom(user.name);
    final phoneVerified =
        FirebaseAuth.instance.currentUser?.phoneNumber != null;

    final maskedPhone = _maskPhone(user.phone);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Text(
              initials,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isEmpty ? 'Sin nombre' : user.name,
                  style: theme.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (maskedPhone != null)
                  Row(
                    children: [
                      Text(maskedPhone, style: theme.textTheme.bodyMedium),
                      if (phoneVerified) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                if (workspace != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${_workspaceLabel(workspace!.type)} · ${workspace!.orgName}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION: DATOS PERSONALES
// ─────────────────────────────────────────────────────────────────────────────

class _PersonalDataSection extends StatelessWidget {
  final UserEntity user;
  const _PersonalDataSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final email = user.email.trim().isEmpty ? 'Sin email' : user.email;
    final city = _resolveCity(user);
    return _AccountSection(
      title: 'Datos personales',
      action: _SectionActionButton(
        label: 'Editar',
        onPressed: () => openEditPersonalDataSheet(context, current: user),
      ),
      children: [
        _AccountTile(
          icon: Icons.person_outline,
          label: 'Nombre',
          value: user.name.isEmpty ? 'Sin nombre' : user.name,
        ),
        _AccountTile(
          icon: Icons.alternate_email,
          label: 'Email',
          value: email,
        ),
        if (city != null)
          _AccountTile(
            icon: Icons.location_city_outlined,
            label: 'Ciudad',
            value: city,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION: ACCESO Y SEGURIDAD
// ─────────────────────────────────────────────────────────────────────────────

class _SecuritySection extends StatelessWidget {
  final AccountProfileController controller;
  const _SecuritySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fbUser = FirebaseAuth.instance.currentUser;
    final phoneVerified = fbUser?.phoneNumber != null;

    return _AccountSection(
      title: 'Acceso y seguridad',
      children: [
        _AccountTile(
          icon: Icons.phone_iphone,
          label: 'Teléfono',
          value: phoneVerified ? 'Verificado' : 'Sin verificar',
          trailing: phoneVerified
              ? Icon(Icons.check_circle_rounded,
                  color: theme.colorScheme.primary, size: 20)
              : null,
        ),
        Obx(() {
          final loading = controller.desktopAccessLoading.value;
          final status = controller.desktopAccess.value;
          return _DesktopAccessTile(
            loading: loading,
            status: status,
            onActivate: () async {
              final newStatus = await openDesktopAccessSetupSheet(context);
              if (newStatus != null) {
                controller.desktopAccess.value = newStatus;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Acceso de escritorio activado como '
                        '"${newStatus.username ?? ''}".',
                      ),
                    ),
                  );
                }
              }
            },
          );
        }),
      ],
    );
  }
}

class _DesktopAccessTile extends StatelessWidget {
  final bool loading;
  final DesktopAccessStatus status;
  final VoidCallback onActivate;

  const _DesktopAccessTile({
    required this.loading,
    required this.status,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isConfigured = status.isConfigured;
    final value = isConfigured
        ? 'Activo · ${status.username}'
        : 'No configurado';

    Widget? trailing;
    if (loading) {
      trailing = const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (isConfigured) {
      trailing = Icon(Icons.check_circle_rounded,
          color: theme.colorScheme.primary, size: 20);
    } else {
      trailing = FilledButton.tonal(
        onPressed: onActivate,
        child: const Text('Activar'),
      );
    }

    return _AccountTile(
      icon: Icons.laptop_mac_outlined,
      label: 'Acceso para escritorio',
      value: value,
      trailing: trailing,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION: CONTEXTO OPERATIVO
// ─────────────────────────────────────────────────────────────────────────────

class _OperationalContextSection extends StatelessWidget {
  final WorkspaceContext? workspace;
  final List<MembershipEntity> memberships;
  const _OperationalContextSection({
    required this.workspace,
    required this.memberships,
  });

  @override
  Widget build(BuildContext context) {
    if (workspace == null && memberships.isEmpty) {
      return const SizedBox.shrink();
    }
    final activeOrgId = workspace?.orgId;
    final otherCount = memberships
        .where((m) => m.estatus == 'activo' && m.orgId != activeOrgId)
        .length;

    return _AccountSection(
      title: 'Contexto actual',
      children: [
        if (workspace != null) ...[
          _AccountTile(
            icon: Icons.workspaces_outline,
            label: 'Workspace activo',
            value: _workspaceLabel(workspace!.type),
          ),
          _AccountTile(
            icon: Icons.business_outlined,
            label: 'Organización',
            value: workspace!.orgName,
          ),
        ],
        if (otherCount > 0)
          _AccountTile(
            icon: Icons.swap_horiz_rounded,
            label: 'Otros contextos',
            value: otherCount == 1
                ? '1 workspace adicional'
                : '$otherCount workspaces adicionales',
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION: PREFERENCIAS
// ─────────────────────────────────────────────────────────────────────────────

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTheme = Get.isRegistered<AppThemeController>();

    return _AccountSection(
      title: 'Preferencias',
      children: [
        if (hasTheme)
          Obx(() {
            final ctrl = Get.find<AppThemeController>();
            return _AccountTile(
              icon: Icons.color_lens_outlined,
              label: 'Tema',
              value: _themeLabel(ctrl.themeMode.value),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _openThemePicker(context, ctrl),
            );
          })
        else
          const _AccountTile(
            icon: Icons.color_lens_outlined,
            label: 'Tema',
            value: 'Sistema',
          ),
        _AccountTile(
          icon: Icons.translate_rounded,
          label: 'Idioma',
          value: 'Español (CO)',
          trailing: Text(
            'Próximamente',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.hintColor),
          ),
        ),
        _AccountTile(
          icon: Icons.notifications_none_rounded,
          label: 'Notificaciones',
          value: PlatformCapabilities.supportsPushNotifications
              ? 'Configuración por defecto'
              : 'No disponible en escritorio',
          trailing: Text(
            'Próximamente',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.hintColor),
          ),
        ),
      ],
    );
  }
}

Future<void> _openThemePicker(
  BuildContext context,
  AppThemeController ctrl,
) async {
  final current = ctrl.themeMode.value;
  final selected = await showModalBottomSheet<ThemeMode>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in ThemeMode.values)
              ListTile(
                title: Text(_themeLabel(mode)),
                trailing: mode == current
                    ? Icon(Icons.check_rounded,
                        color: theme.colorScheme.primary)
                    : null,
                onTap: () => Navigator.of(ctx).pop(mode),
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
  if (selected != null) {
    await ctrl.setThemeMode(selected);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE BUILDING BLOCKS
// ─────────────────────────────────────────────────────────────────────────────

class _AccountSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? action;
  const _AccountSection({
    required this.title,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.hintColor,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.4),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      indent: 52,
                      color: theme.dividerColor.withValues(alpha: 0.4),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _SectionActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _AccountTile({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.hintColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyAccount extends StatelessWidget {
  const _EmptyAccount();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline,
                size: 64, color: theme.hintColor.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('Aún no has iniciado sesión',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Regístrate o inicia sesión para gestionar tu cuenta.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

String _initialsFrom(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'U';
  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.characters.first.toUpperCase();
  }
  return (parts.first.characters.first + parts.last.characters.first)
      .toUpperCase();
}

String? _maskPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) return null;
  final s = phone.trim();
  if (s.length <= 4) return s;
  return '${s.substring(0, s.length - 4).replaceAll(RegExp(r'\d'), '•')}${s.substring(s.length - 4)}';
}

String? _resolveCity(UserEntity user) {
  final addr = user.addresses;
  if (addr == null || addr.isEmpty) return null;
  final cityId = addr.first.cityId;
  if (cityId == null || cityId.trim().isEmpty) return null;
  return cityId;
}

String _workspaceLabel(WorkspaceType type) {
  switch (type) {
    case WorkspaceType.assetAdmin:
      return 'Administrador de activos';
    case WorkspaceType.owner:
      return 'Propietario';
    case WorkspaceType.renter:
      return 'Arrendatario';
    case WorkspaceType.workshop:
      return 'Proveedor de servicios';
    case WorkspaceType.supplier:
      return 'Proveedor de artículos';
    case WorkspaceType.insurer:
      return 'Aseguradora / Broker';
    case WorkspaceType.legal:
      return 'Jurídico';
    case WorkspaceType.advisor:
      return 'Asesor';
    case WorkspaceType.unknown:
      return 'Sin contexto';
  }
}

String _themeLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return 'Sistema';
    case ThemeMode.light:
      return 'Claro';
    case ThemeMode.dark:
      return 'Oscuro';
  }
}
