import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/simit/models/simit_models.dart';
import '../../../data/simit/simit_repository.dart';

/// Controlador GetX para consultas de SIMIT (multas de tránsito).
///
/// Maneja el estado de las consultas de multas por documento.
///
/// Estados principales:
/// - [isLoading]: indica si está consultando multas
/// - [multasData]: datos de las multas consultadas
/// - [errorMessage]: mensaje de error para mostrar en UI
/// - [isPartialData]: indica si hay multas con detalle incompleto
class SimitController extends GetxController {
  final SimitRepository _repository;

  /// Constructor con inyección de dependencias.
  ///
  /// [_repository]: Repositorio SIMIT ya configurado
  SimitController(this._repository);

  // ==================== ESTADOS OBSERVABLES ====================

  /// Indica si está cargando datos de multas.
  final _isLoading = false.obs;

  /// Datos de las multas consultadas (null si no hay consulta).
  final _multasData = Rx<SimitData?>(null);

  /// Mensaje de error actual (null si no hay error).
  final _errorMessage = Rx<String?>(null);

  /// Indica si algunas multas tienen detalle incompleto.
  ///
  /// Esto NO es un error, solo una advertencia de que
  /// algunos detalles expandibles pueden no estar disponibles.
  final _isPartialData = false.obs;

  // ==================== GETTERS PÚBLICOS ====================

  /// Indica si está cargando datos de multas.
  bool get isLoading => _isLoading.value;

  /// Datos de las multas consultadas (null si no hay consulta).
  SimitData? get multasData => _multasData.value;

  /// Mensaje de error actual (null si no hay error).
  String? get errorMessage => _errorMessage.value;

  /// Indica si algunas multas tienen detalle incompleto.
  bool get isPartialData => _isPartialData.value;

  // ==================== MÉTODOS PÚBLICOS ====================

  /// Consulta multas de tránsito por documento.
  ///
  /// [document]: Número de documento (cédula)
  ///
  /// Actualiza el estado [multasData] con la respuesta exitosa,
  /// o [errorMessage] si hay algún error.
  ///
  /// También verifica si hay datos parciales (multas sin detalle completo)
  /// y actualiza [isPartialData] en consecuencia.
  ///
  /// Muestra un Snackbar al usuario en caso de error.
  Future<void> consultarMultas(String document) async {
    try {
      // Iniciar estado de carga
      _isLoading.value = true;
      _errorMessage.value = null;
      _isPartialData.value = false;

      // Consultar repositorio
      final data = await _repository.obtenerMultasPorDocumento(document);

      // Actualizar estado con datos
      _multasData.value = data;

      // Verificar si hay datos parciales
      _checkPartialData(data);
    } on SimitApiException catch (e) {
      print(e);
      // Traducir excepción a mensaje amigable
      final message = _translateSimitError(e);
      _errorMessage.value = message;
      _showError('Error SIMIT', message);
    } catch (e) {
      // Error inesperado
      final message = 'Error inesperado: ${e.toString()}';
      _errorMessage.value = message;
      _showError('Error', message);
    } finally {
      // Finalizar estado de carga
      _isLoading.value = false;
    }
  }

  /// Limpia el cache de SIMIT.
  ///
  /// Fuerza que la próxima consulta vaya directo a la API.
  Future<void> limpiarCache() async {
    await _repository.limpiarCache();
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

  /// Reinicia todos los datos de multas.
  void resetData() {
    _multasData.value = null;
    _errorMessage.value = null;
    _isPartialData.value = false;
  }

  // ==================== MÉTODOS PRIVADOS ====================

  /// Verifica si hay multas con detalle incompleto.
  ///
  /// Algunas multas pueden no tener el campo [detalle] completo.
  /// Esto NO es un error, pero es útil informar al usuario.
  void _checkPartialData(SimitData data) {
    if (data.fines.any((fine) => fine.detalle == null)) {
      _isPartialData.value = true;
    }
  }

  /// Traduce una [SimitApiException] a un mensaje amigable para el usuario.
  ///
  /// Según la fuente del error (network, parsing, business_logic),
  /// retorna un mensaje apropiado en español.
  String _translateSimitError(SimitApiException e) {
    switch (e.errorSource) {
      case 'network':
        return 'Sin conexión a internet. Verifica tu conexión y vuelve a intentar.';
      case 'parsing':
        return 'Error al procesar los datos de SIMIT. Intenta nuevamente en unos momentos.';
      case 'business_logic':
        return e.message;
      default:
        return 'Error al consultar SIMIT: ${e.message}';
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
