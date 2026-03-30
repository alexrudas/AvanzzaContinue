// ============================================================================
// lib/data/repositories/insurance_lead_repository_impl.dart
// INSURANCE LEAD REPOSITORY IMPL — Implementación HTTP del contrato de leads.
//
// QUÉ HACE:
// - Implementa InsuranceLeadRepository delegando en InsuranceLeadRemoteDs.
// - Convierte tipos de dominio → wire antes de llamar al datasource:
//     InsuranceLeadStatus → status.toWire  (en updateStatus)
//     InsuranceLeadType   → type.toWire    (en listLeads)
// - No envía InsuranceLeadType.unknown al backend: lo convierte en null.
//
// QUÉ NO HACE:
// - No persiste en Isar (MVP HTTP only).
// - No interpreta ni transforma respuestas de dominio.
// - No atrapa excepciones — las propaga al controller/UI para decisión.
//
// PRINCIPIOS:
// - Una sola responsabilidad de mapping dominio → wire: aquí, en el impl.
// - El datasource recibe solo primitivos (String?).
// - Simetría: listLeads, updateStatus y assignProvider siguen el mismo patrón.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE.
// ============================================================================

import '../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../domain/repositories/insurance_lead_repository.dart';
import '../sources/remote/insurance_lead_remote_ds.dart';

class InsuranceLeadRepositoryImpl implements InsuranceLeadRepository {
  final InsuranceLeadRemoteDs _remote;

  InsuranceLeadRepositoryImpl(this._remote);

  @override
  Future<CreateInsuranceLeadResponse> createLead(
    CreateInsuranceLeadRequest request,
  ) =>
      _remote.createLead(request);

  @override
  Future<InsuranceOpportunityLead> getLead({
    required String id,
    required String orgId,
  }) =>
      _remote.getLead(id: id, orgId: orgId);

  @override
  Future<List<InsuranceOpportunityLead>> listLeads({
    required String orgId,
    InsuranceLeadStatus? status,
    InsuranceLeadType? insuranceType,
    String? assetId,
  }) =>
      _remote.listLeads(
        orgId: orgId,
        status: status?.toWire,
        // unknown no es un filtro válido — no enviar al backend.
        insuranceType: (insuranceType == InsuranceLeadType.unknown)
            ? null
            : insuranceType?.toWire,
        assetId: assetId,
      );

  @override
  Future<void> updateStatus({
    required String id,
    required String orgId,
    required InsuranceLeadStatus status,
    String? notes,
  }) =>
      _remote.updateStatus(
        id: id,
        orgId: orgId,
        status: status.toWire, // conversión dominio → wire aquí
        notes: notes,
      );

  @override
  Future<void> assignProvider({
    required String id,
    required String orgId,
    required String providerId,
    String? notes,
  }) =>
      _remote.assignProvider(
        id: id,
        orgId: orgId,
        providerId: providerId,
        notes: notes,
      );
}
