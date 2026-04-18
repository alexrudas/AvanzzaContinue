// ============================================================================
// lib/data/sources/remote/core_common/local_contact_firestore_ds.dart
// LOCAL CONTACT FIRESTORE DS — Data Layer / Sources / Remote
// ============================================================================
// QUÉ HACE:
//   - Persiste LocalContactRemoteDto en Firestore scoped al workspace.
//   - Path: organizations/{orgId}/localContacts/{id}.
//
// WARNING: This datasource must not be used for coordination domain logic.
// Coordination flows (CoordinationFlow / OperationalRequest) must only use
// Core API (CoordinationFlowApiClient). Firestore aquí es persistencia
// privada del workspace (contactos locales del usuario) y NO participa en
// decisiones de negocio del Coordination Engine.
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/core_common/remote/local_contact_remote_dto.dart';

class LocalContactFirestoreDataSource {
  final FirebaseFirestore _firestore;

  LocalContactFirestoreDataSource(this._firestore);

  String _docPath(String workspaceId, String id) =>
      'organizations/$workspaceId/localContacts/$id';

  String _colPath(String workspaceId) =>
      'organizations/$workspaceId/localContacts';

  Future<void> save(String workspaceId, LocalContactRemoteDto dto) async {
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

  Stream<List<LocalContactRemoteDto>> watchByWorkspace(String workspaceId) {
    return _firestore.collection(_colPath(workspaceId)).snapshots().map(
          (snap) => snap.docs
              .map((d) => LocalContactRemoteDto.fromJson(d.data()))
              .toList(),
        );
  }
}
