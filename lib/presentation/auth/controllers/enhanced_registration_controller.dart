import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../data/datasources/auth/firebase_auth_ds.dart';
import '../../../domain/entities/org/organization_entity.dart';
import '../../../domain/entities/user/active_context.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../routes/app_pages.dart';
import '../../controllers/session_context_controller.dart';
import '../scanners/escanner_document_model.dart';
import '../scanners/show_bottom_sheet_scanner.dart';
import 'registration_controller.dart';

/// EnhancedRegistrationController - Wizard de registro mejorado con MFA obligatorio
///
/// Flujo de 4 pasos:
/// - Step 0: Selección de método de autenticación (email/password, Google, Apple, Facebook)
/// - Step 1: MFA obligatorio con teléfono + OTP (no se puede saltar)
/// - Step 2: Escaneo de documento de identidad + confirmación de datos
/// - Step 3: Ubicación (prellenada pero editable) + nombre empresa (si tipo=empresa) + términos
///
/// Importante:
/// - MFA es OBLIGATORIO para todos los métodos de auth (no opcional)
/// - Location desde registrationController.progress es prellenada pero usuario puede modificar
/// - Al finalizar registro exitosamente, limpia completamente registrationController.progress
class EnhancedRegistrationController extends GetxController {
  final RegistrationController registrationController;
  final SessionContextController sessionController;

  EnhancedRegistrationController({
    required this.registrationController,
    required this.sessionController,
  });

  // ============================================================================
  // ESTADO OBSERVABLE DEL WIZARD
  // ============================================================================

  /// Paso actual del wizard (0 = auth method, 1 = MFA, 2 = ID scan, 3 = location/company/terms)
  final RxInt currentStep = 0.obs;

  /// Método de autenticación seleccionado
  /// Valores: 'phone', 'email-password', 'google', 'apple', 'facebook'
  final RxString selectedAuthMethod = ''.obs;

  /// Estado de carga global
  final RxBool isLoading = false.obs;

  /// Mensaje de error
  final RxString errorMessage = ''.obs;

  // ============================================================================
  // STEP 0: AUTH METHOD SELECTION
  // ============================================================================

  /// Email y password para registro tradicional
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  /// Indica si se completó exitosamente la autenticación primaria (paso 0)
  final RxBool authMethodCompleted = false.obs;

  // ============================================================================
  // STEP 1: PHONE MFA (OBLIGATORIO)
  // ============================================================================

  /// Número de teléfono para MFA
  final RxString phoneNumber = ''.obs;

  /// ID de verificación de Firebase para OTP
  String? _verificationId;

  /// Indica si se envió el código OTP
  final RxBool otpSent = false.obs;

  /// Timer para reenvío de OTP
  Timer? _resendTimer;
  final RxInt secondsToResend = 0.obs;
  bool get canResendOtp => secondsToResend.value == 0;

  /// Indica si se completó exitosamente la verificación MFA
  final RxBool mfaCompleted = false.obs;

  // ============================================================================
  // STEP 2: ID DOCUMENT SCAN
  // ============================================================================

  /// Datos del documento escaneado
  final Rxn<ScannerDocumentModel> scannedDocument = Rxn<ScannerDocumentModel>();

  /// Indica si se completó el escaneo de documento
  final RxBool documentScanCompleted = false.obs;

  // ============================================================================
  // STEP 3: LOCATION + COMPANY + TERMS
  // ============================================================================

  /// Ubicación (prellenada desde registrationController.progress pero editable)
  final RxString countryId = ''.obs;
  final RxString regionId = ''.obs;
  final RxString cityId = ''.obs;

  /// Nombre de empresa (obligatorio si titularType == 'empresa')
  final RxString companyName = ''.obs;

  /// Aceptación de términos
  final RxBool termsAccepted = false.obs;

  // ============================================================================
  // INICIALIZACIÓN
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    _prefillLocationFromProgress();
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  /// Prellenar ubicación desde registrationController.progress
  /// (pero usuario puede modificar antes de confirmar)
  void _prefillLocationFromProgress() {
    final progress = registrationController.progress.value;
    if (progress != null) {
      countryId.value = progress.countryId ?? 'CO';
      regionId.value = progress.regionId ?? '';
      cityId.value = progress.cityId ?? '';
    } else {
      // Default a Colombia si no hay datos previos
      countryId.value = 'CO';
    }
  }

  // ============================================================================
  // NAVEGACIÓN DEL WIZARD
  // ============================================================================

  /// Avanzar al siguiente paso (solo si validación pasa)
  Future<void> nextStep() async {
    if (!canGoNext()) {
      errorMessage.value = _getValidationMessage();
      return;
    }

    errorMessage.value = '';

    // Si estamos en el último paso, completar registro
    if (currentStep.value == 3) {
      await completeRegistration();
      return;
    }

    currentStep.value++;
  }

  /// Retroceder al paso anterior
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      errorMessage.value = '';
    }
  }

  /// Validar si se puede avanzar al siguiente paso
  bool canGoNext() {
    switch (currentStep.value) {
      case 0: // Auth method
        return authMethodCompleted.value;
      case 1: // Phone MFA
        return mfaCompleted.value;
      case 2: // Document scan
        return documentScanCompleted.value;
      case 3: // Location + company + terms
        return _validateFinalStep();
      default:
        return false;
    }
  }

  /// Obtener mensaje de validación según paso actual
  String _getValidationMessage() {
    switch (currentStep.value) {
      case 0:
        return 'Debes completar la autenticación antes de continuar';
      case 1:
        return 'Debes verificar tu número de teléfono antes de continuar';
      case 2:
        return 'Debes escanear tu documento de identidad antes de continuar';
      case 3:
        return _getFinalStepValidationMessage();
      default:
        return 'Completa los campos requeridos';
    }
  }

  /// Validar paso final (ubicación, empresa si aplica, términos)
  bool _validateFinalStep() {
    final progress = registrationController.progress.value;
    final isEmpresa = progress?.titularType == 'empresa';

    // Ubicación obligatoria
    if (countryId.value.isEmpty || cityId.value.isEmpty) {
      return false;
    }

    // Nombre empresa obligatorio si es empresa
    if (isEmpresa && companyName.value.trim().isEmpty) {
      return false;
    }

    // Términos obligatorios
    if (!termsAccepted.value) {
      return false;
    }

    return true;
  }

  String _getFinalStepValidationMessage() {
    if (countryId.value.isEmpty || cityId.value.isEmpty) {
      return 'Debes seleccionar tu ubicación';
    }

    final progress = registrationController.progress.value;
    final isEmpresa = progress?.titularType == 'empresa';

    if (isEmpresa && companyName.value.trim().isEmpty) {
      return 'Debes ingresar el nombre de tu empresa';
    }

    if (!termsAccepted.value) {
      return 'Debes aceptar los términos y condiciones';
    }

    return 'Completa todos los campos requeridos';
  }

  // ============================================================================
  // STEP 0: MÉTODOS DE AUTENTICACIÓN
  // ============================================================================

  /// Registrar con email y password
  Future<void> signUpWithEmailPassword() async {
    if (email.value.trim().isEmpty || password.value.trim().isEmpty) {
      errorMessage.value = 'Email y contraseña son obligatorios';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuthDS = Get.find<FirebaseAuthDS>();

      // Crear alias email (username@avanzza.local)
      final username = email.value.split('@').first;
      final aliasEmail = '$username@avanzza.local';

      await firebaseAuthDS.signUpWithAliasEmail(
        aliasEmail: aliasEmail,
        password: password.value,
      );

      selectedAuthMethod.value = 'email-password';
      authMethodCompleted.value = true;

      // Guardar en progress para referencia
      await registrationController.setEmail(email.value);
      await registrationController.progress.value?.let((p) async {
        p.authMethod = 'email-password';
        await registrationController.progressDS.upsert(p);
      });

      Get.snackbar(
        'Éxito',
        'Cuenta creada exitosamente',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapFirebaseError(e.code);
    } catch (e) {
      errorMessage.value = 'Error inesperado: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Autenticación con Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuthDS = Get.find<FirebaseAuthDS>();
      final userCredential = await firebaseAuthDS.signInWithGoogle();

      selectedAuthMethod.value = 'google';
      authMethodCompleted.value = true;

      // Extraer email del usuario de Google
      final googleEmail = userCredential.user?.email ?? '';
      email.value = googleEmail;

      // Guardar método de auth en progress
      await registrationController.progress.value?.let((p) async {
        p.authMethod = 'google';
        p.email = googleEmail;
        await registrationController.progressDS.upsert(p);
      });

      Get.snackbar(
        'Éxito',
        'Autenticación con Google exitosa',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ERROR_ABORTED_BY_USER') {
        errorMessage.value = 'Autenticación cancelada';
      } else {
        errorMessage.value = _mapFirebaseError(e.code);
      }
    } catch (e) {
      errorMessage.value = 'Error inesperado: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Autenticación con Apple
  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuthDS = Get.find<FirebaseAuthDS>();
      final userCredential = await firebaseAuthDS.signInWithApple();

      selectedAuthMethod.value = 'apple';
      authMethodCompleted.value = true;

      // Extraer email del usuario de Apple (puede ser null si usuario ocultó email)
      final appleEmail = userCredential.user?.email ?? '';
      email.value = appleEmail;

      // Guardar método de auth en progress
      await registrationController.progress.value?.let((p) async {
        p.authMethod = 'apple';
        p.email = appleEmail;
        await registrationController.progressDS.upsert(p);
      });

      Get.snackbar(
        'Éxito',
        'Autenticación con Apple exitosa',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapFirebaseError(e.code);
    } catch (e) {
      errorMessage.value = 'Error inesperado: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Autenticación con Facebook
  Future<void> signInWithFacebook() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuthDS = Get.find<FirebaseAuthDS>();
      final userCredential = await firebaseAuthDS.signInWithFacebook();

      selectedAuthMethod.value = 'facebook';
      authMethodCompleted.value = true;

      // Extraer email del usuario de Facebook
      final fbEmail = userCredential.user?.email ?? '';
      email.value = fbEmail;

      // Guardar método de auth en progress
      await registrationController.progress.value?.let((p) async {
        p.authMethod = 'facebook';
        p.email = fbEmail;
        await registrationController.progressDS.upsert(p);
      });

      Get.snackbar(
        'Éxito',
        'Autenticación con Facebook exitosa',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapFirebaseError(e.code);
    } catch (e) {
      errorMessage.value = 'Error inesperado: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // STEP 1: PHONE MFA (OBLIGATORIO)
  // ============================================================================

  /// Enviar OTP al teléfono (MFA obligatorio)
  Future<void> sendMfaOtp() async {
    if (phoneNumber.value.trim().isEmpty) {
      errorMessage.value = 'Debes ingresar tu número de teléfono';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuthDS = Get.find<FirebaseAuthDS>();

      await firebaseAuthDS.sendOtp(
        phoneNumber: phoneNumber.value,
        onCodeSent: (verificationId) {
          _verificationId = verificationId;
          otpSent.value = true;
          _startResendTimer();
          Get.snackbar(
            'Código enviado',
            'Revisa tu teléfono para el código de verificación',
            backgroundColor: Colors.blue.shade100,
            colorText: Colors.blue.shade900,
          );
        },
        onCodeTimeout: (verificationId) {
          _verificationId = verificationId;
        },
        onAutoVerified: (uid) async {
          // Auto-verificación exitosa
          mfaCompleted.value = true;
          await registrationController.setPhone(phoneNumber.value);
          Get.snackbar(
            'Verificado',
            'Número verificado automáticamente',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900,
          );
        },
        onFailed: (e) {
          errorMessage.value = _mapFirebaseError(e.code);
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al enviar código: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Verificar código OTP del teléfono
  Future<void> verifyMfaOtp(String smsCode) async {
    if (_verificationId == null) {
      errorMessage.value = 'Falta ID de verificación. Reenvía el código.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuthDS = Get.find<FirebaseAuthDS>();

      await firebaseAuthDS.verifyOtp(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      mfaCompleted.value = true;
      await registrationController.setPhone(phoneNumber.value);

      Get.snackbar(
        'Verificado',
        'Número de teléfono verificado exitosamente',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapFirebaseError(e.code);
    } catch (e) {
      errorMessage.value = 'Error al verificar código: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Reenviar código OTP
  Future<void> resendMfaOtp() async {
    if (!canResendOtp) return;
    await sendMfaOtp();
  }

  /// Timer para reenvío de OTP (60 segundos)
  void _startResendTimer() {
    _resendTimer?.cancel();
    secondsToResend.value = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsToResend.value > 0) {
        secondsToResend.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // ============================================================================
  // STEP 2: DOCUMENT SCAN
  // ============================================================================

  /// Abrir scanner de documentos (bottom sheet con cámara/galería)
  Future<void> scanDocument(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Usar el scanner oficial del proyecto
      await showBottomSheetScanner(
        context,
        onResult: (result, error) async {
          if (result != null) {
            scannedDocument.value = result;
            documentScanCompleted.value = true;

            // Guardar en progress
            await registrationController.setIdentity(
              docType:
                  result.userDocument == UserDocument.cardId ? 'CC' : 'other',
              docNumber: result.numeroDocumento ?? '',
              barcodeRaw: result.fullDecode ?? '',
            );

            Get.snackbar(
              'Documento escaneado',
              'Verifica que los datos sean correctos',
              backgroundColor: Colors.green.shade100,
              colorText: Colors.green.shade900,
            );
          } else {
            if (error != null) {
              errorMessage.value =
                  'Error al escanear documento: ${error.toString()}';
            }
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al escanear documento: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Omitir escaneo de documento (usar datos mock para pruebas)
  void skipDocumentScan() {
    scannedDocument.value = ScannerDocumentModel.mock();
    documentScanCompleted.value = true;
  }

  // ============================================================================
  // STEP 3: LOCATION + COMPANY + TERMS
  // ============================================================================

  /// Actualizar ubicación (usuario puede modificar valores prellenados)
  void updateLocation({
    String? country,
    String? region,
    String? city,
  }) {
    if (country != null) countryId.value = country;
    if (region != null) regionId.value = region;
    if (city != null) cityId.value = city;
  }

  // ============================================================================
  // REGISTRO COMPLETO
  // ============================================================================

  /// Completar registro y crear entidades (User, Organization, Membership)
  Future<void> completeRegistration() async {
    if (!_validateFinalStep()) {
      errorMessage.value = _getFinalStepValidationMessage();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final firebaseAuth = FirebaseAuth.instance;
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        throw StateError('Usuario no autenticado');
      }

      final uid = currentUser.uid;
      final progress = registrationController.progress.value;

      // ========================================================================
      // 1. CREAR ORGANIZACIÓN
      // ========================================================================

      final orgId = 'org_${DateTime.now().millisecondsSinceEpoch}';
      final isEmpresa = progress?.titularType == 'empresa';

      final orgName = isEmpresa
          ? companyName.value.trim()
          : (scannedDocument.value?.nombreCompleto.trim() ?? 'Personal');

      final organization = OrganizationEntity(
        id: orgId,
        nombre: orgName,
        tipo: isEmpresa ? 'empresa' : 'personal',
        countryId: countryId.value,
        regionId: regionId.value.isEmpty ? null : regionId.value,
        cityId: cityId.value,
        ownerUid: uid,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await DIContainer().orgRepository.upsertOrg(organization);

      // ========================================================================
      // 2. CREAR USUARIO
      // ========================================================================

      final scannedDoc = scannedDocument.value;

      final userName = scannedDoc?.nombreCompleto.trim() ??
          currentUser.displayName ??
          email.value.split('@').first;

      final userEntity = UserEntity(
        uid: uid,
        name: userName,
        email: email.value.isEmpty ? currentUser.email ?? '' : email.value,
        phone: phoneNumber.value,
        tipoDoc: scannedDoc?.userDocument == UserDocument.cardId ? 'CC' : null,
        numDoc: scannedDoc?.numeroDocumento,
        countryId: countryId.value,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await DIContainer().userRepository.upsertUser(userEntity);

      // ========================================================================
      // 3. CREAR MEMBERSHIP
      // ========================================================================

      final selectedRole = progress?.selectedRole ?? 'admin_activos_ind';
      final roles = [selectedRole];

      final membership = MembershipEntity(
        userId: uid,
        orgId: orgId,
        orgName: orgName,
        roles: roles,
        estatus: 'activo',
        primaryLocation: {
          'countryId': countryId.value,
          if (regionId.value.isNotEmpty) 'regionId': regionId.value,
          'cityId': cityId.value,
        },
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await DIContainer().userRepository.upsertMembership(membership);

      // ========================================================================
      // 4. SET ACTIVE CONTEXT
      // ========================================================================

      final activeContext = ActiveContext(
        orgId: orgId,
        orgName: orgName,
        rol: selectedRole,
        providerType: progress?.providerType,
      );

      await sessionController.setActiveContext(activeContext);

      // ========================================================================
      // 4.1. INICIALIZAR SESSION CONTROLLER (CRÍTICO)
      // ========================================================================

      // CRITICAL: Inicializar SessionController para que observe el usuario recién creado
      debugPrint(
          '[EnhancedRegistration] Inicializando SessionController con uid: $uid');
      try {
        await sessionController.init(uid);
        debugPrint('[EnhancedRegistration] SessionController inicializado');
      } catch (e) {
        debugPrint(
            '[EnhancedRegistration] Error al inicializar SessionController: $e');
        // Continuar de todos modos - el usuario está creado
      }

      // ========================================================================
      // 5. LIMPIAR REGISTRATION PROGRESS (MUY IMPORTANTE)
      // ========================================================================

      await registrationController.clear();

      // ========================================================================
      // 6. NAVEGAR A HOME
      // ========================================================================

      Get.snackbar(
        '¡Bienvenido a Avanzza!',
        'Tu cuenta ha sido creada exitosamente',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 3),
      );

      Get.offAllNamed(Routes.home);
    } catch (e) {
      errorMessage.value = 'Error al completar registro: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Mapear códigos de error de Firebase a mensajes legibles
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'invalid-email':
        return 'Email inválido';
      case 'weak-password':
        return 'Contraseña muy débil (mínimo 6 caracteres)';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'invalid-phone-number':
        return 'Número de teléfono inválido';
      case 'quota-exceeded':
        return 'Límite de SMS excedido, intenta más tarde';
      case 'too-many-requests':
        return 'Demasiados intentos, intenta más tarde';
      case 'invalid-verification-code':
        return 'Código de verificación inválido';
      case 'code-expired':
      case 'session-expired':
        return 'Código expirado, solicita uno nuevo';
      case 'network-request-failed':
        return 'Sin conexión a internet';
      default:
        return 'Error de autenticación: $code';
    }
  }
}

/// Extension helper para sintaxis .let() estilo Kotlin
extension LetExtension<T> on T? {
  R? let<R>(R Function(T) block) {
    final value = this;
    return value != null ? block(value) : null;
  }
}
