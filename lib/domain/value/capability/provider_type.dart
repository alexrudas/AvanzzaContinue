// ============================================================================
// lib/domain/value/capability/provider_type.dart
// ProviderType — catálogo cerrado del tipo de oferta de un proveedor
// ============================================================================
// QUÉ HACE:
//   - Distingue si un Workspace con CapabilityProfile.kind == provider ofrece
//     productos físicos (articulos) o trabajo/intervención (servicios).
//   - Wire-stable.
//
// QUÉ NO HACE:
//   - NO modela el catálogo de productos ni el catálogo de servicios.
//   - NO aplica a kinds distintos de provider; advisor/broker/legal/insurer
//     tienen sus propios specs.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum ProviderType {
  /// Proveedor de artículos / productos físicos.
  @JsonValue('articulos')
  articulos,

  /// Proveedor de servicios / mano de obra.
  @JsonValue('servicios')
  servicios,
}

extension ProviderTypeX on ProviderType {
  String get wireName {
    switch (this) {
      case ProviderType.articulos:
        return 'articulos';
      case ProviderType.servicios:
        return 'servicios';
    }
  }

  static ProviderType fromWire(String raw) {
    final parsed = tryFromWire(raw);
    if (parsed == null) {
      throw ArgumentError('ProviderType desconocido: $raw');
    }
    return parsed;
  }

  static ProviderType? tryFromWire(String raw) {
    switch (raw) {
      case 'articulos':
        return ProviderType.articulos;
      case 'servicios':
        return ProviderType.servicios;
      default:
        return null;
    }
  }

  static bool isValidWireName(String raw) => tryFromWire(raw) != null;

  static List<String> get allWireNames =>
      ProviderType.values.map((t) => t.wireName).toList(growable: false);
}
