// ============================================================================
// lib/domain/repositories/network/team_repository.dart
// TEAM REPOSITORY — Contrato dominio para el equipo interno
// ============================================================================
// QUÉ HACE:
//   - Define el contrato para listar/contar miembros activos del equipo
//     interno (membresías ACTIVE del workspace).
//
// EXCEPCIONES DOCUMENTADAS:
//   - `UnauthorizedException`               — sesión inválida.
//   - `ForbiddenException`                  — sin capability team.read.
//   - `UnsupportedSchemaVersionException`   — app desactualizada.
//   - `BadRequestException(code: 'INVALID_CURSOR')` — cursor inválido.
//   - `NetworkException`                    — sin respuesta HTTP.
//   - `ServerException`                     — 5xx.
//
// SEPARACIÓN CON NetworkRepository:
//   - /v1/team y /v1/network requieren capabilities distintas. Un workspace
//     puede tener acceso a uno y no al otro. La UI debe manejar fallos
//     parciales (ej. /network OK + /team 403) sin bloquear toda la pantalla.
// ============================================================================

import '../../../data/models/network/network_envelope.dart';
import '../../../data/models/network/team_member_summary_dto.dart';
import '../../../data/repositories/network/refresh_network_outcome.dart';
import '../../../data/sources/local/network/team_local_datasource.dart';

/// Contrato de la sección equipo interno (Mi equipo en Mi Red Tab 5).
///
/// ═══════════════════════════════════════════════════════════════════════
/// MODELO DE VERDAD (V1) — mismo que NetworkRepository:
///   - Local Isar = VERDAD OPERACIONAL INMEDIATA (lo que el usuario hizo ahora).
///   - Backend Core API = VERDAD CONTRACTUAL CONSOLIDADA (estado canónico).
///   - reconcile() une ambos.
///
/// ⚠ Política LWW V1: TeamMemberSummaryDto trae `updatedAt` REAL del backend
/// (campo requerido del wire contract, parseado estricto con `DateTime.parse`,
/// nunca derivado de `DateTime.now()`). Por tanto LWW es semánticamente
/// válido aquí — mismas advertencias que en Network sobre clock skew,
/// multi-device, etc. Documentado como deuda conceptual en NetworkRepoImpl.
/// ═══════════════════════════════════════════════════════════════════════
abstract class TeamRepository {
  /// Stream cache-first del estado de la sección team para [workspaceId].
  /// Mismo contrato que `NetworkRepository.watchSection`.
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  });

  /// Refresca team contra Core API y reconcilia atómicamente al cache local.
  /// Mismo contrato que `NetworkRepository.refreshSection`. NUNCA lanza hacia
  /// afuera; convierte excepciones a outcomes y marca `meta.syncStatus`.
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    int? limit,
  });

  /// [LEGACY] Trae una página del equipo interno. cursor=null = primera página.
  /// Mantenido para callers existentes durante la transición a cache-first.
  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> fetchPage({
    String? cursor,
    int? limit,
  });

  /// Contador de miembros activos.
  Future<TeamSummaryEnvelope> fetchSummary();
}
