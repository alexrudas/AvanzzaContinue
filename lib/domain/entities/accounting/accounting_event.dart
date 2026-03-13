// ============================================================================
// lib/domain/entities/accounting/accounting_event.dart
// AUDIT TRAIL — Enterprise Ultra Pro (Domain)
//
// QUÉ HACE:
// - Entidad inmutable que representa un evento contable auditable.
// - Calcula hash sha256 determinístico sobre el payload (sin campo hash).
// - Soporta encadenamiento via prevHash para integridad de secuencia.
//
// QUÉ NO HACE:
// - NO persiste datos (responsabilidad del repositorio).
// - NO depende de Flutter ni GetX.
//
// NOTAS:
// - Todos los montos en el payload deben ser int COP (§2 policy).
// - hash se auto-calcula en constructor si no se provee.
// - computeHash() es público para verificación externa.
// - verifiedFromJson() es el path RECOMENDADO para disco/red (anti-tamper).
// ============================================================================

import 'dart:convert';

import 'package:crypto/crypto.dart';

class AccountingEvent {
  AccountingEvent({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.eventType,
    required this.occurredAt,
    required this.recordedAt,
    required this.actorId,
    required Map<String, dynamic> payload,
    this.prevHash,
    String? hash,
  })  : assert(id.isNotEmpty, 'id must not be empty'),
        assert(entityType.isNotEmpty, 'entityType must not be empty'),
        assert(entityId.isNotEmpty, 'entityId must not be empty'),
        assert(eventType.isNotEmpty, 'eventType must not be empty'),
        assert(actorId.isNotEmpty, 'actorId must not be empty'),
        payload = Map<String, dynamic>.unmodifiable(payload),
        hash = hash ??
            _compute(
              id,
              entityType,
              entityId,
              eventType,
              occurredAt,
              recordedAt,
              actorId,
              payload,
              prevHash,
            );

  final String id;
  final String entityType;
  final String entityId;
  final String eventType;
  final DateTime occurredAt;
  final DateTime recordedAt;
  final String actorId;
  final Map<String, dynamic> payload;
  final String? prevHash;
  final String hash;

  // ---------------------------------------------------------------------------
  // Canonical JSON (determinismo total)
  // ---------------------------------------------------------------------------

  /// Canonicaliza [v] para serialización JSON determinística:
  /// - Map: keys ordenadas ascendente por su representación string (stable)
  ///        y valores canonicalizados recursivamente.
  /// - List: canonicaliza cada elemento en orden.
  /// - DateTime: UTC ISO8601.
  /// - Primitivos: sin cambios.
  ///
  /// Nota enterprise:
  /// - JSON exige keys string. Si llegan keys no-string, las convertimos a string
  ///   de forma determinística. Esto debe ser raro: payload debería usar String keys.
  static dynamic _canonicalize(dynamic v) {
    if (v is DateTime) return v.toUtc().toIso8601String();

    if (v is Map) {
      // Ordena por representación estable; conserva acceso al valor con key original.
      final originalKeys = v.keys.toList(growable: false)
        ..sort((a, b) => a.toString().compareTo(b.toString()));

      final out = <String, dynamic>{};
      for (final k in originalKeys) {
        out[k.toString()] = _canonicalize(v[k]);
      }
      return out;
    }

    if (v is List) {
      return [for (final e in v) _canonicalize(e)];
    }

    return v; // num/bool/String/null/otros JSON-encodables
  }

  static String _compute(
    String id,
    String entityType,
    String entityId,
    String eventType,
    DateTime occurredAt,
    DateTime recordedAt,
    String actorId,
    Map<String, dynamic> payload,
    String? prevHash,
  ) {
    final data = <String, dynamic>{
      'id': id,
      'entityType': entityType,
      'entityId': entityId,
      'eventType': eventType,
      'occurredAt': occurredAt.toUtc().toIso8601String(),
      'recordedAt': recordedAt.toUtc().toIso8601String(),
      'actorId': actorId,
      'payload': payload,
      if (prevHash != null) 'prevHash': prevHash,
    };

    final canonical = _canonicalize(data);
    final bytes = utf8.encode(jsonEncode(canonical));
    return sha256.convert(bytes).toString();
  }

  /// Recalcula el hash canónico desde el estado actual del evento.
  String computeHash() => _compute(
        id,
        entityType,
        entityId,
        eventType,
        occurredAt,
        recordedAt,
        actorId,
        payload,
        prevHash,
      );

  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'id': id,
        'entityType': entityType,
        'entityId': entityId,
        'eventType': eventType,
        'occurredAt': occurredAt.toUtc().toIso8601String(),
        'recordedAt': recordedAt.toUtc().toIso8601String(),
        'actorId': actorId,
        'payload': payload,
        if (prevHash != null) 'prevHash': prevHash,
        'hash': hash,
      };

  /// Deserializa SIN verificación de hash.
  ///
  /// Úsalo solo para flujos internos donde la integridad ya fue verificada
  /// (ej: evento recién creado en memoria).
  factory AccountingEvent.fromJson(Map<String, dynamic> json) =>
      AccountingEvent(
        id: json['id'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        eventType: json['eventType'] as String,
        occurredAt: DateTime.parse(json['occurredAt'] as String),
        recordedAt: DateTime.parse(json['recordedAt'] as String),
        actorId: json['actorId'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        prevHash: json['prevHash'] as String?,
        hash: json['hash'] as String,
      );

  /// Deserializa y verifica integridad (anti-tamper).
  ///
  /// LÉASE: este es el constructor recomendado para:
  /// - leer de disco (Isar/Hive/etc)
  /// - leer de red (Firestore/API)
  ///
  /// Si el hash almacenado no coincide con el hash canónico recomputado → throw.
  factory AccountingEvent.verifiedFromJson(Map<String, dynamic> json) {
    final incomingHash = json['hash'] as String;
    final event = AccountingEvent.fromJson(json);
    final computed = event.computeHash();

    if (computed != incomingHash) {
      throw FormatException(
        'AccountingEvent hash mismatch: stored=$incomingHash computed=$computed',
      );
    }
    return event;
  }
}
