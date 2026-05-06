// ============================================================================
// lib/domain/value/capability/insurer_spec.dart
// InsurerSpec — spec de un CapabilityProfile con kind == insurer
// ============================================================================
// QUÉ HACE:
//   - Describe a un Workspace que actúa como aseguradora / emisor de pólizas
//     (carrier o reasegurador). NO aplica a corredores — eso es BrokerSpec.
//   - Lista los ramos de seguro que opera (insuranceLines, ≥ 1) usando un
//     catálogo cerrado (InsuranceLine).
//   - Tipado fuerte para market e insuranceLines; regulatorLicense es
//     identificador externo (FK a registro regulatorio, sin catálogo cerrado).
//   - Inmutable, comparable por valor, serializable.
//
// VALIDACIÓN (constructor):
//   - insuranceLines.isNotEmpty (≥ 1 ramo declarado, sin duplicados)
//   - isCarrier obligatorio (no nullable). true ⇒ emite póliza directamente;
//     false ⇒ no emite (caso reasegurador parcial / aseguradora en runoff).
//
// FRONTERA broker vs insurer (decidida v3.1, opción B):
//   - InsurerSpec aplica solo a emisores de póliza.
//   - Un corredor / asesor de seguros usa BrokerSpec, no InsurerSpec.
// ============================================================================

import '../../shared/enums/asset_type.dart';
import 'insurance_line.dart';
import 'refs/regulator_license_ref.dart';

class InsurerSpec {
  /// Ramos de seguro que opera la aseguradora. Catálogo cerrado.
  /// Debe contener al menos un valor; sin duplicados.
  final List<InsuranceLine> insuranceLines;

  /// Mercado primario del activo cubierto (vehículo, inmueble, ...). Null
  /// para aseguradoras transversales (vida, salud, empresarial sin activo
  /// asociado).
  final AssetRegistrationType? market;

  /// FK opcional al registro regulatorio del país aplicable. Es un value
  /// object tipado con validación sintáctica garantizada en construcción;
  /// la validación de vigencia ante el regulador real se hace vía
  /// RegulatorLicenseValidator en boundary, no aquí.
  final RegulatorLicenseRef? regulatorLicenseRef;

  /// True si la aseguradora emite póliza directamente. False para casos en
  /// runoff o cesión total a reaseguro.
  final bool isCarrier;

  InsurerSpec({
    required this.insuranceLines,
    required this.isCarrier,
    this.market,
    this.regulatorLicenseRef,
  })  : assert(
          insuranceLines.isNotEmpty,
          'InsurerSpec: insuranceLines requiere al menos un ramo',
        ),
        assert(
          insuranceLines.toSet().length == insuranceLines.length,
          'InsurerSpec: insuranceLines no debe tener ramos duplicados',
        );

  InsurerSpec copyWith({
    List<InsuranceLine>? insuranceLines,
    AssetRegistrationType? market,
    RegulatorLicenseRef? regulatorLicenseRef,
    bool? isCarrier,
  }) =>
      InsurerSpec(
        insuranceLines: insuranceLines ?? this.insuranceLines,
        market: market ?? this.market,
        regulatorLicenseRef: regulatorLicenseRef ?? this.regulatorLicenseRef,
        isCarrier: isCarrier ?? this.isCarrier,
      );

  Map<String, dynamic> toJson() => {
        'insuranceLines': insuranceLines.map((l) => l.wireName).toList(),
        'isCarrier': isCarrier,
        if (market != null) 'market': market!.wireName,
        if (regulatorLicenseRef != null)
          'regulatorLicense': regulatorLicenseRef!.toJson(),
      };

  factory InsurerSpec.fromJson(Map<String, dynamic> json) {
    final linesRaw = json['insuranceLines'];
    if (linesRaw is! List) {
      throw ArgumentError(
        'InsurerSpec.fromJson: insuranceLines requerida (List<String>)',
      );
    }
    final lines = <InsuranceLine>[];
    for (final raw in linesRaw) {
      if (raw is! String) {
        throw ArgumentError(
          'InsurerSpec.fromJson: cada elemento de insuranceLines debe ser String',
        );
      }
      lines.add(InsuranceLineX.fromWire(raw));
    }
    final isCarrierRaw = json['isCarrier'];
    if (isCarrierRaw is! bool) {
      throw ArgumentError(
        'InsurerSpec.fromJson: isCarrier requerido (bool)',
      );
    }
    final marketRaw = json['market'];
    final licenseRaw = json['regulatorLicense'];
    return InsurerSpec(
      insuranceLines: lines,
      isCarrier: isCarrierRaw,
      market: marketRaw is String
          ? AssetRegistrationTypeWire.fromWire(marketRaw)
          : null,
      regulatorLicenseRef: licenseRaw is String
          ? RegulatorLicenseRef.fromJson(licenseRaw)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InsurerSpec) return false;
    if (other.isCarrier != isCarrier) return false;
    if (other.market != market) return false;
    if (other.regulatorLicenseRef != regulatorLicenseRef) return false;
    if (other.insuranceLines.length != insuranceLines.length) return false;
    for (var i = 0; i < insuranceLines.length; i++) {
      if (other.insuranceLines[i] != insuranceLines[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(insuranceLines),
        market,
        regulatorLicenseRef,
        isCarrier,
      );

  @override
  String toString() =>
      'InsurerSpec(insuranceLines: ${insuranceLines.map((l) => l.wireName).toList()}, '
      'market: ${market?.wireName}, '
      'regulatorLicenseRef: $regulatorLicenseRef, '
      'isCarrier: $isCarrier)';
}
