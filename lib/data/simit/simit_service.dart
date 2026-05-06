// ===================== lib/data/simit/simit_service.dart =====================

import 'package:dio/dio.dart';
import '../../core/exceptions/api_exceptions.dart';
import 'models/simit_models.dart';

/// Servicio HTTP para consumir la API de SIMIT (Sistema Integrado de Multas de Tránsito).
///
/// QUÉ HACE:
/// - Consulta multas por documento contra Integrations API.
///
/// QUÉ NO HACE:
/// - No construye baseUrl. El [Dio] inyectado ya trae origin; el service
///   solo pasa el path absoluto con su prefijo (`/api/simit/...`).
/// - No maneja cache — responsabilidad del repositorio.
class SimitService {
  final Dio _dio;

  /// Constructor. Recibe el [Dio] con baseUrl = origin de Integrations
  /// y `ApiKeyInterceptor` ya configurados.
  SimitService(this._dio);

  /// Consulta multas de tránsito por número de documento.
  ///
  /// Endpoint: GET /api/simit/multas/:license
  ///
  /// [document]: Número de documento (cédula) de la persona a consultar
  ///
  /// Retorna [SimitResponse] con:
  /// - Resumen de multas y comparendos
  /// - Lista detallada de todas las multas
  /// - Total a pagar
  ///
  /// Lanza [SimitApiException] si:
  /// - Hay error de red
  /// - La respuesta tiene ok=false
  /// - El parsing falla
  ///
  /// NOTA: Si una persona no tiene multas, la API retorna ok=true con
  /// data.hasFines=false y lista vacía. Esto NO es un error.
  Future<SimitResponse> getFinesByDocument({
    required String document,
  }) async {
    try {
      final url = '/api/simit/multas/$document';

      // Realizar petición HTTP
      final response = await _dio.get(url);

      // Validar status code
      if (response.statusCode != 200) {
        throw SimitApiException.businessLogic(
          message: 'Error en consulta SIMIT: HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      // Parsear respuesta
      final json = response.data as Map<String, dynamic>;
      final parsedResponse = SimitResponse.fromJson(json);

      // Validar campo ok
      if (!parsedResponse.ok) {
        throw SimitApiException.businessLogic(
          message: 'La API de SIMIT retornó ok=false para documento $document',
          statusCode: response.statusCode,
          requestId: parsedResponse.meta?.requestId,
        );
      }

      return parsedResponse;
    } on DioException catch (e) {
      // Errores de red: timeout, no connection, etc.
      throw SimitApiException.network(
        'Error de red al consultar SIMIT: ${e.message}',
      );
    } on SimitApiException {
      // Re-lanzar excepciones propias
      rethrow;
    } catch (e) {
      // Errores de parsing u otros
      throw SimitApiException.parsing(
        'Error inesperado al procesar respuesta SIMIT',
        originalError: e,
      );
    }
  }
}