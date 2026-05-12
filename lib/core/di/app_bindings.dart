import '../../application/gateways/accounting/accounting_event_remote_gateway.dart';
import '../../core/auth/auth_state_observer.dart';
import '../../infrastructure/isar/repositories/isar_accounting_event_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:avanzza/data/sources/local/user_local_ds.dart';
import 'package:avanzza/data/sources/remote/user_remote_ds.dart';
import 'package:avanzza/domain/usecases/bootstrap_first_login_uc.dart'
    show BootstrapFirstLoginUC;
import 'package:avanzza/domain/usecases/load_initial_cache_uc.dart'
    show LoadInitialCacheUC;
import 'package:avanzza/domain/usecases/set_active_context_uc.dart'
    show SetActiveContextUC;
import 'package:avanzza/domain/usecases/verify_otp_uc.dart' show VerifyOtpUC;
import 'package:avanzza/core/platform/platform_capabilities.dart';
import 'package:avanzza/core/services/auth/federated_auth_service.dart';
import 'package:avanzza/core/services/notifications/notification_registration_service.dart';
import 'package:avanzza/core/services/phone/phone_dialer_service.dart';
import 'package:avanzza/core/services/platform_services_factory.dart';
import 'package:avanzza/core/services/scanner/barcode_scanner_service.dart';
import 'package:avanzza/infrastructure/contacts/flutter_contacts_picker.dart';
import 'package:avanzza/presentation/auth/scanners/scanner_controller.dart';
import 'package:avanzza/presentation/shared/widgets/phone/contact_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../data/datasources/auth/firebase_auth_ds.dart';
import '../../data/datasources/firestore/user_firestore_ds.dart';
import '../../data/datasources/local/isar_session_ds.dart';
import '../../data/datasources/local/registration_progress_ds.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/check_username_available_uc.dart';
import '../../domain/usecases/finalize_registration_uc.dart';
import '../../domain/usecases/send_mfa_code_uc.dart';
import '../../domain/usecases/send_otp_uc.dart';
import '../../domain/usecases/sign_in_username_password_uc.dart';
import '../../domain/usecases/sign_up_username_password_uc.dart';
import '../../domain/usecases/verify_mfa_uc.dart';
import '../../presentation/auth/controllers/auth_controller.dart';
import '../../presentation/auth/controllers/registration_controller.dart';
import '../../presentation/location/controllers/location_controller.dart';
import '../../services/telemetry/telemetry_service.dart';
import '../di/container.dart';
import '../startup/bootstrap.dart';

class AppBindings extends Bindings {
  final BootstrapResult bootstrap;
  AppBindings(this.bootstrap);

  @override
  void dependencies() {
    // ==================== INFRAESTRUCTURA CORE ====================

    // Firebase
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<FirebaseFirestore>(bootstrap.firestore, permanent: true);

    // Base de datos local
    Get.put<Isar>(bootstrap.isar, permanent: true);

    // Contabilidad — Audit Trail / Outbox Sync
    Get.put<IsarAccountingEventRepository>(
      IsarAccountingEventRepository(bootstrap.isar),
      permanent: true,
    );
    Get.put<AccountingEventRemoteGateway>(
      FakeAccountingEventRemoteGateway(),
      permanent: true,
    );

    // Cliente HTTP único para toda la aplicación
    // Este Dio será reutilizado por todos los services (RuntService, SimitService, etc.)
    // mediante Get.find<Dio>()
    Get.put<Dio>(
      Dio(BaseOptions(
        // Timeouts globales
        connectTimeout: const Duration(seconds: 200),
        receiveTimeout: const Duration(seconds: 200),
        sendTimeout: const Duration(seconds: 200),

        // Headers comunes para todas las requests
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        // Configuración de redirects
        followRedirects: true,
        maxRedirects: 5,
      )),
      permanent: true,
    );

    // Telemetry
    Get.put<TelemetryService>(TelemetryService(), permanent: true);

    // DS
    Get.put<FirebaseAuthDS>(FirebaseAuthDS(Get.find()), permanent: true);
    Get.put<UserFirestoreDS>(UserFirestoreDS(Get.find()), permanent: true);
    Get.put<IsarSessionDS>(IsarSessionDS(Get.find()), permanent: true);
    Get.put<RegistrationProgressDS>(RegistrationProgressDS(Get.find()),
        permanent: true);

    // Repos
    Get.put<AuthRepository>(AuthRepositoryImpl(Get.find(), Get.find()),
        permanent: true);
    Get.put<UserLocalDataSource>(UserLocalDataSource(Get.find()),
        permanent: true);
    Get.put<UserRemoteDataSource>(UserRemoteDataSource(Get.find()),
        permanent: true);

    Get.put<UserRepository>(
        UserRepositoryImpl(local: Get.find(), remote: Get.find()),
        permanent: true);

    // Use cases
    Get.put<SendOtpUC>(SendOtpUC(Get.find()), permanent: true);
    Get.put<CheckUsernameAvailableUC>(CheckUsernameAvailableUC(Get.find()),
        permanent: true);
    Get.put<CheckUsernameAvailabilityUC>(
        CheckUsernameAvailabilityUC(Get.find()),
        permanent: true);
    Get.put<SignUpUsernamePasswordUC>(SignUpUsernamePasswordUC(Get.find()),
        permanent: true);
    Get.put<SignInUsernamePasswordUC>(SignInUsernamePasswordUC(Get.find()),
        permanent: true);
    Get.put<SendMfaCodeUC>(SendMfaCodeUC(Get.find()), permanent: true);
    Get.put<VerifyMfaUC>(VerifyMfaUC(Get.find()), permanent: true);
    Get.put<FinalizeRegistrationUC>(FinalizeRegistrationUC(Get.find()),
        permanent: true);
    Get.put<BootstrapFirstLoginUC>(BootstrapFirstLoginUC(Get.find()),
        permanent: true);
    Get.put<LoadInitialCacheUC>(LoadInitialCacheUC(Get.find()),
        permanent: true);
    Get.put<SetActiveContextUC>(SetActiveContextUC(Get.find()),
        permanent: true);
    Get.put<VerifyOtpUC>(
        VerifyOtpUC(
          authRepo: Get.find(),
          userRepo: Get.find(),
          bootstrapFirstLogin: Get.find(),
          loadInitialCache: Get.find(),
          setActiveContext: Get.find(),
        ),
        permanent: true);

    // Controllers
    // Registration controller
    Get.put<RegistrationController>(
      RegistrationController(
        checkUsername: Get.find(),
        checkUsernameIdempotent: Get.find(),
        signUp: Get.find(),
        progressDS: Get.find(),
        finalizeUC: Get.find(),
      ),
      permanent: true,
    );

    Get.put<AuthController>(
        AuthController(
          sendOtpUC: Get.find(),
          verifyOtpUC: Get.find(),
          bootstrapFirstLoginUC: Get.find(),
          loadInitialCacheUC: Get.find(),
          setActiveContextUC: Get.find(),
          telemetry: Get.find(),
        ),
        permanent: true);

    // Location controller
    Get.lazyPut<LocationController>(
      () => LocationController(DIContainer().geoRepository),
      fenix: true,
    );

    // Contact picker (seam para `PhoneField`). Mobile: impl real con
    // `flutter_contacts` que abre el picker nativo. Desktop: no-op que
    // hace que el widget muestre "Selector no disponible en escritorio".
    Get.put<ContactPicker>(
      PlatformCapabilities.supportsNativeContactsPicker
          ? const FlutterContactsPicker()
          : const NoOpContactPicker(),
      permanent: true,
    );

    // Phone dialer cross-platform: Android usa llamada directa; iOS y
    // desktop caen a `tel:` vía url_launcher.
    Get.put<PhoneDialerService>(
      PlatformServicesFactory.createPhoneDialer(),
      permanent: true,
    );

    // Barcode scanner: Phase 0 deja el scanner real (MobileScanner) en
    // las páginas existentes — esta interfaz se inyecta para que código
    // nuevo y desktop pregunten `isAvailable` antes de abrir flujos.
    Get.put<BarcodeScannerService>(
      PlatformServicesFactory.createBarcodeScanner(),
      permanent: true,
    );

    // Federated auth gate: la UI consulta `availableProviders` para
    // decidir qué botones renderizar. En desktop el set queda vacío.
    Get.put<FederatedAuthService>(
      PlatformServicesFactory.createFederatedAuth(),
      permanent: true,
    );

    // Notification registration (FCM): hoy Noop en todas las plataformas.
    // Cuando se integre `firebase_messaging`, la factory devolverá la
    // impl mobile solo cuando aplique.
    Get.put<NotificationRegistrationService>(
      PlatformServicesFactory.createNotificationRegistration(),
      permanent: true,
    );

    // Workspace controller
    Get.put<ScannerController>(
      ScannerController(),
      permanent: true,
    );

    // ==================== AUTH STATE OBSERVER ====================
    // DEBE ser lo ÚLTIMO en registrarse: requiere que IsarAccountingEventRepository
    // y AccountingEventRemoteGateway ya estén en GetX.
    // start() dispara la suscripción a Firebase → _onAuthStateChanged puede
    // ejecutarse de inmediato (si hay sesión activa).
    Get.put<AuthStateObserver>(bootstrap.authStateObserver, permanent: true);
    Get.find<AuthStateObserver>().start();
    if (kDebugMode) {
      debugPrint('[P2D][Auth][Bindings] AuthStateObserver.start() called');
    }
  }
}
