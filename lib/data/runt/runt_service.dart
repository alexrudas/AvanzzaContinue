// ===================== lib/data/runt/runt_service.dart =====================

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

      // Errores de red: timeout, no connection, etc.
      throw RuntApiException.network(
        'Error de red al consultar RUNT Persona: ${e.message}',
      );
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

      // Errores de red: timeout, no connection, etc.
      throw RuntApiException.network(
        'Error de red al consultar RUNT Vehículo: ${e.message}',
      );
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
}
