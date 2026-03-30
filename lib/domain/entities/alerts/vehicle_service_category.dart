// ============================================================================
// lib/domain/entities/alerts/vehicle_service_category.dart
// VEHICLE SERVICE CATEGORY — Clasificación canónica del tipo de servicio
//
// QUÉ HACE:
// - Define VehicleServiceCategory: enum canónico que normaliza el tipo de
//   servicio del vehículo desde el string crudo del RUNT hacia un valor
//   estable de dominio.
// - Expone fromRaw() para normalización desde datos crudos del assembler.
// - Expone wireName y fromWire() para serialización estable si este enum
//   necesita persistirse o transportarse.
//
// QUÉ NO HACE:
// - No contiene lógica de negocio sobre obligatoriedad de pólizas.
// - No importa Flutter, GetX ni infraestructura.
// - No depende de otros enums del pipeline de alertas.
//
// PRINCIPIOS:
// - El snapshot contiene clasificación canónica, no strings crudos del RUNT.
//   fromRaw() es el único punto donde los strings crudos se normalizan.
// - Cualquier valor no reconocido -> unknown (falla segura).
// - Si este enum se persiste o transporta, wireName debe tratarse como
//   valor estable.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): V5 — Clasificación canónica de servicio vehicular.
// ============================================================================

/// Clasificación canónica del tipo de servicio de un vehículo.
///
/// Normalizada desde el string crudo del RUNT a través de [fromRaw].
/// Si se serializa, usar [wireName].
enum VehicleServiceCategory {
  /// Servicio público de transporte.
  /// Wire value: `public_transport`.
  publicTransport,

  /// Uso particular / privado.
  /// Wire value: `private_use`.
  privateUse,

  /// Valor para servicio nulo, desconocido o no reconocido.
  /// Wire value: `unknown`.
  unknown;

  // ---------------------------------------------------------------------------
  // NORMALIZACIÓN DESDE RUNT (solo para assembler)
  // ---------------------------------------------------------------------------

  /// Normaliza el string crudo del RUNT al enum canónico.
  ///
  /// Cubre las dos variantes conocidas del campo RUNT: con y sin tilde.
  /// Aplica trim() + toUpperCase() — defensivo ante espacios y variaciones
  /// de capitalización en datos fuente.
  /// Cualquier valor no reconocido -> [unknown].
  static VehicleServiceCategory fromRaw(String? raw) =>
      switch (raw?.trim().toUpperCase()) {
        'PÚBLICO' || 'PUBLICO' => VehicleServiceCategory.publicTransport,
        'PARTICULAR' => VehicleServiceCategory.privateUse,
        _ => VehicleServiceCategory.unknown,
      };

  // ---------------------------------------------------------------------------
  // WIRE MAP
  // ---------------------------------------------------------------------------

  static const Map<String, VehicleServiceCategory> _byWire = {
    'public_transport': VehicleServiceCategory.publicTransport,
    'private_use': VehicleServiceCategory.privateUse,
    'unknown': VehicleServiceCategory.unknown,
  };

  /// Construye el enum desde su wire value. Retorna [unknown] si no se reconoce.
  static VehicleServiceCategory fromWire(String? value) =>
      _byWire[value?.trim().toLowerCase()] ?? VehicleServiceCategory.unknown;

  /// Wire value estable de esta categoría.
  String get wireName => switch (this) {
        VehicleServiceCategory.publicTransport => 'public_transport',
        VehicleServiceCategory.privateUse => 'private_use',
        VehicleServiceCategory.unknown => 'unknown',
      };
}
