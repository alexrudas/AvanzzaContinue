import '../entities/chat/chat_message_entity.dart';
import '../entities/chat/broadcast_message_entity.dart';

abstract class ChatRepository {
  // Chat messages
  Stream<List<ChatMessageEntity>> watchMessagesByChat(String chatId);
  Future<List<ChatMessageEntity>> fetchMessagesByChat(String chatId);
  Future<void> upsertMessage(ChatMessageEntity message);

  // Broadcasts
  Stream<List<BroadcastMessageEntity>> watchBroadcastsByOrg(String orgId);
  Future<List<BroadcastMessageEntity>> fetchBroadcastsByOrg(String orgId);
  Future<void> upsertBroadcast(BroadcastMessageEntity message);
}
