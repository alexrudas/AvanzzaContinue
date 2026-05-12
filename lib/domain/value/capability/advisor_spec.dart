// ============================================================================
// lib/domain/value/capability/advisor_spec.dart
// AdvisorSpec — spec de un CapabilityProfile con kind == advisor
// ============================================================================
// QUÉ HACE:
//   - Describe la oferta de un Workspace que actúa como asesor especializado.
//   - Su único campo discriminante es el mercado primario que asesora.
//   - Tipado fuerte (AssetRegistrationType, no string libre).
// ============================================================================

import '../../shared/enums/asset_type.dart';

class AdvisorSpec {
  /// Mercado primario que asesora el workspace.
  final AssetRegistrationType market;

  const AdvisorSpec({required this.market});

  AdvisorSpec copyWith({AssetRegistrationType? market}) =>
      AdvisorSpec(market: market ?? this.market);

  Map<String, dynamic> toJson() => {
        'market': market.wireName,
      };

  factory AdvisorSpec.fromJson(Map<String, dynamic> json) {
    final marketRaw = json['market'];
    if (marketRaw is! String) {
      throw ArgumentError(
        'AdvisorSpec.fromJson: market requerido (String wire name)',
      );
    }
    return AdvisorSpec(
      market: AssetRegistrationTypeWire.fromWire(marketRaw),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdvisorSpec && other.market == market);

  @override
  int get hashCode => market.hashCode;

  @override
  String toString() => 'AdvisorSpec(market: ${market.wireName})';
}
