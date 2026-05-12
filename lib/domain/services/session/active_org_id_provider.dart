// ============================================================================
// lib/domain/services/session/active_org_id_provider.dart
// ACTIVE ORG ID PROVIDER — contrato de dominio para exponer el orgId activo.
// ============================================================================
// QUÉ HACE:
// - Expone un método síncrono `activeOrgId` que retorna el identificador
//   canónico del workspace legacy (orgId string) activo para el caller.
// - Permite que capas infra (p. ej. `AccessInterceptor`, `AccessGateway`)
//   lean el orgId sin importar `SessionContextController` — core NO importa
//   presentation.
//
// QUÉ NO HACE:
// - No observa, no notifica cambios. Es un getter puntual; si un consumer
//   necesita reaccionar a cambios, debe escuchar las fuentes reactivas ya
//   existentes (p. ej. `UserRx` de `SessionContextController`).
// - No persiste. Solo refleja el estado vivo del SSOT.
// - No resuelve workspaceId canónico (UUID) — eso lo hace el backend o el
//   `AccessContext` retornado por `/v1/access/me/context`.
//
// PRINCIPIOS:
// - Contrato mínimo (un solo getter). Sin ceremonia.
// - Retorno nullable: null significa "no hay sesión hidratada o no hay
//   orgId resuelto todavía". El consumer decide qué hacer ante null.
// - Síncrono por diseño — interceptores HTTP no deben bloquearse en I/O.
//
// ENTERPRISE NOTES:
// - Fuente conceptual: "Contrato de integración — Flutter ↔ Core API Access"
//   §8.2 (fallback body.orgId en dev/piloto).
// - Los implementadores deben tolerar `user?.activeContext?.orgId == ''`
//   (ver memoria `feedback_orgid_race` del repo Avanzza 2.0) y fallback a
//   la primera membership disponible si existe.
// ============================================================================

abstract class ActiveOrgIdProvider {
  /// Retorna el orgId legacy (string) activo del caller, o null si no hay
  /// sesión hidratada o el orgId aún no está resuelto.
  ///
  /// Debe:
  /// - Normalizar strings vacíos a null ("" → null).
  /// - Preferir `activeContext.orgId` cuando exista.
  /// - Caer a la primera membership activa cuando `activeContext.orgId`
  ///   venga vacío (repair del race documentado en la memoria del repo).
  String? get activeOrgId;
}
