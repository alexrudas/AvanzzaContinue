import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user/user_entity.dart' as domain;
import '../geo/address_model.dart';
import 'active_context_model.dart';

part 'user_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class UserModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? tipoDoc;
  final String? numDoc;
  final String? countryId;
  final String? preferredLanguage;
  final ActiveContextModel? activeContext;
  final List<AddressModel>? addresses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.isarId,
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.tipoDoc,
    this.numDoc,
    this.countryId,
    this.preferredLanguage,
    this.activeContext,
    this.addresses,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  factory UserModel.fromFirestore(String docId, Map<String, dynamic> json) =>
      UserModel.fromJson({...json, 'uid': docId});

  factory UserModel.fromEntity(domain.UserEntity e) => UserModel(
        uid: e.uid,
        name: e.name,
        email: e.email,
        phone: e.phone,
        tipoDoc: e.tipoDoc,
        numDoc: e.numDoc,
        countryId: e.countryId,
        preferredLanguage: e.preferredLanguage,
        activeContext: e.activeContext == null
            ? null
            : ActiveContextModel.fromEntity(e.activeContext!),
        addresses: e.addresses?.map(AddressModel.fromEntity).toList(),
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.UserEntity toEntity() => domain.UserEntity(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        tipoDoc: tipoDoc,
        numDoc: numDoc,
        countryId: countryId,
        preferredLanguage: preferredLanguage,
        activeContext: activeContext?.toEntity(),
        addresses: addresses?.map((e) => e.toEntity()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
