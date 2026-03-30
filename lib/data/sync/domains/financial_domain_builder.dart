// ============================================================================
// lib/data/sync/domains/financial_domain_builder.dart
// FINANCIAL DOMAIN BUILDER — Enterprise 10/10 (v1.3.4)
//
// QUÉ HACE:
// - Construye el fragmento `domains.financial` para Firestore.
// - Define un contrato financiero escalable desde el día 1.
// - Soporta evolución futura hacia ledger/event sourcing.
//
// QUÉ NO HACE:
// - No calcula contabilidad avanzada.
// - No accede a Isar ni Firestore.
// - No mezcla lógica de negocio externa.
//
// PRINCIPIOS:
// - Determinístico (hash-safe)
// - Forward-compatible (no rompe cuando escale)
// - Contract-first design
//
// STATUS MODEL:
// - NO_DATA  → sin información financiera
// - ACTIVE   → flujo positivo o balanceado
// - AT_RISK  → costos altos vs ingresos
// - LOSS     → pérdida neta
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 3 — Asset Schema v1.3.4.
// ============================================================================

// ─────────────────────────────────────────────────────────────────────────────
// RESULT
// ─────────────────────────────────────────────────────────────────────────────

final class FinancialDomainResult {
  final Map<String, dynamic> domain;

  /// Estado financiero derivado. Igual a domain['status']. Tipado para
  /// evitar acoplamiento del caller a la estructura interna del domain Map.
  final String status;

  const FinancialDomainResult({required this.domain, required this.status});
}

// ─────────────────────────────────────────────────────────────────────────────
// BUILDER
// ─────────────────────────────────────────────────────────────────────────────

abstract final class FinancialDomainBuilder {
  /// Umbral de margen neto por debajo del cual el activo se considera AT_RISK.
  ///
  /// 0.10 → margen ≤ 10% de ingresos → AT_RISK.
  static const _atRiskMarginThreshold = 0.10;

  static FinancialDomainResult build({
    int domainVersion = 1,

    // 🔹 Inputs opcionales (futuro)
    double? totalRevenue,
    double? totalCosts,
    String currencyCode = 'COP',
  }) {
    assert(
      totalRevenue == null || totalRevenue >= 0,
      'totalRevenue no puede ser negativo: $totalRevenue',
    );
    assert(
      totalCosts == null || totalCosts >= 0,
      'totalCosts no puede ser negativo: $totalCosts',
    );

    // =========================================================================
    // 1. NORMALIZACIÓN (determinismo)
    // =========================================================================

    final revenue = (totalRevenue ?? 0).toDouble();
    final costs = (totalCosts ?? 0).toDouble();
    final net = revenue - costs;

    // currencyCode normalizado: trim + toUpperCase; fallback 'COP' si vacío.
    final normalizedCurrency = currencyCode.trim().toUpperCase();
    final effectiveCurrency =
        normalizedCurrency.isEmpty ? 'COP' : normalizedCurrency;

    // =========================================================================
    // 2. FLAGS BASE
    // =========================================================================

    final hasRevenue = revenue > 0;
    final hasCosts = costs > 0;

    // =========================================================================
    // 3. STATUS ENGINE (simple pero sólido)
    // =========================================================================

    final String status;

    if (!hasRevenue && !hasCosts) {
      status = 'NO_DATA';
    } else if (net < 0) {
      status = 'LOSS';
    } else if (hasCosts && net <= (revenue * _atRiskMarginThreshold)) {
      // Margen neto ≤ _atRiskMarginThreshold → riesgo
      status = 'AT_RISK';
    } else {
      status = 'ACTIVE';
    }

    // =========================================================================
    // 4. CONSTRUCCIÓN DEL DOMINIO (orden estable)
    // =========================================================================

    final domain = <String, dynamic>{
      'domainVersion': domainVersion,

      // Estado global del dominio financiero
      'status': status,

      // Resumen financiero (base del sistema)
      'summary': <String, dynamic>{
        'totalRevenue': _round(revenue),
        'totalCosts': _round(costs),
        'netResult': _round(net),
        'currencyCode': effectiveCurrency,
      },

      // Indicadores operativos
      'flags': <String, dynamic>{
        'hasRevenue': hasRevenue,
        'hasCosts': hasCosts,
        // hasDebt: omitido hasta que haya implementación real — no escribir false
        // estático en Firestore cuando el campo no tiene información.
      },

      // Metadatos para evolución futura
      'meta': <String, dynamic>{
        // lastCalculatedAt: omitido cuando es null — Firestore no debe recibir
        // campos nulos explícitos en Maps anidados; usar if(x != null) al escalar.
        'dataCompleteness': _computeCompleteness(
          hasRevenue: hasRevenue,
          hasCosts: hasCosts,
        ),
      },
    };

    return FinancialDomainResult(domain: domain, status: status);
  }

  // ==========================================================================
  // UTILIDADES PRIVADAS
  // ==========================================================================

  /// Redondeo estable para evitar ruido en hashing
  static double _round(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// Indicador simple de completitud del dominio
  static String _computeCompleteness({
    required bool hasRevenue,
    required bool hasCosts,
  }) {
    if (!hasRevenue && !hasCosts) return 'EMPTY';
    if (hasRevenue && hasCosts) return 'COMPLETE';
    return 'PARTIAL';
  }
}
