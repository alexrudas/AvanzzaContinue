// ============================================================================
// lib/data/repositories/integrations_repository_impl.dart
//
// INTEGRATIONS REPOSITORY IMPL
//
// Implementación concreta del contrato [IntegrationsRepository].
//
// Flujo cache-first para cada consulta:
//   1. Consultar cache Isar (TTL controlado por IntegrationsLocalDatasource).
//   2. Si existe y no expiró  → deserializar JSON → mapear a entidad → retornar.
//   3. Si no existe o expiró  → llamar API remota → guardar en cache → retornar.
//
// Mapeo Model → Entity:
//   Toda la conversión de DTOs a entidades de dominio ocurre aquí,
//   manteniendo la capa de dominio libre de dependencias de datos.
// ============================================================================

import '../../domain/entities/integrations/runt_person.dart';
import '../../domain/entities/integrations/simit_result.dart';
import '../../domain/repositories/integrations_repository.dart';
import '../datasources/integrations_remote_datasource.dart';
import '../local/integrations_local_datasource.dart';
import '../models/integrations/runt_person_model.dart';
import '../models/integrations/simit_result_model.dart';

class IntegrationsRepositoryImpl implements IntegrationsRepository {
  final IntegrationsRemoteDatasource _remote;
  final IntegrationsLocalDatasource _local;

  IntegrationsRepositoryImpl({
    required IntegrationsRemoteDatasource remote,
    required IntegrationsLocalDatasource local,
  })  : _remote = remote,
        _local = local;

  // ── RUNT Persona ───────────────────────────────────────────────────────────

  @override
  Future<RuntPersonEntity> consultRuntPerson({
    required String document,
    required String type,
  }) async {
    final cacheKey = '${document.trim()}_${type.trim().toUpperCase()}';

    // Paso 1: Revisar cache Isar con TTL de 24 horas.
    final cachedJson = await _local.getRuntPersonCache(cacheKey);
    if (cachedJson != null) {
      final model = RuntPersonResponseModel.fromJson(cachedJson);
      return _mapRuntPersonToEntity(model.data);
    }

    // Paso 2: Cache expirado o inexistente — llamar a la API.
    final response = await _remote.fetchRuntPerson(
      document: document.trim(),
      type: type.trim().toUpperCase(),
    );

    // Paso 3: Guardar respuesta completa en cache para próximas consultas.
    await _local.saveRuntPersonCache(cacheKey, response.toJson());

    // Paso 4: Mapear DTO a entidad de dominio y retornar.
    return _mapRuntPersonToEntity(response.data);
  }

  // ── SIMIT ──────────────────────────────────────────────────────────────────

  @override
  Future<SimitResultEntity> consultSimit({required String query}) async {
    final cacheKey = query.trim().toUpperCase();

    // Paso 1: Revisar cache Isar con TTL de 6 horas.
    final cachedJson = await _local.getSimitCache(cacheKey);
    if (cachedJson != null) {
      final model = SimitResultResponseModel.fromJson(cachedJson);
      return _mapSimitToEntity(model.data, query: query.trim());
    }

    // Paso 2: Cache expirado o inexistente — llamar a la API.
    final response = await _remote.fetchSimit(query: query.trim());

    // Paso 3: Guardar en cache.
    await _local.saveSimitCache(cacheKey, response.toJson());

    // Paso 4: Mapear y retornar.
    return _mapSimitToEntity(response.data, query: query.trim());
  }

  // ── Limpieza ───────────────────────────────────────────────────────────────

  @override
  Future<void> clearCache() async {
    await _local.clearAll();
  }

  // ── Mappers Model → Entity ─────────────────────────────────────────────────

  /// Convierte [RuntPersonDataModel] (DTO) a [RuntPersonEntity] (dominio).
  RuntPersonEntity _mapRuntPersonToEntity(RuntPersonDataModel data) {
    return RuntPersonEntity(
      nombreCompleto: data.nombreCompleto,
      tipoDocumento: data.tipoDocumento,
      numeroDocumento: data.numeroDocumento,
      estadoPersona: data.estadoPersona,
      estadoConductor: data.estadoConductor,
      numeroInscripcionRunt: data.numeroInscripcionRunt,
      fechaInscripcion: data.fechaInscripcion,
      licencias: data.licencias.map(_mapLicenseToEntity).toList(),
    );
  }

  RuntLicenseEntity _mapLicenseToEntity(RuntLicenseModel model) {
    return RuntLicenseEntity(
      numeroLicencia: model.numeroLicencia,
      otExpide: model.otExpide,
      fechaExpedicion: model.fechaExpedicion,
      estado: model.estado,
      restricciones: model.restricciones,
      retencion: model.retencion,
      otCancelaSuspende: model.otCancelaSuspende,
      detalles: model.detalles.map(_mapLicenseDetailToEntity).toList(),
    );
  }

  RuntLicenseDetailEntity _mapLicenseDetailToEntity(
    RuntLicenseDetailModel model,
  ) {
    return RuntLicenseDetailEntity(
      categoria: model.categoria,
      fechaExpedicion: model.fechaExpedicion,
      fechaVencimiento: model.fechaVencimiento,
      categoriaAntigua: model.categoriaAntigua,
    );
  }

  /// Convierte [SimitDataModel] (DTO) a [SimitResultEntity] (dominio).
  SimitResultEntity _mapSimitToEntity(
    SimitDataModel data, {
    required String query,
  }) {
    return SimitResultEntity(
      tieneMultas: data.tieneMultas,
      total: data.total,
      resumen: data.resumen,
      multas: data.multas,
      query: query,
    );
  }
}
