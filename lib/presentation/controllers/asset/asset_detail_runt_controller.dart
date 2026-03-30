// ============================================================================
// lib/presentation/controllers/asset/asset_detail_runt_controller.dart
// ASSET DETAIL RUNT CONTROLLER — Estado reactivo granular del RUNT en detalle
//
// QUÉ HACE:
// - Mantiene el estado observable mínimo del RUNT para AssetDetailPage:
//   lastRuntQueryAt, isUpdating, isOnline.
// - Deriva freshnessState (noData / fresh / warning / stale) en el controller
//   para que la UI no contenga lógica de negocio.
// - Escucha ConnectivityService para reflejar conectividad en tiempo real.
// - Expone updateFromVehiculo() para que la página lo llame cuando el stream
//   de Isar emite un nuevo AssetVehiculoEntity.
//
// QUÉ NO HACE:
// - No accede directamente a Isar ni a Firestore.
// - No orquesta el flujo RUNT completo (eso es RuntQueryController).
// - No maneja la navegación al wizard de registro.
// - No toma decisiones de UX (eso es la página).
// - No ejecuta background polling autónomo (ver nota de arquitectura).
//
// NOTA DE ARQUITECTURA — Refresh directo (Fase futura):
// Para soportar "Actualizar sin navegar", se necesita:
//   1. AssetVehiculoEntity.ownerDocument y ownerDocumentType (schema change).
//   2. AssetRepository.refreshFromRuntBackground(assetId, plate, ...).
// Cuando existan, startRuntUpdate() los usará directamente sin navegar al wizard.
// El contrato observable de este controller no cambia.
//
// CICLO DE VIDA:
// AssetDetailPage.initState()  → Get.put(AssetDetailRuntController())
// AssetDetailPage.dispose()    → Get.delete<AssetDetailRuntController>()
// _loadVehiculoDetails() done  → controller.updateFromVehiculo(vehiculo)
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Separación de responsabilidades RUNT en AssetDetailPage.
// Elimina setState global para cambios de conectividad y freshness.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../widgets/asset_document_context_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FRESHNESS STATE — derivado en controller, consumido por UI
// ─────────────────────────────────────────────────────────────────────────────

/// Estado de frescura del dato RUNT.
///
/// Derivado desde [lastRuntQueryAt] en [AssetDetailRuntController].
/// La UI solo lee este enum — no calcula fechas.
enum RuntFreshnessState {
  /// No hay ninguna consulta RUNT registrada.
  noData,

  /// Datos actualizados hace menos de 7 días. Normal.
  fresh,

  /// Datos con 7–30 días de antigüedad. Atención recomendada.
  warning,

  /// Datos con más de 30 días. Actualización urgente.
  stale,
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────

class AssetDetailRuntController extends GetxController {
  // ──────────────────────────────────────────────────────────────────────────
  // Observables
  // ──────────────────────────────────────────────────────────────────────────

  /// Fecha de la última consulta RUNT (proxy: AssetVehiculoEntity.updatedAt).
  ///
  /// Null si el activo nunca tuvo datos RUNT.
  final lastRuntQueryAt = Rx<DateTime?>(null);

  /// Placa del activo — disponible para páginas hijas (SOAT, RC) sin fetch.
  ///
  /// Poblado en [updateFromVehiculo]. Vacío si el activo no tiene datos RUNT.
  String vehiclePrimaryLabel = '';

  /// Label secundario del activo ("MARCA MODELO - AÑO").
  ///
  /// Construido por [buildVehicleSecondaryLabel] desde campos ya en memoria.
  /// Null si marca y modelo están vacíos.
  String? vehicleSecondaryLabel;

  /// Snapshot del vehículo para el flujo de cotización SRCE.
  ///
  /// Disponible para [SegurosRcDetailPage] sin fetch adicional.
  /// Null si el activo no tiene datos RUNT o vehicleClass/serviceType vacíos.
  VehicleSnapshot? vehicleSnapshotForQuote;

  /// Verdadero mientras se está ejecutando una actualización RUNT.
  ///
  /// La UI deshabilita el botón y muestra un indicador de progreso local.
  final isUpdating = false.obs;

  /// Verdadero si el dispositivo tiene conectividad confirmada.
  ///
  /// Fuente: ConnectivityService (actualizado en tiempo real via stream).
  final isOnline = false.obs;

  // ──────────────────────────────────────────────────────────────────────────
  // Computed — derivado de lastRuntQueryAt
  // ──────────────────────────────────────────────────────────────────────────

  /// Estado de frescura derivado de [lastRuntQueryAt].
  ///
  /// Lee [lastRuntQueryAt.value] directamente — usar dentro de Obx para
  /// que el widget se reconstruya cuando cambia la fecha.
  RuntFreshnessState get freshnessState {
    final dt = lastRuntQueryAt.value;
    if (dt == null) return RuntFreshnessState.noData;

    final days = DateTime.now().difference(dt.toLocal()).inDays;
    if (days < 7) return RuntFreshnessState.fresh;
    if (days <= 30) return RuntFreshnessState.warning;
    return RuntFreshnessState.stale;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Estado interno
  // ──────────────────────────────────────────────────────────────────────────

  StreamSubscription<bool>? _connectivitySub;

  // ──────────────────────────────────────────────────────────────────────────
  // Ciclo de vida
  // ──────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    // Leer conectividad actual y suscribirse a cambios futuros.
    final connectivity = DIContainer().connectivityService;
    isOnline.value = connectivity.isOnline;

    _connectivitySub = connectivity.online$.listen((online) {
      isOnline.value = online;
    });

    if (kDebugMode) {
      debugPrint('[AssetDetailRuntCtrl][onInit] isOnline=${isOnline.value}');
    }
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    super.onClose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // API pública
  // ──────────────────────────────────────────────────────────────────────────

  /// Actualiza el estado reactivo desde el último [AssetVehiculoEntity] recibido
  /// del stream de Isar.
  ///
  /// Llamar:
  ///   - Al completar [_loadVehiculoDetails()] en AssetDetailPage.
  ///   - Cada vez que el stream de Isar emite un nuevo vehículo.
  ///
  /// [vehiculo] puede ser null (activo sin datos RUNT → noData).
  void updateFromVehiculo(AssetVehiculoEntity? vehiculo) {
    lastRuntQueryAt.value = vehiculo?.updatedAt;
    vehiclePrimaryLabel = vehiculo?.placa ?? '';
    vehicleSecondaryLabel = vehiculo != null
        ? buildVehicleSecondaryLabel(vehiculo.marca, vehiculo.modelo, vehiculo.anio)
        : null;
    vehicleSnapshotForQuote = vehiculo != null
        ? VehicleSnapshot(
            plate: vehiculo.placa,
            brand: vehiculo.marca,
            model: vehiculo.modelo,
            year: vehiculo.anio,
            vehicleClass: vehiculo.vehicleClass ?? '',
            service: vehiculo.serviceType ?? '',
          )
        : null;
  }

  /// Marca el inicio de una actualización RUNT iniciada por el usuario.
  ///
  /// La UI llama este método ANTES de iniciar la acción (navegar o lanzar
  /// el job background). El controller refleja el estado visualmente.
  ///
  /// Retorna false si no se puede actualizar ahora (sin conexión o ya en curso).
  bool beginUpdate() {
    if (isUpdating.value) return false;
    if (!isOnline.value) return false;

    isUpdating.value = true;
    return true;
  }

  /// Cancela el estado de actualización en curso.
  ///
  /// Llamar cuando la actualización falla o el usuario cancela el wizard.
  void cancelUpdate() {
    isUpdating.value = false;
  }

  /// Marca la actualización como completada.
  ///
  /// La fecha se actualizará automáticamente cuando el stream de Isar
  /// emita el vehículo actualizado (via [updateFromVehiculo]).
  void completeUpdate() {
    isUpdating.value = false;
  }
}
