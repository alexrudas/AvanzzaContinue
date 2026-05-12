// ============================================================================
// lib/data/models/network/network_envelope.dart
// NETWORK ENVELOPES — Wrappers de respuesta para Mi Red Operativa v1
// ============================================================================
// QUÉ HACE:
//   - Define los envelopes para los 4 endpoints del contrato:
//       · NetworkPageEnvelope<T>  — para /v1/network y /v1/team (listas).
//       · NetworkSummaryEnvelope  — para /v1/network/categories/summary.
//       · TeamSummaryEnvelope     — para /v1/team/summary.
//   - Valida `schemaVersion == 1` en cada parse: si llega otro valor, lanza
//     [UnsupportedSchemaVersionException].
//
// QUÉ NO HACE:
//   - No define los items: cada caller pasa su propio `parseItem` para
//     deserializar T (NetworkActorSummaryDto / TeamMemberSummaryDto).
//
// POLÍTICA DE schemaVersion (espejo del contrato backend congelado):
//   - BUMP solo ante breaking changes: remover campo, cambiar tipo,
//     cambiar semántica, recortar enum cerrado.
//   - NO se bumpea ante: agregar campo opcional, ampliar nullable,
//     agregar endpoint, agregar enum value cubierto por "other".
//
// CONTRATO sobre nextCursor / items:
//   - nextCursor === null ⇒ última página (no seguir paginando).
//   - items vacío + nextCursor null es válido (lista vacía con cero páginas).
//   - Cursor es opaco; el cliente lo retransmite tal cual sin interpretarlo.
// ============================================================================

import 'unsupported_schema_version_exception.dart';

/// Schema version actual de los endpoints `/v1/network*`. Backend lo emite
/// en cada response. Ver `src/modules/network/constants/network-capabilities.ts`
/// (NETWORK_API_SCHEMA_VERSION) en avanzza-core-api para la política de bump.
///
/// Evoluciona INDEPENDIENTE de [kTeamSchemaVersion] porque el shape de
/// `NetworkActorSummaryDto` cambia distinto al de `TeamMemberSummaryDto`.
const int kNetworkSchemaVersion = 2;

/// Schema version actual de los endpoints `/v1/team*`.
const int kTeamSchemaVersion = 1;

/// Valida schemaVersion contra la versión esperada del endpoint y lanza si
/// es incompatible. El caller pasa la versión esperada (network vs team)
/// para evitar acoplar ambos endpoints a una única constante.
void _assertSchemaVersion({
  required Map<String, dynamic> json,
  required String endpoint,
  required int expected,
}) {
  final raw = json['schemaVersion'];
  if (raw is! int) {
    throw FormatException(
      'Envelope de $endpoint sin schemaVersion entero (recibido: $raw)',
    );
  }
  if (raw != expected) {
    throw UnsupportedSchemaVersionException(
      received: raw,
      supported: [expected],
      endpoint: endpoint,
    );
  }
}

/// Envelope paginado genérico de Mi Red Operativa v1.
///
/// Usado por:
///   - GET /v1/network → NetworkPageEnvelope<NetworkActorSummaryDto>
///   - GET /v1/team    → NetworkPageEnvelope<TeamMemberSummaryDto>
class NetworkPageEnvelope<T> {
  final int schemaVersion;
  final List<T> items;

  /// `null` indica última página. No seguir pidiendo más.
  final String? nextCursor;

  /// Hora del servidor en el momento de la respuesta (ISO-8601).
  /// Útil para detección de clock skew y TTLs locales.
  final DateTime serverTime;

  const NetworkPageEnvelope({
    required this.schemaVersion,
    required this.items,
    required this.nextCursor,
    required this.serverTime,
  });

  /// Parsea el envelope validando schemaVersion. `parseItem` deserializa T.
  /// El caller pasa `expectedSchemaVersion` (network o team) para que la
  /// validación sea independiente por endpoint.
  factory NetworkPageEnvelope.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic>) parseItem,
    required String endpoint,
    required int expectedSchemaVersion,
  }) {
    _assertSchemaVersion(
      json: json,
      endpoint: endpoint,
      expected: expectedSchemaVersion,
    );

    final itemsRaw = (json['items'] as List<dynamic>?) ?? const [];
    final items = itemsRaw
        .map((e) => parseItem(e as Map<String, dynamic>))
        .toList(growable: false);

    return NetworkPageEnvelope<T>(
      schemaVersion: json['schemaVersion'] as int,
      items: items,
      nextCursor: json['nextCursor'] as String?,
      serverTime: DateTime.parse(json['serverTime'] as String),
    );
  }

  /// True cuando esta es la última página.
  bool get isLastPage => nextCursor == null;
}

/// Envelope de GET /v1/network/categories/summary.
class NetworkCategoriesSummaryEnvelope {
  final int schemaVersion;
  final int externalActiveCount;
  final DateTime serverTime;

  const NetworkCategoriesSummaryEnvelope({
    required this.schemaVersion,
    required this.externalActiveCount,
    required this.serverTime,
  });

  factory NetworkCategoriesSummaryEnvelope.fromJson(
    Map<String, dynamic> json, {
    String endpoint = 'GET /v1/network/categories/summary',
  }) {
    _assertSchemaVersion(
      json: json,
      endpoint: endpoint,
      expected: kNetworkSchemaVersion,
    );
    return NetworkCategoriesSummaryEnvelope(
      schemaVersion: json['schemaVersion'] as int,
      externalActiveCount: json['externalActiveCount'] as int,
      serverTime: DateTime.parse(json['serverTime'] as String),
    );
  }
}

/// Envelope de GET /v1/team/summary.
class TeamSummaryEnvelope {
  final int schemaVersion;
  final int activeCount;
  final DateTime serverTime;

  const TeamSummaryEnvelope({
    required this.schemaVersion,
    required this.activeCount,
    required this.serverTime,
  });

  factory TeamSummaryEnvelope.fromJson(
    Map<String, dynamic> json, {
    String endpoint = 'GET /v1/team/summary',
  }) {
    _assertSchemaVersion(
      json: json,
      endpoint: endpoint,
      expected: kTeamSchemaVersion,
    );
    return TeamSummaryEnvelope(
      schemaVersion: json['schemaVersion'] as int,
      activeCount: json['activeCount'] as int,
      serverTime: DateTime.parse(json['serverTime'] as String),
    );
  }
}
