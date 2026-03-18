// lib\data\models\auth\registration_progress_model.dart

import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';

part 'registration_progress_model.g.dart';

@isar.Collection()
class RegistrationProgressModel {
  isar.Id? isarId;

  @isar.Index(unique: true, replace: true)
  late String id;

  int step = 0;
  String? phone;
  String? username;
  bool passwordSet = false;
  String? email;

  String? docType;
  String? docNumber;
  String? barcodeRaw;

  String? countryId;
  String? regionId;
  String? cityId;

  String? titularType;
  String? providerType;
  List<String> assetTypeIds = [];
  String? businessCategoryId;
  List<String> assetSegmentIds = [];
  List<String> offeringLineIds = [];
  List<String> coverageCities = [];
  List<String> categories = [];

  String? selectedRole;

  // Respuestas contextuales para roles Admin/Owner
  String? adminFollowUp; // 'own' | 'third' | 'both'
  String? ownerFollowUp; // 'self' | 'third' | 'both'

  // Roles finales computados basados en las respuestas
  List<String> resolvedRoles = []; // Ej: ['Administrador', 'Propietario']
  List<String> resolvedWorkspaces = []; // Ej: ['Administrador', 'Propietario']

  // Campos para registro mejorado con autenticación federada
  String?
      companyName; // Nombre de empresa (obligatorio si titularType == 'empresa')
  String?
      authMethod; // Método de autenticación: 'phone', 'email-password', 'google', 'apple', 'facebook'

  // ==========================================================================
  // FASE 2 — Contrato tipado de onboarding (onboarding_workspace_contract.md)
  // Escritura transicional: estos campos persisten el output de
  // RegistrationWorkspaceResolver para que SplashBootstrapController pueda
  // construir el WorkspaceContext sin re-resolver desde el modelo legacy.
  // ==========================================================================

  /// workspaceId determinístico producido por el resolver.
  /// Null si el registro no completó la Fase 2.
  String? resolvedWorkspaceId;

  /// wireName del WorkspaceType resuelto (ej. 'owner', 'assetAdmin').
  /// Null si el registro no completó la Fase 2.
  String? resolvedWorkspaceTypeName;

  /// wireName del BusinessMode resuelto (ej. 'self_managed', 'third_party').
  /// Null si el registro no completó la Fase 2.
  String? resolvedBusinessModeName;

  /// WorkspaceContextSeed serializado como JSON string.
  /// Deserializar con WorkspaceContextSeed.fromMap(jsonDecode(value)).
  /// Null si el registro no completó la Fase 2.
  String? resolvedWorkspaceContextSeedJson;

  bool termsAccepted = false;

  late DateTime updatedAt;

  RegistrationProgressModel();
}
