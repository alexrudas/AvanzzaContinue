// ============================================================================
// lib/data/sync/domains/legal_domain_builder.dart
// LEGAL DOMAIN BUILDER — Fragmento domains.legal para schema v1.3.4
//
// QUÉ HACE:
// - Construye el fragmento `domains.legal` del documento Firestore v1.3.4
//   desde `runtMetaJson` (String?) y `propertyLiens` (String?) del modelo
//   de vehículo.
// - Parsea inline `runt_limitations` y `runt_warranties` desde runtMetaJson
//   decodificando el JSON UNA sola vez.
// - Ordena limitaciones y garantías de forma estable (systemRegistrationDate
//   + tipo/nombre) antes de construir el fragmento — crítico para hashing.
// - Normaliza propertyLiens (trim + colapso de espacios múltiples) para
//   estabilidad de hash.
// - Deriva LegalStatus: DISPUTED > ENCUMBERED > CLEAR.
//   DISPUTED: alguna limitación contiene keywords judiciales en tipo/entidad.
//   ENCUMBERED: existe alguna limitación/garantía útil o novedad en liens.
//   CLEAR: sin afectaciones legales.
//
// QUÉ NO HACE:
// - No importa nada de lib/presentation/ — parsing inlineado.
// - No parsea fechas a DateTime: se conservan como String? fuente del RUNT.
// - No accede a Isar ni Firestore.
// - No normaliza ni suprime el texto de propertyLiens fuera de espacios.
//
// PRINCIPIOS:
// - Decode once: runtMetaJson se decodifica una sola vez en build().
// - Orden estable: listas ordenadas antes del fragmento final → hash estable.
// - Falla silenciosamente ante JSON malformado: listas vacías, status CLEAR.
// - Keywords judiciales en catálogo cerrado `_judicialKeywords`.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 3 — Asset Schema v1.3.4.
// WIRING: usado exclusivamente desde AssetDocumentBuilder.buildFullDocument().
// ============================================================================

import 'dart:convert';

import '../asset_priority_engine.dart';

final class LegalDomainResult {
  final Map<String, dynamic> domain;
  final LegalStatus legalStatus;

  const LegalDomainResult({
    required this.domain,
    required this.legalStatus,
  });
}

abstract final class LegalDomainBuilder {
  static LegalDomainResult build({
    required String? runtMetaJson,
    required String? propertyLiens,
    int domainVersion = 1,
  }) {
    // ✅ 1. Parsear UNA sola vez
    final decoded = _decodeMetaJson(runtMetaJson);

    final limitations = _parseLimitations(decoded);
    final warranties = _parseWarranties(decoded);

    // ✅ 2. Normalizar propertyLiens (estable para hashing)
    final liensFinal = _normalizeLiens(propertyLiens);

    final hasLimitations = limitations.isNotEmpty;
    final hasWarranties = warranties.isNotEmpty;
    final hasPropertyLiensNovelties = _hasLiensNovelty(liensFinal);

    // ✅ 3. Status legal
    final LegalStatus legalStatus;

    if (hasLimitations && limitations.any(_isDisputedLimitation)) {
      legalStatus = LegalStatus.disputed;
    } else if (hasLimitations || hasWarranties || hasPropertyLiensNovelties) {
      legalStatus = LegalStatus.encumbered;
    } else {
      legalStatus = LegalStatus.clear;
    }

    // ✅ 4. Orden estable (CRÍTICO para hashing)
    final sortedLimitations = [...limitations]..sort(_sortLimitations);
    final sortedWarranties = [...warranties]..sort(_sortWarranties);

    final domain = <String, dynamic>{
      'domainVersion': domainVersion,
      'status': legalStatus.name.toUpperCase(),
      'totalLimitations': sortedLimitations.length,
      'totalWarranties': sortedWarranties.length,
      'hasPropertyLiensNovelties': hasPropertyLiensNovelties,
      if (liensFinal != null) 'propertyLiensText': liensFinal,
      'limitations': List<Map<String, dynamic>>.unmodifiable(
        sortedLimitations.map(_limitationForFirestore),
      ),
      'warranties': List<Map<String, dynamic>>.unmodifiable(
        sortedWarranties.map(_warrantyForFirestore),
      ),
    };

    return LegalDomainResult(
      domain: domain,
      legalStatus: legalStatus,
    );
  }

  // ==========================================================================
  // PARSING (ahora recibe decoded)
  // ==========================================================================

  static List<_LimitationItem> _parseLimitations(
    Map<String, dynamic>? decoded,
  ) {
    if (decoded == null) return const [];

    final raw = decoded['runt_limitations'];
    if (raw is! List) return const [];

    final result = <_LimitationItem>[];

    for (final entry in raw) {
      if (entry is! Map) continue;

      final m = Map<String, dynamic>.from(entry);

      final item = _LimitationItem(
        limitationType: _strKey(m, [
          'tipoLimitacion',
          'tipo_de_limitacion',
        ]),
        legalEntity: _strKey(m, [
          'entidadJuridica',
          'entidad_juridica',
        ]),
        officeIssueDate: _strKey(m, [
          'fechaExpedicionOficio',
          'fecha_de_expedicion_del_oficio',
        ]),
        systemRegistrationDate: _strKey(m, [
          'fechaRegistro',
          'fecha_de_registro_en_el_sistema',
        ]),
      );

      if (item.hasContent) result.add(item);
    }

    return result;
  }

  static List<_WarrantyItem> _parseWarranties(
    Map<String, dynamic>? decoded,
  ) {
    if (decoded == null) return const [];

    final raw = decoded['runt_warranties'];
    if (raw is! List) return const [];

    final result = <_WarrantyItem>[];

    for (final entry in raw) {
      if (entry is! Map) continue;

      final m = Map<String, dynamic>.from(entry);

      final item = _WarrantyItem(
        creditorId: _strKey(m, ['identificacionAcreedor']),
        creditorName: _str(m['acreedor']),
        registrationDate: _strKey(m, ['fechaInscripcion']),
      );

      if (item.hasContent) result.add(item);
    }

    return result;
  }

  // ==========================================================================
  // SORTING (NUEVO — determinismo)
  // ==========================================================================

  static int _sortLimitations(_LimitationItem a, _LimitationItem b) {
    final dateA = a.systemRegistrationDate ?? '';
    final dateB = b.systemRegistrationDate ?? '';

    final dateCompare = dateA.compareTo(dateB);
    if (dateCompare != 0) return dateCompare;

    final typeA = a.limitationType ?? '';
    final typeB = b.limitationType ?? '';

    return typeA.compareTo(typeB);
  }

  static int _sortWarranties(_WarrantyItem a, _WarrantyItem b) {
    final dateA = a.registrationDate ?? '';
    final dateB = b.registrationDate ?? '';

    final dateCompare = dateA.compareTo(dateB);
    if (dateCompare != 0) return dateCompare;

    final nameA = a.creditorName ?? '';
    final nameB = b.creditorName ?? '';

    return nameA.compareTo(nameB);
  }

  // ==========================================================================
  // NORMALIZACIÓN
  // ==========================================================================

  static String? _normalizeLiens(String? raw) {
    if (raw == null) return null;

    final normalized = raw.trim().replaceAll(RegExp(r'\s+'), ' ');

    return normalized.isEmpty ? null : normalized;
  }

  static bool _hasLiensNovelty(String? liens) {
    if (liens == null) return false;
    return liens.toUpperCase().trim() != 'NO REGISTRA';
  }

  // ==========================================================================
  // UTILIDADES
  // ==========================================================================

  static Map<String, dynamic>? _decodeMetaJson(String? json) {
    if (json == null || json.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(json);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}

    return null;
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static String? _strKey(Map<String, dynamic> m, List<String> keys) {
    for (final key in keys) {
      final v = _str(m[key]);
      if (v != null) return v;
    }
    return null;
  }

  static const _judicialKeywords = [
    'judicial',
    'litigio',
    'demanda',
    'proceso judicial',
    'embargo',
  ];

  static bool _isDisputedLimitation(_LimitationItem item) {
    final combined =
        '${item.limitationType ?? ''} ${item.legalEntity ?? ''}'.toLowerCase();

    return _judicialKeywords.any((kw) => combined.contains(kw));
  }

  static Map<String, dynamic> _limitationForFirestore(
    _LimitationItem item,
  ) {
    return {
      if (item.limitationType != null) 'limitationType': item.limitationType,
      if (item.legalEntity != null) 'legalEntity': item.legalEntity,
      if (item.systemRegistrationDate != null)
        'systemRegistrationDate': item.systemRegistrationDate,
    };
  }

  static Map<String, dynamic> _warrantyForFirestore(
    _WarrantyItem item,
  ) {
    return {
      if (item.creditorId != null) 'creditorId': item.creditorId,
      if (item.creditorName != null) 'creditorName': item.creditorName,
      if (item.registrationDate != null)
        'registrationDate': item.registrationDate,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

final class _LimitationItem {
  final String? limitationType;
  final String? legalEntity;
  final String? officeIssueDate;
  final String? systemRegistrationDate;

  const _LimitationItem({
    this.limitationType,
    this.legalEntity,
    this.officeIssueDate,
    this.systemRegistrationDate,
  });

  bool get hasContent =>
      limitationType != null ||
      legalEntity != null ||
      systemRegistrationDate != null;
}

final class _WarrantyItem {
  final String? creditorId;
  final String? creditorName;
  final String? registrationDate;

  const _WarrantyItem({
    this.creditorId,
    this.creditorName,
    this.registrationDate,
  });

  bool get hasContent =>
      creditorName != null || creditorId != null || registrationDate != null;
}
