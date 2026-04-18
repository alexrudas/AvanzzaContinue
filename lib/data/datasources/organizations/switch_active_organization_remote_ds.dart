// ============================================================================
// lib/data/datasources/organizations/switch_active_organization_remote_ds.dart
// SWITCH ACTIVE ORGANIZATION REMOTE DS
//
// QUÉ HACE:
// - Llama al endpoint Firebase Function POST /switchActiveOrganization.
// - Parsea el envelope de respuesta { ok: true, data: { activeContext: { ... } } }.
// - Retorna el organizationId confirmado por el backend para validación posterior.
//
// QUÉ NO HACE:
// - No gestiona token refresh ni OrgSwitchState (responsabilidad del use case).
// - No parsea claims JWT ni interactúa con Isar.
// - No mezcla lógica de sesión aquí — solo HTTP + mapeo de respuesta.
//
// PRINCIPIOS:
// - Responsabilidad única: HTTP call + parseo de envelope.
// - Usa [FirebaseBackendClient] — Dio con Bearer token automático.
// - Toda falla de HTTP o parseo lanza [SwitchOrganizationException].
//
// ENTERPRISE NOTES:
// - CREADO (2026-04): Deuda de sync activeContext.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../core/session/org_switch_exceptions.dart';

/// Resultado confirmado por el backend al procesar el switch de organización.
class SwitchOrganizationBackendResponse {
  /// El organizationId que el backend confirmó y escribió en custom claims.
  final String organizationId;

  const SwitchOrganizationBackendResponse({required this.organizationId});
}

/// Datasource para llamar al Firebase Function `switchActiveOrganization`.
///
/// El backend al responder OK garantiza que:
/// - [user_active_contexts/{uid}] fue actualizado en Firestore.
/// - Los custom claims JWT del usuario fueron actualizados con el nuevo orgId.
/// El token del cliente aún puede ser viejo — el use case debe forzar refresh.
class SwitchActiveOrganizationRemoteDS {
  final Dio _dio;

  const SwitchActiveOrganizationRemoteDS({required Dio dio}) : _dio = dio;

  /// Llama al backend para cambiar la organización activa del usuario autenticado.
  ///
  /// La autenticación corre en el Bearer token inyectado por [FirebaseBackendClient].
  /// Retorna [SwitchOrganizationBackendResponse] con el orgId confirmado.
  ///
  /// Lanza [SwitchOrganizationException] con [SwitchOrganizationFailureReason.backendError]
  /// si el backend devuelve error HTTP o un envelope inesperado.
  Future<SwitchOrganizationBackendResponse> switchActiveOrganization(
    String organizationId,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/switchActiveOrganization',
        data: {'organizationId': organizationId},
      );

      // Envelope esperado: { ok: true, data: { success: true, activeContext: { organizationId, ... } } }
      final envelope = response.data;
      if (envelope == null || envelope['ok'] != true) {
        throw const SwitchOrganizationException(
          'Backend returned non-ok envelope',
          SwitchOrganizationFailureReason.backendError,
        );
      }

      final data = envelope['data'] as Map<String, dynamic>?;
      final activeContext = data?['activeContext'] as Map<String, dynamic>?;
      final confirmedOrgId = activeContext?['organizationId'] as String?;

      if (confirmedOrgId == null || confirmedOrgId.isEmpty) {
        throw const SwitchOrganizationException(
          'Backend response missing activeContext.organizationId',
          SwitchOrganizationFailureReason.backendError,
        );
      }

      return SwitchOrganizationBackendResponse(
        organizationId: confirmedOrgId,
      );
    } on DioException catch (e) {
      // Mapear error HTTP a excepción tipada del dominio
      final statusCode = e.response?.statusCode;
      final serverMessage = e.response?.data?['error']?['message'] as String?;
      throw SwitchOrganizationException(
        'Backend HTTP $statusCode: ${serverMessage ?? e.message}',
        SwitchOrganizationFailureReason.backendError,
      );
    } on SwitchOrganizationException {
      rethrow;
    } catch (e) {
      throw SwitchOrganizationException(
        'Unexpected error calling switchActiveOrganization: $e',
        SwitchOrganizationFailureReason.backendError,
      );
    }
  }
}
