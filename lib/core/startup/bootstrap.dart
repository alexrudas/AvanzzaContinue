import 'package:avanzza/core/di/app_bindings.dart';
import 'package:avanzza/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isar_community/isar.dart';

import '../auth/auth_state_observer.dart';
import '../db/isar_instance.dart';
import '../db/migrations.dart';
import '../di/container.dart';
import '../network/connectivity_service.dart';
import '../sync/sync_observer.dart';

class Bootstrap {
  static Future<BootstrapResult> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final isar = await openIsar();
    await runMigrations(isar);

    final firestore = FirebaseFirestore.instance;

    final connectivity = ConnectivityService();
    final syncObserver = SyncObserver(connectivityService: connectivity);

    await initDI(isar: isar, firestore: firestore);
    syncObserver.start();

    // CRITICAL: Inicializar AuthStateObserver para manejar cambios de sesión automáticamente
    final authStateObserver = AuthStateObserver();
    authStateObserver.start();

    final bootsTrap = BootstrapResult(
      isar: isar,
      firestore: firestore,
      syncObserver: syncObserver,
      authStateObserver: authStateObserver,
    );
    final appBinding = AppBindings(bootsTrap);
    appBinding.dependencies();
    return bootsTrap;
  }
}

class BootstrapResult {
  final Isar isar;
  final FirebaseFirestore firestore;
  final SyncObserver syncObserver;
  final AuthStateObserver authStateObserver;

  BootstrapResult({
    required this.isar,
    required this.firestore,
    required this.syncObserver,
    required this.authStateObserver,
  });
}
