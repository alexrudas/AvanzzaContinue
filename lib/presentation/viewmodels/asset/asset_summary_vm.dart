// ============================================================================
// lib/presentation/viewmodels/asset/asset_summary_vm.dart
// ASSET SUMMARY VIEW MODELS — Enterprise Ultra Pro Premium 2026
//
// QUÉ HACE:
// - Define AssetSummaryVM como sealed class con una variante por tipo de activo.
// - Implementa Equatable para comparación por valor (eficiencia en listas).
// - Soporta Mixins operativos (ej: OperativeAlerts) para extensibilidad.
// - Desacopla 100% la UI de las entidades de dominio puro (AssetEntity).
//
// QUÉ NO HACE:
// - No contiene lógica de negocio, mapeos a JSON ni mutaciones de estado.
// - No depende del framework visual de Flutter (solo Dart puro + Equatable).
//
// PRINCIPIOS:
// - Value Equality: Comparación por valores reales, no por referencia en memoria.
// - Exhaustive Pattern Matching: Dart 3 garantiza que la UI maneje todos los tipos.
// - Safe Fallbacks: Lógica robusta en getters (ej. displayTitle) contra nulos.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Capa de presentación inmutable y reactiva.
// ============================================================================

import 'package:equatable/equatable.dart';

import '../../../domain/entities/alerts/alert_severity.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';

/// Mixin para activos que pueden reportar alertas operativas de cumplimiento.
///
/// V1: solo lo implementa [VehicleSummaryVM].
/// Fase 6+: extender a MachinerySummaryVM, RealEstateSummaryVM según dominio.
mixin OperativeAlerts {
  /// Lista de alertas activas. Vacío significa "sin alertas" — nunca null.
  List<AlertCardVm> get alerts;

  /// True si al menos una alerta tiene severity == [AlertSeverity.critical].
  bool get hasCriticalAlerts =>
      alerts.any((a) => a.severity == AlertSeverity.critical);
}

/// Sealed class base para todos los ViewModels de resumen de activos.
///
/// Usar pattern matching exhaustivo en widgets y mappers.
sealed class AssetSummaryVM extends Equatable {
  const AssetSummaryVM();

  /// ID único del activo (UUID).
  String get assetId;

  /// ID del portafolio al que pertenece, si está vinculado.
  String? get portfolioId;

  /// Etiqueta legible del estado del activo para UI (ej: "Activo", "Borrador").
  String get stateLabel;

  /// Título compacto y formateado para listas y tarjetas (nombre visible).
  String get displayTitle;
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE (CORE ASSET)
// ─────────────────────────────────────────────────────────────────────────────

/// ViewModel de resumen para activos tipo Vehículo.
final class VehicleSummaryVM extends AssetSummaryVM with OperativeAlerts {
  @override
  final String assetId;

  @override
  final String? portfolioId;

  /// Placa normalizada del vehículo (ej: "HXP334").
  final String plate;

  /// Marca del vehículo (ej: "CHEVROLET").
  final String brand;

  /// Modelo del vehículo (ej: "SPARK", "COROLLA").
  final String model;

  final String? line;
  final String? modelYear;
  final String? cilindraje;
  final String? bodyType;
  final String? vehicleColor;
  final String? vehicleClass;
  final String? serviceType;
  final String? vin;
  final String? engine;

  /// Nombre del propietario legal o responsable operativo.
  final String? ownerName;

  /// Documento del propietario (CC, NIT).
  final String? ownerDocument;

  @override
  final String stateLabel;

  @override
  final List<AlertCardVm> alerts;

  const VehicleSummaryVM({
    required this.assetId,
    this.portfolioId,
    required this.plate,
    this.brand = '',
    this.model = '',
    this.line,
    this.modelYear,
    this.cilindraje,
    this.bodyType,
    this.vehicleColor,
    this.vehicleClass,
    this.serviceType,
    this.vin,
    this.engine,
    this.ownerName,
    this.ownerDocument,
    this.alerts = const [],
    required this.stateLabel,
  });

  @override
  String get displayTitle {
    final name = '$brand $model'.trim();
    final identity = plate.isNotEmpty ? ' ($plate)' : '';
    return name.isNotEmpty ? '$name$identity' : 'Vehículo Sin Identificar';
  }

  @override
  List<Object?> get props => [
        assetId,
        portfolioId,
        plate,
        brand,
        model,
        line,
        modelYear,
        cilindraje,
        bodyType,
        vehicleColor,
        vehicleClass,
        serviceType,
        vin,
        engine,
        ownerName,
        ownerDocument,
        stateLabel,
        alerts,
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
// REAL ESTATE
// ─────────────────────────────────────────────────────────────────────────────

/// ViewModel de resumen para activos tipo Inmueble.
final class RealEstateSummaryVM extends AssetSummaryVM {
  @override
  final String assetId;

  @override
  final String? portfolioId;

  final String registrationKey;
  final String address;
  final String city;
  final String? propertyType;
  final String? areaDisplay;

  @override
  final String stateLabel;

  const RealEstateSummaryVM({
    required this.assetId,
    this.portfolioId,
    required this.registrationKey,
    required this.address,
    required this.city,
    this.propertyType,
    this.areaDisplay,
    required this.stateLabel,
  });

  @override
  String get displayTitle =>
      [city, address].where((s) => s.isNotEmpty).join(' — ').trim();

  @override
  List<Object?> get props => [
        assetId,
        portfolioId,
        registrationKey,
        address,
        city,
        propertyType,
        areaDisplay,
        stateLabel,
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
// MACHINERY
// ─────────────────────────────────────────────────────────────────────────────

/// ViewModel de resumen para activos tipo Maquinaria.
final class MachinerySummaryVM extends AssetSummaryVM {
  @override
  final String assetId;

  @override
  final String? portfolioId;

  final String serialKey;
  final String brand;
  final String model;
  final String? category;
  final int? manufacturingYear;

  @override
  final String stateLabel;

  const MachinerySummaryVM({
    required this.assetId,
    this.portfolioId,
    required this.serialKey,
    required this.brand,
    required this.model,
    this.category,
    this.manufacturingYear,
    required this.stateLabel,
  });

  @override
  String get displayTitle {
    final name = '$brand $model'.trim();
    return name.isNotEmpty ? name : 'Maquinaria Sin Identificar';
  }

  @override
  List<Object?> get props => [
        assetId,
        portfolioId,
        serialKey,
        brand,
        model,
        category,
        manufacturingYear,
        stateLabel,
      ];
}

// ─────────────────────────────────────────────────────────────────────────────
// EQUIPMENT
// ─────────────────────────────────────────────────────────────────────────────

/// ViewModel de resumen para activos tipo Equipo.
final class EquipmentSummaryVM extends AssetSummaryVM {
  @override
  final String assetId;

  @override
  final String? portfolioId;

  final String serialKey;
  final String name;
  final String? brand;
  final String? model;
  final String? category;

  @override
  final String stateLabel;

  const EquipmentSummaryVM({
    required this.assetId,
    this.portfolioId,
    required this.serialKey,
    required this.name,
    this.brand,
    this.model,
    this.category,
    required this.stateLabel,
  });

  @override
  String get displayTitle => name.isNotEmpty ? name : 'Equipo ($serialKey)';

  @override
  List<Object?> get props => [
        assetId,
        portfolioId,
        serialKey,
        name,
        brand,
        model,
        category,
        stateLabel,
      ];
}
