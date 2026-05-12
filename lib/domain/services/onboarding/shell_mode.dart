// ============================================================================
// lib/domain/services/onboarding/shell_mode.dart
// ShellMode — modo de UI shell que se renderiza para una membership/intent.
// ============================================================================
// QUÉ HACE:
//   - Distingue qué shell de UI debe montar el HomeShell (owner-shell,
//     provider-shell, etc.) según la capability/intent del workspace activo.
//   - Wire-stable: cada valor expone wireName en snake_case para logs y
//     telemetría runtime.
//
// QUÉ NO HACE:
//   - NO es boundary persistente. Está PROHIBIDO usar ShellMode como
//     valor de Firestore/Isar partition key (orgId/workspaceId son los
//     únicos boundaries).
//   - NO se persiste como filtro de query. Vive solo en
//     SessionContextController como Rx runtime.
//   - NO controla permisos. Para policy usar MembershipPolicy.
//
// REGLA BASE (Avanzza 2.0):
//   `orgId`/`workspaceId` ⇒ tenancy boundary, partition key.
//   `shellMode`            ⇒ UI mode, runtime-only, NUNCA filtro de datos.
//
// VALORES (wireName):
//   - asset_owner        : workspace que mantiene assets (owner / assetAdmin / renter)
//   - provider_articulos : workspace proveedor de productos
//   - provider_servicios : workspace proveedor de servicios
//   - advisor            : workspace asesor especializado
//   - broker             : workspace intermediario / corredor (incluye corredor de seguros)
//   - legal              : workspace legal (firma / abogado)
//   - insurer            : workspace aseguradora emisora de pólizas
//   - renter             : workspace que toma assets en arriendo (sub-shell de asset_owner)
// ============================================================================

enum ShellMode {
  /// Workspace que mantiene activos como propietario o administrador
  /// (incluye también owner / assetAdmin).
  assetOwner,

  /// Workspace que toma activos en arriendo (sub-shell distinto de
  /// assetOwner porque la UX es de consumo, no de gestión patrimonial).
  renter,

  /// Workspace proveedor de productos (artículos físicos).
  providerArticulos,

  /// Workspace proveedor de servicios (mano de obra, intervención).
  providerServicios,

  /// Workspace asesor especializado.
  advisor,

  /// Workspace intermediario / corredor (incluye corredor de seguros).
  broker,

  /// Workspace de servicios legales.
  legal,

  /// Workspace aseguradora emisora de pólizas (carrier o reasegurador).
  insurer,
}

extension ShellModeX on ShellMode {
  /// Identificador estable snake_case para logs / telemetría runtime.
  String get wireName {
    switch (this) {
      case ShellMode.assetOwner:
        return 'asset_owner';
      case ShellMode.renter:
        return 'renter';
      case ShellMode.providerArticulos:
        return 'provider_articulos';
      case ShellMode.providerServicios:
        return 'provider_servicios';
      case ShellMode.advisor:
        return 'advisor';
      case ShellMode.broker:
        return 'broker';
      case ShellMode.legal:
        return 'legal';
      case ShellMode.insurer:
        return 'insurer';
    }
  }

  /// Parsea wire name al enum. Throws si desconocido.
  static ShellMode fromWire(String raw) {
    final parsed = tryFromWire(raw);
    if (parsed == null) {
      throw ArgumentError('ShellMode desconocido: $raw');
    }
    return parsed;
  }

  /// Versión no-throw.
  static ShellMode? tryFromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'asset_owner':
        return ShellMode.assetOwner;
      case 'renter':
        return ShellMode.renter;
      case 'provider_articulos':
        return ShellMode.providerArticulos;
      case 'provider_servicios':
        return ShellMode.providerServicios;
      case 'advisor':
        return ShellMode.advisor;
      case 'broker':
        return ShellMode.broker;
      case 'legal':
        return ShellMode.legal;
      case 'insurer':
        return ShellMode.insurer;
      default:
        return null;
    }
  }

  static List<String> get allWireNames =>
      ShellMode.values.map((s) => s.wireName).toList(growable: false);
}
