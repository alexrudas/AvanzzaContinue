// ============================================================================
// lib/data/models/asset/asset_registration_draft_model.dart
//
// ASSET REGISTRATION DRAFT MODEL — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Persistir en Isar el estado completo del wizard de registro de activos.
//
// ESTE DRAFT DEBE SOBREVIVIR A:
// - navegación entre Step1 y Step2
// - reconstrucción de widgets
// - cierre y reapertura de la app
// - consulta RUNT en progreso
// - restauración de resultados parciales o finales del RUNT
//
// ALCANCE DEL DRAFT
// - datos del Step 1
// - datos del Step 2
// - metadata del job RUNT
// - progreso por bloques
// - datos parciales del RUNT
// - datos finales del RUNT
//
// DECISIÓN DE DISEÑO
// Se usa Isar porque esto es estado de negocio transaccional del wizard,
// no preferencias de UI. Por eso NO corresponde usar SharedPreferences.
//
// NOTA SOBRE TIPOS
// Algunos campos se persisten como String por simplicidad de infraestructura,
// pero sus valores válidos están centralizados en constantes para evitar
// errores por strings arbitrarios.
//
// DESPUÉS DE MODIFICAR
// Ejecutar:
//   flutter pub run build_runner build --delete-conflicting-outputs
//
// Y asegurar que el schema correspondiente quede incluido en:
//   isar_schemas.dart
// ============================================================================

import 'package:isar_community/isar.dart';

part 'asset_registration_draft_model.g.dart';

/// Valores permitidos para [assetType].
abstract final class AssetDraftAssetTypes {
  static const String vehicle = 'vehicle';
  static const String realEstate = 'real_estate';
  static const String machinery = 'machinery';
  static const String equipment = 'equipment';
  static const String other = 'other';

  static const Set<String> values = {
    vehicle,
    realEstate,
    machinery,
    equipment,
    other,
  };
}

/// Valores permitidos para [documentType].
abstract final class AssetDraftDocumentTypes {
  static const String cc = 'CC';
  static const String ce = 'CE';
  static const String nit = 'NIT';
  static const String passport = 'PASSPORT';
  static const String foreignId = 'TI';

  static const Set<String> values = {
    cc,
    ce,
    nit,
    passport,
    foreignId,
  };
}

/// Valores permitidos para [runtStatus].
abstract final class AssetDraftRuntStatuses {
  static const String idle = 'idle';
  static const String pending = 'pending';
  static const String running = 'running';
  static const String completed = 'completed';
  static const String failed = 'failed';

  static const Set<String> values = {
    idle,
    pending,
    running,
    completed,
    failed,
  };
}

@Collection()
class AssetRegistrationDraftModel {
  // ignore: avoid_positional_boolean_parameters
  AssetRegistrationDraftModel();

  // ───────────────────────────────────────────────────────────────────────────
  // IDENTIDAD / SCOPING
  // ───────────────────────────────────────────────────────────────────────────

  /// Clave primaria interna de Isar.
  Id isarId = Isar.autoIncrement;

  /// Identificador funcional del draft.
  ///
  /// Regla actual:
  /// - coincide normalmente con el portfolioId generado en Step1
  /// - se usa para recuperar el draft a lo largo del wizard
  @Index(unique: true, replace: true)
  late String draftId;

  /// Organización propietaria del draft.
  @Index()
  late String orgId;

  // ───────────────────────────────────────────────────────────────────────────
  // STEP 1
  // ───────────────────────────────────────────────────────────────────────────

  /// Tipo de activo.
  ///
  /// Valores esperados: ver [AssetDraftAssetTypes].
  late String assetType;

  /// Nombre del portafolio.
  late String portfolioName;

  /// País seleccionado.
  late String countryId;

  /// Región / Estado seleccionado.
  late String regionId;

  /// Ciudad seleccionada.
  late String cityId;

  // ───────────────────────────────────────────────────────────────────────────
  // STEP 2 — INPUT DE CONSULTA
  // ───────────────────────────────────────────────────────────────────────────

  /// Tipo de documento del propietario.
  ///
  /// Valores esperados: ver [AssetDraftDocumentTypes].
  String? documentType;

  /// Número de documento del propietario.
  ///
  /// Puede ser null mientras el usuario no lo haya ingresado.
  String? documentNumber;

  /// Placa ingresada por el usuario.
  ///
  /// Se conserva para permitir corrección manual o "Nueva consulta"
  /// sin obligar a reescribir todo.
  String? plate;

  // ───────────────────────────────────────────────────────────────────────────
  // STEP 2 — ESTADO DE JOB RUNT
  // ───────────────────────────────────────────────────────────────────────────

  /// ID del job asíncrono creado en backend.
  String? runtJobId;

  /// Estado global del job RUNT.
  ///
  /// Valores esperados: ver [AssetDraftRuntStatuses].
  late String runtStatus;

  /// Progreso porcentual del job, si existe.
  int? runtProgressPercent;

  /// Mensaje de error si la consulta falló.
  String? runtErrorMessage;

  /// Progreso por bloques serializado en JSON.
  ///
  /// Ejemplo:
  /// {
  ///   "vehicle": "done",
  ///   "owner": "loading",
  ///   "soat": "pending",
  ///   "rtm": "pending",
  ///   "history": "pending"
  /// }
  String? runtProgressJson;

  /// Datos parciales del RUNT serializados en JSON.
  ///
  /// Ejemplo:
  /// {
  ///   "vehicle": {...},
  ///   "owner": {...}
  /// }
  ///
  /// Permite reconstruir la UI de progreso enriquecido antes de que
  /// el job termine completamente.
  String? runtPartialDataJson;

  /// Datos finales del RUNT serializados en JSON.
  ///
  /// Solo debería existir cuando runtStatus == completed.
  String? runtVehicleDataJson;

  /// Último timestamp de actualización del job RUNT, si backend lo provee.
  DateTime? runtUpdatedAt;

  /// Timestamp de finalización del job RUNT, si backend lo provee.
  DateTime? runtCompletedAt;

  // ───────────────────────────────────────────────────────────────────────────
  // CONTROL
  // ───────────────────────────────────────────────────────────────────────────

  /// Última modificación del draft.
  late DateTime updatedAt;

  // ───────────────────────────────────────────────────────────────────────────
  // FACTORIES
  // ───────────────────────────────────────────────────────────────────────────

  /// Crea un draft inicial a partir del Step 1.
  factory AssetRegistrationDraftModel.fromStep1({
    required String draftId,
    required String orgId,
    required String assetType,
    required String portfolioName,
    required String countryId,
    required String regionId,
    required String cityId,
  }) {
    assert(draftId.trim().isNotEmpty, 'draftId no puede estar vacío');
    assert(orgId.trim().isNotEmpty, 'orgId no puede estar vacío');
    assert(
      AssetDraftAssetTypes.values.contains(assetType),
      'assetType inválido: $assetType',
    );

    return AssetRegistrationDraftModel()
      ..draftId = draftId.trim()
      ..orgId = orgId.trim()
      ..assetType = assetType
      ..portfolioName = portfolioName.trim()
      ..countryId = countryId.trim()
      ..regionId = regionId.trim()
      ..cityId = cityId.trim()
      ..documentType = null
      ..documentNumber = null
      ..plate = null
      ..runtJobId = null
      ..runtStatus = AssetDraftRuntStatuses.idle
      ..runtProgressPercent = 0
      ..runtErrorMessage = null
      ..runtProgressJson = null
      ..runtPartialDataJson = null
      ..runtVehicleDataJson = null
      ..runtUpdatedAt = null
      ..runtCompletedAt = null
      ..updatedAt = DateTime.now().toUtc();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MUTACIONES SEGURAS
  // ───────────────────────────────────────────────────────────────────────────

  /// Crea una copia del draft con los campos actualizados.
  ///
  /// Diseñado para evitar mutaciones dispersas y mantener un patrón claro
  /// de actualización del wizard.
  AssetRegistrationDraftModel copyWith({
    // Identidad / scoping
    String? draftId,
    String? orgId,

    // Step 1
    String? assetType,
    String? portfolioName,
    String? countryId,
    String? regionId,
    String? cityId,

    // Step 2 input
    String? documentType,
    String? documentNumber,
    String? plate,

    // RUNT
    String? runtJobId,
    String? runtStatus,
    int? runtProgressPercent,
    String? runtErrorMessage,
    String? runtProgressJson,
    String? runtPartialDataJson,
    String? runtVehicleDataJson,
    DateTime? runtUpdatedAt,
    DateTime? runtCompletedAt,

    // Acciones
    bool clearRunt = false,
  }) {
    final copy = AssetRegistrationDraftModel()
      ..isarId = isarId
      ..draftId = (draftId ?? this.draftId).trim()
      ..orgId = (orgId ?? this.orgId).trim()
      ..assetType = assetType ?? this.assetType
      ..portfolioName = (portfolioName ?? this.portfolioName).trim()
      ..countryId = (countryId ?? this.countryId).trim()
      ..regionId = (regionId ?? this.regionId).trim()
      ..cityId = (cityId ?? this.cityId).trim()
      ..documentType = documentType ?? this.documentType
      ..documentNumber = documentNumber ?? this.documentNumber
      ..plate = plate ?? this.plate
      ..runtJobId = clearRunt ? null : (runtJobId ?? this.runtJobId)
      ..runtStatus = clearRunt
          ? AssetDraftRuntStatuses.idle
          : (runtStatus ?? this.runtStatus)
      ..runtProgressPercent =
          clearRunt ? 0 : (runtProgressPercent ?? this.runtProgressPercent)
      ..runtErrorMessage =
          clearRunt ? null : (runtErrorMessage ?? this.runtErrorMessage)
      ..runtProgressJson =
          clearRunt ? null : (runtProgressJson ?? this.runtProgressJson)
      ..runtPartialDataJson =
          clearRunt ? null : (runtPartialDataJson ?? this.runtPartialDataJson)
      ..runtVehicleDataJson =
          clearRunt ? null : (runtVehicleDataJson ?? this.runtVehicleDataJson)
      ..runtUpdatedAt = clearRunt ? null : (runtUpdatedAt ?? this.runtUpdatedAt)
      ..runtCompletedAt =
          clearRunt ? null : (runtCompletedAt ?? this.runtCompletedAt)
      ..updatedAt = DateTime.now().toUtc();

    return copy;
  }

  /// Limpia exclusivamente el estado RUNT.
  ///
  /// Intención:
  /// - soportar "Nueva consulta"
  /// - conservar Step 1
  /// - conservar tipo/número de documento
  /// - conservar la placa por defecto para facilitar corrección manual
  ///
  /// Si el caller quiere borrar la placa, debe hacerlo explícitamente:
  ///   copyWith(plate: null).clearRuntState()
  AssetRegistrationDraftModel clearRuntState() {
    return copyWith(clearRunt: true);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HELPERS DE ESTADO
  // ───────────────────────────────────────────────────────────────────────────

  bool get hasStep1CoreData =>
      draftId.trim().isNotEmpty &&
      orgId.trim().isNotEmpty &&
      assetType.trim().isNotEmpty &&
      portfolioName.trim().isNotEmpty &&
      countryId.trim().isNotEmpty &&
      regionId.trim().isNotEmpty &&
      cityId.trim().isNotEmpty;

  bool get hasDocumentData =>
      documentType != null &&
      documentType!.trim().isNotEmpty &&
      documentNumber != null &&
      documentNumber!.trim().isNotEmpty;

  bool get hasPlate => plate != null && plate!.trim().isNotEmpty;

  bool get hasRuntJob => runtJobId != null && runtJobId!.trim().isNotEmpty;

  bool get hasRuntProgress =>
      runtProgressJson != null && runtProgressJson!.trim().isNotEmpty;

  bool get hasRuntPartialData =>
      runtPartialDataJson != null && runtPartialDataJson!.trim().isNotEmpty;

  bool get hasRuntFinalData =>
      runtVehicleDataJson != null && runtVehicleDataJson!.trim().isNotEmpty;

  bool get isRuntIdle => runtStatus == AssetDraftRuntStatuses.idle;
  bool get isRuntPending => runtStatus == AssetDraftRuntStatuses.pending;
  bool get isRuntRunning => runtStatus == AssetDraftRuntStatuses.running;
  bool get isRuntCompleted => runtStatus == AssetDraftRuntStatuses.completed;
  bool get isRuntFailed => runtStatus == AssetDraftRuntStatuses.failed;

  // ───────────────────────────────────────────────────────────────────────────
  // VALIDACIONES LIGERAS
  // ───────────────────────────────────────────────────────────────────────────

  /// Sanity check ligero para debugging e integridad básica.
  ///
  /// No reemplaza validaciones de dominio ni de use case.
  bool get hasValidCoreEnums {
    final assetTypeOk = AssetDraftAssetTypes.values.contains(assetType);
    final documentTypeOk = documentType == null ||
        AssetDraftDocumentTypes.values.contains(documentType);
    final runtStatusOk = AssetDraftRuntStatuses.values.contains(runtStatus);

    return assetTypeOk && documentTypeOk && runtStatusOk;
  }
}
