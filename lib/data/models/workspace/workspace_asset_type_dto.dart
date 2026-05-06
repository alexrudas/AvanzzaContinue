// ============================================================================
// lib/data/models/workspace/workspace_asset_type_dto.dart
// WORKSPACE ASSET TYPE DTO + MAPPER — Wire ↔ Domain
//
// QUÉ HACE:
// - DTO 1:1 con el JSON de
//   `GET /v1/core-common/workspaces/me/asset-types`:
//     [{ id, name, parentId }]
// - Provee `toEntity()` con parser estricto: lanza FormatException ante
//   shape incorrecto. El ApiClient lo traduce a ServerException.
//
// QUÉ NO HACE:
// - NO ordena ni filtra: backend lo hace por (parentId NULLS FIRST, name ASC).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): integración Flutter del workspace asset-type endpoint.
// ============================================================================

import '../../../domain/entities/workspace/workspace_asset_type_entity.dart';

class WorkspaceAssetTypeDto {
  final String id;
  final String name;
  final String? parentId;

  const WorkspaceAssetTypeDto({
    required this.id,
    required this.name,
    required this.parentId,
  });

  factory WorkspaceAssetTypeDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final parentId = json['parentId'];
    if (id is! String || id.isEmpty) {
      throw const FormatException(
        'WorkspaceAssetTypeDto.id ausente o no es String.',
      );
    }
    if (name is! String) {
      throw const FormatException(
        'WorkspaceAssetTypeDto.name ausente o no es String.',
      );
    }
    if (parentId != null && parentId is! String) {
      throw const FormatException(
        'WorkspaceAssetTypeDto.parentId debe ser String o null.',
      );
    }
    return WorkspaceAssetTypeDto(
      id: id,
      name: name,
      parentId: parentId as String?,
    );
  }

  WorkspaceAssetTypeEntity toEntity() {
    return WorkspaceAssetTypeEntity(
      id: id,
      name: name,
      parentId: parentId,
    );
  }
}
