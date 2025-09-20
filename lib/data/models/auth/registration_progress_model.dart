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

  String? selectedRole;
  bool termsAccepted = false;

  late DateTime updatedAt;

  RegistrationProgressModel();
}
