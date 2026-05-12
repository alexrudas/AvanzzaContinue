// ============================================================================
// lib/presentation/controllers/network/v2/section_state.dart
// SECTION STATE — Estado explícito por sección de Mi Red Operativa
// ============================================================================
// QUÉ HACE:
//   - Define un sealed type que representa todos los estados posibles de
//     UNA sección de la pantalla (red externa o equipo interno).
//   - Sustituye el patrón "RxList + RxBool dispersos" por estados disjuntos
//     y exhaustivos:
//       · SectionLoading       — primera carga en curso.
//       · SectionLoaded        — items disponibles (carry: items, cursor,
//                                isLoadingMore para próxima página).
//       · SectionEmpty         — primera carga ok pero sin items.
//       · SectionForbidden     — 403 sobre el endpoint de esta sección. La
//                                otra sección puede estar funcionando.
//       · SectionError         — fallo recuperable (network, server, etc.).
//
// QUÉ NO HACE:
//   - No conoce repositorios ni HTTP. Es estructura inmutable.
//   - No expone "isLoadingMore" en el outer: solo en SectionLoaded. Imposible
//     representar "loadingMore=true && error" o combinaciones inválidas.
//
// PRINCIPIOS:
//   - Sealed: el compilador exige cubrir todos los estados en switches.
//   - copyWith mínimo en SectionLoaded para append + isLoadingMore toggling.
// ============================================================================

/// Estado mutuamente excluyente de una sección. Genérico en el tipo de items.
sealed class SectionState<T> {
  const SectionState();
}

/// Primera carga en curso (no hay items ni error).
class SectionLoading<T> extends SectionState<T> {
  const SectionLoading();
}

/// Carga inicial completada pero el backend retornó cero items.
/// La UI debe mostrar empty state (ej. "No tienes red operativa todavía").
class SectionEmpty<T> extends SectionState<T> {
  const SectionEmpty();
}

/// Sección con items cargados.
///
/// - [items] siempre tiene al menos 1 elemento (lista vacía es SectionEmpty).
/// - [nextCursor] null indica última página: la UI deshabilita "cargar más".
/// - [isLoadingMore] true durante una llamada loadMore en curso. Solo puede
///   ser true desde este estado (loadMore desde Loading/Empty/Error/Forbidden
///   no tiene sentido y el controller lo rechaza por construcción).
class SectionLoaded<T> extends SectionState<T> {
  final List<T> items;
  final String? nextCursor;
  final bool isLoadingMore;

  const SectionLoaded({
    required this.items,
    required this.nextCursor,
    this.isLoadingMore = false,
  });

  /// True si quedan páginas por traer.
  bool get hasMore => nextCursor != null;

  /// Construye un nuevo Loaded con campos opcionalmente sustituidos.
  /// Sentinel `_unset` distingue "no tocar" de "setear a null" para nextCursor
  /// (que es legítimamente nullable).
  SectionLoaded<T> copyWith({
    List<T>? items,
    Object? nextCursor = _unset,
    bool? isLoadingMore,
  }) =>
      SectionLoaded<T>(
        items: items ?? this.items,
        nextCursor:
            identical(nextCursor, _unset) ? this.nextCursor : nextCursor as String?,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  /// Append idempotente: agrega items al final y actualiza cursor.
  /// Mantiene `isLoadingMore=false` por defecto (el caller usualmente quiere
  /// resetearlo al concluir el loadMore).
  SectionLoaded<T> appendPage({
    required List<T> moreItems,
    required String? nextCursor,
  }) =>
      SectionLoaded<T>(
        items: [...items, ...moreItems],
        nextCursor: nextCursor,
        isLoadingMore: false,
      );
}

/// 403 sobre el endpoint de esta sección. La UI debe mostrar mensaje
/// "Sin permiso" sin afectar la otra sección. Intentar reload puede tener
/// sentido si las capabilities cambiaron (no automatizar el reintento).
class SectionForbidden<T> extends SectionState<T> {
  /// Mensaje opcional del backend (no para mostrar literal en UI; útil para
  /// telemetría / debugging).
  final String? message;
  const SectionForbidden({this.message});
}

/// Error recuperable (network, server, schemaVersion no soportado, etc.).
/// La UI muestra estado de error con botón "Reintentar".
class SectionError<T> extends SectionState<T> {
  /// Excepción tipada original. La UI puede inspeccionarla para mensajes
  /// más específicos sin perder type-safety.
  final Object error;

  /// Mensaje genérico para UI cuando no se quiera inspeccionar `error`.
  final String? message;

  const SectionError({required this.error, this.message});
}

/// Sentinel privado para `copyWith` cuando se quiere distinguir "no tocar"
/// de "setear a null" en campos legítimamente nullable.
const Object _unset = Object();
