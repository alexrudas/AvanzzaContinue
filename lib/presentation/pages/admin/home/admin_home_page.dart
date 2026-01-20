import 'dart:ui';

import 'package:avanzza/core/utils/workspace_normalizer.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:avanzza/domain/entities/user/active_context.dart';
import 'package:avanzza/presentation/controllers/session_context_controller.dart';
import 'package:avanzza/presentation/pages/admin/home/ai_alerts_page.dart';
import 'package:avanzza/presentation/pages/portfolio/wizard/create_portfolio_step1_page.dart';
import 'package:avanzza/presentation/widgets/ai_banner/ai_banner.dart';
import 'package:avanzza/presentation/widgets/modal/action_sheet_pro.dart';
import 'package:avanzza/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ============================================================================
// 1. DESIGN SYSTEM (Premium Light Theme)
// ============================================================================
class AssetDesignSystemLight {
  // Fondos claros
  static const Color background = Color(0xFFF2F4F8); // Gris perla suave
  static const Color surface = Color(0xFFFFFFFF); // Blanco puro

  // Acentos
  static const Color accentStart = Color(0xFF4F5CFF); // Azul Eléctrico
  static const Color accentEnd = Color(0xFF8E54E9); // Violeta

  // Textos
  static const Color textPrimary = Color(0xFF1A1D26); // Casi negro
  static const Color textSecondary = Color(0xFF8F9BB3); // Gris medio

  // Estados
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF3D00);
  static const Color warning = Color(0xFFFFAB00); // Ámbar

  // Paleta "Mi red operativa" - VIBRANT (color-blind safe)
  static const Color networkOwners =
      Color(0xFF2563EB); // Azul Royal – Propietarios
  static const Color networkTenants =
      Color(0xFF059669); // Verde Esmeralda – Arrendatarios
  static const Color networkContacts =
      Color(0xFFF59E0B); // Ámbar (Naranja) – Contactos

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [accentStart, accentEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get glassGradient => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: .8),
          Colors.white.withValues(alpha: .5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static List<BoxShadow> get softShadow => [
        // Sombra corta (cerca del componente)
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
        // Sombra larga (ambient)
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static TextStyle get headerStyle => const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      color: textPrimary,
      letterSpacing: -0.8);
}

// ============================================================================
// 2. PAGE: AdminHomePage (Solo contenido, con FAB)
// ============================================================================
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Stack(
      children: [
        // --- FONDO AMBIENTAL ---
        Positioned(
          top: -50,
          right: -100,
          child: _AmbientLight(
              color: AssetDesignSystemLight.accentStart.withValues(alpha: .1)),
        ),
        Positioned(
          top: 300,
          left: -100,
          child: _AmbientLight(
              color: AssetDesignSystemLight.accentEnd.withValues(alpha: .1)),
        ),

        // --- CONTENIDO SCROLLABLE ---
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 0),
              const _QuickActionsRow(),
              const SizedBox(height: 26),
              _SectionTitle(
                  title: "Atención Requerida",
                  trailing: _NotificationBadge(
                      count: _getHighPriorityCount(_adminAlerts))),
              const SizedBox(height: 14),
              AIBanner(
                messages: _adminAlerts,
                showHeader: false,
                rotationInterval: const Duration(seconds: 6),
                onTap: () {
                  Get.to(() => AiAlertsPage(messages: _adminAlerts));
                },
              ),
              const SizedBox(height: 26),
              const _SectionTitle(title: "Portafolio de negocio"),
              const SizedBox(height: 14),
              const _AssetCategoryCard(
                title: "Vehículos",
                subtitle: "8 Unidades • 2 En mantenimiento",
                value: "\$ 35.M",
                icon: Icons.directions_car_filled_rounded,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              const _AssetCategoryCard(
                title: "Inmuebles",
                subtitle: "3 Propiedades • 100% Ocupación",
                value: "\$ 8.3M",
                icon: Icons.apartment_rounded,
                color: Colors.orange,
              ),
              const SizedBox(height: 26),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(
                    title: "Mi red operativa",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Actores vinculados a mi operación",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AssetDesignSystemLight.textSecondary,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _PersonasDashboard(),
              const SizedBox(height: 80), // Espacio para el FAB
            ],
          ),
        ),

        // --- FAB ---
        const Positioned(
          bottom: 16,
          right: 16,
          child: _PremiumFAB(),
        ),
      ],
    );
  }
}

// ============================================================================
// 3. COMPONENTES
// ============================================================================

// ============================================================================
// PREMIUM FAB - Botón flotante para "Nuevo Activo"
// ============================================================================
class _PremiumFAB extends StatelessWidget {
  const _PremiumFAB();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 0), // Espacio para la nav bar flotante
      child: Container(
        decoration: BoxDecoration(
          gradient: AssetDesignSystemLight.primaryGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AssetDesignSystemLight.accentStart.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AssetDesignSystemLight.accentStart.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () async {
              HapticFeedback.mediumImpact();

              // Nuevo: Abrir sheet de operación (portafolio primero)
              showFabNewOperationSheet(context);
            },
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Nuevo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header Enterprise: Contexto operativo sin ruido técnico
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  /// Obtiene el saludo según la hora local
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  /// Obtiene la fecha abreviada (ej: "Lun, 5 Ene")
  String _getShortDate() {
    final now = DateTime.now();
    final weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];

    final weekday = weekdays[now.weekday - 1];
    final day = now.day;
    final month = months[now.month - 1];

    return '$weekday, $day $month';
  }

  /// Extrae el primer nombre del usuario con capitalización correcta
  String _getFirstName() {
    try {
      final session = Get.find<SessionContextController>();
      final fullName = session.user?.name ?? '';

      if (fullName.isEmpty) {
        return 'Usuario';
      }

      // Extraer primer nombre + remover dobles espacios
      final firstName =
          fullName.trim().replaceAll(RegExp(r'\s+'), ' ').split(' ').first;

      if (firstName.isEmpty) {
        return 'Usuario';
      }

      // Capitalización correcta: "ALEXANDER" → "Alexander"
      return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
    } catch (e) {
      return 'Usuario';
    }
  }

  /// Abre modal de selección de workspace
  void _showWorkspaceSelector(BuildContext context, String currentWorkspace,
      List<String> availableRoles) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _WorkspaceSelectorModal(
        currentWorkspace: currentWorkspace,
        availableRoles: availableRoles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = _getGreeting();
    final shortDate = _getShortDate();
    final firstName = _getFirstName();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FILA 1: Contexto temporal (secundaria)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                greeting,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AssetDesignSystemLight.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                shortDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AssetDesignSystemLight.accentEnd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 0),

          // FILA 2: Identidad + Workspace (principal) - REACTIVO
          Obx(() {
            try {
              final session = Get.find<SessionContextController>();
              final activeWorkspace =
                  session.user?.activeContext?.rol ?? 'Workspace';
              final availableRoles = session.memberships
                  .where((m) => m.estatus == 'activo')
                  .expand((m) => m.roles)
                  .toSet()
                  .toList();
              final hasMultipleWorkspaces = availableRoles.length > 1;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Primer nombre (protagonista)
                  Text(
                    firstName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      color: AssetDesignSystemLight.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Workspace chip (discreta) - Dinámico + chevron condicional
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: hasMultipleWorkspaces
                          ? () {
                              HapticFeedback.lightImpact();
                              _showWorkspaceSelector(
                                  context, activeWorkspace, availableRoles);
                            }
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AssetDesignSystemLight.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              activeWorkspace,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AssetDesignSystemLight.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (hasMultipleWorkspaces) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: AssetDesignSystemLight.textSecondary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } catch (e) {
              // Fallback si falla GetX
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    firstName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      color: AssetDesignSystemLight.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    height: 30,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AssetDesignSystemLight.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Workspace',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AssetDesignSystemLight.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatusLegend(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: .4), blurRadius: 4)
              ]),
        ),
        const SizedBox(width: 6),
        Text(count,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: .5), fontSize: 12)),
      ],
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // 1. GPS - Control Operativo (azul suave)
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.map_outlined,
            label: "GPS",
            semanticLabel: "Abrir GPS para control operativo",
            iconColor: const Color(0xFF3B82F6), // Azul suave para monitoreo
            onTap: () {
              // TODO: Navegar a GPS
              HapticFeedback.mediumImpact();
            },
          ),
        ),

        // 2. Publicar - Activación Comercial (primary)
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.campaign_outlined,
            label: "Publicar",
            semanticLabel: "Publicar activos disponibles",
            iconColor: theme.colorScheme.primary,
            onTap: () {
              // TODO: Navegar a Publicar
              HapticFeedback.mediumImpact();
            },
          ),
        ),

        // 3. Solicitudes - Gestión (gris oscuro / azul neutro)
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.assignment_turned_in_outlined,
            label: "Solicitudes",
            semanticLabel: "Ver y gestionar solicitudes",
            iconColor: AssetDesignSystemLight.textPrimary,
            onTap: () {
              // TODO: Navegar a Solicitudes
              HapticFeedback.mediumImpact();
            },
          ),
        ),

        // 4. Emergencias - Seguridad Crítica (error)
        Expanded(
          child: _QuickActionBtn(
            icon: Icons.sos,
            label: "Emergencias",
            semanticLabel: "Acceder a emergencias críticas",
            iconColor: theme.colorScheme.error,
            isEmergency: true,
            onTap: () {
              // TODO: Acción crítica de emergencias
              HapticFeedback.heavyImpact();
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String semanticLabel;
  final Color iconColor;
  final bool isEmergency;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.iconColor,
    required this.onTap,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          highlightColor: isEmergency
              ? theme.colorScheme.error.withValues(alpha: 0.12)
              : null,
          splashColor: isEmergency
              ? theme.colorScheme.error.withValues(alpha: 0.12)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            constraints: const BoxConstraints(minHeight: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Contenedor del icono
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isEmergency
                            ? theme.colorScheme.error.withValues(alpha: 0.07)
                            : AssetDesignSystemLight.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isEmergency
                              ? theme.colorScheme.error.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.10),
                          width: 1,
                        ),
                        boxShadow: AssetDesignSystemLight.softShadow,
                      ),
                      child: Icon(
                        icon,
                        size: 28,
                        color: iconColor,
                      ),
                    ),
                    // Micro-badge para emergencias
                    if (isEmergency)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AssetDesignSystemLight.background,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // Label
                Text(
                  label,
                  style: const TextStyle(
                    color: AssetDesignSystemLight.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventosPorRevisarTileLight extends StatelessWidget {
  const _EventosPorRevisarTileLight();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AssetDesignSystemLight.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            HapticFeedback.mediumImpact();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AssetDesignSystemLight.warning.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.notifications_active_rounded,
                      color: AssetDesignSystemLight.warning, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("3 Eventos Críticos",
                              style: TextStyle(
                                  color: AssetDesignSystemLight.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AssetDesignSystemLight.error),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "SOAT vencido y 2 mantenimientos.",
                        style: TextStyle(
                            color: AssetDesignSystemLight.textSecondary,
                            fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final Color color;

  const _AssetCategoryCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AssetDesignSystemLight.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: AssetDesignSystemLight.textSecondary,
                        fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: AssetDesignSystemLight.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.trending_up_rounded,
                      size: 14, color: AssetDesignSystemLight.success),
                  SizedBox(width: 2),
                  Text("2.4%",
                      style: TextStyle(
                          color: AssetDesignSystemLight.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _AmbientLight extends StatelessWidget {
  final Color color;
  const _AmbientLight({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: AssetDesignSystemLight.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w800)),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;
  const _NotificationBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AssetDesignSystemLight.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text("$count Pendientes",
          style: const TextStyle(
              color: AssetDesignSystemLight.error,
              fontSize: 11,
              fontWeight: FontWeight.bold)),
    );
  }
}

// ============================================================================
// PERSONAS DASHBOARD - Fila fija de 3 accesos directos (sin scroll, sin insights)
// ============================================================================
class _PersonasDashboard extends StatelessWidget {
  const _PersonasDashboard();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OperationalNetwork(
            icon: Icons.person_outline_rounded,
            borderColor: AssetDesignSystemLight.networkOwners,
            title: 'Propietarios',
            subtitle: '12 registrados',
            onTap: () => _handlePersonaTap(context, 'Propietarios'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OperationalNetwork(
            icon: Icons.home_outlined,
            borderColor: AssetDesignSystemLight.networkTenants,
            title: 'Arrendatarios',
            subtitle: '8 activos',
            onTap: () => _handlePersonaTap(context, 'Arrendatarios'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OperationalNetwork(
            icon: Icons.contacts_outlined,
            borderColor: AssetDesignSystemLight.networkContacts,
            title: 'Directorio',
            subtitle: '24 contactos',
            onTap: () => _handleDirectorioTap(context),
          ),
        ),
      ],
    );
  }

  static void _handlePersonaTap(BuildContext context, String tipo) {
    // TODO: Reemplazar con navegación real cuando existan las rutas
    // Ejemplo: Get.toNamed(Routes.propietarios);
    Get.snackbar(
      'Próximamente',
      'Módulo de $tipo en construcción',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          AssetDesignSystemLight.accentStart.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void _handleDirectorioTap(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mi red operativa',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        Text(
                          'Agrega miembros a tu red operativa',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),

                  // Opciones
                  _DirectoryOption(
                    icon: Icons.store_rounded,
                    title: 'Proveedores',
                    subtitle: 'Suministro de productos o insumos',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navegar a Proveedores
                    },
                  ),
                  _DirectoryOption(
                    icon: Icons.engineering_rounded,
                    title: 'Técnicos',
                    subtitle: 'Personal de mantenimiento',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navegar a Técnicos
                    },
                  ),
                  _DirectoryOption(
                    icon: Icons.business_rounded,
                    title: 'Oficina',
                    subtitle: 'Equipo administrativo',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navegar a Oficina
                    },
                  ),
                  _DirectoryOption(
                    icon: Icons.gavel_rounded,
                    title: 'Abogado',
                    subtitle: 'Asesoría legal',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navegar a Abogado
                    },
                  ),

                  _DirectoryOption(
                    icon: Icons.folder_shared_rounded,
                    title: 'Otros',
                    subtitle: 'Contactos adicionales',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navegar a Otros
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// DIRECTORY OPTION - Item del modal de Directorio
// ============================================================================
class _DirectoryOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DirectoryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cs.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// RED DE CONTACTOS CARD - Tarjeta individual (acceso directo sin insights)
// ============================================================================
/// Enterprise Network Card - Estilo profesional con borde semántico
class _OperationalNetwork extends StatelessWidget {
  final IconData icon;
  final Color borderColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OperationalNetwork({
    required this.icon,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícono con fondo neutro
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: borderColor,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),

                // Título
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AssetDesignSystemLight.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),

                // Subtítulo
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AssetDesignSystemLight.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SEED DATA - Alertas IA para Admin
// ============================================================================
final _adminAlerts = <AIBannerMessage>[
  // CRÍTICAS
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.block_rounded,
    title: 'SOAT vencido - ABC123',
    subtitle: 'Sin cobertura. Evita sanciones, renueva ya',
    domain: AIAlertDomain.legal,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.assignment_late_rounded,
    title: 'Contrato vencido - Local Centro',
    subtitle: 'Sin vigencia desde 15/Dic. Regulariza el estado',
    domain: AIAlertDomain.legal,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.attach_money_rounded,
    title: '3 Arrendatarios en mora - \$2.4M',
    subtitle: 'Mora acumulada por más de 60 días',
    domain: AIAlertDomain.financiero,
  ),

  // ALTAS
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.receipt_long_rounded,
    title: 'SOAT por vencer - XYZ789',
    subtitle: 'Vence el 15/Ene. Renueva antes',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.build_circle_rounded,
    title: 'RTM próxima a vencer - 2 vehículos',
    subtitle: 'Agenda la inspección antes del 20/Ene',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.gavel_rounded,
    title: 'Multas activas - 3 vehículos',
    subtitle: 'Revisa comparendos y evita intereses',
    domain: AIAlertDomain.multas,
  ),

  // MEDIAS
  AIBannerMessage(
    type: AIMessageType.info,
    icon: Icons.event_busy_rounded,
    title: '2 Contratos por vencer - 30 días',
    subtitle: 'Decide renovar o terminar',
    domain: AIAlertDomain.comercial,
  ),
  AIBannerMessage(
    type: AIMessageType.info,
    icon: Icons.engineering_rounded,
    title: 'Mantenimientos programados - 5 activos',
    subtitle: 'Próximos 15 días',
    domain: AIAlertDomain.operativo,
  ),

  // OPORTUNIDADES
  AIBannerMessage(
    type: AIMessageType.success,
    icon: Icons.trending_up_rounded,
    title: 'Ocupación 100% - Inmuebles',
    subtitle: 'Todos los espacios arrendados',
    domain: AIAlertDomain.comercial,
  ),
  AIBannerMessage(
    type: AIMessageType.success,
    icon: Icons.verified_rounded,
    title: 'Sin multas registradas - Flota',
    subtitle: 'Buen comportamiento vial este mes',
    domain: AIAlertDomain.multas,
  ),
];

/// Helper: Cuenta alertas CRÍTICA + ALTA
int _getHighPriorityCount(List<AIBannerMessage> alerts) {
  return alerts
      .where((a) =>
          a.priority == AIAlertPriority.critica ||
          a.priority == AIAlertPriority.alta)
      .length;
}

// ============================================================================
// WORKSPACE SELECTOR MODAL - Modal PRO 2026 para cambiar workspace
// ============================================================================
/// Modal PRO 2026 para selección de workspace
class _WorkspaceSelectorModal extends StatefulWidget {
  final String currentWorkspace;
  final List<String> availableRoles;

  const _WorkspaceSelectorModal({
    required this.currentWorkspace,
    required this.availableRoles,
  });

  @override
  State<_WorkspaceSelectorModal> createState() =>
      _WorkspaceSelectorModalState();
}

class _WorkspaceSelectorModalState extends State<_WorkspaceSelectorModal> {
  late String _selectedWorkspace;

  @override
  void initState() {
    super.initState();
    _selectedWorkspace = widget.currentWorkspace;
  }

  Future<void> _handleChange() async {
    if (_selectedWorkspace == widget.currentWorkspace) {
      Navigator.of(context).pop();
      return;
    }

    try {
      final session = Get.find<SessionContextController>();
      final user = session.user;
      if (user == null) return;

      // Buscar membership que contiene el rol seleccionado
      final targetMembership = session.memberships.firstWhereOrNull(
        (m) => m.roles
            .any((r) => WorkspaceNormalizer.areEqual(r, _selectedWorkspace)),
      );

      if (targetMembership != null) {
        final newContext = ActiveContext(
          orgId: targetMembership.orgId,
          orgName: targetMembership.orgName,
          rol: _selectedWorkspace,
          providerType: user.activeContext?.providerType,
        );

        await session.setActiveContext(newContext);

        if (mounted) {
          Navigator.of(context).pop();

          // Navegar a HomeRouter para que redirija al workspace correcto
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.home);
          });
        }
      }
    } catch (e) {
      debugPrint('[WorkspaceSelector] Error changing workspace: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Título
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cambiar espacio de trabajo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AssetDesignSystemLight.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Selecciona uno para continuar',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AssetDesignSystemLight.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 24),

            // Lista de workspaces
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: widget.availableRoles.map((role) {
                    final isSelected = _selectedWorkspace == role;
                    final isCurrent = role == widget.currentWorkspace;

                    return RadioListTile<String>(
                      value: role,
                      groupValue: _selectedWorkspace,
                      onChanged: (value) {
                        if (value != null) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedWorkspace = value);
                        }
                      },
                      title: Row(
                        children: [
                          Text(
                            role,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: AssetDesignSystemLight.textPrimary,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Actual',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      activeColor: cs.primary,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(height: 24),

            // Botones CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  // Cancelar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                            color: Colors.black.withValues(alpha: 0.15)),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: AssetDesignSystemLight.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Cambiar
                  Expanded(
                    child: FilledButton(
                      onPressed: _handleChange,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: cs.primary,
                      ),
                      child: const Text(
                        'Cambiar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FAB MENU - Menú de categorías (Nivel 1)
// ============================================================================
/// Modal bottom sheet para FAB "Nuevo"
/// Diseño de 2 niveles:
/// - Nivel 1: Categorías (Portafolio, Activos, Finanzas, Operación, Red operativa)
/// - Nivel 2: Submenús por categoría
///
/// REGLA DURA: Sin portafolio ACTIVE (assetsCount >= 1) NO hay operación
/// - Portafolio: Siempre habilitado (única categoría sin gating)
/// - Activos/Finanzas/Operación: Requieren portfolio ACTIVE
/// - Red operativa: Siempre habilitado (gestión de usuarios/equipos)
Future<void> showFabNewOperationSheet(BuildContext context) async {
  // TODO: Obtener hasActivePortfolio del estado (PortfolioRepository)
  // Por ahora, asumir false (sin portfolios ACTIVE)
  const hasActivePortfolio = false;

  // Capturar el contexto raíz ANTES de abrir cualquier sheet
  // Este contexto permanece válido incluso después de cerrar sheets
  final rootContext = Get.context!;

  await ActionSheetPro.show(
    context,
    title: 'Nuevo',
    data: [
      ActionSection(
        items: [
          // Categoría 1: Portafolio (siempre habilitado)
          ActionItem(
            label: 'Portafolio',
            subtitle: 'Crea tu portafolio de negocio',
            icon: Icons.folder_rounded,
            onTap: () {
              Get.back(); // Cerrar Nivel 1 (GetX maneja el navigator)
              // Abrir Menú 2 en el siguiente frame (evita apilar sheets)
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showPortfolioSubmenu(rootContext);
              });
            },
          ),

          // Categoría 2: Activos (requiere portfolio ACTIVE)
          ActionItem(
            label: 'Activos',
            subtitle: 'Agrega vehículos, inmuebles, maquinaria a tu portafolio',
            icon: Icons.directions_car_rounded,
            enabled: hasActivePortfolio,
            onTap: () {
              // ignore: dead_code
              if (hasActivePortfolio) {
              } else {
                Get.snackbar(
                  'Bloqueado',
                  'Primero crea un portafolio con al menos un activo',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange.shade100,
                  icon: const Icon(Icons.lock_outline, color: Colors.orange),
                );
              }
            },
          ),

          // Categoría 3: Finanzas (requiere portfolio ACTIVE)
          ActionItem(
            label: 'Finanzas',
            subtitle: 'Registrar ingresos, gastos, cuentas por cobrar',
            icon: Icons.attach_money_rounded,
            enabled: hasActivePortfolio,
            onTap: () {
              if (hasActivePortfolio) {
                Get.back(); // Cerrar Nivel 1
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showFinanzasSubmenu(rootContext);
                });
              } else {
                Get.snackbar(
                  'Bloqueado',
                  'Primero crea un portafolio con al menos un activo',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange.shade100,
                  icon: const Icon(Icons.lock_outline, color: Colors.orange),
                );
              }
            },
          ),

          // Categoría 4: Operación (requiere portfolio ACTIVE)
          ActionItem(
            label: 'Operación',
            subtitle: 'Agrega Incidencias, mantenimientos, documentos y más',
            icon: Icons.route_rounded,
            enabled: hasActivePortfolio,
            onTap: () {
              if (hasActivePortfolio) {
                Get.back(); // Cerrar Nivel 1
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showOperacionSubmenu(rootContext);
                });
              } else {
                Get.snackbar(
                  'Bloqueado',
                  'Primero crea un portafolio con al menos un activo',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange.shade100,
                  icon: const Icon(Icons.lock_outline, color: Colors.orange),
                );
              }
            },
          ),

          // Categoría 5: Red operativa (siempre habilitado)
          ActionItem(
            label: 'Red operativa',
            subtitle:
                'Agrega propietarios, arrendatarios, proveedores, técnicos y más.',
            icon: Icons.people_rounded,
            onTap: () {
              Get.back(); // Cerrar Nivel 1
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showRedOperativaSubmenu(rootContext);
              });
            },
          ),
        ],
      ),
    ],
  );
}

// NIVEL 2: Submenús por categoría
// ============================================================================

/// Submenú: Portafolio - Selección de tipo
/// Menú 2: SOLO para crear portafolio (Vehículos o Inmuebles)
void _showPortfolioSubmenu(BuildContext context) {
  ActionSheetPro.show(
    context,
    title: 'Portafolio',
    data: [
      ActionSection(
        header: 'Selecciona una opción para crear tu portafolio.',
        items: [
          // Opción 1: Crear portafolio de Vehículos
          ActionItem(
            label: 'Vehículos',
            subtitle: 'Crea un portafolio para gestionar vehículos',
            icon: Icons.directions_car_rounded,
            onTap: () {
              Get.back(); // Cerrar Menú 2 (GetX maneja el navigator)
              // Navegar al Wizard con preselección de tipo Vehículos
              Future.microtask(() {
                Get.to(() => const CreatePortfolioStep1Page(
                  preselectedType: PortfolioType.vehiculos,
                ));
              });
            },
          ),

          // Opción 2: Crear portafolio de Inmuebles
          ActionItem(
            label: 'Inmuebles',
            subtitle: 'Crea un portafolio para gestionar inmuebles',
            icon: Icons.apartment_rounded,
            onTap: () {
              Get.back(); // Cerrar Menú 2 (GetX maneja el navigator)
              // Navegar al Wizard con preselección de tipo Inmuebles
              Future.microtask(() {
                Get.to(() => const CreatePortfolioStep1Page(
                  preselectedType: PortfolioType.inmuebles,
                ));
              });
            },
          ),
        ],
      ),
    ],
  );
}

/// Submenú: Activos
void _showActivosSubmenu(BuildContext context) {
  ActionSheetPro.show(
    context,
    title: 'Activos',
    data: [
      ActionSection(
        header: 'Selecciona una opción para continuar.',
        items: [
          ActionItem(
            label: 'Agregar activo a portafolio',
            subtitle: 'Vehículo, inmueble, maquinaria',
            icon: Icons.add_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Integrar showAssetTypeSheet + selección de portafolio
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de agregar activo estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Ver todos los activos',
            subtitle: 'Consulta y edita activos existentes',
            icon: Icons.list_alt_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a lista de activos
                Get.snackbar(
                  'Próximamente',
                  'La lista de activos estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
        ],
      ),
    ],
  );
}

/// Submenú: Finanzas
void _showFinanzasSubmenu(BuildContext context) {
  ActionSheetPro.show(
    context,
    title: 'Finanzas',
    data: [
      ActionSection(
        header: 'Selecciona una opción para continuar.',
        items: [
          ActionItem(
            label: 'Registrar ingreso',
            subtitle: 'Arriendo, venta, otros ingresos',
            icon: Icons.trending_up_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a formulario de ingreso
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de registrar ingreso estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Registrar gasto',
            subtitle: 'Mantenimiento, seguros, servicios',
            icon: Icons.trending_down_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a formulario de gasto
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de registrar gasto estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Registrar cuenta por cobrar',
            subtitle: 'Facturas pendientes de pago',
            icon: Icons.receipt_long_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a formulario de cuenta por cobrar
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de cuentas por cobrar estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
        ],
      ),
    ],
  );
}

/// Submenú: Operación
void _showOperacionSubmenu(BuildContext context) {
  ActionSheetPro.show(
    context,
    title: 'Operación',
    data: [
      ActionSection(
        header: 'Selecciona una opción para continuar.',
        items: [
          ActionItem(
            label: 'Crear ruta',
            subtitle: 'Asignar activo a una ruta operativa',
            icon: Icons.add_road_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a formulario de ruta
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de crear ruta estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Programar mantenimiento',
            subtitle: 'Mantenimiento preventivo o correctivo',
            icon: Icons.build_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a formulario de mantenimiento
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de programar mantenimiento estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Cargar documento',
            subtitle: 'SOAT, revisión técnica, pólizas',
            icon: Icons.upload_file_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a carga de documentos
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de cargar documento estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
        ],
      ),
    ],
  );
}

/// Submenú: Red operativa
void _showRedOperativaSubmenu(BuildContext context) {
  ActionSheetPro.show(
    context,
    title: 'Red operativa',
    data: [
      ActionSection(
        header: 'Selecciona una opción para continuar.',
        items: [
          ActionItem(
            label: 'Invitar usuario',
            subtitle: 'Agregar conductor, administrador, etc.',
            icon: Icons.person_add_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a invitación de usuario
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de invitar usuario estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Crear equipo',
            subtitle: 'Organiza usuarios por equipos',
            icon: Icons.group_add_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a creación de equipo
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de crear equipo estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
          ActionItem(
            label: 'Gestionar permisos',
            subtitle: 'Roles y permisos de acceso',
            icon: Icons.admin_panel_settings_rounded,
            onTap: () {
              Get.back(); // Cerrar sheet de forma segura
              Future.microtask(() {
                // TODO: Navegar a gestión de permisos
                Get.snackbar(
                  'Próximamente',
                  'La funcionalidad de gestionar permisos estará disponible pronto',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
          ),
        ],
      ),
    ],
  );
}
