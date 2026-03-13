// ============================================================================
// lib/data/runt/runt_query_service.dart
//
// RUNT QUERY SERVICE — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Servicio HTTP para el sistema de consulta RUNT basado en jobs asíncronos.
//
// DIFERENCIA CON RuntService
//   RuntService
//     → consulta síncrona directa
//     → usado por pantallas standalone de consulta RUNT
//
//   RuntQueryService
//     → consulta asíncrona basada en jobs
//     → usado por el wizard de registro de activos
//
// ENDPOINTS ESPERADOS EN BACKEND
//   POST /runt/query
//     → crea job y devuelve jobId
//
//   GET /runt/query/:id/status
//     → devuelve estado actual + progreso por bloques + datos parciales/finales
//
// PRINCIPIOS
// - No contiene polling: eso le pertenece al controller/use case.
// - No contiene caché: eso pertenece al repositorio/draft.
// - No contiene lógica de UI.
// - Defensivo ante payloads inesperados del backend.
// - Diseñado para integrarse con un backend que puede evolucionar.
//
// NOTA DE DISEÑO
// Se permite `baseUrl` inyectado, con default centralizado en ApiEndpoints,
// para mantener consistencia y facilitar testeo/inyección.
// ============================================================================

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/api_endpoints.dart';
import '../../core/exceptions/api_exceptions.dart';
import 'models/runt_job_models.dart';

class RuntQueryService {
  final Dio _dio;
  final String _baseUrl;

  /// Servicio HTTP para consultas RUNT basadas en jobs.
  ///
  /// [baseUrl] permite override explícito para tests o entornos especiales.
  /// Si no se provee, usa [ApiEndpoints.runtBaseUrl].
  RuntQueryService(
    this._dio, {
    String? baseUrl,
  }) : _baseUrl = (baseUrl ?? ApiEndpoints.runtBaseUrl).trim();

  /// URL base efectiva usada por el servicio.
  String get baseUrl => _baseUrl;

  // ---------------------------------------------------------------------------
  // POST /runt/query — inicia un job de consulta
  // ---------------------------------------------------------------------------

  /// Crea un job de consulta RUNT en el backend.
  ///
  /// El backend debe devolver inmediatamente un [jobId] y continuar
  /// el scraping en background.
  ///
  /// [cancelToken] es opcional y permite cancelar la request inicial
  /// si la UI abandona la pantalla antes de recibir el jobId.
  Future<RuntQueryJobResponse> startQuery({
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
    String portalType = 'GOV',
    CancelToken? cancelToken,
  }) async {
    _validateStartQueryInput(
      plate: plate,
      ownerDocument: ownerDocument,
      ownerDocumentType: ownerDocumentType,
      portalType: portalType,
    );

    final url = '$_baseUrl/api/runt/query';

    try {
      final response = await _dio.post(
        url,
        data: {
          'plate': plate.trim().toUpperCase(),
          'ownerDocument': ownerDocument.trim(),
          'ownerDocumentType': ownerDocumentType.trim(),
          'portalType': portalType.trim().toUpperCase(),
        },
        cancelToken: cancelToken,
      );

      _ensureSuccessStatus(
        response.statusCode,
        context: 'startQuery',
        // 202 Accepted: el backend acepta el job y lo procesa en background.
        acceptedStatuses: const [200, 201, 202],
      );

      final json = _requireJsonMap(
        response.data,
        context: 'startQuery',
      );

      return RuntQueryJobResponse.fromJson(json);
    } on DioException catch (e) {
      throw _mapDioException(e, 'startQuery');
    } on RuntApiException {
      rethrow;
    } catch (e) {
      throw RuntApiException.parsing(
        'Error inesperado al iniciar consulta RUNT',
        originalError: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // GET /runt/query/{jobId}/status — polling de estado
  // ---------------------------------------------------------------------------

  /// Obtiene el estado actual de un job de consulta RUNT.
  ///
  /// Debe llamarse periódicamente desde el controller o use case
  /// hasta que el job termine en:
  ///
  /// - [RuntJobStatus.completed]
  /// - [RuntJobStatus.failed]
  ///
  /// [cancelToken] es opcional para permitir cancelar polling en curso.
  Future<RuntJobStatusResponse> getJobStatus(
    String jobId, {
    CancelToken? cancelToken,
  }) async {
    final normalizedJobId = jobId.trim();
    if (normalizedJobId.isEmpty) {
      throw RuntApiException.businessLogic(
        message: 'jobId vacío en getJobStatus',
      );
    }

    final url = '$_baseUrl/api/runt/query/$normalizedJobId/status';

    // [DIAG-E1] URL exacta que se va a llamar
    debugPrint('[DIAG][getJobStatus] >>> GET $url');

    try {
      final response = await _dio.get(
        url,
        cancelToken: cancelToken,
      );

      // [DIAG-E2] statusCode y body recibidos
      debugPrint('[DIAG][getJobStatus] <<< statusCode=${response.statusCode}');
      final rawBody = response.data.toString();
      debugPrint('[DIAG][getJobStatus] <<< body=${rawBody.length > 300 ? "${rawBody.substring(0, 300)}..." : rawBody}');

      _ensureSuccessStatus(
        response.statusCode,
        context: 'getJobStatus',
        acceptedStatuses: const [200],
      );

      final json = _requireJsonMap(
        response.data,
        context: 'getJobStatus',
      );

      return RuntJobStatusResponse.fromJson(json);
    } on DioException catch (e) {
      // [DIAG-E3] Error Dio en getJobStatus
      debugPrint('[DIAG][getJobStatus] DioException: type=${e.type} status=${e.response?.statusCode} msg=${e.message}');
      throw _mapDioException(e, 'getJobStatus');
    } on RuntApiException {
      rethrow;
    } catch (e) {
      // [DIAG-E4] Error inesperado en getJobStatus
      debugPrint('[DIAG][getJobStatus] UNEXPECTED ERROR: $e');
      throw RuntApiException.parsing(
        'Error inesperado al obtener estado del job RUNT',
        originalError: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Validaciones defensivas
  // ---------------------------------------------------------------------------

  void _validateStartQueryInput({
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
    required String portalType,
  }) {
    if (plate.trim().isEmpty) {
      throw RuntApiException.businessLogic(
        message: 'La placa es obligatoria para iniciar la consulta RUNT.',
      );
    }

    if (ownerDocument.trim().isEmpty) {
      throw RuntApiException.businessLogic(
        message: 'El documento del propietario es obligatorio.',
      );
    }

    if (ownerDocumentType.trim().isEmpty) {
      throw RuntApiException.businessLogic(
        message: 'El tipo de documento del propietario es obligatorio.',
      );
    }

    if (portalType.trim().isEmpty) {
      throw RuntApiException.businessLogic(
        message: 'portalType no puede estar vacío.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Parseo defensivo
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _requireJsonMap(
    dynamic data, {
    required String context,
  }) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }

    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map(
            (key, value) => MapEntry(key.toString(), value),
          );
        }
      } catch (e) {
        throw RuntApiException.parsing(
          'La respuesta RUNT no contiene un JSON objeto válido ($context).',
          originalError: e,
        );
      }
    }

    throw RuntApiException.parsing(
      'La respuesta RUNT no tiene el formato esperado ($context).',
    );
  }

  void _ensureSuccessStatus(
    int? statusCode, {
    required String context,
    required List<int> acceptedStatuses,
  }) {
    if (statusCode == null || !acceptedStatuses.contains(statusCode)) {
      throw RuntApiException.businessLogic(
        message: 'Error HTTP ${statusCode ?? 'desconocido'} en RUNT ($context)',
        statusCode: statusCode,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Mapeo de errores de red / backend
  // ---------------------------------------------------------------------------

  RuntApiException _mapDioException(DioException e, String context) {
    if (_isCancellation(e)) {
      return RuntApiException.network(
        'Solicitud RUNT cancelada ($context).',
      );
    }

    final response = e.response;

    if (response == null) {
      return RuntApiException.network(
        'Error de red en RUNT ($context): ${e.message}',
      );
    }

    final statusCode = response.statusCode;
    final body = _tryExtractJsonMap(response.data);

    final rawError = body?['error'];
    final errorObj = rawError is Map<String, dynamic>
        ? rawError
        : rawError is Map
            ? rawError.map((k, v) => MapEntry(k.toString(), v))
            : null;

    final source = (errorObj?['errorSource'] as String?) ??
        (body?['errorSource'] as String?) ??
        'server';

    final message = (errorObj?['message'] as String?) ??
        (body?['message'] as String?) ??
        (rawError is String ? rawError : null);

    if (source == 'business_logic') {
      return RuntApiException.businessLogic(
        message: message ?? 'Error de negocio RUNT ($context)',
        statusCode: statusCode,
      );
    }

    if (message != null && message.trim().isNotEmpty) {
      return RuntApiException.businessLogic(
        message: message.trim(),
        statusCode: statusCode,
      );
    }

    return RuntApiException(
      message: 'Error HTTP ${statusCode ?? 'desconocido'} en RUNT ($context)',
      statusCode: statusCode,
      errorSource: source,
    );
  }

  Map<String, dynamic>? _tryExtractJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;

    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }

    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  bool _isCancellation(DioException e) {
    return e.type == DioExceptionType.cancel;
  }
}
