// ============================================================================
// lib/domain/entities/purchase/create_purchase_request_input.dart
// CREATE PURCHASE REQUEST INPUT — Value object canónico del create path
// ============================================================================
// QUÉ HACE:
//   - Representa la entrada de creación de una PurchaseRequest, alineada al
//     contrato backend `POST /v1/purchase-requests` (avanzza-core-api).
//   - Campos canónicos: title, type, category, originType, assetId, notes,
//     delivery{department?, city, address, info?}, items[],
//     [vendorActorRefs | vendorContactIds], attestSelf?.
//
// QUÉ NO HACE:
//   - No toca `PurchaseRequestEntity` (legacy: tipoRepuesto/cantidad/ciudad).
//     Ese entity sigue siendo el shape de cache/lectura por ahora.
//   - No persiste: solo describe la intención de creación.
//
// PRINCIPIOS:
//   - Coherencia canónica 1:1 con backend (sin metadata escondida en notes).
//   - Enums cerrados para type y originType; category queda string libre.
//   - ActorRef (nuevo) y vendorContactIds (legacy) son mutuamente excluyentes
//     en wire. El controller/repo debe enviar uno, no ambos.
//
// ENTERPRISE NOTES:
//   - Wire-stable: `wireName` mapea a los valores exactos que espera el DTO
//     NestJS (PRODUCT/SERVICE/ASSET/INVENTORY/GENERAL).
//   - assetId es referencia contextual; el backend no valida tenancy de Asset.
//
// See docs/adr/0001-actor-canon.md (regla 2.13 — transición vendorContactIds).
// ============================================================================

import '../../../application/core_common/actor_ref_factory.dart';
import '../core_common/actor_ref.dart';

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

/// Snapshot mínimo persistible de la VehicleSpec seleccionada al crear una
/// solicitud para inventario/stock. Se captura al momento de envío para que
/// el registro sea auto-contenido aun si la derivación posterior cambia.
///
/// NOTA: el backend canónico HOY no acepta este bloque. Por eso el snapshot
/// vive solo en la cache local (Isar) del cliente — es la persistencia mínima
/// viable que pidió la decisión de arquitectura de negocio para esta fase.
/// Cuando el backend lo acepte, el mapper remoto sumará estos campos sin
/// romper el contrato de dominio.
class VehicleSpecSnapshotInput {
  /// ID determinístico de la spec (ej: `toyota|hilux|2022`).
  final String vehicleSpecId;

  /// Label "humano" listo para UI/BI (ej: "Toyota Hilux 2022").
  final String displayLabel;

  final String make;
  final String model;
  final int year;

  final String? version;
  final String? motorization;
  final int? engineDisplacementCc;
  final String? transmission;

  /// Cuántos vehículos reales del parque estaban vinculados a esta spec en el
  /// momento de la creación. Útil para trazabilidad/BI futura.
  final int? linkedAssetsCountSnapshot;

  const VehicleSpecSnapshotInput({
    required this.vehicleSpecId,
    required this.displayLabel,
    required this.make,
    required this.model,
    required this.year,
    this.version,
    this.motorization,
    this.engineDisplacementCc,
    this.transmission,
    this.linkedAssetsCountSnapshot,
  });
}

/// Fecha tope (RFC 3339 UTC) tras la cual [CreatePurchaseRequestInput.withLegacyContactIds]
/// debe estar retirado del código cliente. Alineada con `VENDOR_CONTACT_IDS_SUNSET_DATE`
/// del backend (avanzza-core-api).
///
/// Un test de CI dedicado falla cuando `DateTime.now() >= sunset` y el
/// factory legacy aún existe (ver test: legacy_sunset_guardrail_test.dart).
/// Eso convierte esta fecha en deuda programada: no se puede ignorar.
const String kLegacyVendorContactIdsSunsetUtc =
    '2026-07-20T00:00:00.000Z';

/// Payload canónico del create path.
///
/// ADR actor-canon (fase 1 de transición):
///   - [CreatePurchaseRequestInput.withBuiltActorRefs] es el CAMINO CANÓNICO.
///     Exige un [BuiltActorRefs] producido por [ActorRefFactory]. Blindaje
///     por TIPOS de la regla §8: nadie puede decidir `attestSelf` por fuera
///     del factory.
///   - [CreatePurchaseRequestInput.withLegacyContactIds] es el camino LEGACY
///     de transición (fase 1). Mutuamente excluyente con el canónico en
///     wire. Deprecado; se retira en fase 2 del ADR.
///   - Constructor directo es PRIVADO. No se puede construir saltándose los
///     factories → garantía de compilador.
class CreatePurchaseRequestInput {
  final String title;
  final PurchaseRequestTypeInput type;
  final String? category;
  final PurchaseRequestOriginInput originType;
  final String? assetId;
  final String? notes;
  final CreateDeliveryInput? delivery;
  final List<CreatePurchaseRequestItemInput> items;

  /// Destinatarios en contrato canónico. Null cuando se usa legacy.
  final List<ActorRef>? vendorActorRefs;

  /// LEGACY — IDs opacos de LocalContact. Null cuando se usa canónico.
  /// @deprecated usar [withBuiltActorRefs]
  final List<String>? vendorContactIds;

  /// Flag de attestation implícita. Solo lo produce [ActorRefFactory] vía
  /// [BuiltActorRefs]. En camino legacy queda siempre null.
  final bool? attestSelf;

  /// Snapshot opcional de VehicleSpec cuando `originType == inventory` y el
  /// target seleccionado es una especificación de vehículo. No se envía al
  /// backend hoy; se persiste local.
  final VehicleSpecSnapshotInput? vehicleSpec;

  /// Constructor privado. Cualquier caller externo debe usar uno de los dos
  /// factories públicos.
  const CreatePurchaseRequestInput._({
    required this.title,
    required this.type,
    this.category,
    required this.originType,
    this.assetId,
    this.notes,
    this.delivery,
    required this.items,
    this.vendorActorRefs,
    this.vendorContactIds,
    this.attestSelf,
    this.vehicleSpec,
  });

  /// CAMINO CANÓNICO (ADR actor-canon §8).
  ///
  /// Exige un [BuiltActorRefs] producido por [ActorRefFactory]. El caller
  /// NO puede elegir `attestSelf` por cuenta propia — lo fija el factory
  /// según el método que usó (`fromKnown...` vs `fromFreshlyCreated...`).
  factory CreatePurchaseRequestInput.withBuiltActorRefs({
    required String title,
    required PurchaseRequestTypeInput type,
    String? category,
    required PurchaseRequestOriginInput originType,
    String? assetId,
    String? notes,
    CreateDeliveryInput? delivery,
    required List<CreatePurchaseRequestItemInput> items,
    required BuiltActorRefs built,
    VehicleSpecSnapshotInput? vehicleSpec,
  }) {
    assert(built.refs.isNotEmpty,
        'withBuiltActorRefs: refs no puede ser vacío');
    return CreatePurchaseRequestInput._(
      title: title,
      type: type,
      category: category,
      originType: originType,
      assetId: assetId,
      notes: notes,
      delivery: delivery,
      items: items,
      vendorActorRefs: built.refs,
      attestSelf: built.attestSelf,
      vehicleSpec: vehicleSpec,
    );
  }

  /// CAMINO LEGACY (fase 1 de transición).
  ///
  /// Emite `vendorContactIds` plano. El backend responde con headers
  /// `Deprecation: true` + `Sunset: <date>`. En fase 2 se rechaza con 410.
  ///
  /// DEUDA CON FECHA: retirar antes de [kLegacyVendorContactIdsSunsetUtc].
  /// Enforcement por COMBINACIÓN (ADR §8.4), ningún eslabón individual es
  /// barrera absoluta:
  ///   1) `@Deprecated` abajo → warning del analyzer en cada uso.
  ///   2) Constante `kLegacyVendorContactIdsSunsetUtc` → valor único auditable.
  ///   3) Test `legacy_sunset_guardrail_test.dart` → falla cuando el reloj
  ///      del runner pasa la sunset (enforcement temporal).
  ///   4) ADR §8.4 → obligación documental de retirar y bajar a fase 2.
  @Deprecated(
    'Usar withBuiltActorRefs + ActorRefFactory. '
    'Retirar antes de 2026-07-20 (ADR actor-canon fase 2).',
  )
  factory CreatePurchaseRequestInput.withLegacyContactIds({
    required String title,
    required PurchaseRequestTypeInput type,
    String? category,
    required PurchaseRequestOriginInput originType,
    String? assetId,
    String? notes,
    CreateDeliveryInput? delivery,
    required List<CreatePurchaseRequestItemInput> items,
    required List<String> vendorContactIds,
    VehicleSpecSnapshotInput? vehicleSpec,
  }) {
    assert(vendorContactIds.isNotEmpty,
        'withLegacyContactIds: vendorContactIds no puede ser vacío');
    return CreatePurchaseRequestInput._(
      title: title,
      type: type,
      category: category,
      originType: originType,
      assetId: assetId,
      notes: notes,
      delivery: delivery,
      items: items,
      vendorContactIds: vendorContactIds,
      vehicleSpec: vehicleSpec,
    );
  }
}
