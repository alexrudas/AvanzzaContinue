// ============================================================================
// lib/domain/repositories/core_common/operational_relationship_repository.dart
// OPERATIONAL RELATIONSHIP REPOSITORY — Core Common v1 / Contrato
// ============================================================================
// Qué hace:
//   - Define el contrato de persistencia y consulta de OperationalRelationship.
//   - Soporta queries por workspace, por target local y por PlatformActor.
//
// Qué NO hace:
//   - No ejecuta transiciones de estado: eso es responsabilidad del motor F2.a
//     invocado desde casos de uso. El repo solo persiste el resultado.
//   - No coordina Requests ni Deliveries.
//   - No valida invariantes de estado: el motor lo hace antes de llamar a save.
//   - NO expone deleteById: ver "Borrado controlado" abajo.
//
// Principios:
//   - Offline-first: los cambios van a Isar inmediatamente y se encolan para
//     Firestore. El espejo a Postgres ocurre solo cuando la Relación entra a
//     'vinculada' (responsabilidad del caso de uso, no del repo).
//   - Scoped por sourceWorkspaceId.
//   - NO-DIRECTORIO BY DESIGN: ningún método permite listar Relaciones fuera
//     del workspace consultante.
//
// Borrado controlado:
//   - Eliminación física restringida a procesos de mantenimiento; NO existe
//     en el contrato del flujo operativo.
//   - El flujo operativo cierra Relaciones vía cambio de estado a 'cerrada'
//     usando RelationshipStateMachine (F2.a). El motor define cuándo y desde
//     qué estados se puede cerrar.
//   - Si alguna tarea administrativa requiere borrado físico, debe introducirse
//     un repositorio separado de mantenimiento con auditoría explícita,
//     fuera del contrato operativo.
//
// Enterprise Notes:
//   - Cualquier mutación de state pasa obligatoriamente por
//     RelationshipStateMachine (F2.a). No se expone un método setState directo
//     para evitar bypass del motor.
// ============================================================================

import '../../entities/core_common/operational_relationship_entity.dart';
import '../../entities/core_common/value_objects/target_local_kind.dart';

/// Contrato de persistencia y consulta de OperationalRelationship.
/// Scoped por sourceWorkspaceId.
///
/// NO incluye deleteById: el cierre se realiza por máquina de estados (F2.a)
/// transicionando a 'cerrada'. La eliminación física queda fuera del flujo
/// operativo y solo debería existir en procesos de mantenimiento separados.
abstract class OperationalRelationshipRepository {
  /// Hidrata localmente una Relación recibida desde backend (POST /resolve).
  /// Local-only: Core API es la fuente de verdad; este repo solo cachea.
  Future<void> hydrateFromRemote(OperationalRelationshipEntity relationship);

  /// Retorna la entidad por id o null si no existe.
  Future<OperationalRelationshipEntity?> getById(String id);

  /// Stream reactivo por id. Emite null si se pierde visibilidad.
  Stream<OperationalRelationshipEntity?> watchById(String id);

  /// Lista todas las Relaciones del workspace.
  Future<List<OperationalRelationshipEntity>> listByWorkspace(
    String workspaceId,
  );

  /// Stream reactivo de Relaciones del workspace.
  Stream<List<OperationalRelationshipEntity>> watchByWorkspace(
    String workspaceId,
  );

  /// Encuentra la Relación (si existe) que apunta a un target local específico.
  /// Un workspace puede tener a lo sumo una Relación vigente por target.
  /// Nota: un mismo actor real referenciado como LocalOrganization y a la vez
  /// como LocalContact genera DOS Relaciones distintas (por targetLocalKind).
  Future<OperationalRelationshipEntity?> findByTarget(
    String workspaceId,
    TargetLocalKind targetLocalKind,
    String targetLocalId,
  );

  /// Stream reactivo de la Relación (si existe) para el target local dado.
  /// Emite null cuando no hay vínculo registrado para ese target.
  /// Consumido por los indicadores de match para reflejar "Vinculado"
  /// inmediatamente tras confirmar la resolución (F5 Hito 4).
  Stream<OperationalRelationshipEntity?> watchByTarget(
    String workspaceId,
    TargetLocalKind targetLocalKind,
    String targetLocalId,
  );

  /// Lista Relaciones del workspace vinculadas al mismo PlatformActor.
  /// Útil cuando un mismo actor aparece varias veces en la red local.
  Future<List<OperationalRelationshipEntity>> findByPlatformActor(
    String workspaceId,
    String platformActorId,
  );
}
