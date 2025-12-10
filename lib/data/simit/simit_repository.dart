// ===================== lib/data/simit/simit_repository.dart =====================

import 'models/simit_models.dart';
import 'simit_service.dart';

/// Repositorio de alto nivel para datos de SIMIT.
///
/// Proporciona una capa de abstracción sobre [SimitService] con:
/// - API simplificada para casos de uso y controllers
/// - Gestión de cache local (preparado para Isar)
/// - Lógica de negocio adicional si es necesaria
///
/// Este repositorio puede ser inyectado en:
/// - Casos de uso (Clean Architecture)
/// - GetX Controllers
/// - Cualquier otra capa de presentación o dominio
class SimitRepository {
  final SimitService _service;

  /// Constructor con inyección de dependencias.
  ///
  /// [_service]: Servicio HTTP de SIMIT ya configurado
  SimitRepository(this._service);

  /// Obtiene todas las multas asociadas a un documento.
  ///
  /// [document]: Número de cédula de la persona a consultar
  ///
  /// Retorna [SimitData] con:
  /// - Resumen de multas y comparendos
  /// - Lista detallada de multas
  /// - Total a pagar
  ///
  /// Si la persona no tiene multas, retorna [SimitData] con:
  /// - hasFines = false
  /// - fines = []
  /// - total = 0
  ///
  /// Estrategia de cache (a implementar):
  /// 1. Buscar en cache local por documento
  /// 2. Si no existe o está desactualizado (ej: más de 24h), consultar API
  /// 3. Guardar en cache
  /// 4. Retornar datos
  Future<SimitData> obtenerMultasPorDocumento(String document) async {
    // TODO: INTEGRATION ISAR (Read cache logic here)
    // Ejemplo:
    // final cached = await _isarDb.simitFinesCache
    //     .where()
    //     .documentEqualTo(document)
    //     .findFirst();
    //
    // if (cached != null && !cached.isExpired()) {
    //   return cached.toSimitData();
    // }

    // Consultar API
    final response = await _service.getFinesByDocument(document: document);

    // TODO: INTEGRATION ISAR (Save cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   await _isarDb.simitFinesCache.put(
    //     SimitFinesCacheEntity.fromResponse(response),
    //   );
    // });

    // Retornar solo los datos (sin meta ni ok)
    return response.data;
  }

  /// Obtiene el resumen de multas sin el detalle completo.
  ///
  /// Útil para mostrar totales rápidamente sin cargar todo el detalle.
  ///
  /// [document]: Número de cédula
  ///
  /// Retorna [SimitSummary] con contadores y totales.
  Future<SimitSummary> obtenerResumenMultas(String document) async {
    final data = await obtenerMultasPorDocumento(document);
    return data.summary;
  }

  /// Verifica si una persona tiene multas pendientes.
  ///
  /// [document]: Número de cédula
  ///
  /// Retorna true si tiene multas, false si no tiene.
  Future<bool> tieneMultasPendientes(String document) async {
    final data = await obtenerMultasPorDocumento(document);
    return data.hasFines;
  }

  /// Obtiene el total a pagar en multas.
  ///
  /// [document]: Número de cédula
  ///
  /// Retorna el monto total en pesos colombianos.
  /// Retorna 0 si no tiene multas.
  Future<num> obtenerTotalAPagar(String document) async {
    final data = await obtenerMultasPorDocumento(document);
    return data.total;
  }

  /// Limpia el cache de multas.
  ///
  /// Útil para forzar una nueva consulta a la API.
  Future<void> limpiarCache() async {
    // TODO: INTEGRATION ISAR (Clear cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   await _isarDb.simitFinesCache.clear();
    // });
  }

  /// Limpia el cache de multas para un documento específico.
  ///
  /// [document]: Número de cédula cuyo cache se desea limpiar
  Future<void> limpiarCachePorDocumento(String document) async {
    // TODO: INTEGRATION ISAR (Clear specific cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   final cached = await _isarDb.simitFinesCache
    //       .where()
    //       .documentEqualTo(document)
    //       .findFirst();
    //   if (cached != null) {
    //     await _isarDb.simitFinesCache.delete(cached.id);
    //   }
    // });
  }
}