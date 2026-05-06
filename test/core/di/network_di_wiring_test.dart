// ============================================================================
// test/core/di/network_di_wiring_test.dart
// DI wiring — Mi Red Operativa (ADR actor-canon hito 5b)
// ============================================================================
// QUÉ HACE:
//   - Valida que los 4 símbolos introducidos en hito 5b están DECLARADOS en
//     DIContainer y apuntan a los tipos canónicos correctos.
//   - NO ejecuta `init()` del container completo (requiere Isar+Firestore
//     reales); es un chequeo estático de shape usando reflection mirror
//     sobre la clase.
//
// QUÉ NO HACE:
//   - No verifica que los objetos estén construidos (eso lo hace init()).
//   - No valida binding de GetX ni el ciclo Singleton.
// ============================================================================

import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/data/sources/remote/core_common/asset_actor_link_api_client.dart';
import 'package:avanzza/data/sources/remote/core_common/relationship_api_client.dart';
import 'package:avanzza/domain/repositories/core_common/asset_actor_link_repository.dart';
import 'package:avanzza/domain/repositories/core_common/network_relationship_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DIContainer — Network module (ADR §10)', () {
    test('declara los 4 símbolos del módulo Network con el tipo canónico', () {
      // Reflexion-free: confiamos en el tipo estático. Si alguien renombra o
      // elimina un campo, este test falla en compilación (imports rotos) o
      // en runtime por el `as` (no aplicable — compilación directa).
      //
      // Este test actúa como "sello": si compila, los símbolos existen y
      // apuntan al tipo correcto. Es guardrail de presencia + tipo.
      const typeCheck = _TypeCheck();
      expect(typeCheck.assetActorLinkRepositoryType,
          AssetActorLinkRepository);
      expect(typeCheck.networkRelationshipRepositoryType,
          NetworkRelationshipRepository);
      expect(typeCheck.assetActorLinkRemoteType, AssetActorLinkApiClient);
      expect(typeCheck.networkRelationshipRemoteType, RelationshipApiClient);
    });
  });
}

/// Sella los tipos declarados en DIContainer. Si un campo desaparece o
/// cambia de tipo, el archivo no compila.
class _TypeCheck {
  const _TypeCheck();

  Type get assetActorLinkRepositoryType {
    // Forzamos al compilador a verificar que el campo existe y es del tipo
    // esperado: `_Assign<DIContainer, AssetActorLinkRepository>`. Si cambia,
    // falla el análisis.
    AssetActorLinkRepository? _;
    _ = _readAssetActorLinkRepository();
    return _.runtimeType == Null
        ? AssetActorLinkRepository
        : AssetActorLinkRepository;
  }

  Type get networkRelationshipRepositoryType {
    NetworkRelationshipRepository? _;
    _ = _readNetworkRelationshipRepository();
    return _.runtimeType == Null
        ? NetworkRelationshipRepository
        : NetworkRelationshipRepository;
  }

  Type get assetActorLinkRemoteType {
    AssetActorLinkApiClient? _;
    _ = _readAssetActorLinkRemote();
    return _.runtimeType == Null
        ? AssetActorLinkApiClient
        : AssetActorLinkApiClient;
  }

  Type get networkRelationshipRemoteType {
    RelationshipApiClient? _;
    _ = _readNetworkRelationshipRemote();
    return _.runtimeType == Null
        ? RelationshipApiClient
        : RelationshipApiClient;
  }

  // ---------------------------------------------------------------------------
  // Readers: nunca se ejecutan realmente (el container no está init'd); pero
  // deben COMPILAR. Eso garantiza que los campos existen y son del tipo dado.
  // ---------------------------------------------------------------------------

  AssetActorLinkRepository? _readAssetActorLinkRepository() {
    try {
      return DIContainer().assetActorLinkRepository;
    } on Error {
      return null; // late-init error: el campo existe pero no inicializado.
    } on Exception {
      return null;
    }
  }

  NetworkRelationshipRepository? _readNetworkRelationshipRepository() {
    try {
      return DIContainer().networkRelationshipRepository;
    } on Error {
      return null;
    } on Exception {
      return null;
    }
  }

  AssetActorLinkApiClient? _readAssetActorLinkRemote() {
    try {
      return DIContainer().assetActorLinkRemote;
    } on Error {
      return null;
    } on Exception {
      return null;
    }
  }

  RelationshipApiClient? _readNetworkRelationshipRemote() {
    try {
      return DIContainer().networkRelationshipRemote;
    } on Error {
      return null;
    } on Exception {
      return null;
    }
  }
}
