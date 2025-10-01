import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/repositories/chat_repository.dart';
import '../../../controllers/session_context_controller.dart';

class AdminChatController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();
  bool get hasActiveOrg => _orgId != null;

  String? _orgId;
  late final ChatRepository _repo;

  final _tiles = <Widget>[].obs;
  List<Widget> get conversationTiles => _tiles;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _repo = di.chatRepository;
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;

    _subscribeLocal();
    di.syncService.sync();
  }

  void _subscribeLocal() {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) return;
      final orgId = _orgId!;

      _repo.watchBroadcastsByOrg(orgId).listen((list) {
        _tiles
          ..clear()
          ..addAll(list.map((b) => ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: Text(
                  'Broadcast${(b.rolObjetivo != null && b.rolObjetivo!.isNotEmpty) ? ' (${b.rolObjetivo})' : ''}',
                ),
                subtitle: Text(b.message),
                trailing: Text(
                  _fmt(b.timestamp),
                  style: const TextStyle(fontSize: 12),
                ),
              )));
        loading.value = false;
      });
    } catch (e) {
      error.value = 'Error cargando conversaciones';
      loading.value = false;
    }
  }

  String _fmt(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  }

  void broadcastMessage() {
    Get.snackbar('Chat', 'Enviar broadcast (stub)');
  }

  void newDirectMessage() {
    Get.snackbar('Chat', 'Nuevo mensaje directo (stub)');
  }
}
