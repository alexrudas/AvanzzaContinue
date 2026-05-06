// ============================================================================
// lib/domain/entities/core_common/constants/role_labels.dart
// ROLE LABELS — Etiquetas canónicas para LocalContact.roleLabel
// ============================================================================
// QUÉ HACE:
//   - Centraliza los valores string conocidos del campo `roleLabel` de
//     LocalContactEntity. `roleLabel` es texto libre por canon (ver ADR
//     actor-canon — "Sin semántica vertical: solo anotación local"), pero
//     hay roles operativos frecuentes que merecen una constante única para
//     evitar dispersión de strings literales en la app.
//
// QUÉ NO HACE:
//   - No impone enum cerrado: el dominio sigue aceptando cualquier string.
//   - No crea tipos nuevos de actor ni rompe el canon: es convención, no
//     contrato.
//   - No mapea a `AssetActorRole` (ese enum es para vínculos actor↔activo,
//     dimensión ortogonal).
//
// PRINCIPIOS:
//   - Wire-stable: los strings están pensados para persistirse tal cual.
//   - Bajo costo de introducción: basta con que callers nuevos usen la
//     constante y que lecturas comparen case-insensitive cuando convenga.
// ============================================================================

/// Etiqueta canónica para contactos del workspace que actúan como proveedor
/// comercial (destinatario potencial de una solicitud de compra).
const String kRoleLabelVendor = 'proveedor';

/// Máximo de proveedores seleccionables por PurchaseRequest en el cliente.
/// Debe coincidir con `MAX_TARGETS_PER_REQUEST` del backend
/// (avanzza-core-api/src/modules/purchase-request/constants/purchase-request.constants.ts).
const int kMaxVendorsPerPurchaseRequest = 3;

/// Helper de comparación tolerante a mayúsculas/espacios para lectura
/// (los filtros UI no deben romperse si un caller antiguo guardó "Proveedor"
/// con mayúscula o con espacios accidentales).
bool isVendorRoleLabel(String? raw) {
  if (raw == null) return false;
  final v = raw.trim().toLowerCase();
  return v == kRoleLabelVendor;
}
