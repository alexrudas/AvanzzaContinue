// ============================================================================
// lib/data/local/integrations_local_datasource.dart
//
// INTEGRATIONS LOCAL DATASOURCE — Cache Isar con TTL
//
// Persiste en Isar los resultados de consultas RUNT Persona y SIMIT
// con Time-To-Live configurable para evitar llamadas innecesarias a la API.
//
// TTL configurados en [IntegrationsApiConfig]:
//   - RUNT Persona: 24 horas
//   - SIMIT:         6 horas
//
// ⚠️  PASO OBLIGATORIO DESPUÉS DE CREAR ESTE ARCHIVO:
//
//     1. Ejecutar build_runner para generar integrations_local_datasource.g.dart:
//
//        flutter pub run build_runner build --delete-conflicting-outputs
//
//     2. Agregar los schemas generados al registro de Isar donde se abre la DB.
//        Busca la función que llama a Isar.open() en tu proyecto y agrega:
//
//        schemas: [
//          ...schemasActuales,
//          IntegrationsRuntPersonCacheModelSchema,
//          IntegrationsSimitCacheModelSchema,
//        ]
//
//        Típicamente en: lib/core/db/ o lib/core/startup/bootstrap.dart
//
// ============================================================================

import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../core/config/integrations_api_config.dart';

part 'integrations_local_datasource.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Colección Isar — RUNT Persona Cache
// ─────────────────────────────────────────────────────────────────────────────

/// Modelo de cache Isar para consultas RUNT Persona.
///
/// El campo [dataJson] almacena la respuesta completa serializada como JSON
/// para evitar modelos @embedded complejos y simplificar migraciones futuras.
@Collection()
class IntegrationsRuntPersonCacheModel {
  IntegrationsRuntPersonCacheModel();

  /// ID auto-incremental de Isar.
  Id isarId = Isar.autoIncrement;

  /// Clave de búsqueda única: "{document}_{type}" (ej. "72184925_CC").
  /// Índice único con reemplazo: una nueva consulta sobreescribe el cache anterior.
  @Index(unique: true, replace: true)
  late String cacheKey;

  /// Timestamp de cuando se guardó la consulta en cache.
  late DateTime cachedAt;

  /// Respuesta completa de la API serializada como JSON string.
  /// Se deserializa en el datasource al recuperar del cache.
  late String dataJson;
}

// ─────────────────────────────────────────────────────────────────────────────
// Colección Isar — SIMIT Cache
// ─────────────────────────────────────────────────────────────────────────────

/// Modelo de cache Isar para consultas SIMIT Multas.
@Collection()
class IntegrationsSimitCacheModel {
  IntegrationsSimitCacheModel();

  /// ID auto-incremental de Isar.
  Id isarId = Isar.autoIncrement;

  /// Clave de búsqueda única: la query original (placa o documento).
  @Index(unique: true, replace: true)
  late String cacheKey;

  /// Timestamp de cuando se guardó la consulta en cache.
  late DateTime cachedAt;

  /// Respuesta completa de la API serializada como JSON string.
  late String dataJson;
}

// ─────────────────────────────────────────────────────────────────────────────
// Datasource
// ─────────────────────────────────────────────────────────────────────────────

/// Datasource local que gestiona el cache de consultas de integraciones en Isar.
///
/// Recibe la instancia de [Isar] como dependencia (inyectada desde el binding
/// a través de [DIContainer().isar]).
class IntegrationsLocalDatasource {
  final Isar _isar;

  IntegrationsLocalDatasource(this._isar);

  // ── RUNT Persona ───────────────────────────────────────────────────────────

  /// Recupera un resultado RUNT Persona del cache si existe y no ha expirado.
  ///
  /// Retorna el mapa JSON deserializado o null si el cache es inválido/expirado.
  Future<Map<String, dynamic>?> getRuntPersonCache(String cacheKey) async {
    final record = await _isar.integrationsRuntPersonCacheModels
        .where()
        .cacheKeyEqualTo(cacheKey)
        .findFirst();

    if (record == null) return null;

    // Valida TTL: descarta registros más viejos que 24 horas.
    final age = DateTime.now().difference(record.cachedAt);
    if (age > IntegrationsApiConfig.runtPersonTtl) {
      // Cache expirado — se limpia para no acumular datos stale.
      await _isar.writeTxn(() async {
        await _isar.integrationsRuntPersonCacheModels.delete(record.isarId);
      });
      return null;
    }

    try {
      return jsonDecode(record.dataJson) as Map<String, dynamic>;
    } catch (_) {
      // Cache corrupto — elimina y retorna null para forzar llamada remota.
      await _isar.writeTxn(() async {
        await _isar.integrationsRuntPersonCacheModels.delete(record.isarId);
      });
      return null;
    }
  }

  /// Guarda una respuesta RUNT Persona en el cache Isar.
  ///
  /// Si ya existe un registro con el mismo [cacheKey], lo reemplaza (unique+replace).
  Future<void> saveRuntPersonCache(
    String cacheKey,
    Map<String, dynamic> data,
  ) async {
    final model = IntegrationsRuntPersonCacheModel()
      ..cacheKey = cacheKey
      ..cachedAt = DateTime.now()
      ..dataJson = jsonEncode(data);

    await _isar.writeTxn(() async {
      await _isar.integrationsRuntPersonCacheModels.put(model);
    });
  }

  // ── SIMIT ──────────────────────────────────────────────────────────────────

  /// Recupera un resultado SIMIT del cache si existe y no ha expirado.
  ///
  /// Retorna el mapa JSON deserializado o null si el cache es inválido/expirado.
  Future<Map<String, dynamic>?> getSimitCache(String cacheKey) async {
    final record = await _isar.integrationsSimitCacheModels
        .where()
        .cacheKeyEqualTo(cacheKey)
        .findFirst();

    if (record == null) return null;

    // Valida TTL: descarta registros más viejos que 6 horas.
    final age = DateTime.now().difference(record.cachedAt);
    if (age > IntegrationsApiConfig.simitTtl) {
      await _isar.writeTxn(() async {
        await _isar.integrationsSimitCacheModels.delete(record.isarId);
      });
      return null;
    }

    try {
      return jsonDecode(record.dataJson) as Map<String, dynamic>;
    } catch (_) {
      await _isar.writeTxn(() async {
        await _isar.integrationsSimitCacheModels.delete(record.isarId);
      });
      return null;
    }
  }

  /// Guarda una respuesta SIMIT en el cache Isar.
  Future<void> saveSimitCache(
    String cacheKey,
    Map<String, dynamic> data,
  ) async {
    final model = IntegrationsSimitCacheModel()
      ..cacheKey = cacheKey
      ..cachedAt = DateTime.now()
      ..dataJson = jsonEncode(data);

    await _isar.writeTxn(() async {
      await _isar.integrationsSimitCacheModels.put(model);
    });
  }

  // ── Limpieza ───────────────────────────────────────────────────────────────

  /// Elimina un registro RUNT Persona específico del cache por su clave.
  ///
  /// Usado por el flujo de refresh manual: al limpiar la entrada antes de
  /// llamar consultRuntPerson, se fuerza una consulta fresca a la API
  /// independientemente del TTL.
  Future<void> deleteRuntPersonCacheByKey(String cacheKey) async {
    final record = await _isar.integrationsRuntPersonCacheModels
        .where()
        .cacheKeyEqualTo(cacheKey)
        .findFirst();
    if (record == null) return;
    await _isar.writeTxn(() async {
      await _isar.integrationsRuntPersonCacheModels.delete(record.isarId);
    });
  }

  /// Elimina un registro SIMIT específico del cache por su clave.
  ///
  /// Mismo patrón que [deleteRuntPersonCacheByKey] — fuerza refresh
  /// bypass de TTL para el flujo de actualización manual.
  Future<void> deleteSimitCacheByKey(String cacheKey) async {
    final record = await _isar.integrationsSimitCacheModels
        .where()
        .cacheKeyEqualTo(cacheKey)
        .findFirst();
    if (record == null) return;
    await _isar.writeTxn(() async {
      await _isar.integrationsSimitCacheModels.delete(record.isarId);
    });
  }

  /// Elimina todos los registros de cache de integraciones en Isar.
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.integrationsRuntPersonCacheModels.clear();
      await _isar.integrationsSimitCacheModels.clear();
    });
  }
}
