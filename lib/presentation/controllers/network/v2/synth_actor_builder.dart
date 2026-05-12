// ============================================================================
// lib/presentation/controllers/network/v2/synth_actor_builder.dart
// SYNTH ACTOR BUILDER — LocalContactModel → NetworkActorSummaryVM síntetico.
// ============================================================================
//
// QUÉ HACE:
//   Convierte un `LocalContactModel` no archivado en un `NetworkActorSummaryVM`
//   "synth" para que Tab 5 pueda renderizar al actor INMEDIATAMENTE tras el
//   registro local, ANTES de que el backend lo confirme y el wire lo devuelva.
//
//   - `ref` = `local:contact:<contact.id>` mientras no hay link platform real.
//   - `supplierType` = `SupplierType.fromWire(contact.supplierTypeWire)`.
//   - `actions` = subset de canales locales (call/whatsapp/email/viewProfile).
//
// QUÉ NO HACE:
//   - NO infiere `hasWhatsApp=true` solo porque haya teléfono. El flag respeta
//     null (V1 conservador). Si backend lo confirma vía refresh, ese valor
//     prevalece tras dedupe synth ↔ real.
//   - NO incluye `edit` ni `archive` en `actions[]`. Esas afordancias viven
//     en UI level (long-press / detail page) y aplican a todo actor — synth
//     o real — independientemente de su lista de acciones.
//
// REGLAS:
//   - viewProviderProfile disabled si `linkedProviderProfileId == null`
//     (tooltip UI: "Disponible al sincronizar").
//   - call habilitado si `primaryPhoneE164 != null`.
//   - whatsapp se INTENTA si hay teléfono pero NO se afirma hasWhatsApp=true
//     a nivel de VM. El intento puede fallar si el contacto no tiene WA real.
//   - email habilitado si `primaryEmail != null`.
//
// SIN dependencia de wire DTO: este builder NO ve `NetworkActorSummaryDto`.
// Es pura conversión local → VM.
// ============================================================================

import '../../../../data/models/core_common/local_contact_model.dart';
import '../../../../data/models/network/network_action_dto.dart'
    show
        NetworkActionType,
        NetworkActionDisabledReason,
        NetworkActionCapability,
        NetworkActionDomain;
import '../../../../data/models/network/network_actor_ref.dart';
import '../../../../data/models/network/network_actor_summary_dto.dart'
    show NetworkRelationshipState;
import '../../../../data/models/network/network_category.dart';
import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import '../../../view_models/network/v2/network_action_vm.dart';
import '../../../view_models/network/v2/network_actor_summary_vm.dart';

/// Construye un VM synth a partir de un `LocalContactModel`. El contact
/// debe NO estar soft-deleted (el caller filtra antes). Si está archived
/// se considera bug — no se debería sintetizar para luego ocultar.
NetworkActorSummaryVM buildSynthActorVM(LocalContactModel contact) {
  assert(!contact.isDeleted,
      'No sintetizar contacts archived — el merger debe filtrarlos antes');

  final supplier = SupplierType.fromWire(contact.supplierTypeWire);
  final ref = NetworkActorRef.parse('local:contact:${contact.id}');
  final hasLink = contact.linkedProviderProfileId != null &&
      contact.linkedProviderProfileId!.isNotEmpty;

  return NetworkActorSummaryVM(
    ref: ref,
    displayName: contact.displayName,
    avatarRef: null,
    // Synth no resuelto a platform actor todavía.
    unresolved: !hasLink,
    // Placeholder hasta que refresh traiga categorías reales del wire.
    categories: const [NetworkCategory.unclassified],
    groupCategory: NetworkCategory.unclassified,
    isTeamMember: false,
    isRestricted: false,
    restrictionReason: null,
    primaryPhoneE164: contact.primaryPhoneE164,
    primaryEmail: contact.primaryEmail,
    // No inferir WA solo por tener teléfono. Quedará false hasta que backend
    // lo confirme (tras refresh exitoso el real DTO prevalece via dedupe).
    hasWhatsApp: false,
    relationshipState: NetworkRelationshipState.vinculada,
    providerProfileId: contact.linkedProviderProfileId,
    actions: _buildSynthActions(contact, hasLink: hasLink),
    // sectionKeys vacío en synth — la priority chain del bucketizer usa
    // `supplierType` (priority 1) cuando viene poblado. Si supplier es null,
    // el actor cae a data debt — correcto, falta clasificación.
    sectionKeys: const [],
    updatedAt: contact.updatedAt,
    supplierType: supplier,
    // ANCLA UI ESTABLE: synth → real con el mismo LocalContact comparten
    // este key. Flutter no destruye el tile durante la transición.
    visualStableKey: 'contact:${contact.id}',
  );
}

/// Construye la lista de acciones locales para un synth actor.
///
/// Tabla de habilitación:
///   - call    → si phone disponible
///   - whatsapp → si phone disponible (intento; sin afirmar hasWhatsApp)
///   - email   → si email disponible
///   - viewProviderProfile → si hasLink (linkedProviderProfileId presente)
///
/// edit y archive NO se incluyen en `actions[]`: son afordancias UI globales
/// que aplican a cualquier actor, no acciones operativas del catálogo wire.
List<NetworkActionVM> _buildSynthActions(
  LocalContactModel contact, {
  required bool hasLink,
}) {
  final out = <NetworkActionVM>[];

  final hasPhone =
      contact.primaryPhoneE164 != null && contact.primaryPhoneE164!.isNotEmpty;
  final hasEmail =
      contact.primaryEmail != null && contact.primaryEmail!.isNotEmpty;

  if (hasPhone) {
    out.add(const NetworkActionVM(
      type: NetworkActionType.call,
      enabled: true,
      domain: null,
      capability: null,
      disabledReason: null,
    ));
    out.add(const NetworkActionVM(
      type: NetworkActionType.whatsapp,
      enabled: true,
      domain: null,
      capability: null,
      disabledReason: null,
    ));
  } else {
    out.add(const NetworkActionVM(
      type: NetworkActionType.call,
      enabled: false,
      domain: null,
      capability: null,
      disabledReason: NetworkActionDisabledReason.phoneNotAvailable,
    ));
    out.add(const NetworkActionVM(
      type: NetworkActionType.whatsapp,
      enabled: false,
      domain: null,
      capability: null,
      disabledReason: NetworkActionDisabledReason.phoneNotAvailable,
    ));
  }

  if (hasEmail) {
    out.add(const NetworkActionVM(
      type: NetworkActionType.email,
      enabled: true,
      domain: null,
      capability: null,
      disabledReason: null,
    ));
  } else {
    out.add(const NetworkActionVM(
      type: NetworkActionType.email,
      enabled: false,
      domain: null,
      capability: null,
      disabledReason: NetworkActionDisabledReason.emailNotAvailable,
    ));
  }

  out.add(NetworkActionVM(
    type: NetworkActionType.viewProviderProfile,
    enabled: hasLink,
    domain: NetworkActionDomain.provider,
    capability: NetworkActionCapability.providerRead,
    // V1: razón conservadora cuando no hay link.
    disabledReason: hasLink ? null : NetworkActionDisabledReason.other,
  ));

  return List.unmodifiable(out);
}
