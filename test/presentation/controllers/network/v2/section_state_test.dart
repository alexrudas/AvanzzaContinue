// ============================================================================
// test/presentation/controllers/network/v2/section_state_test.dart
// SectionState<T> — sealed disjoint + copyWith + appendPage
// ============================================================================

import 'package:avanzza/presentation/controllers/network/v2/section_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SectionState — disjuntos', () {
    test('SectionLoaded con items + nextCursor + isLoadingMore por defecto false',
        () {
      const s = SectionLoaded<int>(items: [1, 2, 3], nextCursor: 'C');
      expect(s.items, [1, 2, 3]);
      expect(s.nextCursor, 'C');
      expect(s.isLoadingMore, isFalse);
      expect(s.hasMore, isTrue);
    });

    test('SectionLoaded con nextCursor=null implica hasMore=false', () {
      const s = SectionLoaded<int>(items: [1], nextCursor: null);
      expect(s.hasMore, isFalse);
    });
  });

  group('SectionLoaded.copyWith', () {
    test('cambia isLoadingMore sin tocar items ni nextCursor', () {
      const s = SectionLoaded<int>(items: [1], nextCursor: 'A');
      final s2 = s.copyWith(isLoadingMore: true);
      expect(s2.items, [1]);
      expect(s2.nextCursor, 'A');
      expect(s2.isLoadingMore, isTrue);
    });

    test('puede setear nextCursor a null explícitamente (sentinel works)', () {
      const s = SectionLoaded<int>(items: [1], nextCursor: 'A');
      final s2 = s.copyWith(nextCursor: null);
      expect(s2.nextCursor, isNull);
      expect(s2.hasMore, isFalse);
    });

    test('omitir nextCursor lo preserva (no se vuelve null por accidente)', () {
      const s = SectionLoaded<int>(items: [1], nextCursor: 'A');
      final s2 = s.copyWith(isLoadingMore: true);
      expect(s2.nextCursor, 'A');
    });
  });

  group('SectionLoaded.appendPage', () {
    test('agrega items al final y actualiza nextCursor', () {
      const s = SectionLoaded<int>(items: [1, 2], nextCursor: 'A');
      final s2 = s.appendPage(moreItems: [3, 4], nextCursor: 'B');
      expect(s2.items, [1, 2, 3, 4]);
      expect(s2.nextCursor, 'B');
      expect(s2.isLoadingMore, isFalse);
    });

    test('appendPage con nextCursor=null marca última página', () {
      const s = SectionLoaded<int>(items: [1], nextCursor: 'A');
      final s2 = s.appendPage(moreItems: [2], nextCursor: null);
      expect(s2.hasMore, isFalse);
    });

    test('appendPage resetea isLoadingMore a false', () {
      const s = SectionLoaded<int>(
        items: [1],
        nextCursor: 'A',
        isLoadingMore: true,
      );
      final s2 = s.appendPage(moreItems: [2], nextCursor: 'B');
      expect(s2.isLoadingMore, isFalse);
    });
  });

  group('SectionState — pattern matching exhaustivo', () {
    test('switch sobre SectionState cubre todos los casos sin default', () {
      // Si se agrega un nuevo subtipo a SectionState y no se actualiza este
      // switch, el compilador no compila este test (sealed exhaustiveness).
      // Esto sirve como tripwire para evolución futura del estado.
      String label(SectionState<int> s) => switch (s) {
            SectionLoading<int>() => 'loading',
            SectionEmpty<int>() => 'empty',
            SectionLoaded<int>() => 'loaded',
            SectionForbidden<int>() => 'forbidden',
            SectionError<int>() => 'error',
          };

      expect(label(const SectionLoading<int>()), 'loading');
      expect(label(const SectionEmpty<int>()), 'empty');
      expect(label(const SectionLoaded<int>(items: [1], nextCursor: null)),
          'loaded');
      expect(label(const SectionForbidden<int>()), 'forbidden');
      expect(
          label(const SectionError<int>(error: 'boom')), 'error');
    });
  });
}
