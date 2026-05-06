// ============================================================================
// lib/domain/services/onboarding/intent_mapping_result.dart
// IntentMappingResult — output canónico de mapIntentToCanonical.
// ============================================================================
// QUÉ HACE:
//   - Agrupa los 3 outputs producidos a partir del intent capturado en
//     Q3/Q4 del onboarding:
//       · capabilityProfiles → lo que el Workspace ofrece al mercado.
//       · expectedRelationKind → intent de relación con activos (null si
//         el workspace NO mantiene activos como owner/manager/renter).
//       · shellMode → modo de UI shell que se renderiza después de
//         CompleteOnboardingUC.
//
// QUÉ NO HACE:
//   - NO incluye Membership.roles. El fundador SIEMPRE recibe `[admin]`
//     en CompleteOnboardingUC; el mapper de intent NO escribe roles.
//   - NO incluye Organization.tipo. Eso se deriva exclusivamente de
//     Q4.titularType en CompleteOnboardingUC.
//   - NO produce navegación ni efectos secundarios; es solo data.
// ============================================================================

import '../../entities/core_common/value_objects/asset_actor_role.dart';
import '../../value/capability/capability_profile.dart';
import '../../value/migration/legacy_migration_warning.dart';
import 'shell_mode.dart';

class IntentMappingResult {
  /// Capabilities que el workspace declara ofrecer al mercado.
  /// Lista vacía cuando el intent del workspace NO incluye oferta
  /// (caso owner/assetAdmin/renter: mantienen/usan assets, no ofrecen
  /// servicios al mercado).
  final List<CapabilityProfile> capabilityProfiles;

  /// Intent de relación del workspace con los activos que se vayan
  /// añadiendo a su Portfolio. Null cuando el workspace NO mantiene
  /// assets (provider/advisor/broker/legal/insurer ofrecen al mercado
  /// pero no necesariamente operan assets propios).
  ///
  /// Este valor se persiste en `Portfolio.expectedRelationKind` y se
  /// usa como hint para crear el `AssetActorLinkEntity` correspondiente
  /// cuando VRC añade el primer asset.
  final AssetActorRole? expectedRelationKind;

  /// Modo de UI shell. Runtime-only (NUNCA partition key).
  final ShellMode shellMode;

  /// Warnings tipados emitidos durante el mapping. Lista vacía cuando
  /// todos los campos del intent eran válidos.
  ///
  /// Caso típico: el state demo declara `providerSpecialties.first =
  /// 'Lubricentro'` (formato inválido — debería ser snake_case ASCII).
  /// El mapper drop el ref a null pero emite un warning
  /// `malformedBusinessCategory` con el rawValue. El caller
  /// (`CompleteOnboardingUC`) lo emite vía
  /// [LegacyMembershipMigrationTelemetry.recordRolesWarning] o equivalente
  /// para detectar drift de datos legacy.
  ///
  /// El mapper NO emite telemetría directamente — sigue siendo función
  /// pura. Los warnings son data; el caller decide.
  final List<LegacyMigrationWarning> warnings;

  const IntentMappingResult({
    required this.capabilityProfiles,
    required this.expectedRelationKind,
    required this.shellMode,
    this.warnings = const [],
  });

  bool get hasWarnings => warnings.isNotEmpty;
  int get warningCount => warnings.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IntentMappingResult) return false;
    if (other.expectedRelationKind != expectedRelationKind) return false;
    if (other.shellMode != shellMode) return false;
    if (other.capabilityProfiles.length != capabilityProfiles.length) {
      return false;
    }
    for (var i = 0; i < capabilityProfiles.length; i++) {
      if (other.capabilityProfiles[i] != capabilityProfiles[i]) return false;
    }
    if (other.warnings.length != warnings.length) return false;
    for (var i = 0; i < warnings.length; i++) {
      if (other.warnings[i].kind != warnings[i].kind) return false;
      if (other.warnings[i].fieldPath != warnings[i].fieldPath) return false;
      if (other.warnings[i].rawValue != warnings[i].rawValue) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(capabilityProfiles),
        expectedRelationKind,
        shellMode,
        warnings.length,
      );

  @override
  String toString() => 'IntentMappingResult('
      'capabilityProfiles: ${capabilityProfiles.length} items, '
      'expectedRelationKind: ${expectedRelationKind?.wireName}, '
      'shellMode: ${shellMode.wireName}, '
      'warnings: ${warnings.length})';
}
