// lib/presentation/controllers/dev/simit_diagnostic_controller.dart
// ============================================================================
// DEV-ONLY — Consulta DIRECTA a Integrations API / SIMIT.
//
// El endpoint `/api/simit/multas/:license` acepta documento O placa por path
// (decisión backend). Reusamos `SimitService.getFinesByDocument()` para ambos
// modos vía un único controller con [SimitQueryMode].
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/simit/models/simit_models.dart';
import '../../../data/simit/simit_detail_prefetch_service.dart';
import '../../../data/simit/simit_service.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_state_view.dart';
import '../../pages/dev/integrations_diagnostics/widgets/diagnostic_status_panel.dart';
import '_diagnostic_controller_base.dart';

enum SimitQueryMode { person, vehicle }

class SimitDiagnosticController extends GetxController
    with DiagnosticControllerBase {
  final SimitQueryMode mode;

  /// Valor ingresado: documento (modo persona) o placa (modo vehículo).
  final query = ''.obs;

  /// Datos parseados.
  final data = Rxn<SimitData>();

  /// Bandera derivada para distinguir SUCCESS_EMPTY de SUCCESS_WITH_DATA.
  /// Se calcula tras parseo; si true ⇒ render estado SUCCESS_EMPTY.
  bool successEmpty = false;

  late final SimitService _service =
      SimitService(Get.find<Dio>(tag: 'integrations'));

  SimitDiagnosticController({required this.mode});

  String get inputLabel =>
      mode == SimitQueryMode.person ? 'Número de documento' : 'Placa';

  Future<void> consult() async {
    final value = query.value.trim();
    if (value.isEmpty) {
      failureMessage.value = mode == SimitQueryMode.person
          ? 'Ingresa un número de documento.'
          : 'Ingresa una placa.';
      state.value = DiagnosticState.failed;
      return;
    }

    final normalized =
        mode == SimitQueryMode.vehicle ? value.toUpperCase() : value;

    beginLoading();
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _service.getFinesByDocument(document: normalized);
      stopwatch.stop();

      data.value = response.data;

      // SUCCESS_EMPTY: ok=true y todos los contadores en 0 (incluye total=0).
      // Se distingue de SUCCESS_WITH_DATA para mostrar copy explícito.
      final summary = response.data.summary;
      successEmpty = summary.comparendos == 0 &&
          summary.multas == 0 &&
          response.data.total == 0;

      // ── Prefetch background de detalles (Opción A) ────────────────────────
      // Tras recibir la lista, encolamos el detalle de cada multa con
      // throttle 2 (max 2 scrapes simultáneos). Cuando el user toque una
      // tarjeta, normalmente ya estará en cache o "joineable" via inflight.
      // El controller del bottom sheet consulta `getInflight()` antes de
      // disparar su propio request lazy.
      final fines = response.data.fines;
      if (fines.isNotEmpty &&
          Get.isRegistered<SimitDetailPrefetchService>()) {
        final docForPrefetch =
            summary.document.trim().isNotEmpty ? summary.document : normalized;
        Get.find<SimitDetailPrefetchService>().prefetchAll(
          document: docForPrefetch,
          comparendoIds: fines.map((f) => f.id).where((id) => id.isNotEmpty),
        );
      }

      report.value = DiagnosticReport(
        duration: stopwatch.elapsed,
        httpStatus: 200,
        requestId: response.meta?.requestId,
        source: response.source,
        rawJson: response.toJson(),
        fetchedAt: DateTime.now(),
      );

      // SUCCESS_EMPTY → state.success (UI renderiza copy "sin comparendos");
      // jamás el state.empty (que dice "Sin información").
      state.value = DiagnosticState.success;
    } on DioException catch (e) {
      stopwatch.stop();
      report.value =
          reportFromDioException(e, duration: stopwatch.elapsed);
      failureMessage.value = report.value.errorMessage;
      state.value = DiagnosticState.failed;
    } on SimitApiException catch (e) {
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

  @override
  void onClose() {
    // Limpiar prefetch al salir de la pantalla — cancela tareas en cola
    // (las que ya están scrapeando en backend igual completan y popular
    // cache Redis, así que la próxima visita aprovecha el trabajo).
    if (Get.isRegistered<SimitDetailPrefetchService>()) {
      Get.find<SimitDetailPrefetchService>().clear();
    }
    super.onClose();
  }
}
