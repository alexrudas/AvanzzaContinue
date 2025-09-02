import 'dart:async';

import '../network/connectivity_service.dart';
import '../platform/offline_sync_service.dart';
import '../di/container.dart';
import '../log/logger.dart';

class SyncObserver {
  final ConnectivityService connectivityService;
  StreamSubscription<bool>? _sub;

  SyncObserver({required this.connectivityService});

  void start() {
    _sub?.cancel();
    _sub = connectivityService.online$.listen((online) async {
      if (online) {
        Logger.info('Connectivity restored. Triggering offline sync.');
        // Trigger the global sync service
        try {
          final OfflineSyncService svc = DIContainer().syncService;
          // currently OfflineSyncService exposes internal queue; here we simply call setOnline(true)
          svc.setOnline(true);
        } catch (e, st) {
          Logger.error('Failed to trigger offline sync', e, st);
        }
      }
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
