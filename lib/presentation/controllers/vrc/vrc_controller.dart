// ============================================================================
// lib/presentation/controllers/vrc/vrc_controller.dart
// VRC CONTROLLER — Presentation Layer / GetX Controller
//
// QUÉ HACE:
// - Gestiona el estado reactivo de la consulta VRC Individual.
// - Expone viewState (resultado técnico) y señales operativas separadas.
// - Delega la decisión de bloqueo/degradación a VrcRules (puras).
// - Captura timeout de 120 s como VrcViewState.timeout (sin crash).
//
// QUÉ NO HACE:
// - No construye el Dio ni configura HTTP (responsabilidad de VrcBinding).
// - No persiste datos (VRC es read-only).
// - No toma decisiones de UI (colores, textos, widgets).
//
// SEPARACIÓN CRÍTICA:
// - viewState   → éxito/fallo TÉCNICO de la llamada HTTP.
// - canProceedAutomatically / shouldDisableContinue → aprobación OPERATIVA.
//   La UI NUNCA debe inferir "puede continuar" desde viewState == success.
//   Siempre usar canProceedAutomatically para habilitar el flujo siguiente.
//
// INVARIANTES:
// - canProceedAutomatically == true solo si: data != null, no bloqueo, no revisión.
// - shouldDisableContinue == !canProceedAutomatically.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/vrc/models/vrc_models.dart';
import '../../../data/vrc/vrc_rules.dart';
import '../../../data/vrc/vrc_service.dart';

export '../../../data/vrc/vrc_rules.dart' show VrcViewState;

/// Controller GetX para el módulo VRC Individual.
class VrcController extends GetxController {
  final VrcService _service;

  VrcController(this._service);

  // ── Estado reactivo ────────────────────────────────────────────────────────

  final _viewState = VrcViewState.idle.obs;
  VrcViewState get viewState => _viewState.value;

  final _result = Rx<VrcResponseModel?>(null);
  VrcResponseModel? get result => _result.value;

  final _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;

  // ── Señales operativas (INDEPENDIENTES del viewState) ─────────────────────

  /// true si la consulta terminó Y la decisión de negocio permite continuar
  /// sin intervención manual.
  ///
  /// La UI usa este getter para habilitar el botón "Continuar" / "Registrar activo".
  /// NUNCA derivar esta lógica de viewState == success.
  bool get canProceedAutomatically {
    final data = _result.value?.data;
    if (data == null) return false;
    return !VrcRules.shouldBlockRegistration(data) &&
        !VrcRules.shouldRequireManualReview(data);
  }

  /// true cuando el flujo de registro NO debe continuar automáticamente.
  ///
  /// Atajo de lectura: equivale a !canProceedAutomatically.
  bool get shouldDisableContinue => !canProceedAutomatically;

  // ── Consulta ───────────────────────────────────────────────────────────────

  /// Ejecuta la consulta VRC Individual.
  ///
  /// - [plate]: placa del vehículo.
  /// - [documentType]: tipo de documento (CC, NIT, etc.).
  /// - [documentNumber]: número de documento del propietario.
  /// - [forceRefresh]: si true, limpia el resultado anterior antes de consultar.
  Future<void> consultVehicle({
    required String plate,
    required String documentType,
    required String documentNumber,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) reset();

    _viewState.value = VrcViewState.loading;
    _errorMessage.value = null;

    try {
      final response = await _service.consultIndividual(
        plate: plate.trim().toUpperCase(),
        documentType: documentType.trim().toUpperCase(),
        documentNumber: documentNumber.trim(),
      );

      _result.value = response;
      _viewState.value = VrcRules.classifyViewState(response);
    } on VrcApiException catch (e) {
      _result.value = null;
      _errorMessage.value = e.message;

      // Timeout distinguido del error genérico para UX diferenciada
      if (e.errorSource == 'network' &&
          e.message.contains('Timeout')) {
        _viewState.value = VrcViewState.timeout;
      } else {
        _viewState.value = VrcViewState.failed;
      }
    } on DioException catch (e) {
      // DioException no capturado en el servicio (casos edge)
      _result.value = null;
      _errorMessage.value = 'Error de red: ${e.message ?? 'Sin detalle'}';
      _viewState.value = VrcViewState.failed;
    } catch (e) {
      _result.value = null;
      _errorMessage.value = 'Error inesperado: $e';
      _viewState.value = VrcViewState.failed;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Limpia el estado del controller para una nueva consulta.
  void reset() {
    _viewState.value = VrcViewState.idle;
    _result.value = null;
    _errorMessage.value = null;
  }
}
