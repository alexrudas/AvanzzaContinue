// ============================================================================
// lib/presentation/widgets/purchase/vendor_target_picker_sheet.dart
// VENDOR TARGET PICKER — Selector multiselect de PROVEEDORES del pedido
// ============================================================================
// QUÉ HACE:
//   - Bottom sheet modal que lista los PROVEEDORES del workspace activo
//     (fuente: LocalContactRepository + Isar filtrado por roleLabel) y
//     permite seleccionar entre 1 y `kMaxVendorsPerPurchaseRequest` (= 3)
//     proveedores para la solicitud actual.
//   - El estado de selección vive en PurchaseRequestController; el sheet
//     solo lee y alterna vía `toggleVendor` (que enforza el tope duro).
//   - Ofrece alta rápida inline de un proveedor sin salir del pedido vía
//     `showNewVendorDialog` (widget compartido con la página dedicada de
//     Proveedores — una sola vía de alta, misma fuente de verdad).
//   - Empty state con CTA claro para agregar el primer proveedor.
//   - Contador visible X/3; el botón "Agregar proveedor" y los tiles no
//     seleccionados se deshabilitan cuando se alcanza el máximo.
//
// QUÉ NO HACE:
//   - No es CRUD completo de proveedor: la edición, eliminación y gestión
//     profunda viven en ProvidersDirectoryPage (Directorio / Mi red
//     operativa → Proveedores). Este sheet es un SELECTOR con atajo de alta.
//   - No abre cross-workspace ni invitación externa; el proveedor creado
//     aquí es un `LocalContact` privado del workspace del administrador.
//   - No crea `LocalOrganization` (proveedor-empresa pesada). Si el
//     proveedor es una empresa, el nombre de la empresa entra como
//     displayName; cuando el proyecto habilite el flujo empresa-NIT se
//     migra a LocalOrganization sin romper esta pantalla.
//   - No duplica formularios: el diálogo de alta es `showNewVendorDialog`
//     compartido; si el copy o campos cambian, cambian en un solo lugar.
//
// PRINCIPIOS:
//   - Semántica comercial real en UI: "Proveedor", "Seleccionar proveedores",
//     "Agregar proveedor". Nada de "contacto genérico" aquí.
//   - Persistencia canónica: la creación usa `SaveLocalContactWithProbe` a
//     través de `showNewVendorDialog` — patrón offline-first (save local +
//     enqueue remoto) consolidado del proyecto.
//   - Reactividad: tras el save, el stream `watchByWorkspace` del repo
//     refresca `availableContacts` del controller → el proveedor recién
//     creado reaparece sin refresh manual y queda autoseleccionado.
//     El MISMO stream alimenta ProvidersDirectoryPage: cualquier alta
//     aquí aparece ahí y viceversa sin intervención del usuario.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/core_common/constants/role_labels.dart';
import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../controllers/purchase_request_controller.dart';
import '../core_common/new_vendor_dialog.dart';

class VendorTargetPickerSheet extends StatelessWidget {
  const VendorTargetPickerSheet({super.key});

  /// Abre el sheet. Al cerrar, la selección queda persistida en el controller.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const VendorTargetPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<PurchaseRequestController>();

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con título + acción "Agregar proveedor" (deshabilitada
              // cuando ya se alcanzó el máximo permitido por el pedido).
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Seleccionar proveedores',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Obx(() {
                      // Observa selectedVendorIds para reaccionar al tope.
                      final reached = controller.hasReachedMaxVendors;
                      return TextButton.icon(
                        key: const Key('vendor_picker.add_vendor.btn'),
                        icon: const Icon(Icons.add_business_outlined, size: 18),
                        label: const Text('Agregar proveedor'),
                        onPressed: reached
                            ? null
                            : () =>
                                _promptCreateVendor(context, controller),
                      );
                    }),
                  ],
                ),
              ),
              Text(
                'Elige hasta $kMaxVendorsPerPurchaseRequest proveedores del '
                'workspace para enviarles la solicitud. Debe haber al menos uno.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  // availableContacts ya es un getter filtrado por
                  // roleLabel == 'proveedor' (o rol vacío por compat).
                  // Se accede a selectedVendorIds para que Obx reaccione
                  // cuando el tope cambia el "disabled" de cada tile.
                  final vendors = controller.availableContacts;
                  // Lectura reactiva: suscribe este Obx a cambios de tope,
                  // para deshabilitar/habilitar tiles cuando se alcanza el máximo.
                  // ignore: unnecessary_statements
                  controller.selectedVendorIds.length;
                  if (vendors.isEmpty) {
                    return _EmptyState(
                      onCreate: () =>
                          _promptCreateVendor(context, controller),
                    );
                  }
                  return ListView.separated(
                    itemCount: vendors.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 56),
                    itemBuilder: (_, i) => _VendorTile(
                      vendor: vendors[i],
                      controller: controller,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              // Footer: contador X/MAX + CTA cerrar.
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final n = controller.selectedVendorIds.length;
                      const max = kMaxVendorsPerPurchaseRequest;
                      return Text(
                        n == 0
                            ? 'Sin proveedores seleccionados (máx. $max)'
                            : '$n/$max ${n == 1 ? "proveedor" : "proveedores"} '
                                'seleccionado${n == 1 ? "" : "s"}',
                        style: theme.textTheme.bodyMedium,
                      );
                    }),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Listo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // ALTA RÁPIDA INLINE — DELEGADA A showNewVendorDialog
  // ───────────────────────────────────────────────────────────────────────

  /// Abre el diálogo compartido de alta y, tras un éxito, marca el vendor
  /// como recién creado (para `attestSelf=true` al enviar) y lo autoselecciona
  /// si hay cupo. Errores se muestran vía SnackBar local al sheet; éxitos
  /// también, usando `ScaffoldMessenger` para inmunidad a transiciones de
  /// Overlay (ver `_showSnack`).
  Future<void> _promptCreateVendor(
    BuildContext context,
    PurchaseRequestController controller,
  ) async {
    final result = await showNewVendorDialog(
      context,
      workspaceId: controller.orgIdForNewContact ?? '',
    );
    // Usuario canceló: el diálogo cierra devolviendo null.
    if (result == null) return;

    // Fallo al persistir: mostramos el mensaje estructurado del diálogo.
    if (result.isError) {
      if (!context.mounted) return;
      _showSnack(context, result.error!);
      return;
    }

    final vendor = result.vendor!;

    // Marcar el proveedor como RECIÉN CREADO en esta sesión del formulario.
    // Cuando el usuario envíe la solicitud, el controller detectará que
    // hay al menos un "fresh" y usará el factory
    // `fromFreshlyCreatedLocalContactIds` (attestSelf=true). Esto evita
    // el 409 ACTOR_REF_UNKNOWN del backend cuando el alta no tenía
    // llaves normalizables (el probe fue no-op). Ver ADR actor-canon §8.
    //
    // La marca se guarda ANTES de autoseleccionar para que el estado sea
    // coherente incluso si el toggle rebotase por tope máximo.
    controller.markVendorAsFreshlyCreated(vendor.id);

    // Autoseleccionar si queda cupo. Si el usuario ya tenía el máximo
    // seleccionados, `toggleVendor` devolverá false y avisamos.
    final accepted = controller.toggleVendor(vendor.id);
    if (!context.mounted) return;
    if (accepted) {
      _showSnack(context, 'Proveedor agregado: ${vendor.displayName}');
    } else {
      _showSnack(
        context,
        'Ya tienes $kMaxVendorsPerPurchaseRequest proveedores seleccionados. '
        'El proveedor se guardó en tu red, pero no se agregó al pedido.',
        duration: const Duration(seconds: 4),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SNACKBAR HELPER — seguro tras cerrar modales
// ═══════════════════════════════════════════════════════════════════════════

/// Muestra un SnackBar vía `ScaffoldMessenger` pospuesto al próximo frame.
///
/// POR QUÉ EXISTE:
///   - `Get.snackbar` invocado inmediatamente tras cerrar un AlertDialog o
///     bottom sheet puede fallar con "No Overlay widget found" porque el
///     Overlay raíz está en transición. `ScaffoldMessenger.maybeOf(context)`
///     resuelve al Scaffold padre del árbol (la pantalla de compras), que
///     sigue montado, y `addPostFrameCallback` garantiza que el frame donde
///     se cierra el modal ya terminó antes de agendar el snack.
///   - Si por alguna razón no hay ScaffoldMessenger arriba (contexto
///     huérfano), simplemente no mostramos nada en lugar de crashear.
void _showSnack(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// TILE
// ═══════════════════════════════════════════════════════════════════════════

class _VendorTile extends StatelessWidget {
  final LocalContactEntity vendor;
  final PurchaseRequestController controller;

  const _VendorTile({required this.vendor, required this.controller});

  /// Subtítulo compuesto: teléfono, email y categoría (si existen).
  /// Categoría se guarda en `notesPrivate` en el alta rápida.
  String? _subtitle() {
    final parts = <String>[];
    if (vendor.primaryPhoneE164?.isNotEmpty == true) {
      parts.add(vendor.primaryPhoneE164!);
    }
    if (vendor.primaryEmail?.isNotEmpty == true) {
      parts.add(vendor.primaryEmail!);
    }
    final cat = vendor.notesPrivate?.trim();
    if (cat != null && cat.isNotEmpty) parts.add(cat);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.isSelected(vendor.id);
      // Si ya se alcanzó el máximo y este proveedor NO está seleccionado,
      // se deshabilita el tile para reforzar visualmente el tope.
      final disabled = !selected && controller.hasReachedMaxVendors;
      final sub = _subtitle();
      return CheckboxListTile(
        key: Key('vendor_picker.tile.${vendor.id}'),
        value: selected,
        onChanged: disabled
            ? null
            : (_) {
                final accepted = controller.toggleVendor(vendor.id);
                if (!accepted) {
                  _showSnack(
                    context,
                    'Solo puedes seleccionar hasta '
                    '$kMaxVendorsPerPurchaseRequest proveedores por pedido.',
                  );
                }
              },
        title: Text(vendor.displayName),
        subtitle: sub != null ? Text(sub) : null,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  /// CTA para crear el primer proveedor inline sin salir del pedido.
  final VoidCallback? onCreate;
  const _EmptyState({this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_business_outlined,
                size: 48, color: theme.hintColor),
            const SizedBox(height: 12),
            Text(
              'Aún no tienes proveedores',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega tu primer proveedor para enviarle esta solicitud. '
              'Podrás gestionarlo después en Mi red operativa → Proveedores.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (onCreate != null)
              FilledButton.icon(
                key: const Key('vendor_picker.empty_state.create.btn'),
                icon: const Icon(Icons.add_business_outlined),
                label: const Text('Agregar proveedor'),
                onPressed: onCreate,
              )
            else
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido'),
              ),
          ],
        ),
      ),
    );
  }
}
