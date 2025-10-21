import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/chat/chat_message_model.dart';
import '../../models/chat/broadcast_message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore db;
  ChatRemoteDataSource(this.db);

  /// Límite por defecto para queries de chat
  static const int defaultLimit = 50;

  /// Límite máximo permitido
  static const int maxLimit = 200;

  /// Obtiene mensajes paginados de un chat
  ///
  /// OPTIMIZACIÓN CRÍTICA: Evita traer TODOS los mensajes históricos
  /// - Un chat con 5,000 mensajes ahora solo trae 50 por página
  /// - Reduce costos de lectura en ~98% (5,000 → 50 lecturas)
  /// - Usa [startAfter] para cargar páginas adicionales
  ///
  /// Ejemplo:
  /// ```dart
  /// // Primera página
  /// final page1 = await ds.messagesByChat('chat123', limit: 50);
  ///
  /// // Segunda página
  /// if (page1.hasMore) {
  ///   final page2 = await ds.messagesByChat(
  ///     'chat123',
  ///     limit: 50,
  ///     startAfter: page1.lastDocument,
  ///   );
  /// }
  /// ```
  Future<PaginatedResult<ChatMessageModel>> messagesByChat(
    String chatId, {
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    // Validar límite
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q = db
        .collection('chat_messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true) // Más recientes primero
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => ChatMessageModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  ///
  /// ⚠️ ADVERTENCIA: Este método trae TODOS los mensajes sin límite
  /// Solo usar para migración o casos especiales donde se necesitan todos los mensajes
  ///
  /// Considera usar [messagesByChat] con paginación
  @Deprecated('Usa messagesByChat con paginación para mejor rendimiento')
  Future<List<ChatMessageModel>> messagesByChatLegacy(String chatId) async {
    final snap = await db
        .collection('chat_messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .get();
    return snap.docs.map((d) => ChatMessageModel.fromFirestore(d.id, d.data())).toList();
  }

  Future<void> upsertMessage(ChatMessageModel m) async {
    await db.collection('chat_messages').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  /// Obtiene broadcasts paginados de una organización
  ///
  /// OPTIMIZACIÓN: Limita broadcasts a páginas de 50 en lugar de traer todos
  Future<PaginatedResult<BroadcastMessageModel>> broadcastsByOrg(
    String orgId, {
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q = db
        .collection('broadcast_messages')
        .where('orgId', isEqualTo: orgId)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => BroadcastMessageModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  @Deprecated('Usa broadcastsByOrg con paginación')
  Future<List<BroadcastMessageModel>> broadcastsByOrgLegacy(String orgId) async {
    final snap = await db
        .collection('broadcast_messages')
        .where('orgId', isEqualTo: orgId)
        .orderBy('timestamp', descending: true)
        .get();
    return snap.docs.map((d) => BroadcastMessageModel.fromFirestore(d.id, d.data())).toList();
  }

  Future<void> upsertBroadcast(BroadcastMessageModel m) async {
    await db.collection('broadcast_messages').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }
}
