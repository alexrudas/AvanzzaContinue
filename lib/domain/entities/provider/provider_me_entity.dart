// ============================================================================
// lib/domain/entities/provider/provider_me_entity.dart
// PROVIDER ME — vista agregada self del proveedor para Flutter.
//
// QUÉ HACE:
//   Reflejo 1:1 del response de `GET /v1/providers/me` del Core API.
//   Le dice al cliente:
//     - en qué workspace está operando (workspaceId).
//     - si el user es proveedor en ese workspace (isProvider).
//     - qué providerProfile tiene (null si NO es proveedor — UI ramifica
//       sin try/catch).
//     - qué specialties + assetTypes cubre (vacíos si NO es proveedor).
//     - qué capabilities tiene en este workspace (alimentadas por
//       Membership.roles en backend).
//
// QUÉ NO HACE:
//   - NO persiste en Isar (vista online por hito; offline llega en M2).
//   - NO mapea actorRefKind ni VerifiedKey: scope reducido a UI Provider.
//
// REUSE:
//   - Mappers exactos del JSON canónico Core API
//     (`provider-me.dto.ts:ProviderMeResponse`).
// ============================================================================

class ProviderMeProfile {
  /// UUID del ProviderProfile.
  final String providerProfileId;

  /// PlatformActor canónico (cross-workspace).
  final String platformActorId;

  /// Display name del actor (ya en español backend).
  final String displayName;

  /// Si el ProviderProfile está activo. Null se trata como true por
  /// defecto al deserializar (el backend siempre lo emite).
  final bool isActive;

  /// updatedAt ISO 8601 — útil como token de optimistic-concurrency en
  /// futuras escrituras (ej: replace specialties).
  final String updatedAt;

  const ProviderMeProfile({
    required this.providerProfileId,
    required this.platformActorId,
    required this.displayName,
    required this.isActive,
    required this.updatedAt,
  });

  factory ProviderMeProfile.fromJson(Map<String, dynamic> json) =>
      ProviderMeProfile(
        providerProfileId: json['providerProfileId'] as String,
        platformActorId: json['platformActorId'] as String,
        displayName: json['displayName'] as String,
        isActive: (json['isActive'] as bool?) ?? true,
        updatedAt: json['updatedAt'] as String,
      );
}

class ProviderMeSpecialty {
  final String id;
  final String key;
  final String name;
  /// 'SERVICE' | 'PRODUCT' | 'BOTH'.
  final String kind;

  const ProviderMeSpecialty({
    required this.id,
    required this.key,
    required this.name,
    required this.kind,
  });

  factory ProviderMeSpecialty.fromJson(Map<String, dynamic> json) =>
      ProviderMeSpecialty(
        id: json['id'] as String,
        key: json['key'] as String,
        name: json['name'] as String,
        kind: json['kind'] as String,
      );
}

class ProviderMeAssetType {
  final String id;
  final String name;

  const ProviderMeAssetType({required this.id, required this.name});

  factory ProviderMeAssetType.fromJson(Map<String, dynamic> json) =>
      ProviderMeAssetType(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

/// Response agregado de `GET /v1/providers/me`.
class ProviderMeEntity {
  final String workspaceId;
  final bool isProvider;
  final ProviderMeProfile? providerProfile;
  final List<ProviderMeSpecialty> specialties;
  final List<ProviderMeAssetType> assetTypes;
  /// Capabilities efectivas del user en este workspace (Membership.roles).
  final List<String> capabilities;

  const ProviderMeEntity({
    required this.workspaceId,
    required this.isProvider,
    required this.providerProfile,
    required this.specialties,
    required this.assetTypes,
    required this.capabilities,
  });

  factory ProviderMeEntity.fromJson(Map<String, dynamic> json) {
    final ppRaw = json['providerProfile'];
    return ProviderMeEntity(
      workspaceId: json['workspaceId'] as String,
      isProvider: (json['isProvider'] as bool?) ?? false,
      providerProfile: ppRaw is Map<String, dynamic>
          ? ProviderMeProfile.fromJson(ppRaw)
          : null,
      specialties: ((json['specialties'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProviderMeSpecialty.fromJson)
          .toList(growable: false),
      assetTypes: ((json['assetTypes'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProviderMeAssetType.fromJson)
          .toList(growable: false),
      capabilities: ((json['capabilities'] as List?) ?? const [])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  /// Helper UI: el user tiene la capability admin de invitar agentes
  /// (provista por `provider_admin_role` cuando hace bootstrap SELF).
  bool get hasInviteAgentCapability =>
      capabilities.contains('provider.invite_agent');

  /// Helper UI: tiene capability para listar invitaciones emitidas.
  bool get hasReadAgentInvitationsCapability =>
      capabilities.contains('provider.agent_invitation.read');
}
