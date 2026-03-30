// ============================================================================
// lib/data/sync/asset_document_builder.dart
// ASSET DOCUMENT BUILDER — Enterprise Ultra Pro Premium (v1.3.4)
// ----------------------------------------------------------------------------
// QUÉ HACE
// - Construye el documento Firestore v1.3.4 completo a partir de:
//   * AssetVehiculoModel
//   * List<InsurancePolicyModel>
//   * DateTime now
//   * currentDomainVersions (base N por domain — opcional)
//   * previousFunctionalSnapshots (estado previo para comparar — opcional)
// - Determina domainsTouched comparando functionalSnapshot(nuevo) vs
//   functionalSnapshot(previo) por SHA-256. Sin previo → todos tocados.
// - Asigna domainVersion correcta: N+1 para tocados, N para no tocados.
// - Construye archivableFragments (compliance policies + legal limitations)
//   y verifica el límite de 50 KB.
// - Si no hay fragments oversized, siembra governance inicial con estado PENDING
//   para domains archivables reales.
// - historyPendingSince solo se siembra cuando existe pending history real.
// - Calcula payloadHash de forma estable y determinística sobre el documento
//   final canonicalizado, excluyendo metadata.payloadHash y lastSyncedAt.
// - Retorna AssetDocumentBuilderResult con el contrato tipado completo.
//
// QUÉ NO HACE
// - No accede a Isar ni Firestore.
// - No emite audit events.
// - No hace OCC, deduplication ni feature-flag routing.
// - No inventa campos fuera de los existentes en AssetVehiculoModel.
// - No ejecuta writes en Firestore.
// - No aplica merge punteado sobre governance.
//
// PRINCIPIOS
// - Función pura: mismo input → mismo documento y mismo payloadHash.
// - El hash sale del documento final exacto, no de fragmentos intermedios.
// - metadata.payloadHash y lastSyncedAt son los ÚNICOS campos excluidos del hash.
// - domainsTouched ⊆ document['domains'].keys (subconjunto semántico real).
// - expectedDomainVersions[d] = N (base, lo que leyó el cliente).
//   document['domains'][d]['domainVersion'] = N+1 (tocado) o N (no tocado).
// - historyWriteStatusSeed representa únicamente domains archivables reales.
// - El builder NO ejecuta merge field-by-field: solo construye document + seed.
//   Dispatcher / ArchiveService aplican los writes reales en Firestore.
//
// ENTERPRISE NOTES
// CREADO (2026-03): Fase 3 — Asset Schema v1.3.4.
// EXTENDIDO (2026-03): Fase 5 — AssetDocumentBuilderResult completo.
// CONTRATO: El builder NO escribe Firestore. Solo construye y retorna.
// ============================================================================

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../../core/utils/map_canonicalizer.dart';
import '../models/asset/special/asset_vehiculo_model.dart';
import '../models/insurance/insurance_policy_model.dart';
import 'asset_priority_engine.dart';
import 'domains/compliance_domain_builder.dart';
import 'domains/financial_domain_builder.dart';
import 'domains/legal_domain_builder.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RESULT CONTRACT
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado canónico del builder.
///
/// El dispatcher consume este resultado para:
/// - Escribir [document] en Firestore.
/// - Verificar dedup por [payloadHash].
/// - Validar OCC por [expectedDomainVersions].
/// - Disparar archive por [archivableFragments].
/// - Sembrar governance inicial de pending history.
final class AssetDocumentBuilderResult {
  const AssetDocumentBuilderResult({
    required this.document,
    required this.payloadHash,
    required this.domainsTouched,
    required this.expectedDomainVersions,
    required this.archivableFragments,
    required this.historyWriteStatusSeed,
    required this.archivableFragmentsOversized,
    required this.wasSnapshotTruncated,
    required this.rawSnapshotsOriginalSizeBytes,
    required this.rawSnapshotsPersistedSizeBytes,
    required this.documentSizeBytes,
    required this.hasLockedOverride,
  });

  /// Documento Firestore completo con metadata.payloadHash ya inyectado.
  final Map<String, dynamic> document;

  /// SHA-256 del documento final canonicalizado
  /// (sin metadata.payloadHash ni metadata.lastSyncedAt).
  final String payloadHash;

  /// Domains con cambios funcionales reales en este ciclo.
  ///
  /// Subconjunto de document['domains'].keys.
  final List<String> domainsTouched;

  /// Versión base N por domain (lo que leyó el cliente antes de este write).
  ///
  /// Invariante:
  /// - tocado     → document.domains[d].domainVersion = N+1
  /// - no tocado  → document.domains[d].domainVersion = N
  final Map<String, int> expectedDomainVersions;

  /// Fragmentos archivables por domain, listos para history subcollection.
  ///
  /// Compliance → List<Map> de pólizas con campos identidad.
  /// Legal → List<Map> de limitaciones con campos identidad.
  /// Puede quedar vacío si:
  /// - no hubo domains archivables tocados, o
  /// - archivableFragmentsOversized == true.
  final Map<String, dynamic> archivableFragments;

  /// Estado inicial de historyWriteStatusByDomain para domains archivables.
  ///
  /// Valores esperados en este builder: { domain: 'PENDING' }.
  /// Vacío si no hay archivables pendientes.
  /// El builder lo devuelve como seed contractual; el write principal lo
  /// persiste dentro del documento y los updates posteriores se hacen con
  /// merge punteado.
  final Map<String, String> historyWriteStatusSeed;

  /// True si archivableFragments supera el guardrail de 50 KB.
  final bool archivableFragmentsOversized;

  /// True si rawSnapshots fue truncado por superar el límite.
  final bool wasSnapshotTruncated;

  /// Tamaño de rawSnapshots antes del truncamiento (en bytes, UTF-8).
  final int rawSnapshotsOriginalSizeBytes;

  /// Tamaño de rawSnapshots persistido en el documento (en bytes, UTF-8).
  /// Igual a [rawSnapshotsOriginalSizeBytes] cuando no hubo truncamiento.
  final int rawSnapshotsPersistedSizeBytes;

  /// Tamaño estimado del documento serializado.
  final int documentSizeBytes;

  /// True si alguna de las pólizas del activo tiene override.isLocked == true.
  ///
  /// Cuando es true, el dispatcher debe saltarse la deduplicación (pre-check y
  /// tardía) pero OCC sigue ejecutándose normalmente (plan §8.5, regla 33).
  /// El dispatcher lee este valor desde entry.metadata['overrideIsLocked'].
  final bool hasLockedOverride;
}

// Alias backward-compatible.
typedef AssetDocumentResult = AssetDocumentBuilderResult;

// ─────────────────────────────────────────────────────────────────────────────
// BUILDER
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AssetDocumentBuilder {
  static const String _schemaVersion = '1.3.4';

  static const int _rawSnapshotsMaxBytes = 10 * 1024; // 10 KB
  static const int _archivableFragmentsMaxBytes = 50 * 1024; // 50 KB

  // ==========================================================================
  // PUBLIC API
  // ==========================================================================

  static AssetDocumentBuilderResult buildFullDocument({
    required AssetVehiculoModel vehiculoModel,
    required List<InsurancePolicyModel> policies,
    required DateTime now,
    Map<String, int>? currentDomainVersions,
    Map<String, dynamic>? previousFunctionalSnapshots,
    int domainVersion = 1, // legacy fallback
  }) {
    final utcNow = now.toUtc();

    final baseVersions = _resolveBaseVersions(
      currentDomainVersions: currentDomainVersions,
      fallbackVersion: domainVersion,
    );

    // 1) DOMAIN BUILDERS — first pass with base version N
    final complianceResult = ComplianceDomainBuilder.build(
      policies: policies,
      now: utcNow,
      domainVersion: baseVersions['compliance'] ?? 0,
    );

    final legalResult = LegalDomainBuilder.build(
      runtMetaJson: vehiculoModel.runtMetaJson,
      propertyLiens: vehiculoModel.propertyLiens,
      domainVersion: baseVersions['legal'] ?? 0,
    );

    final financialResult = FinancialDomainBuilder.build(
      domainVersion: baseVersions['financial'] ?? 0,
    );

    // 2) FUNCTIONAL SNAPSHOTS
    final newSnapshots = <String, dynamic>{
      'compliance': _functionalSnapshotCompliance(complianceResult),
      'legal': _functionalSnapshotLegal(legalResult),
      'financial': _functionalSnapshotFinancial(financialResult),
    };

    final domainsTouched = _computeDomainsTouched(
      newSnapshots: newSnapshots,
      previousSnapshots: previousFunctionalSnapshots,
    );

    // 3) EXPECTED VERSIONS + FINAL DOMAIN VERSION
    final expectedDomainVersions = <String, int>{
      'compliance': baseVersions['compliance'] ?? 0,
      'legal': baseVersions['legal'] ?? 0,
      'financial': baseVersions['financial'] ?? 0,
    };

    _applyDomainVersions(
      domain: complianceResult.domain,
      domainKey: 'compliance',
      expectedVersions: expectedDomainVersions,
      domainsTouched: domainsTouched,
    );
    _applyDomainVersions(
      domain: legalResult.domain,
      domainKey: 'legal',
      expectedVersions: expectedDomainVersions,
      domainsTouched: domainsTouched,
    );
    _applyDomainVersions(
      domain: financialResult.domain,
      domainKey: 'financial',
      expectedVersions: expectedDomainVersions,
      domainsTouched: domainsTouched,
    );

    // 4) ARCHIVABLE FRAGMENTS
    final rawFragments = _buildArchivableFragments(
      complianceResult: complianceResult,
      legalResult: legalResult,
      domainsTouched: domainsTouched,
    );

    final rawFragmentsJson = jsonEncode(deepSortKeys(rawFragments));
    final rawFragmentsBytes = utf8.encode(rawFragmentsJson).length;
    final archivableFragmentsOversized =
        rawFragmentsBytes > _archivableFragmentsMaxBytes;

    final archivableFragments =
        archivableFragmentsOversized ? <String, dynamic>{} : rawFragments;

    // 5) HISTORY SEED
    //
    // CRÍTICO:
    // - Solo domains archivables reales.
    // - No usar domainsTouched directo, porque financial placeholder puede
    //   quedar tocado sin tener history operativa.
    final historyWriteStatusSeed = <String, String>{
      for (final d in archivableFragments.keys) d: 'PENDING',
    };

    final hasPendingHistory = historyWriteStatusSeed.isNotEmpty;

    // 6) PRIORITY
    final priorityInput = PriorityInput(
      complianceStatus: complianceResult.complianceStatus,
      complianceType: complianceResult.leadingComplianceType,
      daysExpired: complianceResult.daysExpired,
      legalStatus: legalResult.legalStatus,
      alertsMaxSeverity: null,
      alertsCount: 0,
    );

    final priorityResult = AssetPriorityEngine.computePriority(priorityInput);

    // 7) RAW SNAPSHOTS
    final rawSnapshotsSource = _buildRawSnapshotsData(vehiculoModel);
    final rawSnapshotsSourceJson = jsonEncode(deepSortKeys(rawSnapshotsSource));
    final rawSnapshotsOriginalSizeBytes =
        utf8.encode(rawSnapshotsSourceJson).length;

    final wasSnapshotTruncated =
        rawSnapshotsOriginalSizeBytes > _rawSnapshotsMaxBytes;

    final rawSnapshots = wasSnapshotTruncated
        ? _buildTruncatedRawSnapshots(
            original: rawSnapshotsSource,
            originalSizeBytes: rawSnapshotsOriginalSizeBytes,
          )
        : rawSnapshotsSource;

    final rawSnapshotsPersistedSizeBytes = wasSnapshotTruncated
        ? utf8.encode(jsonEncode(deepSortKeys(rawSnapshots))).length
        : rawSnapshotsOriginalSizeBytes;

    // 8) DOCUMENT ASSEMBLY (without payloadHash yet)
    final metadata = <String, dynamic>{
      'schemaVersion': _schemaVersion,
      'documentType': 'asset_vehicle',
      'lastSyncedAt': utcNow.toIso8601String(),
    };

    final governanceBlock = <String, dynamic>{
      'schemaVersion': _schemaVersion,
      if (vehiculoModel.createdAt != null)
        'createdAt': vehiculoModel.createdAt!.toUtc().toIso8601String(),
      if (vehiculoModel.updatedAt != null)
        'updatedAt': vehiculoModel.updatedAt!.toUtc().toIso8601String(),

      // Campos de pending history — solo cuando existe history operativa pendiente.
      'hasPendingHistory': hasPendingHistory,

      // historyPendingSince solo existe cuando hay domains archivables pendientes.
      // No debe sembrarse para domains tocados sin archive real.
      if (hasPendingHistory) ...{
        'historyWriteStatusByDomain':
            Map<String, String>.from(historyWriteStatusSeed),
        'historyPendingSince': Timestamp.fromDate(utcNow),
      },
    };

    final document = <String, dynamic>{
      'identity': _buildIdentity(vehiculoModel),
      'classification': _buildClassification(),
      'domains': <String, dynamic>{
        'compliance': complianceResult.domain,
        'legal': legalResult.domain,
        'financial': financialResult.domain,
      },
      'queryIndexes': <String, dynamic>{
        'priorityScore': priorityResult.score,
        'priorityReason': priorityResult.reason,
        'priorityReasonHuman': priorityResult.reasonHuman,
        'complianceStatus':
            complianceResult.complianceStatus.name.toUpperCase(),
        'leadingComplianceType': complianceResult.leadingComplianceType,
        'daysExpired': complianceResult.daysExpired,
        'activeComplianceTypes': complianceResult.activeComplianceTypes,
        'expiredComplianceTypes': complianceResult.expiredComplianceTypes,
        'legalStatus': legalResult.legalStatus.name.toUpperCase(),
        'financialStatus': financialResult.status,
      },
      'governance': governanceBlock,
      'rawSnapshots': rawSnapshots,
      'metadata': metadata,
    };

    // 9) FINAL HASH
    final hashableDocument = _buildHashableDocument(document: document);
    final canonical = deepSortKeys(hashableDocument);
    final payloadHash = _sha256(jsonEncode(canonical));

    metadata['payloadHash'] = payloadHash;

    // 10) FINAL SIZE
    final documentSizeBytes =
        utf8.encode(jsonEncode(deepSortKeys(document))).length;

    _assertBuilderInvariants(
      domainsTouched: domainsTouched,
      expectedDomainVersions: expectedDomainVersions,
      document: document,
      archivableFragments: archivableFragments,
      historyWriteStatusSeed: historyWriteStatusSeed,
      archivableFragmentsOversized: archivableFragmentsOversized,
    );

    // override.isLocked: true si alguna póliza tiene override activo con lock.
    // El dispatcher usa este flag para saltarse dedup manteniendo OCC activo.
    final hasLockedOverride = policies.any((p) => p.override.isLocked);

    return AssetDocumentBuilderResult(
      document: document,
      payloadHash: payloadHash,
      domainsTouched: domainsTouched,
      expectedDomainVersions: expectedDomainVersions,
      archivableFragments: archivableFragments,
      historyWriteStatusSeed: historyWriteStatusSeed,
      archivableFragmentsOversized: archivableFragmentsOversized,
      wasSnapshotTruncated: wasSnapshotTruncated,
      rawSnapshotsOriginalSizeBytes: rawSnapshotsOriginalSizeBytes,
      rawSnapshotsPersistedSizeBytes: rawSnapshotsPersistedSizeBytes,
      documentSizeBytes: documentSizeBytes,
      hasLockedOverride: hasLockedOverride,
    );
  }

  // ==========================================================================
  // DOMAIN VERSIONS
  // ==========================================================================

  static Map<String, int> _resolveBaseVersions({
    required Map<String, int>? currentDomainVersions,
    required int fallbackVersion,
  }) {
    if (currentDomainVersions != null) {
      return {
        'compliance': currentDomainVersions['compliance'] ?? 0,
        'legal': currentDomainVersions['legal'] ?? 0,
        'financial': currentDomainVersions['financial'] ?? 0,
      };
    }

    final base = fallbackVersion - 1;
    return {
      'compliance': base < 0 ? 0 : base,
      'legal': base < 0 ? 0 : base,
      'financial': base < 0 ? 0 : base,
    };
  }

  static void _applyDomainVersions({
    required Map<String, dynamic> domain,
    required String domainKey,
    required Map<String, int> expectedVersions,
    required List<String> domainsTouched,
  }) {
    final base = expectedVersions[domainKey] ?? 0;
    domain['domainVersion'] =
        domainsTouched.contains(domainKey) ? base + 1 : base;
  }

  // ==========================================================================
  // FUNCTIONAL SNAPSHOTS
  // ==========================================================================

  static List<Map<String, dynamic>> _functionalSnapshotCompliance(
    ComplianceDomainResult result,
  ) {
    final policies = result.domain['policies'] as List<dynamic>? ?? const [];

    return (policies
        .whereType<Map<String, dynamic>>()
        .map(
          (p) => <String, dynamic>{
            'policyId': p['policyId'],
            'complianceType': p['complianceType'],
            if (p['policyNumber'] != null) 'policyNumber': p['policyNumber'],
            'status': p['status'],
            if (p['tarifaBase'] != null) 'tarifaBase': p['tarifaBase'],
            if (p['currencyCode'] != null) 'currencyCode': p['currencyCode'],
            if (p['fechaInicio'] != null) 'fechaInicio': p['fechaInicio'],
            if (p['fechaFin'] != null) 'fechaFin': p['fechaFin'],
            if (p['estado'] != null) 'estado': p['estado'],
          },
        )
        .toList(growable: false)
      ..sort((a, b) => '${a['policyId']}'.compareTo('${b['policyId']}')));
  }

  static List<Map<String, dynamic>> _functionalSnapshotLegal(
    LegalDomainResult result,
  ) {
    final limitations =
        result.domain['limitations'] as List<dynamic>? ?? const [];

    return (limitations
        .whereType<Map<String, dynamic>>()
        .map(
          (l) => <String, dynamic>{
            if (l['limitationType'] != null)
              'limitationType': l['limitationType'],
            if (l['legalEntity'] != null) 'legalEntity': l['legalEntity'],
            if (l['systemRegistrationDate'] != null)
              'systemRegistrationDate': l['systemRegistrationDate'],
          },
        )
        .toList(growable: false)
      ..sort(
        (a, b) => '${a['limitationType']}${a['systemRegistrationDate']}'
            .compareTo('${b['limitationType']}${b['systemRegistrationDate']}'),
      ));
  }

  static Map<String, dynamic> _functionalSnapshotFinancial(
    FinancialDomainResult result,
  ) {
    final summary =
        result.domain['summary'] as Map<String, dynamic>? ?? const {};
    return <String, dynamic>{
      'status': result.domain['status'],
      'totalRevenue': summary['totalRevenue'],
      'totalCosts': summary['totalCosts'],
      'netResult': summary['netResult'],
    };
  }

  // ==========================================================================
  // DOMAINS TOUCHED
  // ==========================================================================

  static List<String> _computeDomainsTouched({
    required Map<String, dynamic> newSnapshots,
    required Map<String, dynamic>? previousSnapshots,
  }) {
    if (previousSnapshots == null) {
      return List<String>.unmodifiable(newSnapshots.keys.toList()..sort());
    }

    final touched = <String>[];

    for (final domain in newSnapshots.keys) {
      final newHash = _hashSnapshot(newSnapshots[domain]);
      final prevHash = _hashSnapshot(previousSnapshots[domain]);

      if (newHash != prevHash) {
        touched.add(domain);
      }
    }

    return List<String>.unmodifiable(touched..sort());
  }

  static String _hashSnapshot(dynamic snapshot) {
    if (snapshot == null) return '';
    final canonical = deepSortKeys(
      snapshot is Map<String, dynamic>
          ? snapshot
          : <String, dynamic>{'_value': snapshot},
    );
    return _sha256(jsonEncode(canonical));
  }

  // ==========================================================================
  // ARCHIVABLE FRAGMENTS
  // ==========================================================================

  /// Construye los fragmentos archivables para los domains tocados.
  ///
  /// compliance → policies list (campos identidad).
  /// legal → limitations list (campos identidad).
  /// Solo incluye domains que:
  /// - estén en [domainsTouched], y
  /// - tengan history operativa real para escribir.
  static Map<String, dynamic> _buildArchivableFragments({
    required ComplianceDomainResult complianceResult,
    required LegalDomainResult legalResult,
    required List<String> domainsTouched,
  }) {
    final fragments = <String, dynamic>{};

    if (domainsTouched.contains('compliance')) {
      final policies =
          complianceResult.domain['policies'] as List<dynamic>? ?? const [];
      if (policies.isNotEmpty) {
        fragments['compliance'] = policies
            .whereType<Map<String, dynamic>>()
            .where((p) => p['policyId'] != null)
            .map(
              (p) => <String, dynamic>{
                'policyId': p['policyId'],
                if (p['policyNumber'] != null)
                  'policyNumber': p['policyNumber'],
                if (p['complianceType'] != null)
                  'policyType': p['complianceType'],
                'status': p['status'],
                if (p['tarifaBase'] != null) 'premium': p['tarifaBase'],
                if (p['fechaInicio'] != null) 'effectiveDate': p['fechaInicio'],
                if (p['fechaFin'] != null) 'expirationDate': p['fechaFin'],
                if (p['estado'] != null) 'estado': p['estado'],
              },
            )
            .toList(growable: false);
      }
    }

    if (domainsTouched.contains('legal')) {
      final limitations =
          legalResult.domain['limitations'] as List<dynamic>? ?? const [];
      if (limitations.isNotEmpty) {
        fragments['legal'] = limitations
            .whereType<Map<String, dynamic>>()
            .where((l) => l['limitationType'] != null)
            .map(
              (l) => <String, dynamic>{
                'limitationId':
                    '${l['limitationType']}_${l['systemRegistrationDate'] ?? ''}',
                'type': l['limitationType'],
                if (l['legalEntity'] != null) 'creditor': l['legalEntity'],
                if (l['systemRegistrationDate'] != null)
                  'registrationDate': l['systemRegistrationDate'],
              },
            )
            .toList(growable: false);
      }
    }

    return fragments;
  }

  // ==========================================================================
  // IDENTITY / CLASSIFICATION
  // ==========================================================================

  static Map<String, dynamic> _buildIdentity(AssetVehiculoModel m) {
    return <String, dynamic>{
      'assetId': m.assetId,
      'refCode': m.refCode,
      'placa': m.placa,
      'assetType': 'VEHICLE',
    };
  }

  static Map<String, dynamic> _buildClassification() {
    return const <String, dynamic>{
      'schemaFamily': 'ASSET_VEHICLE',
    };
  }

  // ==========================================================================
  // RAW SNAPSHOTS
  // ==========================================================================

  static Map<String, dynamic> _buildRawSnapshotsData(AssetVehiculoModel m) {
    return <String, dynamic>{
      'vehicle': <String, dynamic>{
        'assetId': m.assetId,
        'refCode': m.refCode,
        'placa': m.placa,
        'marca': m.marca,
        'modelo': m.modelo,
        'anio': m.anio,
        if (m.color != null) 'color': m.color,
        if (m.engineDisplacement != null)
          'engineDisplacement': _roundNum(m.engineDisplacement!),
        if (m.vin != null) 'vin': m.vin,
        if (m.engineNumber != null) 'engineNumber': m.engineNumber,
        if (m.chassisNumber != null) 'chassisNumber': m.chassisNumber,
        if (m.line != null) 'line': m.line,
        if (m.serviceType != null) 'serviceType': m.serviceType,
        if (m.vehicleClass != null) 'vehicleClass': m.vehicleClass,
        if (m.bodyType != null) 'bodyType': m.bodyType,
        if (m.fuelType != null) 'fuelType': m.fuelType,
        if (m.passengerCapacity != null)
          'passengerCapacity': m.passengerCapacity,
        if (m.loadCapacityKg != null)
          'loadCapacityKg': _roundNum(m.loadCapacityKg!),
        if (m.grossWeightKg != null)
          'grossWeightKg': _roundNum(m.grossWeightKg!),
        if (m.axles != null) 'axles': m.axles,
        if (m.transitAuthority != null) 'transitAuthority': m.transitAuthority,
        if (m.initialRegistrationDate != null)
          'initialRegistrationDate': m.initialRegistrationDate,
        if (m.propertyLiens != null) 'propertyLiens': m.propertyLiens,
        if (m.runtMetaJson != null) 'runtMetaJson': m.runtMetaJson,
        if (m.createdAt != null)
          'createdAt': m.createdAt!.toUtc().toIso8601String(),
        if (m.updatedAt != null)
          'updatedAt': m.updatedAt!.toUtc().toIso8601String(),
      },
    };
  }

  static Map<String, dynamic> _buildTruncatedRawSnapshots({
    required Map<String, dynamic> original,
    required int originalSizeBytes,
  }) {
    final summary = <String, dynamic>{
      'snapshotSummary': <String, dynamic>{
        'truncated': true,
        'originalSizeBytes': originalSizeBytes,
        'strategy': 'keys_only',
      },
    };

    for (final entry in original.entries) {
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        summary[entry.key] = <String, dynamic>{
          for (final key in value.keys.toList()..sort()) key: true,
        };
      } else {
        summary[entry.key] = true;
      }
    }

    return summary;
  }

  // ==========================================================================
  // HASHABLE DOCUMENT
  // ==========================================================================

  static Map<String, dynamic> _buildHashableDocument({
    required Map<String, dynamic> document,
  }) {
    final originalMetadata = document['metadata'];
    final hashableMetadata = originalMetadata is Map<String, dynamic>
        ? Map<String, dynamic>.of(originalMetadata)
        : <String, dynamic>{};

    hashableMetadata.remove('payloadHash');
    hashableMetadata.remove('lastSyncedAt');

    return <String, dynamic>{
      ...document,
      'metadata': hashableMetadata,
    };
  }

  // ==========================================================================
  // INVARIANTS
  // ==========================================================================

  static void _assertBuilderInvariants({
    required List<String> domainsTouched,
    required Map<String, int> expectedDomainVersions,
    required Map<String, dynamic> document,
    required Map<String, dynamic> archivableFragments,
    required Map<String, String> historyWriteStatusSeed,
    required bool archivableFragmentsOversized,
  }) {
    assert(() {
      final domains = (document['domains'] as Map<String, dynamic>? ?? const {})
          .keys
          .toSet();

      for (final d in domainsTouched) {
        if (!domains.contains(d)) {
          throw StateError(
            'Invariant violated: domainsTouched contains unknown domain "$d".',
          );
        }
      }

      for (final d in archivableFragments.keys) {
        if (!domainsTouched.contains(d)) {
          throw StateError(
            'Invariant violated: archivableFragments contains non-touched domain "$d".',
          );
        }
      }

      for (final d in historyWriteStatusSeed.keys) {
        if (!archivableFragments.containsKey(d)) {
          throw StateError(
            'Invariant violated: historyWriteStatusSeed contains non-archivable domain "$d".',
          );
        }
        if (historyWriteStatusSeed[d] != 'PENDING') {
          throw StateError(
            'Invariant violated: historyWriteStatusSeed["$d"] must be PENDING.',
          );
        }
      }

      if (archivableFragmentsOversized && archivableFragments.isNotEmpty) {
        throw StateError(
          'Invariant violated: oversized fragments must produce empty archivableFragments.',
        );
      }

      for (final d in const ['compliance', 'legal', 'financial']) {
        if (!expectedDomainVersions.containsKey(d)) {
          throw StateError(
            'Invariant violated: expectedDomainVersions missing "$d".',
          );
        }
      }

      // ── INVARIANTE DE VERSIONADO (corazón del contrato OCC) ─────────────
      // Para cada domain conocido:
      //   tocado     → domainVersion == expectedDomainVersions[d] + 1
      //   no tocado  → domainVersion == expectedDomainVersions[d]
      final domainsMap =
          document['domains'] as Map<String, dynamic>? ?? const {};
      for (final d in const ['compliance', 'legal', 'financial']) {
        final domainData = domainsMap[d] as Map<String, dynamic>?;
        if (domainData == null) continue;
        final actual = domainData['domainVersion'] as int?;
        final base = expectedDomainVersions[d] ?? 0;
        final isTouched = domainsTouched.contains(d);
        final expected = isTouched ? base + 1 : base;
        if (actual != expected) {
          throw StateError(
            'Invariant violated: domain "$d" domainVersion=$actual '
            'but expected=$expected (base=$base, touched=$isTouched).',
          );
        }
      }

      // ── INVARIANTE DE PENDING HISTORY ────────────────────────────────────
      // historyWriteStatusSeed vacío  → hasPendingHistory == false,
      //                                  historyPendingSince ausente/null.
      // historyWriteStatusSeed no vacío → hasPendingHistory == true,
      //                                    historyPendingSince presente.
      final governance =
          document['governance'] as Map<String, dynamic>? ?? const {};
      final hasPending = governance['hasPendingHistory'] as bool? ?? false;
      final pendingSince = governance['historyPendingSince'];

      if (historyWriteStatusSeed.isEmpty) {
        if (hasPending) {
          throw StateError(
            'Invariant violated: historyWriteStatusSeed is empty '
            'but hasPendingHistory == true.',
          );
        }
        if (pendingSince != null) {
          throw StateError(
            'Invariant violated: historyWriteStatusSeed is empty '
            'but historyPendingSince is set.',
          );
        }
      } else {
        if (!hasPending) {
          throw StateError(
            'Invariant violated: historyWriteStatusSeed has domains '
            'but hasPendingHistory == false.',
          );
        }
        if (pendingSince == null) {
          throw StateError(
            'Invariant violated: historyWriteStatusSeed has domains '
            'but historyPendingSince is null.',
          );
        }
      }

      return true;
    }());
  }

  // ==========================================================================
  // UTILS
  // ==========================================================================

  static String _sha256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  static double _roundNum(num value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
