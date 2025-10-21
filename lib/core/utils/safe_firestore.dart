import 'package:cloud_firestore/cloud_firestore.dart';

/// Wrapper de seguridad para queries de Firestore
///
/// Garantiza que todas las queries tengan límites por defecto
/// para prevenir costos excesivos por queries sin límite.
///
/// Basado en las recomendaciones del documento FIRESTORE_ANALYSIS.md
class SafeFirestore {
  /// Límite por defecto para queries generales
  static const int defaultLimit = 100;

  /// Límite por defecto para chat/mensajes
  static const int defaultChatLimit = 50;

  /// Límite máximo absoluto permitido
  static const int maxLimit = 1000;

  /// Límite recomendado para scroll infinito
  static const int infiniteScrollLimit = 50;

  /// Aplica un límite seguro a una query
  ///
  /// Si [userLimit] es null, usa [defaultLimit]
  /// Si [userLimit] excede [maxLimit], lanza ArgumentError
  ///
  /// Ejemplo:
  /// ```dart
  /// Query q = db.collection('assets').where('orgId', isEqualTo: orgId);
  /// q = SafeFirestore.applyLimit(q, userLimit: 200);
  /// ```
  static Query applyLimit(Query query, {int? userLimit}) {
    final limit = userLimit ?? defaultLimit;

    if (limit > maxLimit) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of $maxLimit. '
        'Use pagination with startAfter instead of large limits.',
      );
    }

    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than 0, got $limit');
    }

    return query.limit(limit);
  }

  /// Valida que una query tenga paginación adecuada
  ///
  /// Retorna true si el límite es razonable (≤ maxLimit)
  static bool isValidLimit(int limit) {
    return limit > 0 && limit <= maxLimit;
  }

  /// Calcula el límite apropiado basado en el tipo de query
  ///
  /// Ejemplos:
  /// - chat: 50 mensajes
  /// - assets: 100 items
  /// - infiniteScroll: 50 items
  static int getLimitForQueryType(QueryType type) {
    switch (type) {
      case QueryType.chat:
      case QueryType.messages:
        return defaultChatLimit;
      case QueryType.infiniteScroll:
        return infiniteScrollLimit;
      case QueryType.general:
        return defaultLimit;
    }
  }

  /// Crea un objeto de configuración de paginación
  ///
  /// Útil para mantener consistencia en toda la app
  static PaginationConfig createConfig({
    QueryType type = QueryType.general,
    int? customLimit,
  }) {
    return PaginationConfig(
      limit: customLimit ?? getLimitForQueryType(type),
      type: type,
    );
  }
}

/// Tipos de queries para determinar límites apropiados
enum QueryType {
  /// Queries generales (assets, maintenance, etc.)
  general,

  /// Queries de chat/mensajes
  chat,

  /// Queries de mensajes/notificaciones
  messages,

  /// Queries para scroll infinito en UI
  infiniteScroll,
}

/// Configuración de paginación para queries
class PaginationConfig {
  final int limit;
  final QueryType type;

  const PaginationConfig({
    required this.limit,
    required this.type,
  });

  /// Valida que la configuración sea segura
  bool get isValid => SafeFirestore.isValidLimit(limit);

  @override
  String toString() => 'PaginationConfig(limit: $limit, type: $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationConfig &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          type == other.type;

  @override
  int get hashCode => Object.hash(limit, type);
}

/// Extensión para aplicar límites de forma fluida
extension SafeQueryExtension on Query {
  /// Aplica un límite seguro a la query
  ///
  /// Ejemplo:
  /// ```dart
  /// final query = db.collection('assets')
  ///   .where('orgId', isEqualTo: orgId)
  ///   .safeLimit(100);
  /// ```
  Query safeLimit([int? limit]) {
    return SafeFirestore.applyLimit(this, userLimit: limit);
  }
}
