import 'package:isar_community/isar.dart';

// Increase when breaking Isar schema changes are introduced.
//
// History:
//   v1 → initial schema.
//   v2 → OrganizationModel.capabilityProfilesJson added (nullable String,
//        retro-compatible: registros existentes lo verán null y la entity
//        reconstruye `capabilityProfiles: []` por default). No requiere
//        backfill de datos.
//   v3 → PortfolioModel.expectedRelationKindWire added (nullable String,
//        wire-stable AssetActorRole). Y AssetActorRole gana valor 'manager'
//        (append-only). Registros previos lo verán null y la entity
//        reconstruye `expectedRelationKind: null` por default.
//        Wire desconocido en lectura ⇒ tryFromWire devuelve null sin lanzar.
//        No requiere backfill de datos.
//   v4 → BootstrapSyncStateModel collection added (nueva colección).
//        Estado persistente del POST /v1/bootstrap (1 fila por userId).
//        Aditivo puro — usuarios existentes la verán vacía hasta el primer
//        sync. No requiere backfill.
//   v5 → BootstrapSyncStateModel.payloadJson añadido (nullable String).
//        Persiste el `UnifiedBootstrapRequestDto` para que el retry
//        sobreviva a kills sin requerir que el caller esté vivo.
//        Filas v4 existentes lo verán null y el controller las trata como
//        "sin payload retryable" — el banner muestra FAILED hasta que el
//        próximo `start()` provea payload nuevo.
const int schemaVersion = 5;

typedef MigrationStep = Future<void> Function(Isar isar);

final List<MigrationStep> _migrations = <MigrationStep>[
  // v1 → v2: añadido OrganizationModel.capabilityProfilesJson.
  // No hay data migration: el campo es nullable y los registros previos
  // se interpretan como "sin capabilities" (lista vacía en domain).
  // Se mantiene este step explícito para trazabilidad del bump.
  (isar) async {},
  // v2 → v3: añadido PortfolioModel.expectedRelationKindWire + AssetActorRole.manager.
  // No hay data migration: campo nullable; registros previos lo verán null y
  // se interpretan como "relación no declarada" en domain.
  (isar) async {},
  // v3 → v4: añadida colección BootstrapSyncStateModel (estado persistente
  // del sync de fondo). Aditivo puro — Isar crea la colección la primera
  // vez que se escribe; no hay backfill necesario.
  (isar) async {},
  // v4 → v5: añadido BootstrapSyncStateModel.payloadJson (nullable).
  // Aditivo puro — filas existentes lo verán null y el controller las
  // trata como "sin payload retryable".
  (isar) async {},
];

Future<void> runMigrations(Isar isar) async {
  for (final m in _migrations) {
    await m(isar);
  }
}
