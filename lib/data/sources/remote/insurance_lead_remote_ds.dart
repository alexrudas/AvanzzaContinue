// ============================================================================
// lib/data/sources/remote/insurance_lead_remote_ds.dart
// INSURANCE LEAD REMOTE DS — Datasource HTTP para leads de cotización SRCE.
//
// QUÉ HACE:
// - Implementa los 5 endpoints del contrato Avanzza Core /insurance/leads.
// - Deserializa respuestas usando los modelos de dominio.
// - Mapea DioException → InsuranceLeadRemoteException con code tipado.
// - Trata 201 y 200 como éxito operativo en createLead (dedup transparente).
//
// QUÉ NO HACE:
// - No persiste en Isar — HTTP only (MVP).
// - No interpreta estados de negocio ni decide lógica de flujo.
// - No toma decisiones sobre dedup — solo expone el campo "created".
//
// PRINCIPIOS:
// - Thin datasource: construir URL → ejecutar request → parsear → retornar.
// - Error mapping explícito: DioException → InsuranceLeadRemoteException.
// - _extractCode defensivo: acepta Map genérico (evita cast runtime fail).
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EXCEPCIÓN PROPIA DEL MÓDULO
// ─────────────────────────────────────────────────────────────────────────────

/// Excepción tipada para errores de la API de insurance leads.
///
/// [code] refleja el code devuelto por el backend (LEAD_NOT_FOUND, BAD_REQUEST,
/// NETWORK_ERROR, etc.), o un valor genérico si el backend no lo incluye.
/// Evita que controllers/UI comparen mensajes de Exception genérica.
class InsuranceLeadRemoteException implements Exception {
  final String code;
  final int? statusCode;
  final String? message;

  const InsuranceLeadRemoteException({
    required this.code,
    this.statusCode,
    this.message,
  });

  @override
  String toString() =>
      'InsuranceLeadRemoteException(code: $code, status: $statusCode, message: $message)';
}

// ─────────────────────────────────────────────────────────────────────────────
// DATASOURCE
// ─────────────────────────────────────────────────────────────────────────────

class InsuranceLeadRemoteDs {
  final Dio _dio;

  InsuranceLeadRemoteDs(this._dio);

  // ── POST /insurance/leads ──────────────────────────────────────────────────
  //
  // 201 → lead nuevo   (created: true)
  // 200 → dedup activo (created: false)
  // Ambos son éxito operativo — no lanzar en 200.

  Future<CreateInsuranceLeadResponse> createLead(
    CreateInsuranceLeadRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<dynamic, dynamic>>(
        '/insurance/leads',
        data: request.toJson(),
        options: Options(
          // Aceptar tanto 200 (dedup) como 201 (nuevo) sin que Dio los trate
          // como error. Dio por defecto solo acepta 2xx, pero es explícito aquí.
          validateStatus: (status) => status != null && status >= 200 && status < 300,
        ),
      );
      final data = response.data;
      if (data == null) {
        throw InsuranceLeadRemoteException(
          code: 'EMPTY_RESPONSE',
          statusCode: response.statusCode,
          message: 'POST /insurance/leads devolvió body vacío.',
        );
      }
      return CreateInsuranceLeadResponse.fromJson(
        Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw _mapError(e, context: 'createLead');
    }
  }

  // ── GET /insurance/leads/:id?orgId= ───────────────────────────────────────

  Future<InsuranceOpportunityLead> getLead({
    required String id,
    required String orgId,
  }) async {
    try {
      final response = await _dio.get<Map<dynamic, dynamic>>(
        '/insurance/leads/$id',
        queryParameters: {'orgId': orgId},
      );
      final data = response.data;
      if (data == null) {
        throw InsuranceLeadRemoteException(
          code: 'EMPTY_RESPONSE',
          statusCode: response.statusCode,
          message: 'GET /insurance/leads/$id devolvió body vacío.',
        );
      }
      return InsuranceOpportunityLead.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw _mapError(e, context: 'getLead(id=$id)');
    }
  }

  // ── GET /insurance/leads?orgId=&status=&insuranceType=&assetId= ───────────

  Future<List<InsuranceOpportunityLead>> listLeads({
    required String orgId,
    String? status,
    String? insuranceType,
    String? assetId,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/insurance/leads',
        queryParameters: {
          'orgId': orgId,
          if (status != null) 'status': status,
          if (insuranceType != null) 'insuranceType': insuranceType,
          if (assetId != null) 'assetId': assetId,
        },
      );
      final data = response.data;
      if (data == null) return [];
      // Backend puede devolver { leads: [...] } o directamente [...]
      final List<dynamic> raw = data is List
          ? data
          : (data as Map<dynamic, dynamic>)['leads'] as List<dynamic>? ?? [];
      return raw
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => InsuranceOpportunityLead.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e, context: 'listLeads(orgId=$orgId)');
    }
  }

  // ── PATCH /insurance/leads/:id/status ─────────────────────────────────────

  /// [status] debe ser el wire value ya convertido (e.g. 'requested').
  /// La conversión dominio → wire es responsabilidad del repositorio impl.
  Future<InsuranceOpportunityLead> updateStatus({
    required String id,
    required String orgId,
    required String status,
    String? notes,
  }) async {
    try {
      final response = await _dio.patch<Map<dynamic, dynamic>>(
        '/insurance/leads/$id/status',
        data: {
          'orgId': orgId,
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );
      final data = response.data;
      if (data == null) {
        throw InsuranceLeadRemoteException(
          code: 'EMPTY_RESPONSE',
          statusCode: response.statusCode,
          message: 'PATCH /insurance/leads/$id/status devolvió body vacío.',
        );
      }
      return InsuranceOpportunityLead.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw _mapError(e, context: 'updateStatus(id=$id)');
    }
  }

  // ── PATCH /insurance/leads/:id/assign ─────────────────────────────────────

  Future<InsuranceOpportunityLead> assignProvider({
    required String id,
    required String orgId,
    required String providerId,
    String? notes,
  }) async {
    try {
      final response = await _dio.patch<Map<dynamic, dynamic>>(
        '/insurance/leads/$id/assign',
        data: {
          'orgId': orgId,
          'providerId': providerId,
          if (notes != null) 'notes': notes,
        },
      );
      final data = response.data;
      if (data == null) {
        throw InsuranceLeadRemoteException(
          code: 'EMPTY_RESPONSE',
          statusCode: response.statusCode,
          message: 'PATCH /insurance/leads/$id/assign devolvió body vacío.',
        );
      }
      return InsuranceOpportunityLead.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw _mapError(e, context: 'assignProvider(id=$id)');
    }
  }

  // ── ERROR MAPPING ──────────────────────────────────────────────────────────

  InsuranceLeadRemoteException _mapError(
    DioException e, {
    required String context,
  }) {
    if (kDebugMode) {
      debugPrint('[InsuranceLeadRemoteDs][$context] '
          'status=${e.response?.statusCode} data=${e.response?.data}');
    }

    final statusCode = e.response?.statusCode;
    final rawData = e.response?.data;

    if (statusCode == 404) {
      return InsuranceLeadRemoteException(
        code: _extractCode(rawData) ?? 'LEAD_NOT_FOUND',
        statusCode: statusCode,
        message: 'Recurso no encontrado.',
      );
    }

    if (statusCode == 400) {
      return InsuranceLeadRemoteException(
        code: _extractCode(rawData) ?? 'BAD_REQUEST',
        statusCode: statusCode,
        message: 'Solicitud inválida.',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const InsuranceLeadRemoteException(
        code: 'NETWORK_ERROR',
        message: 'Sin conexión o timeout.',
      );
    }

    return InsuranceLeadRemoteException(
      code: 'UNKNOWN_ERROR',
      statusCode: statusCode,
      message: e.message,
    );
  }

  /// Extrae el código de error del body del backend.
  ///
  /// Acepta Map genérico (no asume Map<String, dynamic>) para evitar
  /// ClassCastException en runtime cuando Dio deserializa con tipos mixtos.
  ///
  /// Soporta dos formatos del backend:
  ///   { "code": "LEAD_NOT_FOUND" }
  ///   { "message": { "code": "VALIDATION_ERROR" } }
  String? _extractCode(dynamic data) {
    if (data is! Map) return null;
    // Formato directo
    final direct = data['code'];
    if (direct is String && direct.isNotEmpty) return direct;
    // Formato anidado en message
    final msg = data['message'];
    if (msg is Map) {
      final nested = msg['code'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
    return null;
  }
}
