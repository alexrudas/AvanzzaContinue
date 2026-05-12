// ============================================================================
// lib/data/repositories/network/network_repository_impl.dart
// NETWORK REPOSITORY IMPL — Cache-first / Local-first (Fase 4 Paso 3a)
// ============================================================================
//
// ═══════════════════════════════════════════════════════════════════════════
// MODELO DE VERDAD V1:
//   - Local Isar       = VERDAD OPERACIONAL INMEDIATA
//     (lo que el usuario hizo ahora, sin esperar red).
//   - Backend Core API = VERDAD CONTRACTUAL CONSOLIDADA
//     (estado canónico autoritativo entre dispositivos / workspaces).
//   - reconcile()      = arbitrar local ↔ backend sin destruir verdad
//     operacional. V1 usa LWW por `updatedAt`; ver bloque ⚠ abajo.
// ═══════════════════════════════════════════════════════════════════════════
//
// QUÉ HACE:
//   - `watchSection(workspaceId)` → stream local-first del DS.
//   - `refreshSection(workspaceId)` → HTTP /v1/network → `reconcileFromServer`
//     atómico al DS. Convierte excepciones a `RefreshNetworkOutcome`.
//   - `fetchPage(...)` legacy: delega 1:1 al apiClient (sin cache).
//   - `fetchSummary()` legacy: delega 1:1.
//
// QUÉ NO HACE:
//   - No mantiene estado: stateless. Cursor + filtros viven en el controller.
//   - No bloquea read path en HTTP: la UI nunca espera /v1/network para
//     renderizar — eso es responsabilidad del controller que suscribe el
//     watchSection y dispara refreshSection unawaited.
//   - No reintenta automáticamente: cada llamada a refreshSection es un
//     intento único. Auto-retry queda fuera de scope (deuda explícita).
//
// ═══════════════════════════════════════════════════════════════════════════
// ⚠ HARDENING — PER-ROW QUARANTINE NO IMPLEMENTADO EN V1 ⚠
// ═══════════════════════════════════════════════════════════════════════════
//   El parser de `NetworkPageEnvelope.fromJson` itera la lista de items y
//   delega cada uno a `NetworkActorSummaryDto.fromJson`, que es ESTRICTO
//   (lanza FormatException si campos requeridos faltan o están malformados).
//
//   Limitación actual:
//     · Si UN solo actor en la respuesta viene malformado → toda la página
//       se rechaza con FormatException.
//     · Perdemos visibilidad de los actores válidos que venían en la misma
//       respuesta.
//
//   Lo que SÍ está garantizado:
//     · La cache local NUNCA se toca cuando hay parse error (jamás se llega
//       a `reconcileFromServer`). Los actores cacheados siguen visibles.
//     · El outcome es `RefreshNetworkOutcome.unknownError`.
//     · `meta.lastErrorCode='parseError'` queda persistido para telemetría
//       y para que la UI pueda diferenciar "fallo de red" vs "fallo de parse".
//
//   Deuda técnica explícita (V2):
//     · Mover el try/catch al nivel de item en `NetworkPageEnvelope.fromJson`
//       (`parseItemSafe(...)`), saltarse el malformado, contar/loguear su ref
//       o índice, y reconciliar solo los actores válidos.
//     · Permite parse parcial sin perder la página completa.
//     · Out-of-scope V1 — requiere cambio al api_client/envelope parser.
//
// ⚠ POLÍTICA DE RESOLUCIÓN DE CONFLICTOS V1 — SIMPLIFICACIÓN TEMPORAL ⚠
//   reconcileFromServer (en NetworkLocalDataSource) usa Last-Write-Wins por
//   `updatedAt`. ACEPTABLE para single-device con sync ocasional. NO es la
//   política definitiva de Avanzza.
//
//   Falla previsible en:
//     - Reloj de cliente desincronizado (clock skew, NTP roto)
//     - Timezones distintos entre cliente y servidor
//     - Multi-device con sync delayed
//     - Replay de mutaciones tras conectividad recuperada
//     - Retries que reescriben el updatedAt
//
//   Migración futura (post-V1) hacia:
//     - Causal ordering (vector clocks / lamport timestamps)
//     - Operational transforms para edits concurrentes
//     - Domain-specific merge per campo (archive nunca pierde frente a edit)
//     - Field-level CRDTs en datos colaborativos
//
//   DEUDA CONCEPTUAL EXPLÍCITA — documentada para que no se olvide.
// ═══════════════════════════════════════════════════════════════════════════
// ============================================================================

import '../../../core/utils/text_normalization.dart';
import '../../../domain/errors/remote_exceptions.dart';
import '../../../domain/repositories/network/network_repository.dart';
import '../../models/network/network_actor_projection.dart';
import '../../models/network/network_actor_summary_dto.dart';
import '../../models/network/network_category.dart';
import '../../models/network/network_envelope.dart';
import '../../sources/local/network/network_local_datasource.dart';
import '../../sources/remote/network/network_api_client.dart';
import 'refresh_network_outcome.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkApiClient _client;
  final NetworkLocalDataSource _localDs;

  NetworkRepositoryImpl({
    required NetworkApiClient client,
    required NetworkLocalDataSource localDataSource,
  })  : _client = client,
        _localDs = localDataSource;

  // ──────────────────────────────────────────────────────────────────────────
  // Cache-first read API
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) {
    return _localDs.watchSection(
      workspaceId: workspaceId,
      includeMissing: includeMissing,
    );
  }

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    int? limit,
  }) async {
    try {
      final envelope = await _client.list(
        category: category,
        state: state,
        assetId: assetId,
        cursor: null, // refreshSection siempre es página 1 (snapshot completo
        // cuando nextCursor==null en respuesta).
        limit: limit ?? 50,
      );

      final projections = envelope.items.map((dto) {
        final norm = normalizeForSearch(dto.displayName ?? '');
        return NetworkActorProjection.fromSummaryDto(
          dto,
          displayNameNormalized: norm,
        );
      }).toList(growable: false);

      final isFullSnapshot = envelope.nextCursor == null;

      await _localDs.reconcileFromServer(
        workspaceId: workspaceId,
        incoming: projections,
        isFullSnapshot: isFullSnapshot,
        schemaVersion: envelope.schemaVersion,
        nextCursor: envelope.nextCursor,
        serverTime: envelope.serverTime,
      );

      return RefreshNetworkOutcome.success;
    } on UnauthorizedException {
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: '401',
      );
      return RefreshNetworkOutcome.authError;
    } on ForbiddenException {
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: '403',
      );
      return RefreshNetworkOutcome.forbidden;
    } on NetworkException {
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: 'network',
      );
      return RefreshNetworkOutcome.networkError;
    } on ServerException {
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: 'server',
      );
      return RefreshNetworkOutcome.serverError;
    } on BadRequestException catch (e) {
      // INVALID_CURSOR no aplica aquí (cursor==null en refresh). Cualquier
      // otro BAD_REQUEST cae a unknown.
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: 'badRequest:${e.code ?? "unknown"}',
      );
      return RefreshNetworkOutcome.unknownError;
    } on RequestCancelledException {
      // No marcamos meta — el cancel es decisión del caller, no un fallo.
      return RefreshNetworkOutcome.unknownError;
    } on FormatException {
      // Backend devolvió payload no parseable (schema mismatch, actor
      // malformado, JSON inválido). Cache intacta porque nunca llegamos
      // a reconcileFromServer. Marcamos con errorCode específico para
      // diagnóstico/telemetría. Per-row quarantine es deuda V2 — ver
      // bloque de hardening en el header del archivo.
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: 'parseError',
      );
      return RefreshNetworkOutcome.unknownError;
    } catch (e) {
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: 'unknown',
      );
      return RefreshNetworkOutcome.unknownError;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Legacy delegation (mantenido durante transición)
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> fetchPage({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  }) {
    return _client.list(
      category: category,
      state: state,
      assetId: assetId,
      cursor: cursor,
      limit: limit,
    );
  }

  @override
  Future<NetworkCategoriesSummaryEnvelope> fetchSummary() {
    return _client.getCategoriesSummary();
  }
}
