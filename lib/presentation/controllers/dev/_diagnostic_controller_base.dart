// lib/presentation/controllers/dev/_diagnostic_controller_base.dart
// ============================================================================
// DEV-ONLY — Mixin compartido para los 4 controllers de diagnóstico
// (RUNT Persona/Vehículo, SIMIT Persona/Vehículo).
//
// QUÉ HACE:
// - Expone state Rx (idle/loading/success/empty/failed) + DiagnosticReport.
// - Centraliza el wrap de cronómetro + parseo de DioException → reporte.
//
// QUÉ NO HACE:
// - No persiste resultados en Isar/Firestore.
// - No usa IntegrationsRepository (que sí cachea).
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_state_view.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_status_panel.dart';

mixin DiagnosticControllerBase on GetxController {
  /// Estado de pantalla.
  final state = DiagnosticState.idle.obs;

  /// Mensaje de error legible (presentación), separado del campo técnico
  /// expuesto por [report].
  final failureMessage = RxnString();

  /// Reporte técnico (duración, HTTP, requestId, raw JSON).
  final report = const DiagnosticReport().obs;

  /// Marca como cargando, limpia reporte y mensaje previo.
  void beginLoading() {
    state.value = DiagnosticState.loading;
    failureMessage.value = null;
    report.value = const DiagnosticReport();
  }

  /// Convierte un [DioException] en un [DiagnosticReport] con datos técnicos.
  DiagnosticReport reportFromDioException(
    DioException e, {
    required Duration duration,
  }) {
    final res = e.response;
    Map<String, dynamic>? raw;
    if (res?.data is Map<String, dynamic>) {
      raw = res!.data as Map<String, dynamic>;
    }

    final errorObj = raw?['error'] as Map<String, dynamic>?;
    final errorCode = (errorObj?['errorCode'] ?? errorObj?['errorSource']) as String?;
    final message =
        (errorObj?['message'] ?? raw?['message'] ?? e.message) as String?;

    return DiagnosticReport(
      duration: duration,
      httpStatus: res?.statusCode,
      requestId: errorObj?['requestId'] as String?,
      errorCode: errorCode ?? 'NETWORK_ERROR',
      errorMessage: message,
      rawJson: raw,
      fetchedAt: DateTime.now(),
    );
  }

  /// Convierte una excepción de dominio (RuntApiException/SimitApiException)
  /// en un reporte técnico parcial.
  DiagnosticReport reportFromApiException(
    Object e, {
    required Duration duration,
    Map<String, dynamic>? rawJson,
  }) {
    String code = 'UNKNOWN';
    String? msg;
    int? status;
    if (e is RuntApiException) {
      code = e.errorSource ?? 'runt_error';
      msg = e.message;
      status = e.statusCode;
    } else if (e is SimitApiException) {
      code = e.errorSource ?? 'simit_error';
      msg = e.message;
      status = e.statusCode;
    } else {
      msg = e.toString();
    }

    return DiagnosticReport(
      duration: duration,
      httpStatus: status,
      errorCode: code,
      errorMessage: msg,
      rawJson: rawJson,
      fetchedAt: DateTime.now(),
    );
  }
}
