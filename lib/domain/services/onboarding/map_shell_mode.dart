// ============================================================================
// lib/domain/services/onboarding/map_shell_mode.dart
// mapShellMode — función pura: capabilities + expectedRelationKind → ShellMode.
// ============================================================================
// QUÉ HACE:
//   - Deriva el [ShellMode] que el HomeShell debe montar para un workspace
//     a partir de los datos canónicos disponibles:
//       · `Workspace.capabilityProfiles` (lo que el workspace ofrece al mercado)
//       · `Portfolio.expectedRelationKind` (intent de relación con assets)
//   - Resuelve multi-capability con un orden de prioridad estable (cuando
//     un workspace declara varias capabilities, el shell por default es el
//     más operativo; el usuario puede switchear vía UI futura).
//   - Fallback seguro a [ShellMode.assetOwner] cuando no hay capabilities
//     ni expectedRelationKind (un workspace personal recién creado sin
//     intent declarado se asume mantenedor de assets).
//
// QUÉ NO HACE:
//   - NO accede a repos, ni a Firestore, ni a Isar. Es función pura.
//   - NO infiere expectedRelationKind desde capabilities. Lo recibe como
//     parámetro opcional; el caller (típicamente SessionContextController)
//     decide qué relación expone.
//   - NO produce ningún valor que pueda usarse como partition key. ShellMode
//     es UI runtime — está PROHIBIDO persistirlo o filtrar queries con él.
//   - NO toma decisiones de permiso. Para policy usar `MembershipPolicy`.
//
// PRIORIDAD MULTI-CAPABILITY (orden estable):
//   provider > advisor > broker > insurer > legal
//
//   Justificación: provider tiene la operación más concreta (productos vs
//   servicios + market) y suele ser el shell principal del workspace.
//   Advisor le sigue (consultivo). Broker, insurer y legal son shells
//   menos frecuentes como default.
//
//   Si en el futuro un workspace tiene multi-capability con un shell
//   distinto deseado, el usuario alterna via switcher (ítem futuro).
//
// FALLBACK (sin capabilities):
//   - expectedRelationKind ∈ {tenant, driver, operator}        ⇒ renter
//   - expectedRelationKind ∈ {owner, manager, workshop, ...}   ⇒ assetOwner
//   - null                                                     ⇒ assetOwner
// ============================================================================

import '../../entities/core_common/value_objects/asset_actor_role.dart';
import '../../value/capability/capability_profile.dart';
import '../../value/capability/profile_kind.dart';
import '../../value/capability/provider_type.dart';
import 'shell_mode.dart';

/// Deriva el [ShellMode] de un workspace a partir de sus capabilities y
/// (opcionalmente) el intent de relación con assets.
///
/// Función pura: mismo input → mismo output. No persistencia, no I/O,
/// no telemetría, no efectos secundarios.
ShellMode mapShellMode({
  required List<CapabilityProfile> capabilityProfiles,
  AssetActorRole? expectedRelationKind,
}) {
  // 1. Workspace con capabilities: prioridad provider > advisor > broker >
  //    insurer > legal.
  if (capabilityProfiles.isNotEmpty) {
    // 1a. provider distingue articulos vs servicios (sub-shell).
    for (final cap in capabilityProfiles) {
      if (cap.kind == ProfileKind.provider) {
        final type = cap.providerSpec?.providerType;
        if (type == ProviderType.articulos) return ShellMode.providerArticulos;
        if (type == ProviderType.servicios) return ShellMode.providerServicios;
        // providerSpec inválido (kind=provider sin spec) — invariante del
        // CapabilityProfile constructor lo prohíbe. Solo posible vía bug;
        // caemos al siguiente nivel de prioridad.
      }
    }

    // 1b. Otros kinds en orden de prioridad estable.
    const otherPriority = <ProfileKind, ShellMode>{
      ProfileKind.advisor: ShellMode.advisor,
      ProfileKind.broker: ShellMode.broker,
      ProfileKind.insurer: ShellMode.insurer,
      ProfileKind.legal: ShellMode.legal,
    };
    for (final entry in otherPriority.entries) {
      if (capabilityProfiles.any((c) => c.kind == entry.key)) {
        return entry.value;
      }
    }
  }

  // 2. Sin capabilities: distinguir por expectedRelationKind.
  if (expectedRelationKind != null && _isRenterRelation(expectedRelationKind)) {
    return ShellMode.renter;
  }

  // 3. Default: workspace mantiene assets (owner/admin/etc) o no declara
  //    intent — usa el shell de gestión de activos.
  return ShellMode.assetOwner;
}

/// True si [role] expresa una relación de USO de un activo (no propiedad
/// ni administración).
///
/// - tenant   : arrendatario.
/// - driver   : conductor de vehículo.
/// - operator : operador / cliente operativo (ej. cliente que arrienda
///              maquinaria y la opera él mismo o un tercero).
///
/// Otros valores (owner, manager, workshop, technician, legal) NO son
/// renter relations — el workspace que los tiene mantiene el activo en
/// algún rol patrimonial / operativo / de servicio.
bool _isRenterRelation(AssetActorRole role) {
  switch (role) {
    case AssetActorRole.tenant:
    case AssetActorRole.driver:
    case AssetActorRole.operator:
      return true;
    case AssetActorRole.owner:
    case AssetActorRole.manager:
    case AssetActorRole.workshop:
    case AssetActorRole.technician:
    case AssetActorRole.legal:
      return false;
  }
}
