// ============================================================================
// lib/data/models/core_common/local_contact_model.dart
// LOCAL CONTACT MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste LocalContactEntity en Isar (colección local, offline-first).
//   - Mapea entre Entity y Model.
//   - Soporta soft delete (isDeleted + deletedAt) con índice para filtrar.
//
// QUÉ NO HACE:
//   - No contiene lógica de negocio.
//   - No sincroniza campos privados.
//
// PRINCIPIOS:
//   - Wire-stable en nombres de campo.
//   - Índices compuestos para queries por duplicados y por organización.
//   - Índice compuesto (workspaceId + isDeleted) para excluir soft-deleted.
//   - Unique sin replace: colisiones explícitas.
//
// ENTERPRISE NOTES:
//   - organizationId nullable = contacto suelto (sin LocalOrganization).
//   - docId se almacena normalizado.
//   - Soft delete: el repositorio expone deleteById como soft; hard-delete queda
//     fuera del flujo operativo.
// ============================================================================

// NOTA: import de isar_community sin alias. El codegen genera referencias
// top-level (Isar, Id, FilterCondition, IsarCollection, ...) y el `part of`
// sólo compila si están disponibles sin prefijo en el padre.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/local_contact_entity.dart';

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
      );

  factory LocalContactModel.fromJson(Map<String, dynamic> json) =>
      _$LocalContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalContactModelToJson(this);
}
