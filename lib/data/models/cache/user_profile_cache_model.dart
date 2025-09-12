import 'package:avanzza/data/models/user_profile_model.dart';
import 'package:isar_community/isar.dart';


part 'user_profile_cache_model.g.dart';

@Collection()
class UserProfileCacheModel {
  Id? isarId;
  @Index(unique: true, replace: true)
  late String uid;
  String? phone;
  String? countryId;
  String? cityId;
  List<String> roles = const [];
  List<String> orgIds = const [];
  String status = 'active';
  DateTime? createdAt;
  DateTime? updatedAt;

  UserProfileCacheModel();

  factory UserProfileCacheModel.fromRemote(UserProfileModel r) {
    final m = UserProfileCacheModel();
    m.uid = r.uid;
    m.phone = r.phone;
    m.countryId = r.countryId;
    m.cityId = r.cityId;
    m.roles = r.roles;
    m.orgIds = r.orgIds;
    m.status = r.status;
    m.createdAt = r.createdAt;
    m.updatedAt = r.updatedAt;
    return m;
  }

  UserProfileModel toRemote() => UserProfileModel(
        uid: uid,
        phone: phone ?? '',
        countryId: countryId,
        cityId: cityId,
        roles: roles,
        orgIds: orgIds,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
