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
  /// Timeout para la consulta principal (resumen + lista, SIN detalles).
  ///
  /// El backend ya NO enriquece detalles inline: la consulta principal
  /// devuelve sólo resumen + lista en ~45-55 s. 90 s da margen amplio.
  /// Los detalles se obtienen on-demand vía [getMultaDetail].
  static const Duration _simitReceiveTimeout = Duration(seconds: 90);

  /// Timeout para la consulta de detalle on-demand de UNA multa.
  ///
  /// Comportamiento backend:
  ///   - Cache hit Redis (24h TTL) → ~50-200 ms
  ///   - Cache miss → ~50-65 s (Chrome real + form + submit + click + extract)
  ///
  /// 90 s cubre el peor caso con holgura. La UI debe mostrar loading
  /// SOLO en la tarjeta tappeada, no bloquear toda la pantalla.
  static const Duration _simitDetailReceiveTimeout = Duration(seconds: 90);

  Future<SimitResponse> getFinesByDocument({
    required String document,
  }) async {
    try {
      final url = '/api/simit/multas/$document';

      // Realizar petición HTTP con timeout extendido para SIMIT
      final response = await _dio.get(
        url,
        options: Options(receiveTimeout: _simitReceiveTimeout),
      );

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

  /// Consulta el DETALLE completo de una multa específica, on-demand.
  ///
  /// Endpoint: GET /api/simit/multas/:document/:comparendoId/detail
  ///
  /// Pensado para llamarse al expandir una tarjeta de multa en la UI.
  /// El backend cachea por (document, comparendoId) en Redis con TTL 24 h
  /// y aplica single-flight in-process — taps repetidos sobre la misma
  /// tarjeta resuelven en ~ms (cache hit) o coalescen en una sola scrape.
  ///
  /// [document]: Cédula o placa que originó la consulta principal
  /// [comparendoId]: Identificador de la multa (debe coincidir con el
  ///   `comparendoId` que devolvió la lista en [getFinesByDocument]).
  ///
  /// Retorna [SimitFineDetail] con las 6 secciones (puede traer alguna
  /// vacía si SIMIT no la expone para esa multa).
  ///
  /// Lanza [SimitApiException]:
  ///   - [SimitApiException.network] si hay timeout / sin red
  ///   - [SimitApiException.businessLogic] si HTTP != 200 o ok=false
  ///   - [SimitApiException.parsing] si el JSON no calza con el contrato
  Future<SimitFineDetail> getMultaDetail({
    required String document,
    required String comparendoId,
  }) async {
    try {
      final url = '/api/simit/multas/$document/$comparendoId/detail';

      final response = await _dio.get(
        url,
        options: Options(receiveTimeout: _simitDetailReceiveTimeout),
      );

      if (response.statusCode != 200) {
        throw SimitApiException.businessLogic(
          message:
              'Error en consulta detalle SIMIT: HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = response.data as Map<String, dynamic>;

      // Contrato backend: { ok, source, data: { comparendoId, detalle, cached }, meta }
      final ok = json['ok'] == true;
      if (!ok) {
        throw SimitApiException.businessLogic(
          message:
              'API SIMIT detalle retornó ok=false para $document/$comparendoId',
          statusCode: response.statusCode,
        );
      }

      final data = json['data'] as Map<String, dynamic>?;
      final detalleJson = data?['detalle'] as Map<String, dynamic>?;

      if (detalleJson == null) {
        throw SimitApiException.parsing(
          'Respuesta de detalle SIMIT sin campo data.detalle',
        );
      }

      return SimitFineDetail.fromJson(detalleJson);
    } on DioException catch (e) {
      throw SimitApiException.network(
        'Error de red al consultar detalle SIMIT: ${e.message}',
      );
    } on SimitApiException {
      rethrow;
    } catch (e) {
      throw SimitApiException.parsing(
        'Error inesperado al procesar detalle SIMIT',
        originalError: e,
      );
    }
  }
}