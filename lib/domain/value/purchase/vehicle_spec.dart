// ============================================================================
// lib/domain/value/purchase/vehicle_spec.dart
// VEHICLE SPEC — Especificación de vehículo derivada del parque real
//
// QUÉ HACE:
// - Representa una combinación canónica (make, model, year) usada como target
//   reusable de PurchaseRequest cuando el pedido es para inventario/stock.
// - Se deriva en memoria desde los vehículos reales del workspace; no es una
//   entidad maestra editable ni una colección persistida aparte.
//
// QUÉ NO HACE:
// - No resuelve compatibilidad ampliada de repuestos (TecDoc y similares).
// - No contiene ciudad, país, proveedor ni información analítica compuesta.
// - No persiste como fila propia en Isar/Firestore — lo que sí persiste es el
//   snapshot plano dentro de cada PurchaseRequest que la referencia.
//
// PRINCIPIOS:
// - ID estable derivado determinísticamente de (makeKey|modelKey|year).
// - Identidad separada de label visible: la UI se apoya en displayLabel, el
//   grouping se apoya en id.
// - Campos obligatorios fase 1: make, model, year. Todo lo demás es opcional.
// - Value object puro: sin Freezed ni codegen — inmutable + equals/hashCode.
// ============================================================================

class VehicleSpec {
  /// ID determinístico: `makeKey|modelKey|year`. Estable entre cargas
  /// sucesivas sobre el mismo parque vehicular.
  final String id;

  /// Marca normalizada para agrupación (lower, sin espacios redundantes).
  final String makeKey;
  final String modelKey;
  final int year;

  /// Labels "humanos" preservados para UI (Title Case cuando es posible).
  final String makeLabel;
  final String modelLabel;

  /// Cuántos vehículos reales del workspace contribuyeron a esta spec.
  final int linkedAssetsCount;

  /// Opcionales fase 1 — se pueblan solo si TODOS los vehículos del grupo
  /// coinciden en el mismo valor; si hay dispersión, se dejan null para no
  /// inventar datos.
  final String? version;
  final String? motorization;
  final int? engineDisplacementCc;
  final String? transmission;

  const VehicleSpec({
    required this.id,
    required this.makeKey,
    required this.modelKey,
    required this.year,
    required this.makeLabel,
    required this.modelLabel,
    this.linkedAssetsCount = 0,
    this.version,
    this.motorization,
    this.engineDisplacementCc,
    this.transmission,
  });

  /// Label humano listo para UI. Ej: "Hyundai Grand i10 2021".
  String get displayLabel => '$makeLabel $modelLabel $year';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is VehicleSpec && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
