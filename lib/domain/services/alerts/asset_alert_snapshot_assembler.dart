// ============================================================================
// lib/domain/services/alerts/asset_alert_snapshot_assembler.dart
// ASSET ALERT SNAPSHOT ASSEMBLER — Construcción del snapshot para evaluación
//
// QUÉ HACE:
// - Construye AssetAlertSnapshot consultando repositorios reales (asset, insurance).
// - Selecciona la póliza relevante por tipo según el criterio canónico:
//     1. La más reciente entre las actualmente vigentes (día calendario de
//        fechaFin >= hoy UTC; incluye "vence hoy"). NO se usa
//        InsurancePolicyEntity.estado: puede quedar stale.
//     2. Si no hay vigente: la de fechaFin más reciente entre las vencidas.
//     3. Si no hay ninguna: null.
// - Parsea runtMetaJson directamente (sin importar los helpers de presentación)
//   para extraer datos RTM y jurídicos.
// - Calcula estado de EXENCIÓN RTM para activos que no requieren revisión
//   (vehículos nuevos según normativa colombiana).
//
// QUÉ NO HACE:
// - No evalúa alertas — solo consolida datos.
// - No importa Flutter, GetX ni presentation helpers.
// - No duplica lógica de evaluateSoat() ni getSoatPriority().
// - No persiste el snapshot.
//
// PRINCIPIOS:
// - Constructor injection: recibe repositorios via constructor (DI).
// - Registrado en DIContainer para uso via inyección.
// - Falla silenciosamente ante datos faltantes: devuelve snapshot con nulls.
// - Parseo de runtMetaJson propio e independiente de los presentation helpers.
// - Snapshot consistente: todos los datos salen del mismo asset en memoria.
// - Sin refetch: ningún evaluador debe volver a consultar datos.
//
// REGLA CRÍTICA — EXENCIÓN RTM:
// - Si NO hay RTM registrada → evaluar si está en periodo de exención.
// - Público: 2 años desde fecha actual (aproximación V1).
// - Particular: 5 años.
// - Si está exento → NO debe generar alerta de vencimiento.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Productor contextual v1. Ver ALERTS_SYSTEM_V4.md §11.3.
// ACTUALIZADO (2026-03): Fase 5.6 — soporte RTM_EXENTO (regla Colombia).
// ACTUALIZADO (2026-03): V5 — _computeRtmExemption() usa VehicleServiceCategory
//   (no raw string). Fix bug: PÚBLICO con tilde caía en rama de 5 años.
//   _joinLabels() previene strings "null Brand" cuando brand/model son null.
// ACTUALIZADO (2026-04): FIX CRÍTICO — _parseRtmFromMeta() reconoce ahora la clave
//   'expirationDate' (English camelCase, wizard async backend, ISO YYYY-MM-DD).
//   Raíz de inconsistencia: alert list mostraba "Vencido hace 1 día" mientras la
//   vista detalle mostraba "Vigente" para WPV583, WPV585, WGA960.
//   Causa: el wizard persiste los registros con 'expirationDate' como clave; el
//   assembler solo buscaba 'fecha_vigencia'/'fechaVigencia'. Los registros nuevos
//   eran descartados silenciosamente → rtmVigencia=null → falsa alerta rtmExpired.
//   _parseRtmDate() ya soportaba YYYY-MM-DD; solo faltaba la clave.
// ============================================================================

import 'dart:convert';
import 'dart:developer' as dev;

import '../../entities/alerts/vehicle_service_category.dart';
import '../../entities/asset/asset_content.dart';

import '../../entities/insurance/insurance_policy_entity.dart';
import '../../repositories/asset_repository.dart';
import '../../repositories/insurance_repository.dart';
import 'asset_alert_snapshot.dart';

/// Ensambla un [AssetAlertSnapshot] desde repositorios de dominio reales.
///
/// Instanciar vía [DIContainer] — no usar directamente en widgets.
class AssetAlertSnapshotAssembler {
  final AssetRepository _assetRepository;
  final InsuranceRepository _insuranceRepository;

  const AssetAlertSnapshotAssembler({
    required AssetRepository assetRepository,
    required InsuranceRepository insuranceRepository,
  })  : _assetRepository = assetRepository,
        _insuranceRepository = insuranceRepository;

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Construye el snapshot completo para [assetId] en [orgId].
  ///
  /// Retorna null si no se puede obtener la entidad del activo (no existe o error).
  Future<AssetAlertSnapshot?> assemble({
    required String assetId,
    required String orgId,
  }) async {
    // 1. Cargar activo
    final asset = await _assetRepository.getAsset(assetId);
    if (asset == null) return null;

    final details = await _assetRepository.getAssetDetails(assetId);
    final vehiculo = details.vehiculo;

    // 2. Pólizas
    final policies = await _insuranceRepository.fetchPoliciesByAsset(assetId);

    final soat = _selectRelevantPolicy(policies, InsurancePolicyType.soat);
    final rcContractual =
        _selectRelevantPolicy(policies, InsurancePolicyType.rcContractual);
    final rcExtracontractual =
        _selectRelevantPolicy(policies, InsurancePolicyType.rcExtracontractual);

    // 3. Parseos
    final rtmResult = _parseRtmFromMeta(
      vehiculo?.runtMetaJson,
      debugPlaca: vehiculo?.placa,
    );
    final legalResult = _parseLegalFromMeta(
      vehiculo?.runtMetaJson,
      propertyLiens: vehiculo?.propertyLiens,
    );

    // 4. Metadata
    final sourceUpdatedAt = vehiculo?.updatedAt ?? asset.updatedAt;

    final (vehicleServiceType, initialRegistrationDateRaw) =
        switch (asset.content) {
      VehicleContent(
        :final serviceType,
        :final initialRegistrationDate,
      ) =>
        (serviceType, initialRegistrationDate),
      _ => (null, null),
    };

    // 5. Identidad
    final assetPrimaryLabel = asset.content.assetKeyValue;

    final assetSecondaryLabel = switch (asset.content) {
      VehicleContent(:final brand, :final model) => _joinLabels([brand, model]),
      RealEstateContent(:final address) => _joinLabels([address]),
      MachineryContent(:final brand, :final model) => _joinLabels([brand, model]),
      EquipmentContent(:final name) => _joinLabels([name]),
    };

    final assetType = asset.content.typeDiscriminator;

    // ─────────────────────────────────────────────────────────────────────
    // 🔥 EXENCIÓN RTM (LÓGICA DE NEGOCIO CRÍTICA)
    // ─────────────────────────────────────────────────────────────────────

    // Normalizar primero: _computeRtmExemption usa la categoría canónica.
    final vehicleServiceCategory = VehicleServiceCategory.fromRaw(vehicleServiceType);

    final rtmExemptUntil = _computeRtmExemption(
      vehicleServiceCategory: vehicleServiceCategory,
      vigencia: rtmResult.vigencia,
      initialRegistrationDateRaw: initialRegistrationDateRaw,
    );

    return AssetAlertSnapshot(
      assetId: assetId,
      orgId: orgId,
      placa: vehiculo?.placa,
      assetPrimaryLabel: assetPrimaryLabel,
      assetSecondaryLabel: assetSecondaryLabel,
      assetType: assetType,
      soatPolicy: soat,
      rcContractualPolicy: rcContractual,
      rcExtracontractualPolicy: rcExtracontractual,
      rtmVigencia: rtmResult.vigencia,
      rtmCertificado: rtmResult.certificado,
      rtmExemptUntil: rtmExemptUntil,
      hasLegalLimitations: legalResult.hasLimitations,
      propertyLiensText: legalResult.propertyLiensText,
      primaryLimitationType: legalResult.primaryLimitationType,
      primaryLegalEntity: legalResult.primaryLegalEntity,
      vehicleServiceType: vehicleServiceType,
      vehicleServiceCategory: vehicleServiceCategory,
      sourceUpdatedAt: sourceUpdatedAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 🔥 EXENCIÓN RTM
  // ─────────────────────────────────────────────────────────────────────────

  /// Calcula si el activo está en periodo de exención RTM.
  ///
  /// REGLAS:
  /// - Si ya existe RTM → NO aplica exención.
  /// - Público → 2 años
  /// - Particular → 5 años
  ///
  /// NOTA:
  /// En V1 se usa fecha actual como baseline.
  /// En V2 debe usarse fecha de matrícula real del vehículo.
  DateTime? _computeRtmExemption({
    required VehicleServiceCategory vehicleServiceCategory,
    required DateTime? vigencia,
    required String? initialRegistrationDateRaw,
  }) {
    // Si ya existe RTM, no hay exención.
    if (vigencia != null) return null;

    // Sin fecha real de matrícula, no inventamos exención.
    final registrationDate = _parseInitialRegistrationDate(
      initialRegistrationDateRaw,
    );
    if (registrationDate == null) return null;

    final baseline = DateTime.utc(
      registrationDate.year,
      registrationDate.month,
      registrationDate.day,
    );

    if (vehicleServiceCategory == VehicleServiceCategory.publicTransport) {
      return DateTime.utc(
        baseline.year + 2,
        baseline.month,
        baseline.day,
      );
    }

    // Particular: 5 años. Unknown: falla hacia más leniente para no
    // generar alerta RTM espuria en vehículos sin servicio registrado.
    return DateTime.utc(
      baseline.year + 5,
      baseline.month,
      baseline.day,
    );
  }

  DateTime? _parseInitialRegistrationDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    final value = raw.trim();

    // Caso ISO / parseable por Dart
    final direct = DateTime.tryParse(value);
    if (direct != null) {
      return DateTime.utc(direct.year, direct.month, direct.day);
    }

    // Caso común dd/MM/yyyy o dd-MM-yyyy
    final match =
        RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(value);
    if (match != null) {
      final day = int.tryParse(match.group(1)!);
      final month = int.tryParse(match.group(2)!);
      final year = int.tryParse(match.group(3)!);

      if (day != null && month != null && year != null) {
        return DateTime.utc(year, month, day);
      }
    }

    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SELECCIÓN DE PÓLIZA
  // ─────────────────────────────────────────────────────────────────────────

  InsurancePolicyEntity? _selectRelevantPolicy(
    List<InsurancePolicyEntity> policies,
    InsurancePolicyType tipo,
  ) {
    final typed = policies.where((p) => p.policyType == tipo).toList();
    if (typed.isEmpty) return null;

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    final vigentes = typed.where((p) {
      final finDay =
          DateTime.utc(p.fechaFin.year, p.fechaFin.month, p.fechaFin.day);
      return !finDay.isBefore(today);
    }).toList();

    if (vigentes.isNotEmpty) {
      vigentes.sort((a, b) => b.fechaFin.compareTo(a.fechaFin));
      return vigentes.first;
    }

    typed.sort((a, b) => b.fechaFin.compareTo(a.fechaFin));
    return typed.first;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PARSEO RTM
  // ─────────────────────────────────────────────────────────────────────────

  _RtmParseResult _parseRtmFromMeta(
    String? runtMetaJson, {
    String? debugPlaca,
  }) {
    if (runtMetaJson == null || runtMetaJson.trim().isEmpty) {
      return const _RtmParseResult();
    }

    // Placas bajo diagnóstico activo — remover tras validar WPV583/WPV585/WGA960.
    const debugTargets = {'WPV583', 'WPV585', 'WGA960'};
    final isDebug =
        debugPlaca != null && debugTargets.contains(debugPlaca.toUpperCase());

    try {
      final decoded = jsonDecode(runtMetaJson) as Map<String, dynamic>;
      final rtmList = decoded['runt_rtm'];
      if (rtmList is! List || rtmList.isEmpty) {
        return const _RtmParseResult();
      }

      DateTime? bestVigencia;
      String? bestCertificado;

      for (final entry in rtmList) {
        if (entry is! Map) continue;
        final m = Map<String, dynamic>.from(entry);

        // FIX (2026-04): 'expirationDate' es la clave usada por el wizard async
        // backend (camelCase inglés, ISO YYYY-MM-DD). Antes solo se buscaban
        // 'fecha_vigencia' y 'fechaVigencia', causando que los registros nuevos
        // fueran descartados silenciosamente → falsa alerta rtmExpired.
        // _parseRtmDate() ya soporta YYYY-MM-DD; solo faltaba esta clave.
        final vigenciaStr = _strKey(m, [
          'fecha_vigencia',
          'fechaVigencia',
          'expirationDate', // wizard async backend — ISO YYYY-MM-DD
        ]);

        final vigencia =
            vigenciaStr != null ? _parseRtmDate(vigenciaStr) : null;

        if (isDebug) {
          dev.log(
            '[$debugPlaca] keys=${m.keys.toList()} '
            'vigenciaStr=$vigenciaStr vigenciaParsed=$vigencia',
            name: 'RTM_ASSEMBLER',
          );
        }

        if (vigenciaStr == null) continue;
        if (vigencia == null) continue;

        if (bestVigencia == null || vigencia.isAfter(bestVigencia)) {
          bestVigencia = vigencia;
          bestCertificado = _strKey(m, [
            'nro_certificado',
            'numeroCertificado',
            'certificateNumber', // wizard async backend
          ]);
        }
      }

      return _RtmParseResult(
        vigencia: bestVigencia,
        certificado: bestCertificado,
      );
    } catch (_) {
      return const _RtmParseResult();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PARSEO LEGAL
  // ─────────────────────────────────────────────────────────────────────────

  _LegalParseResult _parseLegalFromMeta(
    String? runtMetaJson, {
    String? propertyLiens,
  }) {
    bool hasLimitations = false;
    String? primaryLimitationType;
    String? primaryLegalEntity;

    if (runtMetaJson != null && runtMetaJson.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(runtMetaJson);
        if (decoded is Map) {
          final m = Map<String, dynamic>.from(decoded);

          final limRaw = m['runt_limitations'];
          if (limRaw is List) {
            for (final entry in limRaw) {
              if (entry is! Map) continue;
              final item = Map<String, dynamic>.from(entry);

              final tipo = _strKey(item, [
                'tipoLimitacion',
                'tipo_de_limitaci_n',
                'tipo_de_limitacion',
              ]);

              final entidad = _strKey(item, [
                'entidadJuridica',
                'entidad_jur_dica',
                'entidad_juridica',
              ]);

              if (tipo != null || entidad != null) {
                hasLimitations = true;
                primaryLimitationType ??= tipo;
                primaryLegalEntity ??= entidad;
              }
            }
          }
        }
      } catch (_) {}
    }

    final normalizedLiens = propertyLiens?.trim();
    final liensFinal = (normalizedLiens == null || normalizedLiens.isEmpty)
        ? null
        : normalizedLiens;

    return _LegalParseResult(
      hasLimitations: hasLimitations,
      propertyLiensText: liensFinal,
      primaryLimitationType: primaryLimitationType,
      primaryLegalEntity: primaryLegalEntity,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────

  DateTime? _parseRtmDate(String dateStr) {
    try {
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          return DateTime.utc(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } else if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          return DateTime.utc(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      }
    } catch (_) {}
    return null;
  }

  String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  String? _strKey(Map<String, dynamic> m, List<String> keys) {
    for (final key in keys) {
      final v = _str(m[key]);
      if (v != null) return v;
    }
    return null;
  }

  /// Une partes no-nulas y no-vacías con espacio.
  ///
  /// Evita strings tipo "null Hilux" o "Toyota null" cuando brand/model son null.
  /// Retorna null si el resultado final es vacío.
  String? _joinLabels(List<String?> parts) {
    final joined = parts
        .where((p) => p != null && p.trim().isNotEmpty)
        .map((p) => p!.trim())
        .join(' ');
    return joined.isEmpty ? null : joined;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _RtmParseResult {
  final DateTime? vigencia;
  final String? certificado;
  const _RtmParseResult({this.vigencia, this.certificado});
}

class _LegalParseResult {
  final bool hasLimitations;
  final String? propertyLiensText;
  final String? primaryLimitationType;
  final String? primaryLegalEntity;

  const _LegalParseResult({
    this.hasLimitations = false,
    this.propertyLiensText,
    this.primaryLimitationType,
    this.primaryLegalEntity,
  });
}
