// ============================================================================
// lib/domain/repositories/core_common/request_delivery_repository.dart
// REQUEST DELIVERY REPOSITORY — Core Common v1 / Contrato
// ============================================================================
// Qué hace:
//   - Define el contrato de persistencia y consulta de RequestDelivery.
//   - Expone una consulta clave: si una Request tiene al menos un delivery en
//     'dispatched' o 'confirmedByEmitter' (regla de activación real de Relación).
//
// Qué NO hace:
//   - No muta deliveries en caso de fallo: para reintentar se crea un delivery
//     NUEVO; el contrato no expone eliminación.
//   - No dispara transiciones de Relación: el caso de uso 'dispatch_request'
//     consulta hasDispatchedOrConfirmed y decide si promueve a activadaUnilateral.
//   - No integra APIs externas (v1 sólo registra intents asistidos).
//
// Principios:
//   - Offline-first.
//   - Cada delivery es inmutable en intención; el estado se refleja en su propia
//     máquina (DeliveryStatus) sin reescribirse desde otro delivery.
//   - NO-DIRECTORIO BY DESIGN: no expone descubrir deliveries fuera del grafo
//     ya referenciado por el workspace (se consulta por requestId).
//
// Borrado controlado:
//   - No se expone delete: los deliveries son histórico operativo del transporte.
//   - Cualquier depuración masiva queda fuera del contrato operativo.
//
// Enterprise Notes:
//   - El reporte manual del emisor ('confirmedByEmitter') cuenta como
//     activación real por diseño: el workspace asume responsabilidad del aviso.
// ============================================================================

import '../../entities/core_common/request_delivery_entity.dart';

/// Contrato de persistencia y consulta de RequestDelivery.
abstract class RequestDeliveryRepository {
  /// Crea un delivery. Los reintentos se persisten como deliveries nuevos.
  /// Actualizar status de un delivery existente (p.ej. dispatched → delivered)
  /// también va por este método; la invariante de no-mutación aplica al fallo
  /// (failed no se edita: se crea uno nuevo como reintento).
  Future<void> save(RequestDeliveryEntity delivery);

  /// Retorna el delivery por id o null si no existe.
  Future<RequestDeliveryEntity?> getById(String id);

  /// Lista todos los deliveries asociados a una Request, ordenados por createdAt.
  Future<List<RequestDeliveryEntity>> listByRequest(String requestId);

  /// Stream reactivo de deliveries de una Request.
  Stream<List<RequestDeliveryEntity>> watchByRequest(String requestId);

  /// Retorna el delivery más reciente de una Request (el de createdAt mayor).
  /// Null si la Request aún no tiene deliveries.
  Future<RequestDeliveryEntity?> latestByRequest(String requestId);

  /// true si al menos un delivery de esta Request está en 'dispatched' o
  /// 'confirmedByEmitter'. Contrato de la regla de activación real:
  /// el caso de uso 'dispatch_request' consulta este método para decidir
  /// si promueve la Relación a 'activadaUnilateral'.
  Future<bool> hasDispatchedOrConfirmed(String requestId);
}
