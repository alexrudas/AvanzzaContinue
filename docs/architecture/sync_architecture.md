# Sync Architecture — Avanzza 2.0

| Campo                    | Valor                                          |
| ------------------------ | ---------------------------------------------- |
| **Estado**               | Vigente                                        |
| **Última actualización** | 2026-03-19                                     |
| **Scope**                | Sincronización local↔remoto (Isar ↔ Firestore) |

---

## Visión general

Avanzza 2.0 es **offline-first**.  
Toda escritura ocurre primero en **Isar**.  
La sincronización hacia **Firestore** es asíncrona, basada en **outbox**, y completamente desacoplada de la UI.

El sistema de sync está dividido en dos capas:

| Capa                          | Componentes                                                            | Rol                                                           |
| ----------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------- |
| **Genérica**                  | `SyncEngineService`, `SyncDispatcher`                                  | Infraestructura base: polling, retry/backoff, dead letter     |
| **Especializada (vehículos)** | `AssetSyncDispatcher`, `AssetSyncEngine`, `AssetSyncLifecycleObserver` | Coalescing, anti-ping-pong, lifecycle control, bootstrap pull |

---

## Principios del sistema

- **Offline-first real**: Isar es la fuente de verdad local temporal.
- **Outbox obligatorio**: todo write remoto debe pasar por `SyncOutboxRepository`.
- **Separación estricta** entre infraestructura genérica y lógica especializada.
- **Ownership explícito** del lifecycle de sync.
- **Idempotencia** en cada operación remota.
- **No hay owner implícito** para nuevas entidades.

---

## Outbox Pattern

Todo write hacia Firestore pasa por `SyncOutboxRepository` (Isar).

Cada entrada contiene, como mínimo:

- `id`
- `idempotencyKey`
- `partitionKey`
- `payload`
- `status`
- `retryCount`

### Backoff strategy

| Intento | Delay |
| ------- | ----- |
| 1       | 10s   |
| 2       | 30s   |
| 3       | 2m    |
| 4       | 10m   |
| 5       | 30m   |
| 6+      | 1h    |

Después de `maxRetries` → **Dead Letter Queue**

---

## Sync Ownership Rule — Entity-specific Dispatchers

### Regla vigente

El stack especializado gobierna completamente la sincronización de activos vehiculares.

| Componente                   | Rol                                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `AssetSyncEngine`            | Observa Isar (`watchLazy()`), aplica debounce y realiza bootstrap pull                                     |
| `AssetSyncDispatcher`        | Consume outbox (`vehicle:*`), aplica coalescing por `partitionKey`, usa lease locking y empuja a Firestore |
| `AssetSyncLifecycleObserver` | Owner del lifecycle del stack vehicular                                                                    |

---

### Regla crítica

**`SyncEngineService` genérico NO es el owner del lifecycle vehicular.**

Aunque está instanciado:

- NO arranca automáticamente para vehículos
- NO participa en el flujo `vehicle:*`
- NO debe competir por el mismo outbox mientras el stack especializado esté activo

En `Bootstrap` se fuerza explícitamente:

```dart
await syncEngineService.stop(graceful: true);
```

Además:

- `SyncLifecycleObserver` se mantiene registrado por compatibilidad legacy
- `SyncLifecycleObserver` **NO recibe `startIfResumed()`**
- El lifecycle real lo controla `AssetSyncLifecycleObserver`

---

## Regla dura — Nuevas entidades

Cualquier nueva entidad que requiera sincronización:

❌ NO debe usar automáticamente `SyncEngineService` genérico

Debe cumplir **una** de estas dos rutas:

### Opción A — Reactivar engine genérico

- Decisión arquitectónica explícita
- Documentada en este archivo
- Validación de no colisión con stacks especializados
- Ownership definido claramente

### Opción B — Crear stack especializado

- Dispatcher propio
- Engine propio
- Lifecycle propio
- Estrategia de coalescing
- Retry policy diferenciada
- Conflict handling propio

---

## Justificación de la regla

Esta regla evita:

- Competencia entre dispatchers
- Doble procesamiento del outbox
- Writes redundantes a Firestore
- Pérdida del coalescing especializado
- Ambigüedad de ownership del lifecycle
- Bugs silenciosos en producción

---

## Estado actual de ownership

| Tipo de entidad  | Owner de sync                                                                                  | Estado                              |
| ---------------- | ---------------------------------------------------------------------------------------------- | ----------------------------------- |
| Activo vehicular | Stack especializado (`AssetSyncDispatcher` + `AssetSyncEngine` + `AssetSyncLifecycleObserver`) | ✅ Activo                           |
| Todas las demás  | Ningún owner activo por defecto                                                                | ⚠️ Requiere decisión arquitectónica |

---

## Anti-ping-pong

Cada asset mantiene un `VehicleSyncState` en memoria:

- fingerprint (SHA-256 del payload)
- último estado sincronizado

`AssetSyncService.schedulePush()` descarta el push si el fingerprint no cambia.

### Resultado

- elimina loops local → remoto → local
- reduce writes innecesarios
- estabiliza el sistema

---

## Coalescing

El stack vehicular aplica coalescing por `partitionKey`.

Ejemplo:

```text
vehicle:{assetId}
```

### Regla

Solo se procesa la última versión del mismo asset dentro de una ventana de cambios.

### Beneficio

- reduce writes a Firestore
- reduce ruido en el outbox
- mejora performance

---

## Lifecycle del stack especializado

### Bootstrap init

```text
Bootstrap._doInit()
  │
  ├── initDI(...)
  │
  ├── SyncLifecycleObserver.register()      ← legacy
  │
  ├── AssetSyncLifecycleObserver.register()
  │
  ├── startSyncInfrastructure()             ← FUENTE DE VERDAD
  │     ├── AssetSyncDispatcher.start()
  │     ├── AssetSyncEngine.start()
  │     └── SyncEngineService.stop(graceful: true)
  │
  └── AppBindings(...)
```

### App resume

```text
AssetSyncLifecycleObserver.didChangeAppLifecycleState(resumed)
  └── startIfResumed()
        ├── AssetSyncDispatcher.start()
        └── AssetSyncEngine.start()
```

### App pause / inactive / detached / hidden

```text
AssetSyncLifecycleObserver.didChangeAppLifecycleState(state)
  └── stop()
        ├── AssetSyncEngine.stop()
        └── AssetSyncDispatcher.stop()
```

### Bootstrap dispose

```text
Bootstrap.dispose()
  ├── AssetSyncLifecycleObserver.dispose()
  ├── SyncLifecycleObserver.dispose()     ← legacy
  ├── stopSyncInfrastructure()            ← FUENTE DE VERDAD
  │     ├── AssetSyncEngine.stop()
  │     ├── AssetSyncDispatcher.stop()
  │     └── SyncEngineService.stop(graceful: true)
  ├── AuthStateObserver.stop()
  ├── SyncObserver.dispose()
  └── Connectivity.dispose()
```

---

## Fuente de verdad operativa

### Arranque

```dart
startSyncInfrastructure();
```

### Apagado

```dart
stopSyncInfrastructure();
```

---

## Archivos clave

| Archivo                                            | Descripción                  |
| -------------------------------------------------- | ---------------------------- |
| `lib/data/sync/asset_sync_engine.dart`             | Watchers Isar + debounce     |
| `lib/data/sync/asset_sync_dispatcher.dart`         | Outbox consumer + coalescing |
| `lib/data/sync/asset_sync_service.dart`            | Coordinador push/pull        |
| `lib/data/sync/asset_sync_queue.dart`              | Factory de entries           |
| `lib/data/sync/asset_firestore_adapter.dart`       | Mapping + fingerprint        |
| `lib/core/sync/asset_sync_lifecycle_observer.dart` | Lifecycle owner              |
| `lib/core/sync/sync_lifecycle_observer.dart`       | Legacy                       |
| `lib/domain/services/sync/sync_engine.dart`        | Engine genérico              |
| `lib/domain/services/sync/sync_dispatcher.dart`    | Dispatcher genérico          |
| `lib/core/di/container.dart`                       | Wiring                       |
| `lib/core/startup/bootstrap.dart`                  | Init / dispose               |

---

## Estado actual del sistema

### Resuelto

- separación genérico vs especializado
- ownership explícito
- lifecycle controlado
- anti-ping-pong
- coalescing
- guardrail contra engine genérico

### Pendiente (producto)

- SOAT sync
- RC sync
- Estado Jurídico sync
- definición de ownership para nuevas entidades

---

## Regla final

**El sync en Avanzza NO es genérico por defecto.**  
**Es explícito, controlado y gobernado por ownership arquitectónico.**
