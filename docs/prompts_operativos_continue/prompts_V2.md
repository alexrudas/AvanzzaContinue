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