// ============================================================================
// lib/domain/entities/asset/asset_entity.dart
// ENTIDAD PRINCIPAL DE ACTIVO - Dominio Puro (Freezed + JSON)
//
// SIN anotaciones Isar. Las entidades Isar van en Infraestructura.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/safe_datetime_converter.dart';
import 'asset_content.dart';

part 'asset_entity.freezed.dart';
part 'asset_entity.g.dart';

// ============================================================================
// HELPERS
// ============================================================================

/// Hash estable para generar Id Isar desde String UUID.
/// Retorna solo 63 bits positivos para compatibilidad Isar.
/// Se usa en infraestructura para mapear a Isar.
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash & 0x7FFFFFFFFFFFFFFF;
}

// ============================================================================
// ENUMS
// ============================================================================

enum AssetState {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('PENDING_OWNERSHIP')
  pendingOwnership,
  @JsonValue('VERIFIED')
  verified,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('ARCHIVED')
  archived,
}

enum AssetType {
  @JsonValue('vehicle')
  vehicle,
  @JsonValue('real_estate')
  realEstate,
  @JsonValue('machinery')
  machinery,
  @JsonValue('equipment')
  equipment,
}

// ============================================================================
// LEGAL OWNER
// ============================================================================

@Freezed()
abstract class LegalOwner with _$LegalOwner {
  const factory LegalOwner({
    required String documentType,
    required String documentNumber,
    required String name,
    required String source,
    @SafeDateTimeConverter() required DateTime verifiedAt,
  }) = _LegalOwner;

  factory LegalOwner.fromJson(Map<String, dynamic> json) =>
      _$LegalOwnerFromJson(json);
}

// ============================================================================
// BENEFICIAL OWNER
// ============================================================================

enum BeneficialOwnerType {
  @JsonValue('user')
  user,
  @JsonValue('org')
  org,
}

enum OwnershipRelationship {
  @JsonValue('owner')
  owner,
  @JsonValue('manager')
  manager,
  @JsonValue('operator')
  operator_,
  @JsonValue('lessee')
  lessee,
}

@Freezed()
abstract class BeneficialOwner with _$BeneficialOwner {
  const factory BeneficialOwner({
    required BeneficialOwnerType ownerType,
    required String ownerId,
    required String ownerName,
    required OwnershipRelationship relationship,
    @SafeDateTimeConverter() required DateTime assignedAt,
    required String assignedBy,
  }) = _BeneficialOwner;

  factory BeneficialOwner.fromJson(Map<String, dynamic> json) =>
      _$BeneficialOwnerFromJson(json);
}

// ============================================================================
// ASSET ENTITY V2
// ============================================================================

@Freezed()
abstract class AssetEntity with _$AssetEntity {
  const AssetEntity._();

  const factory AssetEntity({
    required String id,

    /// assetKey derivado del contenido (INVARIANTE: == content.assetKey)
    required String assetKey,
    required AssetType type,
    @Default(AssetState.draft) AssetState state,
    required AssetContent content,
    LegalOwner? legalOwner,
    BeneficialOwner? beneficialOwner,
    String? snapshotId,
    String? portfolioId,
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
    @SafeDateTimeConverter() required DateTime createdAt,
    @SafeDateTimeConverter() required DateTime updatedAt,
  }) = _AssetEntity;

  factory AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);

  // ==========================================================================
  // FACTORY: Crear con assetKey derivado del contenido
  // ==========================================================================

  factory AssetEntity.create({
    required String id,
    required AssetContent content,
    LegalOwner? legalOwner,
    BeneficialOwner? beneficialOwner,
    String? snapshotId,
    String? portfolioId,
    AssetState state = AssetState.draft,
    Map<String, dynamic> metadata = const {},
  }) {
    final derivedAssetKey = content.assetKey;
    final now = DateTime.now().toUtc();

    return AssetEntity(
      id: id,
      assetKey: derivedAssetKey,
      type: content.map(
        vehicle: (_) => AssetType.vehicle,
        realEstate: (_) => AssetType.realEstate,
        machinery: (_) => AssetType.machinery,
        equipment: (_) => AssetType.equipment,
      ),
      state: state,
      content: content,
      legalOwner: legalOwner,
      beneficialOwner: beneficialOwner,
      snapshotId: snapshotId,
      portfolioId: portfolioId,
      metadata: metadata,
      createdAt: now,
      updatedAt: now,
    );
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get isActive => state == AssetState.active;
  bool get isArchived => state == AssetState.archived;
  bool get hasBeneficialOwner => beneficialOwner != null;
  bool get hasLegalOwner => legalOwner != null;
  bool get isSyncable =>
      state == AssetState.verified ||
      state == AssetState.active ||
      state == AssetState.archived;

  String get displayName => content.displayName;
  @override
  String get assetKey => content.assetKey;
}

// ============================================================================
// TRANSICIONES DE ESTADO
// ============================================================================

extension AssetStateTransitions on AssetEntity {
  bool canTransitionTo(AssetState newState) {
    switch ((state, newState)) {
      case (AssetState.draft, AssetState.pendingOwnership):
      case (AssetState.pendingOwnership, AssetState.verified):
      case (AssetState.verified, AssetState.active):
      case (AssetState.active, AssetState.archived):
      case (AssetState.archived, AssetState.active):
        return true;
      default:
        return false;
    }
  }

  AssetEntity transitionTo(AssetState newState) {
    if (!canTransitionTo(newState)) {
      throw StateError('Invalid: ${state.name} -> ${newState.name}');
    }
    return copyWith(state: newState, updatedAt: DateTime.now().toUtc());
  }
}
