// ============================================================================
// lib/presentation/view_models/network/owner_network_vm.dart
// OWNER NETWORK VM — ViewModel para Propietarios en "Mi red operativa"
//
// QUÉ HACE:
// - Define [OwnerNetworkVm]: proyección in-memory de un propietario único
//   agregado desde los snapshots de PortfolioEntity.
// - Provee [OwnerNetworkVm.fromPortfolios]: mapper puro que deduplica,
//   normaliza y agrega una lista de PortfolioEntity en OwnerNetworkVm.
// - Expone [riskFlags] computados (multas, licencia no vigente).
//
// QUÉ NO HACE:
// - No persiste datos en Isar ni accede a Firebase.
// - No contiene lógica de UI (colores, textos de chip, etc.).
// - No asume datos inexistentes: todos los campos sensibles son nullable.
//
// PRINCIPIOS:
// - Clave de deduplicación: ownerDocument.trim().toLowerCase() — nunca el nombre.
// - Nombre visible: del portfolio con simitCheckedAt más reciente en el grupo.
// - Métrica visible en Sprint 1: "N portafolios" — no "N activos" (relación
//   no garantizada por portfolio → activos en Sprint 1).
// - Agregación O(n): suficiente para Sprint 1. Perfilar si aparece lag real.
//   No usar Isolate por defecto.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Sprint 1 módulo "Mi red operativa" — Propietarios.
// ============================================================================

import '../../../domain/entities/portfolio/portfolio_entity.dart';
import 'network_actor_vm.dart';

// ── Flags de riesgo ──────────────────────────────────────────────────────────

/// Señales de riesgo detectables en el snapshot del propietario.
enum OwnerRiskFlag {
  /// El propietario tiene multas SIMIT activas.
  hasFines,

  /// La licencia del propietario no está vigente.
  licenseNotVigent,
}

// ── OwnerNetworkVm ───────────────────────────────────────────────────────────

/// Proyección in-memory de un propietario único.
///
/// Construido exclusivamente desde [OwnerNetworkVm.fromPortfolios]
/// — no instanciar directamente en código de producción.
class OwnerNetworkVm implements NetworkActorVm {
  // ── Identidad ──────────────────────────────────────────────────────────────

  /// Documento normalizado (trim + lowercase). Clave única del propietario.
  final String document;

  /// Tipo de documento visible: CC, NIT, CE.
  final String? documentType;

  /// Nombre del propietario — del portfolio con simitCheckedAt más reciente.
  final String name;

  // ── Agregación ─────────────────────────────────────────────────────────────

  /// Número de portfolios asociados a este propietario.
  ///
  /// NOTA: Se muestra "N portafolios" en Sprint 1, no "N activos",
  /// porque la relación portfolio → activos no es garantizada por propietario.
  final int portfolioCount;

  /// Timestamp de la consulta VRC más reciente entre todos sus portfolios.
  final DateTime? lastUpdated;

  // ── Snapshot de riesgo ────────────────────────────────────────────────────

  /// Estado de la licencia del propietario. Null si nunca se consultó.
  final String? licenseStatus;

  /// True si el propietario tiene multas SIMIT activas. Null si no se consultó.
  final bool? simitHasFines;

  /// Total formateado de multas SIMIT (ej. "$320.000"). Null si no aplica.
  final String? simitFormattedTotal;

  // ── Riesgo computado ─────────────────────────────────────────────────────

  /// Señales de riesgo activas. Vacío si no hay riesgo detectado.
  final List<OwnerRiskFlag> riskFlags;

  // ── Navegación ────────────────────────────────────────────────────────────

  /// Portfolios del grupo. Usados para navegación a detalles de portafolio.
  final List<PortfolioEntity> portfolios;

  // ── Constructor ──────────────────────────────────────────────────────────

  const OwnerNetworkVm({
    required this.document,
    required this.documentType,
    required this.name,
    required this.portfolioCount,
    required this.lastUpdated,
    required this.licenseStatus,
    required this.simitHasFines,
    required this.simitFormattedTotal,
    required this.riskFlags,
    required this.portfolios,
  });

  // ── NetworkActorVm ────────────────────────────────────────────────────────

  @override
  String get actorKey => document;

  @override
  String get displayName => name;

  @override
  ActorType get actorType => ActorType.owner;

  // ── Mapper ───────────────────────────────────────────────────────────────

  /// Transforma una lista de [PortfolioEntity] en propietarios únicos deduplicados.
  ///
  /// Reglas de agrupación:
  /// 1. Filtrar portfolios con ownerDocument válido (no null, no vacío post-trim).
  /// 2. Normalizar clave: ownerDocument.trim().toLowerCase().
  /// 3. Agrupar por clave normalizada.
  /// 4. Por cada grupo: ordenar por simitCheckedAt desc, tomar el primero
  ///    para nombre y campos de estado.
  /// 5. Ordenar resultado: hasFines primero, luego por nombre asc.
  ///
  /// Documentos vacíos post-trim se descartan silenciosamente — son datos
  /// incompletos, no errores de lógica.
  static List<OwnerNetworkVm> fromPortfolios(List<PortfolioEntity> portfolios) {
    // ── 1. Filtrar portfolios con ownerDocument válido ─────────────────────
    final valid = portfolios.where((p) {
      final doc = p.ownerDocument?.trim();
      return doc != null && doc.isNotEmpty;
    }).toList();

    // ── 2. Agrupar por clave de documento normalizada ─────────────────────
    final groups = <String, List<PortfolioEntity>>{};
    for (final p in valid) {
      final key = p.ownerDocument!.trim().toLowerCase();
      groups.putIfAbsent(key, () => []).add(p);
    }

    // ── 3. Construir OwnerNetworkVm por cada grupo ─────────────────────────
    final result = <OwnerNetworkVm>[];

    for (final entry in groups.entries) {
      final group = List<PortfolioEntity>.from(entry.value);

      // Ordenar por simitCheckedAt desc — null al final.
      group.sort((a, b) {
        final ta = a.simitCheckedAt;
        final tb = b.simitCheckedAt;
        if (ta == null && tb == null) return 0;
        if (ta == null) return 1;
        if (tb == null) return -1;
        return tb.compareTo(ta);
      });

      // El portfolio más reciente es la fuente de verdad para nombre y estado.
      final first = group.first;

      // Nombre: del más reciente. Fallback si es null.
      final name = first.ownerName?.trim().isNotEmpty == true
          ? first.ownerName!.trim()
          : 'Propietario sin nombre';

      // Clave de documento original preservada (trim, con mayúsculas originales).
      final document = first.ownerDocument!.trim();
      final documentType = first.ownerDocumentType?.trim().toUpperCase();

      // Campos de estado del más reciente.
      final licenseStatus = first.licenseStatus;
      final simitHasFines = first.simitHasFines;
      final simitFormattedTotal = first.simitFormattedTotal;
      final lastUpdated = first.simitCheckedAt;

      // ── 4. Calcular riskFlags ────────────────────────────────────────────
      final flags = <OwnerRiskFlag>[];
      if (simitHasFines == true) {
        flags.add(OwnerRiskFlag.hasFines);
      }
      if (licenseStatus != null &&
          !licenseStatus.toLowerCase().contains('vig') &&
          !licenseStatus.toLowerCase().contains('activ')) {
        flags.add(OwnerRiskFlag.licenseNotVigent);
      }

      result.add(OwnerNetworkVm(
        document: document,
        documentType: documentType,
        name: name,
        portfolioCount: group.length,
        lastUpdated: lastUpdated,
        licenseStatus: licenseStatus,
        simitHasFines: simitHasFines,
        simitFormattedTotal: simitFormattedTotal,
        riskFlags: List.unmodifiable(flags),
        portfolios: List.unmodifiable(group),
      ));
    }

    // ── 5. Ordenar: hasFines primero, luego por nombre asc ─────────────────
    result.sort((a, b) {
      final aHasFines = a.riskFlags.contains(OwnerRiskFlag.hasFines) ? 0 : 1;
      final bHasFines = b.riskFlags.contains(OwnerRiskFlag.hasFines) ? 0 : 1;
      if (aHasFines != bHasFines) return aHasFines.compareTo(bHasFines);
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return result;
  }
}
