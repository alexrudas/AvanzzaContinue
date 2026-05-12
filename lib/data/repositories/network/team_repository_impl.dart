// ============================================================================
// lib/data/repositories/network/team_repository_impl.dart
// TEAM REPOSITORY IMPL — Cache-first / Local-first (Fase 4 Paso 3b)
// ============================================================================
//
// ═══════════════════════════════════════════════════════════════════════════
// MODELO DE VERDAD V1 (paridad con NetworkRepositoryImpl):
//   - Local Isar       = VERDAD OPERACIONAL INMEDIATA.
//   - Backend Core API = VERDAD CONTRACTUAL CONSOLIDADA.
//   - reconcile()      = arbitrar local ↔ backend sin destruir verdad
//     operacional. LWW por `updatedAt` (ver ⚠ abajo).
// ═══════════════════════════════════════════════════════════════════════════
//
// ⚠ Política LWW V1 — SIMPLIFICACIÓN TEMPORAL ⚠
//   Aplica IDÉNTICA a NetworkRepositoryImpl. Documentación de fallas
//   previsibles y migración futura vive en ese archivo (single source).
//
// VERIFICACIÓN preventiva del campo temporal (Paso 3b — gate del usuario):
//   - `TeamMemberSummaryDto.updatedAt` es campo REQUERIDO del wire (no
//     opcional). Parser usa `DateTime.parse(json['updatedAt'])` ESTRICTO
//     (lanza FormatException si falta). NO se deriva de `DateTime.now()`.
//   - Backend emite el valor; cliente lo preserva 1:1 hasta el cache.
//   - Conclusión: LWW por updatedAt es semánticamente VÁLIDO para team,
//     misma garantía que network. No requiere degradación.
//
// ⚠ HARDENING — PER-ROW QUARANTINE NO IMPLEMENTADO EN V1 (paridad Network) ⚠
//   Si un miembro del equipo viene malformado en la respuesta, toda la página
//   se rechaza con FormatException. Cache local PRESERVADA, outcome reportado
//   como `unknownError` con `meta.lastErrorCode='parseError'`. Per-row
//   quarantine es deuda V2 documentada en NetworkRepositoryImpl.
//
// QUÉ NO HACE:
//   - No mantiene estado. Cursor + filtros viven en el controller.
//   - No bloquea read path en HTTP.
//   - No reintenta automáticamente.
// ============================================================================

import '../../../core/utils/text_normalization.dart';
import '../../../domain/errors/remote_exceptions.dart';
import '../../../domain/repositories/network/team_repository.dart';
import '../../models/network/network_envelope.dart';
import '../../models/network/team_actor_projection.dart';
import '../../models/network/team_member_summary_dto.dart';
import '../../sources/local/network/team_local_datasource.dart';
import '../../sources/remote/network/team_api_client.dart';
import 'refresh_network_outcome.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamApiClient _client;
  final TeamLocalDataSource _localDs;

  TeamRepositoryImpl({
    required TeamApiClient client,
    required TeamLocalDataSource localDataSource,
  })  : _client = client,
        _localDs = localDataSource;

  // ──────────────────────────────────────────────────────────────────────────
  // Cache-first read API
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Stream<TeamSectionSnapshot> watchSection({
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
    int? limit,
  }) async {
    try {
      final envelope = await _client.list(
        cursor: null,
        limit: limit ?? 50,
      );

      final projections = envelope.items.map((dto) {
        final norm = normalizeForSearch(dto.displayName ?? '');
        return TeamActorProjection.fromSummaryDto(
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
      await _localDs.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: 'badRequest:${e.code ?? "unknown"}',
      );
      return RefreshNetworkOutcome.unknownError;
    } on RequestCancelledException {
      return RefreshNetworkOutcome.unknownError;
    } on FormatException {
      // Paridad con NetworkRepositoryImpl — ver hardening en su header.
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
  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> fetchPage({
    String? cursor,
    int? limit,
  }) {
    return _client.list(cursor: cursor, limit: limit);
  }

  @override
  Future<TeamSummaryEnvelope> fetchSummary() {
    return _client.getSummary();
  }
}
