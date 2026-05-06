// ============================================================================
// test/domain/services/catalog/specialty_grouping_test.dart
//
// QUÉ VALIDA:
// - PRODUCT muestra solo specialties de kind=PRODUCT (con BOTH como
//   complemento informativo).
// - SERVICE muestra solo kind=SERVICE (con BOTH).
// - BOTH muestra ambas secciones separadas (sin lista plana mezclada).
// - Una specialty kind=BOTH aparece en ambas secciones cuando offerType=BOTH.
// - Mapeo SpecialtyOfferType ↔ SpecialtyKind? para el query backend.
// - Orden interno preservado tal como vino del backend.
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/domain/entities/catalog/specialty_entity.dart';
import 'package:avanzza/domain/services/catalog/specialty_grouping.dart';

Specialty _s(String id, SpecialtyKind kind) =>
    Specialty(id: id, name: id, kind: kind);

void main() {
  // Dataset compartido — orden definido para verificar preservación.
  final dataset = <Specialty>[
    _s('p1', SpecialtyKind.product),
    _s('s1', SpecialtyKind.service),
    _s('b1', SpecialtyKind.both),
    _s('p2', SpecialtyKind.product),
    _s('s2', SpecialtyKind.service),
  ];

  group('SpecialtyOfferType ↔ SpecialtyKind?', () {
    test('toQueryKind() mapea cada offerType al SpecialtyKind? canónico', () {
      expect(SpecialtyOfferType.product.toQueryKind(), SpecialtyKind.product);
      expect(SpecialtyOfferType.service.toQueryKind(), SpecialtyKind.service);
      expect(SpecialtyOfferType.both.toQueryKind(), isNull);
    });

    test('fromKind(null) → both (default canónico)', () {
      expect(SpecialtyOfferTypeX.fromKind(null), SpecialtyOfferType.both);
      expect(
        SpecialtyOfferTypeX.fromKind(SpecialtyKind.product),
        SpecialtyOfferType.product,
      );
      expect(
        SpecialtyOfferTypeX.fromKind(SpecialtyKind.service),
        SpecialtyOfferType.service,
      );
      // Edge: SpecialtyKind.both como query no es canónico (backend usa
      // null para "todos"), pero el helper lo trata como `both` para que
      // el toggle UI quede consistente.
      expect(
        SpecialtyOfferTypeX.fromKind(SpecialtyKind.both),
        SpecialtyOfferType.both,
      );
    });
  });

  group('SpecialtyGrouping.group — PRODUCT', () {
    test('PRODUCT devuelve flat con product + both, sin services', () {
      final result = SpecialtyGrouping.group(
        specialties: dataset,
        offerType: SpecialtyOfferType.product,
      );
      expect(result, isA<SpecialtyGroupingFlat>());
      final flat = result as SpecialtyGroupingFlat;
      expect(flat.items.map((e) => e.id).toList(), ['p1', 'b1', 'p2']);
      // Defensa: si el backend devuelve algo de otro kind por error, NO
      // debe colarse en flat de PRODUCT.
      expect(flat.items.any((e) => e.kind == SpecialtyKind.service), isFalse);
      expect(flat.visibleCount, 3);
    });
  });

  group('SpecialtyGrouping.group — SERVICE', () {
    test('SERVICE devuelve flat con service + both, sin products', () {
      final result = SpecialtyGrouping.group(
        specialties: dataset,
        offerType: SpecialtyOfferType.service,
      );
      expect(result, isA<SpecialtyGroupingFlat>());
      final flat = result as SpecialtyGroupingFlat;
      expect(flat.items.map((e) => e.id).toList(), ['s1', 'b1', 's2']);
      expect(flat.items.any((e) => e.kind == SpecialtyKind.product), isFalse);
      expect(flat.visibleCount, 3);
    });
  });

  group('SpecialtyGrouping.group — BOTH (secciones separadas)', () {
    test('BOTH devuelve grouped con productos y servicios separados', () {
      final result = SpecialtyGrouping.group(
        specialties: dataset,
        offerType: SpecialtyOfferType.both,
      );
      expect(result, isA<SpecialtyGroupingGrouped>());
      final grouped = result as SpecialtyGroupingGrouped;

      // Productos: PRODUCT + BOTH (orden preservado).
      expect(grouped.products.map((e) => e.id).toList(), ['p1', 'b1', 'p2']);
      // Servicios: SERVICE + BOTH (orden preservado).
      expect(grouped.services.map((e) => e.id).toList(), ['s1', 'b1', 's2']);
      // visibleCount considera duplicados por sección (b1 cuenta 2 veces).
      expect(grouped.visibleCount, 6);
    });

    test('una specialty kind=BOTH aparece en AMBAS secciones', () {
      final onlyBoth = [_s('b1', SpecialtyKind.both)];
      final result = SpecialtyGrouping.group(
        specialties: onlyBoth,
        offerType: SpecialtyOfferType.both,
      ) as SpecialtyGroupingGrouped;
      expect(result.products.map((e) => e.id).toList(), ['b1']);
      expect(result.services.map((e) => e.id).toList(), ['b1']);
    });

    test('BOTH con dataset vacío produce ambas secciones vacías', () {
      final result = SpecialtyGrouping.group(
        specialties: const [],
        offerType: SpecialtyOfferType.both,
      ) as SpecialtyGroupingGrouped;
      expect(result.products, isEmpty);
      expect(result.services, isEmpty);
      expect(result.visibleCount, 0);
    });

    test('BOTH NO mezcla: ningún producto puro aparece en services', () {
      final result = SpecialtyGrouping.group(
        specialties: dataset,
        offerType: SpecialtyOfferType.both,
      ) as SpecialtyGroupingGrouped;
      // Regla del prompt: "lista plana combinada sin separación" está prohibida.
      final productIds =
          dataset.where((e) => e.kind == SpecialtyKind.product).map((e) => e.id);
      for (final id in productIds) {
        expect(result.services.any((e) => e.id == id), isFalse,
            reason: 'Specialty PRODUCT puro "$id" no debe estar en services.');
      }
      final serviceIds =
          dataset.where((e) => e.kind == SpecialtyKind.service).map((e) => e.id);
      for (final id in serviceIds) {
        expect(result.products.any((e) => e.id == id), isFalse,
            reason: 'Specialty SERVICE puro "$id" no debe estar en products.');
      }
    });
  });
}
