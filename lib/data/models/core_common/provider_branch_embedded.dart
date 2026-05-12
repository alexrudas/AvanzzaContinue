// ============================================================================
// lib/data/models/core_common/provider_branch_embedded.dart
// PROVIDER BRANCH EMBEDDED — Isar @embedded de una sede dentro del proveedor
// ============================================================================
// QUÉ HACE:
//   - Embeds `ProviderBranchEntity` dentro de `LocalContactModel` sin crear
//     una colección Isar separada. Isar serializa la lista dentro del
//     mismo registro y el write es atómico con el proveedor.
//
// QUÉ NO HACE:
//   - NO es una colección Isar propia (`@collection`): es `@embedded`.
//   - NO lleva `Id`; el identificador de negocio es `id` (UUID string).
//
// PRINCIPIOS:
//   - Wire-stable en nombres de campo (espejo exacto de la Entity).
//   - Defaults seguros para tolerar registros viejos sin este campo.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../domain/entities/core_common/provider_branch_entity.dart';

part 'provider_branch_embedded.g.dart';

@embedded
class ProviderBranchEmbedded {
  String id;
  String? label;
  String? countryId;
  String? regionId;
  String? cityId;
  String? addressLine;
  String? phoneE164;
  String? contactName;
  String? notes;

  ProviderBranchEmbedded({
    this.id = '',
    this.label,
    this.countryId,
    this.regionId,
    this.cityId,
    this.addressLine,
    this.phoneE164,
    this.contactName,
    this.notes,
  });

  ProviderBranchEntity toEntity() => ProviderBranchEntity(
        id: id,
        label: label,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        addressLine: addressLine,
        phoneE164: phoneE164,
        contactName: contactName,
        notes: notes,
      );

  factory ProviderBranchEmbedded.fromEntity(ProviderBranchEntity e) =>
      ProviderBranchEmbedded(
        id: e.id,
        label: e.label,
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        addressLine: e.addressLine,
        phoneE164: e.phoneE164,
        contactName: e.contactName,
        notes: e.notes,
      );

  /// JSON bridge delegado en la Entity freezed (que ya tiene `fromJson/toJson`
  /// generados). Se expone porque `LocalContactModel` usa `@JsonSerializable`
  /// y el generador necesita saber cómo serializar campos embebidos.
  Map<String, dynamic> toJson() => toEntity().toJson();

  factory ProviderBranchEmbedded.fromJson(Map<String, dynamic> json) =>
      ProviderBranchEmbedded.fromEntity(ProviderBranchEntity.fromJson(json));
}
