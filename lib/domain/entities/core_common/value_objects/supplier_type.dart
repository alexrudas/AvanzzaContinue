// ============================================================================
// lib/domain/entities/core_common/value_objects/supplier_type.dart
// SUPPLIER TYPE — Value object wire-stable para LocalContactEntity
// ============================================================================
// QUÉ HACE:
//   - Define las tres categorías operativas que puede tener un proveedor en
//     el workspace: solo productos, solo servicios, o mixto.
//   - Expone `wireName` y `fromWire(...)` para persistencia estable en red
//     y Firestore (los strings son el contrato, no los nombres Dart).
//
// QUÉ NO HACE:
//   - NO representa categorías verticales (repuestos, lubricantes, taller).
//     Ese eje es `categories: List<String>` en LocalContactEntity.
//   - NO impone una taxonomía universal: es etiqueta operativa del workspace
//     para habilitar filtros y flujos (ej. solicitud de cotización vs. OT).
//   - NO sustituye a AssetActorRole (esa es la dimensión actor↔activo).
//
// PRINCIPIOS:
//   - Wire-stable: los valores `products | services | mixed` se persisten
//     tal cual en Isar/Firestore y nunca mutan.
//   - El dominio acepta `null` = "sin clasificar" (legado + altas rápidas
//     sin completar el perfil). Completeness rule exige no-null para marcar
//     un proveedor como completo.
// ============================================================================

/// Clasificación comercial operativa de un proveedor en el workspace.
enum SupplierType {
  /// Solo venta de productos (repuestos, insumos, bienes tangibles).
  products('products'),

  /// Solo prestación de servicios (mantenimiento, consultoría, instalación).
  services('services'),

  /// Vende productos y además presta servicios (caso común de talleres).
  mixed('mixed');

  /// Valor persistido en Isar/Firestore. Contrato estable; no renombrar.
  final String wireName;

  const SupplierType(this.wireName);

  /// Reconstruye el enum desde el valor de red. Retorna `null` si el string
  /// está vacío o no coincide (no lanza excepción: el dominio tolera
  /// registros antiguos sin clasificar).
  static SupplierType? fromWire(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final t in SupplierType.values) {
      if (t.wireName == value) return t;
    }
    return null;
  }

  /// Texto humano en español para UI. Se mantiene aquí (no en widgets) para
  /// evitar drift entre vistas y porque la UI es monolingüe ES por canon de
  /// proyecto.
  String get humanLabel {
    switch (this) {
      case SupplierType.products:
        return 'Productos';
      case SupplierType.services:
        return 'Servicios';
      case SupplierType.mixed:
        return 'Productos y servicios';
    }
  }
}
