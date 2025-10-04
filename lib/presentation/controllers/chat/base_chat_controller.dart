import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/domain/repositories/chat_repository.dart';
import 'package:avanzza/presentation/controllers/session_context_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseChatController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();
  final _tiles = <Widget>[].obs;

  List<Widget> get conversationTiles => _tiles;
  String? _orgId;
  late final ChatRepository _repo;

  // Para especialización por rol
  List<String> get acceptedRoleKeys => const [];
  String? get providerTypeFilter => null; // 'servicios' | 'articulos'

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _repo = di.chatRepository;
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;
    _subscribe();
  }

  void _subscribe() {
    try {
      loading.value = true;
      error.value = null;
      final orgId = _orgId;
      if (orgId == null || orgId.isEmpty) {
        loading.value = false;
        return;
      }

      _repo.watchBroadcastsByOrg(orgId).listen((list) {
        final filtered = list.where((b) {
          final rolObj = (b.rolObjetivo ?? '').toLowerCase();
          if (acceptedRoleKeys.isNotEmpty &&
              !acceptedRoleKeys.any((k) => rolObj.contains(k))) {
            return false;
          }
          final pt = providerTypeFilter;
          if (pt != null && pt.isNotEmpty) {
            // si se quiere filtrar más por providerType en rolObjetivo
            // si no coincide, podría retornarse false. Por ahora, no forzamos.
          }
          return true;
        }).toList();

        _tiles
          ..clear()
          ..addAll(filtered.map((b) => ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: Text(b.message),
                subtitle: Text(b.rolObjetivo ?? 'broadcast'),
              )));
        loading.value = false;
      });
    } catch (e) {
      error.value = 'Error cargando conversaciones';
      loading.value = false;
    }
  }
}
