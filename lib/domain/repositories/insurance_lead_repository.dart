// ============================================================================
// lib/domain/repositories/insurance_lead_repository.dart
// INSURANCE LEAD REPOSITORY — Contrato de dominio para leads SRCE.
//
// QUÉ HACE:
// - Define el contrato que la UI/controllers usan para operar leads de
//   cotización de Seguro de Responsabilidad Civil Extracontractual (SRCE).
// - Aísla la capa de presentación de la implementación concreta
//   (HTTP, cache, persistencia futura, etc.).
// - Mantiene tipado fuerte en estados y tipo de seguro para evitar strings
//   mágicos dispersos en la app.
//
// QUÉ NO HACE:
// - No define cómo se obtienen o persisten los datos.
// - No contiene lógica de negocio.
// - No implementa serialización ni networking.
// - No asume detalles de Dio, datasource ni backend.
//
// PRINCIPIOS:
// - Contrato limpio y estable para la capa de presentación.
// - Tipado fuerte en filtros y operaciones críticas.
// - Escrituras desacopladas del shape exacto del response backend.
// - Cero dependencia de infraestructura.
// - Fallback defensivo en enums de dominio: unknown en lugar de null.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE.
// DECISIÓN:
// - updateStatus() y assignProvider() retornan Future<void> para no acoplar
//   el dominio Flutter a un response body que el backend no debe garantizar
//   como fuente de verdad del lead actualizado.
// - El refresco del estado real del lead debe hacerse vía getLead().
// ============================================================================

import '../entities/insurance/insurance_opportunity_lead.dart';

/// Tipo de seguro soportado por el flujo comercial.
///
/// Diseñado para permitir expansión futura sin usar strings mágicos
/// ni nulls dispersos en el dominio.
enum InsuranceLeadType {
  rcExtracontractual,

  /// Fallback defensivo: valor wire no reconocido por esta versión de la app.
  unknown;

  /// Wire value esperado por el backend.
  String get toWire => switch (this) {
        InsuranceLeadType.rcExtracontractual => 'rc_extracontractual',
        InsuranceLeadType.unknown => 'unknown',
      };

  /// Parsea el wire value del backend de forma defensiva.
  static InsuranceLeadType fromWire(String? value) {
    return switch (value) {
      'rc_extracontractual' => InsuranceLeadType.rcExtracontractual,
      _ => InsuranceLeadType.unknown,
    };
  }
}

/// Contrato de dominio para operar leads de cotización SRCE.
///
/// La UI y los controllers deben depender de esta abstracción,
/// no del datasource HTTP concreto.
abstract class InsuranceLeadRepository {
  /// Crea un nuevo lead o retorna el existente si el backend aplica dedup.
  ///
  /// Backend:
  /// - 201 → lead nuevo
  /// - 200 → dedup, lead existente
  ///
  /// Ambos casos son éxito operativo y deben tratarse igual en UI.
  Future<CreateInsuranceLeadResponse> createLead(
    CreateInsuranceLeadRequest request,
  );

  /// Obtiene un lead específico validando tenancy mediante [orgId].
  Future<InsuranceOpportunityLead> getLead({
    required String id,
    required String orgId,
  });

  /// Lista leads de la organización con filtros opcionales.
  Future<List<InsuranceOpportunityLead>> listLeads({
    required String orgId,
    InsuranceLeadStatus? status,
    InsuranceLeadType? insuranceType,
    String? assetId,
  });

  /// Solicita cambio de estado del lead.
  ///
  /// No retorna el lead completo para no acoplar el dominio Flutter a la forma
  /// exacta del response de escritura del backend. Si la UI necesita el estado
  /// actualizado, debe consultar luego con [getLead].
  Future<void> updateStatus({
    required String id,
    required String orgId,
    required InsuranceLeadStatus status,
    String? notes,
  });

  /// Asigna un proveedor al lead.
  ///
  /// No retorna el lead completo por la misma razón que [updateStatus].
  /// Si la UI necesita el lead actualizado, debe refrescar con [getLead].
  Future<void> assignProvider({
    required String id,
    required String orgId,
    required String providerId,
    String? notes,
  });
}
