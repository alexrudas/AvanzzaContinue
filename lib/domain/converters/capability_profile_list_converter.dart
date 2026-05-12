// ============================================================================
// lib/domain/converters/capability_profile_list_converter.dart
// JsonConverter centralizado para List<CapabilityProfile>.
// ============================================================================
// QUÉ HACE:
//   - fromJson: acepta List<dynamic> (típicamente List<Map<String,dynamic>>),
//     mapea cada item con CapabilityProfile.fromJson. Acepta null/[] como
//     lista vacía.
//   - toJson: produce List<Map<String,dynamic>> (cada item via toJson del
//     CapabilityProfile).
//
// CONTRATO:
//   - El dominio acepta colecciones de capability profiles en JSON canónico.
//   - Items malformados (kind desconocido, spec ausente, etc.) propagan
//     ArgumentError desde CapabilityProfile.fromJson — el path estricto NO
//     se degrada aquí.
//   - Para parse tolerante (datos legacy), usar el adapter
//     LegacyCapabilitySpecAdapter en data layer; este converter es para
//     datos canónicos producidos por la propia plataforma.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../value/capability/capability_profile.dart';

class CapabilityProfileListConverter
    implements
        JsonConverter<List<CapabilityProfile>, List<dynamic>?> {
  const CapabilityProfileListConverter();

  @override
  List<CapabilityProfile> fromJson(List<dynamic>? json) {
    if (json == null || json.isEmpty) return const <CapabilityProfile>[];
    return json
        .map((raw) {
          if (raw is Map<String, dynamic>) {
            return CapabilityProfile.fromJson(raw);
          }
          if (raw is Map) {
            return CapabilityProfile.fromJson(
              Map<String, dynamic>.from(raw),
            );
          }
          throw ArgumentError(
            'CapabilityProfileListConverter: cada elemento debe ser '
            'Map<String, dynamic>, recibido: ${raw.runtimeType}',
          );
        })
        .toList(growable: false);
  }

  @override
  List<dynamic> toJson(List<CapabilityProfile> object) =>
      object.map((p) => p.toJson()).toList(growable: false);
}
