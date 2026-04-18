// ============================================================================
// lib/domain/value/registration/vehicle_plate_item.dart
// VEHICLE PLATE ITEM — Valor de dominio para una placa en consulta multi-vehículo
//
// QUÉ HACE:
// - Define VehiclePlateItem: placa + estado de consulta + mensaje de error.
// - Define VehiclePlateStatus: enum de estados del ciclo de vida de una placa
//   en el flujo de registro multi-vehículo.
// - Value object immutable con copyWith() para actualizaciones sin mutación.
//
// QUÉ NO HACE:
// - No persiste en Isar ni en Firestore — vive solo en memoria del controller.
// - No maneja lógica de consulta VRC ni de registro de activo.
// - No importa nada de la capa de datos ni de presentación.
//
// PRINCIPIOS:
// - Value object puro: sin side effects, sin estado mutable.
// - Null-safe: errorMessage es null cuando no hay error.
// - id estable (UUID v4 generado por el caller): necesario para identificar
//   el chip en la lista de placas durante removePlate(id).
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Multi-plate registration feature — Phase 1.
// Phase 1 usa solo el estado 'draft'. Los estados consulting/success/partial/
// failed son la base para la consulta batch async (Phase 2).
// ACTUALIZADO (2026-04): +errorCode — fuente de verdad del fallo por placa.
//   Propaga el código tipado del backend (RUNT_OWNER_MISMATCH, etc.) para
//   mapeo canónico en UI y fail-fast sin depender del texto libre del error.
// ============================================================================

/// Estado del ciclo de vida de una [VehiclePlateItem] en el flujo multi-vehículo.
enum VehiclePlateStatus {
  /// Placa agregada por el usuario, pendiente de consulta.
  draft,

  /// Consulta VRC en progreso.
  consulting,

  /// Consulta completada con todos los datos disponibles.
  success,

  /// Consulta completada con datos parciales.
  partial,

  /// Consulta fallida.
  failed,
}

/// Valor de dominio que representa una placa vehicular en el flujo de
/// registro multi-vehículo.
///
/// Immutable. Usar [copyWith] para actualizar campos.
class VehiclePlateItem {
  /// Identificador estable único (UUID v4), generado por el caller al crear.
  ///
  /// No cambia durante el ciclo de vida del objeto.
  /// Necesario para identificar el chip en la lista y ejecutar removePlate().
  final String id;

  /// Placa en mayúsculas, solo caracteres alfanuméricos.
  final String plate;

  /// Estado actual de este vehículo en el flujo de consulta.
  final VehiclePlateStatus status;

  /// Código de error tipado del backend para el estado [VehiclePlateStatus.failed].
  ///
  /// Fuente de verdad para la clasificación del fallo y el mapeo a mensaje
  /// legible en la UI. Ejemplos: RUNT_OWNER_MISMATCH, RUNT_NOT_FOUND.
  /// Null cuando no hay error o no aplica.
  final String? errorCode;

  /// Descripción textual del error — apoyo al usuario cuando no haya
  /// mapeo canónico para [errorCode].
  ///
  /// Null en todos los estados sin error.
  final String? errorMessage;

  const VehiclePlateItem({
    required this.id,
    required this.plate,
    this.status = VehiclePlateStatus.draft,
    this.errorCode,
    this.errorMessage,
  });

  VehiclePlateItem copyWith({
    String? id,
    String? plate,
    VehiclePlateStatus? status,
    String? errorCode,
    String? errorMessage,
  }) {
    return VehiclePlateItem(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      status: status ?? this.status,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
