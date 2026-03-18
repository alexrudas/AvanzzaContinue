// ============================================================================
// lib/domain/value/registration/asset_runt_snapshot.dart
// ASSET RUNT SNAPSHOT — Value Object de enriquecimiento RUNT para registro
//
// PROPÓSITO:
// Transportar TODOS los datos relevantes de una consulta RUNT completada
// desde presentation → controller → repository sin acoplar capas.
//
// PRINCIPIOS:
// - Plain Dart (sin frameworks)
// - Null-safe real (listas nunca null)
// - Sin lógica de persistencia
// - Sin validación de negocio (eso es del repo)
//
// NOTA:
// List<Map<String, dynamic>> es TRANSICIONAL para no frenar el flujo.
// SOAT/RC deben migrar a VO tipado en siguiente fase.
// ============================================================================

class AssetRuntSnapshot {
  // ──────────────────────────────────────────────────────────────────────────
  // ESPECIFICACIONES TÉCNICAS
  // ──────────────────────────────────────────────────────────────────────────

  final String? color;
  final double? engineDisplacement;
  final String? vin;
  final String? engineNumber;
  final String? chassisNumber;
  final String? line;
  final String? serviceType;
  final String? vehicleClass;
  final String? bodyType;
  final String? fuelType;
  final int? passengerCapacity;
  final double? loadCapacityKg;
  final double? grossWeightKg;
  final int? axles;
  final String? transitAuthority;
  final String? initialRegistrationDate;

  /// Ej: 'NO REGISTRA', 'PRENDA'
  final String? propertyLiens;

  // ──────────────────────────────────────────────────────────────────────────
  // SEGUROS (TRANSICIONAL)
  // ──────────────────────────────────────────────────────────────────────────

  final List<Map<String, dynamic>> soatRecords;
  final List<Map<String, dynamic>> rcRecords;

  // ──────────────────────────────────────────────────────────────────────────
  // ESTADO / HISTORIAL
  // ──────────────────────────────────────────────────────────────────────────

  final List<Map<String, dynamic>> rtmRecords;
  final List<Map<String, dynamic>> limitations;
  final List<Map<String, dynamic>> warranties;

  // ──────────────────────────────────────────────────────────────────────────
  // CONSTRUCTOR BLINDADO (ANTI-NULL)
  // ──────────────────────────────────────────────────────────────────────────

  const AssetRuntSnapshot({
    this.color,
    this.engineDisplacement,
    this.vin,
    this.engineNumber,
    this.chassisNumber,
    this.line,
    this.serviceType,
    this.vehicleClass,
    this.bodyType,
    this.fuelType,
    this.passengerCapacity,
    this.loadCapacityKg,
    this.grossWeightKg,
    this.axles,
    this.transitAuthority,
    this.initialRegistrationDate,
    this.propertyLiens,
    List<Map<String, dynamic>>? soatRecords,
    List<Map<String, dynamic>>? rcRecords,
    List<Map<String, dynamic>>? rtmRecords,
    List<Map<String, dynamic>>? limitations,
    List<Map<String, dynamic>>? warranties,
  })  : soatRecords = soatRecords ?? const [],
        rcRecords = rcRecords ?? const [],
        rtmRecords = rtmRecords ?? const [],
        limitations = limitations ?? const [],
        warranties = warranties ?? const [];

  /// Snapshot vacío seguro
  static const empty = AssetRuntSnapshot();

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS (CLAVE PARA UI / LÓGICA)
  // ──────────────────────────────────────────────────────────────────────────

  bool get hasTechnicalData =>
      _hasText(color) ||
      engineDisplacement != null ||
      _hasText(vin) ||
      _hasText(engineNumber) ||
      _hasText(chassisNumber) ||
      _hasText(line) ||
      _hasText(serviceType) ||
      _hasText(vehicleClass) ||
      _hasText(bodyType) ||
      _hasText(fuelType) ||
      passengerCapacity != null ||
      loadCapacityKg != null ||
      grossWeightKg != null ||
      axles != null ||
      _hasText(transitAuthority) ||
      _hasText(initialRegistrationDate);

  bool get hasInsuranceData => soatRecords.isNotEmpty || rcRecords.isNotEmpty;

  bool get hasRtmData => rtmRecords.isNotEmpty;

  bool get hasLegalData =>
      limitations.isNotEmpty ||
      warranties.isNotEmpty ||
      _hasText(propertyLiens);

  bool get hasAnyData =>
      hasTechnicalData || hasInsuranceData || hasRtmData || hasLegalData;

  // ──────────────────────────────────────────────────────────────────────────
  // COPY WITH (SEGURO)
  // ──────────────────────────────────────────────────────────────────────────

  AssetRuntSnapshot copyWith({
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
    List<Map<String, dynamic>>? soatRecords,
    List<Map<String, dynamic>>? rcRecords,
    List<Map<String, dynamic>>? rtmRecords,
    List<Map<String, dynamic>>? limitations,
    List<Map<String, dynamic>>? warranties,
  }) {
    return AssetRuntSnapshot(
      color: color ?? this.color,
      engineDisplacement: engineDisplacement ?? this.engineDisplacement,
      vin: vin ?? this.vin,
      engineNumber: engineNumber ?? this.engineNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      line: line ?? this.line,
      serviceType: serviceType ?? this.serviceType,
      vehicleClass: vehicleClass ?? this.vehicleClass,
      bodyType: bodyType ?? this.bodyType,
      fuelType: fuelType ?? this.fuelType,
      passengerCapacity: passengerCapacity ?? this.passengerCapacity,
      loadCapacityKg: loadCapacityKg ?? this.loadCapacityKg,
      grossWeightKg: grossWeightKg ?? this.grossWeightKg,
      axles: axles ?? this.axles,
      transitAuthority: transitAuthority ?? this.transitAuthority,
      initialRegistrationDate:
          initialRegistrationDate ?? this.initialRegistrationDate,
      propertyLiens: propertyLiens ?? this.propertyLiens,
      soatRecords: soatRecords ?? this.soatRecords,
      rcRecords: rcRecords ?? this.rcRecords,
      rtmRecords: rtmRecords ?? this.rtmRecords,
      limitations: limitations ?? this.limitations,
      warranties: warranties ?? this.warranties,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DEBUG
  // ──────────────────────────────────────────────────────────────────────────

  @override
  String toString() {
    return 'AssetRuntSnapshot('
        'tech: $hasTechnicalData, '
        'soat: ${soatRecords.length}, '
        'rc: ${rcRecords.length}, '
        'rtm: ${rtmRecords.length}, '
        'limitations: ${limitations.length}, '
        'warranties: ${warranties.length}, '
        'liens: $propertyLiens'
        ')';
  }

  // ──────────────────────────────────────────────────────────────────────────
  // INTERNAL
  // ──────────────────────────────────────────────────────────────────────────

  static bool _hasText(String? v) => v != null && v.trim().isNotEmpty;
}
