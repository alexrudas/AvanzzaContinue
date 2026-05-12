// lib/presentation/controllers/dev/runt_vehicle_diagnostic_controller.dart
// ============================================================================
// DEV-ONLY — Consulta DIRECTA a Integrations API / RUNT Vehículo.
// Bypassea IntegrationsRepositoryImpl (caché Isar). NO persiste.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/runt/models/runt_vehicle_models.dart';
import '../../../data/runt/runt_service.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_state_view.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_status_panel.dart';
import '_diagnostic_controller_base.dart';

class RuntVehicleDiagnosticController extends GetxController
    with DiagnosticControllerBase {
  /// Tipo de documento del propietario validado: "C", "E", "P".
  final documentType = 'C'.obs;

  /// Documento del propietario validado.
  final documentNumber = ''.obs;

  /// Placa única (sin batch).
  final plate = ''.obs;

  /// Datos parseados (cuando state == success).
  final data = Rxn<RuntVehicleData>();

  /// portalType fijado en GOV (oculto en form, decisión de gobernanza).
  static const _portalType = 'GOV';

  late final RuntService _service =
      RuntService(Get.find<Dio>(tag: 'integrations'));

  Future<void> consult() async {
    final number = documentNumber.value.trim();
    final plateValue = plate.value.trim().toUpperCase();

    if (number.isEmpty || plateValue.isEmpty) {
      failureMessage.value = 'Ingresa documento y placa.';
      state.value = DiagnosticState.failed;
      return;
    }

    beginLoading();
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _service.getVehicle(
        portalType: _portalType,
        plate: plateValue,
        ownerDocument: number,
        ownerDocumentType: documentType.value,
      );
      stopwatch.stop();

      data.value = response.data;

      report.value = DiagnosticReport(
        duration: stopwatch.elapsed,
        httpStatus: 200,
        requestId: response.meta?.requestId,
        source: response.source,
        rawJson: response.toJson(),
        fetchedAt: DateTime.now(),
      );

      state.value = DiagnosticState.success;
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
