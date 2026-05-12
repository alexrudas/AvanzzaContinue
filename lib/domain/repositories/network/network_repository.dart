// ============================================================================
// lib/domain/repositories/network/network_repository.dart
// NETWORK REPOSITORY — Contrato dominio para Mi Red Operativa externa
// ============================================================================
// QUÉ HACE:
//   - Define el contrato que el controller (presentation) consume para
//     listar/contar la Red Operativa externa.
//   - Stateless por diseño: el cursor lo gestiona el controller (lock
//     `isLoadingMore`, reset al cambiar filtros, etc.).
//
// QUÉ NO HACE:
//   - No implementa `refresh()` ni `loadMore()` como métodos: ambos son
//     composiciones triviales sobre `fetchPage()` y son responsabilidad del
//     controller. Mantener el repo stateless evita drift de estado entre
//     capas y permite múltiples controllers (admin, owner futuro) compartir
//     el mismo repo sin pelear por cursor compartido.
//
// EXCEPCIONES DOCUMENTADAS:
//   - `UnauthorizedException`               — sesión inválida (re-login).
//   - `ForbiddenException`                  — sin capability network.read.
//   - `UnsupportedSchemaVersionException`   — app desactualizada.
//   - `BadRequestException(code: 'INVALID_CURSOR')` — cursor inválido (el
//     controller debe resetear cursor y reintentar primera página).
//   - `NetworkException`                    — sin respuesta HTTP.
//   - `ServerException`                     — 5xx.
// ============================================================================

import '../../../data/models/network/network_actor_summary_dto.dart';
import '../../../data/models/network/network_category.dart';
import '../../../data/models/network/network_envelope.dart';
import '../../../data/repositories/network/refresh_network_outcome.dart';
import '../../../data/sources/local/network/network_local_datasource.dart';

/// Contrato de la Red Operativa externa (red de actores con quien opera el
/// workspace: talleres, proveedores, técnicos, propietarios, etc.).
///
/// ═══════════════════════════════════════════════════════════════════════
/// MODELO DE VERDAD (V1):
///   - Local Isar = VERDAD OPERACIONAL INMEDIATA (lo que el usuario hizo ahora).
///   - Backend Core API = VERDAD CONTRACTUAL CONSOLIDADA (estado canónico).
///   - `reconcile` (parte del refreshSection exitoso) une ambos: backend gana
///     en campos canónicos, local gana en campos de intención (supplierType).
/// ═══════════════════════════════════════════════════════════════════════
abstract class NetworkRepository {
  /// Stream cache-first del estado de la sección network para [workspaceId].
  ///
  /// - Emite el snapshot actual desde Isar al suscribirse (incluye items y meta).
  /// - Re-emite cada vez que cambian items o meta del workspace.
  /// - Aislamiento estricto por workspace: nunca cruza entre orgs.
  ///
  /// Esta es la API local-first canónica. El controller suscribe a este
  /// stream y dispara [refreshSection] en background sin bloquear render.
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  });

  /// Refresca la sección network contra Core API y reconcilia atómicamente
  /// el resultado al cache local.
  ///
  /// Devuelve un [RefreshNetworkOutcome] estructurado — el caller decide
  /// qué banner/estado mostrar según el outcome. Esta función NUNCA lanza
  /// hacia afuera; convierte excepciones a outcomes y marca meta.syncStatus.
  ///
  /// Sobre éxito: ejecuta `reconcileFromServer` en el DS local (atómico,
  /// con blindajes anti-mass-delete + missingInLastSync).
  /// Sobre fallo: ejecuta `markSyncFailed` (cache de actores intacta).
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    int? limit,
  });

  /// [LEGACY] Trae una página del listado HTTP-only.
  ///
  /// - [cursor] null = primera página.
  /// - El caller debe resetear cursor cuando cambia cualquier filtro
  ///   (category/state/assetId).
  /// - El envelope retornado expone `nextCursor` (null = última página) y
  ///   `serverTime` (útil para TTL/clock skew).
  ///
  /// Mantenido para callers existentes durante la transición a cache-first.
  /// Nuevos consumidores deben usar [watchSection] + [refreshSection].
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> fetchPage({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  });

  /// Contador ligero de externos activos. Útil para badges y headers.
  Future<NetworkCategoriesSummaryEnvelope> fetchSummary();
}
