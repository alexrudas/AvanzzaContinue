import 'package:isar_community/isar.dart';

import '../../models/chat/broadcast_message_model.dart';
import '../../models/chat/chat_message_model.dart';

class ChatLocalDataSource {
  final Isar isar;
  ChatLocalDataSource(this.isar);

  Future<List<ChatMessageModel>> messagesByChat(String chatId) async {
    return isar.chatMessageModels
        .filter()
        .chatIdEqualTo(chatId)
        .sortByTimestamp()
        .findAll();
  }

  Future<void> upsertMessage(ChatMessageModel m) async =>
      isar.writeTxn(() async => isar.chatMessageModels.put(m));

  Future<List<BroadcastMessageModel>> broadcastsByOrg(String orgId) async {
    return isar.broadcastMessageModels
        .filter()
        .orgIdEqualTo(orgId)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<void> upsertBroadcast(BroadcastMessageModel m) async =>
      isar.writeTxn(() async => isar.broadcastMessageModels.put(m));
}
