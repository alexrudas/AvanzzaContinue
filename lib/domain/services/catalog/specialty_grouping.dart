// ============================================================================
// lib/domain/services/catalog/specialty_grouping.dart
// SPECIALTY GROUPING — helper puro de presentación para el selector.
//
// QUÉ HACE:
// - Recibe la lista plana de `Specialty` ya cargada del backend y el
//   `offerType` activo del toggle (`product` | `service` | `both`).
// - Devuelve un veredicto que la UI traduce a render:
//     * `flat`     → una sola lista (caso PRODUCT o SERVICE).
//     * `grouped`  → dos sub-listas (Productos / Servicios) con sus
//                    headers, sin mezcla.
//
// QUÉ NO HACE:
// - No ordena, deduplica ni filtra IDs — el backend ya entrega el set
//   correcto. Solo agrupa visualmente.
// - No trae HTTP, no toca controllers, no toca GetX. Función pura para
//   poder testearse sin infraestructura.
// - No persiste el offerType. La fuente sigue siendo `_selectedKind` del
//   controller (Rx<SpecialtyKind?>).
//
// PRINCIPIOS:
// - `kind == BOTH` aparece en AMBAS secciones (Productos y Servicios) cuando
//   el offerType es "Ambos": refleja fielmente la semántica del catálogo —
//   una specialty BOTH "aplica a ambas" — y la selección por id mantiene
//   coherencia (el toggle de un mismo id se ve sincronizado en las dos
//   instancias visuales).
// - El veredicto es enumerado y agnóstico de Material/Cupertino: la UI
//   decide cómo renderizar cada caso.
// ============================================================================

import '../../entities/catalog/specialty_entity.dart';

/// Modo de oferta seleccionado en el toggle de la pantalla. NO es un rol
/// ni una capability — es metadata UI para clasificar comercialmente.
enum SpecialtyOfferType {
  /// Solo productos. La lista del backend ya viene filtrada por
  /// `?type=PRODUCT`; UI renderiza plana.
  product,

  /// Solo servicios. `?type=SERVICE`. UI plana.
  service,

  /// Ambos. El backend NO filtra (sin `?type=`). UI agrupa en 2 secciones.
  both,
}

extension SpecialtyOfferTypeX on SpecialtyOfferType {
  /// Mapea al `SpecialtyKind?` que se le pasa al endpoint:
  ///   * product → SpecialtyKind.product
  ///   * service → SpecialtyKind.service
  ///   * both    → null (sin filtro server-side)
  SpecialtyKind? toQueryKind() {
    switch (this) {
      case SpecialtyOfferType.product:
        return SpecialtyKind.product;
      case SpecialtyOfferType.service:
        return SpecialtyKind.service;
      case SpecialtyOfferType.both:
        return null;
    }
  }

  /// Inverso de [toQueryKind] — útil para hidratar el toggle desde un
  /// estado existente (`null` → both).
  static SpecialtyOfferType fromKind(SpecialtyKind? kind) {
    switch (kind) {
      case SpecialtyKind.product:
        return SpecialtyOfferType.product;
      case SpecialtyKind.service:
        return SpecialtyOfferType.service;
      case SpecialtyKind.both:
      case null:
        return SpecialtyOfferType.both;
    }
  }
}

/// Veredicto del helper. El callsite pattern-matchea para renderizar.
sealed class SpecialtyGroupingResult {
  const SpecialtyGroupingResult();

  /// Total de specialties visibles tras la agrupación. Útil para logs y
  /// para el botón "Continuar (N)".
  int get visibleCount;
}

/// Lista plana — usada cuando el offerType filtra a un único kind
/// (PRODUCT o SERVICE). El backend ya entregó la lista lista.
class SpecialtyGroupingFlat extends SpecialtyGroupingResult {
  final List<Specialty> items;
  const SpecialtyGroupingFlat(this.items);

  @override
  int get visibleCount => items.length;
}

/// Dos sub-listas separadas — usada cuando el offerType es BOTH.
class SpecialtyGroupingGrouped extends SpecialtyGroupingResult {
  final List<Specialty> products;
  final List<Specialty> services;
  const SpecialtyGroupingGrouped({
    required this.products,
    required this.services,
  });

  @override
  int get visibleCount => products.length + services.length;
}

class SpecialtyGrouping {
  SpecialtyGrouping._();

  /// Agrupa [specialties] según [offerType].
  ///
  /// Reglas:
  /// - PRODUCT / SERVICE → `SpecialtyGroupingFlat` con la lista tal cual
  ///   (el backend ya filtró). Defensa en profundidad: si llegan items de
  ///   otro kind por error, se filtran aquí también.
  /// - BOTH → `SpecialtyGroupingGrouped`:
  ///     * `products` = items con `kind == PRODUCT` o `kind == BOTH`.
  ///     * `services` = items con `kind == SERVICE` o `kind == BOTH`.
  ///   Una specialty `BOTH` aparece en ambas listas (intencional — refleja
  ///   la semántica del catálogo: "aplica a ambas").
  ///
  /// El orden dentro de cada lista se preserva tal como vino del backend.
  static SpecialtyGroupingResult group({
    required List<Specialty> specialties,
    required SpecialtyOfferType offerType,
  }) {
    switch (offerType) {
      case SpecialtyOfferType.product:
        return SpecialtyGroupingFlat(
          [for (final s in specialties) if (s.kind == SpecialtyKind.product || s.kind == SpecialtyKind.both) s],
        );
      case SpecialtyOfferType.service:
        return SpecialtyGroupingFlat(
          [for (final s in specialties) if (s.kind == SpecialtyKind.service || s.kind == SpecialtyKind.both) s],
        );
      case SpecialtyOfferType.both:
        final products = <Specialty>[];
        final services = <Specialty>[];
        for (final s in specialties) {
          switch (s.kind) {
            case SpecialtyKind.product:
              products.add(s);
              break;
            case SpecialtyKind.service:
              services.add(s);
              break;
            case SpecialtyKind.both:
              products.add(s);
              services.add(s);
              break;
          }
        }
        return SpecialtyGroupingGrouped(
          products: products,
          services: services,
        );
    }
  }
}
