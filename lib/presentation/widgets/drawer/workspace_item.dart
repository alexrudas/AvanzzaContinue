import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../auth/controllers/registration_controller.dart';
import '../../controllers/session_context_controller.dart';

/// Item de workspace con soporte de long-press para borrar
class WorkspaceItem extends StatefulWidget {
  final String roleLabel; // Ej: 'Proveedor', 'Administrador'
  final IconData icon; // Ícono del workspace
  final String? subtitle; // Descripción del workspace
  final bool isActive; // Si está activo/seleccionado
  final VoidCallback? onTap; // Acción normal (navegar/cambiar)
  final VoidCallback? onDeleted; // Notificar borrado al padre

  const WorkspaceItem({
    super.key,
    required this.roleLabel,
    required this.icon,
    this.subtitle,
    this.isActive = false,
    this.onTap,
    this.onDeleted,
  });

  @override
  State<WorkspaceItem> createState() => _WorkspaceItemState();
}

class _WorkspaceItemState extends State<WorkspaceItem> {
  bool _pendingDelete = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg =
        _pendingDelete ? theme.colorScheme.errorContainer : Colors.transparent;
    final fg = _pendingDelete
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onSurface;

    return GestureDetector(
      onLongPressStart: (_) {
        HapticFeedback.selectionClick();
        setState(() => _pendingDelete = true);
      },
      onLongPressEnd: (_) async {
        HapticFeedback.lightImpact();
        setState(() => _pendingDelete = false);
        final ok = await _confirmDelete(context, widget.roleLabel);
        if (ok == true) {
          await _deleteWorkspace(context, widget.roleLabel);
          widget.onDeleted?.call();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: _pendingDelete ? fg : null,
          ),
          title: Text(
            widget.roleLabel,
            style: TextStyle(color: fg),
          ),
          subtitle: widget.subtitle == null
              ? null
              : Text(
                  widget.subtitle!,
                  style: TextStyle(color: fg.withValues(alpha: 0.7)),
                ),
          trailing: widget.isActive && !_pendingDelete
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : Icon(Icons.chevron_right, color: fg),
          selected: widget.isActive,
          onTap: widget.onTap,
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String label) {
    HapticFeedback.mediumImpact();
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Borrar workspace'),
        content: Text('¿Deseas borrar el workspace "$label"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWorkspace(BuildContext context, String roleLabel) async {
    try {
      if (Get.isRegistered<SessionContextController>() &&
          Get.find<SessionContextController>().user != null) {
        // Modo autenticado: borrar del membership activo
        await Get.find<SessionContextController>()
            .removeWorkspaceFromActiveOrg(role: roleLabel);
      } else if (Get.isRegistered<RegistrationController>()) {
        // Modo registro: eliminar del progress
        final reg = Get.find<RegistrationController>();
        final p = reg.progress.value ?? await reg.progressDS.get('current');
        if (p != null) {
          final norm = roleLabel.trim().toLowerCase();
          // Filtrar listas existentes directamente en el modelo
          p.resolvedWorkspaces = (p.resolvedWorkspaces)
              .where((w) => w.trim().toLowerCase() != norm)
              .toList();
          p.resolvedRoles = (p.resolvedRoles)
              .where((r) => r.trim().toLowerCase() != norm)
              .toList();
          // Persistir cambios
          await reg.progressDS.upsert(p);
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Workspace eliminado')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el workspace')));
      }
    }
  }
}
