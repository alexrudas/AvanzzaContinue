import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/datasources/local/registration_progress_ds.dart';
import '../../../data/models/auth/registration_progress_model.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/usecases/check_username_available_uc.dart';
import '../../../domain/usecases/finalize_registration_uc.dart';
import '../../../domain/usecases/sign_up_username_password_uc.dart';

class RegistrationController extends GetxController {
  final CheckUsernameAvailableUC checkUsername;
  final SignUpUsernamePasswordUC signUp;
  final RegistrationProgressDS progressDS;
  final FinalizeRegistrationUC finalizeUC;

  RegistrationController({
    required this.checkUsername,
    required this.signUp,
    required this.progressDS,
    required this.finalizeUC,
  });

  final Rx<RegistrationProgressModel?> progress =
      Rx<RegistrationProgressModel?>(null);
  final RxString message = ''.obs;

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

  Future<bool> isUsernameAvailable(String username) async {
    final ok = await checkUsername(username);
    if (!ok) message.value = 'El usuario no está disponible';
    return ok;
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

  Future<void> finalizeRegistration({String id = 'current'}) async {
    final p = progress.value ?? await progressDS.get(id);
    if (p == null) throw StateError('No hay progreso de registro');
    final auth = Get.find<FirebaseAuth>();
    final uid = auth.currentUser?.uid;
    if (uid == null) throw StateError('Usuario no autenticado');
    final phone = p.phone ?? auth.currentUser?.phoneNumber ?? '';
    final roles = <String>[];
    if (p.selectedRole != null && p.selectedRole!.isNotEmpty) {
      roles.add(p.selectedRole!);
    }

    final profile = UserProfileEntity(
      uid: uid,
      phone: phone,
      username: p.username,
      email: p.email,
      countryId: p.countryId,
      regionId: p.regionId,
      cityId: p.cityId,
      roles: roles,
      orgIds: const [],
      docType: p.docType,
      docNumber: p.docNumber,
      identityRaw: p.barcodeRaw,
      termsVersion: 'v1',
      termsAcceptedAt: p.termsAccepted ? DateTime.now().toUtc() : null,
      status: 'active',
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    await finalizeUC(profile);
    await clear(id);
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
