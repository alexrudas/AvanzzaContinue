// ============================================================================
// lib/presentation/auth/controllers/registration_controller.dart
//
// QUÉ HACE:
// Controla el flujo de registro de usuario incluyendo verificación de username,
// creación de credenciales, progreso de registro y finalización del perfil.
//
// QUÉ NO HACE:
// No maneja autenticación OTP ni bootstrap de sesión.
// No decide rutas de navegación global.
//
// PRINCIPIOS:
// - Registro progresivo y reanudable
// - Idempotencia en verificación de username
// - Separación de responsabilidades (UseCases)
//
// ENTERPRISE NOTES:
// checkUsernameIdempotent es NOT nullable para mantener compatibilidad con DI de GetX.
// detectExistingUsername: Isar progress → Firestore one-shot (evita doble-verdad).
// resumeRegistration(): progress.step como única fuente de verdad del wizard.
// finalizeRegistration(): orden garantizado: finalizeUC → session.init → clear → navigate.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../core/utils/workspace_normalizer.dart';
import '../../../data/datasources/local/registration_progress_ds.dart';
import '../../../data/models/auth/registration_progress_model.dart';
import '../../../domain/adapters/workspace_context_adapter.dart';
import '../../../domain/entities/org/organization_entity.dart';
import '../../../domain/entities/user/active_context.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/entities/workspace/registration_workspace_intent.dart';
import '../../../domain/entities/workspace/workspace_type.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/services/registration/registration_workspace_resolver.dart';
import '../../../domain/usecases/check_username_available_uc.dart';
import '../../../domain/usecases/finalize_registration_uc.dart';
import '../../../domain/usecases/sign_up_username_password_uc.dart';
import '../../../domain/value/workspace/business_mode.dart';
import '../../../routes/app_pages.dart';
import '../../../services/telemetry/telemetry_service.dart';
import '../../controllers/session_context_controller.dart';
import '../../controllers/workspace_controller.dart';

class RegistrationController extends GetxController {
  final CheckUsernameAvailableUC checkUsername;
  final CheckUsernameAvailabilityUC checkUsernameIdempotent;
  final SignUpUsernamePasswordUC signUp;
  final RegistrationProgressDS progressDS;
  final FinalizeRegistrationUC finalizeUC;

  RegistrationController({
    required this.checkUsername,
    required this.checkUsernameIdempotent,
    required this.signUp,
    required this.progressDS,
    required this.finalizeUC,
  });

  final Rx<RegistrationProgressModel?> progress =
      Rx<RegistrationProgressModel?>(null);
  final RxString message = ''.obs;

  // Anti-race lock para eliminación de workspace
  bool _isRemovingWorkspace = false;

  // Estado efímero para UI
  final RxString titularType = ''.obs; // 'persona' | 'empresa'
  final RxString providerType = ''.obs; // 'servicios' | 'articulos'
  final RxList<String> providerCategories =
      <String>[].obs; // mapea a categories

  Future<void> setProviderType(String type, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.providerType = type;
    providerType.value = type;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setAssetTypes(List<String> ids, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.assetTypeIds = ids;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setBusinessCategory(String catId,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.businessCategoryId = catId;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setAssetSegments(List<String> segs,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.assetSegmentIds = segs;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setOfferingLines(List<String> lines,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.offeringLineIds = lines;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setProviderCoverage(List<String> cities,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.coverageCities = cities;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setTitularType(String tipo, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.titularType = tipo;
    titularType.value = tipo;
    progress.value = await progressDS.upsert(p);
  }

  // Mantén esta variante efímera pero sin lista providerTypes
  Future<void> setProviderTypeEphemeral(String type,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.providerType = type;
    providerType.value = type;
    progress.value = await progressDS.upsert(p);
  }

  // Mapea categorías efímeras a 'categories' del modelo
  Future<void> setProviderCategoriesEphemeral(List<String> cats,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.categories = cats;
    providerCategories.assignAll(cats);
    progress.value = await progressDS.upsert(p);
  }

  // Consultas utilitarias
  bool isProviderOf(String type) {
    // Ya no existe providerTypes; compara contra el tipo activo
    return progress.value?.providerType == type;
  }

  Future<void> loadProgress([String id = 'current']) async {
    final p = await progressDS.get(id) ??
        (RegistrationProgressModel()
          ..id = id
          ..step = 0
          ..updatedAt = DateTime.now().toUtc());
    progress.value = await progressDS.upsert(p);
    providerType.value = p.providerType ?? '';
    titularType.value = p.titularType ?? '';
    providerCategories.assignAll(p.categories);
  }

  Future<void> saveStep(int step, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.step = step;
    progress.value = await progressDS.upsert(p);
  }

  /// Verificación idempotente de username.
  /// ownedByCurrentUser → permitir continuar (sin error).
  /// takenByOtherUser   → mostrar error.
  Future<bool> isUsernameAvailable(String username) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final result = await checkUsernameIdempotent(username, uid);
      switch (result) {
        case UsernameCheckResult.available:
        case UsernameCheckResult.ownedByCurrentUser:
          return true;
        case UsernameCheckResult.takenByOtherUser:
          message.value = 'El usuario no está disponible';
          return false;
      }
    }
    // Fallback legacy (uid null, e.g. estado transitorio)
    final ok = await checkUsername(username);
    if (!ok) message.value = 'El usuario no está disponible';
    return ok;
  }

  /// Detecta si el usuario ya completó el paso de username en una sesión anterior.
  /// Prioridad: (1) progreso Isar → (2) Firestore one-shot (evita doble-verdad).
  /// Retorna el username encontrado, o null si el paso no se ha completado.
  Future<String?> detectExistingUsername(String uid) async {
    // 1) Progreso local (Isar)
    final prog = progress.value ?? await progressDS.get('current');
    if (prog?.username != null && prog!.username!.isNotEmpty) {
      return prog.username;
    }
    // 2) Firestore one-shot: usuarios/{uid}.username
    try {
      final authRepo = Get.find<AuthRepository>();
      return await authRepo.fetchUsernameForUid(uid);
    } catch (e) {
      debugPrint('[RegistrationController] detectExistingUsername error: $e');
      return null;
    }
  }

  Future<String> createAccount({
    required String username,
    required String password,
    required String phone,
    String id = 'current',
  }) async {
    final uid = await signUp(
      username: username,
      password: password,
      phoneNumber: phone,
    );
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.username = username;
    p.passwordSet = true;
    p.phone = phone;
    p.step = 1;
    progress.value = await progressDS.upsert(p);
    return uid;
  }

  Future<void> setPhone(String phone, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.phone = phone;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setEmail(String email, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.email = email;
    p.step = 2;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setIdentity({
    required String docType,
    required String docNumber,
    required String barcodeRaw,
    String id = 'current',
  }) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.docType = docType;
    p.docNumber = docNumber;
    p.barcodeRaw = barcodeRaw;
    p.step = 3;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setLocation({
    required String countryId,
    String? regionId,
    String? cityId,
    String id = 'current',
  }) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.countryId = countryId;
    p.regionId = regionId;
    p.cityId = cityId;
    p.step = 4;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setRole(String role, {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.selectedRole = role;
    p.step = 5;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> clearSelectedRole({String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.selectedRole = null;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setAdminFollowUp(String followUp,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.adminFollowUp = followUp;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setOwnerFollowUp(String followUp,
      {String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.ownerFollowUp = followUp;
    progress.value = await progressDS.upsert(p);
  }

  /// Mapea el código interno de rol a etiqueta legible y workspace por defecto.
  /// Ajusta aquí si en el futuro un rol debe abrir un workspace distinto al nombre.
  String _labelForRole(String code) {
    switch (code) {
      case 'admin_activos_ind':
      case 'admin_activos_org':
        return 'Administrador';
      case 'propietario':
      case 'propietario_emp':
        return 'Propietario';
      case 'proveedor':
        return 'Proveedor';
      case 'arrendatario':
      case 'arrendatario_emp':
        return 'Arrendatario';
      case 'asesor_seguros':
        return 'Asesor de seguros';
      case 'aseguradora':
        return 'Aseguradora';
      case 'abogado':
      case 'abogados_firma':
        return 'Abogado';
      default:
        // Fallback: usa el code tal cual si no hay mapeo
        return code;
    }
  }

  /// Calcula y retorna los roles y workspaces basándose en la lógica de negocio
  /// Sin efectos secundarios - solo calcula y retorna
  AccessPreview resolveAccessPreview({
    required String? selectedRole,
    String? adminFollowUp,
    String? ownerFollowUp,
  }) {
    final roles = <String>{};
    final workspaces = <String>{};

    final isAdminRole = selectedRole != null &&
        (selectedRole.startsWith('admin_activos') ||
            selectedRole == 'admin_activos_org');

    final isOwnerRole =
        selectedRole == 'propietario' || selectedRole == 'propietario_emp';

    if (isAdminRole) {
      // Admin → siempre workspace Administrador
      roles.add('Administrador');
      workspaces.add('Administrador');

      // Admin both → también Propietario
      if (adminFollowUp == 'both') {
        roles.add('Propietario');
        workspaces.add('Propietario');
      }
    } else if (isOwnerRole) {
      // Propietario según follow-up
      if (ownerFollowUp == 'self') {
        roles.add('Administrador');
        workspaces.add('Administrador');
      } else if (ownerFollowUp == 'third') {
        roles.add('Propietario');
        workspaces.add('Propietario');
      } else if (ownerFollowUp == 'both') {
        roles.addAll(['Propietario', 'Administrador']);
        workspaces.addAll(['Administrador', 'Propietario']);
      }
    } else if (selectedRole != null && selectedRole.isNotEmpty) {
      // Otros roles → habilita el rol seleccionado y su workspace homónimo
      final label = _labelForRole(selectedRole);
      roles.add(label);
      workspaces.add(label);
    }

    return AccessPreview(
      roles: roles.toList(),
      workspaces: workspaces.toList(),
    );
  }

  /// Calcula y guarda los roles y workspaces finales basándose en la lógica de negocio
  Future<void> resolveAndSaveWorkspaces({
    required String selectedRole,
    String? adminFollowUp,
    String? ownerFollowUp,
    String id = 'current',
  }) async {
    final p = progress.value ?? await progressDS.get(id);
    if (p == null) return;

    // Usar el resolver para calcular
    final preview = resolveAccessPreview(
      selectedRole: selectedRole,
      adminFollowUp: adminFollowUp,
      ownerFollowUp: ownerFollowUp,
    );

    // Guardar los roles y workspaces resueltos
    p.resolvedRoles = preview.roles;
    p.resolvedWorkspaces = preview.workspaces;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> acceptTerms({String id = 'current'}) async {
    final p = progress.value ??
        (RegistrationProgressModel()
          ..id = id
          ..updatedAt = DateTime.now().toUtc());
    p.termsAccepted = true;
    p.step = 6;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> clear([String id = 'current']) async {
    await progressDS.clear(id);
    progress.value = null;
    providerType.value = '';
    titularType.value = '';
    providerCategories.clear();
  }

  /// Elimina un workspace del progreso de registro (para usuarios no autenticados en modo guest)
  /// - Normaliza con WorkspaceNormalizer
  /// - Actualiza selectedRole si era el activo (policy alfabético)
  /// - Sincroniza con WorkspaceController con source:'guest'
  /// - Anti-race lock con finally
  Future<void> removeWorkspaceFromProgress(String workspace,
      {String id = 'current'}) async {
    // Anti-race: si ya hay una eliminación en curso, salir
    if (_isRemovingWorkspace) {
      debugPrint(
          '[RegistrationController] Remove already in progress, skipping');
      return;
    }

    final p = progress.value ?? await progressDS.get(id);
    if (p == null) return;

    final normalized = WorkspaceNormalizer.normalize(workspace);
    final wasActive = p.selectedRole != null &&
        WorkspaceNormalizer.areEqual(p.selectedRole!, workspace);

    _isRemovingWorkspace = true;

    try {
      final startTime = DateTime.now();

      // Filtrar workspace y rol de las listas usando WorkspaceNormalizer
      p.resolvedWorkspaces = p.resolvedWorkspaces
          .where((w) => !WorkspaceNormalizer.areEqual(w, workspace))
          .toList();
      p.resolvedRoles = p.resolvedRoles
          .where((r) => !WorkspaceNormalizer.areEqual(r, workspace))
          .toList();

      final latency = DateTime.now().difference(startTime).inMilliseconds;

      // Si borramos el workspace activo, seleccionar siguiente con política determinística
      String? newActiveRole;
      String? selectionRule;

      if (wasActive) {
        // Política: alfabético → vacío
        if (p.resolvedWorkspaces.isNotEmpty) {
          newActiveRole = WorkspaceNormalizer.findNextAlphabetic(
            p.resolvedWorkspaces,
          );
          selectionRule = 'alpha';
        } else {
          selectionRule = 'empty';
        }

        p.selectedRole = newActiveRole;

        _logTelemetry('workspace_switched_auto', {
          'from': normalized,
          'to': newActiveRole ?? '',
          'cause': 'deleted_active',
          'rule': selectionRule,
          'ctx': 'guest',
        });

        // Forzar navegación al nuevo workspace (cierra vista del eliminado)
        // HomeRouter redirigirá automáticamente al workspace correcto
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != Routes.home) {
            Get.offAllNamed(Routes.home);
          }
        });
      }

      progress.value = await progressDS.upsert(p);

      // Sincronizar con WorkspaceController
      await syncToWorkspaceController();

      _logTelemetry('workspace_delete_success', {
        'workspace': normalized,
        'wasActive': wasActive,
        'newActiveRole': newActiveRole,
        'rule': selectionRule,
        'latency_ms': latency,
        'ctx': 'guest',
      });
    } catch (e) {
      _logTelemetry('workspace_delete_error', {
        'workspace': normalized,
        'error': e.toString(),
        'ctx': 'guest',
      });
      rethrow;
    } finally {
      _isRemovingWorkspace = false;
    }
  }

  /// Sincroniza el progreso de registro con WorkspaceController (modo guest)
  Future<void> syncToWorkspaceController() async {
    if (!Get.isRegistered<WorkspaceController>()) return;

    try {
      final workspaceController = Get.find<WorkspaceController>();
      final p = progress.value;

      if (p != null) {
        await workspaceController.syncFromRegistrationProgress(
          p.resolvedWorkspaces,
          p.selectedRole,
        );
      }
    } catch (e) {
      debugPrint('[RegistrationController] Error syncing workspaces: $e');
    }
  }

  /// Helper para telemetría
  void _logTelemetry(String event, Map<String, dynamic> extras) {
    try {
      if (Get.isRegistered<TelemetryService>()) {
        Get.find<TelemetryService>().log(event, extras);
      }
    } catch (e) {
      debugPrint('[RegistrationController] Telemetry error: $e');
    }
  }

  /// Reanuda el wizard de registro navegando al paso correcto según progress.step.
  /// step=0 → registerUsername, step=1 → registerEmail, etc.
  Future<void> resumeRegistration() async {
    final step = progress.value?.step ?? 0;
    debugPrint('[RegistrationController] resumeRegistration: step=$step');
    switch (step) {
      case 1:
        Get.offAllNamed(Routes.registerEmail);
        break;
      case 2:
        Get.offAllNamed(Routes.registerIdScan);
        break;
      case 3:
        Get.offAllNamed(Routes.countryCity);
        break;
      case 4:
        Get.offAllNamed(Routes.profile);
        break;
      case 5:
        Get.offAllNamed(Routes.registerSummary);
        break;
      case 6:
        Get.offAllNamed(Routes.registerSummary);
        break;
      default:
        Get.offAllNamed(Routes.registerUsername);
    }
  }

  /// Finaliza el registro del usuario.
  ///
  /// Orden garantizado:
  /// 1. Escribe UserProfileEntity legacy (Firestore userProfiles — backward compat).
  /// 2. Crea Organization + UserEntity (con activeContext) + Membership en
  ///    isar.userModels y isar.membershipModels.
  ///    → Esto es lo que SessionContextController._getLocalUserOnly() leerá.
  /// 3. Re-hidrata sesión: session.init() → hydrationState = authOkProfileReady.
  /// 4. Limpia progress de Isar.
  ///
  /// Sin esta secuencia bootstrap veía userModels vacío → authOkProfileEmpty → loop.
  Future<void> finalizeRegistration({String id = 'current'}) async {
    final p = progress.value ?? await progressDS.get(id);
    if (p == null) throw StateError('No hay progreso de registro');

    final auth = Get.find<FirebaseAuth>();
    final currentUser = auth.currentUser;
    if (currentUser == null) throw StateError('Usuario no autenticado');

    final uid = currentUser.uid;
    final phone = p.phone ?? currentUser.phoneNumber ?? '';
    final selectedRole = (p.selectedRole?.isNotEmpty == true)
        ? p.selectedRole!
        : 'admin_activos_ind';
    final now = DateTime.now().toUtc();

    // ── 1. Perfil legacy (UserProfileEntity → Firestore userProfiles) ──────
    // Conservado para compatibilidad con lecturas que usan IsarSessionDS.
    final profile = UserProfileEntity(
      uid: uid,
      phone: phone,
      username: p.username,
      email: p.email,
      countryId: p.countryId,
      regionId: p.regionId,
      cityId: p.cityId,
      roles: [selectedRole],
      orgIds: const [],
      docType: p.docType,
      docNumber: p.docNumber,
      identityRaw: p.barcodeRaw,
      termsVersion: 'v1',
      termsAcceptedAt: p.termsAccepted ? now : null,
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );
    await finalizeUC(profile);

    // ── 2. Organización ────────────────────────────────────────────────────
    // Genera un orgId determinístico pero único para este usuario.
    final orgId = 'org_${uid.hashCode.abs()}_${now.millisecondsSinceEpoch}';
    final isEmpresa = (p.titularType ?? '').toLowerCase() == 'empresa';

    // Nombre de display: display name de Firebase (Google/Apple) o teléfono.
    final displayName = currentUser.displayName ??
        (phone.isNotEmpty ? phone : currentUser.email ?? 'Usuario');

    final orgName = isEmpresa
        ? (p.companyName?.trim().isNotEmpty == true
            ? p.companyName!.trim()
            : displayName)
        : displayName;

    final organization = OrganizationEntity(
      id: orgId,
      nombre: orgName,
      tipo: isEmpresa ? 'empresa' : 'personal',
      countryId: p.countryId ?? 'CO',
      regionId: (p.regionId?.isNotEmpty == true) ? p.regionId : null,
      cityId: p.cityId,
      ownerUid: uid,
      createdAt: now,
      updatedAt: now,
    );
    await DIContainer().orgRepository.upsertOrg(organization);

    // ── 3. UserEntity (con activeContext) → isar.userModels ───────────────
    // CRÍTICO: SessionContextController._getLocalUserOnly() lee isar.userModels.
    // Sin este upsert, hydrationState queda en authOkProfileEmpty y bootstrap loopea.
    final activeCtx = ActiveContext(
      orgId: orgId,
      orgName: orgName,
      rol: selectedRole,
      providerType: p.providerType,
    );
    final userEntity = UserEntity(
      uid: uid,
      name: displayName,
      email: currentUser.email ?? p.email ?? '',
      phone: phone.isNotEmpty ? phone : null,
      countryId: p.countryId,
      activeContext: activeCtx,
      createdAt: now,
      updatedAt: now,
    );
    await DIContainer().userRepository.upsertUser(userEntity);

    // ── 4. Membership (roles + org) → isar.membershipModels ───────────────
    final membership = MembershipEntity(
      userId: uid,
      orgId: orgId,
      orgName: orgName,
      roles: [selectedRole],
      estatus: 'activo',
      primaryLocation: {
        'countryId': p.countryId ?? 'CO',
        if (p.regionId?.isNotEmpty == true) 'regionId': p.regionId!,
        if (p.cityId?.isNotEmpty == true) 'cityId': p.cityId!,
      },
      createdAt: now,
      updatedAt: now,
    );
    await DIContainer().userRepository.upsertMembership(membership);

    // ── 4b. FASE 2 — Contrato tipado (no-fatal) ───────────────────────────
    // Si el resolver falla, el bootstrap legacy sigue funcionando (Gate 4
    // Steps 2-4). Se registra el error en debug pero NO interrumpe el flujo.
    await _tryApplyFase2Contract(
      p: p,
      uid: uid,
      orgId: orgId,
      orgName: orgName,
      legacySelectedRole: selectedRole,
    );

    // ── 5. Re-hidratar sesión ─────────────────────────────────────────────
    // resetForLogout() limpia el single-flight guard → _doInit() corre fresco.
    // Ahora _getLocalUserOnly() encontrará el UserModel recién creado →
    // hydrationState = authOkProfileReady → bootstrap pasa Gate 2 y Gate 3.
    if (Get.isRegistered<SessionContextController>()) {
      try {
        final session = Get.find<SessionContextController>();
        session.resetForLogout();
        await session.init(uid);
      } catch (e) {
        debugPrint(
            '[RegistrationController] session rehydration error (non-fatal): $e');
      }
    }

    // ── 6. Limpiar progreso (después de re-hidratar, no antes) ────────────
    await clear(id);
  }

  // ==========================================================================
  // FASE 2 — Bloque de resolución tipada (no-fatal)
  // ==========================================================================

  /// Intenta aplicar el contrato tipado de Fase 2.
  ///
  /// Si el resolver falla por cualquier motivo (combinación no mapeada,
  /// campos faltantes, inconsistencia), registra el error en debug y retorna
  /// sin lanzar. El bootstrap legacy (Gate 4 Steps 2-4) actúa como fallback.
  Future<void> _tryApplyFase2Contract({
    required RegistrationProgressModel p,
    required String uid,
    required String orgId,
    required String orgName,
    required String legacySelectedRole,
  }) async {
    try {
      final workspaceType = WorkspaceContextAdapter.resolveType(
        normalizedRole:
            WorkspaceContextAdapter.normalizeRole(legacySelectedRole),
        normalizedProviderType:
            WorkspaceContextAdapter.normalizeProviderType(p.providerType),
      );

      if (workspaceType == WorkspaceType.unknown) {
        debugPrint(
            '[Fase2] workspaceType unknown para role=$legacySelectedRole — skip');
        return;
      }

      final businessMode = _deriveBusinessMode(
        workspaceType: workspaceType,
        adminFollowUp: p.adminFollowUp,
        ownerFollowUp: p.ownerFollowUp,
      );

      if (businessMode == null) {
        debugPrint(
            '[Fase2] businessMode no derivable para type=${workspaceType.wireName} — skip');
        return;
      }

      final orgType = (p.titularType ?? '').toLowerCase() == 'empresa'
          ? 'empresa'
          : 'personal';

      final intent = RegistrationWorkspaceIntent(
        workspaceType: workspaceType,
        businessMode: businessMode,
        orgType: orgType,
        providerType:
            p.providerType?.isNotEmpty == true ? p.providerType : null,
      );

      final resolved = const RegistrationWorkspaceResolver().resolve(
        intent: intent,
        userId: uid,
        orgId: orgId,
        orgName: orgName,
      );

      // Doble escritura transicional: canonical legacyRoleCode.
      final canonicalRole = resolved.legacyRoleCode;

      // Actualizar UserEntity.activeContext.rol al rol canónico.
      final existingUser = await DIContainer().userRepository.getUser(uid);
      if (existingUser != null) {
        final updatedCtx = existingUser.activeContext?.copyWith(
              rol: canonicalRole,
            ) ??
            ActiveContext(
              orgId: orgId,
              orgName: orgName,
              rol: canonicalRole,
              providerType: p.providerType,
            );
        await DIContainer().userRepository.upsertUser(
              existingUser.copyWith(
                activeContext: updatedCtx,
                updatedAt: DateTime.now().toUtc(),
              ),
            );
      }

      // Actualizar Membership.roles[] con el rol canónico.
      //
      // ESTRATEGIA FASE 2: se reemplazan los roles de la membership dejando
      // solo el rol canónico formal. Los códigos internos del wizard (ej.
      // 'admin_activos_ind') son artefactos de onboarding, no roles formales
      // del dominio. Mezclarlos produciría ambigüedad semántica en bootstrap.
      // Solo se preservan roles canónicos formales previos distintos al nuevo.
      final memberships =
          await DIContainer().userRepository.fetchMemberships(uid);
      final existingMembership =
          memberships.where((m) => m.orgId == orgId).firstOrNull;
      if (existingMembership != null) {
        const formalRoles = {
          'propietario',
          'administrador',
          'arrendatario',
          'proveedor_servicios',
          'proveedor_articulos',
        };
        final cleanedRoles = existingMembership.roles
            .where((r) => formalRoles.contains(r) && r != canonicalRole)
            .toList()
          ..add(canonicalRole);

        await DIContainer().userRepository.upsertMembership(
          existingMembership.copyWith(
            roles: cleanedRoles,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }

      // Persistir workspaceId activo.
      // Esta escritura sobrevive al clear() de RegistrationProgressModel y es
      // la fuente de verdad que Gate 4 Step 1 del bootstrap usa para rehidratar
      // el WorkspaceContext sin re-resolver desde legacy.
      await DIContainer()
          .workspaceRepository
          .setActiveWorkspace(resolved.workspaceId);

      // NOTA ARQUITECTÓNICA — seed NO se persiste en RegistrationProgressModel:
      // Sería destruido por clear() al final de finalizeRegistration().
      // La doble escritura a UserEntity.activeContext.rol + WorkspaceRepository
      // es suficiente. SessionContextController reconstruye el contexto desde ahí.

      debugPrint('[Fase2] contrato resuelto: ${resolved.debugDescription}');
    } catch (e, st) {
      debugPrint('[Fase2] resolver no-fatal error: $e\n$st');
    }
  }

  /// Deriva [BusinessMode] desde el workspaceType y los follow-up del progress.
  ///
  /// Retorna null si la combinación no es derivable (indica datos de onboarding
  /// incompletos o un tipo de workspace sin follow-up mapeado).
  /// Deriva [BusinessMode] desde workspaceType + follow-up del wizard.
  ///
  /// REGLA: prefiere null honesto a semántica falsa.
  /// Si la combinación no puede mapearse con los datos disponibles, retorna null
  /// y el bloque Fase 2 hace skip no-fatal → bootstrap legacy actúa como fallback.
  ///
  /// Valores esperados del wizard:
  /// - ownerFollowUp: 'self' | 'third'
  /// - adminFollowUp: 'third' | 'both'  ('own' no mapea a ningún modo de la matriz)
  BusinessMode? _deriveBusinessMode({
    required WorkspaceType workspaceType,
    required String? adminFollowUp,
    required String? ownerFollowUp,
  }) {
    switch (workspaceType) {
      case WorkspaceType.owner:
        final followUp = ownerFollowUp?.trim().toLowerCase();
        if (followUp == 'self') return BusinessMode.selfManaged;
        if (followUp == 'third') return BusinessMode.delegated;
        // Cualquier otro valor (null, 'both', inesperado) → no derivable.
        return null;

      case WorkspaceType.assetAdmin:
        final followUp = adminFollowUp?.trim().toLowerCase();
        if (followUp == 'third') return BusinessMode.thirdParty;
        if (followUp == 'both') return BusinessMode.hybrid;
        // 'own' significa solo activos propios — no está en la matriz formal.
        // null u otro valor inesperado → no derivable.
        return null;

      case WorkspaceType.renter:
        return BusinessMode.consumer;

      case WorkspaceType.workshop:
        return BusinessMode.serviceProvider;

      case WorkspaceType.supplier:
        return BusinessMode.retailer;

      case WorkspaceType.insurer:
      case WorkspaceType.legal:
      case WorkspaceType.advisor:
      case WorkspaceType.unknown:
        return null;
    }
  }

  // --- Shims para compatibilidad con provider_profile_page.dart ---

  Future<void> setSegment(String segment, {String id = 'current'}) async {
    // Antes: progress.segment = segment
    await setAssetTypes([segment], id: id);
  }

  Future<void> setVehicleType(String vehicleType,
      {String id = 'current'}) async {
    // Antes: progress.vehicleType = vehicleType
    await setAssetSegments([vehicleType], id: id);
  }

  Future<void> setProviderCategory(String? category,
      {String id = 'current'}) async {
    // Antes: progress.providerCategory = category
    await setBusinessCategory(category ?? '', id: id);
  }

  Future<void> clearProviderCategory({String id = 'current'}) async {
    await setBusinessCategory('', id: id);
  }

// Accesores de solo lectura para compatibilidad UI:
  List<String> get providerTypesCompat {
    final t = progress.value?.providerType;
    return (t == null || t.isEmpty) ? const <String>[] : <String>[t];
  }

  String? get segmentCompat =>
      (progress.value?.assetTypeIds.isNotEmpty ?? false)
          ? progress.value!.assetTypeIds.first
          : null;

  String? get vehicleTypeCompat =>
      (progress.value?.assetSegmentIds.isNotEmpty ?? false)
          ? progress.value!.assetSegmentIds.first
          : null;

  String? get providerCategoryCompat => progress.value?.businessCategoryId;
}

/// Clase para retornar el resultado de la resolución de roles/workspaces
class AccessPreview {
  final List<String> roles;
  final List<String> workspaces;

  AccessPreview({
    required this.roles,
    required this.workspaces,
  });
}
