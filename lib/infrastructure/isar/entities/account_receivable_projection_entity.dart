// ============================================================================
// lib/infrastructure/isar/entities/account_receivable_projection_entity.dart
// AUDIT TRAIL PROJECTION — Enterprise Ultra Pro (Infra / Isar)
//
// HARDENED — DETERMINISTIC — FAIL HARD — AUDIT GRADE
//
// PRINCIPIOS:
// - replace:true en entityId → upsert directo (proyección se actualiza en cada evento).
// - estado almacenado como String wire (independencia del generador de enums).
// - updatedAtIso indexado para queries de proyecciones recientes.
// - Mappers top-level: infra pura, sin lógica de negocio.
// - La proyección NO tiene integridad propia: el hash lo valida la chain de eventos.
// - MAPPING enum ↔ estadoWire: único lugar autorizado → ARProjectionEstadoCodec.
//
// NOTA:
// build_runner genera el .g.dart.
// NO modificar manualmente el archivo generado.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../domain/entities/accounting/account_receivable_projection.dart';
import '../codecs/ar_projection_estado_codec.dart';

part 'account_receivable_projection_entity.g.dart';

@Collection(
  ignore: {
    // Computed getters: no persisten en Isar
    'updatedAt',
    'estadoEnum',
  },
)
class AccountReceivableProjectionEntity {
  // ==========================================================================
  // PRIMARY KEY (Isar internal auto increment)
  // ==========================================================================

  Id id = Isar.autoIncrement;

  // ==========================================================================
  // BUSINESS KEY — UNIQUE + REPLACE (proyección se sobreescribe en cada evento)
  // ==========================================================================

  /// ID de la entidad CxC. replace:true → upsert sin collision.
  @Index(unique: true, replace: true)
  late String entityId;

  // ==========================================================================
  // PROJECTION STATE (int COP — nunca double)
  // ==========================================================================

  /// Saldo pendiente actual. Siempre >= 0 (invariante del domain).
  late int saldoActualCop;

  /// Acumulado total recaudado en efectivo (sin ajustes).
  late int totalRecaudadoCop;

  // ==========================================================================
  // ESTADO
  // ==========================================================================

  /// Estado wire: 'abierta' | 'cerrada' | 'ajustada' (codificado por
  /// ARProjectionEstadoCodec). Almacenado como String para independencia
  /// del generador de enums.
  @Index()
  late String estadoWire;

  // ==========================================================================
  // HASH CHAIN
  // ==========================================================================

  /// Hash del último AccountingEvent aplicado. Null si ningún evento aún.
  /// Permite detectar desincronización projection ↔ event log.
  String? lastEventHash;

  // ==========================================================================
  // TIMESTAMP
  // ==========================================================================

  /// ISO8601 UTC. Momento del último evento aplicado.
  /// Indexado para queries de proyecciones recientes.
  @Index()
  late String updatedAtIso;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  AccountReceivableProjectionEntity();

  // ==========================================================================
  // COMPUTED GETTERS (NO PERSISTIDOS — ignorados por @Collection)
  // ==========================================================================

  DateTime get updatedAt => DateTime.parse(updatedAtIso);
  set updatedAt(DateTime v) => updatedAtIso = v.toUtc().toIso8601String();

  /// Proyección al enum de dominio. Delega al codec canónico para mantener
  /// una única fuente del mapping enum ↔ string.
  ///
  /// ⚠️ Puede lanzar [FormatException] si `estadoWire` está corrupto
  ///    (valor desconocido, vacío o casing distinto). Este comportamiento
  ///    es INTENCIONAL (fail-hard): corrupción en persistencia debe
  ///    propagarse, no enmascararse con un fallback silencioso.
  ///    NO "arreglar" esto con try/catch o defaulting a ARProjectionEstado.abierta.
  ARProjectionEstado get estadoEnum =>
      ARProjectionEstadoCodec.decode(estadoWire);
}

// ============================================================================
// MAPPERS (Domain ↔ Infra)
// ============================================================================

/// Domain → Entity.
/// Valida invariantes mínimas antes de persistir.
AccountReceivableProjectionEntity projectionToEntity(
  AccountReceivableProjection projection,
) {
  if (projection.saldoActualCop < 0) {
    throw StateError(
      'ARProjection saldoActualCop cannot be negative '
      '(entityId=${projection.entityId})',
    );
  }
  if (projection.totalRecaudadoCop < 0) {
    throw StateError(
      'ARProjection totalRecaudadoCop cannot be negative '
      '(entityId=${projection.entityId})',
    );
  }

  return AccountReceivableProjectionEntity()
    ..entityId = projection.entityId
    ..saldoActualCop = projection.saldoActualCop
    ..totalRecaudadoCop = projection.totalRecaudadoCop
    ..estadoWire = ARProjectionEstadoCodec.encode(projection.estado)
    ..lastEventHash = projection.lastEventHash
    ..updatedAtIso = projection.updatedAt.toUtc().toIso8601String();
}

/// Entity → Domain.
/// Lanza [FormatException] si el estado wire o el timestamp son inválidos.
AccountReceivableProjection projectionFromEntity(
  AccountReceivableProjectionEntity entity,
) {
  // Guard: updatedAtIso parseable
  if (DateTime.tryParse(entity.updatedAtIso) == null) {
    throw FormatException(
      'ARProjectionEntity corrupt updatedAtIso '
      '(entityId=${entity.entityId}, raw="${entity.updatedAtIso}")',
    );
  }

  // Guard: saldos no negativos (corrupción de storage)
  if (entity.saldoActualCop < 0) {
    throw FormatException(
      'ARProjectionEntity saldoActualCop negative '
      '(entityId=${entity.entityId})',
    );
  }
  if (entity.totalRecaudadoCop < 0) {
    throw FormatException(
      'ARProjectionEntity totalRecaudadoCop negative '
      '(entityId=${entity.entityId})',
    );
  }

  // Codec.decode lanza FormatException si el wire es inválido.
  final estado = ARProjectionEstadoCodec.decode(entity.estadoWire);

  return AccountReceivableProjection(
    entityId: entity.entityId,
    saldoActualCop: entity.saldoActualCop,
    totalRecaudadoCop: entity.totalRecaudadoCop,
    estado: estado,
    lastEventHash: entity.lastEventHash,
    updatedAt: DateTime.parse(entity.updatedAtIso),
  );
}
