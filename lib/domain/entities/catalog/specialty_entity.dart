// ============================================================================
// lib/domain/entities/catalog/specialty_entity.dart
// SPECIALTY ENTITY — Domain Entity (Catálogo Global)
//
// QUÉ HACE:
// - Modela una specialty del catálogo global (`/v1/catalog/specialties`).
// - Define `SpecialtyKind` (PRODUCT | SERVICE | BOTH) con wireName/fromWire
//   wire-stable, alineado al contrato Core API.
// - Expone los únicos campos requeridos por la UI: `id` (clave estable),
//   `name` (display en español, server-provided) y `kind`.
//
// QUÉ NO HACE:
// - NO expone `key`: por contrato, la UI nunca debe usar key — solo `id`.
// - NO infiere `kind` desde `key` ni desde el `name`.
// - NO ordena, deduplica ni filtra: el backend ya retorna la lista lista.
// - NO mapea `null` a `BOTH` con `??`. `null` ≠ `BOTH` por contrato.
// - NO contiene lógica de cache: el backend ya cachea 60s.
//
// PRINCIPIOS / INVARIANTES:
// - `id` es estable: no cambia entre despliegues. UI lo usa como llave de
//   selección (`Set<String>`).
// - `name` viene en español y NO se traduce en cliente.
// - Los errores se distinguen por `code` (ver remote_exceptions.dart),
//   no por `message`.
//
// ENTERPRISE NOTES:
// - Wire enums siguen el patrón establecido en el proyecto: `wireName`
//   estable + `fromWire` con throw explícito ante valores desconocidos
//   para evitar caer silenciosamente a un default.
// - CREADO (2026-04-25): Selector de specialties para proveedores.
// ============================================================================

/// Tipo (kind) de una specialty.
///
/// Wire values (case-sensitive en wire, normalizados a uppercase por backend):
/// - `PRODUCT`: la specialty SOLO aplica a productos.
/// - `SERVICE`: la specialty SOLO aplica a servicios.
/// - `BOTH`: la specialty aplica indistintamente a productos y servicios.
enum SpecialtyKind {
  product('PRODUCT'),
  service('SERVICE'),
  both('BOTH');

  const SpecialtyKind(this.wireName);

  /// Valor canónico en wire (alineado con `SpecialtyKind` de Prisma).
  final String wireName;

  /// Resuelve un `SpecialtyKind` a partir del valor wire.
  /// Lanza [ArgumentError] si el valor es desconocido — no retorna default.
  static SpecialtyKind fromWire(String value) {
    final upper = value.toUpperCase();
    for (final k in SpecialtyKind.values) {
      if (k.wireName == upper) return k;
    }
    throw ArgumentError.value(
      value,
      'value',
      'SpecialtyKind wire desconocido. Esperado: PRODUCT | SERVICE | BOTH.',
    );
  }
}

/// Specialty del catálogo global.
///
/// Inmutable por contrato (los campos son `final`). Igualdad estructural
/// por `id` para permitir uso directo en `Set`/`Map` y comparaciones de UI.
class Specialty {
  /// ID estable de la specialty. Clave primaria en Postgres y llave de
  /// selección en UI. Se mantiene mientras la specialty exista.
  final String id;

  /// Nombre en español, listo para mostrar. NO traducir.
  final String name;

  /// Tipo de la specialty (PRODUCT | SERVICE | BOTH).
  final SpecialtyKind kind;

  const Specialty({
    required this.id,
    required this.name,
    required this.kind,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Specialty && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Specialty(id=$id, name=$name, kind=${kind.wireName})';
}
