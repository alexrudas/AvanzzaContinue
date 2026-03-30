import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_vehiculo_entity.freezed.dart';
part 'asset_vehiculo_entity.g.dart';

@freezed
abstract class AssetVehiculoEntity with _$AssetVehiculoEntity {
  const factory AssetVehiculoEntity({
    required String assetId,
    required String refCode, // 3 letters + 3 numbers
    required String placa,
    required String marca,
    required String modelo,
    required int anio,

    // ── Campos enriquecidos desde RUNT ────────────────────────────────────
    // Null para activos registrados antes de la Fase RUNT Grid (2026-03).
    // Se persisten durante el registro; leídos de regreso en _toEnrichedEntity().
    String? color,
    double? engineDisplacement,
    String? vin,
    String? engineNumber,
    String? chassisNumber,
    String? line,
    String? serviceType,
    String? vehicleClass,
    String? bodyType,
    String? fuelType,
    int? passengerCapacity,
    double? loadCapacityKg,
    double? grossWeightKg,
    int? axles,
    String? transitAuthority,
    String? initialRegistrationDate,
    String? propertyLiens,

    // ── Propietario registrado en RUNT ───────────────────────────────────────
    // Null para activos registrados antes de la Fase Propietario (2026-03).
    /// Tipo de documento del propietario (ej. 'CC', 'CE').
    String? ownerDocumentType,
    /// Número de documento del propietario.
    String? ownerDocument,

    /// JSON serializado de snapshots RTM, limitaciones y garantías.
    ///
    /// Formato: {'runt_rtm': [...], 'runt_limitations': [...],
    ///           'runt_warranties': [...]}
    /// Null si no hay datos RUNT disponibles en el momento del registro.
    String? runtMetaJson,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AssetVehiculoEntity;

  factory AssetVehiculoEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetVehiculoEntityFromJson(json);
}
