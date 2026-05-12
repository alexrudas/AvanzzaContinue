// ============================================================================
// test/presentation/view_models/network/v2/mi_red_buckets_supplier_priority_test.dart
// PRIORITY CHAIN del bucketizer determinístico — Etapa 3 fix Mi Red.
// ============================================================================
// Cubre los 9 tests obligatorios:
//   1. local services → Servicios
//   2. local products → Productos
//   3. local mixed → ambos buckets
//   4. mixed no duplica totalRenderedActors
//   5. sectionKeys services fallback → Servicios
//   6. sectionKeys products fallback → Productos
//   7. sin supplierType + sectionKeys vacío → data debt
//   8. conflicto local services + wire products → gana services
//   9. bucketsForActor con local services → solo Servicios
// ============================================================================

import 'package:avanzza/data/models/network/network_actor_ref.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/supplier_type.dart';
import 'package:avanzza/presentation/view_models/network/v2/mi_red_buckets.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_action_vm.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_actor_summary_vm.dart';
import 'package:flutter_test/flutter_test.dart';

NetworkActorSummaryVM _vm({
  required String ref,
  String? displayName = 'Actor',
  List<String> sectionKeys = const [],
  SupplierType? supplierType,
  NetworkCategory primaryCategory = NetworkCategory.provider,
  NetworkRelationshipState relationshipState =
      NetworkRelationshipState.vinculada,
}) {
  final parsedRef = NetworkActorRef.parse(ref);
  return NetworkActorSummaryVM(
    ref: parsedRef,
    displayName: displayName,
    avatarRef: null,
    unresolved: false,
    categories: [primaryCategory],
    groupCategory: primaryCategory,
    isTeamMember: false,
    isRestricted: false,
    restrictionReason: null,
    primaryPhoneE164: '+573001234567',
    primaryEmail: 'x@y.co',
    hasWhatsApp: true,
    relationshipState: relationshipState,
    providerProfileId: parsedRef.isPlatform ? parsedRef.id : null,
    actions: const <NetworkActionVM>[],
    sectionKeys: sectionKeys,
    updatedAt: DateTime.utc(2026, 5, 11, 10),
    supplierType: supplierType,
  );
}

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // 1. local services → Servicios
  // ──────────────────────────────────────────────────────────────────────────
  test('1. actor.supplierType=services → bucket Servicios (local override)',
      () {
    final actor = _vm(
      ref: 'platform:abc',
      supplierType: SupplierType.services,
      sectionKeys: const [], // wire vacío — no debe importar.
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.network[MiRedBucket.servicios], hasLength(1));
    expect(b.network[MiRedBucket.servicios]!.first.ref.raw, 'platform:abc');
    expect(b.network[MiRedBucket.productos], isEmpty);
    expect(b.hiddenActorCount, 0);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 2. local products → Productos
  // ──────────────────────────────────────────────────────────────────────────
  test('2. actor.supplierType=products → bucket Productos (local override)',
      () {
    final actor = _vm(
      ref: 'platform:abc',
      supplierType: SupplierType.products,
      sectionKeys: const [],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.network[MiRedBucket.productos], hasLength(1));
    expect(b.network[MiRedBucket.servicios], isEmpty);
    expect(b.hiddenActorCount, 0);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 3. local mixed → ambos buckets
  // ──────────────────────────────────────────────────────────────────────────
  test('3. actor.supplierType=mixed → AMBOS buckets (regla explícita)', () {
    final actor = _vm(
      ref: 'platform:abc',
      supplierType: SupplierType.mixed,
      sectionKeys: const [],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.network[MiRedBucket.productos], hasLength(1));
    expect(b.network[MiRedBucket.servicios], hasLength(1));
    expect(b.network[MiRedBucket.productos]!.first.ref.raw, 'platform:abc');
    expect(b.network[MiRedBucket.servicios]!.first.ref.raw, 'platform:abc');
    expect(b.hiddenActorCount, 0);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4. mixed no duplica totalRenderedActors
  // ──────────────────────────────────────────────────────────────────────────
  test('4. mixed cuenta UNA vez en totalRenderedActors (deduplicación por ref)',
      () {
    final mixed = _vm(
      ref: 'platform:mix',
      supplierType: SupplierType.mixed,
    );
    final solo = _vm(
      ref: 'platform:solo',
      supplierType: SupplierType.products,
    );
    final b = bucketize(networkItems: [mixed, solo], teamItems: const []);

    // mixed está en 2 buckets, solo en 1 → suma cruda sería 3.
    // Pero la deduplicación por ref → mixed cuenta 1, solo cuenta 1 → total 2.
    expect(b.totalRenderedActors, 2,
        reason: 'mixed NO debe contar doble en el total global');
    // Verificación cruzada: las listas individuales sí muestran 2+1=3 ítems.
    final crudo = b.network[MiRedBucket.productos]!.length +
        b.network[MiRedBucket.servicios]!.length;
    expect(crudo, 3);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 5. sectionKeys services fallback → Servicios
  // ──────────────────────────────────────────────────────────────────────────
  test(
      '5. sin supplierType + sectionKeys=[services_and_workshops] → Servicios',
      () {
    final actor = _vm(
      ref: 'platform:wire-only',
      supplierType: null, // sin override local.
      sectionKeys: const ['services_and_workshops'],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.network[MiRedBucket.servicios], hasLength(1));
    expect(b.network[MiRedBucket.productos], isEmpty);
    expect(b.hiddenActorCount, 0);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 6. sectionKeys products fallback → Productos
  // ──────────────────────────────────────────────────────────────────────────
  test('6. sin supplierType + sectionKeys=[parts_and_supplies] → Productos',
      () {
    final actor = _vm(
      ref: 'platform:wire-prod',
      supplierType: null,
      sectionKeys: const ['parts_and_supplies'],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.network[MiRedBucket.productos], hasLength(1));
    expect(b.network[MiRedBucket.servicios], isEmpty);
    expect(b.hiddenActorCount, 0);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 7. sin supplierType + sectionKeys vacío → data debt
  // ──────────────────────────────────────────────────────────────────────────
  test('7. sin supplierType + sectionKeys vacío → data debt legítimo', () {
    final actor = _vm(
      ref: 'platform:huerfano',
      supplierType: null,
      sectionKeys: const [],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.hiddenActorCount, 1);
    expect(b.network[MiRedBucket.productos], isEmpty);
    expect(b.network[MiRedBucket.servicios], isEmpty);
    expect(b.totalRenderedActors, 0);
  });

  test(
      '7b. sin supplierType + sectionKeys solo con keys no-mapeadas → '
      'data debt (legal/owners_and_tenants/commercial_advisors)', () {
    final actor = _vm(
      ref: 'platform:legal-only',
      supplierType: null,
      sectionKeys: const ['legal', 'owners_and_tenants'],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.hiddenActorCount, 1);
    expect(b.totalRenderedActors, 0);
  });

  test(
      '7c. sin supplierType + sectionKeys ambiguo (>1 mapeado) → data debt',
      () {
    final actor = _vm(
      ref: 'platform:ambig',
      supplierType: null,
      sectionKeys: const ['parts_and_supplies', 'services_and_workshops'],
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.hiddenActorCount, 1,
        reason: 'wires ambiguos sin local override caen a data debt');
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 8. conflicto local services + wire products → gana services
  // ──────────────────────────────────────────────────────────────────────────
  test(
      '8. supplierType=services + sectionKeys=[parts_and_supplies] → '
      'gana LOCAL OVERRIDE (Servicios)', () {
    final actor = _vm(
      ref: 'platform:conflict',
      supplierType: SupplierType.services, // local dice servicios
      sectionKeys: const ['parts_and_supplies'], // wire dice productos
    );
    final b = bucketize(networkItems: [actor], teamItems: const []);

    expect(b.network[MiRedBucket.servicios], hasLength(1),
        reason: 'local supplierType debe ganar sobre sectionKeys del wire');
    expect(b.network[MiRedBucket.productos], isEmpty);
    expect(b.hiddenActorCount, 0);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 9. bucketsForActor con local services → solo Servicios
  // ──────────────────────────────────────────────────────────────────────────
  test('9. bucketsForActor con supplierType=services → [servicios]', () {
    final actor = _vm(
      ref: 'platform:badge',
      supplierType: SupplierType.services,
      sectionKeys: const ['parts_and_supplies'], // intencionalmente conflictivo
    );
    final out = bucketsForActor(actor);
    expect(out, [MiRedBucket.servicios]);
  });

  test('9b. bucketsForActor con mixed → [productos, servicios] en orden enum',
      () {
    final actor = _vm(
      ref: 'platform:badge-mix',
      supplierType: SupplierType.mixed,
    );
    final out = bucketsForActor(actor);
    expect(out, [MiRedBucket.productos, MiRedBucket.servicios]);
  });

  test(
      '9c. bucketsForActor con localSupplier param override (sin tocar VM)',
      () {
    final actor = _vm(
      ref: 'platform:badge-override',
      supplierType: null,
      sectionKeys: const ['parts_and_supplies'], // wire diría productos
    );
    final out = bucketsForActor(actor, localSupplier: SupplierType.services);
    expect(out, [MiRedBucket.servicios],
        reason: 'el parámetro localSupplier debe ganar sobre sectionKeys');
  });

  test('9d. bucketsForActor sin signals → fallback al wire', () {
    final actor = _vm(
      ref: 'platform:badge-wire',
      supplierType: null,
      sectionKeys: const ['parts_and_supplies'],
    );
    final out = bucketsForActor(actor);
    expect(out, [MiRedBucket.productos]);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Tests adicionales del supplierByRef map (etapa 4 prep)
  // ──────────────────────────────────────────────────────────────────────────
  group('supplierByRef — segunda fuente de prioridad', () {
    test('lookup gana sobre sectionKeys cuando VM no tiene supplierType', () {
      final actor = _vm(
        ref: 'platform:from-map',
        supplierType: null,
        sectionKeys: const ['parts_and_supplies'], // wire dice productos
      );
      final b = bucketize(
        networkItems: [actor],
        teamItems: const [],
        supplierByRef: const {'platform:from-map': SupplierType.services},
      );
      expect(b.network[MiRedBucket.servicios], hasLength(1),
          reason: 'supplierByRef debe ganar sobre wire sectionKeys');
      expect(b.network[MiRedBucket.productos], isEmpty);
    });

    test('VM supplierType gana sobre supplierByRef cuando ambos están seteados',
        () {
      // Escenario: VM ya enriquecido (más cercano al origen) + map (resolución
      // posterior). El VM gana por estar más cercano al productor de la data.
      final actor = _vm(
        ref: 'platform:double',
        supplierType: SupplierType.services,
      );
      final b = bucketize(
        networkItems: [actor],
        teamItems: const [],
        supplierByRef: const {'platform:double': SupplierType.products},
      );
      expect(b.network[MiRedBucket.servicios], hasLength(1));
      expect(b.network[MiRedBucket.productos], isEmpty);
    });

    test('lookup mixto desde supplierByRef → ambos buckets', () {
      final actor = _vm(
        ref: 'platform:mixto-map',
        supplierType: null,
        sectionKeys: const [],
      );
      final b = bucketize(
        networkItems: [actor],
        teamItems: const [],
        supplierByRef: const {'platform:mixto-map': SupplierType.mixed},
      );
      expect(b.network[MiRedBucket.productos], hasLength(1));
      expect(b.network[MiRedBucket.servicios], hasLength(1));
      expect(b.totalRenderedActors, 1);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Sanity: estado vacío
  // ──────────────────────────────────────────────────────────────────────────
  test('Sin actores → totalRenderedActors=0, isEmpty=true', () {
    final b = bucketize(networkItems: const [], teamItems: const []);
    expect(b.totalRenderedActors, 0);
    expect(b.isEmpty, isTrue);
    expect(b.hiddenActorCount, 0);
  });
}
