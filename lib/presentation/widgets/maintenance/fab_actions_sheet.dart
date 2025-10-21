import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modal bottom sheet con acciones disponibles para mantenimientos
///
/// Opciones:
/// - 🧰 Registrar incidencia
/// - 🗓️ Programar mantenimiento
/// - ⚡ Registrar mantenimiento urgente
/// - 📜 Buscar historial
class FabActionsSheet {
  /// Muestra el modal de acciones
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FabActionsContent(),
    );
  }
}

class _FabActionsContent extends StatelessWidget {
  const _FabActionsContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seleccione una opción',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Opciones
          _ActionTile(
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBgColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
            title: 'Registrar incidencia',
            subtitle: 'Reportar falla o problema urgente',
            onTap: () {
              Navigator.pop(context);
              Get.snackbar(
                'Incidencia',
                'Abriendo formulario de incidencia...',
                snackPosition: SnackPosition.BOTTOM,
              );
              // TODO: Navegar a formulario de incidencia
            },
          ),

          _ActionTile(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF2563EB),
            iconBgColor: const Color(0xFF2563EB).withValues(alpha: 0.1),
            title: 'Programar mantenimiento',
            subtitle: 'Agendar mantenimiento preventivo',
            onTap: () {
              Navigator.pop(context);
              Get.snackbar(
                'Programar',
                'Abriendo calendario...',
                snackPosition: SnackPosition.BOTTOM,
              );
              // TODO: Navegar a programación
            },
          ),

          _ActionTile(
            icon: Icons.flash_on_rounded,
            iconColor: const Color(0xFFF97316),
            iconBgColor: const Color(0xFFF97316).withValues(alpha: 0.1),
            title: 'Mantenimiento urgente',
            subtitle: 'Registro y asignación inmediata',
            onTap: () {
              Navigator.pop(context);
              Get.snackbar(
                'Urgente',
                'Abriendo formulario urgente...',
                snackPosition: SnackPosition.BOTTOM,
              );
              // TODO: Navegar a mantenimiento urgente
            },
          ),

          _ActionTile(
            icon: Icons.history_rounded,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFF10B981).withValues(alpha: 0.1),
            title: 'Buscar historial',
            subtitle: 'Ver mantenimientos anteriores',
            onTap: () {
              Navigator.pop(context);
              Get.snackbar(
                'Historial',
                'Abriendo búsqueda avanzada...',
                snackPosition: SnackPosition.BOTTOM,
              );
              // TODO: Navegar a búsqueda de historial
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // Icono
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Flecha
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

/// FAB extendido personalizado para mantenimientos
///
/// Muestra un FAB naranja (#F97316) con label "Nueva acción"
/// Al presionar, abre el modal FabActionsSheet
///
/// Uso:
/// ```dart
/// floatingActionButton: const MaintenanceFAB()
/// // Or with custom heroTag:
/// floatingActionButton: const MaintenanceFAB(heroTag: 'adminMaintFab')
/// ```
class MaintenanceFAB extends StatelessWidget {
  /// Tag único para Hero animation. Si no se especifica, usa 'maintenance_fab'
  final String? heroTag;

  const MaintenanceFAB({
    super.key,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75, // translucidez del FAB
      child: FloatingActionButton.extended(
        heroTag: heroTag ?? 'maintenance_fab',
        onPressed: () => FabActionsSheet.show(context), // hoja de acciones
        backgroundColor: const Color(0xFFF97316), // naranja marca
        foregroundColor: Colors.white,
        elevation: 2, // sombra ligera
        icon: const Icon(Icons.add_rounded),
        label: const Text('Acciones',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
