// ============================================================================
// lib/data/sources/remote/insurance_remote_ds.dart
// INSURANCE REMOTE DATA SOURCE — Lecturas/escrituras remotas de Seguros.
//
// QUÉ HACE:
// - Expone queries remotas para pólizas y compras de seguros.
// - Separa consultas livianas de existencia de consultas pesadas paginadas.
// - Protege a la app de fallos de Firestore por índices faltantes en queries
//   compuestas, evitando congelamientos innecesarios en pantallas de detalle.
//
// QUÉ NO HACE:
// - No decide reglas de negocio de elegibilidad.
// - No transforma errores a mensajes UI.
// - No cachea ni persiste localmente.
// - No mezcla consultas de “existencia” con “historial” si no hace falta.
//
// PRINCIPIOS:
// - Query mínima para vistas de detalle/upsell: usar existencia o limit(1)
//   sin orderBy cuando no sea necesario.
// - Query paginada para historial/listado: usar orderBy(createdAt) y asumir que
//   puede requerir índice compuesto en Firestore.
// - Manejo explícito de FirebaseFirestoreException para evitar que la app quede
//   trabada por un failed-precondition de índice faltante.
// - Mantener compatibilidad con métodos legacy mientras se migra el consumo.
//
// ENTERPRISE NOTES:
// REFACTORIZADO (2026-03): separación entre consulta liviana de existencia y
// consulta pesada de historial para reducir dependencia de índices en vistas
// operativas como Detalles de Seguro RC.
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/insurance/insurance_policy_model.dart';
import '../../models/insurance/insurance_purchase_model.dart';

class InsuranceRemoteDataSource {
  final FirebaseFirestore db;

  InsuranceRemoteDataSource(this.db);

  // ───────────────────────────────────────────────────────────────────────────
  // PÓLIZAS — CONSULTAS LIVIANAS PARA DETALLE / UPSELL
  // ───────────────────────────────────────────────────────────────────────────

  /// Indica si existe al menos una póliza asociada al activo.
  ///
  /// IMPORTANTE:
  /// - Usa una query mínima sin orderBy para evitar depender de índices
  ///   compuestos cuando la vista solo necesita saber existencia.
  /// - Si Firestore falla por infraestructura o permisos, relanza el error.
  Future<bool> hasPoliciesByAsset(
    String assetId, {
    String? countryId,
    String? cityId,
  }) async {
    Query<Map<String, dynamic>> q = db
        .collection('insurance_policies')
        .where('assetId', isEqualTo: assetId);

    if (countryId != null && countryId.trim().isNotEmpty) {
      q = q.where('countryId', isEqualTo: countryId.trim());
    }

    if (cityId != null && cityId.trim().isNotEmpty) {
      q = q.where('cityId', isEqualTo: cityId.trim());
    }

    q = q.limit(1);

    try {
      final snap = await q.get();
      return snap.docs.isNotEmpty;
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.hasPoliciesByAsset] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  /// Trae una sola póliza del activo sin imponer orden por createdAt.
  ///
  /// Útil para vistas que necesitan un documento representativo mínimo sin
  /// cargar historial completo ni exigir índices compuestos.
  Future<InsurancePolicyModel?> firstPolicyByAsset(
    String assetId, {
    String? countryId,
    String? cityId,
  }) async {
    Query<Map<String, dynamic>> q = db
        .collection('insurance_policies')
        .where('assetId', isEqualTo: assetId);

    if (countryId != null && countryId.trim().isNotEmpty) {
      q = q.where('countryId', isEqualTo: countryId.trim());
    }

    if (cityId != null && cityId.trim().isNotEmpty) {
      q = q.where('cityId', isEqualTo: cityId.trim());
    }

    q = q.limit(1);

    try {
      final snap = await q.get();
      if (snap.docs.isEmpty) return null;

      final doc = snap.docs.first;
      return InsurancePolicyModel.fromFirestore(doc.id, doc.data());
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.firstPolicyByAsset] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PÓLIZAS — HISTORIAL / LISTADOS PAGINADOS
  // ───────────────────────────────────────────────────────────────────────────

  /// Devuelve pólizas del activo ordenadas por fecha de creación descendente.
  ///
  /// IMPORTANTE:
  /// - Esta query sí puede requerir índice compuesto en Firestore.
  /// - Si falta el índice, devolvemos resultado vacío controlado para evitar
  ///   congelar pantallas operativas. El problema debe corregirse creando el
  ///   índice en infraestructura si esta query es necesaria de verdad.
  Future<PaginatedResult<InsurancePolicyModel>> policiesByAsset(
    String assetId, {
    String? countryId,
    String? cityId,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 100) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 100 for insurance policies.',
      );
    }

    Query<Map<String, dynamic>> q = db
        .collection('insurance_policies')
        .where('assetId', isEqualTo: assetId);

    if (countryId != null && countryId.trim().isNotEmpty) {
      q = q.where('countryId', isEqualTo: countryId.trim());
    }

    if (cityId != null && cityId.trim().isNotEmpty) {
      q = q.where('cityId', isEqualTo: cityId.trim());
    }

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    try {
      final snap = await q.get();

      return PaginatedResult(
        items: snap.docs
            .map((d) => InsurancePolicyModel.fromFirestore(d.id, d.data()))
            .toList(),
        lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
        hasMore: snap.docs.length == limit,
      );
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.policiesByAsset] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }

      // Evita que la app quede congelada por índice faltante.
      if (e.code == 'failed-precondition') {
        return const PaginatedResult(
          items: <InsurancePolicyModel>[],
          lastDocument: null,
          hasMore: false,
        );
      }

      rethrow;
    }
  }

  @Deprecated('Use policiesByAsset() with pagination instead')
  Future<List<InsurancePolicyModel>> policiesByAssetLegacy(
    String assetId, {
    String? countryId,
    String? cityId,
  }) async {
    Query<Map<String, dynamic>> q = db
        .collection('insurance_policies')
        .where('assetId', isEqualTo: assetId);

    if (countryId != null && countryId.trim().isNotEmpty) {
      q = q.where('countryId', isEqualTo: countryId.trim());
    }

    if (cityId != null && cityId.trim().isNotEmpty) {
      q = q.where('cityId', isEqualTo: cityId.trim());
    }

    try {
      final snap = await q.get();

      return snap.docs
          .map((d) => InsurancePolicyModel.fromFirestore(d.id, d.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.policiesByAssetLegacy] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  Future<InsurancePolicyModel?> getPolicy(String id) async {
    try {
      final d = await db.collection('insurance_policies').doc(id).get();
      if (!d.exists) return null;
      return InsurancePolicyModel.fromFirestore(d.id, d.data()!);
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.getPolicy] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  Future<void> upsertPolicy(InsurancePolicyModel m) async {
    try {
      await db
          .collection('insurance_policies')
          .doc(m.id)
          .set(m.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.upsertPolicy] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // COMPRAS — CONSULTAS PAGINADAS
  // ───────────────────────────────────────────────────────────────────────────

  Future<InsurancePurchaseModel?> getPurchase(String id) async {
    try {
      final d = await db.collection('insurance_purchases').doc(id).get();
      if (!d.exists) return null;
      return InsurancePurchaseModel.fromFirestore(d.id, d.data()!);
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.getPurchase] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  Future<PaginatedResult<InsurancePurchaseModel>> purchasesByOrg(
    String orgId, {
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 200) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 200. Use pagination with startAfter instead.',
      );
    }

    Query<Map<String, dynamic>> q = db
        .collection('insurance_purchases')
        .where('orgId', isEqualTo: orgId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    try {
      final snap = await q.get();

      return PaginatedResult(
        items: snap.docs
            .map(
              (d) => InsurancePurchaseModel.fromFirestore(
                d.id,
                d.data(),
              ),
            )
            .toList(),
        lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
        hasMore: snap.docs.length == limit,
      );
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.purchasesByOrg] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  @Deprecated('Use purchasesByOrg() with pagination instead')
  Future<List<InsurancePurchaseModel>> purchasesByOrgLegacy(
    String orgId,
  ) async {
    try {
      final snap = await db
          .collection('insurance_purchases')
          .where('orgId', isEqualTo: orgId)
          .get();

      return snap.docs
          .map((d) => InsurancePurchaseModel.fromFirestore(d.id, d.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.purchasesByOrgLegacy] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }

  Future<void> upsertPurchase(InsurancePurchaseModel m) async {
    try {
      await db
          .collection('insurance_purchases')
          .doc(m.id)
          .set(m.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[InsuranceRemoteDataSource.upsertPurchase] '
          'Firestore error: ${e.code} | ${e.message}',
        );
        debugPrint('$st');
      }
      rethrow;
    }
  }
}
