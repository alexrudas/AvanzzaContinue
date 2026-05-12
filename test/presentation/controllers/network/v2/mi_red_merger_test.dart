// ============================================================================
// test/presentation/controllers/network/v2/mi_red_merger_test.dart
// MI RED MERGER — Función pura: merge + dedupe + archive override.
// ============================================================================
// Cubre los 4 invariantes del contrato:
//   1. Archive override (LocalContact.isDeleted=true → oculta).
//   2. SupplierByRef se construye solo de NO archivados.
//   3. Synth ↔ Real dedupe por linkedProviderProfileId.
//   4. Real prevalece, pero supplierType local enriquece al real.
// ============================================================================

import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/models/network/network_actor_ref.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/supplier_type.dart';
import 'package:avanzza/presentation/controllers/network/v2/mi_red_merger.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_actor_summary_vm.dart';
import 'package:flutter_test/flutter_test.dart';

NetworkActorSummaryVM _realVM({
  required String ref,
  String? displayName = 'Real',
  String? providerProfileId,
  List<String> sectionKeys = const ['parts_and_supplies'],
  SupplierType? supplierType,
}) {
  final parsed = NetworkActorRef.parse(ref);
  return NetworkActorSummaryVM(
    ref: parsed,
    displayName: displayName,
    avatarRef: null,
    unresolved: false,
    categories: const [NetworkCategory.workshop],
    groupCategory: NetworkCategory.workshop,
    isTeamMember: false,
    isRestricted: false,
    restrictionReason: null,
    primaryPhoneE164: '+573001234567',
    primaryEmail: 'r@e.co',
    hasWhatsApp: true,
    relationshipState: NetworkRelationshipState.vinculada,
    providerProfileId: providerProfileId ?? (parsed.isPlatform ? parsed.id : null),
    actions: const [],
    sectionKeys: sectionKeys,
    updatedAt: DateTime.utc(2026, 5, 11, 10),
    supplierType: supplierType,
  );
}

LocalContactModel _contact({
  required String id,
  bool isDeleted = false,
  SupplierType? supplier,
  String? linkedProviderProfileId,
  String displayName = 'C',
  String? primaryPhoneE164 = '+573001112233',
  String? primaryEmail = 'c@e.co',
}) {
  final now = DateTime.utc(2026, 5, 11, 10);
  return LocalContactModel(
    id: id,
    workspaceId: 'ws-1',
    displayName: displayName,
    createdAt: now,
    updatedAt: now,
    supplierTypeWire: supplier?.wireName,
    linkedProviderProfileId: linkedProviderProfileId,
    primaryPhoneE164: primaryPhoneE164,
    primaryEmail: primaryEmail,
    isDeleted: isDeleted,
  );
}

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // 1. Archive override
  // ──────────────────────────────────────────────────────────────────────────
  group('archive override — LocalContact.isDeleted oculta', () {
    test('contact archived sin link → ref local:contact: oculto del result',
        () {
      final result = mergeMiRed(
        networkActors: [_realVM(ref: 'local:contact:X')],
        localContacts: [
          _contact(id: 'X', isDeleted: true, supplier: SupplierType.services),
        ],
      );
      expect(result.mergedActors, isEmpty);
      expect(result.archivedRefs, contains('local:contact:X'));
    });

    test(
        'contact archived con link → real platform: con ese link también '
        'se oculta', () {
      final result = mergeMiRed(
        networkActors: [
          _realVM(ref: 'platform:abc-123', providerProfileId: 'abc-123'),
        ],
        localContacts: [
          _contact(
            id: 'C',
            isDeleted: true,
            supplier: SupplierType.services,
            linkedProviderProfileId: 'abc-123',
          ),
        ],
      );
      expect(result.mergedActors, isEmpty);
      expect(result.archivedRefs, contains('platform:abc-123'));
      expect(result.archivedRefs, contains('local:contact:C'));
    });

    test('contact archived NO contribuye a supplierByRef', () {
      final result = mergeMiRed(
        networkActors: const [],
        localContacts: [
          _contact(
            id: 'C',
            isDeleted: true,
            supplier: SupplierType.services,
            linkedProviderProfileId: 'abc-123',
          ),
        ],
      );
      expect(result.supplierByRef, isEmpty,
          reason: 'contactos archived no deben aparecer en supplierByRef');
    });

    test('contacts archived NO se sintetizan (no aparecen como synth)', () {
      final result = mergeMiRed(
        networkActors: const [],
        localContacts: [
          _contact(id: 'A', isDeleted: false, supplier: SupplierType.services),
          _contact(id: 'B', isDeleted: true, supplier: SupplierType.products),
        ],
      );
      expect(result.synthCount, 1, reason: 'solo el activo se sintetiza');
      expect(result.mergedActors, hasLength(1));
      expect(result.mergedActors.first.ref.raw, 'local:contact:A');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 2. SupplierByRef desde contactos activos
  // ──────────────────────────────────────────────────────────────────────────
  group('supplierByRef construcción', () {
    test('contact con supplier + link emite ambas claves (local + platform)',
        () {
      final result = mergeMiRed(
        networkActors: const [],
        localContacts: [
          _contact(
            id: 'C',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-x',
          ),
        ],
      );
      expect(result.supplierByRef['local:contact:C'], SupplierType.services);
      expect(result.supplierByRef['platform:prov-x'], SupplierType.services);
    });

    test('contact sin supplier NO aparece en supplierByRef', () {
      final result = mergeMiRed(
        networkActors: const [],
        localContacts: [_contact(id: 'C', supplier: null)],
      );
      expect(result.supplierByRef, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 3. Synth ↔ Real dedupe
  // ──────────────────────────────────────────────────────────────────────────
  group('dedupe synth ↔ real', () {
    test(
        'LocalContact con link Y real platform en wire → solo real '
        '(synth se omite)', () {
      final result = mergeMiRed(
        networkActors: [
          _realVM(ref: 'platform:prov-x', providerProfileId: 'prov-x'),
        ],
        localContacts: [
          _contact(
            id: 'C',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-x',
          ),
        ],
      );
      expect(result.mergedActors, hasLength(1));
      expect(result.mergedActors.first.ref.raw, 'platform:prov-x',
          reason: 'real prevalece sobre synth cuando hay link match');
      expect(result.synthCount, 0);
    });

    test(
        'LocalContact con link PERO real platform NO en wire → synth visible',
        () {
      final result = mergeMiRed(
        networkActors: const [], // refresh aún no llegó
        localContacts: [
          _contact(
            id: 'C',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-x',
          ),
        ],
      );
      expect(result.mergedActors, hasLength(1));
      expect(result.mergedActors.first.ref.raw, 'local:contact:C');
      expect(result.synthCount, 1);
    });

    test('LocalContact SIN link → synth siempre (no hay platform real posible)',
        () {
      final result = mergeMiRed(
        networkActors: [_realVM(ref: 'platform:other')],
        localContacts: [
          _contact(id: 'C', supplier: SupplierType.services),
        ],
      );
      expect(result.mergedActors, hasLength(2));
      expect(result.synthCount, 1);
      final refs = result.mergedActors.map((a) => a.ref.raw).toSet();
      expect(refs, contains('platform:other'));
      expect(refs, contains('local:contact:C'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4. Real enriquecido con supplierType local
  // ──────────────────────────────────────────────────────────────────────────
  group('enrichment — real recibe supplierType local', () {
    test(
        'real platform sin supplierType + LocalContact link match → '
        'real con supplierType del contact', () {
      final result = mergeMiRed(
        networkActors: [
          _realVM(ref: 'platform:prov-x', providerProfileId: 'prov-x'),
        ],
        localContacts: [
          _contact(
            id: 'C',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-x',
          ),
        ],
      );
      expect(result.mergedActors, hasLength(1));
      expect(result.mergedActors.first.supplierType, SupplierType.services,
          reason:
              'el real debe enriquecerse con supplierType local para que el '
              'bucketizer use priority chain correctamente');
      expect(result.enrichedRealCount, 1);
    });

    test('real ya tiene supplierType → no se sobrescribe', () {
      final result = mergeMiRed(
        networkActors: [
          _realVM(
            ref: 'platform:prov-x',
            providerProfileId: 'prov-x',
            supplierType: SupplierType.products, // valor existente
          ),
        ],
        localContacts: [
          _contact(
            id: 'C',
            supplier: SupplierType.services, // local distinto
            linkedProviderProfileId: 'prov-x',
          ),
        ],
      );
      expect(result.mergedActors.first.supplierType, SupplierType.products,
          reason:
              'el valor existente en el VM gana — el merger no sobrescribe');
      expect(result.enrichedRealCount, 0);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4b. visualStableKey — synth ↔ real estable durante transición
  // ──────────────────────────────────────────────────────────────────────────
  group('visualStableKey — UI anchor estable synth ↔ real', () {
    test(
        'synth VM tiene visualStableKey=contact:<localId> '
        '(verificado por separado en synth_actor_builder_test)', () {
      // Sin networkActors, solo LocalContact con link → solo synth.
      final result = mergeMiRed(
        networkActors: const [],
        localContacts: [
          _contact(
            id: 'CX',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-target',
          ),
        ],
      );
      expect(result.mergedActors, hasLength(1));
      final synth = result.mergedActors.first;
      expect(synth.ref.raw, 'local:contact:CX');
      expect(synth.visualStableKey, 'contact:CX',
          reason: 'synth ancla key al LocalContact.id');
    });

    test(
        'real con link match → visualStableKey=contact:<localId> '
        '(MISMA key que el synth previo → no flicker)', () {
      // Real entra al wire, LocalContact ya linkado → dedupe + ancla.
      final result = mergeMiRed(
        networkActors: [
          _realVM(ref: 'platform:prov-target', providerProfileId: 'prov-target'),
        ],
        localContacts: [
          _contact(
            id: 'CX',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-target',
          ),
        ],
      );
      expect(result.mergedActors, hasLength(1));
      final real = result.mergedActors.first;
      expect(real.ref.raw, 'platform:prov-target',
          reason: 'real prevalece tras dedupe');
      expect(real.visualStableKey, 'contact:CX',
          reason: 'real con LocalContact match hereda la MISMA visualStableKey '
              'que tenía el synth — Flutter conserva el Element del tile y '
              'no destruye la UI durante la transición');
    });

    test(
        'real SIN LocalContact match → visualStableKey=ref:platform:<id> '
        '(fallback)', () {
      final result = mergeMiRed(
        networkActors: [_realVM(ref: 'platform:wire-only')],
        localContacts: const [],
      );
      expect(result.mergedActors, hasLength(1));
      expect(result.mergedActors.first.visualStableKey, 'ref:platform:wire-only',
          reason: 'sin match local, fallback al ref como key');
    });

    test(
        'identidad UI preservada: synth y real para el MISMO contact '
        'comparten visualStableKey', () {
      // Paso 1: solo LocalContact → synth.
      final phase1 = mergeMiRed(
        networkActors: const [],
        localContacts: [
          _contact(
            id: 'C-trans',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-trans',
          ),
        ],
      );
      final synthKey = phase1.mergedActors.first.visualStableKey;

      // Paso 2: real llega del wire para el mismo contact.
      final phase2 = mergeMiRed(
        networkActors: [
          _realVM(ref: 'platform:prov-trans', providerProfileId: 'prov-trans'),
        ],
        localContacts: [
          _contact(
            id: 'C-trans',
            supplier: SupplierType.services,
            linkedProviderProfileId: 'prov-trans',
          ),
        ],
      );
      final realKey = phase2.mergedActors.first.visualStableKey;

      expect(realKey, synthKey,
          reason: 'la key UI debe ser idéntica antes y después del dedupe '
              '— ese es el invariante "no flicker" durante synth → real');
      expect(synthKey, 'contact:C-trans');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 5. Empty / edge cases
  // ──────────────────────────────────────────────────────────────────────────
  group('edge cases', () {
    test('inputs vacíos → result vacío', () {
      final result = mergeMiRed(
        networkActors: const [],
        localContacts: const [],
      );
      expect(result.mergedActors, isEmpty);
      expect(result.supplierByRef, isEmpty);
      expect(result.archivedRefs, isEmpty);
      expect(result.synthCount, 0);
      expect(result.enrichedRealCount, 0);
    });

    test('solo real, sin locales → real pasa intacto', () {
      final result = mergeMiRed(
        networkActors: [_realVM(ref: 'platform:a'), _realVM(ref: 'platform:b')],
        localContacts: const [],
      );
      expect(result.mergedActors, hasLength(2));
      expect(result.synthCount, 0);
    });
  });
}
