import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/runt/models/runt_person_models.dart';
import '../../../data/runt/models/runt_vehicle_models.dart';
import '../../../data/runt/runt_repository.dart';

/// Controlador GetX para consultas del RUNT.
///
/// Maneja el estado de las consultas de:
/// - Personas (conductores) por documento
/// - Vehículos por placa y documento del propietario
///
/// Estados principales:
/// - [isLoadingPerson]: indica si está consultando persona
/// - [isLoadingVehicle]: indica si está consultando vehículo
/// - [personData]: datos de la persona consultada
/// - [vehicleData]: datos del vehículo consultado
/// - [errorMessage]: mensaje de error para mostrar en UI
class RuntController extends GetxController {
  final RuntRepository _repository;

  /// Constructor con inyección de dependencias.
  ///
  /// [_repository]: Repositorio RUNT ya configurado
  RuntController(this._repository);

  // ==================== FORM STATE ====================

  /// Controlador de texto para el campo de documento.
  final documentController = TextEditingController();

  /// Tipo de documento seleccionado (C, E, P).
  final documentType = 'C'.obs;

  // ==================== ESTADOS OBSERVABLES ====================

  /// Indica si está cargando datos de persona.
  final _isLoadingPerson = false.obs;

  /// Indica si está cargando datos de vehículo.
  final _isLoadingVehicle = false.obs;

  /// Datos de la persona consultada (null si no hay consulta).
  final _personData = Rx<RuntPersonData?>(null);

  /// Datos del vehículo consultado (null si no hay consulta).
  final _vehicleData = Rx<RuntVehicleData?>(null);

  /// Mensaje de error actual (null si no hay error).
  final _errorMessage = Rx<String?>(null);

  // ==================== GETTERS PÚBLICOS ====================

  /// Indica si está cargando datos de persona.
  bool get isLoadingPerson => _isLoadingPerson.value;

  /// Indica si está cargando datos de vehículo.
  bool get isLoadingVehicle => _isLoadingVehicle.value;

  /// Datos de la persona consultada (null si no hay consulta).
  RuntPersonData? get personData => _personData.value;

  /// Datos del vehículo consultado (null si no hay consulta).
  RuntVehicleData? get vehicleData => _vehicleData.value;

  /// Mensaje de error actual (null si no hay error).
  String? get errorMessage => _errorMessage.value;

  // ==================== CICLO DE VIDA ====================

  @override
  void onClose() {
    // Liberar recursos del TextEditingController cuando el controlador se destruye
    documentController.dispose();
    super.onClose();
  }

  // ==================== MÉTODOS PÚBLICOS ====================

  /// Consulta información de una persona por documento.
  ///
  /// [document]: Número de documento (cédula, pasaporte, etc.)
  /// [documentType]: Tipo de documento ("C", "E", "P")
  ///
  /// Actualiza el estado [personData] con la respuesta exitosa,
  /// o [errorMessage] si hay algún error.
  ///
  /// Muestra un Snackbar al usuario en caso de error.
  Future<void> consultarPersona(String document, String documentType) async {
    try {
      // Iniciar estado de carga
      _isLoadingPerson.value = true;
      _errorMessage.value = null;

      // Consultar repositorio
      final data = await _repository.obtenerPersonaPorDocumento(
        document,
        documentType,
      );

      // Actualizar estado con datos
      _personData.value = data;
    } on RuntApiException catch (e) {
      print(e);
      // Traducir excepción a mensaje amigable
      final message = _translateRuntError(e);
      _errorMessage.value = message;
      _showError('Error RUNT', message);
    } catch (e) {
      print(e);

      // Error inesperado
      final message = 'Error inesperado: ${e.toString()}';
      _errorMessage.value = message;
      _showError('Error', message);
    } finally {
      // Finalizar estado de carga
      _isLoadingPerson.value = false;
    }
  }

  /// Consulta información de un vehículo.
  ///
  /// [portalType]: Tipo de portal ("GOV" o "COM")
  /// [plate]: Placa del vehículo
  /// [ownerDocument]: Documento del propietario
  /// [ownerDocumentType]: Tipo de documento del propietario
  ///
  /// Actualiza el estado [vehicleData] con la respuesta exitosa,
  /// o [errorMessage] si hay algún error.
  ///
  /// Muestra un Snackbar al usuario en caso de error.
  Future<void> consultarVehiculo({
    required String portalType,
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
  }) async {
    try {
      // Iniciar estado de carga
      _isLoadingVehicle.value = true;
      _errorMessage.value = null;

      // Consultar repositorio
      final data = await _repository.obtenerVehiculo(
        portalType: portalType,
        plate: plate,
        ownerDocument: ownerDocument,
        ownerDocumentType: ownerDocumentType,
      );

      // Actualizar estado con datos
      _vehicleData.value = data;
    } on RuntApiException catch (e) {
      print(e);
      // Traducir excepción a mensaje amigable
      final message = _translateRuntError(e);
      _errorMessage.value = message;
      _showError('Error RUNT', message);
    } catch (e) {
      print(e);

      // Error inesperado
      final message = 'Error inesperado: ${e.toString()}';
      _errorMessage.value = message;
      _showError('Error', message);
    } finally {
      // Finalizar estado de carga
      _isLoadingVehicle.value = false;
    }
  }

  /// Limpia el cache de RUNT.
  ///
  /// Fuerza que la próxima consulta vaya directo a la API.
  Future<void> limpiarCache() async {
    await _repository.limpiarTodoElCache();
    Get.snackbar(
      'Cache limpiado',
      'La próxima consulta será contra el servidor',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Reinicia el mensaje de error.
  void resetError() {
    _errorMessage.value = null;
  }

  /// Reinicia los datos de persona consultada.
  void resetPersonData() {
    _personData.value = null;
    _errorMessage.value = null;
  }

  /// Reinicia los datos de vehículo consultado.
  void resetVehicleData() {
    _vehicleData.value = null;
    _errorMessage.value = null;
  }

  /// Reinicia formulario y datos de persona.
  ///
  /// Útil para botón "Limpiar" en la UI.
  void resetPersonForm() {
    documentController.clear();
    documentType.value = 'C';
    _personData.value = null;
    _errorMessage.value = null;
  }

  // ==================== MÉTODOS PRIVADOS ====================

  /// Traduce una [RuntApiException] a un mensaje amigable para el usuario.
  ///
  /// Según la fuente del error (network, parsing, business_logic, server),
  /// retorna un mensaje apropiado en español.
  String _translateRuntError(RuntApiException e) {
    switch (e.errorSource) {
      case 'network':
        return 'Sin conexión a internet. Verifica tu conexión y vuelve a intentar.';
      case 'parsing':
        return 'Error al procesar los datos del RUNT. Intenta nuevamente en unos momentos.';
      case 'business_logic':
        return e.message; // Mensaje real del backend
      case 'server':
        return 'Error del servidor RUNT. Intenta nuevamente en unos momentos.';
      default:
        return 'Error al consultar RUNT:\n${e.message}';
    }
  }

  /// Muestra un Snackbar de error al usuario.
  ///
  /// [title]: Título del mensaje
  /// [message]: Descripción del error
  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
    );
  }
}
