// ============================================================================
// lib/data/vrc/vrc_service.dart
// VRC SERVICE — Data Layer / HTTP Service
//
// QUÉ HACE:
// - Ejecuta la llamada HTTP GET /v1/vrc/:plate/:documentType/:documentNumber.
//   (Individual VRC — flujo de 1 placa)
// - Ejecuta POST /v1/vrc-batches para crear una consulta multi-placa.
//   (Batch VRC — flujo de N placas; el Dio base usa /api pero batches usan /v1)
// - Ejecuta GET /v1/vrc-batches/:batchId para hacer polling del estado.
// - Deserializa respuestas en VrcResponseModel / VrcBatchCreateResponseModel /
//   VrcBatchStatusResponseModel.
// - Traduce DioException → VrcApiException con mensajes descriptivos.
//
// QUÉ NO HACE:
// - No contiene reglas de negocio ni lógica de decisión.
// - No persiste resultados (VRC es read-only, sin cache).
// - No configura el Dio ni sus interceptores (responsabilidad del VrcBinding).
//
// PRINCIPIOS:
// - El Dio recibido ya tiene baseUrl = 'http://178.156.227.90/api' y ApiKeyInterceptor.
// - Individual: timeout 120 s (el backend agrega fuentes lentas).
// - Batch create: timeout 30 s (el endpoint devuelve batchId inmediatamente).
// - Batch poll: timeout 15 s (sondeo ligero — el backend ya procesó).
// - La validación de ok == false se delega al controller.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/exceptions/api_exceptions.dart';
import 'models/vrc_batch_models.dart';
import 'models/vrc_models.dart';

/// Servicio HTTP para la consulta VRC Individual.
///
/// Recibe el [Dio] ya configurado con base URL e interceptores del módulo.
class VrcService {
  final Dio _dio;

  /// Timeout extendido por request — el servidor VRC puede tardar hasta ~120 s.
  static const _requestReceiveTimeout = Duration(seconds: 120);

  VrcService(this._dio);

  // ── VRC Individual ─────────────────────────────────────────────────────────

  /// Consulta el estado del vehículo y su propietario en la API VRC.
  ///
  /// Endpoint: GET /vrc/:plate/:documentType/:documentNumber
  ///
  /// - [plate]: placa del vehículo (ej. ABC123).
  /// - [documentType]: tipo de documento del propietario (ej. CC, NIT).
  /// - [documentNumber]: número de documento del propietario.
  ///
  /// Lanza [VrcApiException] en caso de error de red o parsing.
  Future<VrcResponseModel> consultIndividual({
    required String plate,
    required String documentType,
    required String documentNumber,
  }) async {
    final url = '/vrc/$plate/$documentType/$documentNumber';
    debugPrint('[VRC_SERVICE] URL → $url');

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        options: Options(
          // Timeout extendido solo para este endpoint — el agregador puede tardar.
          receiveTimeout: _requestReceiveTimeout,
        ),
      );

      final data = response.data;
      if (data == null) {
        throw VrcApiException.parsing('Respuesta vacía del servidor VRC.');
      }

      // LOG DIAGNÓSTICO — imprime el bloque vehicle y owner del JSON real.
      // REMOVER en producción una vez confirmadas las claves correctas.
      if (kDebugMode) {
        final rawData    = data['data'];
        final rawVehicle = rawData?['vehicle'];
        final rawOwner   = rawData?['owner'];
        debugPrint('[VRC_SERVICE] RAW vehicle block: $rawVehicle');
        debugPrint('[VRC_SERVICE] RAW owner block: $rawOwner');
        // Diagnóstico de bloques documentales — confirma que llegan del backend.
        final soatList = rawData?['soat'];
        final rcList   = rawData?['rc'];
        final rtmList  = rawData?['rtm'];
        final legal    = rawData?['legal'];
        debugPrint('[VRC_SERVICE] RAW soat count: ${soatList is List ? soatList.length : 'null/not-list'}');
        debugPrint('[VRC_SERVICE] RAW rc count:   ${rcList is List ? rcList.length : 'null/not-list'}');
        debugPrint('[VRC_SERVICE] RAW rtm count:  ${rtmList is List ? rtmList.length : 'null/not-list'}');
        debugPrint('[VRC_SERVICE] RAW legal: $legal');
      }

      return VrcResponseModel.fromJson(data);
    } on VrcApiException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioError(e, timeoutSeconds: _requestReceiveTimeout.inSeconds);
    } on FormatException catch (e) {
      throw VrcApiException.parsing(e.message);
    } catch (e) {
      throw VrcApiException(message: 'Error inesperado en VRC: $e');
    }
  }

  // ── VRC Batch ──────────────────────────────────────────────────────────────

  /// Timeout para crear el batch — el endpoint devuelve batchId inmediatamente.
  static const _batchCreateTimeout = Duration(seconds: 30);

  /// Timeout para sondear el estado — request ligero de status.
  static const _batchPollTimeout = Duration(seconds: 15);

  /// URL base para los endpoints v1 del batch VRC.
  ///
  /// Los batch endpoints usan el prefijo /v1/ mientras que los endpoints
  /// individuales usan /api/ (reflejado en [Dio.options.baseUrl]).
  /// Se deriva tomando solo el origin (scheme + host + port) del baseUrl
  /// y añadiendo /v1. Funciona correctamente con el servidor actual
  /// (http://178.156.227.90/api → http://178.156.227.90/v1).
  ///
  /// NOTA: si en el futuro el servidor introduce un path-prefix (proxy,
  /// subruta), este getter debe revisarse — no preserva paths intermedios.
  String get _batchBaseUrl {
    final origin = Uri.parse(_dio.options.baseUrl).origin;
    return '$origin/v1';
  }

  /// Crea un batch de consultas VRC para múltiples placas.
  ///
  /// Endpoint: POST /v1/vrc-batches
  ///
  /// El backend encola el batch y responde de inmediato con un [batchId].
  /// El procesamiento real ocurre de forma asíncrona — usar [pollBatch]
  /// para consultar el estado.
  ///
  /// Lanza [VrcApiException] en caso de error de red o parsing.
  Future<VrcBatchCreateResponseModel> createBatch({
    required String ownerDocumentType,
    required String ownerDocument,
    required List<String> plates,
    required String orgId,
    required String requestedBy,
  }) async {
    final url = '$_batchBaseUrl/vrc-batches';
    debugPrint('[VRC_SERVICE] Batch create → url=$url plates=${plates.join(",")}');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: {
          'ownerDocumentType': ownerDocumentType,
          'ownerDocument': ownerDocument,
          'plates': plates,
          'orgId': orgId,
          'requestedBy': requestedBy,
        },
        options: Options(receiveTimeout: _batchCreateTimeout),
      );

      final data = response.data;
      if (data == null) {
        throw VrcApiException.parsing('Respuesta vacía al crear batch VRC.');
      }

      debugPrint('[VRC_SERVICE] Batch created → batchId=${data['batchId']}');
      return VrcBatchCreateResponseModel.fromJson(data);
    } on VrcApiException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioError(e, timeoutSeconds: _batchCreateTimeout.inSeconds);
    } catch (e) {
      throw VrcApiException(message: 'Error inesperado al crear batch VRC: $e');
    }
  }

  /// Consulta el estado actual de un batch VRC.
  ///
  /// Endpoint: GET /v1/vrc-batches/:batchId
  ///
  /// Debe llamarse periódicamente (polling) hasta que
  /// [VrcBatchStatusResponseModel.isTerminal] sea true.
  ///
  /// Lanza [VrcApiException] en caso de error de red o parsing.
  Future<VrcBatchStatusResponseModel> pollBatch(String batchId) async {
    final url = '$_batchBaseUrl/vrc-batches/$batchId';

    try {
      // ── [BATCH_TIMING] PUNTO 2a — HTTP_RAW SEND ────────────────────────────
      if (kDebugMode) {
        debugPrint(
          '[BATCH_TIMING][HTTP_RAW] ts=${DateTime.now().millisecondsSinceEpoch} '
          'batchId=$batchId action=SEND',
        );
      }

      final response = await _dio.get<Map<String, dynamic>>(
        url,
        options: Options(receiveTimeout: _batchPollTimeout),
      );

      // ── [BATCH_TIMING] PUNTO 2b — HTTP_RAW RECV + items crudos ────────────
      if (kDebugMode) {
        final t = DateTime.now().millisecondsSinceEpoch;
        debugPrint(
          '[BATCH_TIMING][HTTP_RAW] ts=$t '
          'batchId=$batchId action=RECV '
          'httpStatus=${response.statusCode}',
        );
        final rawItems = response.data?['items'];
        if (rawItems is List) {
          for (final raw in rawItems) {
            if (raw is Map) {
              debugPrint(
                '[BATCH_TIMING][HTTP_ITEM] ts=$t '
                'plate=${raw["plate"]} '
                'status=${raw["status"]} '
                'errorCode=${raw["errorCode"] ?? "null"} '
                'retryable=${raw["retryable"] ?? "null"}',
              );
            }
          }
        }
      }

      final data = response.data;
      if (data == null) {
        throw VrcApiException.parsing('Respuesta vacía al sondear batch VRC.');
      }

      return VrcBatchStatusResponseModel.fromJson(data);
    } on VrcApiException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioError(e, timeoutSeconds: _batchPollTimeout.inSeconds);
    } catch (e) {
      throw VrcApiException(message: 'Error inesperado al sondear batch VRC: $e');
    }
  }

  // ── Helper ─────────────────────────────────────────────────────────────────

  /// Traduce [DioException] en [VrcApiException] con mensaje legible para el usuario.
  ///
  /// [timeoutSeconds] debe pasarse desde cada caller con el timeout real usado
  /// en esa llamada (120 s individual, 30 s batch create, 15 s batch poll),
  /// evitando que el mensaje al usuario reporte un tiempo incorrecto.
  ///
  /// IMPORTANTE: no expone el texto interno de Dio (que contiene detalles técnicos
  /// de la librería). Solo produce mensajes en español orientados al usuario.
  VrcApiException _mapDioError(
    DioException e, {
    int timeoutSeconds = 120,
  }) {
    final status = e.response?.statusCode;

    // LOG DIAGNÓSTICO — muestra URL, status y body real del backend.
    debugPrint('[VRC_SERVICE] ERROR status=$status type=${e.type}');
    debugPrint('[VRC_SERVICE] ERROR requestUrl=${e.requestOptions.uri}');
    debugPrint('[VRC_SERVICE] ERROR responseBody=${e.response?.data}');

    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return VrcApiException.network(
        'La consulta VRC tardó más de $timeoutSeconds segundos. '
        'El servidor puede estar procesando — intenta de nuevo.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return VrcApiException.network(
        'Sin conexión con el servidor VRC. Verifica tu red e intenta de nuevo.',
      );
    }

    if (status != null) {
      // Si el backend devolvió JSON con ok:false y error.message, usarlo.
      final body = e.response?.data;
      if (body is Map<String, dynamic> && body['ok'] == false) {
        final errorBlock = body['error'];
        if (errorBlock is Map<String, dynamic>) {
          final msg = errorBlock['message'];
          if (msg is String && msg.isNotEmpty) {
            return VrcApiException(
              message: msg,
              statusCode: status,
            );
          }
        }
      }
      return VrcApiException(
        message: _httpStatusMessage(status),
        statusCode: status,
      );
    }

    return VrcApiException.network(
      'No se pudo conectar con el servicio VRC. Intenta de nuevo.',
    );
  }

  /// Mensaje legible para el usuario según el código HTTP de respuesta.
  ///
  /// No expone el mensaje interno de Dio ni detalles de implementación HTTP.
  String _httpStatusMessage(int status) {
    if (status == 404) {
      return 'Placa o documento no encontrado en VRC.';
    }
    if (status == 400) {
      return 'Los datos ingresados no son válidos para VRC.';
    }
    if (status == 401 || status == 403) {
      return 'Sin autorización para consultar VRC. Contacta soporte.';
    }
    if (status >= 500) {
      return 'El servicio VRC no está disponible en este momento.';
    }
    return 'El servicio VRC respondió con un error (código $status).';
  }
}
