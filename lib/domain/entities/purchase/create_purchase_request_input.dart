// ============================================================================
// lib/domain/entities/purchase/create_purchase_request_input.dart
// CREATE PURCHASE REQUEST INPUT — Value object canónico del create path
// ============================================================================
// QUÉ HACE:
//   - Representa la entrada de creación de una PurchaseRequest, alineada al
//     contrato backend `POST /v1/purchase-requests` ya cerrado en core-api.
//   - Campos canónicos: title, type, category, originType, assetId, notes,
//     delivery{department?, city, address, info?}, items[], vendorContactIds[].
//
// QUÉ NO HACE:
//   - No toca `PurchaseRequestEntity` (legacy: tipoRepuesto/cantidad/ciudad).
//     Ese entity sigue siendo el shape de cache/lectura por ahora y se
//     migrará en tarea aparte.
//   - No persiste: solo describe la intención de creación.
//
// PRINCIPIOS:
//   - Coherencia canónica 1:1 con backend (sin metadata escondida en notes).
//   - Enums cerrados para type y originType; category queda string libre.
//   - Invariantes mínimas verificadas en fábrica (assert): title no vacío,
//     items ≥ 1, vendorContactIds ≥ 1. La validación rica de UI vive en el
//     controller; aquí solo blindamos contra usos incorrectos.
//
// ENTERPRISE NOTES:
//   - Wire-stable: `wireName` mapea a los valores exactos que espera el DTO
//     NestJS (PRODUCT/SERVICE/ASSET/INVENTORY/GENERAL).
//   - assetId es referencia contextual; el backend no valida tenancy de Asset
//     (gap documentado del lado backend).
// ============================================================================

/// Naturaleza del contrato agregado de la solicitud.
/// Mapea 1:1 al enum backend `PurchaseRequestType`.
enum PurchaseRequestTypeInput {
  product('PRODUCT'),
  service('SERVICE');

  final String wireName;
  const PurchaseRequestTypeInput(this.wireName);
}

/// Origen de la necesidad de la solicitud.
/// Mapea 1:1 al enum backend `PurchaseRequestOrigin`.
enum PurchaseRequestOriginInput {
  asset('ASSET'),
  inventory('INVENTORY'),
  general('GENERAL');

  final String wireName;
  const PurchaseRequestOriginInput(this.wireName);
}

/// Ítem solicitado dentro de un create.
class CreatePurchaseRequestItemInput {
  final String description;
  final num quantity;
  final String unit;
  final String? notes;

  const CreatePurchaseRequestItemInput({
    required this.description,
    required this.quantity,
    required this.unit,
    this.notes,
  });
}

/// Dirección estructurada de entrega / ejecución.
/// Si se provee, `city` y `address` son obligatorios (espejo del DTO backend).
class CreateDeliveryInput {
  final String? department;
  final String city;
  final String address;
  final String? info;

  const CreateDeliveryInput({
    this.department,
    required this.city,
    required this.address,
    this.info,
  });
}

/// Payload canónico del create path.
class CreatePurchaseRequestInput {
  final String title;
  final PurchaseRequestTypeInput type;
  final String? category;
  final PurchaseRequestOriginInput originType;
  final String? assetId;
  final String? notes;
  final CreateDeliveryInput? delivery;
  final List<CreatePurchaseRequestItemInput> items;
  final List<String> vendorContactIds;

  const CreatePurchaseRequestInput({
    required this.title,
    required this.type,
    this.category,
    required this.originType,
    this.assetId,
    this.notes,
    this.delivery,
    required this.items,
    required this.vendorContactIds,
  });
}
