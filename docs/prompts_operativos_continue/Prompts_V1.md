Create the following empty files (or minimal README) to scaffold the clean architecture folders. Save each file exactly at the given path:

- Save empty file to: lib/domain/entities/.gitkeep

- Save empty file to: lib/domain/repositories/.gitkeep

- Save empty file to: lib/domain/usecases/.gitkeep

- Save empty file to: lib/data/models/.gitkeep

- Save empty file to: lib/data/sources/remote/.gitkeep

- Save empty file to: lib/data/sources/local/.gitkeep

- Save empty file to: lib/data/repositories/.gitkeep

- Save empty file to: lib/presentation/controllers/.gitkeep

- Save empty file to: lib/presentation/pages/.gitkeep

- Save empty file to: lib/presentation/widgets/.gitkeep

Respond only with DONE when finished.

-------------------------------------------------------

Using IA_ARQUITECTA_PROMPT.md, generate the following Dart domain entities with freezed (+ json_serializable), including copyWith, fromJson/toJson and value objects where needed. Save each to the exact path listed:

# GEO / Locale

- CountryEntity -> lib/domain/entities/geo/country_entity.dart

- RegionEntity  -> lib/domain/entities/geo/region_entity.dart

- CityEntity    -> lib/domain/entities/geo/city_entity.dart

- LocalRegulationEntity -> lib/domain/entities/geo/local_regulation_entity.dart

- AddressEntity -> lib/domain/entities/geo/address_entity.dart

- Money (value object)  -> lib/domain/entities/common/money.dart

- DateRange (value object) -> lib/domain/entities/common/date_range.dart

- GeoCoord (value object)  -> lib/domain/entities/common/geo_coord.dart

# Users / Orgs

- OrganizationEntity -> lib/domain/entities/org/organization_entity.dart

- UserEntity         -> lib/domain/entities/user/user_entity.dart

- MembershipEntity   -> lib/domain/entities/user/membership_entity.dart

- ActiveContext      -> lib/domain/entities/user/active_context.dart

# Assets (root + specializations)

- AssetEntity              -> lib/domain/entities/asset/asset_entity.dart

- AssetDocumentEntity      -> lib/domain/entities/asset/asset_document_entity.dart

- AssetVehiculoEntity      -> lib/domain/entities/asset/special/asset_vehiculo_entity.dart

- AssetInmuebleEntity      -> lib/domain/entities/asset/special/asset_inmueble_entity.dart

- AssetMaquinariaEntity    -> lib/domain/entities/asset/special/asset_maquinaria_entity.dart

# Incidents / Maintenance

- IncidenciaEntity             -> lib/domain/entities/maintenance/incidencia_entity.dart

- MaintenanceProgrammingEntity -> lib/domain/entities/maintenance/maintenance_programming_entity.dart

- MaintenanceProcessEntity     -> lib/domain/entities/maintenance/maintenance_process_entity.dart

- MaintenanceFinishedEntity    -> lib/domain/entities/maintenance/maintenance_finished_entity.dart

# Purchases

- PurchaseRequestEntity  -> lib/domain/entities/purchase/purchase_request_entity.dart

- SupplierResponseEntity -> lib/domain/entities/purchase/supplier_response_entity.dart

# Accounting

- AccountingEntryEntity  -> lib/domain/entities/accounting/accounting_entry_entity.dart

- AdjustmentEntity       -> lib/domain/entities/accounting/adjustment_entity.dart

# Insurance

- InsurancePolicyEntity   -> lib/domain/entities/insurance/insurance_policy_entity.dart

- InsurancePurchaseEntity -> lib/domain/entities/insurance/insurance_purchase_entity.dart

# Chat

- ChatMessageEntity     -> lib/domain/entities/chat/chat_message_entity.dart

- BroadcastMessageEntity-> lib/domain/entities/chat/broadcast_message_entity.dart

# AI Transversal

- AIAdvisorEntity    -> lib/domain/entities/ai/ai_advisor_entity.dart

- AIPredictionEntity -> lib/domain/entities/ai/ai_prediction_entity.dart

- AIAuditLogEntity   -> lib/domain/entities/ai/ai_audit_log_entity.dart

When finished saving all files, reply only with DONE.

-------------------------------------------

/agent

Create the following repository interfaces (pure Dart, no imports from Firebase/Isar). Save to:

- GeoRepository           -> lib/domain/repositories/geo_repository.dart

- OrgRepository           -> lib/domain/repositories/org_repository.dart

- UserRepository          -> lib/domain/repositories/user_repository.dart

- AssetRepository         -> lib/domain/repositories/asset_repository.dart

- MaintenanceRepository   -> lib/domain/repositories/maintenance_repository.dart

- PurchaseRepository      -> lib/domain/repositories/purchase_repository.dart

- AccountingRepository    -> lib/domain/repositories/accounting_repository.dart

- InsuranceRepository     -> lib/domain/repositories/insurance_repository.dart

- ChatRepository          -> lib/domain/repositories/chat_repository.dart

- AIRepository            -> lib/domain/repositories/ai_repository.dart

Each interface must expose the methods described in IA_ARQUITECTA_PROMPT.md (list/get/create/update, filters by orgId/countryId/cityId/assetId, offline-first friendly signatures). Reply only with DONE when saved.

---------------------------------------------

For each corresponding domain entity, generate a data model with:

- Firestore mapping (toJson/fromJson, docId)

- Isar mapping (@Collection, ids, indexes)

- Converters to/from the domain entity

Save to:

# GEO / Locale

- country_model.dart           -> lib/data/models/geo/country_model.dart

- region_model.dart            -> lib/data/models/geo/region_model.dart

- city_model.dart              -> lib/data/models/geo/city_model.dart

- local_regulation_model.dart  -> lib/data/models/geo/local_regulation_model.dart

- address_model.dart           -> lib/data/models/geo/address_model.dart

- money_model.dart             -> lib/data/models/common/money_model.dart

- date_range_model.dart        -> lib/data/models/common/date_range_model.dart

- geo_coord_model.dart         -> lib/data/models/common/geo_coord_model.dart

# Users / Orgs

- organization_model.dart -> lib/data/models/org/organization_model.dart

- user_model.dart         -> lib/data/models/user/user_model.dart

- membership_model.dart   -> lib/data/models/user/membership_model.dart

- active_context_model.dart -> lib/data/models/user/active_context_model.dart

# Assets

- asset_model.dart              -> lib/data/models/asset/asset_model.dart

- asset_document_model.dart     -> lib/data/models/asset/asset_document_model.dart

- asset_vehiculo_model.dart     -> lib/data/models/asset/special/asset_vehiculo_model.dart

- asset_inmueble_model.dart     -> lib/data/models/asset/special/asset_inmueble_model.dart

- asset_maquinaria_model.dart   -> lib/data/models/asset/special/asset_maquinaria_model.dart

# Maintenance

- incidencia_model.dart                -> lib/data/models/maintenance/incidencia_model.dart

- maintenance_programming_model.dart   -> lib/data/models/maintenance/maintenance_programming_model.dart

- maintenance_process_model.dart       -> lib/data/models/maintenance/maintenance_process_model.dart

- maintenance_finished_model.dart      -> lib/data/models/maintenance/maintenance_finished_model.dart

# Purchases

- purchase_request_model.dart  -> lib/data/models/purchase/purchase_request_model.dart

- supplier_response_model.dart -> lib/data/models/purchase/supplier_response_model.dart

# Accounting

- accounting_entry_model.dart  -> lib/data/models/accounting/accounting_entry_model.dart

- adjustment_model.dart        -> lib/data/models/accounting/adjustment_model.dart

# Insurance

- insurance_policy_model.dart   -> lib/data/models/insurance/insurance_policy_model.dart

- insurance_purchase_model.dart -> lib/data/models/insurance/insurance_purchase_model.dart

# Chat

- chat_message_model.dart      -> lib/data/models/chat/chat_message_model.dart

- broadcast_message_model.dart -> lib/data/models/chat/broadcast_message_model.dart

# AI

- ai_advisor_model.dart    -> lib/data/models/ai/ai_advisor_model.dart

- ai_prediction_model.dart -> lib/data/models/ai/ai_prediction_model.dart

- ai_audit_log_model.dart  -> lib/data/models/ai/ai_audit_log_model.dart

When finished saving all files, reply only with DONE.

----------------------------------------------

For each corresponding domain entity, generate a data model with:

- Firestore mapping (toJson/fromJson, docId)

- Isar mapping (@Collection, ids, indexes)

- Converters to/from the domain entity

Save to:



- AssetMaquinariaEntity    -> lib/domain/entities/asset/special/asset_maquinaria_entity.dart

# Incidents / Maintenance

- IncidenciaEntity             -> lib/domain/entities/maintenance/incidencia_entity.dart

- MaintenanceProgrammingEntity -> lib/domain/entities/maintenance/maintenance_programming_entity.dart

- MaintenanceProcessEntity     -> lib/domain/entities/maintenance/maintenance_process_entity.dart

- MaintenanceFinishedEntity    -> lib/domain/entities/maintenance/maintenance_finished_entity.dart

# Purchases

- PurchaseRequestEntity  -> lib/domain/entities/purchase/purchase_request_entity.dart

- SupplierResponseEntity -> lib/domain/entities/purchase/supplier_response_entity.dart

# Accounting

- AccountingEntryEntity  -> lib/domain/entities/accounting/accounting_entry_entity.dart

- AdjustmentEntity       -> lib/domain/entities/accounting/adjustment_entity.dart

# Insurance

- InsurancePolicyEntity   -> lib/domain/entities/insurance/insurance_policy_entity.dart

- InsurancePurchaseEntity -> lib/domain/entities/insurance/insurance_purchase_entity.dart

# Chat

- ChatMessageEntity     -> lib/domain/entities/chat/chat_message_entity.dart

- BroadcastMessageEntity-> lib/domain/entities/chat/broadcast_message_entity.dart

# AI Transversal

- AIAdvisorEntity    -> lib/domain/entities/ai/ai_advisor_entity.dart

- AIPredictionEntity -> lib/domain/entities/ai/ai_prediction_entity.dart

- AIAuditLogEntity   -> lib/domain/entities/ai/ai_audit_log_entity.dart

When finished saving all files, reply only with DONE.

---------------------------------------------------

Generate Firestore remote data sources and Isar local data sources with the following files:

# Remote (Firestore)

- geo_remote_ds.dart          -> lib/data/sources/remote/geo_remote_ds.dart

- org_remote_ds.dart          -> lib/data/sources/remote/org_remote_ds.dart

- user_remote_ds.dart         -> lib/data/sources/remote/user_remote_ds.dart

- asset_remote_ds.dart        -> lib/data/sources/remote/asset_remote_ds.dart

- maintenance_remote_ds.dart  -> lib/data/sources/remote/maintenance_remote_ds.dart

- purchase_remote_ds.dart     -> lib/data/sources/remote/purchase_remote_ds.dart

- accounting_remote_ds.dart   -> lib/data/sources/remote/accounting_remote_ds.dart

- insurance_remote_ds.dart    -> lib/data/sources/remote/insurance_remote_ds.dart

- chat_remote_ds.dart         -> lib/data/sources/remote/chat_remote_ds.dart

- ai_remote_ds.dart           -> lib/data/sources/remote/ai_remote_ds.dart

# Local (Isar)

- geo_local_ds.dart           -> lib/data/sources/local/geo_local_ds.dart

- org_local_ds.dart           -> lib/data/sources/local/org_local_ds.dart

- user_local_ds.dart          -> lib/data/sources/local/user_local_ds.dart

- asset_local_ds.dart         -> lib/data/sources/local/asset_local_ds.dart

- maintenance_local_ds.dart   -> lib/data/sources/local/maintenance_local_ds.dart

- purchase_local_ds.dart      -> lib/data/sources/local/purchase_local_ds.dart

- accounting_local_ds.dart    -> lib/data/sources/local/accounting_local_ds.dart

- insurance_local_ds.dart     -> lib/data/sources/local/insurance_local_ds.dart

- chat_local_ds.dart          -> lib/data/sources/local/chat_local_ds.dart

- ai_local_ds.dart            -> lib/data/sources/local/ai_local_ds.dart

Each DS exposes CRUD and list queries scoped by orgId (+ filters countryId/cityId/assetId). No UI. Reply ONLY with DONE after saving.

-----------------------------------------------------------

Implement repositories that depend on the data sources above, with offline-first policy:

- read: local first + background sync

- write: write-through (local + remote) with conflict resolution (updatedAt)

Save to:

- geo_repository_impl.dart         -> lib/data/repositories/geo_repository_impl.dart

- org_repository_impl.dart         -> lib/data/repositories/org_repository_impl.dart

- user_repository_impl.dart        -> lib/data/repositories/user_repository_impl.dart

- asset_repository_impl.dart       -> lib/data/repositories/asset_repository_impl.dart

- maintenance_repository_impl.dart -> lib/data/repositories/maintenance_repository_impl.dart

- purchase_repository_impl.dart    -> lib/data/repositories/purchase_repository_impl.dart

- accounting_repository_impl.dart  -> lib/data/repositories/accounting_repository_impl.dart

- insurance_repository_impl.dart   -> lib/data/repositories/insurance_repository_impl.dart

- chat_repository_impl.dart        -> lib/data/repositories/chat_repository_impl.dart

- ai_repository_impl.dart          -> lib/data/repositories/ai_repository_impl.dart

Use DI-friendly constructors. Return domain entities, not data models. Reply only with DONE.

------------------------------------------------

Generate:

- SessionContextController (GetX): manages activeContext and memberships, persists to Isar and mirrors /usuarios/{uid}.activeContext in Firestore.

  Save to: lib/presentation/controllers/session_context_controller.dart

- A small OfflineSyncService (queue + retries) used by repositories to sync when connectivity returns.

  Save to: lib/core/platform/offline_sync_service.dart

- FirestorePaths helper with all collection paths for Avanzza 2.0

  Save to: lib/core/utils/firestore_paths.dart

Reply only with DONE after saving.

-----------------------------------------

/agent arquitecta

You have write access to the workspace. For each file, OVERWRITE the whole file content (no patches, no SEARCH/REPLACE, no code fences). Create parent folders if needed. Do NOT print code in chat; just write to disk and reply only with DONE.

Files to write:

- lib/data/repositories/accounting_repository_impl.dart

- lib/data/repositories/insurance_repository_impl.dart

Requirements:

- Implement offline-first: read = local-first with background sync; write = write-through local+remote; resolve conflicts by updatedAt (keep newest).

- Depend only on the data sources we defined (local/remote) and return **domain entities**, never data models.

- Constructors DI-friendly (receive the needed data sources).

- Include minimal error handling and simple logger hooks (TODOs ok).

- Use orgId and (where relevant) countryId/cityId/assetId scoping.

Final response: DONE

--------------------------------------------------------
/agent arquitecta

(overwrite files, same rules)

Files to write:

- lib/data/repositories/geo_repository_impl.dart

- lib/data/repositories/org_repository_impl.dart

- lib/data/repositories/user_repository_impl.dart

- lib/data/repositories/asset_repository_impl.dart

- lib/data/repositories/maintenance_repository_impl.dart

- lib/data/repositories/purchase_repository_impl.dart

Final response: DONE

-------------------------------------------------------------

/agent arquitecta

Generate Firestore security rules for Avanzza 2.0, enforcing:

- Membership check at /orgs/{orgId}/members/{uid} with estatus="activo".

- Role checks per collection (read/write) for assets, incidencias, maintenance, purchases, accounting, insurance, chat, ai_*.

- Scope queries by orgId; deny cross-org access.

- idx_* collections: read-only for clients; writes only by Cloud Functions (request.auth.token.admin_cf == true or service).

- Basic geo-consistency (countryId/cityId must match origin asset/org when present).

Save to:

firebase/firestore.rules

Also generate Firestore indexes:

- The set described in our data design (incidencias by estado+createdAt, assets by assetType+estado, etc.).

Save to:

firebase/firestore.indexes.json

Reply only with DONE.

--------------------------------------------------------------

/agent arquitecta

Create Cloud Functions (TypeScript) for:

- onWrite of assets/incidencias/maintenance/docs/purchases/accounting to maintain idx_* mirrors under /orgs/{orgId}/idx_*.

- Monthly accounting summaries under /orgs/{orgId}/summaries/{YYYY-MM}.

- Mark CF requests with an admin claim for idx_* writes.

Project layout:

functions/

  src/index.ts

  src/idx/...

  src/summaries/...

  src/utils/paths.ts

  src/utils/guards.ts

  package.json

  tsconfig.json

Save all files under the paths above. Keep code modular and testable.

Reply only with DONE.

---------------------------------------------------------------------
/agent arquitecta

You have write access. OVERWRITE whole files (no patches, no code in chat). Create parents as needed. Reply only with DONE.

Files to write:

- functions/src/utils/paths.ts

- functions/src/utils/guards.ts

- functions/src/idx/onAssetWrite.ts

- functions/src/idx/onIncidenciaWrite.ts

- functions/src/idx/onMaintenanceWrite.ts

- functions/src/idx/onDocumentWrite.ts

- functions/src/idx/onPurchaseWrite.ts

- functions/src/idx/onAccountingWrite.ts

--------------------------------------------------

/agent arquitecta

Save the following literal text into tool/build_runner.sh:

---file---

#!/bin/bash

# Clean and rebuild generated files

fvm flutter pub run build_runner clean

fvm flutter pub run build_runner build --delete-conflicting-outputs

---end---

Reply only with DONE.

---------------------------

/agent arquitecta

Save the following literal text into tool/build_runner_watch.sh:

---file---

#!/bin/bash

# Continuous codegen while developing

fvm flutter pub run build_runner watch --delete-conflicting-outputs

---end---

Reply only with DONE.




