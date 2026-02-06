// ============================================================================
// lib/domain/entities/asset/asset_draft.dart
// DRAFT TEMPORAL DE ACTIVO - Estado pre-confirmación de propiedad
//
// - Representa un activo en proceso de registro (wizard)
// - Persiste localmente mientras el usuario completa el flujo
// - SE ELIMINA tras conversión exitosa a AssetEntity
// - Nunca se sincroniza a Firestore (solo local)
//
// SIN anotaciones Isar. Las entidades Isar van en Infraestructura.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/safe_datetime_converter.dart';
import 'asset_content.dart';
import 'asset_entity.dart';
import 'asset_snapshot.dart';

part 'asset_draft.freezed.dart';
part 'asset_draft.g.dart';

// ============================================================================
// DRAFT STATUS
// ============================================================================

/// Estado del draft en el wizard de registro.
enum DraftStatus {
  /// Paso 1: Identificación del activo (placa, matrícula, etc.)
  @JsonValue('IDENTIFICATION')
  identification,

  /// Paso 2: Datos obtenidos/validados (snapshot capturado)
  @JsonValue('DATA_CAPTURED')
  dataCaptured,

  /// Paso 3: Asignación de propietario beneficiario
  @JsonValue('OWNERSHIP_PENDING')
  ownershipPending,

  /// Listo para finalizar (convertir a AssetEntity)
  @JsonValue('READY_TO_FINALIZE')
  readyToFinalize,

  /// Abandonado (puede limpiarse)
  @JsonValue('ABANDONED')
  abandoned,
}

// ============================================================================
// ASSET DRAFT
// ============================================================================

/// Draft temporal de activo durante el wizard de registro.
///
/// REGLAS:
/// - Solo persiste localmente (Isar), NUNCA se sincroniza a Firestore.
/// - SE ELIMINA tras conversión exitosa a AssetEntity.
/// - Puede abandonarse y limpiarse posteriormente.
/// - Guarda el snapshot para auditoría al finalizar.
@Freezed()
abstract class AssetDraft with _$AssetDraft {
  const AssetDraft._();

  const factory AssetDraft({
    /// ID único del draft (UUID v4)
    required String id,

    /// Tipo de activo que se está registrando
    required AssetType assetType,

    /// Estado actual del draft en el wizard
    @Default(DraftStatus.identification) DraftStatus status,

    /// Identificador primario ingresado (placa, matrícula, serial)
    /// Normalizado: MAYÚSCULAS, trim
    String? primaryIdentifier,

    /// Contenido del activo (null hasta capturar datos)
    AssetContent? content,

    /// Snapshot capturado (datos RAW de fuente oficial)
    AssetSnapshot? snapshot,

    /// Propietario legal extraído del snapshot
    LegalOwner? legalOwner,

    /// Propietario beneficiario seleccionado por el usuario
    BeneficialOwner? beneficialOwner,

    /// Portfolio destino (si se seleccionó)
    String? targetPortfolioId,

    /// Metadatos del wizard (paso actual, errores, etc.)
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,

    /// Fecha de creación del draft
    @SafeDateTimeConverter() required DateTime createdAt,

    /// Fecha de última actualización
    @SafeDateTimeConverter() required DateTime updatedAt,

    /// Usuario que inició el registro
    required String createdBy,
  }) = _AssetDraft;

  factory AssetDraft.fromJson(Map<String, dynamic> json) =>
      _$AssetDraftFromJson(json);

  // ==========================================================================
  // FACTORY: Crear nuevo draft
  // ==========================================================================

  /// Crea un nuevo draft para iniciar el wizard de registro.
  factory AssetDraft.create({
    required String id,
    required AssetType assetType,
    required String createdBy,
    String? primaryIdentifier,
  }) {
    final now = DateTime.now().toUtc();
    return AssetDraft(
      id: id,
      assetType: assetType,
      status: DraftStatus.identification,
      primaryIdentifier: primaryIdentifier,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
    );
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get hasContent => content != null;
  bool get hasSnapshot => snapshot != null;
  bool get hasLegalOwner => legalOwner != null;
  bool get hasBeneficialOwner => beneficialOwner != null;

  bool get canFinalize =>
      status == DraftStatus.readyToFinalize &&
      content != null &&
      beneficialOwner != null;

  bool get isAbandoned => status == DraftStatus.abandoned;

  /// Calcula el assetKey que tendrá el Asset final (si hay contenido).
  String? get previewAssetKey => content?.assetKey;
}

// ============================================================================
// HELPERS
// ============================================================================

/// Deriva el AssetType desde un AssetContent.
AssetType _deriveAssetType(AssetContent content) {
  return content.map(
    vehicle: (_) => AssetType.vehicle,
    realEstate: (_) => AssetType.realEstate,
    machinery: (_) => AssetType.machinery,
    equipment: (_) => AssetType.equipment,
  );
}

// ============================================================================
// TRANSICIONES DE ESTADO DEL DRAFT
// ============================================================================

extension AssetDraftTransitions on AssetDraft {
  /// Avanza al estado de datos capturados (tras obtener snapshot).
  ///
  /// Throws [StateError] si el tipo de contenido no coincide con assetType.
  AssetDraft captureData({
    required AssetContent content,
    required AssetSnapshot snapshot,
    LegalOwner? legalOwner,
  }) {
    if (status != DraftStatus.identification) {
      throw StateError('captureData solo válido desde IDENTIFICATION');
    }

    // Validación: el tipo de contenido debe coincidir con assetType del draft
    final derivedType = _deriveAssetType(content);
    if (derivedType != assetType) {
      throw StateError(
        'Tipo de contenido ($derivedType) no coincide con assetType del draft ($assetType)',
      );
    }

    return copyWith(
      status: DraftStatus.dataCaptured,
      content: content,
      snapshot: snapshot,
      legalOwner: legalOwner,
      primaryIdentifier: content.assetKey,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Avanza al estado de asignación de propietario.
  AssetDraft proceedToOwnership() {
    if (status != DraftStatus.dataCaptured) {
      throw StateError('proceedToOwnership solo válido desde DATA_CAPTURED');
    }
    return copyWith(
      status: DraftStatus.ownershipPending,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Asigna propietario beneficiario y marca como listo.
  AssetDraft assignBeneficialOwner(BeneficialOwner owner) {
    if (status != DraftStatus.ownershipPending) {
      throw StateError(
          'assignBeneficialOwner solo válido desde OWNERSHIP_PENDING');
    }
    return copyWith(
      status: DraftStatus.readyToFinalize,
      beneficialOwner: owner,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Marca el draft como abandonado.
  AssetDraft abandon() {
    return copyWith(
      status: DraftStatus.abandoned,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Convierte el draft a AssetEntity final.
  ///
  /// El Asset se crea en estado [AssetState.pendingOwnership] porque
  /// aún requiere verificación/confirmación antes de pasar a verified/active.
  ///
  /// TODO: Definir use-cases para transiciones pendingOwnership → verified → active.
  ///
  /// IMPORTANTE: Tras llamar este método, el draft DEBE eliminarse.
  AssetEntity toAssetEntity({required String assetId}) {
    if (!canFinalize) {
      throw StateError(
        'Draft no puede finalizarse: '
        'status=$status, content=${content != null}, '
        'beneficialOwner=${beneficialOwner != null}',
      );
    }

    return AssetEntity.create(
      id: assetId,
      content: content!,
      legalOwner: legalOwner,
      beneficialOwner: beneficialOwner,
      snapshotId: snapshot?.id,
      portfolioId: targetPortfolioId,
      state: AssetState.pendingOwnership,
    );
  }
}
