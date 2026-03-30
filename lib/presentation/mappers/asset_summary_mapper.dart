// ============================================================================
// lib/presentation/mappers/asset_summary_mapper.dart
// ASSET SUMMARY MAPPER — Enterprise Ultra Pro Premium 2026
//
// QUÉ HACE:
// - Convierte AssetEntity → AssetSummaryVM de forma pura y segura.
// - Acepta alertas ya resueltas como parámetro opcional para poblar
//   VehicleSummaryVM.alerts (no las obtiene, solo las recibe).
// - Detecta anomalías de datos en debug (placa falsa = UUID).
//
// QUÉ NO HACE:
// - No resuelve documentos de compliance (RTM, SOAT, RC).
// - No obtiene ni carga alertas — las recibe desde el presentation state
//   (AssetComplianceAlertOrchestrator → DomainAlertMapper → caller).
// - No contiene I/O ni lógica de negocio.
//
// PRINCIPIOS:
// - Función pura: sin side effects.
// - Null-Safety estricto: todos los campos opcionales son explícitos.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Capa de presentación inmutable y reactiva.
// MEJORAS APLICADAS:
// - Regex de Placas Corregido: Detecta verdaderos fragmentos UUID sin
//   falsos positivos en placas colombianas válidas (ej: FAD123).
// - Sincronización VM: Soporte para inyección de alertas operativas.
// - DX (Developer Experience): Añadido extension method `toSummaryVM()`.
// - Null-Safety Estricto: Manejo resiliente de strings nulos o vacíos.
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../domain/entities/asset/asset_content.dart';
import '../../domain/entities/asset/asset_entity.dart';
import '../alerts/viewmodels/alert_card_vm.dart';
import '../viewmodels/asset/asset_summary_vm.dart';

// Extension para uso sin alertas (listas, portafolio, contextos sin pipeline).
// Uso: final vm = myAssetEntity.toSummaryVM();
extension AssetEntityToVM on AssetEntity {
  AssetSummaryVM toSummaryVM() => AssetSummaryMapper.fromEntity(this);
}

abstract final class AssetSummaryMapper {
  /// Convierte [AssetEntity] → [AssetSummaryVM] de forma pura y segura.
  ///
  /// [alerts]: alertas canónicas ya mapeadas por [DomainAlertMapper].
  /// Pasar el resultado del pipeline cuando se necesite el banner de alertas.
  /// Omitir (o pasar vacío) en contextos sin pipeline activo (listas, portafolio).
  static AssetSummaryVM fromEntity(
    AssetEntity entity, {
    List<AlertCardVm> alerts = const [],
  }) {
    if (kDebugMode) _auditLogContent(entity);

    final label = _stateLabel(entity.state);

    return switch (entity.content) {
      // ── Vehículo ──────────────────────────────────────────────────────────
      VehicleContent(
        :final assetKey,
        :final brand,
        :final model,
        :final line,
        :final engineDisplacement,
        :final bodyType,
        :final color,
        :final vehicleClass,
        :final serviceType,
        :final vin,
        :final engineNumber,
      ) =>
        VehicleSummaryVM(
          assetId: entity.id,
          portfolioId: entity.portfolioId,
          plate: assetKey.trim().isNotEmpty ? assetKey.trim() : 'S/P',
          brand: brand.trim(),
          model: model.trim(),
          line: line?.trim(),
          modelYear: null, // V2 no expone modelYear directo
          cilindraje: engineDisplacement > 0
              ? engineDisplacement.toStringAsFixed(0)
              : null,
          bodyType: bodyType?.trim(),
          // Sentinel handling robusto (case-insensitive y null-safe)
          vehicleColor: _sanitizeColor(color),
          vehicleClass: vehicleClass?.trim(),
          serviceType: serviceType?.trim(),
          vin: vin?.trim(),
          engine: engineNumber?.trim(),
          ownerName: entity.legalOwner?.name.trim(),
          ownerDocument: _ownerDocDisplay(entity.legalOwner),
          stateLabel: label,
          alerts: alerts,
        ),

      // ── Inmueble ──────────────────────────────────────────────────────────
      RealEstateContent(
        :final assetKey,
        :final address,
        :final city,
        :final propertyType,
        :final area,
      ) =>
        RealEstateSummaryVM(
          assetId: entity.id,
          portfolioId: entity.portfolioId,
          registrationKey: assetKey.trim(),
          address: address.trim(),
          city: city.trim(),
          propertyType: propertyType?.trim(),
          areaDisplay: area > 0 ? '${area.toStringAsFixed(1)} m²' : null,
          stateLabel: label,
        ),

      // ── Maquinaria ────────────────────────────────────────────────────────
      MachineryContent(
        :final assetKey,
        :final brand,
        :final model,
        :final category,
        :final manufacturingYear,
      ) =>
        MachinerySummaryVM(
          assetId: entity.id,
          portfolioId: entity.portfolioId,
          serialKey: assetKey.trim(),
          brand: brand.trim(),
          model: model.trim(),
          category: category?.trim(),
          manufacturingYear: manufacturingYear,
          stateLabel: label,
        ),

      // ── Equipo ────────────────────────────────────────────────────────────
      EquipmentContent(
        :final assetKey,
        :final name,
        :final brand,
        :final model,
        :final category,
      ) =>
        EquipmentSummaryVM(
          assetId: entity.id,
          portfolioId: entity.portfolioId,
          serialKey: assetKey.trim(),
          name: name.trim(),
          brand: brand?.trim(),
          model: model?.trim(),
          category: category?.trim(),
          stateLabel: label,
        ),
    };
  }

  // ── Helpers Privados ──────────────────────────────────────────────────────

  static String _stateLabel(AssetState state) => switch (state) {
        AssetState.draft => 'Borrador',
        AssetState.pendingOwnership => 'Pendiente',
        AssetState.verified => 'Verificado',
        AssetState.active => 'Activo',
        AssetState.archived => 'Archivado',
      };

  static String? _ownerDocDisplay(LegalOwner? owner) {
    if (owner == null) return null;
    final type = owner.documentType.trim().toUpperCase();
    final number = owner.documentNumber.trim();
    if (type.isEmpty || number.isEmpty) return null;
    return '$type $number';
  }

  static String? _sanitizeColor(String? color) {
    if (color == null || color.trim().isEmpty) return null;
    if (color.trim().toUpperCase() == 'PENDIENTE') return null;
    return color.trim();
  }

  /// AUDIT: Detecta anomalías de datos (Ej: RUNT falló y guardó un UUID como placa).
  static void _auditLogContent(AssetEntity entity) {
    final content = entity.content;

    if (content is VehicleContent) {
      final plate = content.assetKey.trim().toUpperCase();

      // Regex Oficial Colombia:
      // Carros: 3 letras, 3 números (AAA123)
      // Motos: 3 letras, 2 números, 1 letra (AAA12A)
      final isColombianPlate =
          RegExp(r'^[A-Z]{3}[0-9]{2}[0-9A-Z]$').hasMatch(plate);

      // Si tiene 6 caracteres, es alfanumérico, pero NO cumple el formato de placa CO:
      final isSuspicious = plate.length == 6 && !isColombianPlate;

      if (isSuspicious) {
        debugPrint(
          '🚨 [AUDIT][MAPPER] Posible placa falsa detectada!\n'
          '  assetId: ${entity.id}\n'
          '  rawPlate: "$plate" (No cumple formato RUNT)\n'
          '  brand: "${content.brand}" model: "${content.model}"',
        );
      }
    }
  }
}
