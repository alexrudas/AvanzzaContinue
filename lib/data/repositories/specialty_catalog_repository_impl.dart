// ============================================================================
// lib/data/repositories/specialty_catalog_repository_impl.dart
// SPECIALTY CATALOG REPOSITORY IMPL — Thin wrapper sobre el API Client
//
// QUÉ HACE:
// - Implementa `SpecialtyCatalogRepository` delegando en
//   `SpecialtyCatalogApiClient` y mapeando DTO → Entity.
// - Convierte `SpecialtyKind?` (dominio) a `String?` (wire) en la query.
// - Gestiona cancelación HTTP: mantiene un `CancelToken` por request en
//   vuelo. Cada nueva llamada a `list()` cancela el anterior antes de
//   disparar el suyo. Domain solo conoce el método `cancelInFlight()` —
//   `package:dio` queda confinado a data layer (Clean Architecture).
//
// QUÉ NO HACE:
// - NO cachea: backend ya cachea 60s, regla del prompt.
// - NO captura excepciones del client (excepto el caso esperado de
//   `RequestCancelledException`, que se RElanza tal cual para que el
//   controller pueda ignorarla sin pintar UI de error).
// - NO valida `assetType` localmente: el backend canoniza el error como
//   `INVALID_ASSET_TYPE`.
//
// CONCURRENCIA:
// - Solo se admite 1 request HTTP en vuelo. Llamadas paralelas a `list()`
//   provocan que la primera lance `RequestCancelledException`.
// - Combinable con sequence-token + debounce en el controller para evitar
//   flood al backend (regla del prompt: "nunca más de 1 request activa").
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-25). Cancelación añadida en refinamiento UX (2026-04-25).
// ============================================================================

import 'package:dio/dio.dart';

import '../../domain/entities/catalog/specialty_entity.dart';
import '../../domain/repositories/catalog/specialty_catalog_repository.dart';
import '../sources/remote/catalog/specialty_catalog_api_client.dart';

class SpecialtyCatalogRepositoryImpl implements SpecialtyCatalogRepository {
  final SpecialtyCatalogApiClient _client;

  /// Token del request en vuelo. `null` cuando no hay request activo.
  CancelToken? _activeToken;

  SpecialtyCatalogRepositoryImpl({
    required SpecialtyCatalogApiClient client,
  }) : _client = client;

  @override
  Future<SpecialtyCatalogResult> list({
    required String assetType,
    SpecialtyKind? type,
  }) async {
    // 1) Cancelar el anterior — si ya completó, es no-op.
    cancelInFlight();

    // 2) Crear un token nuevo para ESTE request.
    final token = CancelToken();
    _activeToken = token;

    try {
      final dto = await _client.list(
        assetType: assetType,
        type: type?.wireName,
        cancelToken: token,
      );
      return dto.toEntity();
    } finally {
      // 3) Si seguimos siendo el "activo", limpiar la referencia.
      // Si otra llamada nos sustituyó, su `cancelInFlight()` ya rotó el token.
      if (identical(_activeToken, token)) {
        _activeToken = null;
      }
    }
  }

  @override
  void cancelInFlight() {
    final token = _activeToken;
    if (token != null && !token.isCancelled) {
      token.cancel('superseded by new request');
    }
    _activeToken = null;
  }
}
