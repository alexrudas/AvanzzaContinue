// ============================================================================
// lib/data/models/network/network_category.dart
// NETWORK CATEGORY — Enum wire-stable para Mi Red Operativa v1
// ============================================================================
// QUÉ HACE:
//   - Define el catálogo cerrado de categorías que clasifican a un actor de la
//     Red Operativa externa (NetworkActorSummaryDto.categories[] y
//     primaryCategory).
//   - Espejo 1:1 del catálogo Core API congelado (GET /v1/network).
//
// QUÉ NO HACE:
//   - No se usa en TeamMemberSummaryDto (equipo interno usa teamRoleKeys[]).
//   - No representa permisos ni roles operativos del workspace.
//
// PRINCIPIOS:
//   - Wire-stable: los strings son el contrato; no renombrar.
//   - fromWire devuelve `unclassified` ante valor desconocido (forward-compat).
//     Esto permite que el backend agregue valores nuevos sin romper clientes
//     viejos: el actor cae al grupo "Otros" hasta que la app se actualice.
// ============================================================================

/// Catálogo cerrado de categorías de la Red Operativa externa.
///
/// Wire format: string lowercase (ver `wireName`).
enum NetworkCategory {
  workshop('workshop'),
  provider('provider'),
  technician('technician'),
  owner('owner'),
  driver('driver'),
  operator('operator'),
  tenant('tenant'),
  legal('legal'),
  unclassified('unclassified');

  /// Valor persistido en la red. Contrato estable; no renombrar.
  final String wireName;

  const NetworkCategory(this.wireName);

  /// Reconstruye el enum desde el wire. Forward-compatible: cualquier valor
  /// desconocido cae a `unclassified` para no romper clientes viejos cuando
  /// el backend extiende el catálogo.
  static NetworkCategory fromWire(String value) {
    for (final c in NetworkCategory.values) {
      if (c.wireName == value) return c;
    }
    return NetworkCategory.unclassified;
  }
}
