import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/usecases/check_username_available_uc.dart';
import '../../../domain/usecases/sign_up_username_password_uc.dart';
import '../../../domain/usecases/finalize_registration_uc.dart';
import '../../../data/datasources/local/registration_progress_ds.dart';
import '../../../data/models/auth/registration_progress_model.dart';
import '../../../domain/entities/user_profile_entity.dart';

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

  final Rx<RegistrationProgressModel?> progress = Rx<RegistrationProgressModel?>(null);
  final RxString message = ''.obs;

  Future<void> loadProgress([String id = 'current']) async {
    progress.value = await progressDS.get(id) ?? (RegistrationProgressModel()
      ..id = id
      ..step = 0
      ..updatedAt = DateTime.now().toUtc());
  }

  Future<void> saveStep(int step, {String id = 'current'}) async {
    final p = progress.value ?? (RegistrationProgressModel()
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

  Future<String> createAccount({required String username, required String password, required String phone, String id = 'current'}) async {
    final uid = await signUp(username: username, password: password, phoneNumber: phone);
    final p = progress.value ?? (RegistrationProgressModel()
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
    final p = progress.value ?? (RegistrationProgressModel()
      ..id = id
      ..updatedAt = DateTime.now().toUtc());
    p.phone = phone;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setEmail(String email, {String id = 'current'}) async {
    final p = progress.value ?? (RegistrationProgressModel()
      ..id = id
      ..updatedAt = DateTime.now().toUtc());
    p.email = email;
    p.step = 2;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setIdentity({required String docType, required String docNumber, required String barcodeRaw, String id = 'current'}) async {
    final p = progress.value ?? (RegistrationProgressModel()
      ..id = id
      ..updatedAt = DateTime.now().toUtc());
    p.docType = docType;
    p.docNumber = docNumber;
    p.barcodeRaw = barcodeRaw;
    p.step = 3;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setLocation({required String countryId, String? regionId, required String cityId, String id = 'current'}) async {
    final p = progress.value ?? (RegistrationProgressModel()
      ..id = id
      ..updatedAt = DateTime.now().toUtc());
    p.countryId = countryId;
    p.regionId = regionId;
    p.cityId = cityId;
    p.step = 4;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> setRole(String role, {String id = 'current'}) async {
    final p = progress.value ?? (RegistrationProgressModel()
      ..id = id
      ..updatedAt = DateTime.now().toUtc());
    p.selectedRole = role;
    p.step = 5;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> acceptTerms({String id = 'current'}) async {
    final p = progress.value ?? (RegistrationProgressModel()
      ..id = id
      ..updatedAt = DateTime.now().toUtc());
    p.termsAccepted = true;
    p.step = 6;
    progress.value = await progressDS.upsert(p);
  }

  Future<void> clear([String id = 'current']) async {
    await progressDS.clear(id);
    progress.value = null;
  }

  Future<void> finalizeRegistration({String id = 'current'}) async {
    final p = progress.value ?? await progressDS.get(id);
    if (p == null) throw StateError('No hay progreso de registro');
    final auth = Get.find<FirebaseAuth>();
    final uid = auth.currentUser?.uid;
    if (uid == null) throw StateError('Usuario no autenticado');
    final phone = p.phone ?? auth.currentUser?.phoneNumber ?? '';
    final roles = <String>[];
    if (p.selectedRole != null && p.selectedRole!.isNotEmpty) roles.add(p.selectedRole!);

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
}
