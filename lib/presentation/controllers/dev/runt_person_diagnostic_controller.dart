// lib/presentation/controllers/dev/runt_person_diagnostic_controller.dart
// ============================================================================
// DEV-ONLY — Consulta DIRECTA a Integrations API / RUNT Persona.
//
// Bypassea IntegrationsRepositoryImpl (que cachea a Isar) → consume
// RuntService instanciado sobre el Dio tag:'integrations' ya registrado.
// NO persiste resultados.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/runt/models/runt_person_models.dart';
import '../../../data/runt/runt_service.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_state_view.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_status_panel.dart';
import '_diagnostic_controller_base.dart';

class RuntPersonDiagnosticController extends GetxController
    with DiagnosticControllerBase {
  /// Tipo de documento RUNT: "C" (CC), "E" (CE), "P" (Pasaporte).
  final documentType = 'C'.obs;

  /// Número de documento ingresado por el usuario.
  final documentNumber = ''.obs;

  /// Datos parseados (cuando el state es success).
  final data = Rxn<RuntPersonData>();

  late final RuntService _service =
      RuntService(Get.find<Dio>(tag: 'integrations'));

  /// Ejecuta consulta individual contra RUNT Persona.
  /// Mide duración, captura raw JSON y publica reporte técnico.
  Future<void> consult() async {
    final number = documentNumber.value.trim();
    if (number.isEmpty) {
      failureMessage.value = 'Ingresa un número de documento.';
      state.value = DiagnosticState.failed;
      return;
    }

    beginLoading();
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _service.getPersonConsult(
        document: number,
        documentType: documentType.value,
      );
      stopwatch.stop();

      data.value = response.data;

      // Empty: persona sin licencias y sin estado conductor → render distinto.
      final isEmpty = response.data.licencias.isEmpty &&
          (response.data.driverStatus == null ||
              response.data.driverStatus!.isEmpty);

      report.value = DiagnosticReport(
        duration: stopwatch.elapsed,
        httpStatus: 200,
        requestId: response.meta?.requestId,
        source: response.source,
        rawJson: response.toJson(),
        fetchedAt: DateTime.now(),
      );

      state.value =
          isEmpty ? DiagnosticState.empty : DiagnosticState.success;
    } on DioException catch (e) {
      stopwatch.stop();
      report.value =
          reportFromDioException(e, duration: stopwatch.elapsed);
      failureMessage.value = report.value.errorMessage;
      state.value = DiagnosticState.failed;
    } on RuntApiException catch (e) {
      stopwatch.stop();
      report.value =
          reportFromApiException(e, duration: stopwatch.elapsed);
      failureMessage.value = e.message;
      state.value = DiagnosticState.failed;
    } catch (e) {
      stopwatch.stop();
      report.value =
          reportFromApiException(e, duration: stopwatch.elapsed);
      failureMessage.value = e.toString();
      state.value = DiagnosticState.failed;
    }
  }
}
