// ============================================================================
// lib/data/models/core_common/local_contact_model.dart
// LOCAL CONTACT MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste LocalContactEntity en Isar (colección local, offline-first).
//   - Mapea entre Entity y Model.
//   - Soporta soft delete (isDeleted + deletedAt) con índice para filtrar.
//   - v2: persiste los campos de perfil estructurado (supplierType, categorías,
//     geo, alt phone, web, coverage) que habilitan el flujo Proveedores.
//
// QUÉ NO HACE:
//   - No contiene lógica de negocio.
//   - No sincroniza campos privados.
//   - No calcula completitud (vive en `local_contact_completeness.dart`).
//
// PRINCIPIOS:
//   - Wire-stable en nombres de campo.
//   - Índices compuestos para queries por duplicados y por organización.
//   - Índice compuesto (workspaceId + isDeleted) para excluir soft-deleted.
//   - Unique sin replace: colisiones explícitas.
//   - supplierType se persiste como `String?` (wireName del enum). Isar no
//     requiere enums nativos y el string es contrato estable.
//
// ENTERPRISE NOTES:
//   - organizationId nullable = contacto suelto (sin LocalOrganization).
//   - docId se almacena normalizado.
//   - Soft delete: el repositorio expone deleteById como soft; hard-delete queda
//     fuera del flujo operativo.
//   - Campos v2 son opcionales / tienen default seguro para NO romper lecturas
//     de registros locales anteriores a la migración (Isar tolera campos nuevos
//     en defecto cuando se agregan sin @Index forzado).
// ============================================================================

// NOTA: import de isar_community sin alias. El codegen genera referencias
// top-level (Isar, Id, FilterCondition, IsarCollection, ...) y el `part of`
// sólo compila si están disponibles sin prefijo en el padre.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../domain/entities/core_common/provider_branch_entity.dart';
import '../../../domain/entities/core_common/value_objects/supplier_type.dart';
import 'provider_branch_embedded.dart';

part 'local_contact_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class LocalContactModel {
  Id? isarId;

  /// Business ID (único, indexado). Sin replace: colisiones explícitas.
  @Index(unique: true)
  final String id;

  /// Partition key. Compuesto con llaves, organizationId e isDeleted.
  @Index(composite: [CompositeIndex('primaryPhoneE164')])
  @Index(
      composite: [CompositeIndex('primaryEmail')],
      name: 'workspaceId_primaryEmail')
  @Index(
      composite: [CompositeIndex('docId')], name: 'workspaceId_docId')
  @Index(
      composite: [CompositeIndex('organizationId')],
      name: 'workspaceId_organizationId')
  @Index(
      composite: [CompositeIndex('isDeleted')],
      name: 'workspaceId_isDeleted')
  final String workspaceId;

  final String displayName;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String? organizationId;
  final String? roleLabel;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final String? docId;

  final String? notesPrivate;
  final List<String> tagsPrivate;

  final String? snapshotSourcePlatformActorId;
  final DateTime? snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado, excluido de queries operativas.
  final bool isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  final DateTime? deletedAt;

  // ── v2 PERFIL ESTRUCTURADO ────────────────────────────────────────────────

  /// Valor persistido del `SupplierType`. Se guarda el `wireName` (`products`,
  /// `services`, `mixed`) para blindar el contrato ante renombres Dart.
  final String? supplierTypeWire;

  /// Categorías verticales libres del proveedor.
  final List<String> categories;

  final String? countryId;
  final String? regionId;
  final String? cityId;
  final String? addressLine;

  final String? secondaryPhoneE164;
  final String? website;

  /// Ciudades donde ofrece servicio.
  final List<String> coverageCityIds;

  /// Modo "Envíos a todo el país". Si es true, `coverageCityIds` debe
  /// estar vacío (el controller lo garantiza al activar el toggle).
  final bool coverageAllCountry;

  /// Sedes adicionales del proveedor (la principal vive en los campos geo
  /// de este mismo modelo). Se persisten embebidas en el mismo registro
  /// Isar vía `ProviderBranchEmbedded`.
  final List<ProviderBranchEmbedded> additionalBranches;

  LocalContactModel({
    this.isarId,
    required this.id,
    required this.workspaceId,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.organizationId,
    this.roleLabel,
    this.primaryPhoneE164,
    this.primaryEmail,
    this.docId,
    this.notesPrivate,
    this.tagsPrivate = const <String>[],
    this.snapshotSourcePlatformActorId,
    this.snapshotAdoptedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.supplierTypeWire,
    this.categories = const <String>[],
    this.countryId,
    this.regionId,
    this.cityId,
    this.addressLine,
    this.secondaryPhoneE164,
    this.website,
    this.coverageCityIds = const <String>[],
    this.coverageAllCountry = false,
    this.additionalBranches = const <ProviderBranchEmbedded>[],
  });

  LocalContactEntity toEntity() => LocalContactEntity(
        id: id,
        workspaceId: workspaceId,
        displayName: displayName,
        createdAt: createdAt,
        updatedAt: updatedAt,
        organizationId: organizationId,
        roleLabel: roleLabel,
        primaryPhoneE164: primaryPhoneE164,
        primaryEmail: primaryEmail,
        docId: docId,
        notesPrivate: notesPrivate,
        tagsPrivate: List<String>.unmodifiable(tagsPrivate),
        snapshotSourcePlatformActorId: snapshotSourcePlatformActorId,
        snapshotAdoptedAt: snapshotAdoptedAt,
        isDeleted: isDeleted,
        deletedAt: deletedAt,
        supplierType: SupplierType.fromWire(supplierTypeWire),
        categories: List<String>.unmodifiable(categories),
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        addressLine: addressLine,
        secondaryPhoneE164: secondaryPhoneE164,
        website: website,
        coverageCityIds: List<String>.unmodifiable(coverageCityIds),
        coverageAllCountry: coverageAllCountry,
        additionalBranches: List<ProviderBranchEntity>.unmodifiable(
          additionalBranches.map((b) => b.toEntity()),
        ),
      );

  factory LocalContactModel.fromEntity(LocalContactEntity e) =>
      LocalContactModel(
        id: e.id,
        workspaceId: e.workspaceId,
        displayName: e.displayName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        organizationId: e.organizationId,
        roleLabel: e.roleLabel,
        primaryPhoneE164: e.primaryPhoneE164,
        primaryEmail: e.primaryEmail,
        docId: e.docId,
        notesPrivate: e.notesPrivate,
        tagsPrivate: List<String>.from(e.tagsPrivate),
        snapshotSourcePlatformActorId: e.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: e.snapshotAdoptedAt?.toUtc(),
        isDeleted: e.isDeleted,
        deletedAt: e.deletedAt?.toUtc(),
        supplierTypeWire: e.supplierType?.wireName,
        categories: List<String>.from(e.categories),
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        addressLine: e.addressLine,
        secondaryPhoneE164: e.secondaryPhoneE164,
        website: e.website,
        coverageCityIds: List<String>.from(e.coverageCityIds),
        coverageAllCountry: e.coverageAllCountry,
        additionalBranches: e.additionalBranches
            .map(ProviderBranchEmbedded.fromEntity)
            .toList(growable: false),
      );

  factory LocalContactModel.fromJson(Map<String, dynamic> json) =>
      _$LocalContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalContactModelToJson(this);
}
