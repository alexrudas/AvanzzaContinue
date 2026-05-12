// ============================================================================
// lib/presentation/controllers/network/v2/mi_red_merger.dart
// MI RED MERGER — Función pura merge + dedupe + archive override.
// ============================================================================
//
// Recibe el snapshot remoto (actores del wire cacheados localmente) más la
// lista de LocalContacts del workspace, y emite UNA lista coherente de VMs
// + un mapa supplierByRef listo para el bucketizer.
//
// REGLAS (en orden estricto):
//
// 1. ARCHIVE OVERRIDE (verdad operacional inmediata):
//    Cualquier LocalContact con `isDeleted=true` produce un set de refs
//    "ocultas" que se EXCLUYEN del resultado, aunque sigan apareciendo en
//    el cache wire. Aplica a:
//      · ref local:contact:<contact.id> directamente.
//      · ref platform:<contact.linkedProviderProfileId> indirectamente.
//
//    Justificación: el usuario archivó → debe ver el efecto AHORA.
//    Sin esperar a que backend procese y devuelva el archive vía refresh.
//
// 2. SUPPLIER MAP:
//    De los LocalContacts NO archivados, construir mapa de overrides:
//      · local:contact:<id> → SupplierType
//      · platform:<linkedProviderProfileId> → SupplierType
//    El bucketizer usa este map (priority 2) como override sobre sectionKeys.
//
// 3. DEDUPE SYNTH ↔ REAL (sin gap):
//    Para cada LocalContact no-archivado:
//      a) Si tiene `linkedProviderProfileId=X` Y existe un actor real en el
//         wire con `ref=platform:X` → REAL gana. No se sintetiza.
//      b) Si tiene `linkedProviderProfileId` pero el real NO está en el wire
//         (aún no llegó del refresh) → SYNTH se construye con
//         ref=local:contact:<id>. Cuando el real aparezca, dedupe lo elimina.
//      c) Si NO tiene `linkedProviderProfileId` → SYNTH puro
//         (provider local sin promover).
//
// 4. SUPPLIERTYPE GANA EN BUCKETING:
//    El bucketizer (intacto) usa priority chain:
//      1. actor.supplierType (en VM) → del LocalContact
//      2. supplierByRef[ref.raw] → del map
//      3. sectionKeys → wire
//    Los REAL VMs no llevan supplierType en su VM por defecto (vienen del
//    wire). El merger los enriquece con supplierType del LocalContact match
//    si existe link válido.
//
// QUÉ NO HACE:
//   - No bucketiza (responsabilidad del caller).
//   - No emite estado UI (responsabilidad del controller).
//   - No persiste nada.
//   - No conoce streams: es función pura input → output.
// ============================================================================

import '../../../../data/models/core_common/local_contact_model.dart';
import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import '../../../view_models/network/v2/network_actor_summary_vm.dart';
import 'synth_actor_builder.dart';

/// Resultado del merge pure.
class MiRedMergeResult {
  /// Lista final de VMs lista para `bucketize()`. Contiene:
  ///   - Actores reales (del wire/cache) NO archivados.
  ///   - Actores synth de LocalContacts no archivados sin platform match.
  ///   - Reales enriquecidos con `supplierType` cuando hay LocalContact match.
  final List<NetworkActorSummaryVM> mergedActors;

  /// Map de override por `ref.raw → SupplierType`. Pasado a bucketize.
  final Map<String, SupplierType> supplierByRef;

  /// Set de refs ocultas por archive override local (telemetría / tests).
  final Set<String> archivedRefs;

  /// Conteo de actores synth en el resultado (telemetría / tests).
  final int synthCount;

  /// Conteo de actores reales hidratados con supplierType local (telemetría).
  final int enrichedRealCount;

  const MiRedMergeResult({
    required this.mergedActors,
    required this.supplierByRef,
    required this.archivedRefs,
    required this.synthCount,
    required this.enrichedRealCount,
  });

  static const empty = MiRedMergeResult(
    mergedActors: [],
    supplierByRef: {},
    archivedRefs: {},
    synthCount: 0,
    enrichedRealCount: 0,
  );
}

/// Función pura. Determinística. Sin efectos.
MiRedMergeResult mergeMiRed({
  required List<NetworkActorSummaryVM> networkActors,
  required List<LocalContactModel> localContacts,
}) {
  // ── 1. Set de archive override desde locales soft-deleted.
  final archivedRefs = <String>{};
  for (final c in localContacts) {
    if (!c.isDeleted) continue;
    archivedRefs.add('local:contact:${c.id}');
    final link = c.linkedProviderProfileId;
    if (link != null && link.isNotEmpty) {
      archivedRefs.add('platform:$link');
    }
  }

  // ── 2. Map de supplierByRef desde locales NO archivados.
  //    Y también recolectamos linked platform IDs para dedupe.
  final supplierByRef = <String, SupplierType>{};
  final platformIdToContact = <String, LocalContactModel>{};
  final activeContactsById = <String, LocalContactModel>{};

  for (final c in localContacts) {
    if (c.isDeleted) continue;
    activeContactsById[c.id] = c;
    final supplier = SupplierType.fromWire(c.supplierTypeWire);
    if (supplier != null) {
      supplierByRef['local:contact:${c.id}'] = supplier;
      final link = c.linkedProviderProfileId;
      if (link != null && link.isNotEmpty) {
        supplierByRef['platform:$link'] = supplier;
      }
    }
    final link = c.linkedProviderProfileId;
    if (link != null && link.isNotEmpty) {
      platformIdToContact[link] = c;
    }
  }

  // ── 3. Filter real actors + enrich con supplierType local cuando aplica.
  final mergedActors = <NetworkActorSummaryVM>[];
  final seenLinkedContactIds = <String>{};
  int enrichedRealCount = 0;

  for (final actor in networkActors) {
    // Archive override.
    if (archivedRefs.contains(actor.ref.raw)) continue;

    // Si el actor es platform y matchea un LocalContact linked, enriquecer
    // con supplierType local + anclar visualStableKey al contact.id.
    // El VM ya puede tener supplierType si el caller lo enriqueció antes;
    // respetamos no-null. Si null, intentamos enriquecer.
    NetworkActorSummaryVM enriched = actor;
    if (actor.ref.isPlatform) {
      final matchContact = platformIdToContact[actor.ref.id];
      if (matchContact != null) {
        seenLinkedContactIds.add(matchContact.id);
        if (actor.supplierType == null) {
          final supplier = SupplierType.fromWire(matchContact.supplierTypeWire);
          if (supplier != null) {
            enriched = enriched.withSupplierType(supplier);
            enrichedRealCount++;
          }
        }
        // ANCLA UI ESTABLE: anclar el real al mismo visualStableKey del
        // synth previo (si existió). Flutter conserva el Element durante
        // la transición synth → real.
        enriched = enriched.withVisualStableKey('contact:${matchContact.id}');
      }
    } else if (actor.ref.isLocal) {
      // Si el actor real ya viene como local:contact:<id> del wire, lo
      // contamos para dedupe synth (no debería pasar — los wire son platform —
      // pero defensivo). Anclamos su visualStableKey al contact.id.
      seenLinkedContactIds.add(actor.ref.id);
      enriched = enriched.withVisualStableKey('contact:${actor.ref.id}');
    }
    mergedActors.add(enriched);
  }

  // ── 4. Synth para LocalContacts NO archivados Y NO ya cubiertos por real.
  int synthCount = 0;
  for (final c in activeContactsById.values) {
    final link = c.linkedProviderProfileId;
    final hasRealMatch = link != null &&
        link.isNotEmpty &&
        platformIdToContact[link] != null &&
        seenLinkedContactIds.contains(c.id);
    if (hasRealMatch) {
      // Real ya está en mergedActors; skip synth (dedupe).
      continue;
    }
    // Si el contact aparece como local:contact en wire ya cubierto, skip.
    final localRefRaw = 'local:contact:${c.id}';
    if (mergedActors.any((a) => a.ref.raw == localRefRaw)) continue;

    mergedActors.add(buildSynthActorVM(c));
    synthCount++;
  }

  return MiRedMergeResult(
    mergedActors: List.unmodifiable(mergedActors),
    supplierByRef: Map.unmodifiable(supplierByRef),
    archivedRefs: Set.unmodifiable(archivedRefs),
    synthCount: synthCount,
    enrichedRealCount: enrichedRealCount,
  );
}
