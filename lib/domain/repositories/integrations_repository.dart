// ============================================================================
// lib/domain/repositories/integrations_repository.dart
//
// INTEGRATIONS REPOSITORY — Contrato de dominio
//
// Define el contrato que la capa de datos debe implementar para consultas
// de integraciones externas (RUNT Persona + SIMIT Multas).
//
// La capa de presentación y los controllers solo conocen esta abstracción.
// ============================================================================

import '../entities/integrations/runt_person.dart';
import '../entities/integrations/simit_result.dart';

/// Contrato de repositorio para integraciones externas (RUNT + SIMIT).
///
/// La implementación concreta ([IntegrationsRepositoryImpl]) aplica
/// lógica de cache-first con TTL antes de llamar a la API remota.
abstract class IntegrationsRepository {
  /// Consulta los datos de una persona en el RUNT por documento.
  ///
  /// [document] Número de documento (ej. "72184925").
  /// [type] Tipo de documento (ej. "CC", "CE", "PAS").
  ///
  /// Flujo:
  /// 1. Revisa cache Isar (TTL: 24 horas).
  /// 2. Si existe y no expiró → retorna desde cache.
  /// 3. Si no → llama a la API, guarda en cache, retorna entidad.
  ///
  /// Lanza [Exception] si la API responde con `ok: false` o hay error de red.
  Future<RuntPersonEntity> consultRuntPerson({
    required String document,
    required String type,
  });

  /// Consulta las multas de una placa o documento en SIMIT.
  ///
  /// [query] puede ser un número de documento o una placa (ej. "SDV757").
  ///
  /// Flujo:
  /// 1. Revisa cache Isar (TTL: 6 horas).
  /// 2. Si existe y no expiró → retorna desde cache.
  /// 3. Si no → llama a la API, guarda en cache, retorna entidad.
  ///
  /// Lanza [Exception] si la API responde con `ok: false` o hay error de red.
  Future<SimitResultEntity> consultSimit({required String query});

  /// Limpia todos los registros de cache de integraciones en Isar.
  ///
  /// Útil para forzar actualización manual de datos.
  Future<void> clearCache();

  /// Invalida el cache de RUNT Persona para una clave específica.
  ///
  /// Llamar antes de [consultRuntPerson] para forzar consulta fresca a la API
  /// independientemente del TTL. Usado por el flujo de refresh manual.
  Future<void> invalidateRuntPersonCache(String document, String type);

  /// Invalida el cache de SIMIT para una clave específica.
  ///
  /// Llamar antes de [consultSimit] para forzar consulta fresca.
  Future<void> invalidateSimitCache(String query);
}
