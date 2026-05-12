// ============================================================================
// lib/data/sources/remote/core_common/local_contact_firestore_ds.dart
// LOCAL CONTACT FIRESTORE DS — Data Layer / Sources / Remote
// ============================================================================
// QUÉ HACE:
//   - Persiste LocalContactRemoteDto en Firestore scoped al workspace.
//   - Path: organizations/{workspaceId}/localContacts/{id}.
//
// WARNING:
//   - Este datasource NO participa en lógica de negocio del Coordination Engine.
//   - CoordinationFlow / OperationalRequest / decisiones de negocio deben ir
//     por Core API.
//   - Firestore aquí es persistencia privada del workspace para libreta local.
//
// NOTA DE DEBUG TEMPORAL:
//   - Se agregan debugPrint para confirmar:
//       1) si el write remoto se está ejecutando,
//       2) contra qué workspaceId,
//       3) en qué path exacto,
//       4) si Firestore responde OK o lanza error.
//   - Si luego confirmas que todo funciona, estos logs se pueden reducir o quitar.
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../models/core_common/remote/local_contact_remote_dto.dart';

class LocalContactFirestoreDataSource {
  final FirebaseFirestore _firestore;

  LocalContactFirestoreDataSource(this._firestore);

  String _docPath(String workspaceId, String id) =>
      'organizations/$workspaceId/localContacts/$id';

  String _colPath(String workspaceId) =>
      'organizations/$workspaceId/localContacts';

  Future<void> save(String workspaceId, LocalContactRemoteDto dto) async {
    final path = _docPath(workspaceId, dto.id);
    final payload = dto.toJson();

    debugPrint('[LocalContactFirestore] save START');
    debugPrint('[LocalContactFirestore] workspaceId=$workspaceId');
    debugPrint('[LocalContactFirestore] id=${dto.id}');
    debugPrint('[LocalContactFirestore] path=$path');
    debugPrint('[LocalContactFirestore] payload=$payload');

    try {
      await _firestore.doc(path).set(payload, SetOptions(merge: true));
      debugPrint('[LocalContactFirestore] save OK path=$path');
    } catch (e, st) {
      debugPrint('[LocalContactFirestore] save FAIL path=$path error=$e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<void> softDelete(
    String workspaceId,
    String id,
    DateTime when,
  ) async {
    final path = _docPath(workspaceId, id);
    final nowIso = when.toUtc().toIso8601String();
    final payload = <String, dynamic>{
      'isDeleted': true,
      'deletedAt': nowIso,
      'updatedAt': nowIso,
    };

    debugPrint('[LocalContactFirestore] softDelete START');
    debugPrint('[LocalContactFirestore] workspaceId=$workspaceId');
    debugPrint('[LocalContactFirestore] id=$id');
    debugPrint('[LocalContactFirestore] path=$path');
    debugPrint('[LocalContactFirestore] payload=$payload');

    try {
      await _firestore.doc(path).set(payload, SetOptions(merge: true));
      debugPrint('[LocalContactFirestore] softDelete OK path=$path');
    } catch (e, st) {
      debugPrint(
        '[LocalContactFirestore] softDelete FAIL path=$path error=$e',
      );
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Stream<List<LocalContactRemoteDto>> watchByWorkspace(String workspaceId) {
    final path = _colPath(workspaceId);

    debugPrint('[LocalContactFirestore] watchByWorkspace START path=$path');

    return _firestore.collection(path).snapshots().map((snap) {
      debugPrint(
        '[LocalContactFirestore] watchByWorkspace EVENT path=$path docs=${snap.docs.length}',
      );

      return snap.docs
          .map((d) => LocalContactRemoteDto.fromJson(d.data()))
          .toList();
    });
  }
}
