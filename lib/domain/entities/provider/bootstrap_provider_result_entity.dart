// ============================================================================
// lib/domain/entities/provider/bootstrap_provider_result_entity.dart
// BOOTSTRAP PROVIDER RESULT — respuesta de POST /v1/providers/bootstrap.
//
// QUÉ HACE:
//   Espejo de `BootstrapProviderOutput` del Core API. Contiene el id del
//   ProviderProfile recién creado/reactivado y el workspace destino.
//   `created` es siempre `true` por contrato actual (el backend devuelve
//   true incluso cuando reactiva un perfil inactivo previo — ver
//   provider-bootstrap.service.ts).
//
// QUÉ NO HACE:
//   - NO incluye specialties/assetTypes: el caller debe consultar
//     `/v1/providers/me` después para obtener la vista agregada.
// ============================================================================

class BootstrapProviderResultEntity {
  final String providerProfileId;
  final String workspaceId;
  final bool created;

  const BootstrapProviderResultEntity({
    required this.providerProfileId,
    required this.workspaceId,
    required this.created,
  });

  factory BootstrapProviderResultEntity.fromJson(Map<String, dynamic> json) =>
      BootstrapProviderResultEntity(
        providerProfileId: json['providerProfileId'] as String,
        workspaceId: json['workspaceId'] as String,
        created: (json['created'] as bool?) ?? true,
      );
}
