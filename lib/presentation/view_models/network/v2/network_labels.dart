// ============================================================================
// lib/presentation/view_models/network/v2/network_labels.dart
// NETWORK LABELS — Único punto de copy ES para Mi Red Operativa
// ============================================================================
// QUÉ HACE:
//   - Resolver puro que mapea los enums del contrato (NetworkCategory,
//     NetworkActionType, NetworkActionDisabledReason, NetworkRestrictionReason)
//     a strings humanos en español para UI.
//
// QUÉ NO HACE:
//   - No vive en VMs: los view-models exponen tipos enum, no strings.
//   - No formatea tiempos, montos ni nombres propios. Solo etiquetas de
//     dominio.
//
// PRINCIPIOS:
//   - Funciones puras `static`. Sin estado, sin singletons.
//   - Future-proof i18n: cuando se introduzca `intl`, esta clase se reemplaza
//     por una que delegue a `AppLocalizations.of(context)` SIN tocar VMs ni
//     widgets que ya consuman la API actual.
//   - Switch exhaustivo sobre enums cerrados: si se agrega un valor al enum
//     y no se actualiza acá, el compilador lo señala (sin fallback silencioso).
// ============================================================================

import '../../../../data/models/network/network_action_dto.dart';
import '../../../../data/models/network/network_actor_summary_dto.dart';
import '../../../../data/models/network/network_category.dart';

/// Resolver de copy en español para Mi Red Operativa.
abstract final class NetworkLabels {
  // ── Categorías (red externa) ───────────────────────────────────────────
  static String category(NetworkCategory c) {
    switch (c) {
      case NetworkCategory.workshop:
        return 'Talleres';
      case NetworkCategory.provider:
        return 'Proveedores';
      case NetworkCategory.technician:
        return 'Técnicos';
      case NetworkCategory.owner:
        return 'Propietarios';
      case NetworkCategory.driver:
        return 'Conductores';
      case NetworkCategory.operator:
        return 'Operadores';
      case NetworkCategory.tenant:
        return 'Arrendatarios';
      case NetworkCategory.legal:
        return 'Legal';
      case NetworkCategory.unclassified:
        return 'Otros';
    }
  }

  // ── Acciones operativas ────────────────────────────────────────────────
  static String actionLabel(NetworkActionType t) {
    switch (t) {
      case NetworkActionType.call:
        return 'Llamar';
      case NetworkActionType.whatsapp:
        return 'WhatsApp';
      case NetworkActionType.email:
        return 'Correo';
      case NetworkActionType.viewProviderProfile:
        return 'Ver proveedor';
      case NetworkActionType.requestQuote:
        return 'Cotizar';
      case NetworkActionType.startCoordinationFlow:
        return 'Coordinar';
    }
  }

  // ── Motivo cuando una acción viene deshabilitada ───────────────────────
  static String actionDisabledHint(NetworkActionDisabledReason r) {
    switch (r) {
      case NetworkActionDisabledReason.phoneNotAvailable:
        return 'Sin teléfono registrado';
      case NetworkActionDisabledReason.emailNotAvailable:
        return 'Sin correo registrado';
      case NetworkActionDisabledReason.capabilityMissing:
        return 'No tienes permiso para esta acción';
      case NetworkActionDisabledReason.relationshipNotActive:
        return 'La relación no está activa';
      case NetworkActionDisabledReason.notAProvider:
        return 'Este actor no es un proveedor';
      case NetworkActionDisabledReason.unresolvedActor:
        return 'Actor no verificado en plataforma';
      case NetworkActionDisabledReason.other:
        return 'Acción no disponible';
    }
  }

  // ── Badge de restricción ───────────────────────────────────────────────
  static String restrictionBadge(NetworkRestrictionReason r) {
    switch (r) {
      case NetworkRestrictionReason.suspended:
        return 'Suspendido';
      case NetworkRestrictionReason.closed:
        return 'Cerrado';
    }
  }

  // ── Estado de relación (caras visibles en /network) ────────────────────
  static String relationshipState(NetworkRelationshipState s) {
    switch (s) {
      case NetworkRelationshipState.vinculada:
        return 'Vinculada';
      case NetworkRelationshipState.suspendida:
        return 'Suspendida';
      case NetworkRelationshipState.cerrada:
        return 'Cerrada';
    }
  }
}
