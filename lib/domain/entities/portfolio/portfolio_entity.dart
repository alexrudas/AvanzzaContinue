// ============================================================================
// lib/domain/entities/portfolio/portfolio_entity.dart
// PORTFOLIO ENTITY — Domain Layer / Freezed
//
// QUÉ HACE:
// - Define la entidad de dominio de un portafolio de activos.
// - Incluye un snapshot del propietario VRC, persistido al completar un batch.
//
// QUÉ NO HACE:
// - No contiene lógica de negocio.
// - No accede a Isar ni Firebase directamente.
//
// PRINCIPIOS:
// - Campos del snapshot VRC son todos nullable (@Default(null)):
//   null = portafolio que nunca pasó por batch VRC.
// - Wire-stable: no renombrar campos owner* ni simit* — están en Isar.
//
// ENTERPRISE NOTES:
// CREADO (original): Portafolio base con status DRAFT/ACTIVE.
// ACTUALIZADO (2026-04): +10 campos de snapshot propietario VRC
//   para persistencia entre sesiones (Problema B — Fase SIMIT-1).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_entity.freezed.dart';
part 'portfolio_entity.g.dart';

/// Estado del portafolio
/// - DRAFT: Recién creado, sin activos (no aparece en Home)
/// - ACTIVE: Con al menos 1 activo (aparece en Home)
enum PortfolioStatus {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('ACTIVE')
  active,
}

/// Tipo de portafolio
enum PortfolioType {
  @JsonValue('VEHICULOS')
  vehiculos,
  @JsonValue('INMUEBLES')
  inmuebles,
  @JsonValue('OPERACION_GENERAL')
  operacionGeneral,
}

/// Entidad de Portafolio
/// Agrupa activos del mismo tipo bajo un contenedor lógico
@freezed
abstract class PortfolioEntity with _$PortfolioEntity {
  const factory PortfolioEntity({
    required String id,
    required PortfolioType portfolioType,
    required String portfolioName,
    required String countryId,
    required String cityId,
    /// Partition key del tenant SaaS.
    /// Permite consultar portafolios por organización activa.
    /// Wire-stable: nunca renombrar este campo.
    @Default('') String orgId,
    @Default(PortfolioStatus.draft) PortfolioStatus status,
    @Default(0) int assetsCount,
    required String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,

    // ── Snapshot del propietario VRC ────────────────────────────────────────
    // Persistido al completar un batch VRC (completed | partially_completed).
    // Null cuando el portafolio nunca pasó por un batch VRC.
    // Wire-stable: no renombrar estos campos — están indexados en Isar.
    @Default(null) String? ownerName,
    @Default(null) String? ownerDocument,
    @Default(null) String? ownerDocumentType,
    @Default(null) String? licenseStatus,
    /// Fecha de vencimiento de la licencia (formato "DD/MM/YYYY" del RUNT).
    /// Derivada de la categoría con fecha más tardía en el batch VRC.
    @Default(null) String? licenseExpiryDate,
    @Default(null) bool? simitHasFines,
    /// Conteo total de infracciones SIMIT (todos los tipos).
    @Default(null) int? simitFinesCount,
    /// Comparendos (infracciones de tránsito — dato firme del backend).
    @Default(null) int? simitComparendosCount,
    /// Multas confirmadas (puede ser null si el backend aún no las envía).
    @Default(null) int? simitMultasCount,
    @Default(null) String? simitFormattedTotal,
    /// Timestamp de la consulta VRC que originó este snapshot.
    @Default(null) DateTime? simitCheckedAt,

    /// Timestamp del último refresh exitoso de licencia (RUNT Persona).
    /// Separado de simitCheckedAt — cada fuente tiene su propio ciclo de refresh.
    @Default(null) DateTime? licenseCheckedAt,

    /// JSON blob del bloque owner.simit completo (summary + fines[]).
    ///
    /// Fuente de verdad para el detalle itemizado SIMIT. Se serializa desde
    /// VrcOwnerSimitModel.toJson() al persistir el snapshot y se deserializa
    /// bajo demanda (lazy) solo al navegar a SimitPersonDetailPage.
    /// Null para portfolios creados antes de esta feature (fallback: escalares).
    @Default(null) String? simitDetailJson,
  }) = _PortfolioEntity;

  factory PortfolioEntity.fromJson(Map<String, dynamic> json) =>
      _$PortfolioEntityFromJson(json);
}
