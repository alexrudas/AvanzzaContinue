// ============================================================================
// lib/presentation/widgets/network/v2/actions_bottom_sheet.dart
// ACTIONS BOTTOM SHEET — Lista de acciones operativas para un actor
// ============================================================================
// QUÉ HACE:
//   - Bottom sheet que muestra cada acción de un actor con su label resuelto
//     (NetworkLabels.actionLabel) y, si está deshabilitada, su hint.
//   - Ejecuta navegación local según action.type:
//       · call → tel:<phone>      (url_launcher)
//       · whatsapp → wa.me/<phone> sin '+'
//       · email → mailto:<email>
//       · view_provider_profile, request_quote, start_coordination_flow
//         → TODO controlado en Hito 5b base; sin pantalla destino aún.
//   - Cierra el sheet automáticamente tras invocar una acción.
//
// QUÉ NO HACE:
//   - No infiere `enabled`: si action.enabled=false, el botón se renderiza
//     deshabilitado y muestra el hint del reason. La UI NO ejecuta nada.
//   - No conoce ni verifica capabilities: respeta lo que el backend mandó.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/network/network_action_dto.dart';
import '../../../../routes/app_routes.dart';
import '../../../view_models/network/v2/network_action_vm.dart';
import '../../../view_models/network/v2/network_labels.dart';

class ActionsBottomSheet extends StatelessWidget {
  /// Título visible (típicamente displayName del actor o miembro).
  final String title;

  final List<NetworkActionVM> actions;

  /// Teléfono E.164 del actor para call/whatsapp. Null si no hay canal.
  final String? phoneE164;

  /// Email del actor para mailto. Null si no hay canal.
  final String? email;

  /// ID del ProviderProfile canónico (Core API) para navegar al detalle.
  /// Null cuando el actor no es proveedor (ej. miembro del equipo). Si la
  /// acción `view_provider_profile` viene `enabled=true` el backend ya
  /// garantizó que este id existe — defensivamente la UI igual valida null.
  final String? providerProfileId;

  const ActionsBottomSheet({
    super.key,
    required this.title,
    required this.actions,
    this.phoneE164,
    this.email,
    this.providerProfileId,
  });

  @override
  Widget build(BuildContext context) {
    // El sheet puede recibir hasta 6 acciones (proveedor con dominio
    // provider/purchase/coordination habilitado). Cada ListTile mide
    // ~56-72px → contenido total ~450-550px. Sin SingleChildScrollView
    // y sin `isScrollControlled` en el caller, el contenido excede la
    // altura default de showModalBottomSheet (~50% del viewport) y
    // Flutter reporta "Bottom Overflowed by N pixels".
    //
    // Aquí garantizamos scroll interno como red de seguridad: incluso
    // si el caller olvida `isScrollControlled: true`, no hay overflow.
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (actions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No hay acciones disponibles.'),
              )
            else
              ...actions.map((a) => _ActionRow(
                    action: a,
                    onPressed: () => _onPressed(context, a),
                  )),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context, NetworkActionVM action) async {
    if (!action.enabled) return; // Defensa extra: el row ya viene disabled.

    Uri? uri;
    bool unimplemented = false;
    bool navigateToProviderDetail = false;

    switch (action.type) {
      case NetworkActionType.call:
        if (phoneE164 != null) uri = Uri.parse('tel:$phoneE164');
        break;
      case NetworkActionType.whatsapp:
        if (phoneE164 != null) {
          // wa.me requiere número sin '+'.
          final digits = phoneE164!.replaceAll('+', '');
          uri = Uri.parse('https://wa.me/$digits');
        }
        break;
      case NetworkActionType.email:
        if (email != null) uri = Uri.parse('mailto:$email');
        break;
      case NetworkActionType.viewProviderProfile:
        // Navegar a NetworkProviderDetailPage (read-only, Core API).
        // Si por algún motivo providerProfileId no llegó (backend habilitó
        // la acción sin id), caer al snackbar "Próximamente" en lugar de
        // crashear con un id vacío que el backend rechazaría con 404.
        if (providerProfileId != null && providerProfileId!.isNotEmpty) {
          navigateToProviderDetail = true;
        } else {
          unimplemented = true;
        }
        break;
      case NetworkActionType.requestQuote:
      case NetworkActionType.startCoordinationFlow:
        // TODO(Hito 5c): wirear navegación a las rutas dedicadas cuando
        // existan los flujos Flutter destino. Mientras tanto, el backend
        // puede marcar estas acciones como enabled=true (capability + dominio
        // listos del lado server) y la app DEBE evitar el cierre silencioso
        // del sheet — un tap sin efecto confunde al usuario.
        unimplemented = true;
        break;
    }

    if (navigateToProviderDetail) {
      // Cerrar el sheet antes de navegar — evita un back-stack raro donde
      // al volver del detalle el sheet sigue visible encima de Mi Red.
      if (context.mounted) Navigator.of(context).pop();
      await Get.toNamed(
        Routes.networkProviderDetail,
        arguments: {'providerProfileId': providerProfileId},
      );
      return;
    }

    if (unimplemented) {
      // Feedback explícito: mostrar mensaje "Próximamente" desde el messenger
      // ancestro del sheet (Scaffold de MiRedPage) ANTES de pop, para que el
      // SnackBar quede atado a la pantalla y no al sheet ya destruido.
      final messenger = ScaffoldMessenger.of(context);
      if (context.mounted) Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Esta acción estará disponible próximamente.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (context.mounted) Navigator.of(context).pop();
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ActionRow extends StatelessWidget {
  final NetworkActionVM action;
  final VoidCallback onPressed;

  const _ActionRow({required this.action, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final label = NetworkLabels.actionLabel(action.type);
    final disabledHint = action.disabledReason != null
        ? NetworkLabels.actionDisabledHint(action.disabledReason!)
        : null;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(_iconFor(action.type)),
      title: Text(
        label,
        style: TextStyle(
          color: action.enabled
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
      subtitle: !action.enabled && disabledHint != null
          ? Text(disabledHint, style: const TextStyle(fontSize: 12))
          : null,
      enabled: action.enabled,
      onTap: action.enabled ? onPressed : null,
    );
  }

  IconData _iconFor(NetworkActionType type) {
    switch (type) {
      case NetworkActionType.call:
        return Icons.call_outlined;
      case NetworkActionType.whatsapp:
        return Icons.chat_outlined;
      case NetworkActionType.email:
        return Icons.email_outlined;
      case NetworkActionType.viewProviderProfile:
        return Icons.badge_outlined;
      case NetworkActionType.requestQuote:
        return Icons.request_quote_outlined;
      case NetworkActionType.startCoordinationFlow:
        return Icons.handshake_outlined;
    }
  }
}
