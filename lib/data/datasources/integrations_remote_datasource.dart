// ============================================================================
// lib/data/datasources/integrations_remote_datasource.dart
//
// INTEGRATIONS REMOTE DATASOURCE
//
// Realiza las llamadas HTTP a la API de integraciones externas.
// Usa el cliente Dio aislado del módulo (IntegrationsApiClient).
//
// Responsabilidades:
// - Construir URLs de los endpoints.
// - Ejecutar requests GET.
// - Deserializar respuestas en DTOs.
// - Traducir DioException → Exception legible para el repositorio.
//
// NO contiene lógica de cache ni de negocio.
// ============================================================================

import 'package:dio/dio.dart';

import '../models/integrations/runt_person_model.dart';
import '../models/integrations/simit_result_model.dart';

/// Datasource remoto para consultas RUNT Persona y SIMIT Multas.
///
/// Recibe el [Dio] ya configurado con base URL e interceptores del módulo.
class IntegrationsRemoteDatasource {
  final Dio _dio;

  IntegrationsRemoteDatasource(this._dio);

  // ── RUNT Persona ───────────────────────────────────────────────────────────

  /// Consulta los datos de una persona en el RUNT.
  ///
  /// Endpoint: GET /runt/person/consult/:document/:type
  ///
  /// Retorna [RuntPersonResponseModel] listo para persistir en cache
  /// y mapear a entidad de dominio.
  Future<RuntPersonResponseModel> fetchRuntPerson({
    required String document,
    required String type,
  }) async {
    final url = '/api/runt/person/consult/$document/$type';

    try {
      final response = await _dio.get<Map<String, dynamic>>(url);

      final data = response.data;
      if (data == null) {
        throw Exception('RUNT Persona: respuesta vacía del servidor.');
      }

      final model = RuntPersonResponseModel.fromJson(data);

      if (!model.ok) {
        throw Exception(
          'RUNT Persona: la consulta no fue exitosa (ok: false).',
        );
      }

      return model;
    } on DioException catch (e) {
      throw _mapDioError(e, 'RUNT Persona');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('RUNT Persona: error inesperado — $e');
    }
  }

  // ── SIMIT Multas ───────────────────────────────────────────────────────────

  /// Timeout dedicado para SIMIT — el scrape interactivo en el backend
  /// (form + submit + waitForResults + Angular pintando) toma 45-55 s
  /// consistentemente. Con el default de 30 s del Dio integrations, el
  /// cliente abortaba antes de recibir respuesta y `OwnerRefreshService`
  /// caía con timeout aunque el backend completara OK y poblara cache
  /// Redis. 90 s da holgura sin tocar el timeout global.
  ///
  /// Mismo valor que `SimitService._simitReceiveTimeout` para el path
  /// directo — los dos consumen el mismo endpoint backend.
  static const Duration _simitReceiveTimeout = Duration(seconds: 90);

  /// Consulta las multas de una placa o documento en SIMIT.
  ///
  /// Endpoint: GET /simit/multas/:query
  ///
  /// Retorna [SimitResultResponseModel] listo para persistir en cache
  /// y mapear a entidad de dominio.
  Future<SimitResultResponseModel> fetchSimit({
    required String query,
  }) async {
    final url = '/api/simit/multas/$query';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        options: Options(receiveTimeout: _simitReceiveTimeout),
      );

      final data = response.data;
      if (data == null) {
        throw Exception('SIMIT: respuesta vacía del servidor.');
      }

      final model = SimitResultResponseModel.fromJson(data);

      if (!model.ok) {
        throw Exception('SIMIT: la consulta no fue exitosa (ok: false).');
      }

      return model;
    } on DioException catch (e) {
      throw _mapDioError(e, 'SIMIT');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('SIMIT: error inesperado — $e');
    }
  }

  // ── Helper ─────────────────────────────────────────────────────────────────

  /// Mapea [DioException] a [Exception] con mensaje descriptivo.
  Exception _mapDioError(DioException e, String context) {
    final statusCode = e.response?.statusCode;
    final message = e.message ?? 'Sin detalle';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('$context: timeout de conexión — $message');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Exception('$context: sin conexión a la red — $message');
    }

    if (statusCode != null) {
      return Exception('$context: error HTTP $statusCode — $message');
    }

    return Exception('$context: error de red — $message');
  }
}
