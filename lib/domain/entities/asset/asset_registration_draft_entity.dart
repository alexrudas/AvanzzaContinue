// ============================================================================
// lib/domain/entities/asset/asset_registration_draft_entity.dart
//
// Entidad de dominio para el draft del wizard de registro de activos.
//
// CONSTANTES DE ESTADO
// DraftRuntStatus y DraftDocumentType viven aquí (domain) para que tanto
// la capa data como presentation puedan usarlas sin violar Clean Architecture.
// ============================================================================

/// Constantes de estado de la consulta RUNT.
///
/// Vivir en domain permite que presentation y data las usen correctamente
/// sin introducir dependencias de capa incorrectas.
abstract final class DraftRuntStatus {
  static const idle = 'idle';
  static const pending = 'pending';
  static const running = 'running';
  static const completed = 'completed';
  static const failed = 'failed';

  static const Set<String> values = {
    idle,
    pending,
    running,
    completed,
    failed,
  };
}

/// Constantes de tipo de documento para la consulta RUNT.
abstract final class DraftDocumentType {
  static const cc = 'CC';
  static const ce = 'CE';
  static const nit = 'NIT';

  static const Set<String> values = {cc, ce, nit};
}

class AssetRegistrationDraftEntity {
  final String draftId;
  final String orgId;

  // Step 1
  final String assetType;
  final String portfolioName;
  final String countryId;
  final String regionId;
  final String cityId;

  // Step 2 input
  final String? documentType;
  final String? documentNumber;
  final String? plate;

  // RUNT job
  final String? runtJobId;
  final String runtStatus;
  final int? runtProgressPercent;
  final String? runtErrorMessage;
  final String? runtProgressJson;
  final String? runtPartialDataJson;
  final String? runtVehicleDataJson;
  final DateTime? runtUpdatedAt;
  final DateTime? runtCompletedAt;

  // Control
  final DateTime updatedAt;

  const AssetRegistrationDraftEntity({
    required this.draftId,
    required this.orgId,
    required this.assetType,
    required this.portfolioName,
    required this.countryId,
    required this.regionId,
    required this.cityId,
    required this.runtStatus,
    required this.updatedAt,
    this.documentType,
    this.documentNumber,
    this.plate,
    this.runtJobId,
    this.runtProgressPercent,
    this.runtErrorMessage,
    this.runtProgressJson,
    this.runtPartialDataJson,
    this.runtVehicleDataJson,
    this.runtUpdatedAt,
    this.runtCompletedAt,
  });

  AssetRegistrationDraftEntity copyWith({
    String? draftId,
    String? orgId,
    String? assetType,
    String? portfolioName,
    String? countryId,
    String? regionId,
    String? cityId,
    String? documentType,
    String? documentNumber,
    String? plate,
    String? runtJobId,
    String? runtStatus,
    int? runtProgressPercent,
    String? runtErrorMessage,
    String? runtProgressJson,
    String? runtPartialDataJson,
    String? runtVehicleDataJson,
    DateTime? runtUpdatedAt,
    DateTime? runtCompletedAt,
    DateTime? updatedAt,
  }) {
    return AssetRegistrationDraftEntity(
      draftId: draftId ?? this.draftId,
      orgId: orgId ?? this.orgId,
      assetType: assetType ?? this.assetType,
      portfolioName: portfolioName ?? this.portfolioName,
      countryId: countryId ?? this.countryId,
      regionId: regionId ?? this.regionId,
      cityId: cityId ?? this.cityId,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      plate: plate ?? this.plate,
      runtJobId: runtJobId ?? this.runtJobId,
      runtStatus: runtStatus ?? this.runtStatus,
      runtProgressPercent: runtProgressPercent ?? this.runtProgressPercent,
      runtErrorMessage: runtErrorMessage ?? this.runtErrorMessage,
      runtProgressJson: runtProgressJson ?? this.runtProgressJson,
      runtPartialDataJson: runtPartialDataJson ?? this.runtPartialDataJson,
      runtVehicleDataJson: runtVehicleDataJson ?? this.runtVehicleDataJson,
      runtUpdatedAt: runtUpdatedAt ?? this.runtUpdatedAt,
      runtCompletedAt: runtCompletedAt ?? this.runtCompletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
