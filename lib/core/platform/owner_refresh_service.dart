// ============================================================================
// lib/core/platform/owner_refresh_service.dart
// OWNER REFRESH SERVICE — Refresh manual de RUNT Persona + SIMIT
//
// QUÉ HACE:
// - Orquesta el refresh manual de datos de Licencia (RUNT Persona) y SIMIT
//   desde las pantallas de detalle, sin depender del widget vivo.
// - Invalida cache TTL → consulta API fresca → mapea a formato VRC →
//   persiste en portfolio snapshot (escalares + blob JSON) → retorna resultado.
// - Deduplicación por clave: si ya hay un refresh en curso para la misma
//   identidad, retorna el mismo Future (no dispara request duplicado).
//
// QUÉ NO HACE:
// - No muestra UI — la presentación decide cómo mostrar loading/error.
// - No depende de controllers GetX ni de widgets.
// - No hace polling ni cron — solo refresh on-demand.
//
// PRINCIPIOS:
// - Singleton vía DIContainer — sobrevive a destrucción de widgets.
// - Dart Futures no se cancelan al destruir widgets: la persistencia completa
//   aunque el usuario navegue fuera de la pantalla.
// - Mapping defensivo: campos faltantes se omiten, no crashean.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Refresh manual de Licencia y SIMIT desde detalle.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import '../../data/vrc/models/vrc_models.dart';
import '../../domain/entities/integrations/runt_person.dart';
import '../../domain/entities/integrations/simit_result.dart';
import '../../domain/repositories/integrations_repository.dart';
import '../../domain/repositories/portfolio_repository.dart';

// ── Resultado tipado del refresh ─────────────────────────────────────────────

/// Resultado de una operación de refresh.
///
/// [T] es el modelo VRC rehidratado (VrcOwnerSimitModel o VrcOwnerRuntModel).
sealed class RefreshResult<T> {
  const RefreshResult();
}

class RefreshSuccess<T> extends RefreshResult<T> {
  final T data;
  final DateTime refreshedAt;
  const RefreshSuccess(this.data, this.refreshedAt);
}

class RefreshError<T> extends RefreshResult<T> {
  final String message;

  /// true si el error es de la fuente externa (RUNT/SIMIT down, timeout, etc.)
  /// false si es error interno (mapping, persistencia, etc.)
  final bool isExternal;
  const RefreshError(this.message, {this.isExternal = true});
}

// ── Servicio ─────────────────────────────────────────────────────────────────

class OwnerRefreshService {
  final IntegrationsRepository _integrations;
  final PortfolioRepository _portfolio;

  OwnerRefreshService({
    required IntegrationsRepository integrations,
    required PortfolioRepository portfolio,
  })  : _integrations = integrations,
        _portfolio = portfolio;

  /// Futures en curso por clave de recurso. Deduplicación: si la clave ya
  /// existe, se retorna el mismo Future sin disparar un request nuevo.
  final Map<String, Future<RefreshResult>> _inFlight = {};

  /// true si hay un refresh SIMIT en curso para [document].
  bool isSimitRefreshing(String document) =>
      _inFlight.containsKey(_simitKey(document));

  /// true si hay un refresh de licencia en curso para [document]/[type].
  bool isLicenseRefreshing(String document, String type) =>
      _inFlight.containsKey(_licenseKey(document, type));

  // ── SIMIT Refresh ─────────────────────────────────────────────────────────

  /// Refresca datos SIMIT para un propietario y persiste en portfolio.
  ///
  /// 1. Invalida cache TTL
  /// 2. Consulta API fresca
  /// 3. Mapea SimitResultEntity → VrcOwnerSimitModel
  /// 4. Persiste escalares + blob JSON en portfolio
  /// 5. Retorna modelo VRC rehidratado
  ///
  /// Deduplicado por documento: múltiples llamadas para el mismo documento
  /// retornan el mismo Future.
  Future<RefreshResult<VrcOwnerSimitModel>> refreshSimit({
    required String portfolioId,
    required String document,
  }) async {
    final key = _simitKey(document);
    if (_inFlight.containsKey(key)) {
      return _inFlight[key]! as Future<RefreshResult<VrcOwnerSimitModel>>;
    }

    final future = _doRefreshSimit(portfolioId: portfolioId, document: document)
        .whenComplete(() => _inFlight.remove(key));
    _inFlight[key] = future;
    return future;
  }

  Future<RefreshResult<VrcOwnerSimitModel>> _doRefreshSimit({
    required String portfolioId,
    required String document,
  }) async {
    try {
      // 1. Invalidar cache para forzar consulta fresca.
      await _integrations.invalidateSimitCache(document);

      // 2. Consultar API.
      final entity = await _integrations.consultSimit(query: document);

      // 3. Mapear a formato VRC.
      final simitModel = _mapSimitEntityToVrc(entity);
      final summary = simitModel.summary;
      final now = DateTime.now();

      // 4. Persistir: escalares + blob JSON atómico via método especializado.
      // No toca campos de licencia ni identidad — sin nulls innecesarios.
      final blob = jsonEncode(simitModel.toJson());
      await _portfolio.updateSimitSnapshot(
        portfolioId,
        hasFines: summary?.hasFines,
        finesCount: summary?.finesCount ?? entity.multas.length,
        comparendosCount: summary?.comparendos,
        multasCount: summary?.multas,
        formattedTotal: summary?.formattedTotal,
        checkedAt: now,
        detailJson: blob,
      );

      return RefreshSuccess(simitModel, now);
    } on Exception catch (e) {
      final msg = e.toString();
      // Heurística: errores de Dio/HTTP son externos; el resto internos.
      final isExternal = msg.contains('DioException') ||
          msg.contains('SocketException') ||
          msg.contains('TimeoutException') ||
          msg.contains('ok: false') ||
          msg.contains('Connection') ||
          msg.contains('500') ||
          msg.contains('503');
      return RefreshError(msg, isExternal: isExternal);
    }
  }

  // ── License Refresh ───────────────────────────────────────────────────────

  /// Refresca datos de Licencia (RUNT Persona) y persiste en portfolio.
  ///
  /// Mismo patrón que [refreshSimit]: invalida cache → API → mapea →
  /// persiste → retorna.
  Future<RefreshResult<VrcOwnerRuntModel>> refreshLicense({
    required String portfolioId,
    required String document,
    required String documentType,
  }) async {
    final key = _licenseKey(document, documentType);
    if (_inFlight.containsKey(key)) {
      return _inFlight[key]! as Future<RefreshResult<VrcOwnerRuntModel>>;
    }

    final future = _doRefreshLicense(
      portfolioId: portfolioId,
      document: document,
      documentType: documentType,
    ).whenComplete(() => _inFlight.remove(key));
    _inFlight[key] = future;
    return future;
  }

  Future<RefreshResult<VrcOwnerRuntModel>> _doRefreshLicense({
    required String portfolioId,
    required String document,
    required String documentType,
  }) async {
    try {
      // 1. Invalidar cache.
      await _integrations.invalidateRuntPersonCache(document, documentType);

      // 2. Consultar API.
      final entity = await _integrations.consultRuntPerson(
        document: document,
        type: documentType,
      );

      // 3. Mapear a formato VRC.
      final runtModel = _mapRuntEntityToVrc(entity);
      final licenses = runtModel.licenses ?? const [];
      final mainLicense = licenses.isNotEmpty ? licenses.first : null;

      // 4. Persistir via método especializado — sin tocar campos SIMIT.
      final now = DateTime.now();
      await _portfolio.updateLicenseSnapshot(
        portfolioId,
        ownerName: entity.nombreCompleto,
        ownerDocument: entity.numeroDocumento,
        ownerDocumentType: entity.tipoDocumento,
        licenseStatus: mainLicense?.status,
        licenseExpiryDate: mainLicense?.expiryDate,
        checkedAt: now,
      );

      return RefreshSuccess(runtModel, now);
    } on Exception catch (e) {
      final msg = e.toString();
      final isExternal = msg.contains('DioException') ||
          msg.contains('SocketException') ||
          msg.contains('TimeoutException') ||
          msg.contains('ok: false') ||
          msg.contains('Connection') ||
          msg.contains('500') ||
          msg.contains('503');
      return RefreshError(msg, isExternal: isExternal);
    }
  }

  // ── Mapping: Standalone SIMIT → VRC format ────────────────────────────────

  /// Mapea [SimitResultEntity] (standalone endpoint) a [VrcOwnerSimitModel]
  /// (formato VRC consumido por las páginas de detalle).
  ///
  /// Los campos de cada multa en el endpoint standalone comparten las mismas
  /// claves JSON que VrcSimitFineModel (id, fecha, ciudad, valor, valorAPagar,
  /// estado, placa, infraccion) — el backend VRC internamente llama al mismo
  /// servicio SIMIT. Se parsean directamente via fromJson.
  VrcOwnerSimitModel _mapSimitEntityToVrc(SimitResultEntity entity) {
    // Fines: cada item en entity.multas es un Map<String, dynamic> crudo.
    // VrcSimitFineModel.fromJson usa las mismas claves JSON (id, fecha, ciudad,
    // valor, valorAPagar, estado, placa, infraccion) — el backend VRC y el
    // endpoint standalone comparten el mismo servicio SIMIT internamente.
    final fines = entity.multas
        .whereType<Map<String, dynamic>>()
        .map((item) {
          try {
            return VrcSimitFineModel.fromJson(item);
          } catch (_) {
            return null; // item malformado — descartar sin crash
          }
        })
        .whereType<VrcSimitFineModel>()
        .toList();

    // Summary: construir desde los campos conocidos del endpoint standalone.
    final resumen = entity.resumen;
    int? toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    // Casteo defensivo — el backend puede enviar tipos inesperados.
    String? toStr(dynamic v) {
      if (v is String) return v;
      if (v != null) return v.toString();
      return null;
    }

    final compCount = toInt(resumen['comparendos']) ?? 0;
    final multasCount = toInt(resumen['multas']) ?? 0;
    final acuerdosCount = toInt(resumen['acuerdosDePago']) ?? 0;

    // Construir byType desde el resumen standalone — conteos reales,
    // total individual no disponible (standalone no desglosa por tipo).
    final byType = VrcSimitByTypeModel(
      comparendos: VrcSimitTypeCountModel(count: compCount, total: 0),
      multas: VrcSimitTypeCountModel(count: multasCount, total: 0),
      acuerdosDePago: VrcSimitTypeCountModel(count: acuerdosCount, total: 0),
    );

    final summary = VrcSimitSummaryModel(
      hasFines: entity.tieneMultas,
      total: entity.total,
      // Preferir conteo del backend sobre fines.length — si whereType filtró
      // items malformados, fines.length podría ser menor al real.
      finesCount: toInt(resumen['total_multas']) ??
          toInt(resumen['cantidadMultas']) ??
          entity.multas.length,
      comparendos: compCount,
      multas: multasCount,
      paymentAgreementsCount: acuerdosCount,
      formattedTotal: toStr(resumen['totalFormateado']),
      document: toStr(resumen['cedula']),
      byType: byType,
    );

    return VrcOwnerSimitModel(
      summary: summary,
      fines: fines,
    );
  }

  // ── Mapping: Standalone RUNT Persona → VRC format ─────────────────────────

  /// Mapea [RuntPersonEntity] (standalone endpoint) a [VrcOwnerRuntModel]
  /// (formato VRC consumido por DriverLicenseDetailPage).
  VrcOwnerRuntModel _mapRuntEntityToVrc(RuntPersonEntity entity) {
    final licenses = entity.licencias.map((lic) {
      // Seleccionar la fecha de vencimiento más tardía entre las categorías.
      String? latestExpiry;
      DateTime? latestDate;
      final categories = <VrcLicenseCategoryModel>[];

      for (final det in lic.detalles) {
        categories.add(VrcLicenseCategoryModel(
          categoria: det.categoria,
          fechaExpedicion: det.fechaExpedicion,
          fechaVencimiento: det.fechaVencimiento,
        ));
        // Parsear DD/MM/YYYY para comparar fechas.
        final parts = det.fechaVencimiento.split('/');
        if (parts.length == 3) {
          final d = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final y = int.tryParse(parts[2]);
          if (d != null && m != null && y != null) {
            final dt = DateTime(y, m, d);
            if (latestDate == null || dt.isAfter(latestDate)) {
              latestDate = dt;
              latestExpiry = det.fechaVencimiento;
            }
          }
        }
      }

      return VrcLicenseModel(
        category: lic.numeroLicencia,
        status: lic.estado,
        issueDate: lic.fechaExpedicion,
        expiryDate: latestExpiry,
        categories: categories,
      );
    }).toList();

    return VrcOwnerRuntModel(licenses: licenses);
  }

  // ── Keys ──────────────────────────────────────────────────────────────────

  String _simitKey(String document) => 'simit:${document.trim().toUpperCase()}';
  String _licenseKey(String document, String type) =>
      'license:${document.trim()}_${type.trim().toUpperCase()}';
}
