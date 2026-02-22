import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value/organization_contract/organization_access_contract.dart';

part 'organization_entity.freezed.dart';
part 'organization_entity.g.dart';

@freezed
abstract class OrganizationEntity with _$OrganizationEntity {
  const factory OrganizationEntity({
    required String id,
    required String nombre,
    required String tipo, // empresa | personal
    required String countryId,
    String? regionId,
    String? cityId,
    String? ownerUid,
    String? logoUrl,
    String? nitOrTaxId, // NUEVO
    Map<String, dynamic>? metadata,

    /// Contrato de acceso de la organización.
    /// Default seguro: deny-by-default (localOnly, sin IA, sin capacidades, 0 assets/members).
    @Default(OrganizationAccessContract()) OrganizationAccessContract contract,

    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrganizationEntity;

  factory OrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$OrganizationEntityFromJson(json);
}
