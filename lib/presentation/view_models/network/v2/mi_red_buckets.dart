// ============================================================================
// lib/presentation/view_models/network/v2/mi_red_buckets.dart
// MI RED BUCKETS — Bucketización pura determinística para Mi Red
// ============================================================================
// QUÉ HACE:
//   - Define el enum cerrado de buckets (Equipo / Productos / Servicios).
//   - Aplica una PRIORITY CHAIN para clasificar cada actor:
//       1. `actor.supplierType`                      (intención local explícita)
//       2. `supplierByRef[actor.ref.raw]`            (lookup contextual)
//       3. `sectionKeys` mapeados a buckets          (señal wire del backend)
//       4. data debt                                 (último recurso)
//   - Regla SupplierType.mixed: aparece en AMBOS buckets (productos + servicios)
//     sin doble conteo en `totalRenderedActors` (deduplicación por ref).
//   - Función pura `bucketize(...)` que devuelve un MiRedBuckets inmutable.
//   - Logging debug-only por actor mostrando la fuente que clasificó.
//
// PRIORITY CHAIN — POR QUÉ:
//   El bug histórico era que el backend asignaba `sectionKeys=['parts_and_
//   supplies']` (default) a todos los providers nuevos, sin importar si el
//   usuario había marcado "servicios". El bucketizer solo veía sectionKeys
//   → service providers terminaban en bucket Productos. Ahora la intención
//   capturada al registrar (LocalContact.supplierType) gana sobre lo que
//   el wire pueda asignar por default.
//
// QUÉ NO HACE:
//   - No es un Get controller: función pura. Recomputo en MiRedController.
//   - No conoce labels humanos.
//   - No emite telemetry remota; debugPrint para visibilidad en desarrollo.
//   - NO oculta actores cuando se puede derivar el tipo de cualquier fuente.
//     Data debt SOLO cuando TODAS las señales fallan.
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import 'network_actor_summary_vm.dart';
import 'team_member_summary_vm.dart';

/// Buckets V1 de Mi Red. Orden de declaración == orden de render en UI.
enum MiRedBucket {
  equipo,
  productos,
  servicios,
}

/// Wire keys del backend (NETWORK_API_SCHEMA_VERSION=2) mapeadas a buckets
/// V1. Las wire keys que no aparecen aquí (`commercial_advisors`, `legal`,
/// `owners_and_tenants`, y cualquier futura) cuentan como "no V1": los
/// actores cuyas sectionKeys[] caen solo en esas quedan invisibles con un
/// warning.
const Map<String, MiRedBucket> _wireKeyToBucket = {
  'parts_and_supplies': MiRedBucket.productos,
  'services_and_workshops': MiRedBucket.servicios,
};

/// Role keys del backend que indican "membership de bootstrap" — usados para
/// la regla "ocultar Equipo si el único miembro es el admin auto-creado".
/// Ver [bucketize] para detalles.
const Set<String> _bootstrapRoleKeys = {
  'bootstrap_default_role',
};

/// Helper público: derive los buckets V1 a los que pertenece un actor.
/// Pensado para widgets (tiles) que necesitan renderizar badges secundarios
/// sin acoplarse a wire keys raw. Mantiene una sola fuente de verdad
/// (`_wireKeyToBucket`) y evita import circular vm → buckets.
///
/// PRIORITY CHAIN (igual que [bucketize]):
///   1. `actor.supplierType` — intención local explícita.
///   2. [localSupplier] — override contextual del caller.
///   3. `actor.sectionKeys` — fallback wire del backend.
///
/// Orden devuelto: orden de declaración del enum [MiRedBucket]
/// (equipo, productos, servicios). Network actors nunca devuelven equipo.
List<MiRedBucket> bucketsForActor(
  NetworkActorSummaryVM actor, {
  SupplierType? localSupplier,
}) {
  // Priority 1: supplierType ya enriquecido en el VM (single source of truth).
  if (actor.supplierType != null) {
    return _bucketsFromSupplier(actor.supplierType!);
  }
  // Priority 2: override contextual.
  if (localSupplier != null) {
    return _bucketsFromSupplier(localSupplier);
  }
  // Priority 3: wire fallback.
  final set = <MiRedBucket>{};
  for (final key in actor.sectionKeys) {
    final bucket = _wireKeyToBucket[key];
    if (bucket != null) set.add(bucket);
  }
  // Orden determinístico siguiendo MiRedBucket.values (orden de declaración).
  final ordered = MiRedBucket.values.where(set.contains).toList(growable: false);
  return ordered;
}

/// Mapping determinístico SupplierType → bucket(s). Single source of truth.
/// `mixed` produce AMBOS buckets — regla explícita documentada.
List<MiRedBucket> _bucketsFromSupplier(SupplierType supplier) {
  switch (supplier) {
    case SupplierType.products:
      return const [MiRedBucket.productos];
    case SupplierType.services:
      return const [MiRedBucket.servicios];
    case SupplierType.mixed:
      // Mixed aparece en AMBOS buckets. El conteo global deduplica por ref.
      return const [MiRedBucket.productos, MiRedBucket.servicios];
  }
}

/// Conteos de un bucket de network (Productos / Servicios).
class BucketCounts {
  /// Total de actores renderizados en este bucket.
  final int total;

  /// Subset de [total] cuyo ref kind=local o platform-unresolved.
  final int contactos;

  /// Subset de [total] cuyo ref es platform resuelto.
  final int aliados;

  const BucketCounts({
    required this.total,
    required this.contactos,
    required this.aliados,
  });

  static const empty = BucketCounts(total: 0, contactos: 0, aliados: 0);
}

/// Resultado inmutable de la bucketización. Consumido por MiRedPage via
/// el `bucketsRx` del controller.
class MiRedBuckets {
  /// Actores de network agrupados por bucket V1. Cada actor aparece en
  /// **un solo** bucket (regla blueprint). Si un bucket no tiene actores,
  /// la lista correspondiente queda vacía y NO se renderiza.
  final Map<MiRedBucket, List<NetworkActorSummaryVM>> network;

  /// Equipo viene de /v1/team — fuente DTO distinta. Lista vacía si no
  /// hay miembros.
  final List<TeamMemberSummaryVM> equipo;

  /// Counts pre-computados por bucket. Para [MiRedBucket.equipo] solo
  /// importa `total` (no se distingue contacto/aliado para equipo).
  final Map<MiRedBucket, BucketCounts> counts;

  /// Cantidad agregada de actores que NO se renderizan por deuda de
  /// data (sectionKeys vacío, no-mapeado, o ambiguo). Visible en debug
  /// UI vía MiRedPage para que la deuda no pase desapercibida.
  final int hiddenActorCount;

  const MiRedBuckets({
    required this.network,
    required this.equipo,
    required this.counts,
    required this.hiddenActorCount,
  });

  /// Total de actores que renderizan (network + equipo). Si == 0 → empty
  /// state global.
  ///
  /// DEDUPLICA por `ref.raw`: un actor con `SupplierType.mixed` aparece en
  /// AMBOS buckets pero cuenta UNA VEZ en el total. La regla evita inflar
  /// contadores visibles sin distorsionar la lista por sección.
  int get totalRenderedActors {
    final uniqueNetworkRefs = <String>{};
    for (final items in network.values) {
      for (final actor in items) {
        uniqueNetworkRefs.add(actor.ref.raw);
      }
    }
    return equipo.length + uniqueNetworkRefs.length;
  }

  bool get isEmpty => totalRenderedActors == 0;

  /// Buckets en orden fijo de render. Skip los vacíos en la UI.
  static const List<MiRedBucket> renderOrder = [
    MiRedBucket.equipo,
    MiRedBucket.productos,
    MiRedBucket.servicios,
  ];

  /// Snapshot vacío inicial (antes del primer load). Equivalente a "estado
  /// limpio sin data debt detectada".
  factory MiRedBuckets.empty() => const MiRedBuckets(
        network: {
          MiRedBucket.productos: [],
          MiRedBucket.servicios: [],
        },
        equipo: [],
        counts: {
          MiRedBucket.equipo: BucketCounts.empty,
          MiRedBucket.productos: BucketCounts.empty,
          MiRedBucket.servicios: BucketCounts.empty,
        },
        hiddenActorCount: 0,
      );
}

/// Función pura. Llamada por MiRedController._rebuildBuckets cada vez
/// que los datos de network o team cambian. NO se llama desde widgets.
///
/// PRIORITY CHAIN de clasificación (orden estricto):
///   1. `actor.supplierType`             — intención local en el VM ya enriquecido
///   2. `supplierByRef[actor.ref.raw]`   — lookup contextual (mismo cache local)
///   3. `actor.sectionKeys` mapeados     — señal wire del backend (fallback)
///   4. data debt                        — último recurso, log explícito
///
/// REGLA `SupplierType.mixed`: el actor aparece en AMBOS buckets
/// (productos + servicios). `totalRenderedActors` deduplica por ref para
/// no inflar contadores globales.
///
/// REGLA Equipo (CONGELADA — sin cambios):
///   La sección "Equipo" NO debe aparecer solo porque exista el admin
///   auto-creado por el bootstrap. Se OCULTA cuando:
///     · `teamItems.length == 1`, Y
///     · el único item tiene `displayName` null/vacío, Y
///     · sus `teamRoleKeys` están contenidas en `_bootstrapRoleKeys`.
///   Si se pasa `currentUserId` no-null y coincide con `ref.id`, también
///   se oculta (rama estricta).
///
/// [supplierByRef]: mapa opcional `actor.ref.raw → SupplierType` construido
/// por el controller desde `LocalContact` (vía `linkedProviderProfileId` o
/// id de `local:contact:*`). Default vacío preserva backward-compat.
///
/// Side effects: solo `debugPrint` para warnings. Sin telemetry remota
/// (no hay pipeline conectado en V1).
MiRedBuckets bucketize({
  required List<NetworkActorSummaryVM> networkItems,
  required List<TeamMemberSummaryVM> teamItems,
  String? currentUserId,
  Map<String, SupplierType> supplierByRef = const {},
}) {
  final report = _BucketizeReport();

  final productos = <NetworkActorSummaryVM>[];
  final servicios = <NetworkActorSummaryVM>[];

  for (final actor in networkItems) {
    final classification = _classifyActor(
      actor: actor,
      supplierByRef: supplierByRef,
    );

    if (classification == null) {
      // Data debt legítima: ningún signal pudo clasificar al actor.
      report.recordMissingBothSignals(actor);
      continue;
    }

    final buckets = classification.buckets;
    final source = classification.source;

    for (final bucket in buckets) {
      switch (bucket) {
        case MiRedBucket.productos:
          productos.add(actor);
        case MiRedBucket.servicios:
          servicios.add(actor);
        case MiRedBucket.equipo:
          // Inalcanzable: el classifier nunca produce equipo (viene de /v1/team).
          break;
      }
    }

    report.recordClassified(actor, buckets, source);
  }

  // Aplicar regla "ocultar Equipo si solo está el admin bootstrap".
  final effectiveTeamItems = _shouldHideSoloBootstrapTeam(
    teamItems: teamItems,
    currentUserId: currentUserId,
  )
      ? const <TeamMemberSummaryVM>[]
      : teamItems;

  final counts = <MiRedBucket, BucketCounts>{
    MiRedBucket.equipo: BucketCounts(
      total: effectiveTeamItems.length,
      contactos: 0,
      aliados: 0,
    ),
    MiRedBucket.productos: _countsOf(productos),
    MiRedBucket.servicios: _countsOf(servicios),
  };

  report.emitSummary();

  return MiRedBuckets(
    network: {
      MiRedBucket.productos: List.unmodifiable(productos),
      MiRedBucket.servicios: List.unmodifiable(servicios),
    },
    equipo: List.unmodifiable(effectiveTeamItems),
    counts: Map.unmodifiable(counts),
    hiddenActorCount: report.totalHidden,
  );
}

/// Devuelve true cuando el equipo debe ocultarse por contener solo al admin
/// auto-creado del bootstrap.
///
/// Casos cubiertos (cualquiera basta para ocultar):
///   A) Conservador (sin currentUserId): único miembro tiene displayName
///      vacío/null Y todos sus teamRoleKeys son bootstrap.
///   B) Estricto (con currentUserId): único miembro coincide con
///      currentUserId Y todos sus teamRoleKeys son bootstrap.
///
/// En cualquier otro caso (2+ miembros, displayName presente, roles
/// no-bootstrap), retorna false → se muestra normalmente.
bool _shouldHideSoloBootstrapTeam({
  required List<TeamMemberSummaryVM> teamItems,
  required String? currentUserId,
}) {
  if (teamItems.length != 1) return false;
  final only = teamItems.single;

  // Roles deben ser TODOS bootstrap (incluido el caso de set vacío, que
  // también consideramos "sin rol real" en bootstrap fresco).
  final allBootstrap = only.teamRoleKeys.isEmpty ||
      only.teamRoleKeys.every(_bootstrapRoleKeys.contains);
  if (!allBootstrap) return false;

  // Rama estricta: currentUserId no-null y coincide.
  if (currentUserId != null && only.ref.id == currentUserId) return true;

  // Rama conservadora: displayName vacío/null Y roles bootstrap.
  final hasRealName =
      only.displayName != null && only.displayName!.trim().isNotEmpty;
  return !hasRealName;
}

BucketCounts _countsOf(List<NetworkActorSummaryVM> items) {
  // V1: TODO actor de red cuenta como "contacto". El badge "Aliado" se
  // reserva para un futuro signal explícito del backend (actor adoptado
  // / verificado globalmente / vínculo bilateral confirmado) que el DTO
  // actual NO expone. Tener `providerProfileId` o `ref.isPlatform` no
  // basta — eso solo indica que el proveedor pasó por POST /v1/providers.
  //
  // TODO(backend): cuando el contrato exponga una señal confiable de
  // "aliado", reactivar la separación contactos/aliados aquí.
  return BucketCounts(
    total: items.length,
    contactos: items.length,
    aliados: 0,
  );
}

// ============================================================================
// _classifyActor — priority chain pura.
// ============================================================================

/// Fuente que clasificó al actor. Útil para logging y telemetría futura.
enum _ClassificationSource {
  /// `actor.supplierType` ya estaba poblado en el VM (intención local
  /// guardada al registrar el actor en este workspace).
  localOverride,

  /// El mapa `supplierByRef` resolvió el ref a un SupplierType (lookup
  /// desde LocalContact por `id` o `linkedProviderProfileId`).
  refLookup,

  /// Fallback al wire `sectionKeys` del backend.
  wireSectionKeys,
}

class _Classification {
  final List<MiRedBucket> buckets;
  final _ClassificationSource source;
  const _Classification(this.buckets, this.source);
}

/// Priority chain pura. Devuelve `null` cuando ninguna señal clasifica
/// al actor (data debt legítima).
_Classification? _classifyActor({
  required NetworkActorSummaryVM actor,
  required Map<String, SupplierType> supplierByRef,
}) {
  // ── 1. supplierType ya enriquecido en el VM (single source of truth).
  if (actor.supplierType != null) {
    return _Classification(
      _bucketsFromSupplier(actor.supplierType!),
      _ClassificationSource.localOverride,
    );
  }

  // ── 2. supplierByRef lookup (mismo cache local, diferente vehículo).
  final fromMap = supplierByRef[actor.ref.raw];
  if (fromMap != null) {
    return _Classification(
      _bucketsFromSupplier(fromMap),
      _ClassificationSource.refLookup,
    );
  }

  // ── 3. sectionKeys wire fallback. Acepta exactamente 1 bucket mapeado;
  //       wires ambiguos (≥2 buckets) o vacíos caen a data debt.
  final v1Buckets = actor.sectionKeys
      .map((wireKey) => _wireKeyToBucket[wireKey])
      .whereType<MiRedBucket>()
      .toSet()
      .toList();
  if (v1Buckets.length == 1) {
    return _Classification(v1Buckets, _ClassificationSource.wireSectionKeys);
  }

  // ── 4. Sin signals válidos. Data debt legítima.
  return null;
}

// ============================================================================
// _BucketizeReport — visibilidad de la cadena de clasificación.
//
// Por actor: 1 línea debug-only con bucket + fuente.
// Agregado: si hay al menos 1 actor escondido por data debt legítima,
// emite resumen final con el evento BUCKETIZE_DATA_DEBT (mantiene el
// nombre del evento histórico para compat con dashboards/grep).
// ============================================================================

class _BucketizeReport {
  /// Actores escondidos por falta de TODAS las señales (`MISSING_BOTH_SIGNALS`).
  int missingBothSignals = 0;

  /// Total escondido. Solo `missingBothSignals` cuenta hoy — el caso
  /// "sectionKeys ambiguo" antes generaba `LEGACY_AMBIGUOUS_BUCKET` pero
  /// ahora cae naturalmente al mismo path porque la priority chain ya
  /// resolvió todas las señales previas.
  int get totalHidden => missingBothSignals;

  void recordClassified(
    NetworkActorSummaryVM actor,
    List<MiRedBucket> buckets,
    _ClassificationSource source,
  ) {
    final bucketLabel = buckets.map((b) => b.name.toUpperCase()).join(',');
    debugPrint(
      '[MiRed][Bucketizer] ref=${actor.ref.raw} '
      'bucket=$bucketLabel '
      'source=${source.name.toUpperCase()}',
    );
  }

  void recordMissingBothSignals(NetworkActorSummaryVM actor) {
    missingBothSignals++;
    debugPrint(
      '[MiRed][Bucketizer] ref=${actor.ref.raw} '
      'name="${actor.displayName ?? "(sin nombre)"}" '
      'reason=MISSING_BOTH_SIGNALS '
      'sectionKeys=${actor.sectionKeys} '
      'supplierTypeOnVm=null supplierLookup=null',
    );
  }

  void emitSummary() {
    if (totalHidden == 0) return;
    debugPrint('[MiRed] ════════════════════════════════════════');
    debugPrint(
      '[MiRed] BUCKETIZE_DATA_DEBT '
      'missing_both_signals=$missingBothSignals '
      'total_hidden=$totalHidden',
    );
    debugPrint('[MiRed] ════════════════════════════════════════');
  }
}
