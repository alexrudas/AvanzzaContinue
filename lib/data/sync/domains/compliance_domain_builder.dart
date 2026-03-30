// ============================================================================
// lib/data/sync/domains/compliance_domain_builder.dart
// COMPLIANCE DOMAIN BUILDER — Fragmento domains.compliance para schema v1.3.4
//
// QUÉ HACE:
// - Convierte una lista de InsurancePolicyModel al fragmento
//   `domains.compliance` del documento Firestore v1.3.4.
// - Normaliza pólizas al formato canónico del documento.
// - Ejecuta AssetPolicyMerger para obtener el estado final canónico.
// - Deriva ComplianceStatus, leadingComplianceType, daysExpired y listas
//   active/expired desde el resultado final del merger.
// - Mantiene output estable para hashing y write deduplication.
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore.
// - No genera ni persiste policyId.
// - No inventa `policyNumber` si el modelo no lo tiene.
// - No persiste estructuras internas del merger (ej: activeLogicalKey).
//
// DECISIONES ARQUITECTÓNICAS IMPORTANTES:
// 1. `policyNumber` real:
//    - Si InsurancePolicyModel aún no tiene campo real de número de póliza,
//      este builder retorna `policyNumber: null`.
//    - NO se usa `id` técnico como sustituto de negocio.
// 2. Fuente de verdad para derivados:
//    - ComplianceStatus, leadingComplianceType, daysExpired,
//      activeComplianceTypes y expiredComplianceTypes
//      SIEMPRE se calculan desde `mergeResult.merged`, no desde el input crudo.
// 3. Persistencia:
//    - `activeLogicalKey` es interno del merger y NO se persiste en Firestore.
// 4. Estabilidad:
//    - Las listas derivadas se ordenan lexicográficamente.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 3 — Asset Schema v1.3.4.
// WIRING: usado exclusivamente desde AssetDocumentBuilder.buildFullDocument().
// ============================================================================

import 'dart:convert';

import '../../models/insurance/insurance_policy_model.dart';
import '../asset_policy_merger.dart';
import '../asset_priority_engine.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RESULT
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado del builder: fragmento de dominio + valores para el motor
/// de prioridad.
final class ComplianceDomainResult {
  /// Fragmento listo para `domains.compliance` en Firestore.
  final Map<String, dynamic> domain;

  /// Estado de cumplimiento derivado del resultado final canónico.
  final ComplianceStatus complianceStatus;

  /// Wire type de la póliza más crítica.
  ///
  /// Casos:
  /// - EXPIRED: póliza más vencida
  /// - WARNING: póliza próxima a vencer con fecha más cercana
  /// - OK: 'unknown'
  final String leadingComplianceType;

  /// Días desde el vencimiento de la póliza más vencida.
  ///
  /// Solo aplica cuando complianceStatus == EXPIRED.
  final int daysExpired;

  /// Tipos activos (ordenados).
  final List<String> activeComplianceTypes;

  /// Tipos vencidos (ordenados).
  final List<String> expiredComplianceTypes;

  const ComplianceDomainResult({
    required this.domain,
    required this.complianceStatus,
    required this.leadingComplianceType,
    required this.daysExpired,
    required this.activeComplianceTypes,
    required this.expiredComplianceTypes,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// BUILDER
// ─────────────────────────────────────────────────────────────────────────────

/// Construye el fragmento `domains.compliance` del documento Firestore v1.3.4.
abstract final class ComplianceDomainBuilder {
  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Construye el fragmento de cumplimiento desde las [policies] del activo.
  ///
  /// [now] se usa para calcular expiración y proximidad de vencimiento.
  /// [domainVersion] representa la versión OCC del dominio compliance.
  static ComplianceDomainResult build({
    required List<InsurancePolicyModel> policies,
    required DateTime now,
    int domainVersion = 1,
  }) {
    final utcNow = now.toUtc();

    // 1. Normalizar input al formato esperado por el merger.
    final incomingPolicies =
        policies.map(_modelToCanonicalMap).toList(growable: false);

    // 2. Ejecutar merger.
    //
    // Importante:
    // - existing=[] porque este builder construye el fragmento final desde el
    //   estado local ya consolidado del activo.
    // - El OCC y la concurrencia remota viven en el dispatcher, no aquí.
    final mergeResult = AssetPolicyMerger.mergePolicies(
      existing: const [],
      incoming: incomingPolicies,
    );

    // 3. Trabajar SIEMPRE sobre el resultado canónico final.
    final mergedPolicies = mergeResult.merged;

    final expiredPolicies = mergedPolicies
        .where((p) => _statusOf(p) == _PolicyStatus.expired)
        .toList(growable: false);

    final warningPolicies = mergedPolicies
        .where((p) => _statusOf(p) == _PolicyStatus.warning)
        .toList(growable: false);

    final activePolicies = mergedPolicies
        .where((p) => _statusOf(p) == _PolicyStatus.active)
        .toList(growable: false);

    // 4. Derivar complianceStatus, leadingComplianceType y daysExpired.
    final ComplianceStatus complianceStatus;
    String leadingComplianceType = 'unknown';
    int daysExpired = 0;

    if (expiredPolicies.isNotEmpty) {
      complianceStatus = ComplianceStatus.expired;

      final mostExpired = _pickMostExpiredPolicy(
        expiredPolicies,
        utcNow,
      );

      leadingComplianceType =
          mostExpired?['complianceType'] as String? ?? 'unknown';
      daysExpired = _daysExpiredForPolicy(mostExpired, utcNow);
    } else if (warningPolicies.isNotEmpty) {
      complianceStatus = ComplianceStatus.warning;

      final nearestExpiring = _pickNearestExpiringPolicy(warningPolicies);

      leadingComplianceType =
          nearestExpiring?['complianceType'] as String? ?? 'unknown';
      daysExpired = 0;
    } else {
      complianceStatus = ComplianceStatus.ok;
      leadingComplianceType = 'unknown';
      daysExpired = 0;
    }

    // 5. Derivar tipos activos/vencidos desde merged final.
    final activeComplianceTypes = activePolicies
        .map((p) => p['complianceType'] as String?)
        .whereType<String>()
        .toSet()
        .toList(growable: false)
      ..sort();

    final expiredComplianceTypes = expiredPolicies
        .map((p) => p['complianceType'] as String?)
        .whereType<String>()
        .toSet()
        .toList(growable: false)
      ..sort();

    // 6. Construir fragmento de dominio.
    //
    // Nota:
    // - NO persistimos activeLogicalKey. Es detalle interno del merger.
    // - Persistimos solo lo que sirve a query/model/UI/sync.
    final domain = <String, dynamic>{
      'domainVersion': domainVersion,
      'status': complianceStatus.name.toUpperCase(),
      'leadingComplianceType': leadingComplianceType,
      'daysExpired': daysExpired,
      'activeComplianceTypes': List<String>.unmodifiable(activeComplianceTypes),
      'expiredComplianceTypes': List<String>.unmodifiable(
        expiredComplianceTypes,
      ),
      'policies': List<Map<String, dynamic>>.unmodifiable(
        mergedPolicies.map(_policyForFirestore),
      ),
    };

    return ComplianceDomainResult(
      domain: domain,
      complianceStatus: complianceStatus,
      leadingComplianceType: leadingComplianceType,
      daysExpired: daysExpired,
      activeComplianceTypes: List<String>.unmodifiable(activeComplianceTypes),
      expiredComplianceTypes: List<String>.unmodifiable(expiredComplianceTypes),
    );
  }

  // ==========================================================================
  // NORMALIZACIÓN DE MODELO
  // ==========================================================================

  /// Convierte InsurancePolicyModel al mapa canónico del dominio compliance.
  ///
  /// Reglas:
  /// - policyId: obligatorio para merger; fallback a `id` técnico solo si
  ///   policyId viene vacío/null, porque aquí hablamos de identidad de registro,
  ///   no de número de póliza.
  /// - policyNumber: solo si el modelo realmente lo tiene.
  /// - status del merger:
  ///   vigente     -> ACTIVE
  ///   vencido     -> EXPIRED
  ///   por_vencer  -> WARNING
  ///   otro        -> UNKNOWN
  static Map<String, dynamic> _modelToCanonicalMap(InsurancePolicyModel m) {
    final status = _mapEstadoToMergerStatus(m.estado);
    final policyId = _safeNonEmpty(m.policyId) ?? m.id;
    final policyNumber = _extractRealPolicyNumber(m);
    final override = _decodeOverrideJson(m.overrideJson);

    final map = <String, dynamic>{
      'policyId': policyId,
      'complianceType': m.tipo,
      'policyNumber': policyNumber,
      'status': status,
      'fechaInicio': m.fechaInicio.toUtc().toIso8601String(),
      'fechaFin': m.fechaFin.toUtc().toIso8601String(),
      'estado': m.estado,
      if (m.aseguradora.trim().isNotEmpty) 'aseguradora': m.aseguradora,
      'tarifaBase': m.tarifaBase,
      if (m.currencyCode.trim().isNotEmpty) 'currencyCode': m.currencyCode,
      if (override != null) 'override': override,
    };

    return map;
  }

  /// Convierte una póliza canónica a la forma final persistible en Firestore.
  ///
  /// Aquí puedes endurecer el contrato de salida del documento sin contaminar
  /// el modelo de entrada.
  static Map<String, dynamic> _policyForFirestore(Map<String, dynamic> p) {
    return <String, dynamic>{
      'policyId': p['policyId'],
      'complianceType': p['complianceType'],
      if (p['policyNumber'] != null) 'policyNumber': p['policyNumber'],
      'status': p['status'],
      if (p['aseguradora'] != null) 'aseguradora': p['aseguradora'],
      if (p['tarifaBase'] != null) 'tarifaBase': p['tarifaBase'],
      if (p['currencyCode'] != null) 'currencyCode': p['currencyCode'],
      if (p['fechaInicio'] != null) 'fechaInicio': p['fechaInicio'],
      if (p['fechaFin'] != null) 'fechaFin': p['fechaFin'],
      if (p['estado'] != null) 'estado': p['estado'],
      if (p['override'] != null) 'override': p['override'],
    };
  }

  // ==========================================================================
  // DERIVACIÓN DE ESTADO
  // ==========================================================================

  static _PolicyStatus _statusOf(Map<String, dynamic> p) {
    final raw = (p['status'] as String?)?.trim().toUpperCase();

    return switch (raw) {
      'ACTIVE' => _PolicyStatus.active,
      'EXPIRED' => _PolicyStatus.expired,
      'WARNING' => _PolicyStatus.warning,
      _ => _PolicyStatus.unknown,
    };
  }

  static String _mapEstadoToMergerStatus(String rawEstado) {
    final normalized = rawEstado.trim().toLowerCase();

    return switch (normalized) {
      'vigente' => 'ACTIVE',
      'vencido' => 'EXPIRED',
      'por_vencer' => 'WARNING',
      _ => 'UNKNOWN',
    };
  }

  static Map<String, dynamic>? _pickMostExpiredPolicy(
    List<Map<String, dynamic>> expiredPolicies,
    DateTime now,
  ) {
    if (expiredPolicies.isEmpty) return null;

    Map<String, dynamic>? winner;
    int maxDaysExpired = -1;

    for (final policy in expiredPolicies) {
      final days = _daysExpiredForPolicy(policy, now);

      if (days > maxDaysExpired) {
        maxDaysExpired = days;
        winner = policy;
        continue;
      }

      // Tie-break estable: complianceType lexicográfico.
      if (days == maxDaysExpired) {
        final currentType = winner?['complianceType'] as String? ?? '';
        final candidateType = policy['complianceType'] as String? ?? '';
        if (candidateType.compareTo(currentType) < 0) {
          winner = policy;
        }
      }
    }

    return winner;
  }

  static Map<String, dynamic>? _pickNearestExpiringPolicy(
    List<Map<String, dynamic>> warningPolicies,
  ) {
    if (warningPolicies.isEmpty) return null;

    final sorted = [...warningPolicies]..sort((a, b) {
        final aDate =
            AssetPriorityEngine.safeParseDate(a['fechaFin'] as String?);
        final bDate =
            AssetPriorityEngine.safeParseDate(b['fechaFin'] as String?);

        final dateCmp = aDate.compareTo(bDate);
        if (dateCmp != 0) return dateCmp;

        final aType = a['complianceType'] as String? ?? '';
        final bType = b['complianceType'] as String? ?? '';
        return aType.compareTo(bType);
      });

    return sorted.first;
  }

  static int _daysExpiredForPolicy(Map<String, dynamic>? p, DateTime now) {
    if (p == null) return 0;

    final rawFechaFin = p['fechaFin'] as String?;
    final fechaFin = AssetPriorityEngine.safeParseDate(rawFechaFin);

    if (fechaFin == DateTime.utc(0)) return 0;

    final diff = now.difference(fechaFin).inDays;
    return diff < 0 ? 0 : diff;
  }

  // ==========================================================================
  // EXTRACCIÓN DE CAMPOS OPCIONALES
  // ==========================================================================

  static String? _extractRealPolicyNumber(InsurancePolicyModel m) {
    try {
      final dynamic dyn = m;
      final dynamic value = dyn.policyNumber;

      if (value is String) {
        final normalized = value.trim();
        return normalized.isEmpty ? null : normalized;
      }
    } catch (_) {
      // El modelo aún no tiene campo real policyNumber.
      // Correcto: no inventarlo.
    }

    return null;
  }

  static Map<String, dynamic>? _decodeOverrideJson(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // overrideJson malformado: se ignora de forma tolerante.
    }

    return null;
  }

  static String? _safeNonEmpty(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INTERNOS
// ─────────────────────────────────────────────────────────────────────────────

enum _PolicyStatus {
  active,
  expired,
  warning,
  unknown,
}
