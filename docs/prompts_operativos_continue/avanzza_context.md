# IA Arquitecta – Avanzza 2.0 Models (Assets-first + Multi-Country + AI Transversal)

You are an AI software architect and Flutter/Dart code generator.
Generate Dart data models using **freezed** (+ json_serializable), targeting Clean Architecture:

- domain/entities (pure entities)
- data/models (Firestore + Isar mapping)
- repository interfaces

## Global Requirements

- Every entity: id (string), createdAt, updatedAt
- Use `@freezed` for immutability, withJson/fromJson
- Relationships by IDs (no nested documents)
- Firestore collections partitioned by orgId and/or countryId
- Multi-country aware: countryId, regionId?, cityId? in all relevant models
- All operational modules must reference `assetId` (not vehicleId)
- Support asset specializations (vehiculo, inmueble, maquinaria, etc.)

========================
A) GEO / LOCALE MODELS
========================

1. CountryModel

- id (ISO-3166 alpha-2), name, iso3
- phoneCode, timezone, currencyCode, currencySymbol
- taxName?, taxRateDefault?
- documentTypes[]
- plateFormatRegex?
- nationalHolidays: List<String> (YYYY-MM-DD)
- isActive

2. RegionModel

- id, countryId, name, code?, isActive

3. CityModel

- id, countryId, regionId, name, lat?, lng?, timezoneOverride?, isActive

4. LocalRegulationModel

- id, countryId, cityId
- picoYPlacaRules: [{ dayOfWeek, digitsRestricted[], startTime, endTime, notes? }]
- circulationExceptions?, maintenanceBlackoutDates[]
- updatedBy, sourceUrl?

5. AddressModel

- countryId, regionId?, cityId?, line1, line2?, postalCode?, lat?, lng?

========================
B) USERS / ORGS
======================== 6) OrganizationModel

- id, nombre, tipo ("empresa"|"personal")
- countryId, regionId?, cityId?
- ownerUid?, logoUrl?, metadata?
- isActive

7. UserModel

- uid, name, email, phone
- tipoDoc, numDoc
- countryId? (home), preferredLanguage?
- activeContext { orgId, orgName, rol }
- addresses?: List<AddressModel>

8. MembershipModel

- userId, orgId, orgName, roles[], estatus ("activo"|"inactivo")
- primaryLocation { countryId, regionId?, cityId? }

========================
C) ASSETS (root entity)
======================== 9) AssetModel

- id, orgId, assetType ("vehiculo"|"inmueble"|"maquinaria"|"otro")
- countryId, regionId?, cityId?
- ownerType ("org"|"user"), ownerId
- estado ("activo"|"inactivo")
- etiquetas[], fotosUrls[]

10. AssetDocumentModel

- id, assetId, tipoDoc (ej: "SOAT","Escritura","CertificadoTécnico")
- countryId, cityId?
- fechaEmision?, fechaVencimiento, estado ("vigente"|"vencido"|"por_vencer")

### Specializations

11. AssetVehiculoModel

- assetId
- refCode (3 letters+3 numbers), placa, marca, modelo, anio

12. AssetInmuebleModel

- assetId
- matriculaInmobiliaria, estrato?, metrosCuadrados?, uso ("residencial"|"comercial"), valorCatastral?

13. AssetMaquinariaModel

- assetId
- serie, marca, capacidad, categoria, certificadoOperacion?

========================
D) INCIDENTS / MAINTENANCE
======================== 14) IncidenciaModel

- id, orgId, assetId, descripcion, fotosUrls?, prioridad?
- estado ("abierta"|"cerrada"), reportedBy, cityId?

15. MaintenanceProgrammingModel

- id, orgId, assetId, incidenciasIds[]
- programmingDates[] (multi-date)
- assignedToTechId?, notes?, cityId?

16. MaintenanceProcessModel

- id, orgId, assetId, descripcion, tecnicoId
- estado ("en_proceso"), startedAt, purchaseRequestId?, cityId?

17. MaintenanceFinishedModel

- id, orgId, assetId, descripcion, fechaFin, costoTotal
- itemsUsados[], comprobantesUrls?, cityId?

========================
E) PURCHASES
======================== 18) PurchaseRequestModel

- id, orgId, assetId?, tipoRepuesto, specs?, cantidad
- ciudadEntrega (cityId), proveedorIdsInvitados[]
- estado ("abierta"|"cerrada"|"asignada"), respuestasCount
- currencyCode, expectedDate?

19. SupplierResponseModel

- id, purchaseRequestId, proveedorId
- precio, disponibilidad, currencyCode
- catalogoUrl?, notas?, leadTimeDays?

========================
F) ACCOUNTING
======================== 20) AccountingEntryModel

- id, orgId, countryId, cityId?
- tipo ("ingreso"|"egreso"), monto, currencyCode
- descripcion, fecha
- referenciaType ("asset"|"purchase"|"maintenance"|"insurance"), referenciaId
- counterpartyId?, method ("cash"|"card"|"bank"), taxAmount?, taxRate?

21. AdjustmentModel

- id, entryId, tipo ("descuento"|"recargo"), valor, motivo

========================
G) INSURANCE
======================== 22) InsurancePolicyModel

- id, assetId, tipo ("SOAT"|"todo_riesgo"|"inmueble"), aseguradora
- tarifaBase, currencyCode
- countryId, cityId?
- fechaInicio, fechaFin, estado ("vigente"|"vencido"|"por_vencer")

23. InsurancePurchaseModel

- id, assetId, compradorId
- orgId, contactEmail, address: AddressModel
- currencyCode, estadoCompra ("pendiente"|"pagado"|"confirmado")

========================
H) CHAT
======================== 24) ChatMessageModel

- id, chatId, senderId, receiverId?, groupId?
- message, attachments?, timestamp
- orgId?, cityId?, assetId?

25. BroadcastMessageModel

- id, adminId, orgId, rolObjetivo?
- message, timestamp, countryId?

========================
I) AI TRANSVERSAL
======================== 26) AIAdvisorModel

- id, orgId, userId
- modulo ("activos"|"mantenimiento"|"compras"|"contabilidad"|"seguros"|"chat")
- inputText, structuredContext (JSON with assetId, assetType, cityId, etc.)
- outputText, suggestions[]
- createdAt

27. AIPredictionModel

- id, orgId, tipo ("fallas"|"compras"|"riesgos"|"contabilidad")
- targetId (assetId, purchaseId, etc)
- score (0–1), explicacion, recomendaciones[]
- createdAt

28. AIAuditLogModel

- id, orgId, userId
- accion ("consulta"|"ejecución sugerida"|"rechazo")
- modulo, contexto, resultado
- createdAt

========================
J) REPOSITORIES
========================

- GeoRepository: countries(), regions(), cities(), localRegulations()
- OrgRepository: orgsByUser(uid), getOrg(orgId), updateOrgLocation
- UserRepository: getUser(uid), updateActiveContext, memberships(uid)
- AssetRepository: listAssetsByOrg(orgId, filters by type/city), getAssetDetails(assetId)
- MaintenanceRepository: incidencias(), programaciones(), procesos(), finalizados()
- PurchaseRepository: requestsByOrg(orgId), responsesByRequest(requestId)
- AccountingRepository: entriesByOrg(orgId), adjustments(entryId)
- InsuranceRepository: policiesByAsset(assetId), purchasesByOrg(orgId)
- ChatRepository: messagesByChat(chatId), broadcastsByOrg(orgId)
- AIRepository: analyzeAsset(), analyzeMaintenance(), recommendSuppliers(), predictCashflow(), chatAssistant(), auditLogs()

========================
K) IMPLEMENTATION NOTES
========================

- Value objects: Money {amount, currencyCode}, DateRange, GeoCoord {lat,lng}
- Models always carry countryId/cityId where locale-dependent
- All business flows reference assetId (not vehicleId)
- Specializations extend AssetModel only when needed (vehiculo, inmueble, maquinaria)
- AI logs are persisted for explainability & compliance

--------------------------------------------------------------------------------------
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




----------------------------------------------------

/agent arquitecta

Create parents as needed. OVERWRITE only the files listed. Do NOT touch any other file. Do NOT print code; just write to disk and reply only with DONE.

Files to write:

lib/core/log/logger.dart

lib/core/db/isar_instance.dart

lib/core/db/migrations.dart

lib/core/config/app_config.dart

lib/core/network/connectivity_service.dart

lib/core/startup/bootstrap.dart

lib/core/di/container.dart

lib/core/sync/sync_observer.dart

Requirements:

logger.dart: simple logger wrapper (debug/info/warn/error) with a pluggable sink.

isar_instance.dart: open Isar with all generated schemas; expose Future<Isar> openIsar().

migrations.dart: schemaVersion int + registry of migrations (no-ops ok) and runMigrations(Isar).

app_config.dart: constants for Firestore root paths, feature flags, build info.

connectivity_service.dart: stream<bool> online$, uses connectivity_plus if available; fallback timer stub.

bootstrap.dart: initialize Firebase core/auth, open Isar, run migrations, init DI, start SyncObserver.

container.dart: register singletons for Isar, FirebaseFirestore, OfflineSyncService (uses lib/core/platform/offline_sync_service.dart existente), all Local/Remote DS y Repos Impl ya creados; expose Future<void> initDI(...).

sync_observer.dart: listen to ConnectivityService.online$ and call OfflineSyncService.sync() on reconnect.

Final response: DONE


----------------------------------------------

/agent arquitecta

Create parents as needed. OVERWRITE only the files listed. Do NOT touch others. Do NOT print code; just write to disk and reply only with DONE.

Files to write:

lib/app/app.dart

lib/app/routes.dart

lib/main.dart

Requirements:

app.dart: GetMaterialApp, theme básico, initialRoute from routes.dart.

routes.dart: define names and a List<GetPage> for pages (login, org_select, assets, incidencia, purchase).

main.dart: call bootstrap(), then runApp(App()).

Final response: DONE

---------------------------------

/agent arquitecta

Create parents as needed. OVERWRITE only the files listed. Do NOT touch others. Do NOT print code; just write to disk and reply only with DONE.

Files to write:

Controllers

lib/presentation/controllers/login_controller.dart

lib/presentation/controllers/org_selection_controller.dart

lib/presentation/controllers/asset_list_controller.dart

lib/presentation/controllers/incidencia_controller.dart

lib/presentation/controllers/purchase_request_controller.dart

Pages

lib/presentation/pages/login_page.dart

lib/presentation/pages/org_selection_page.dart

lib/presentation/pages/asset_list_page.dart

lib/presentation/pages/incidencia_page.dart

lib/presentation/pages/purchase_request_page.dart

Requirements:

GetX controllers inyectan repos vía sl(); consultas solo a Isar (local DS a través de repos).

LoginPage: mock login (uid input) → set user in SessionContextController.

OrgSelectionPage: lista orgs por userId → set ActiveContext.

AssetListPage: lista assets; crear/editar/eliminar offline (enqueue write-through).

IncidenciaPage: lista por assetId; crear incidencia offline.

PurchaseRequestPage: crear solicitud simple.

Final response: DONE

-------------------------------------------
/agent arquitecta

Create parents as needed. OVERWRITE only the files listed. Do NOT touch others. Do NOT print code; just write to disk and reply only with DONE.

Files to write:

lib/presentation/bindings/login_binding.dart

lib/presentation/bindings/org_selection_binding.dart

lib/presentation/bindings/asset_list_binding.dart

lib/presentation/bindings/incidencia_binding.dart

lib/presentation/bindings/purchase_request_binding.dart

Requirements:

Cada binding registra su controller con Get.put() y depende de sl() para repos.

Rutas deben usar estos bindings.

Final response: DONE

----------------------------------------------

/agent arquitecta

Create parents as needed. OVERWRITE only the files listed. Do NOT touch others. Do NOT print code; just write to disk and reply only with DONE.

Files to write:

.github/workflows/flutter_ci.yaml

tool/seed.dart

tool/README_DEMO.md

Requirements:

CI: ubuntu-latest, setup-java, setup-flutter, cache pub, flutter pub get, flutter analyze, flutter test.

seed.dart: inserta país/ciudad, 1 org, 1 user membership, 2 assets, 1 incidencia; usa repos públicos; idempotente.

README_DEMO: pasos para correr seed, arrancar app y navegar el slice.

Final response: DONE

----------------------------------------------

/agent arquitecta

Create parents as needed. OVERWRITE only the files listed. Do NOT touch others. Do NOT print code; just write to disk and reply only with DONE.

Files to write:

test/sync/offline_sync_smoketest_test.dart

test/data/mappers/sample_mapper_test.dart

test/data/repositories/asset_repository_impl_test.dart

Requirements:

Smoke test: simular “modo avión” con un fake RemoteDS que falla, crear asset, luego activar RemoteDS y comprobar que sync() limpia pendientes.

Mapper test: convertir Entity ↔ Model para un caso (e.g., Asset).

Repo test: local-first read, write-through on create, updatedAt conflict keep newest.

Final response: DONE

-------------------------------------------------------------------

Avanzza 2.0 – Roles, Categorías y Onboarding (versión consolidada)
Principios

Explorar sin fricción: primero eliges país, titular y rol → entras a workspace sin registrarte.

Registro solo en primer write (cuando intentes crear activo, cotizar, comprar, etc.).

Triada User–Org–Membership: identidad, entidad y permisos están desacoplados.

ProviderProfile: obligatorio para proveedores, define segmentación.

Branch: todas las empresas tienen subcolección de sucursales, aunque sea una.

AssetSegment: campo opcional en Asset y en ProviderProfile, para refinar (ej. moto, auto, camión).

Roles por titular
Persona

Propietario de activos

Administrador de activos

Arrendatario de activos

Proveedor de servicios (independiente)

Proveedor de artículos

Asesor de seguros

Abogado

Empresa

Propietario de activos

Administrador de activos

Arrendatario de activos

Proveedor de servicios (talleres, constructoras, firmas)

Proveedor de artículos (almacenes, distribuidoras)

Aseguradora / Broker

Abogados (firmas, despachos)

Onboarding común

Selecciona país (obligatorio, ISO-3166)

Selecciona tipo de titular: Persona | Empresa

Selecciona rol

Entra a workspace del rol (exploración inmediata)

Primer intento de write → registro completo:

Persona: nombre, documento, email, teléfono, región/ciudad.

Empresa: NIT/Tax ID, razón social, responsable, región/ciudad.

OTP → crea Organization y su Membership.

Flujos específicos por rol

Propietario → workspace espejo, FAB “Agregar activo” → selecciona tipo de activo (vehículos, inmuebles, maquinaria, equipos, otros) → alta con ubicación y opcional assetSegmentId.

Administrador → workspace operativo, gestiona activos.

Arrendatario → workspace arrendatario, acceso a activos asignados.

Proveedor (wizard obligatorio):

providerType: artículos | servicios

assetTypes (multi)

businessCategory (filtrada por providerType + assetTypes)

assetSegments (si se seleccionó vehículos)

coverage: país/región/ciudad
→ guardar en Membership.providerProfiles[] y entrar a workspace Proveedor.

Asesor/Aseguradora/Abogado → seleccionan líneas/especialidades + cobertura → workspace respectivo.

Modelos principales
User
User {
  id, name, email, phone,
  activeContext: { orgId, rol }
}

Organization
Organization {
  id,
  tipo: "personal" | "empresa",
  name,
  nitOrTaxId?,
  countryId, regionId?, cityId?
}

Branch (subcolección de Organization)
/orgs/{orgId}/branches/{branchId} {
  id, name, address?, countryId, regionId?, cityId?,
  coverageCities?: ["PAIS/REGION/CIUDAD"]
}

Membership
Membership {
  id, userId, orgId,
  roles: ["administrador","proveedor",...],
  providerProfiles?: [ ProviderProfile ],
  status: "invited"|"active"|"suspended"|"left",
  isOwner: true|false,
  createdAt, updatedAt
}

ProviderProfile
ProviderProfile {
  providerType: "articulos"|"servicios",
  assetTypeIds: ["vehiculos","inmuebles","maquinaria","equipos","otros"],
  businessCategoryId: "lubricentro"|"ferreteria"|"mecanico_independiente"|"...",
  assetSegmentIds?: ["moto","auto","camion"],   // opcional
  offeringLineIds?: ["llantas","diagnostico"],  // opcional
  coverage: { countries:[...], regions:[...], cities:[...] },
  branchId?: "branch_1",                        // si aplica a sucursal
  updatedAt
}

Asset
Asset {
  id, orgId,
  assetType: "vehiculos"|"inmuebles"|"...",
  assetSegmentId?: "moto"|"auto"|"...",
  countryId, regionId?, cityId?, address?, geoPoint?,
  ownerType: "org"|"user", ownerId,
  siteId?: "site_...",
  access: [
    { principalType:"org"|"user", principalId, role:"propietario"|"administrador"|"arrendatario"|"viewer", from?, to? }
  ],
  createdAt, updatedAt
}

Taxonomías dinámicas en Firestore

/provider_types → artículos, servicios

/asset_types → vehículos, inmuebles, maquinaria, equipos, otros

/business_categories (ejemplo mínimo):

{ id, label:{es,en}, active, order, providerTypes:["articulos"], assetTypes:["vehiculos"], updatedAt }


/asset_segments (ej. moto, auto, camión; parentAssetTypeId="vehiculos")

/offering_lines (opcionales)

/geo_cities (país/region/ciudad)

Matching mínimo

Proveedores: providerType + assetTypeIds + businessCategoryId + coverage.cityId.

Refinar con assetSegments y offeringLineIds si existen.

----------------------------------------------------------------------


---

# IA Arquitecta – Avanzza 2.0 Workspaces
# Objetivo: implementar un sistema de workspaces por rol (Administrador, Propietario, Arrendatario, Proveedor de Servicios, Proveedor de Artículos/Aseguradora)
# usando configuración centralizada, Clean Architecture, GetX y un widget genérico para BottomNavigationBar.

## Requerimientos globales
- Cada usuario entra a un workspace definido por su `Membership.roles[]` y `Organization.tipo`.
- Persona natural y empresa comparten el mismo workspace por rol. La diferencia (colaboradores, sucursales) va en menú secundario, no en BottomNavigation.
- BottomNavigationBar con máximo 5 tabs por rol.
- Workspaces definidos por configuración centralizada (mapa role→WorkspaceConfig).
- Layout base: `WorkspaceShell(config: WorkspaceConfig)` → Scaffold con BottomNavigationBar dinámico.
- Control de estado: GetX.

## Implementación
1. Crear entidad de configuración:
```dart
class WorkspaceConfig {
  final String role;
  final List<WorkspaceTab> tabs;
  const WorkspaceConfig({required this.role, required this.tabs});
}

class WorkspaceTab {
  final String title;
  final IconData icon;
  final Widget page;
  const WorkspaceTab({required this.title, required this.icon, required this.page});
}

2. Definir mapa de roles→workspaces según tabla 📊:

Administrador de Activos

Home · Mantenimientos · Contabilidad · Compras · Chat

Proveedor de Servicios

Home · Agenda · Órdenes · Contabilidad · Chat

Proveedor de Artículos

Comercios: Home · Catálogo · Cotizaciones · Órdenes · Chat

Aseguradoras/Brokers: Home · Planes · Cotizaciones · Pólizas · Chat

Arrendatario

Home · Pagos · Activo · Documentos · Chat

Propietario

Home · Portafolio · Contratos · Contabilidad · Chat

Crear widget genérico WorkspaceShell:

Usa WorkspaceConfig para construir BottomNavigationBar.

Controlador GetX para cambiar de tab.

Body = página del tab activo.

Integración con sesión:

SessionContextController.activeContext.rol se usa como key para seleccionar WorkspaceConfig.

Si rol = "proveedor", usar ProviderProfile.providerType para decidir entre Servicios o Artículos (y si es aseguradora/broker, usar variante de Artículos).

Reutilización:

Páginas (ej. ChatPage, AccountingPage, PurchasePage) son inyectadas en WorkspaceTab.

Un mismo módulo puede aparecer en varios workspaces.

Archivos a generar

lib/presentation/workspace/workspace_config.dart (WorkspaceConfig + mapa roles→config).

lib/presentation/workspace/workspace_shell.dart (widget base con BottomNavigationBar dinámico).

lib/presentation/controllers/workspace_controller.dart (GetX controller para navegación de tabs).

Actualizar bootstrap de sesión para cargar el workspace correcto basado en activeContext.

---------------------------------------------------------------------------------------------------
Proyecto: Avanzza 2.0 — Migración Firestore a refs + espejo /sessions opcional (sin romper flujo local)
Contexto: 
Actualmente, el proyecto usa RegistrationProgress y RegistrationController para almacenar la selección local del usuario antes del registro (país, región, ciudad, tipo de usuario y rol). 
No se requiere Anonymous Auth obligatorio; solo un espejo /sessions opcional para continuidad, métricas y recuperación cross-device.
El objetivo principal es optimizar Firestore y el almacenamiento local para una base de datos más eficiente, escalable y de bajo costo.

Objetivo general:
Migrar gradualmente los modelos, repositorios y fuentes de datos para reemplazar los campos *_Id por DocumentReference; optimizar consultas, escrituras y sincronización offline; y añadir un espejo no bloqueante /sessions.

Entregable:
Un archivo PLAN.yaml con las fases, tareas atómicas, dependencias, archivos a modificar y checks de aceptación.

Fases solicitadas:

1) **Models & Converters**
   - Crear `DocRefPathConverter` y `TimestampConverter`.
   - Añadir campos `countryRef`, `regionRef`, `cityRef`, `orgRef`, `ownerRef`, `assetRef`, `reportedByRef` según entidad.
   - Mantener `regionCode` y `cityCode` en City.
   - Mapear DocumentReference ↔ path para Isar sin romper dominio existente.

2) **Data Sources & Repos (consultas por refs)**
   - Migrar filtros: `where('orgId',...)` → `where('orgRef',==,db.doc('/organizations/$orgId'))`.
   - Igual para `cityRef`, `regionRef`, `countryRef`.
   - Implementar paginación (`startAfterDocument`, `limit`).
   - Actualizar escrituras con `updatedAt = FieldValue.serverTimestamp()`.

3) **Espejo /sessions (opcional, no bloqueante)**
   - Crear `SessionRepository` y `SessionRemoteDs`.
   - Modificar `RegistrationController` y `RegistrationProgressModel` para actualizar /sessions/{uidAnon} cuando haya red.
   - /sessions guarda: `{countryRef, regionRef, cityRef, personType, intendedRole, lastSeenAt}`.
   - Primer write real crea usuario, organization, membership y borra la sesión.
   - Ningún flujo depende de /sessions ni requiere reglas nuevas.

4) **Seeder (geo v3)**
   - Implementar `GeoSeeder` usando `regions_entities_co.v3.json` y `cities_entities_co.v3.json`.
   - Convertir paths → DocumentReference.
   - Batch ≤450, merge:true, timestamps automáticos.

5) **QA offline + smoke**
   - Crear asset sin conexión → sincronizar al reconectar.
   - Listar assets/incidencias por `orgRef` y `cityRef` sin errores de índice.
   - Confirmar que ningún módulo usa *_Id en Firestore.

Restricciones:
- Mantener compatibilidad total con el flujo actual.
- No alterar las reglas ni la experiencia offline.
- Espejo /sessions es opcional y no bloqueante.
- build_runner, lint y tests deben pasar sin errores.

Salida esperada:
PLAN.yaml con las fases anteriores, cada tarea con:
- id único
- objetivo
- archivos afectados
- pasos concretos
- criterios de aceptación
- dependencias

------------------------------------------------------------------------------------
meta:
  project: "Avanzza 2.0 — Migración Firestore a refs + espejo /sessions"
  owner: "Core Platform/Architecture"
  goals:
    - Migrar progresivamente *_Id → DocumentReference en Firestore sin romper flujo offline-first ni dominio.
    - Optimizar consultas por refs y escrituras con timestamps server-side.
    - Añadir espejo opcional /sessions para continuidad cross-device (no bloqueante).
    - Mantener compatibilidad con UI/DI/Usecases actuales y sin dependencias nuevas.

constraints:
  - No romper flujo actual ni UX offline.
  - No cambiar reglas de seguridad.
  - Espejo /sessions es opcional y tolerante a fallas.
  - build_runner, lints y tests deben pasar.
  - Sin dependencias nuevas.

phases:
  - id: P1
    name: Models & Converters
    objective: Introducir converters para DocumentReference y Timestamp; extender entidades para refs sin romper dominio ni cache local.
    tasks:
      - id: P1-T1
        objective: Crear DocRefPathConverter y TimestampConverter
        files:
          - lib/core/converters/doc_ref_path_converter.dart (nuevo)
          - lib/core/converters/timestamp_converter.dart (nuevo)
        steps:
          - Implementar DocRefPathConverter con toFirestore(DocumentReference→DocumentReference) y fromFirestore(DocumentReference→DocumentReference) y toIsar/fromIsar vía path String.
          - Implementar TimestampConverter para DateTime ↔ Timestamp (Firestore) y DateTime ↔ String/epoch si requerido por Isar models.
          - Exponer helpers para db.doc(path) y pathFromRef(DocumentReference).
        acceptance:
          - Unit tests básicos convierten ref<->path y DateTime<->Timestamp.
          - No rompe compiles; ningún repos necesita cambios aún.
        deps: []
      - id: P1-T2
        objective: Extender entidades de dominio con campos *Ref sin eliminar *_Id (compatibilidad)
        files:
          - lib/domain/entities/**/*
          - lib/data/models/**/*
          - lib/data/mappers/**/*
        steps:
          - Para entidades clave (Organization, Branch, Asset, Maintenance*, Purchase*, AccountingEntry, Chat*, User*, Membership, ActiveContext):
            - Añadir campos opcionales: countryRef, regionRef, cityRef, orgRef, ownerRef, assetRef, reportedByRef según aplique (nullable).
            - Mantener *_Id por compatibilidad en dominio (deprecado) y usarlos como fallback si no hay ref.
            - En City mantener regionCode y cityCode.
          - Anotar converters en modelos (freezed/json) con @JsonKey(fromJson/toJson usando DocRefPathConverter/TimestampConverter).
        acceptance:
          - build_runner generate sin errores.
          - Serialización JSON mantiene ids previos y acepta refs cuando estén.
        deps: [P1-T1]
      - id: P1-T3
        objective: Mapear DocumentReference<->path en Isar
        files:
          - lib/data/sources/local/**/*_local_ds.dart
          - lib/data/models/**/*
        steps:
          - Para modelos persistidos en Isar, almacenar refs como String path (ej. "/orgs/{id}") usando DocRefPathConverter.
          - Mantener lecturas que reconstruyan DocumentReference cuando sea necesario en capa remota.
        acceptance:
          - Lecturas/escrituras locales siguen funcionando con datos existentes.
          - Tests locales de repos no cambian resultados.
        deps: [P1-T1, P1-T2]

  - id: P2
    name: Data Sources & Repos (consultas por refs)
    objective: Migrar gradualmente las consultas y escrituras en remotes a usar refs; añadir paginación y timestamps server-side.
    tasks:
      - id: P2-T1
        objective: Migrar filtros where('orgId', ...) → where('orgRef', ==, db.doc('/orgs/{orgId}')) (similar cityRef, regionRef, countryRef)
        files:
          - lib/data/sources/remote/**/*_remote_ds.dart
          - lib/data/repositories/**/*_repository_impl.dart
        steps:
          - Introducir util db.doc('/collection/id') en cada DS remoto a partir de FirebaseFirestore instance (DIContainer().firestore).
          - Cambiar gradualmente queries (watch/fetch) a usar *Ref con fallback a *_Id si no está aún migrado.
          - Asegurar índices Firestore en dev si hace falta (local rules manteniendo no cambios en prod).
        acceptance:
          - Queries producen los mismos resultados con datos actuales.
          - No fallan si documentos antiguos solo tienen *_Id y no *Ref.
        deps: [P1]
      - id: P2-T2
        objective: Paginación y updatedAt server-side
        files:
          - lib/data/sources/remote/**/*_remote_ds.dart
        steps:
          - Agregar métodos fetch paginados con startAfterDocument/limit y orden por updatedAt desc.
          - En upsert remotos, escribir updatedAt = FieldValue.serverTimestamp() y createdAt si documento nuevo.
        acceptance:
          - fetchEntries paginados devuelven lotes consistentes.
          - Esquemas mantienen updatedAt automatizado sin tocar dominio.
        deps: [P2-T1]

  - id: P3
    name: Espejo /sessions (opcional, no bloqueante)
    objective: Persistir selección local de onboarding en /sessions para continuidad y métricas, sin bloquear UX.
    tasks:
      - id: P3-T1
        objective: Crear SessionRepository y SessionRemoteDs
        files:
          - lib/domain/repositories/session_repository.dart (nuevo)
          - lib/data/sources/remote/session_remote_ds.dart (nuevo)
          - lib/data/repositories/session_repository_impl.dart (nuevo)
        steps:
          - Modelo simple /sessions/{sessionId}: {countryRef, regionRef, cityRef, personType, intendedRole, lastSeenAt}.
          - sessionId puede ser deviceId o uidAnon localmente generado.
        acceptance:
          - Llamadas upsertSession()/getSession() funcionan cuando hay red; no bloquean UI si falla.
        deps: [P1]
      - id: P3-T2
        objective: Integrar en RegistrationController/Progress DS
        files:
          - lib/presentation/auth/controllers/registration_controller.dart
          - lib/data/datasources/local/registration_progress_ds.dart
        steps:
          - Al cambiar country/region/city/role en progreso, intentar mirror en /sessions si hay conectividad (try/catch, no-bloqueante).
          - Al completar primer write real, eliminar /sessions/{id}.
        acceptance:
          - Al navegar onboarding, /sessions se actualiza cuando hay red; si no, no falla nada.
        deps: [P3-T1]

  - id: P4
    name: Seeder (geo v3)
    objective: Sembrar regiones/ciudades v3 con refs.
    tasks:
      - id: P4-T1
        objective: Implementar GeoSeeder v3
        files:
          - lib/tools/geo/geo_seeder_v3.dart (nuevo)
          - assets/regions_entities_co.v3.json
          - assets/cities_entities_co.v3.json
        steps:
          - Parsear JSON y construir DocumentReference por país/region/ciudad.
          - Batch commits ≤ 450, SetOptions(merge:true), timestamps server-side.
          - Mantener codes (regionCode, cityCode) en City.
        acceptance:
          - Colecciones /countries, /regions, /cities pobladas y consultables por ref/codes.
        deps: [P1, P2]

  - id: P5
    name: QA offline + smoke
    objective: Validar que el flujo offline-first y nuevas refs funcionan.
    tasks:
      - id: P5-T1
        objective: Crear asset sin conexión y sincronizar
        files:
          - test/sync/offline_asset_create_test.dart (nuevo)
        steps:
          - Simular offline, crear Asset (usando orgRef/cityRef en local path), reconectar y verificar sincronización remota sin conflictos.
        acceptance:
          - Test pasa; no hay pérdida de datos.
        deps: [P2]
      - id: P5-T2
        objective: Listar assets/incidencias por orgRef y cityRef
        files:
          - test/data/repositories/queries_by_ref_smoke_test.dart (nuevo)
        steps:
          - Validar queries por orgRef y cityRef en repos Asset/Maintenance.
        acceptance:
          - Tests pasan, tiempos aceptables.
        deps: [P2]
      - id: P5-T3
        objective: Verificar que ningún DS remoto usa *_Id en Firestore
        files:
          - scripts/checks/grep_no_id_filters.sh (opcional)
        steps:
          - Grep en repo para where('...Id', ...); documentar excepciones temporales.
        acceptance:
          - Cero ocurrencias en DS remotos (permitido en local DS/mappers).
        deps: [P2]

cross-cutting:
  - id: CC1
    objective: Compatibilidad total con flujo actual
    files:
      - lib/presentation/**/* (sin cambios funcionales forzados)
      - lib/domain/usecases/**/* (mantener firmas)
    steps:
      - Mantener *_Id en dominio y mappers mientras migran colecciones.
      - Fallback: si no hay *Ref, usar *_Id para armar db.doc('/col/id').
    acceptance:
      - App compila y navega sin cambios UX.
    deps: [P1..P2]
  - id: CC2
    objective: Tooling y codegen
    files:
      - build_runner scripts, freezed/json
    steps:
      - flutter pub run build_runner build --delete-conflicting-outputs
      - flutter analyze sin errores.
    acceptance:
      - Build limpia; lints OK.
    deps: [P1]

rollout:
  strategy:
    - Feature-flag por módulos en DS remotos (activar consultas por ref módulo a módulo).
    - Mantener dualidad *_Id/*Ref solo el tiempo mínimo necesario.
    - Monitorear errores y tiempos de consulta.

risks:
  - Datos legacy sin *Ref. Mitigación: fallback a *_Id en mappers/DS hasta migración completa.
  - Índices Firestore. Mitigación: pre-crear índices necesarios para consultas compuestas con refs.
  - Tamaño de lote en seeding. Mitigación: batch ≤450 y reintentos.

checklist_final:
  - [ ] Converters creados y testeados.
  - [ ] Entidades y modelos extendidos con *Ref sin romper dominio.
  - [ ] DS remotos migrados a *Ref con fallback.
  - [ ] Paginación y timestamps en escrituras.
  - [ ] /sessions integrado opcionalmente en RegistrationController.
  - [ ] Geo seeder v3 listo y probado en entorno de dev.
  - [ ] Smoke offline y queries por ref verificados.
  - [ ] build_runner, lints y tests en verde.

----------------------------------------------------------------------------------------
Ajustes menores recomendados antes de ejecutar con Agent

Ubicación de convertidores

En vez de lib/core/converters, usa lib/data/converters o lib/data/models/common/converters (para mantener consistencia con tu estructura actual).

Nombre de sesión

Cambia sessionId = deviceId → sessionId = uuid generado localmente; evita colisiones si el mismo dispositivo reinstala.

GeoSeeder

Añade campo sourceFileVersion al lote ("v3") para auditoría de seeds.

QA automatizada

Agrega test que confirme que las colecciones regions, cities cargan con DocumentReference válido (instanceof DocumentReference).
---------------------------------------------------------------------------------

Objetivo: Añadir soporte DocumentReference y Timestamp sin romper dominio ni offline. Crear convertidores y extender modelos con *Ref. Mantener *_Id como fallback temporal.

Archivos NUEVOS:
- lib/data/models/common/converters/doc_ref_path_converter.dart
- lib/data/models/common/converters/timestamp_converter.dart
- lib/data/sessions/session_id.dart  // util UUID local

Implementar:
1) DocRefPathConverter
  - fromPath(FirebaseFirestore db, String? path) -> DocumentReference?
  - toPath(DocumentReference?) -> String?
2) TimestampConverter
  - fromTimestamp(Timestamp?) -> DateTime?
  - toTimestamp(DateTime?) -> Timestamp?
3) session_id.dart
  - String generateLocalSessionId()  // UUID v4-like sin paquete externo

Modificar modelos (añadir campos *Ref opcionales y anotar json):
- lib/data/models/geo/region_model.dart
  + countryRef: DocumentReference?
- lib/data/models/geo/city_model.dart
  + countryRef, regionRef: DocumentReference?
  + regionCode, cityCode: String (mantener)
- lib/data/models/org/organization_model.dart
  + countryRef, regionRef, cityRef: DocumentReference?
  + ownerRef: DocumentReference?
- lib/data/models/asset/asset_model.dart
  + orgRef, ownerRef: DocumentReference?
  + countryRef, regionRef, cityRef: DocumentReference?
- lib/data/models/maintenance/incidencia_model.dart
  + assetRef, orgRef, reportedByRef, cityRef: DocumentReference?
- lib/data/models/user/membership_model.dart
  + orgRef: DocumentReference?

Notas:
- JSON Firestore: usar DocumentReference nativo.
- Persistencia local (Isar): serializar refs como path String con DocRefPathConverter.
- Mantener *_Id existentes como deprecated y fallback en mappers (no quitarlos aún).
- createdAt/updatedAt con Timestamp (usar TimestampConverter en modelos).

Criterios de aceptación:
- `flutter pub run build_runner build --delete-conflicting-outputs` sin errores.
- `dart analyze` sin warnings nuevos.
- No se rompe ninguna firma pública en entidades de dominio.
- Todos los modelos compilan y aceptan tanto *_Id (legacy) como *Ref (nuevo).
-------------------------------------------------------------

Objetivo: Añadir soporte DocumentReference y Timestamp sin romper dominio ni offline. Crear convertidores y extender modelos con *Ref. Mantener *_Id como fallback temporal.

Archivos NUEVOS:
- lib/data/models/common/converters/doc_ref_path_converter.dart
- lib/data/models/common/converters/timestamp_converter.dart
- lib/data/sessions/session_id.dart  // util UUID local

Implementar:
1) DocRefPathConverter
  - fromPath(FirebaseFirestore db, String? path) -> DocumentReference?
  - toPath(DocumentReference?) -> String?
2) TimestampConverter
  - fromTimestamp(Timestamp?) -> DateTime?
  - toTimestamp(DateTime?) -> Timestamp?
3) session_id.dart
  - String generateLocalSessionId()  // UUID v4-like sin paquete externo

Modificar modelos (añadir campos *Ref opcionales y anotar json):
- lib/data/models/geo/region_model.dart
  + countryRef: DocumentReference?
- lib/data/models/geo/city_model.dart
  + countryRef, regionRef: DocumentReference?
  + regionCode, cityCode: String (mantener)
- lib/data/models/org/organization_model.dart
  + countryRef, regionRef, cityRef: DocumentReference?
  + ownerRef: DocumentReference?
- lib/data/models/asset/asset_model.dart
  + orgRef, ownerRef: DocumentReference?
  + countryRef, regionRef, cityRef: DocumentReference?
- lib/data/models/maintenance/incidencia_model.dart
  + assetRef, orgRef, reportedByRef, cityRef: DocumentReference?
- lib/data/models/user/membership_model.dart
  + orgRef: DocumentReference?

Notas:
- JSON Firestore: usar DocumentReference nativo.
- Persistencia local (Isar): serializar refs como path String con DocRefPathConverter.
- Mantener *_Id existentes como deprecated y fallback en mappers (no quitarlos aún).
- createdAt/updatedAt con Timestamp (usar TimestampConverter en modelos).

Criterios de aceptación:
- `flutter pub run build_runner build --delete-conflicting-outputs` sin errores.
- `dart analyze` sin warnings nuevos.
- No se rompe ninguna firma pública en entidades de dominio.
- Todos los modelos compilan y aceptan tanto *_Id (legacy) como *Ref (nuevo).
-----------------------------------------------------------------
Prompt para Agent — F1-T3 (Models con refs + documentación)
Objetivo:
Añadir campos DocumentReference opcionales en modelos clave y anotar conversión JSON. Mantener *_Id como fallback temporal. Documentar el código.

Archivos a modificar:
- lib/data/models/geo/region_model.dart
- lib/data/models/geo/city_model.dart
- lib/data/models/org/organization_model.dart
- lib/data/models/asset/asset_model.dart
- lib/data/models/maintenance/incidencia_model.dart
- lib/data/models/user/membership_model.dart

Convertidores ya creados:
- lib/data/models/common/converters/doc_ref_path_converter.dart
- lib/data/models/common/converters/timestamp_converter.dart

Instrucciones:
1) Agregar campos *Ref (nullable) según entidad:
   - Region: countryRef
   - City: countryRef, regionRef, regionCode, cityCode (mantener codes)
   - Organization: countryRef, regionRef, cityRef, ownerRef
   - Asset: orgRef, ownerRef, countryRef, regionRef, cityRef
   - Incidencia: assetRef, orgRef, reportedByRef, cityRef
   - Membership: orgRef, roles[] ya existente

2) Anotar JSON con JsonConverter:
   - @DocRefJsonConverter(FirebaseFirestore.instance) en cada *Ref
   - @TimestampJsonConverter() en createdAt y updatedAt

3) Compatibilidad:
   - Conservar *_Id existentes (deprecated) y mapeo fromJson que acepte ambos:
     * si viene *Ref usarlo
     * si no, y hay *_Id, construir DocumentReference con db.doc('/coleccion/{id}')
   - No romper constructors ni APIs públicas.

4) Documentación obligatoria:
   - Encabezado de archivo y docstrings en cada clase/campo explicando propósito, uso y compatibilidad *_Id/*Ref.

5) Post-tarea:
   - Actualizar adapters/toJson para serializar *Ref nativos a Firestore.
   - No escribir *_Id nuevos en toJson.

Criterios de aceptación:
- build_runner sin errores; dart analyze sin warnings nuevos.
- Modelos aceptan datos legacy (solo *_Id) y nuevos (con *Ref).
- toJson no incluye *_Id; fromJson sigue poblando *Ref desde *_Id si falta ref.
