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
  bool termsAccepted = false;

  late DateTime updatedAt;

  RegistrationProgressModel();
}
