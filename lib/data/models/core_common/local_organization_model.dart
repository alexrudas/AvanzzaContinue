// ============================================================================
// lib/data/models/core_common/local_organization_model.dart
// LOCAL ORGANIZATION MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste LocalOrganizationEntity en Isar (colección local, offline-first).
//   - Mapea entre Entity (dominio puro) y Model (storage).
//   - Soporta soft delete (isDeleted + deletedAt) con índice para filtrar.
//
// QUÉ NO HACE:
//   - No contiene lógica de negocio.
//   - No toca Firestore ni NestJS.
//   - No sincroniza campos privados (notesPrivate/tagsPrivate) a remoto:
//     el datasource remoto (F3) es responsable de filtrarlos.
//
// PRINCIPIOS:
//   - Wire-stable: los nombres de campo persistidos no deben cambiar.
//   - Índices compuestos (workspaceId + llave) para queries por duplicados.
//   - Índice compuesto (workspaceId + isDeleted) para excluir soft-deleted.
//   - Unique sin replace: colisiones se resuelven explícitamente.
//   - Timestamps en UTC al persistir.
//
// ENTERPRISE NOTES:
//   - workspaceId ≡ orgId del tenant SaaS — partition key local.
//   - Los snapshot* registran adopciones desde PlatformActor (trazabilidad).
//   - Soft delete: el repositorio expone deleteById como soft; hard-delete queda
//     fuera del flujo operativo.
// ============================================================================

// NOTA: import de isar_community sin alias — el codegen referencia símbolos
// top-level sin prefijo desde el `part of`.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/local_organization_entity.dart';

part 'local_organization_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class LocalOrganizationModel {
  /// Isar internal ID (auto-increment).
  Id? isarId;

  /// Business ID (único, indexado). Sin replace: colisiones explícitas.
  @Index(unique: true)
  final String id;

  /// Partition key del workspace. Compuestos con llaves candidatas de matching
  /// y con isDeleted para listados operativos eficientes.
  @Index(composite: [
    CompositeIndex('primaryPhoneE164'),
  ])
  @Index(composite: [
    CompositeIndex('taxId'),
  ], name: 'workspaceId_taxId')
  @Index(composite: [
    CompositeIndex('primaryEmail'),
  ], name: 'workspaceId_primaryEmail')
  @Index(composite: [
    CompositeIndex('isDeleted'),
  ], name: 'workspaceId_isDeleted')
  final String workspaceId;

  final String displayName;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String? legalName;
  final String? taxId;
  final String? primaryPhoneE164;
  final String? primaryEmail;
  final String? website;

  final String? notesPrivate;

  /// Tags privadas del workspace. Nunca se sincronizan.
  final List<String> tagsPrivate;

  final String? snapshotSourcePlatformActorId;
  final DateTime? snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado, excluido de queries operativas.
  final bool isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  final DateTime? deletedAt;

  LocalOrganizationModel({
    this.isarId,
    required this.id,
    required this.workspaceId,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.legalName,
    this.taxId,
    this.primaryPhoneE164,
    this.primaryEmail,
    this.website,
    this.notesPrivate,
    this.tagsPrivate = const <String>[],
    this.snapshotSourcePlatformActorId,
    this.snapshotAdoptedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  LocalOrganizationEntity toEntity() => LocalOrganizationEntity(
        id: id,
        workspaceId: workspaceId,
        displayName: displayName,
        createdAt: createdAt,
        updatedAt: updatedAt,
        legalName: legalName,
        taxId: taxId,
        primaryPhoneE164: primaryPhoneE164,
        primaryEmail: primaryEmail,
        website: website,
        notesPrivate: notesPrivate,
        tagsPrivate: List<String>.unmodifiable(tagsPrivate),
        snapshotSourcePlatformActorId: snapshotSourcePlatformActorId,
        snapshotAdoptedAt: snapshotAdoptedAt,
        isDeleted: isDeleted,
        deletedAt: deletedAt,
      );

  factory LocalOrganizationModel.fromEntity(LocalOrganizationEntity e) =>
      LocalOrganizationModel(
        id: e.id,
        workspaceId: e.workspaceId,
        displayName: e.displayName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        legalName: e.legalName,
        taxId: e.taxId,
        primaryPhoneE164: e.primaryPhoneE164,
        primaryEmail: e.primaryEmail,
        website: e.website,
        notesPrivate: e.notesPrivate,
        tagsPrivate: List<String>.from(e.tagsPrivate),
        snapshotSourcePlatformActorId: e.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: e.snapshotAdoptedAt?.toUtc(),
        isDeleted: e.isDeleted,
        deletedAt: e.deletedAt?.toUtc(),
      );

  factory LocalOrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$LocalOrganizationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalOrganizationModelToJson(this);
}
