// ===================== lib/data/runt/runt_repository.dart =====================

import 'models/runt_person_models.dart';
import 'models/runt_vehicle_models.dart';
import 'runt_service.dart';

/// Repositorio de alto nivel para datos del RUNT.
///
/// Proporciona una capa de abstracción sobre [RuntService] con:
/// - API simplificada para casos de uso y controllers
/// - Gestión de cache local (preparado para Isar)
/// - Lógica de negocio adicional si es necesaria
///
/// Este repositorio puede ser inyectado en:
/// - Casos de uso (Clean Architecture)
/// - GetX Controllers
/// - Cualquier otra capa de presentación o dominio
class RuntRepository {
  final RuntService _service;

  /// Constructor con inyección de dependencias.
  ///
  /// [_service]: Servicio HTTP del RUNT ya configurado
  RuntRepository(this._service);

  /// Obtiene información completa de una persona por documento.
  ///
  /// [document]: Número de documento (cédula, pasaporte, etc.)
  /// [documentType]: Tipo de documento ("C", "E", "P")
  ///
  /// Retorna [RuntPersonData] con toda la información del conductor.
  ///
  /// Estrategia de cache (a implementar):
  /// 1. Buscar en cache local (Isar)
  /// 2. Si no existe o está desactualizado, consultar API
  /// 3. Guardar en cache la nueva respuesta
  /// 4. Retornar datos
  Future<RuntPersonData> obtenerPersonaPorDocumento(
    String document,
    String documentType,
  ) async {
    // TODO: INTEGRATION ISAR (Read cache logic here)
    // Ejemplo:
    // final cached = await _isarDb.runtPersonCache
    //     .where()
    //     .documentEqualTo(document)
    //     .findFirst();
    //
    // if (cached != null && !cached.isExpired()) {
    //   return cached.toRuntPersonData();
    // }

    // Consultar API
    final response = await _service.getPersonConsult(
      document: document,
      documentType: documentType,
    );

    // TODO: INTEGRATION ISAR (Save cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   await _isarDb.runtPersonCache.put(
    //     RuntPersonCacheEntity.fromResponse(response),
    //   );
    // });

    // Retornar solo los datos (sin meta ni ok)
    return response.data;
  }

  /// Obtiene información completa de un vehículo.
  ///
  /// [portalType]: Tipo de portal ("GOV" o "COM")
  /// [plate]: Placa del vehículo
  /// [ownerDocument]: Documento del propietario
  /// [ownerDocumentType]: Tipo de documento del propietario
  ///
  /// Retorna [RuntVehicleData] con toda la información del vehículo.
  ///
  /// Estrategia de cache (a implementar):
  /// 1. Buscar en cache local por placa
  /// 2. Si no existe o está desactualizado, consultar API
  /// 3. Guardar en cache
  /// 4. Retornar datos
  Future<RuntVehicleData> obtenerVehiculo({
    required String portalType,
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
  }) async {
    // TODO: INTEGRATION ISAR (Read cache logic here)
    // Ejemplo:
    // final cached = await _isarDb.runtVehicleCache
    //     .where()
    //     .plateEqualTo(plate)
    //     .findFirst();
    //
    // if (cached != null && !cached.isExpired()) {
    //   return cached.toRuntVehicleData();
    // }

    // Consultar API
    final response = await _service.getVehicle(
      portalType: portalType,
      plate: plate,
      ownerDocument: ownerDocument,
      ownerDocumentType: ownerDocumentType,
    );

    // TODO: INTEGRATION ISAR (Save cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   await _isarDb.runtVehicleCache.put(
    //     RuntVehicleCacheEntity.fromResponse(response),
    //   );
    // });

    // Retornar solo los datos (sin meta ni ok)
    return response.data;
  }

  /// Limpia el cache de personas.
  ///
  /// Útil para forzar una nueva consulta a la API.
  Future<void> limpiarCachePersonas() async {
    // TODO: INTEGRATION ISAR (Clear cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   await _isarDb.runtPersonCache.clear();
    // });
  }

  /// Limpia el cache de vehículos.
  ///
  /// Útil para forzar una nueva consulta a la API.
  Future<void> limpiarCacheVehiculos() async {
    // TODO: INTEGRATION ISAR (Clear cache logic here)
    // Ejemplo:
    // await _isarDb.writeTxn(() async {
    //   await _isarDb.runtVehicleCache.clear();
    // });
  }

  /// Limpia todo el cache del RUNT (personas y vehículos).
  Future<void> limpiarTodoElCache() async {
    await limpiarCachePersonas();
    await limpiarCacheVehiculos();
  }
}