// ============================================================================
// test/architecture/coordination_firestore_isolation_test.dart
// ARCHITECTURE GUARD — F5 Hito 14
// ============================================================================
// QUÉ VALIDA (estática, sin runtime):
//   Ningún archivo del dominio de coordinación (flow / request / match
//   candidate) debe importar:
//     - LocalContactRepository / LocalOrganizationRepository
//     - LocalContact*FirestoreDataSource / LocalOrganization*FirestoreDataSource
//     - cloud_firestore directo
//     - modelos LocalContact / LocalOrganization
//
// POR QUÉ:
//   Core API es la única fuente de verdad para coordinación. Firestore en
//   este módulo persiste SOLO entidades privadas del workspace (contactos /
//   organizaciones locales del usuario). Cualquier acoplamiento reintroduce
//   doble backend y rompe la inversión de D4.
//
// CÓMO:
//   El test escanea los archivos críticos y falla si encuentra imports
//   prohibidos. No depende de Flutter runtime: puede correr en jenkins/CI
//   sin Isar/Firebase/Dio.
// ============================================================================

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Archivos que forman el dominio server-first de Coordination. Estos son los
/// únicos que matter: si cualquiera de ellos importa Firestore o repos
/// locales, rompemos el aislamiento.
const _coordinationDomainFiles = <String>[
  'lib/data/repositories/core_common/coordination_flow_repository_impl.dart',
  'lib/data/repositories/core_common/match_candidate_repository_impl.dart',
  'lib/data/repositories/core_common/operational_request_repository_impl.dart',
  'lib/data/repositories/core_common/operational_relationship_repository_impl.dart',
  'lib/data/sources/remote/core_common/coordination_flow_api_client.dart',
  'lib/data/sources/remote/core_common/match_candidate_nestjs_ds.dart',
  'lib/data/sources/remote/core_common/match_candidate_nestjs_ds_impl.dart',
  'lib/application/core_common/use_cases/start_operational_request.dart',
  'lib/application/core_common/use_cases/resolve_match_candidate.dart',
  'lib/domain/repositories/core_common/coordination_flow_repository.dart',
  'lib/domain/repositories/core_common/operational_request_repository.dart',
  'lib/domain/repositories/core_common/operational_relationship_repository.dart',
  'lib/domain/repositories/core_common/match_candidate_repository.dart',
];

/// Patrones de import prohibidos dentro del dominio de coordinación.
const _forbiddenImports = <String>[
  'local_contact_firestore_ds',
  'local_organization_firestore_ds',
  'local_contact_repository',
  'local_organization_repository',
  'local_contact_entity',
  'local_organization_entity',
  'local_contact_model',
  'local_organization_model',
  'package:cloud_firestore/',
];

void main() {
  test('dominio de coordinación NO importa Firestore ni repos Local*',
      () async {
    final offenders = <String>[];

    for (final path in _coordinationDomainFiles) {
      final file = File(path);
      if (!await file.exists()) {
        // Si el archivo cambió de ruta, el test falla explícitamente para
        // obligar a actualizar la lista (mejor ruido que falso OK).
        offenders.add('$path → archivo no encontrado (lista desactualizada)');
        continue;
      }
      final lines = await file.readAsLines();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (!line.trimLeft().startsWith('import ')) continue;
        for (final forbidden in _forbiddenImports) {
          if (line.contains(forbidden)) {
            offenders.add('$path:${i + 1}  →  $forbidden   ($line)');
          }
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Coordination domain files deben mantenerse aislados de Firestore y '
          'repos Local*. Ofensas:\n  - ${offenders.join('\n  - ')}',
    );
  });
}
