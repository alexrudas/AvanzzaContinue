import 'dart:async';

import 'package:avanzza/core/di/container.dart';

import '../../domain/entities/chat/broadcast_message_entity.dart';
import '../../domain/entities/chat/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat/broadcast_message_model.dart';
import '../models/chat/chat_message_model.dart';
import '../sources/local/chat_local_ds.dart';
import '../sources/remote/chat_remote_ds.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource local;
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl({required this.local, required this.remote});

  // Messages
  @override
  Stream<List<ChatMessageEntity>> watchMessagesByChat(String chatId) async* {
    final controller = StreamController<List<ChatMessageEntity>>();
    Future(() async {
      try {
        final locals = await local.messagesByChat(chatId);
        controller.add(locals.map((e) => e.toEntity()).toList());
        final remotes = await remote.messagesByChat(chatId);
        await _syncMessages(locals, remotes);
        final updated = await local.messagesByChat(chatId);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO: log error
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<ChatMessageEntity>> fetchMessagesByChat(String chatId) async {
    try {
      final locals = await local.messagesByChat(chatId);
      // background sync
      unawaited(() async {
        try {
          final remotes = await remote.messagesByChat(chatId);
          await _syncMessages(locals, remotes);
        } catch (e) {
          // TODO: log error
        }
      }());
      return locals.map((e) => e.toEntity()).toList();
    } catch (e) {
      // TODO: log error
      rethrow;
    }
  }

  Future<void> _syncMessages(
      List<ChatMessageModel> locals, List<ChatMessageModel> remotes) async {
    final byId = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = byId[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertMessage(r);
      }
    }
  }

  @override
  Future<void> upsertMessage(ChatMessageEntity message) async {
    final now = DateTime.now().toUtc();
    final model = ChatMessageModel.fromEntity(
        message.copyWith(updatedAt: message.updatedAt ?? now));
    try {
      await local.upsertMessage(model);
    } catch (e) {
      // TODO: log local error
    }
    try {
      await remote.upsertMessage(model);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertMessage(model));
    }
  }

  // Broadcasts
  @override
  Stream<List<BroadcastMessageEntity>> watchBroadcastsByOrg(
      String orgId) async* {
    final controller = StreamController<List<BroadcastMessageEntity>>();
    Future(() async {
      try {
        final locals = await local.broadcastsByOrg(orgId);
        controller.add(locals.map((e) => e.toEntity()).toList());
        final remotes = await remote.broadcastsByOrg(orgId);
        await _syncBroadcasts(locals, remotes);
        final updated = await local.broadcastsByOrg(orgId);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO: log error
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<BroadcastMessageEntity>> fetchBroadcastsByOrg(
      String orgId) async {
    try {
      final locals = await local.broadcastsByOrg(orgId);
      unawaited(() async {
        try {
          final remotes = await remote.broadcastsByOrg(orgId);
          await _syncBroadcasts(locals, remotes);
        } catch (e) {
          // TODO: log error
        }
      }());
      return locals.map((e) => e.toEntity()).toList();
    } catch (e) {
      // TODO: log error
      rethrow;
    }
  }

  Future<void> _syncBroadcasts(List<BroadcastMessageModel> locals,
      List<BroadcastMessageModel> remotes) async {
    final byId = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = byId[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertBroadcast(r);
      }
    }
  }

  @override
  Future<void> upsertBroadcast(BroadcastMessageEntity message) async {
    final now = DateTime.now().toUtc();
    final model = BroadcastMessageModel.fromEntity(
        message.copyWith(updatedAt: message.updatedAt ?? now));
    try {
      await local.upsertBroadcast(model);
    } catch (e) {
      // TODO: log local error
    }
    try {
      await remote.upsertBroadcast(model);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertBroadcast(model));
    }
  }
}
