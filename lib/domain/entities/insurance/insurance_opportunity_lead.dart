// ============================================================================
// lib/domain/entities/insurance/insurance_opportunity_lead.dart
// INSURANCE OPPORTUNITY LEAD — Entidad de lead de cotización SRCE.
//
// QUÉ HACE:
// - Modela el lead de cotización de RC Extracontractual.
// - Define InsuranceLeadStatus con fromWire defensivo: valor desconocido
//   del backend → InsuranceLeadStatus.unknown (no crashea).
// - Parsea el lead desde el contrato plano del backend (vehiclePlate,
//   vehicleBrand, etc.) y lo expone como VehicleSnapshot estructurado.
// - Serializa CreateInsuranceLeadRequest con vehicleSnapshot anidado
//   (contrato de escritura).
// - Expone CreateInsuranceLeadResponse.fromJson() que lee el campo "created".
//
// QUÉ NO HACE:
// - No persiste en Isar — entidad de sesión HTTP only (MVP).
// - No calcula ni interpreta estados de cobertura.
// - No decide visibilidad ni lógica de negocio.
//
// PRINCIPIOS:
// - fromWire defensivo: unknown en lugar de throw ante valores inesperados.
// - camelCase exacto según contrato backend — sin transformaciones.
// - Lectura plana (vehiclePlate…) / escritura anidada (vehicleSnapshot{}).
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE — modelo base del flujo
//   cotización → proveedor → cierre. No persiste en Isar en MVP.
// ============================================================================

// ─────────────────────────────────────────────────────────────────────────────
// STATUS ENUM
// ─────────────────────────────────────────────────────────────────────────────

/// Estado del lead en el pipeline comercial.
///
/// [fromWire] garantiza que valores desconocidos del backend no crasheen la app.
enum InsuranceLeadStatus {
  requested,
  assigned,
  quoted,
  accepted,
  rejected,
  expired,
  issued,

  /// El solicitante expresó interés en la cotización recibida.
  interested,

  /// El solicitante descartó la cotización desde la app.
  rejectedByUser,

  /// Fallback defensivo: valor enviado por backend no reconocido en esta versión.
  unknown;

  /// Parsea el string wire del backend. Si no coincide → [unknown].
  static InsuranceLeadStatus fromWire(String? value) {
    if (value == null) return InsuranceLeadStatus.unknown;
    return InsuranceLeadStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InsuranceLeadStatus.unknown,
    );
  }

  String get toWire => name;
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE SNAPSHOT
//
// Usado en dos contextos:
//   Lectura  — construido desde campos planos del backend (vehiclePlate, etc.)
//   Escritura — serializado como objeto anidado en vehicleSnapshot{}
// ─────────────────────────────────────────────────────────────────────────────

class VehicleSnapshot {
  final String plate;
  final String brand;
  final String model;
  final int year;
  final String vehicleClass;
  final String service;

  const VehicleSnapshot({
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.vehicleClass,
    required this.service,
  });

  /// Serializa como objeto anidado para POST /insurance/leads.
  Map<String, dynamic> toJson() => {
        'plate': plate,
        'brand': brand,
        'model': model,
        'year': year,
        'vehicleClass': vehicleClass,
        'service': service,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// LEAD ENTITY
// ─────────────────────────────────────────────────────────────────────────────

class InsuranceOpportunityLead {
  final String id;
  final String assetId;
  final String orgId;
  final String requesterUserId;
  final String insuranceType;
  final String source;
  final VehicleSnapshot vehicleSnapshot;
  final InsuranceLeadStatus status;
  final String? assignedProviderId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InsuranceOpportunityLead({
    required this.id,
    required this.assetId,
    required this.orgId,
    required this.requesterUserId,
    required this.insuranceType,
    required this.source,
    required this.vehicleSnapshot,
    required this.status,
    this.assignedProviderId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parsea el lead desde el contrato plano del backend.
  ///
  /// El backend devuelve los datos del vehículo como campos de primer nivel
  /// (vehiclePlate, vehicleBrand, etc.), no como objeto anidado.
  factory InsuranceOpportunityLead.fromJson(Map<String, dynamic> json) {
    return InsuranceOpportunityLead(
      id: json['id'] as String? ?? '',
      assetId: json['assetId'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      requesterUserId: json['requesterUserId'] as String? ?? '',
      insuranceType: json['insuranceType'] as String? ?? '',
      source: json['source'] as String? ?? '',
      vehicleSnapshot: VehicleSnapshot(
        plate: json['vehiclePlate'] as String? ?? '',
        brand: json['vehicleBrand'] as String? ?? '',
        model: json['vehicleModel'] as String? ?? '',
        year: (json['vehicleYear'] as num?)?.toInt() ?? 0,
        vehicleClass: json['vehicleClass'] as String? ?? '',
        service: json['vehicleService'] as String? ?? '',
      ),
      status: InsuranceLeadStatus.fromWire(json['status'] as String?),
      assignedProviderId: json['assignedProviderId'] as String?,
      notes: json['notes'] as String?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) return DateTime.tryParse(value)?.toLocal() ?? DateTime.now();
    return DateTime.now();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE REQUEST
// ─────────────────────────────────────────────────────────────────────────────

/// Payload para POST /insurance/leads.
///
/// El backend espera vehicleSnapshot como objeto anidado en escritura.
class CreateInsuranceLeadRequest {
  final String orgId;
  final String assetId;
  final String requesterUserId;
  final String insuranceType;
  final String source;
  final VehicleSnapshot vehicleSnapshot;

  const CreateInsuranceLeadRequest({
    required this.orgId,
    required this.assetId,
    required this.requesterUserId,
    required this.insuranceType,
    required this.source,
    required this.vehicleSnapshot,
  });

  Map<String, dynamic> toJson() => {
        'orgId': orgId,
        'assetId': assetId,
        'requesterUserId': requesterUserId,
        'insuranceType': insuranceType,
        'source': source,
        'vehicleSnapshot': vehicleSnapshot.toJson(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE RESPONSE
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado de POST /insurance/leads.
///
/// [wasCreated] lee el campo "created" del backend:
///   true  → 201 (lead nuevo)
///   false → 200 (dedup — lead ya existía)
///
/// Ambos son éxito operativo — la UI los trata igual.
class CreateInsuranceLeadResponse {
  final bool wasCreated;
  final InsuranceOpportunityLead lead;

  const CreateInsuranceLeadResponse({
    required this.wasCreated,
    required this.lead,
  });

  factory CreateInsuranceLeadResponse.fromJson(Map<String, dynamic> json) {
    return CreateInsuranceLeadResponse(
      wasCreated: json['created'] as bool? ?? false,
      lead: InsuranceOpportunityLead.fromJson(
        json['lead'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
