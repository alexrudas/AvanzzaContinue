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
  ///
  /// Endpoint: GET /runt/person/consult/:document/:typeDcm
  ///
  /// [document]: Número de documento (cédula, pasaporte, etc.)
  /// [documentType]: Tipo de documento:
  ///   - "C" para Cédula de Ciudadanía
  ///   - "E" para Cédula de Extranjería
  ///   - "P" para Pasaporte
  ///
  /// Retorna [RuntPersonResponse] con toda la información de la persona.
  ///
  /// Lanza [RuntApiException] si:
  /// - Hay error de red
  /// - La respuesta tiene ok=false
  /// - El parsing falla
  Future<RuntPersonResponse> getPersonConsult({
    required String document,
    required String documentType,
  }) async {
    try {
      final url = '$baseUrl/runt/person/consult/$document/$documentType';

      // Realizar petición HTTP
      final response = await _dio.get(url);

      // Validar status code
      if (response.statusCode != 200) {
        throw RuntApiException.businessLogic(
          message:
              'Error en consulta RUNT Persona: HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      // Parsear respuesta
      final json = response.data as Map<String, dynamic>;
      final parsedResponse = RuntPersonResponse.fromJson(json);

      // Validar campo ok
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

      // Mapear DioException con clasificación correcta según response
      throw _mapDioException(e, 'Persona');
    } on RuntApiException {
      // Re-lanzar excepciones propias
      rethrow;
    } catch (e) {
      print(e);

      // Errores de parsing u otros
      throw RuntApiException.parsing(
        'Error inesperado al procesar respuesta RUNT Persona',
        originalError: e,
      );
    }
  }

  /// Consulta información de un vehículo en el RUNT.
  ///
  /// Endpoint: GET /runt/vehicle/:type/:plaque/:license/:typeDcm
  ///
  /// [portalType]: Tipo de portal de consulta:
  ///   - "GOV" para portal gubernamental
  ///   - "COM" para portal ciudadano
  /// [plate]: Placa del vehículo (ej: "ABC123")
  /// [ownerDocument]: Documento del propietario
  /// [ownerDocumentType]: Tipo de documento del propietario ("C", "E", "P")
  ///
  /// Retorna [RuntVehicleResponse] con toda la información del vehículo.
  ///
  /// Lanza [RuntApiException] si:
  /// - Hay error de red
  /// - La respuesta tiene ok=false
  /// - El parsing falla
  Future<RuntVehicleResponse> getVehicle({
    required String portalType,
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
  }) async {
    try {
      final url =
          '$baseUrl/runt/vehicle/$portalType/$plate/$ownerDocument/$ownerDocumentType';

      // Realizar petición HTTP
      final response = await _dio.get(url);

      // Validar status code
      if (response.statusCode != 200) {
        throw RuntApiException.businessLogic(
          message:
              'Error en consulta RUNT Vehículo: HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      // Parsear respuesta
      final json = response.data as Map<String, dynamic>;
      final parsedResponse = RuntVehicleResponse.fromJson(json);

      // Validar campo ok
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

      // Mapear DioException con clasificación correcta según response
      throw _mapDioException(e, 'Vehículo');
    } on RuntApiException {
      // Re-lanzar excepciones propias
      rethrow;
    } catch (e) {
      print(e);
      // Errores de parsing u otros
      throw RuntApiException.parsing(
        'Error inesperado al procesar respuesta RUNT Vehículo',
        originalError: e,
      );
    }
  }

  /// Mapea un [DioException] a [RuntApiException] con clasificación correcta.
  ///
  /// Reglas de clasificación:
  /// 1. Si NO hay response HTTP (null) => errorSource='network'
  /// 2. Si HAY response HTTP con body válido:
  ///    a) Si body.errorSource existe => usar ese valor
  ///    b) Si body.message existe => errorSource='business_logic' (mensaje de negocio)
  ///    c) Si no hay message útil => errorSource='server' (error HTTP genérico)
  ///
  /// EJEMPLOS:
  /// - 400 + {"error":{"errorSource":"business_logic","message":"Identificación incorrecta"}}
  ///   => business_logic + "Identificación incorrecta" ✅
  /// - 422 + {"message":"Propietario no coincide"} (root)
  ///   => business_logic + "Propietario no coincide" ✅
  /// - 500 + {"error":{"message":"Error interno del servidor"}}
  ///   => business_logic + "Error interno del servidor" ✅
  /// - 500 sin body
  ///   => server + "Error HTTP 500..." ⚠️
  /// - timeout/DNS/sin internet (response==null)
  ///   => network + "Error de red..." ⚠️
  RuntApiException _mapDioException(DioException dioException, String context) {
    final response = dioException.response;

    // ============================================================
    // CASO 1: SIN respuesta HTTP => error de RED REAL
    // ============================================================
    if (response == null) {
      return RuntApiException.network(
        'Error de red al consultar RUNT $context: ${dioException.message}',
      );
    }

    // ============================================================
    // CASO 2: CON respuesta HTTP => parsear body defensivamente
    // ============================================================
    final int statusCode = response.statusCode ?? 0;
    final dynamic responseData = response.data;
    Map<String, dynamic>? bodyMap;

    // Paso A: Parsear response.data según su tipo (Map o String JSON)
    if (responseData is Map<String, dynamic>) {
      bodyMap = responseData;
    } else if (responseData is String && responseData.isNotEmpty) {
      try {
        bodyMap = jsonDecode(responseData) as Map<String, dynamic>;
      } catch (_) {
        // No es JSON válido, bodyMap queda null
      }
    }

    // Paso B: Extraer campos en orden de prioridad (error anidado > root)
    final Map<String, dynamic>? errorObj = bodyMap?['error'] as Map<String, dynamic>?;
    final String? backendErrorSource = errorObj?['errorSource'] as String? ?? bodyMap?['errorSource'] as String?;
    final String? backendMessage = errorObj?['message'] as String? ?? bodyMap?['message'] as String?;

    // ============================================================
    // REGLA 2.1: Backend envía errorSource explícito => USARLO
    // ============================================================
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

    // ============================================================
    // REGLA 2.2: HAY mensaje del backend => es lógica de negocio
    // (Aplica para 4xx, 5xx, cualquier status con mensaje útil)
    // ============================================================
    if (backendMessage != null && backendMessage.isNotEmpty) {
      return RuntApiException.businessLogic(
        message: backendMessage, // PRESERVAR mensaje real del backend
        statusCode: statusCode,
      );
    }

    // ============================================================
    // REGLA 2.3: NO hay mensaje útil => error HTTP genérico
    // (NO es network porque SÍ hubo respuesta HTTP)
    // ============================================================
    return RuntApiException(
      message: 'Error HTTP $statusCode al consultar RUNT $context',
      statusCode: statusCode,
      errorSource: 'server', // Clasificar como error del servidor
    );
  }
}
