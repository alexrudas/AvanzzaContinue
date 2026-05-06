// ============================================================================
// lib/domain/value/capability/broker_spec.dart
// BrokerSpec — spec de un CapabilityProfile con kind == broker
// ============================================================================
// QUÉ HACE:
//   - Describe a un Workspace que actúa como intermediario / corredor.
//   - Aplica a corredores inmobiliarios, brokers de vehículos, corredores de
//     seguros (NO aseguradoras emisoras — eso es InsurerSpec / kind=insurer).
//   - Tipado fuerte: market es AssetRegistrationType, no string libre.
//
// FRONTERA broker vs insurer (decidida v3.1, opción B):
//   Un corredor de seguros usa:
//     CapabilityProfile(kind: broker, brokerSpec: BrokerSpec(market: ...))
//   Una aseguradora emisora de pólizas usa:
//     CapabilityProfile(kind: insurer, insurerSpec: InsurerSpec(...))
// ============================================================================

import '../../shared/enums/asset_type.dart';

class BrokerSpec {
  /// Mercado en el que opera el corredor.
  final AssetRegistrationType market;

  const BrokerSpec({required this.market});

  BrokerSpec copyWith({AssetRegistrationType? market}) =>
      BrokerSpec(market: market ?? this.market);

  Map<String, dynamic> toJson() => {
        'market': market.wireName,
      };

  factory BrokerSpec.fromJson(Map<String, dynamic> json) {
    final marketRaw = json['market'];
    if (marketRaw is! String) {
      throw ArgumentError(
        'BrokerSpec.fromJson: market requerido (String wire name)',
      );
    }
    return BrokerSpec(
      market: AssetRegistrationTypeWire.fromWire(marketRaw),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrokerSpec && other.market == market);

  @override
  int get hashCode => market.hashCode;

  @override
  String toString() => 'BrokerSpec(market: ${market.wireName})';
}
