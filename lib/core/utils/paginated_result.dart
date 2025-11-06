import 'package:cloud_firestore/cloud_firestore.dart';

/// Resultado paginado genérico para queries de Firestore
///
/// Incluye:
/// - Lista de items del tipo T
/// - Referencia al último documento para paginación
/// - Flag indicando si hay más páginas disponibles
///
/// Uso típico:
/// ```dart
/// final result = await remoteDs.listAssets(
///   orgId: 'org123',
///   limit: 50,
/// );
///
/// print('Items: ${result.items.length}');
/// print('Más páginas: ${result.hasMore}');
///
/// // Cargar siguiente página
/// if (result.hasMore) {
///   final nextPage = await remoteDs.listAssets(
///     orgId: 'org123',
///     limit: 50,
///     startAfter: result.lastDocument,
///   );
/// }
/// ```
class PaginatedResult<T> {
  /// Lista de items de la página actual
  final List<T> items;

  /// Último documento de la página (para usar con startAfter en siguiente query)
  final DocumentSnapshot? lastDocument;

  /// Indica si hay más páginas disponibles
  /// true si items.length == limit solicitado
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    required this.lastDocument,
    required this.hasMore,
  });

  /// Resultado vacío (sin items)
  factory PaginatedResult.empty() => const PaginatedResult(
        items: [],
        lastDocument: null,
        hasMore: false,
      );

  /// Mapea los items a otro tipo
  PaginatedResult<R> map<R>(R Function(T) transform) {
    return PaginatedResult<R>(
      items: items.map(transform).toList(),
      lastDocument: lastDocument,
      hasMore: hasMore,
    );
  }

  @override
  String toString() =>
      'PaginatedResult(items: ${items.length}, hasMore: $hasMore)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedResult<T> &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          lastDocument == other.lastDocument &&
          hasMore == other.hasMore;

  @override
  int get hashCode => Object.hash(items, lastDocument, hasMore);
}
