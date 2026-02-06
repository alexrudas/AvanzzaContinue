// ===================== lib/data/runt/runt_service.dart =====================

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/exceptions/api_exceptions.dart';
import 'models/runt_person_models.dart';
import 'models/runt_vehicle_models.dart';

/// Servicio HTTP para consumir la API del RUNT.
///
/// Proporciona métodos para consultar:
/// - Información de personas (conductores)
/// - Información de vehículos
///
/// Este servicio NO maneja cache, solo realiza peticiones HTTP.
/// El cache debe implementarse en la capa de repositorio.
class RuntService {
  final Dio _dio;
  final String baseUrl;

  /// Constructor que recibe una instancia de Dio ya configurada.
  ///
  /// [_dio]: Cliente HTTP Dio con configuración de timeouts, interceptors, etc.
  /// [baseUrl]: URL base de la API (ej: "https://api.example.com")
  RuntService(this._dio, {required this.baseUrl}) {
    print("[RuntService][baseUrl] $baseUrl");
  }

  /// Consulta información de una persona en el RUNT por documento.
  Future<RuntPersonResponse> getPersonConsult({
    required String document,
    required String documentType,
  }) async {
    try {
      final url = '$baseUrl/runt/person/consult/$document/$documentType';

      // 🔍 LOG ANTES DE ENVIAR REQUEST
      print('[RUNT][HTTP][REQUEST] GET $url');

      // Realizar petición HTTP
      final response = await _dio.get(url);

      if (response.statusCode != 200) {
        throw RuntApiException.businessLogic(
          message:
              'Error en consulta RUNT Persona: HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = response.data as Map<String, dynamic>;
      final parsedResponse = RuntPersonResponse.fromJson(json);

      if (!parsedResponse.ok) {
        throw RuntApiException.businessLogic(
          message: 'La API del RUNT retornó ok=false para documento $document',
          statusCode: response.statusCode,
          requestId: parsedResponse.meta?.requestId,
        );
      }

      return parsedResponse;
    } on DioException catch (e) {
      print(e);
      throw _mapDioException(e, 'Persona');
    } on RuntApiException {
      rethrow;
    } catch (e) {
      print(e);
      throw RuntApiException.parsing(
        'Error inesperado al procesar respuesta RUNT Persona',
        originalError: e,
      );
    }
  }

  /// Consulta información de un vehículo en el RUNT.
  Future<RuntVehicleResponse> getVehicle({
    required String portalType,
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
  }) async {
    try {
      final url =
          '$baseUrl/runt/vehicle/$portalType/$plate/$ownerDocument/$ownerDocumentType';

      // 🔍 LOG ANTES DE ENVIAR REQUEST
      print('[RUNT][HTTP][REQUEST] GET $url');

      // Realizar petición HTTP
      final response = await _dio.get(url);

      if (response.statusCode != 200) {
        throw RuntApiException.businessLogic(
          message:
              'Error en consulta RUNT Vehículo: HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = response.data as Map<String, dynamic>;
      final parsedResponse = RuntVehicleResponse.fromJson(json);

      if (!parsedResponse.ok) {
        throw RuntApiException.businessLogic(
          message: 'La API del RUNT retornó ok=false para vehículo $plate',
          statusCode: response.statusCode,
          requestId: parsedResponse.meta?.requestId,
        );
      }

      return parsedResponse;
    } on DioException catch (e) {
      print(e);
      throw _mapDioException(e, 'Vehículo');
    } on RuntApiException {
      rethrow;
    } catch (e) {
      print(e);
      throw RuntApiException.parsing(
        'Error inesperado al procesar respuesta RUNT Vehículo',
        originalError: e,
      );
    }
  }

  // ==================== MAPEO DE ERRORES ====================
  RuntApiException _mapDioException(DioException dioException, String context) {
    final response = dioException.response;

    if (response == null) {
      return RuntApiException.network(
        'Error de red al consultar RUNT $context: ${dioException.message}',
      );
    }

    final int statusCode = response.statusCode ?? 0;
    final dynamic responseData = response.data;
    Map<String, dynamic>? bodyMap;

    if (responseData is Map<String, dynamic>) {
      bodyMap = responseData;
    } else if (responseData is String && responseData.isNotEmpty) {
      try {
        bodyMap = jsonDecode(responseData) as Map<String, dynamic>;
      } catch (_) {}
    }

    final Map<String, dynamic>? errorObj =
        bodyMap?['error'] as Map<String, dynamic>?;
    final String? backendErrorSource = errorObj?['errorSource'] as String? ??
        bodyMap?['errorSource'] as String?;
    final String? backendMessage =
        errorObj?['message'] as String? ?? bodyMap?['message'] as String?;

    if (backendErrorSource == 'business_logic') {
      return RuntApiException.businessLogic(
        message: backendMessage ?? 'Error de negocio en RUNT $context',
        statusCode: statusCode,
      );
    }

    if (backendErrorSource == 'parsing') {
      return RuntApiException.parsing(
        backendMessage ?? 'Error de parsing en RUNT $context',
      );
    }

    if (backendMessage != null && backendMessage.isNotEmpty) {
      return RuntApiException.businessLogic(
        message: backendMessage,
        statusCode: statusCode,
      );
    }

    return RuntApiException(
      message: 'Error HTTP $statusCode al consultar RUNT $context',
      statusCode: statusCode,
      errorSource: 'server',
    );
  }
}
