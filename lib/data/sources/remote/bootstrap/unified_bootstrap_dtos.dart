// ============================================================================
// lib/data/sources/remote/bootstrap/unified_bootstrap_dtos.dart
// DTOs del endpoint unificado POST /v1/bootstrap. Espejo del contrato
// `UnifiedBootstrapDto` / `UnifiedBootstrapResult` del backend NestJS.
// ============================================================================

class UnifiedBootstrapProviderDto {
  final String name;
  final String? phone;
  final List<String>? specialtyIds;
  final List<String>? assetTypeIds;

  const UnifiedBootstrapProviderDto({
    required this.name,
    this.phone,
    this.specialtyIds,
    this.assetTypeIds,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
        if (specialtyIds != null && specialtyIds!.isNotEmpty)
          'specialtyIds': specialtyIds,
        if (assetTypeIds != null && assetTypeIds!.isNotEmpty)
          'assetTypeIds': assetTypeIds,
      };

  /// Reconstruye un payload persistido. Lanza `FormatException` si la shape
  /// no es válida (caller la trata como payload corrupto → retry manual).
  factory UnifiedBootstrapProviderDto.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String || name.isEmpty) {
      throw const FormatException('provider.name missing');
    }
    return UnifiedBootstrapProviderDto(
      name: name,
      phone: json['phone'] is String ? json['phone'] as String : null,
      specialtyIds: (json['specialtyIds'] as List?)?.whereType<String>().toList(),
      assetTypeIds: (json['assetTypeIds'] as List?)?.whereType<String>().toList(),
    );
  }
}

class UnifiedBootstrapRequestDto {
  final String? orgId;
  final String? workspaceName;
  final UnifiedBootstrapProviderDto? provider;

  const UnifiedBootstrapRequestDto({
    this.orgId,
    this.workspaceName,
    this.provider,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (orgId != null && orgId!.isNotEmpty) 'orgId': orgId,
        if (workspaceName != null && workspaceName!.isNotEmpty)
          'workspaceName': workspaceName,
        if (provider != null) 'provider': provider!.toJson(),
      };

  /// Reconstruye un payload persistido en Isar. Lanza `FormatException` si
  /// la shape no es válida.
  factory UnifiedBootstrapRequestDto.fromJson(Map<String, dynamic> json) {
    final providerRaw = json['provider'];
    return UnifiedBootstrapRequestDto(
      orgId: json['orgId'] is String ? json['orgId'] as String : null,
      workspaceName: json['workspaceName'] is String
          ? json['workspaceName'] as String
          : null,
      provider: providerRaw is Map<String, dynamic>
          ? UnifiedBootstrapProviderDto.fromJson(providerRaw)
          : null,
    );
  }
}

/// Estado del User al momento del bootstrap. Telemetría — no condiciona UX.
enum UnifiedBootstrapStatus { created, existing }

class UnifiedBootstrapResultDto {
  final String userId;
  final String workspaceId;
  final String orgId;
  final String? providerId;
  final UnifiedBootstrapStatus status;
  final bool requiresTokenRefresh;

  const UnifiedBootstrapResultDto({
    required this.userId,
    required this.workspaceId,
    required this.orgId,
    required this.providerId,
    required this.status,
    required this.requiresTokenRefresh,
  });

  factory UnifiedBootstrapResultDto.fromJson(Map<String, dynamic> json) {
    final userId = json['userId'];
    final workspaceId = json['workspaceId'];
    final orgId = json['orgId'];
    if (userId is! String || workspaceId is! String || orgId is! String) {
      throw const FormatException(
        'bootstrap response missing required ids (userId/workspaceId/orgId).',
      );
    }
    final rawProviderId = json['providerId'];
    final providerId = rawProviderId is String && rawProviderId.isNotEmpty
        ? rawProviderId
        : null;
    final statusWire = json['status'];
    final status = switch (statusWire) {
      'CREATED' => UnifiedBootstrapStatus.created,
      'EXISTING' => UnifiedBootstrapStatus.existing,
      _ => throw FormatException('unknown status=$statusWire'),
    };
    return UnifiedBootstrapResultDto(
      userId: userId,
      workspaceId: workspaceId,
      orgId: orgId,
      providerId: providerId,
      status: status,
      requiresTokenRefresh: json['requiresTokenRefresh'] == true,
    );
  }
}
