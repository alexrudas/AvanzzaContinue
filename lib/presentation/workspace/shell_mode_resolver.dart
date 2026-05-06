// ============================================================================
// lib/presentation/workspace/shell_mode_resolver.dart
// resolveCurrentShellMode — punto canónico de presentation para resolver el
// ShellMode del workspace activo en una sesión UI.
// ============================================================================
// QUÉ HACE:
//   - Wrapper de presentación sobre [mapShellMode] (domain).
//   - Provee la firma orientada a consumidores UI (controllers, shells,
//     drawers): toma una `OrganizationEntity` + `AssetActorRole?` opcional
//     desde el Portfolio activo y devuelve un `ShellMode` runtime.
//
// QUÉ NO HACE:
//   - NO accede a repos. El caller (controller) carga la organización y
//     pasa el snapshot. Esto preserva la pureza del mapper de dominio.
//   - NO persiste el resultado. ShellMode es UI-only.
//   - NO filtra queries. Si alguien intenta usar el resultado como
//     argumento de `where()` (`.where('shellMode', isEqualTo: ...)`),
//     code review debe rechazarlo: el partition key es `orgId` /
//     `workspaceId`, NO el shell.
//
// REGLA:
//   El SessionContextController y los shells UI consumen este helper.
//   Cualquier nuevo consumidor de ShellMode debe pasar por aquí (NO
//   importar `mapShellMode` directo desde domain en presentation a menos
//   que sea para tests).
// ============================================================================

import '../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/services/onboarding/map_shell_mode.dart';
import '../../domain/services/onboarding/shell_mode.dart';

/// Resuelve el [ShellMode] runtime para el workspace activo a partir de
/// la organización y (opcionalmente) el intent de relación con assets
/// declarado en el Portfolio activo.
///
/// **UI-only.** El valor retornado NUNCA se persiste, NUNCA se usa como
/// filtro de query. Tenancy se mantiene por `orgId`/`workspaceId`.
///
/// Pure: misma input → mismo output. No I/O, no telemetría.
ShellMode resolveCurrentShellMode({
  required OrganizationEntity organization,
  AssetActorRole? expectedRelationKind,
}) {
  return mapShellMode(
    capabilityProfiles: organization.capabilityProfiles,
    expectedRelationKind: expectedRelationKind,
  );
}
