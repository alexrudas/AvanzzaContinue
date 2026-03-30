// ============================================================================
// lib/presentation/controllers/insurance/rc_quote_request_controller.dart
// RC QUOTE REQUEST CONTROLLER — Lógica transaccional para solicitud de SRCE.
//
// DECISIONES APLICADAS
// - Sesión inyectada explícitamente por constructor (sin Get.find() oculto).
// - Snapshot del vehículo tipado en una sola estructura (VehicleSnapshot).
// - Contrato de navegación validado explícitamente.
// - Separación entre:
//   1) creación de lead
//   2) navegación al estado
// - Fuente del request centralizada en constante.
// - Validaciones mínimas endurecidas para reducir falsos positivos.
// - Método de compatibilidad setVehicleData() mantenido para no romper la UI
//   actual si todavía no fue migrada a setVehicleSnapshot().
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../../domain/repositories/insurance_lead_repository.dart';
import '../../../routes/app_routes.dart';
import '../session_context_controller.dart';

class RcQuoteRequestController extends GetxController {
  // ───────────────────────────────────────────────────────────────────────────
  // Dependencias explícitas
  // ───────────────────────────────────────────────────────────────────────────

  final InsuranceLeadRepository _repo;
  final SessionContextController _session;

  RcQuoteRequestController(this._repo, this._session);

  // ───────────────────────────────────────────────────────────────────────────
  // Constantes internas
  // ───────────────────────────────────────────────────────────────────────────

  static const String _requestSource = 'flutter_app';

  // ───────────────────────────────────────────────────────────────────────────
  // Args de navegación
  // ───────────────────────────────────────────────────────────────────────────

  String assetId = '';
  String primaryLabel = 'Vehículo';
  String? secondaryLabel;

  /// Error estructural del contrato de ruta.
  /// Si existe, NO se debe intentar enviar la solicitud.
  String? _routeContractError;

  // ───────────────────────────────────────────────────────────────────────────
  // Snapshot tipado del vehículo
  // ───────────────────────────────────────────────────────────────────────────

  VehicleSnapshot? _vehicleSnapshot;

  // ───────────────────────────────────────────────────────────────────────────
  // Estado observable
  // ───────────────────────────────────────────────────────────────────────────

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  // ───────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadArgs();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Inicialización y carga de argumentos
  // ───────────────────────────────────────────────────────────────────────────

  void _loadArgs() {
    final args = Get.arguments;

    // RcQuoteRequestArgs tipado: la page resolverá y llamará configureResolvedData().
    // No marcamos error aquí — esperamos la configuración explícita.
    if (args is! Map) return;

    assetId = args['assetId']?.toString().trim() ?? '';
    primaryLabel = args['primaryLabel']?.toString().trim().isNotEmpty == true
        ? args['primaryLabel'].toString().trim()
        : 'Vehículo';
    secondaryLabel = args['secondaryLabel']?.toString().trim();

    if (assetId.isEmpty) {
      _routeContractError =
          'Falta assetId en la navegación hacia la solicitud SRCE.';
      errorMessage.value = _routeContractError;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Configuración desde contrato resuelto por la page
  // ───────────────────────────────────────────────────────────────────────────

  /// Configura el controller con datos ya validados por la page.
  ///
  /// Llamado desde [RcQuoteRequestPage._bootstrap()] cuando la page resuelve
  /// el contrato tipado ([RcQuoteRequestArgs]) o el legacy (Map).
  /// Limpia cualquier error de contrato previo.
  void configureResolvedData({
    required String assetId,
    required String primaryLabel,
    String? secondaryLabel,
    required VehicleSnapshot vehicleSnapshot,
  }) {
    _routeContractError = null;
    this.assetId = assetId.trim();
    this.primaryLabel =
        primaryLabel.trim().isNotEmpty ? primaryLabel.trim() : 'Vehículo';
    this.secondaryLabel = secondaryLabel?.trim();
    setVehicleSnapshot(vehicleSnapshot);
    errorMessage.value = null;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Inyección del snapshot del vehículo
  // ───────────────────────────────────────────────────────────────────────────

  /// Método preferido: inyecta el snapshot tipado completo.
  void setVehicleSnapshot(VehicleSnapshot snapshot) {
    _vehicleSnapshot = VehicleSnapshot(
      plate: snapshot.plate.trim().toUpperCase(),
      brand: snapshot.brand.trim(),
      model: snapshot.model.trim(),
      year: snapshot.year,
      vehicleClass: snapshot.vehicleClass.trim(),
      service: snapshot.service.trim(),
    );
  }

  /// Método de compatibilidad para no romper la pantalla actual si todavía
  /// le pasa campos sueltos al controller.
  void setVehicleData({
    required String plate,
    required String brand,
    required String model,
    required int year,
    required String vehicleClass,
    required String service,
  }) {
    setVehicleSnapshot(
      VehicleSnapshot(
        plate: plate,
        brand: brand,
        model: model,
        year: year,
        vehicleClass: vehicleClass,
        service: service,
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Caso de uso principal
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> submitRequest() async {
    // 1. Protección contra doble tap / reentrada.
    if (isLoading.value) return;

    // 2. Validación del contrato de navegación.
    if (_routeContractError != null) {
      _setError(_routeContractError!);
      return;
    }

    // 3. Validación del snapshot local.
    if (!_isSnapshotValid()) {
      _setError('Información del vehículo incompleta o inconsistente.');
      return;
    }

    // 4. Validación de sesión.
    final orgId = _session.user?.activeContext?.orgId.trim();
    final userId = _session.user?.uid.trim();

    if (!_isNotBlank(orgId) || !_isNotBlank(userId)) {
      _setError('Sesión no disponible o expirada.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    CreateInsuranceLeadResponse? response;

    // 5. Fase transaccional: creación del lead.
    try {
      response = await _repo.createLead(
        CreateInsuranceLeadRequest(
          orgId: orgId!,
          assetId: assetId,
          requesterUserId: userId!,
          insuranceType: InsuranceLeadType.rcExtracontractual.toWire,
          source: _requestSource,
          vehicleSnapshot: _vehicleSnapshot!,
        ),
      );

      _track(response, orgId);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[RcQuoteRequestController] createLead error: $e');
        debugPrint('$st');
      }

      _setError(_mapCreateLeadError(e));
      isLoading.value = false;
      return;
    }

    // 6. Fase de navegación: separada de la transacción.
    //    Si esto falla, NO debemos mentir diciendo que la solicitud no se creó.
    try {
      Get.offNamed(
        Routes.rcQuoteStatus,
        arguments: response.lead,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[RcQuoteRequestController] navigation error: $e');
        debugPrint('$st');
      }

      _setError(
        'La solicitud fue creada correctamente, pero no se pudo abrir su estado.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers de validación
  // ───────────────────────────────────────────────────────────────────────────

  bool _isSnapshotValid() {
    final snapshot = _vehicleSnapshot;
    if (snapshot == null) return false;

    final maxAllowedYear = DateTime.now().year + 1;

    // vehicleClass y service son campos RUNT-enriquecidos opcionales.
    // El backend decide si los requiere — no bloquear aquí activos pre-RUNT.
    return _isNotBlank(assetId) &&
        _isNotBlank(snapshot.plate) &&
        _isNotBlank(snapshot.brand) &&
        _isNotBlank(snapshot.model) &&
        snapshot.year >= 1900 &&
        snapshot.year <= maxAllowedYear;
  }

  bool _isNotBlank(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers de errores y tracking
  // ───────────────────────────────────────────────────────────────────────────

  void _setError(String msg) {
    errorMessage.value = msg;
  }

  String _mapCreateLeadError(Object error) {
    final raw = error.toString().toLowerCase();

    if (raw.contains('permission') || raw.contains('forbidden')) {
      return 'No tienes permisos para crear esta solicitud.';
    }

    if (raw.contains('session') ||
        raw.contains('auth') ||
        raw.contains('token')) {
      return 'Tu sesión expiró. Ingresa nuevamente.';
    }

    if (raw.contains('timeout') ||
        raw.contains('network') ||
        raw.contains('socket') ||
        raw.contains('connection')) {
      return 'No se pudo conectar con el servidor. Intenta nuevamente.';
    }

    if (raw.contains('duplicate') ||
        raw.contains('already exists') ||
        raw.contains('already pending')) {
      return 'Ya existe una solicitud similar en curso para este activo.';
    }

    return 'No se pudo procesar la solicitud en este momento.';
  }

  void _track(CreateInsuranceLeadResponse res, String orgId) {
    if (kDebugMode) {
      debugPrint(
        '[TRACK] rc_quote_requested | '
        'assetId: $assetId | '
        'orgId: $orgId | '
        'created: ${res.wasCreated}',
      );
    }
  }
}
