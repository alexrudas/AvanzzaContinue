import 'package:isar_community/isar.dart';

part 'registration_progress_model.g.dart';

@Collection()
class RegistrationProgressModel {
  Id? isarId;
  @Index(unique: true, replace: true)
  late String id; // e.g., 'current' or phone

  int step = 0; // 0..N

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

  // Perfil del proveedor (unificado)
  String?
      segment; // 'vehiculos'|'inmuebles'|'equipos_construccion'|'maquinaria'|'otros_equipos'
  String? vehicleType; // si segment == 'vehiculos'
  String? providerCategory; // categoría dependiente del segmento

  // Onboarding consolidado
  String? titularType; // 'persona' | 'empresa'
  String? providerType; // 'servicios' | 'articulos'
  // Consolidado proveedor (legacy)
  List<String> assetTypeIds =
      []; // ['vehiculos','inmuebles','maquinaria','equipos','otros']
  String?
      businessCategoryId; // ej: 'lubricentro'|'ferreteria'|'mecanico_independiente'
  List<String> assetSegmentIds = []; // ['moto','auto','camion'] si aplica
  List<String> offeringLineIds = []; // opcional
  List<String> coverageCities = []; // ['CO/ANT/MEDELLIN', ...]
  List<String> categories = []; // legacy (mantener por compatibilidad)

  String? selectedRole;
  bool termsAccepted = false;

  late DateTime updatedAt;

  RegistrationProgressModel();
}
