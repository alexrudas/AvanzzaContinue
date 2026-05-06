import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/capability_profile_list_converter.dart';
import '../../value/capability/capability_profile.dart';
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

    /// Capacidades que el Workspace ofrece al mercado (provider/advisor/
    /// broker/legal/insurer). Default seguro: lista vacía (workspace sin
    /// oferta declarada al mercado, ej. workspace personal).
    /// Aplicada `@CapabilityProfileListConverter()` para serialización
    /// canónica de la lista; cada item debe cumplir el contrato estricto
    /// de CapabilityProfile (kind discriminator + exactamente 1 spec poblada).
    @Default(<CapabilityProfile>[])
    @CapabilityProfileListConverter()
    List<CapabilityProfile> capabilityProfiles,

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
