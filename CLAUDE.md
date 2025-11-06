# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Avanzza 2.0 is a Flutter multi-country asset management platform with offline-first architecture. It manages assets (vehicles, real estate, machinery, equipment), maintenance workflows, purchases, accounting, insurance, and includes AI-powered advisory features.

**Tech Stack:**
- Flutter + Dart (SDK >=3.4.0)
- GetX (state management & routing)
- get_it pattern via DIContainer (dependency injection)
- Isar Community (local offline database)
- Firebase (Firestore for remote sync, Auth)
- freezed + json_serializable (code generation for immutable models)

## Build & Development Commands

### Code Generation
```bash
# Clean and rebuild all generated files (freezed, json_serializable, Isar schemas)
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Windows batch scripts available
tool\build_runner.bat
tool\build_runner_watch.bat
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/data/repositories/asset_repository_impl_test.dart

# Analyze code
flutter analyze
```

### Running the App
```bash
# Standard run
flutter run

# Seed demo data (optional - see tool/README_DEMO.md)
dart run lib/seed.dart
```

## Architecture

### Clean Architecture Pattern

The codebase follows Clean Architecture with strict layer separation:

**Domain Layer** (`lib/domain/`):
- `entities/`: Immutable business entities using freezed (Asset, Organization, User, Maintenance, etc.)
- `repositories/`: Abstract repository interfaces (contracts)
- `usecases/`: Business logic use cases
- `value/`: Value objects (Money, GeoCoord, DateRange)

**Data Layer** (`lib/data/`):
- `models/`: Data models with Firestore and Isar mapping (extends domain entities)
- `sources/local/`: Isar local data sources (*_local_ds.dart)
- `sources/remote/`: Firestore remote data sources (*_remote_ds.dart)
- `repositories/`: Repository implementations (*_repository_impl.dart)
- `datasources/`: Additional data sources (e.g., registration progress)

**Presentation Layer** (`lib/presentation/`):
- `pages/`: UI pages organized by role/workspace
- `controllers/`: GetX controllers for state management
- `bindings/`: GetX dependency bindings
- `widgets/`: Reusable UI components
- `auth/`: Authentication flow pages and controllers
- `workspace/`: Role-based workspace configurations

**Core** (`lib/core/`):
- `di/container.dart`: Dependency injection setup (DIContainer singleton)
- `di/app_bindings.dart`: GetX bindings initialization
- `startup/bootstrap.dart`: App initialization (Firebase, Isar, DI, sync)
- `db/`: Isar instance, schemas, migrations
- `platform/offline_sync_service.dart`: Write queue with retry logic for offline-first
- `sync/sync_observer.dart`: Monitors connectivity and triggers sync
- `network/connectivity_service.dart`: Network connectivity monitoring
- `theme/`: App theming (colors, typography, spacing)
- `utils/`: Utilities (validators, date extensions, Firestore paths, Result type)

### Offline-First Strategy

**Critical Implementation Details:**

1. **Read Path**: All queries read from Isar (local DB) first. Remote data syncs to local in background.

2. **Write Path**: Write-through pattern - writes go to both local (Isar) and remote (Firestore) simultaneously. If offline, writes are queued in `OfflineSyncService`.

3. **Conflict Resolution**: Last-Write-Wins based on `updatedAt` timestamp with optional business logic overrides.

4. **Sync Service** (`core/platform/offline_sync_service.dart`):
   - Maintains queue of pending operations
   - Exponential backoff retry (default: 3s delay, max 5 retries)
   - Automatically drains queue when connectivity returns
   - Usage: `DIContainer().syncService.enqueue(() async { ... })`

5. **Repository Pattern**: All repositories implement local-first read with background sync:
   ```dart
   // Example pattern in repositories
   Future<AssetEntity> getAsset(String id) async {
     final local = await localDs.getAsset(id);
     // Background sync from remote
     _backgroundSync(id);
     return local;
   }
   ```

### Entity Structure

All domain entities follow these conventions:

- **Immutable**: Using `@freezed` annotation
- **Standard Fields**: `id` (String), `createdAt` (DateTime?), `updatedAt` (DateTime?)
- **Multi-Country Aware**: `countryId`, `regionId?`, `cityId?` for geo-scoped entities
- **Organization Scoped**: `orgId` for all operational data
- **Serialization**: `fromJson`/`toJson` via json_serializable

### Key Domain Entities

**Geo/Locale:**
- `CountryEntity`: ISO-3166 countries with tax, currency, timezone config
- `RegionEntity`, `CityEntity`: Hierarchical geo data
- `AddressEntity`: Multi-country addresses

**Users & Organizations:**
- `OrganizationEntity`: Support for both personal and company types
- `UserEntity`: User identity with `activeContext` (current org/role)
- `MembershipEntity`: User-Org relationship with roles and provider profiles
- `BranchEntity`: Organization branches/locations
- `ProviderProfile`: Provider segmentation (service/product types, coverage areas)

**Assets (Root Entity):**
- `AssetEntity`: Universal asset with type discrimination (vehiculos, inmuebles, maquinaria, equipos, otros)
- `AssetSegmentId`: Optional refinement (e.g., moto, auto, camión for vehicles)
- Specializations: `AssetVehiculoEntity`, `AssetInmuebleEntity`, `AssetMaquinariaEntity`
- `AssetDocumentEntity`: Asset-related documents (licenses, deeds, certificates)

**Operational Modules:**
- Maintenance: `IncidenciaEntity`, `MaintenanceProgrammingEntity`, `MaintenanceProcessEntity`, `MaintenanceFinishedEntity`
- Purchases: `PurchaseRequestEntity`, `SupplierResponseEntity`
- Accounting: `AccountingEntryEntity`, `AdjustmentEntity`
- Insurance: `InsurancePolicyEntity`, `InsurancePurchaseEntity`
- Chat: `ChatMessageEntity`, `BroadcastMessageEntity`
- AI: `AIAdvisorEntity`, `AIPredictionEntity`, `AIAuditLogEntity`

**All operational modules reference `assetId` (not vehicleId) for consistency.**

### Dependency Injection

The project uses a custom DI pattern via `DIContainer` singleton (not get_it package despite docs):

```dart
// Access container
final container = DIContainer();

// Access services
final isar = container.isar;
final firestore = container.firestore;
final syncService = container.syncService;

// Access repositories
final assetRepo = container.assetRepository;
final userRepo = container.userRepository;
```

**Initialization** happens in `bootstrap.dart`:
1. Initialize Firebase
2. Open Isar database
3. Run migrations
4. Initialize DIContainer with Isar & Firestore instances
5. Start SyncObserver for connectivity monitoring
6. Initialize GetX AppBindings

### State Management

**GetX** is used for:
- State management (reactive controllers)
- Routing and navigation
- Dependency binding for pages

**Key Controllers:**
- `AppThemeController`: Theme mode management
- `SessionContextController`: Active user session and organization context
- `RegistrationController`: Multi-step registration flow
- Role-specific controllers for each workspace (admin, owner, provider, etc.)

### Multi-Tenant & Multi-Country

**Organization Scoping:**
- All data queries filtered by `orgId`
- Firestore collections partitioned by organization
- User can have multiple memberships across organizations
- `activeContext` determines current working organization

**Geo Awareness:**
- Country/Region/City hierarchy
- Locale-specific configurations (tax rates, holidays, regulations)
- Provider coverage areas defined by geo scope
- Asset location tracking

### Role-Based Workspaces

The app supports multiple user roles with dedicated workspaces:

- **Administrador de Activos**: Home, Mantenimientos, Contabilidad, Compras, Chat
- **Propietario**: Home, Portafolio, Contratos, Contabilidad, Chat
- **Arrendatario**: Home, Pagos, Activo, Documentos, Chat
- **Proveedor de Servicios**: Home, Agenda, Órdenes, Contabilidad, Chat
- **Proveedor de Artículos**: Home, Catálogo, Cotizaciones, Órdenes, Chat
- **Aseguradora/Broker**: Home, Planes, Cotizaciones, Pólizas, Chat

Workspace configuration in `lib/presentation/workspace/workspace_config.dart`

### Authentication Flow

Multi-step onboarding:
1. Country/City selection
2. Profile type selection (Person/Company + Role)
3. Workspace exploration (no registration required)
4. First write action → triggers full registration
5. Phone verification (OTP)
6. Complete profile (username, password, optional email)
7. ID scan (optional)
8. Terms acceptance
9. Create Organization & Membership

Supports both guest exploration and authenticated workflows.

### Data Migration Notes

**Active Migration** (as of latest commits):
The codebase is migrating from `*_Id` string fields to Firestore `DocumentReference` types:

- New models include both `*_Id` (deprecated) and `*Ref` (DocumentReference) fields
- Converters in `lib/data/models/common/converters/`:
  - `doc_ref_path_converter.dart`: DocumentReference ↔ path String
  - `timestamp_converter.dart`: DateTime ↔ Firestore Timestamp
- Migration is gradual with backwards compatibility maintained
- When working with models, prefer using `*Ref` fields where available

## Important Patterns & Conventions

### Firestore Collection Paths

Use helper in `lib/core/utils/firestore_paths.dart` for consistent path construction:
- Organizations: `/organizations/{orgId}`
- Assets: `/organizations/{orgId}/assets/{assetId}`
- Maintenance: `/organizations/{orgId}/maintenance/*`
- Partitioned by orgId for multi-tenancy

### Error Handling

Use `Result<T>` type from `lib/core/utils/result.dart` for operation outcomes in domain layer.

### Date/Time Handling

- Extensions in `lib/core/utils/date_time_extensions.dart`
- Timestamp converter for Firestore compatibility
- Always use UTC for storage, convert to local for display

### Logging

Custom logger wrapper in `lib/core/log/logger.dart` with pluggable sinks.

## Testing Strategy

**Unit Tests:**
- Mapper tests (Entity ↔ Model conversion)
- Repository tests with fakes (local-first read, write-through, conflict resolution)

**Integration Tests:**
- Offline sync smoke tests (simulate airplane mode → reconnect)
- Cross-module workflow tests

**Test Files:**
- `test/data/mappers/sample_mapper_test.dart`
- `test/data/repositories/asset_repository_impl_test.dart`
- `test/sync/offline_sync_smoketest_test.dart`

## Code Generation Requirements

**Always run code generation after:**
- Adding/modifying `@freezed` entities
- Changing `@JsonSerializable` models
- Updating Isar collections (`@Collection` annotations)
- Adding new entity/model files

**Generated files (committed to repo):**
- `*.freezed.dart` - Freezed immutable classes
- `*.g.dart` - JSON serialization + Isar schemas
- `lib/core/db/isar_schemas.dart` - Isar schema registry

## Firebase Configuration

- Firebase options in `lib/firebase_options.dart` (generated by FlutterFire CLI)
- Firestore rules and indexes should be deployed separately
- Cloud Functions (if any) handle index mirrors and aggregations

## Common Development Tasks

### Adding a New Entity

1. Create entity in `lib/domain/entities/{module}/{name}_entity.dart` with `@freezed`
2. Create model in `lib/data/models/{module}/{name}_model.dart` with Firestore + Isar annotations
3. Add to repository interface if needed
4. Implement in local and remote data sources
5. Update `lib/core/db/isar_schemas.dart` to include new collection
6. Run `flutter pub run build_runner build --delete-conflicting-outputs`
7. Update repository implementation

### Adding a New Repository

1. Define interface in `lib/domain/repositories/{name}_repository.dart`
2. Implement in `lib/data/repositories/{name}_repository_impl.dart`
3. Create data sources: `lib/data/sources/local/{name}_local_ds.dart` and `remote/{name}_remote_ds.dart`
4. Register in `lib/core/di/container.dart`
5. Use offline-first pattern: read from local, background sync, write-through

### Adding a New Page/Route

1. Create page in `lib/presentation/pages/{name}_page.dart`
2. Create controller in `lib/presentation/controllers/{name}_controller.dart` (if needed)
3. Create binding in `lib/presentation/bindings/{name}_binding.dart` (if needed)
4. Add route to `lib/routes/app_pages.dart`
5. Inject repositories via `DIContainer()`

## Platform Specific Notes

**Windows:** Batch scripts in `tool/` directory for build_runner

**Development:** Uses Flutter stable channel

**Minimum SDK:** Dart >=3.4.0 <4.0.0

## Debugging Tips

- Enable Isar Inspector for local database inspection (enabled in `openIsar()`)
- Check `OfflineSyncService.pendingCount` to see queued operations
- Monitor `SyncObserver` for connectivity status changes
- Use `Logger` for consistent logging across modules
- Check `analyze_log.txt` for static analysis history
