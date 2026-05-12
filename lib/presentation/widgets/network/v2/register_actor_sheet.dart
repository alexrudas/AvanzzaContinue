// ============================================================================
// lib/presentation/widgets/network/v2/register_actor_sheet.dart
// REGISTER ACTOR SHEET — FAB / empty-CTA → 2 opciones consistentes V1
// ============================================================================
// QUÉ HACE:
//   - BottomSheet con 2 opciones (V1):
//       · Proveedores de productos  →  provider_form (initialKind=product)
//       · Proveedores de servicios  →  provider_form (initialKind=service)
//   - Tras volver del form, dispara `MiRedController.loadInitial()` para
//     que el nuevo actor (si se creó) aparezca en su bucket sin que el
//     usuario tenga que recargar manualmente.
//   - Reload INCONDICIONAL al cerrar el form: cubre los tres casos
//     (success, cancel, back físico) sin estado stale.
//
// QUÉ NO HACE:
//   - No muestra opciones que no funcionen en V1 (Equipo / Asesores /
//     Legal). Cero stubs "Próximamente".
//   - No crea actores localmente; delega 100% al flujo de creación
//     existente (provider_form_page + ProviderCanonicalRepository).
//
// SAFETY:
//   - El `MiRedController` se resuelve via `Get.isRegistered<...>()` y
//     `Get.find<...>()`. Si por alguna razón el binding no está cargado,
//     el reload se omite con log de warning (no crash). En la práctica
//     V1, esta sheet solo se invoca desde MiRedPage que SÍ tiene el
//     binding cargado.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/catalog/specialty_entity.dart'
    show SpecialtyKind;
import '../../../../routes/app_routes.dart';
import '../../../controllers/network/v2/mi_red_controller.dart';
import '../../../view_models/network/v2/mi_red_labels.dart';

/// Abre el bottom sheet "Registrar actor". Retorna cuando el sheet se
/// cierra (y el flujo de creación posterior, si hubo, también terminó).
Future<void> showRegisterActorSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _RegisterActorSheet(),
  );
}

/// Abre el provider_form ya contextualizado a [kind] y dispara reload
/// incondicional de Mi Red al volver. Reutilizable desde cualquier CTA
/// que ya conozca el tipo (FAB global → sheet → aquí; "+ Agregar" de
/// sección → aquí directo, sin sheet).
///
/// El binding del form ([ProviderFormBinding]) lee `arguments['initialKind']`
/// (wire string), inicializa `offerKind` y lo deja bloqueado (`isOfferKindLocked`)
/// para evitar que el usuario cambie el tipo desde un punto de entrada que
/// ya lo determina.
Future<void> openProviderFormForKind(SpecialtyKind kind) async {
  await Get.toNamed(
    Routes.providerForm,
    arguments: <String, dynamic>{'initialKind': kind.wireName},
  );
  // Reload incondicional al volver. Cubre los tres casos (success, cancel,
  // back físico). Idempotente; el guard `_reloadInFlight` del controller
  // previene duplicados si se cruza con pull-to-refresh o lifecycle.
  if (!Get.isRegistered<MiRedController>()) {
    debugPrint(
      '[MiRed] ⚠️  MiRedController no registrado tras cerrar el form. '
      'Reload omitido. Si esto ocurre fuera de MiRedPage, revisar binding.',
    );
    return;
  }
  await Get.find<MiRedController>().loadInitial();
}

class _RegisterActorSheet extends StatelessWidget {
  const _RegisterActorSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título — centrado.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 2),
            child: Text(
              MiRedLabels.registerSheetTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Subtítulo — centrado.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              MiRedLabels.registerSheetSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          // 1. Mi equipo — visible pero degradado (sin flujo en V1).
          _RegisterOption(
            icon: Icons.groups_outlined,
            label: MiRedLabels.registerOptionTeam,
            subtitle: MiRedLabels.registerOptionTeamSubtitle,
            onTap: (ctx) => _showComingSoon(ctx),
          ),
          // 2. Proveedores de productos.
          _RegisterOption(
            icon: Icons.inventory_2_outlined,
            label: MiRedLabels.registerOptionProductos,
            subtitle: MiRedLabels.registerOptionProductosSubtitle,
            onTap: (ctx) => _openProviderForm(ctx, SpecialtyKind.product),
          ),
          // 3. Proveedores de servicios.
          _RegisterOption(
            icon: Icons.build_outlined,
            label: MiRedLabels.registerOptionServicios,
            subtitle: MiRedLabels.registerOptionServiciosSubtitle,
            onTap: (ctx) => _openProviderForm(ctx, SpecialtyKind.service),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Mi equipo aún no tiene flujo Flutter implementado en V1. En lugar de
  /// navegar a un stub roto, cerramos la sheet y mostramos snackbar
  /// "Próximamente". Cuando exista el flujo real, basta con sustituir
  /// el contenido de este método por la navegación correspondiente.
  void _showComingSoon(BuildContext sheetContext) {
    final messenger = ScaffoldMessenger.of(sheetContext);
    Navigator.of(sheetContext).pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text(MiRedLabels.registerOptionComingSoon),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Cierra el sheet y delega en [openProviderFormForKind] (navegación +
  /// reload). El pop debe ocurrir ANTES de navegar — evita el back-stack
  /// raro de "sheet > form > back > sheet vuelve a estar visible".
  Future<void> _openProviderForm(
    BuildContext sheetContext,
    SpecialtyKind kind,
  ) async {
    Navigator.of(sheetContext).pop();
    await openProviderFormForKind(kind);
  }
}

class _RegisterOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final void Function(BuildContext context) onTap;

  const _RegisterOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => onTap(context),
    );
  }
}
