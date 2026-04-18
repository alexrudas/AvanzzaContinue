// ============================================================================
// lib/data/sources/remote/core_common/local_organization_firestore_ds.dart
// LOCAL ORGANIZATION FIRESTORE DS — Data Layer / Sources / Remote
// ============================================================================
// QUÉ HACE:
//   - Persiste LocalOrganizationRemoteDto en Firestore scoped al workspace.
//   - Path: organizations/{orgId}/localOrganizations/{id}.
//   - El DTO ya filtró notesPrivate/tagsPrivate por diseño.
//
// QUÉ NO HACE:
//   - No reconstruye Entity (eso es el merger en el repo).
//   - No valida privacidad: el DTO es el guardián.
//   - No toca NestJS.
//
// WARNING: This datasource must not be used for coordination domain logic.
// Coordination flows (CoordinationFlow / OperationalRequest) must only use
// Core API (CoordinationFlowApiClient). Firestore aquí es persistencia
// privada del workspace (organizaciones locales del usuario) y NO participa
// en decisiones de negocio del Coordination Engine.
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/core_common/remote/local_organization_remote_dto.dart';

class LocalOrganizationFirestoreDataSource {
  final FirebaseFirestore _firestore;

  LocalOrganizationFirestoreDataSource(this._firestore);

  String _docPath(String workspaceId, String id) =>
      'organizations/$workspaceId/localOrganizations/$id';

  String _colPath(String workspaceId) =>
      'organizations/$workspaceId/localOrganizations';

  Future<void> save(
    String workspaceId,
    LocalOrganizationRemoteDto dto,
  ) async {
    await _firestore
        .doc(_docPath(workspaceId, dto.id))
        .set(dto.toJson(), SetOptions(merge: true));
  }

  Future<void> softDelete(
    String workspaceId,
    String id,
    DateTime when,
  ) async {
    await _firestore.doc(_docPath(workspaceId, id)).set(<String, dynamic>{
      'isDeleted': true,
      'deletedAt': when.toUtc().toIso8601String(),
      'updatedAt': when.toUtc().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Stream de todos los LocalOrganization del workspace (remoto).
  /// El repo decide cómo fusionar con Isar vía el merger.
  Stream<List<LocalOrganizationRemoteDto>> watchByWorkspace(
    String workspaceId,
  ) {
    return _firestore.collection(_colPath(workspaceId)).snapshots().map(
          (snap) => snap.docs
              .map((d) => LocalOrganizationRemoteDto.fromJson(d.data()))
              .toList(),
        );
  }
}
