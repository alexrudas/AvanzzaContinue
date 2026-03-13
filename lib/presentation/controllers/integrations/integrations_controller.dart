// ============================================================================
// lib/presentation/controllers/integrations/integrations_controller.dart
//
// INTEGRATIONS CONTROLLER
//
// GetX Controller que orquesta las consultas RUNT Persona y SIMIT
// para la capa de presentación.
//
// Estados reactivos:
//   loading   → consulta en curso
//   success   → resultado disponible en [runtPerson] / [simitResult]
//   error     → mensaje en [errorMessage]
//
// El controller NO conoce Dio, Isar ni DTOs — solo trabaja con
// entidades de dominio a través de [IntegrationsRepository].
// ============================================================================

import 'package:get/get.dart';

import '../../../domain/entities/integrations/runt_person.dart';
import '../../../domain/entities/integrations/simit_result.dart';
import '../../../domain/repositories/integrations_repository.dart';

/// Estado de una consulta de integración.
enum IntegrationsQueryState { idle, loading, success, error }

/// Controller GetX para el módulo de integraciones (RUNT Persona + SIMIT).
///
/// Registrado en [IntegrationsBinding] mediante [Get.lazyPut].
/// Consumido por [IntegrationsTestPage] y cualquier otra página del módulo.
class IntegrationsController extends GetxController {
  final IntegrationsRepository _repository;

  IntegrationsController(this._repository);

  // ── Estado reactivo — RUNT Persona ────────────────────────────────────────

  /// Estado actual de la consulta RUNT Persona.
  final runtState = IntegrationsQueryState.idle.obs;

  /// Resultado de la última consulta RUNT Persona exitosa.
  final runtPerson = Rx<RuntPersonEntity?>(null);

  /// Mensaje de error de la última consulta RUNT Persona fallida.
  final runtError = RxnString();

  // ── Estado reactivo — SIMIT ───────────────────────────────────────────────

  /// Estado actual de la consulta SIMIT.
  final simitState = IntegrationsQueryState.idle.obs;

  /// Resultado de la última consulta SIMIT exitosa.
  final simitResult = Rx<SimitResultEntity?>(null);

  /// Mensaje de error de la última consulta SIMIT fallida.
  final simitError = RxnString();

  // ── Getters de conveniencia para la UI ────────────────────────────────────

  bool get isRuntLoading => runtState.value == IntegrationsQueryState.loading;
  bool get isRuntSuccess => runtState.value == IntegrationsQueryState.success;
  bool get isRuntError => runtState.value == IntegrationsQueryState.error;

  bool get isSimitLoading => simitState.value == IntegrationsQueryState.loading;
  bool get isSimitSuccess => simitState.value == IntegrationsQueryState.success;
  bool get isSimitError => simitState.value == IntegrationsQueryState.error;

  // ── Consultas ──────────────────────────────────────────────────────────────

  /// Consulta los datos de una persona en el RUNT.
  ///
  /// [document] Número de documento.
  /// [type] Tipo de documento (ej. "CC", "CE", "PAS").
  ///
  /// Actualiza [runtState], [runtPerson] y [runtError] de forma reactiva.
  Future<void> consultRuntPerson({
    required String document,
    required String type,
  }) async {
    final normalizedDoc = document.trim();
    final normalizedType = type.trim().toUpperCase();

    if (normalizedDoc.isEmpty || normalizedType.isEmpty) {
      runtError.value = 'Debes ingresar el documento y el tipo.';
      runtState.value = IntegrationsQueryState.error;
      return;
    }

    // Limpia estado anterior antes de iniciar la nueva consulta.
    runtPerson.value = null;
    runtError.value = null;
    runtState.value = IntegrationsQueryState.loading;

    try {
      final result = await _repository.consultRuntPerson(
        document: normalizedDoc,
        type: normalizedType,
      );

      runtPerson.value = result;
      runtState.value = IntegrationsQueryState.success;
    } catch (e) {
      runtError.value = _extractMessage(e);
      runtState.value = IntegrationsQueryState.error;
    }
  }

  /// Consulta las multas de una placa o documento en SIMIT.
  ///
  /// [query] Placa del vehículo o número de documento.
  ///
  /// Actualiza [simitState], [simitResult] y [simitError] de forma reactiva.
  Future<void> consultSimit({required String query}) async {
    final normalizedQuery = query.trim().toUpperCase();

    if (normalizedQuery.isEmpty) {
      simitError.value = 'Debes ingresar una placa o número de documento.';
      simitState.value = IntegrationsQueryState.error;
      return;
    }

    // Limpia estado anterior.
    simitResult.value = null;
    simitError.value = null;
    simitState.value = IntegrationsQueryState.loading;

    try {
      final result = await _repository.consultSimit(query: normalizedQuery);

      simitResult.value = result;
      simitState.value = IntegrationsQueryState.success;
    } catch (e) {
      simitError.value = _extractMessage(e);
      simitState.value = IntegrationsQueryState.error;
    }
  }

  /// Limpia el cache completo de integraciones en Isar.
  Future<void> clearCache() async {
    await _repository.clearCache();
    Get.snackbar(
      'Cache limpiado',
      'Las próximas consultas irán directo a la API.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ── Helper ─────────────────────────────────────────────────────────────────

  String _extractMessage(Object e) {
    final raw = e.toString();
    // Remueve el prefijo "Exception: " para mensajes más limpios en la UI.
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length);
    }
    return raw;
  }
}
