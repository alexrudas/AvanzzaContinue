import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat/chat_message_model.dart';
import '../../models/chat/broadcast_message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore db;
  ChatRemoteDataSource(this.db);

  Future<List<ChatMessageModel>> messagesByChat(String chatId) async {
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

  Future<List<BroadcastMessageModel>> broadcastsByOrg(String orgId) async {
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
