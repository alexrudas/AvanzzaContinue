// ============================================================================
// lib/presentation/controllers/asset/asset_operational_status_controller.dart
// ASSET OPERATIONAL STATUS CONTROLLER — Estado operativo diario del activo
//
// QUÉ HACE:
// - Expone el estado operativo del activo para el día de hoy como observable:
//   OperationalDayStatus (unconfigured, enabled, blocked, limited).
// - Expone la razón textual del estado cuando aplica (pico y placa, descanso,
//   restricción de zona, etc.).
// - Actualmente usa mock estático (unconfigured) hasta que exista la fuente
//   de datos real (módulo de configuración operativa del activo).
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore (placeholder en esta fase).
// - No calcula restricciones de pico y placa ni descanso autónomamente.
// - No mezcla su estado con alertas de compliance (SOAT, RTM, seguros).
// - No navega ni emite rutas.
//
// PRINCIPIOS:
// - Dos observables, cero lógica: la UI solo reacciona a status y reason.
// - Lógica de cálculo futura irá en un UseCase, no en este controller.
// - Responsabilidad única: desacoplado de AssetDetailRuntController.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Placeholder para el bloque "Estado operativo HOY" en
//   AssetDetailPage. El contrato observable (status, reason) no cambia cuando
//   se conecte la fuente de datos real. Solo se reemplaza la inicialización.
// TODO: Conectar a fuente de datos real (configuración operativa del activo)
//   cuando el módulo esté disponible. Exponer updateStatus() desde el repo.
// ============================================================================

import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUM — Estado operativo del activo para hoy
// ─────────────────────────────────────────────────────────────────────────────

/// Estado operativo del activo para el día de hoy.
///
/// [unconfigured] — No existe configuración de estado operativo.
///   La UI muestra "Por configurar". Es el estado por defecto.
/// [enabled] — El activo puede operar hoy sin restricciones.
/// [blocked] — El activo NO puede operar hoy (pico y placa, descanso, etc.).
/// [limited] — El activo puede operar con restricciones parciales.
enum OperationalDayStatus { unconfigured, enabled, blocked, limited }

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────

/// Controller reactivo para el estado operativo diario del activo.
///
/// Ciclo de vida:
///   AssetDetailPage.initState() → Get.put(AssetOperationalStatusController())
///   AssetDetailPage.dispose()   → Get.delete<AssetOperationalStatusController>()
class AssetOperationalStatusController extends GetxController {
  // ──────────────────────────────────────────────────────────────────────────
  // Observables
  // ──────────────────────────────────────────────────────────────────────────

  /// Estado operativo del activo para hoy.
  ///
  /// Default: [OperationalDayStatus.unconfigured] hasta que exista
  /// configuración real. La UI muestra "Por configurar" en este estado.
  final status = OperationalDayStatus.unconfigured.obs;

  /// Razón textual del estado cuando aplica.
  ///
  /// Null cuando no hay razón adicional (p. ej. unconfigured o enabled sin causa).
  /// Ejemplos de valores posibles:
  ///   "Pico y placa hoy"
  ///   "Día de descanso"
  ///   "Restricción de zona"
  final reason = Rx<String?>(null);

  // ──────────────────────────────────────────────────────────────────────────
  // API pública
  // ──────────────────────────────────────────────────────────────────────────

  /// Actualiza el estado operativo y la razón desde una fuente externa.
  ///
  /// Llamar cuando el módulo de configuración operativa provea datos reales,
  /// p. ej. desde el repositorio de activos tras una carga de configuración.
  ///
  /// [newReason] es opcional — puede ser null si el estado no requiere
  /// explicación adicional (ej. enabled sin restricciones).
  void updateStatus(OperationalDayStatus newStatus, {String? newReason}) {
    status.value = newStatus;
    reason.value = newReason;
  }
}
