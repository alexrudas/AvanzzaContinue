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
  String? companyName; // Nombre de empresa (obligatorio si titularType == 'empresa')
  String? authMethod; // Método de autenticación: 'phone', 'email-password', 'google', 'apple', 'facebook'

  bool termsAccepted = false;

  late DateTime updatedAt;

  RegistrationProgressModel();
}
