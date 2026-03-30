# ALERTS_SYSTEM_V4.md

> Documento rector de arquitectura para el sistema de alertas de Avanzza 2.0.
>
> Reglas obligatorias:
>
> - No crear sistemas de alertas fuera de este modelo.
> - Todo PR que toque alertas debe respetar este documento.
> - Este documento define la arquitectura objetivo y el plan de migración desde el estado actual del código.
> - Si el código actual contradice este documento, prevalece este documento para todo desarrollo nuevo o migración controlada.

---

## 1. PROPÓSITO

Definir una arquitectura única, escalable y ejecutable para el sistema de alertas de Avanzza 2.0, evitando:

- duplicación de modelos
- lógica fragmentada
- alertas mock visibles en producción
- dependencia del dominio respecto a UI
- múltiples sistemas paralelos sin fuente canónica

Este documento define:

- contrato canónico completo
- capas alineadas con la estructura real del repo
- pipeline end-to-end con ownership por capa
- integración explícita con código existente
- fases con Definition of Done verificable

---

## 2. PRINCIPIO RECTOR

Las alertas nacen en su contexto operativo y se proyectan hacia capas superiores (Home).

NO existe un sistema global como origen.

Flujo correcto:

1. estándar transversal
2. productor contextual por dominio
3. consumo contextual por módulo/vista
4. promotion layer
5. Home como consumidor agregado

Home nunca crea lógica propia de alertas.

---

## 3. ESTRUCTURA DE CAPAS (OBLIGATORIA)

### 3.1 Capas válidas del repo

- `lib/domain/`
- `lib/core/`
- `lib/data/`
- `lib/presentation/`

### 3.2 Prohibición explícita

Se prohíbe crear `lib/application/`.
No existe en la arquitectura del repo. No se crea.

### 3.3 Extensión de lib/domain/

El subdirectorio `lib/domain/services/` se declara extensión permitida de la arquitectura para alojar lógica de negocio que:

- no es entidad ni value object (no va en `entities/`)
- no es contrato de repositorio (no va en `repositories/`)
- no depende de infraestructura (no va en `data/`)
- no depende de UI (no va en `presentation/`)

Esta extensión requiere que CLAUDE.md sea actualizado para incluir `domain/services/`.

### 3.4 Regla de dependencias

| Capa           | Puede importar          | No puede importar              |
| -------------- | ----------------------- | ------------------------------ |
| `domain`       | nada externo al dominio | `core`, `data`, `presentation` |
| `core`         | `domain`                | `data`, `presentation`         |
| `data`         | `domain`, `core`        | `presentation`                 |
| `presentation` | `domain`, `core`        | `data` directamente            |

Justificación: `core` puede importar `domain` porque actúa como infraestructura de soporte que implementa o adapta contratos de dominio. Ejemplo: `soat_alert_adapter` vive en `core/` y retorna `DomainAlert` del dominio. Lo prohibido es la inversión: `domain` nunca puede importar `core`.

---

## 4. ESTRUCTURA DE ARCHIVOS (OBLIGATORIA)

### Dominio — entidades

- `lib/domain/entities/alerts/domain_alert.dart`
- `lib/domain/entities/alerts/alert_code.dart`
- `lib/domain/entities/alerts/alert_severity.dart`
- `lib/domain/entities/alerts/alert_scope.dart`
- `lib/domain/entities/alerts/alert_audience.dart`
- `lib/domain/entities/alerts/alert_promotion_policy.dart`
- `lib/domain/entities/alerts/alert_fact_keys.dart`
- `lib/domain/entities/alerts/alert_evidence_keys.dart`

### Dominio — servicios

- `lib/domain/services/alerts/asset_alert_snapshot.dart`
- `lib/domain/services/alerts/asset_alert_snapshot_assembler.dart`
- `lib/domain/services/alerts/asset_compliance_alert_orchestrator.dart`
- `lib/domain/services/alerts/evaluators/rtm_alert_evaluator.dart`
- `lib/domain/services/alerts/evaluators/rc_alert_evaluator.dart`
- `lib/domain/services/alerts/evaluators/legal_alert_evaluator.dart`
- `lib/domain/services/alerts/support/alert_dedupe.dart`
- `lib/domain/services/alerts/support/alert_sort.dart`

### Core — adaptadores y soporte técnico

- `lib/core/alerts/evaluators/soat_alert_adapter.dart`

### Presentación

- `lib/presentation/alerts/viewmodels/alert_card_vm.dart`
- `lib/presentation/alerts/mappers/domain_alert_mapper.dart`

---

## 5. CONTRATO CANÓNICO

### 5.1 DomainAlert

Campos obligatorios:

| Campo             | Tipo                           | Descripción                                                         |
| ----------------- | ------------------------------ | ------------------------------------------------------------------- |
| `id`              | String                         | UUID único de la alerta                                             |
| `code`            | AlertCode                      | Código canónico wire-stable                                         |
| `severity`        | AlertSeverity                  | Nivel de urgencia                                                   |
| `scope`           | AlertScope                     | Dominio de origen                                                   |
| `audience`        | AlertAudience                  | Rol objetivo                                                        |
| `promotionPolicy` | AlertPromotionPolicy           | Comportamiento hacia Home                                           |
| `sourceEntityId`  | String                         | ID del activo u entidad fuente                                      |
| `titleKey`        | String                         | Key i18n del título                                                 |
| `bodyKey`         | String                         | Key i18n del cuerpo                                                 |
| `facts`           | Map\<String, Object?\>         | Datos contextuales (keys de AlertFactKeys)                          |
| `evidenceRefs`    | List\<Map\<String, Object?\>\> | Referencias a evidencia real                                        |
| `isActive`        | bool                           | Siempre true en V1 (on-read); reservado para V2                     |
| `detectedAt`      | DateTime                       | Momento del cálculo                                                 |
| `sourceUpdatedAt` | DateTime                       | Última actualización de la fuente                                   |
| `dedupeKey`       | String                         | Key derivada: `{code}:{scope}:{sourceEntityId}:{primaryEvidenceId}` |

### 5.2 Restricciones del dominio

DomainAlert:

- NO usa IconData
- NO usa colores
- NO usa Widgets
- NO usa BuildContext
- NO depende de `package:flutter`
- NO contiene strings renderizados finales (solo keys)

### 5.3 Sobre isActive en V1

En V1, las alertas se calculan on-read y nunca se persisten. `isActive` siempre es `true` en el resultado del pipeline. El campo existe para compatibilidad futura (V2 con persistencia).

---

## 6. ENUMS CANÓNICOS

### 6.1 AlertCode (V1 mínimo)

Valores:

- `soat_expired`
- `soat_due_soon`
- `rtm_expired`
- `rtm_due_soon`
- `rc_contractual_expired`
- `rc_contractual_due_soon`
- `rc_contractual_missing` — póliza RC contractual ausente. Solo servicio público en V1.
- `rc_extracontractual_expired`
- `rc_extracontractual_due_soon`
- `rc_extracontractual_missing` — póliza RC extracontractual ausente. Servicio público (critical) y particular (high).
- `legal_limitation_active`
- `embargo_active`

Reservados para fases futuras:

- `simit_fine_active`
- `maintenance_overdue`
- `accounts_payable_overdue`
- `purchase_order_blocked`

Wire-stability obligatoria: `wireName` + `fromWire`. El wire value es el snake_case literal (e.g., `"soat_expired"`). Patrón de referencia: `InsurancePolicyType.fromWireString()` en `lib/domain/entities/insurance/insurance_policy_entity.dart`.

---

### 6.2 AlertSeverity

Valores canónicos:

- `critical`
- `high`
- `medium`
- `low`

#### Mapeo obligatorio desde enums legacy

| Enum legacy       | Valor legacy  | AlertSeverity canónico            |
| ----------------- | ------------- | --------------------------------- |
| `_ModuleSeverity` | `critical`    | `critical`                        |
| `_ModuleSeverity` | `attention`   | `medium`                          |
| `_ModuleSeverity` | `neutral`     | `low` o sin alerta según contexto |
| `AIAlertPriority` | `critica`     | `critical`                        |
| `AIAlertPriority` | `alta`        | `high`                            |
| `AIAlertPriority` | `media`       | `medium`                          |
| `AIAlertPriority` | `oportunidad` | `low`                             |
| `SoatPriority`    | `critical`    | `critical`                        |
| `SoatPriority`    | `high`        | `high`                            |
| `SoatPriority`    | `medium`      | `medium`                          |
| `SoatPriority`    | `low`         | `low`                             |
| `SoatPriority`    | `none`        | no genera alerta                  |
| `AlertType`       | `critical`    | `critical`                        |
| `AlertType`       | `warning`     | `medium`                          |
| `AlertType`       | `info`        | `low`                             |
| `AlertType`       | `success`     | no es alerta canónica — no migrar |

Regla: no crear un quinto enum paralelo después de `AlertSeverity`.

---

### 6.3 AlertScope

| Valor          | Significado                                                      |
| -------------- | ---------------------------------------------------------------- |
| `asset`        | Alerta nacida en un activo o su cumplimiento documental/jurídico |
| `organization` | Alerta agregada/promovida a nivel organización                   |
| `maintenance`  | Alerta nacida en operaciones de mantenimiento                    |
| `accounting`   | Alerta nacida en riesgo contable, tributario o cartera           |
| `purchasing`   | Alerta nacida en compras o abastecimiento                        |

---

### 6.4 AlertAudience

Decisión V1: el campo `audience` y el enum `AlertAudience` se incluyen en el contrato pero con valor único obligatorio en V1. Sin lógica de filtrado por audiencia todavía.

Razón de inclusión: evitar migración breaking en V2 cuando se necesiten filtros por rol.

Valor único obligatorio para todos los `DomainAlert` de V1:

- `asset_admin`

Valores reservados para fases futuras (declarados en el enum, sin lógica en V1):

- `owner`
- `maintenance_manager`
- `accounting_manager`
- `purchasing_manager`
- `viewer`

Mapeo a workspaces del proyecto:

| Valor                 | Workspace                                       |
| --------------------- | ----------------------------------------------- |
| `asset_admin`         | Administrador de Activos                        |
| `owner`               | Propietario                                     |
| `maintenance_manager` | Administrador de Activos (módulo mantenimiento) |
| `accounting_manager`  | Administrador de Activos (módulo contabilidad)  |
| `purchasing_manager`  | Administrador de Activos (módulo compras)       |
| `viewer`              | Cualquier rol con acceso de solo lectura        |

---

### 6.5 AlertPromotionPolicy

| Valor                 | Comportamiento                                                                                 |
| --------------------- | ---------------------------------------------------------------------------------------------- |
| `none`                | La alerta nunca sube a Home                                                                    |
| `promote_if_high`     | Sube si severity >= `high`                                                                     |
| `promote_if_critical` | Sube solo si severity == `critical`                                                            |
| `always_promote`      | Sube independientemente de severity, siempre individual                                        |
| `aggregate_only`      | Nunca aparece individualmente; solo en resúmenes agregados (ej: "5 vehículos con RTM vencida") |

Regla de precedencia: `aggregate_only` no puede combinarse con `always_promote`. Si una alerta tiene `aggregate_only`, ninguna otra condición la hace individual.

---

## 7. KEYS CENTRALIZADOS

### 7.1 alert_fact_keys.dart

Archivo: `lib/domain/entities/alerts/alert_fact_keys.dart`

Keys obligatorias V1:

- `expirationDate`
- `daysRemaining`
- `policyType`
- `legalRestrictionType`
- `sourceName`
- `vehicleServiceType` — tipo de servicio del vehículo (RUNT). String uppercase: `'PÚBLICO'`, `'PUBLICO'`, `'PARTICULAR'`. Null si el activo no es vehículo. Usado por `AlertPromotionService` para diferir reglas RC.

Regla: nadie puede usar keys de `facts` no definidas en este archivo. Toda key nueva se agrega aquí primero.

### 7.2 alert_evidence_keys.dart

Archivo: `lib/domain/entities/alerts/alert_evidence_keys.dart`

Keys obligatorias V1 para cada entrada de `evidenceRefs`:

- `sourceType` — tipo de fuente (e.g., `"insurance_policy"`, `"rtm_doc"`, `"legal_record"`)
- `sourceId` — ID de la entidad fuente
- `sourceCollection` — colección Firestore o tabla Isar
- `documentId` — ID del documento específico
- `externalRef` — referencia externa opcional (RUNT, SIMIT)

---

## 8. DECISIÓN OFFLINE-FIRST

V1: las alertas NO se persisten como colección independiente en Isar.

Estrategia: cálculo on-read a partir de fuentes ya persistidas (pólizas, RTM, data jurídica).

Implicación: la disponibilidad offline de alertas depende de que las fuentes base del activo estén en Isar.

V2 (futuro): evaluar persistencia en Isar con invalidación por `sourceUpdatedAt`.

---

### 8.1 Estrategia de reactividad V1

**Implementación:** watcher local en `TenantHomeController`.

```dart
// V1 — táctica de cierre rápido, NO arquitectura final
_insuranceSub = isar.insurancePolicyModels.watchLazy()
    .listen((_) => _debounce());
_vehiculoSub = isar.assetVehiculoModels.watchLazy()
    .listen((_) => _debounce());
```

- Debounce: 800ms (`Timer` cancelable)
- Guard de concurrencia: `_isRefreshing` previene solapamiento
- Request ID: descarta resultados stale si llega uno más nuevo
- `refreshAlerts()` público para pull-to-refresh manual

**Declaración obligatoria:**
> Esta solución es una táctica de cierre rápido para V1.
> NO es la arquitectura de invalidación final.
> Es aceptable mientras la org tenga ≤15 activos y el rescan dure ≤300ms.

---

### 8.2 Criterio de escalamiento a invalidación por activo

Trigger obligatorio para pasar a V2 (por-activo):

| Condición | Umbral |
|---|---|
| Tiempo promedio de refresh | > 300ms |
| Activos por org | > 15 |
| Recalculos por segundo sostenidos | > 2 |

Estrategia V2:
- `Set<String> dirtyAssets` — registra qué activos cambiaron
- Re-evaluar solo los dirty, fusionar con caché del resto
- Requiere caché de resultados por activo en memoria (no Isar)

---

### 8.3 V2 candidato — AlertInvalidationCoordinator

Cuando se supere el umbral de §8.2, extraer a:

```
lib/core/alerts/alert_invalidation_coordinator.dart

Responsabilidades:
- Centraliza watchers Isar de colecciones relevantes para alertas
- Notifica a múltiples consumidores registrados (no solo TenantHomeController)
- Permite invalidación granular por assetId
- Evita duplicar watchers si hay más de un controller activo
```

---

## 9. INTEGRACIÓN CON SOAT (CRÍTICO)

### 9.1 Archivo existente real

`lib/core/campaign/soat/soat_campaign_evaluator.dart`

Contiene lógica real en producción:

- `evaluateSoat(DateTime fechaVencimiento) → SoatEvaluation`
- `getSoatPriority(int diasRestantes) → SoatPriority`
- `SoatFrequencyGuard`

### 9.2 Decisión obligatoria: adapter en core

NO reescribir la lógica existente.

Crear: `lib/core/alerts/evaluators/soat_alert_adapter.dart`

Razón de ubicación en core: el adapter importa `soat_campaign_evaluator.dart` (core) y retorna `DomainAlert` (domain). Core puede importar domain; domain no puede importar core. Esta es la única ubicación válida para este adapter.

El adapter:

- llama a `evaluateSoat()` con la fecha de vencimiento de la póliza relevante
- llama a `getSoatPriority()` con el resultado
- traduce `SoatPriority` a `AlertSeverity` usando el mapeo de §6.2
- construye y retorna `DomainAlert` con `code: soat_expired` o `soat_due_soon`

### 9.3 SoatFrequencyGuard

- NO usar para ocultar alertas in-app calculadas on-read
- Mantener para campañas y notificaciones outbound

---

## 10. PIPELINE CANÓNICO

```
fuentes reales
  → AssetAlertSnapshot (snapshot assembler)
  → evaluadores (soat adapter, rtm, rc, legal)
  → List<DomainAlert>
  → dedupe
  → sort
  → AlertPromotionService (para Home)
  → mapper de presentación
  → render
```

### Ownership por capa

| Etapa         | Responsabilidad                          | No debe                            |
| ------------- | ---------------------------------------- | ---------------------------------- |
| Fuentes       | Leer datos reales ya persistidos         | Renderizar, decidir UI             |
| Snapshot      | Consolidar foto coherente del activo     | Meter strings UI, calcular alertas |
| Evaluadores   | Aplicar reglas puras, emitir DomainAlert | Depender de widgets, controllers   |
| Dedupe / sort | Limpiar y ordenar                        | Aplicar reglas de negocio          |
| Promotion     | Decidir qué sube a Home                  | Crear lógica nueva de alertas      |
| Mapper        | Convertir DomainAlert en VM              | Lógica de negocio                  |
| UI            | Renderizar                               | Calcular, filtrar, evaluar         |

---

## 11. SNAPSHOT

### 11.1 AssetAlertSnapshot

Debe consolidar como mínimo:

- `assetId`
- `organizationId`
- datos básicos del activo (placa, tipo)
- póliza SOAT relevante
- documento RTM relevante
- póliza RC contractual relevante
- póliza RC extracontractual relevante
- datos jurídicos / limitaciones relevantes
- `sourceUpdatedAt` de cada fuente incluida
- `vehicleServiceType` — tipo de servicio del vehículo extraído de `VehicleContent.serviceType`. Null para activos no vehiculares. Transportado a `facts` por `RcAlertEvaluator` para uso en `AlertPromotionService`.

### 11.2 Criterio de póliza relevante

Para cada tipo de póliza, se selecciona en este orden:

1. La póliza con `fechaFin` más reciente entre las de estado `vigente`
2. Si no hay vigente: la de `fechaFin` más reciente entre las `vencidas`
3. Si no hay ninguna: `null` — el evaluador correspondiente no genera alerta

Este criterio garantiza evaluar el estado real del activo sin procesar histórico irrelevante.

### 11.3 AssetAlertSnapshotAssembler

- Construye `AssetAlertSnapshot` usando repositorios de dominio
- Reutiliza parsers/helpers reales existentes (asset_legal_helpers.dart, asset_rtm_helpers.dart)
- No duplica consultas si existen repositorios o mappers confiables
- Se instancia via DIContainer

---

## 12. DEDUPE Y SORT

### 12.1 Algoritmo de dedupe

Implementado en `lib/core/alerts/support/alert_dedupe.dart`

`dedupeKey` se computa como:

```
dedupeKey = "{code}:{scope}:{sourceEntityId}:{primaryEvidenceId}"
```

Donde `primaryEvidenceId` es el `sourceId` del primer `evidenceRef`.

Si dos alertas tienen el mismo `dedupeKey`, se retiene la de `detectedAt` más reciente.

Regla: no deduplicar por texto renderizado.

### 12.2 Algoritmo de sort

Implementado en `lib/core/alerts/support/alert_sort.dart`

Orden V1 (prioridad descendente):

1. `severity` — critical > high > medium > low
2. Vencido sobre due_soon — `expired` antes que `due_soon` para el mismo dominio
3. Riesgo legal crítico antes que documental ordinario — `embargo_active` y `legal_limitation_active` preceden a `soat_due_soon` en igual severity
4. Menor `daysRemaining` en `facts` — si aplica
5. `sourceUpdatedAt` más reciente — desempate final

---

## 13. CONSUMIDORES CONTEXTUALES V1

### 13.1 Detalle del vehículo

Migración:

- Eliminar `List<String>? alerts` como ruta funcional
- `_AlertsBanner` pasa a consumir `List<AlertCardVm>` derivado de `DomainAlert`
- El mapper convierte `DomainAlert` → `AlertCardVm` añadiendo icono, color y texto renderizado

### 13.2 Vista documental / jurídica

- Consume alertas contextuales de `asset_compliance` directamente
- No recalcula reglas propias
- Muestra evidencia completa de cada alerta

---

## 14. PROMOTION LAYER

### 14.1 AlertPromotionService

Reglas V1:

**Promover individualmente (siempre — equivalente a cumplimiento crítico):**

- `soat_expired`
- `rtm_expired`
- `embargo_active`
- `legal_limitation_active`

**Promover individualmente (por umbral):**

- `soat_due_soon` — solo si `daysRemaining <= 7`
- `rtm_due_soon` — solo si `daysRemaining <= 7`

**Promover RC según tipo de servicio del vehículo (`vehicleServiceType` en `facts`):**

Servicio **público** — RC es cumplimiento operativo obligatorio, equivalente a SOAT/RTM:

| AlertCode                      | Regla                        |
| ------------------------------ | ---------------------------- |
| `rc_contractual_expired`       | Siempre                      |
| `rc_extracontractual_expired`  | Siempre                      |
| `rc_contractual_missing`       | Siempre                      |
| `rc_extracontractual_missing`  | Siempre                      |
| `rc_contractual_due_soon`      | Solo si `daysRemaining <= 7` |
| `rc_extracontractual_due_soon` | Solo si `daysRemaining <= 7` |

Servicio **particular** — RC es riesgo patrimonial, no ruido operativo:

| AlertCode                      | Regla                              |
| ------------------------------ | ---------------------------------- |
| `rc_extracontractual_expired`  | Promover (riesgo patrimonial alto) |
| `rc_extracontractual_missing`  | Promover (riesgo patrimonial alto) |
| `rc_contractual_expired`       | NO promover en V1                  |
| `rc_contractual_missing`       | NO promover en V1                  |
| `rc_contractual_due_soon`      | NO promover en V1                  |
| `rc_extracontractual_due_soon` | NO promover en V1                  |

Servicio **desconocido / null / no reconocido** — falla segura: no promover RC.

Valores reconocidos: `'PÚBLICO'`, `'PUBLICO'`, `'PARTICULAR'`. Cualquier otro valor (incluidos `DIPLOMÁTICO`, `OFICIAL`) cae en desconocido. No asumir comportamiento sin documentarlo aquí primero.

Normalización del campo: centralizada en `AlertPromotionService._resolveVehicleService()`. No duplicar en evaluadores ni en capas superiores.

**No promover individualmente:**

- Documentos vigentes
- `daysRemaining > 7`
- Información positiva
- RC cuando `vehicleServiceType` es desconocido o no aplica

### 14.2 HomeAlertAggregationService

Agrupa alertas del mismo `code` para múltiples activos en un resumen ejecutivo.

Ejemplo: "5 vehículos con RTM vencida" en lugar de 5 alertas individuales.

### 14.3 Regla crítica

Home no decide semántica de negocio.
La promotion layer decide qué sube, cómo y cuándo.

---

## 15. HOME

Home:

- NO calcula alertas
- NO hardcodea listas demo
- Consume `AlertPromotionService` o `HomeAlertAggregationService`
- Elimina `aiMessagesTenantVehicle` como fuente de datos

---

## 16. INYECCIÓN DE DEPENDENCIAS (OBLIGATORIO)

Servicios del pipeline que se registran en `lib/core/di/container.dart`:

- `AssetAlertSnapshotAssembler`
- `AssetComplianceAlertOrchestrator`
- `AlertPromotionService`
- `HomeAlertAggregationService`

Prohibido:

- `Get.find<Service>()` para servicios del pipeline
- Instanciar servicios dentro de widgets o controllers directamente

---

## 17. ARCHIVOS LEGACY

### 17.1 Regla

No eliminar antes de reemplazar. Sustituir primero, eliminar después.

### 17.2 Componentes a migrar o eliminar

| Componente                                          | Archivo                             | Acción                                                              |
| --------------------------------------------------- | ----------------------------------- | ------------------------------------------------------------------- |
| `SmartAlert`, `AlertType`                           | `alert_recommender_controller.dart` | `@Deprecated('LEGACY: ver ALERTS_SYSTEM_V4.md §17')` en Fase 0      |
| `AIBannerMessage`                                   | `ai_banner.dart`                    | Comentario LEGACY en Fase 0; widget puede sobrevivir si consume VMs |
| `AIMessageType`, `AIAlertPriority`, `AIAlertDomain` | `ai_banner.dart`                    | Comentario LEGACY en Fase 0; migrar en Fase 7                       |
| `List<String>? alerts`                              | `asset_summary_vm.dart`             | Eliminar como ruta funcional en Fase 3                              |
| `alerts: const []`                                  | `asset_summary_mapper.dart`         | Reemplazar en Fase 3                                                |

---

## 18. FASES OFICIALES

### FASE 0 — Contención

Objetivo: detener expansión del sistema roto.

Acciones:

- `@Deprecated('LEGACY: ver ALERTS_SYSTEM_V4.md §17')` en `SmartAlert` y `AlertType`
- Comentario `// LEGACY — no usar como fuente canónica. Ver ALERTS_SYSTEM_V4.md §17.` en `AIBannerMessage`, `AIMessageType`, `AIAlertPriority`
- No agregar nuevas features basadas en `List<String>` como contrato de alertas
- No agregar mocks nuevos al Home

Dependencias: ninguna.

Definition of Done:

- `SmartAlert` y `AlertType` tienen `@Deprecated` con referencia al doc
- `AIBannerMessage` tiene comentario LEGACY
- No se agregan nuevos mocks de alertas al Home
- `flutter analyze` no introduce nuevos warnings

---

### FASE 1 — Estándar canónico

Objetivo: crear el lenguaje único de alertas.

Entregables:

- `DomainAlert` (freezed, sin dependencias Flutter)
- `AlertCode` (wire-stable)
- `AlertSeverity` con mapeo legacy documentado en código
- `AlertScope`
- `AlertAudience`
- `AlertPromotionPolicy`
- `AlertFactKeys`
- `AlertEvidenceKeys`

Dependencias: Fase 0 completa.

Definition of Done:

- Todos los archivos existen en rutas canónicas (§4)
- Ningún archivo de `lib/domain/` importa `package:flutter`
- `AlertCode` implementa `wireName` y `fromWire`
- `AlertSeverity` tiene tabla de mapeo legacy como comentario en el archivo
- `flutter analyze` limpio en todos los archivos nuevos

---

### FASE 2 — Productor contextual V1 (asset_compliance)

Objetivo: primer pipeline real con data real.

Entregables:

- `AssetAlertSnapshot`
- `AssetAlertSnapshotAssembler`
- `soat_alert_adapter.dart` (en core/alerts/evaluators/)
- `RtmAlertEvaluator`
- `RcAlertEvaluator`
- `LegalAlertEvaluator`
- `AssetComplianceAlertOrchestrator`
- `alert_dedupe.dart`
- `alert_sort.dart`

Dependencias: Fase 1 completa.

Definition of Done:

- El snapshot consolida pólizas reales desde repositorios existentes
- `soat_alert_adapter` llama a `evaluateSoat()` y `getSoatPriority()`; no duplica su lógica
- Todos los evaluadores emiten `DomainAlert` con los campos obligatorios de §5.1
- El orquestador retorna `List<DomainAlert>` con dedupe y sort aplicados
- Ningún evaluador importa `package:flutter` ni controllers GetX
- El assembler se registra en DIContainer
- Dado un activo con SOAT vencido: el pipeline produce exactamente 1 alerta `code: soat_expired`

---

### FASE 3 — Consumo contextual V1

Objetivo:
Conectar el pipeline canónico de alertas (Fase 2) con la capa de presentación,
mostrando alertas reales en vistas del activo SIN introducir lógica de negocio en UI.

Dependencias: Fase 2 completa.

Alcance:

- Detalle del vehículo
- Vista documental / jurídica del activo

Fuera de alcance:

- Home global
- Promotion layer
- Limpieza completa del sistema legacy

---

Arquitectura obligatoria:

Flujo único:

AssetComplianceAlertOrchestrator
→ List<DomainAlert>
→ DomainAlertMapper
→ List<AlertCardVm>
→ Widgets (render)

Reglas:

- DomainAlert nunca llega crudo a UI
- Widgets NO ejecutan evaluadores
- Widgets NO recalculan reglas
- Mapper NO decide lógica de negocio (solo transformación)

---

Entregables:

1. ViewModel de presentación

- `AlertCardVm`
  - title (resuelto desde i18n)
  - subtitle
  - severity
  - code
  - flags UI (sin widgets)

2. Mapper

- `DomainAlertMapper`
- Transformación pura:
  - DomainAlert → AlertCardVm
- Puede:
  - resolver i18n keys
- NO puede:
  - recalcular severidad
  - cambiar prioridad
  - filtrar alertas

3. Integración — detalle del vehículo

- `_AlertsBanner`:
  - consume List<AlertCardVm>
  - render puro
- Eliminar completamente:
  - `List<String>? alerts`
  - `alerts: const []`
  - cualquier mock

4. Integración — vista documental / jurídica

- consume el mismo pipeline
- NO recalcula estado de documentos
- usa mapper o uno específico si requiere más detalle

---

Reglas de migración (OBLIGATORIAS):

- Prohibido usar List<String> como contrato de alertas
- Prohibido crear alertas en widgets o controllers
- Prohibido duplicar lógica del dominio en presentation
- Prohibido mantener sistemas legacy activos en paralelo

---

Definition of Done:

- `_AlertsBanner` renderiza AlertCardVm reales
- `asset_summary_mapper.dart` NO contiene `alerts: const []`
- Ningún widget contiene lógica de evaluación de alertas
- La vista documental consume DomainAlert vía mapper
- No existe ningún flujo activo basado en List<String>
- Dado un activo con SOAT vencido:
  - aparece alerta en detalle del vehículo
  - aparece alerta en vista documental
  - ambas provienen del mismo pipeline (orchestrator)

---

Criterio de fallo:

La fase falla si:

- existen dos fuentes de alertas activas
- un widget calcula reglas de negocio
- se usan mocks para renderizar alertas
- el mapper modifica la lógica del dominio

---

### FASE 4 — Promotion layer

Objetivo: promover alertas al Home de forma controlada.

Entregables:

- `AlertPromotionService`
- `HomeAlertAggregationService`
- Diferenciación RC por tipo de servicio del vehículo (§14.1)

Dependencias: Fase 3 completa.

Definition of Done:

- `TenantHomeController` deja de usar `aiMessagesTenantVehicle` como fuente
- Home muestra alertas críticas reales
- Las reglas de §14.1 son verificables en código
- Home no crea lógica de negocio propia
- RC no se promueve igual para servicio público y particular
- La diferencia RC depende exclusivamente de `vehicleServiceType` en `facts`
- `AlertPromotionService` contiene toda la lógica de diferenciación RC
- Controller, mapper y widgets no toman decisiones semánticas

CERRADA (2026-03).

---

Chat Gpt propone ajustar el documento de la Fase 5

### FASE 5 — Home global ✅ CERRADA (2026-03)

Objetivo:
Dejar Home consumiendo alertas reales del sistema canónico, sin mocks ni fuentes paralelas.

Entregables:

- Integración de Home con la ruta oficial:
  HomeAlertAggregationService
  → AlertPromotionService
  → DomainAlertMapper
  → AlertCardVm
  → Home
- Eliminación de listas demo y mocks activos
- Home con fuente única de alertas promovidas

Dependencias:

- Fase 4 completa

Arquitectura obligatoria:

- Home NO crea lógica de negocio
- TenantHomeController NO filtra ni prioriza alertas
- Home consume una sola fuente: `TenantHomeController.aiMessages` (derivado del pipeline)
- AIBannerMessage, si sobrevive, solo puede existir como bridge visual temporal

Queda prohibido en Home:

- listas mock de alertas
- fuentes paralelas de alertas
- construcción manual de mensajes de alerta en UI o en el controller

Definition of Done:

- No quedan placeholders demo visibles en producción
- No existe ninguna fuente paralela de alertas en Home
- TenantHomeController consume HomeAlertAggregationService, no mocks ni listas hardcodeadas
- Aggregation muestra resúmenes multi-activo cuando aplica
- Home renderiza VMs del pipeline canónico
- El bridge legacy, si existe, no es fuente primaria

Criterio de fallo:

- La fase falla si Home sigue leyendo mocks
- La fase falla si el controller toma decisiones semánticas
- La fase falla si existen dos fuentes activas de alertas
- La fase falla si Aggregation Layer no participa realmente

Definition of Done verificado (2026-03):

- ✅ Mocks de `aiMessages` eliminados de `_loadMockData()`
- ✅ `TenantHomeController` (inline) consume `HomeAlertAggregationService` via `DIContainer()`
- ✅ `AIBannerMessage` sobrevive como bridge visual; no es fuente de dominio
- ✅ Una sola fuente activa: `_loadPromotedAlerts()` → pipeline canónico
- ✅ `body` envuelto en `Obx` para reactividad async del banner
- ✅ Controller huérfano en `controllers/tenant/home/` marcado como SUPERSEDED (candidato Fase 7)

---

### FASE 5.5 — Reactividad V1 + AlertCenter + UX completa ✅ CERRADA (2026-03)

Objetivo:
Hacer el sistema de alertas reactivo a cambios de datos, exponer todas las alertas
sin filtro de promoción en una vista dedicada, y completar la UX de entrada desde Home.

Entregables:

- **Reactividad V1** (`TenantHomeController`):
  - Watchers Isar: `InsurancePolicyModel.watchLazy()` + `AssetVehiculoModel.watchLazy()`
  - Debounce 800ms, guard `_isRefreshing`, request ID anti-stale
  - `refreshAlerts()` público para pull-to-refresh
  - Logging de performance en debug: `[Alerts] refresh took Xms`

- **AlertCardVm extendido**:
  - `sourceEntityId` (required) — assetId para routing
  - `actionLabel` (nullable) — etiqueta del CTA
  - `actionRoute` (nullable) — ruta canónica sin ID embebido

- **DomainAlertMapper actualizado**:
  - Resuelve `sourceEntityId`, `actionLabel`, `actionRoute`
  - `actionRoute` usa rutas canónicas (ej. `/asset/insurance/soat`)
  - Caller pasa `arguments: vm.sourceEntityId` al navegar

- **HomeAlertAggregationService.allAlertsForOrg()**:
  - Igual que `promotedAlertsForOrg()` pero sin `AlertPromotionService`
  - Aplica `sortAlerts()` — todas las alertas visibles por severidad

- **AlertCenterController + Binding**:
  - Fuente: `allAlertsForOrg()` (no filtrada por promoción)
  - `filteredAlerts` derivado de `alerts + activeFilter`
  - Filtros: Todas, Críticas, Documentos, Legal (V1); Mantenimiento/Contabilidad/Compras (Fase 6, disabled)

- **AlertCenterPage** (`/alerts/center`):
  - Chips de filtro horizontal
  - Sección CRITICAL separada visualmente (siempre arriba)
  - CTA por alerta: `Get.toNamed(route, arguments: sourceEntityId)`
  - Empty state honesto: no afirma "todo al día", solo "no se detectaron..."
  - Pull-to-refresh

- **Métricas en Home** (`_AlertsSummaryCard`):
  - Total de alertas, críticas, activos afectados
  - Tap → `/alerts/center`
  - Solo visible cuando `totalAlertsCount > 0`

- **Fix `AIAlertDomain`**:
  - Antes: todas las alertas → `AIAlertDomain.documentos` (bug)
  - Ahora: SOAT/RTM/RC → `documentos`; embargo/limitación → `legal`; resto → `operativo`

Dependencias: Fase 5 completa.

Definition of Done verificado (2026-03):

- ✅ Sincronizar póliza nueva → Home actualiza en ≤1s sin intervención del usuario
- ✅ Dos cambios rápidos de Isar → solo 1 pipeline se ejecuta (guard + debounce)
- ✅ Pull-to-refresh mientras hay refresh en vuelo → resultado stale descartado (request ID)
- ✅ Home muestra card con total/críticas/activos → tap navega a AlertCenterPage
- ✅ AlertCenterPage muestra CRITICAL en sección prominente arriba
- ✅ AlertCenterPage filtra por Todas/Críticas/Documentos/Legal correctamente
- ✅ Cada alerta tiene actionLabel y actionRoute funcional
- ✅ Filtros Mantenimiento/Contabilidad/Compras aparecen disabled (no crash)
- ✅ AlertCenterPage vacía → empty state honesto con CTA "Revisar activos"
- ✅ `AIAlertDomain` correcto por código de alerta

---

### FASE 6 — Escalamiento por dominio

Objetivo: extender el patrón a otros dominios.

Productores futuros:

- `maintenance_operations`
- `accounting_risk`
- `purchasing_execution`

Dependencias: Fase 5 completa o patrón `asset_compliance` validado.

Definition of Done por dominio:

- Produce `DomainAlert` usando el contrato canónico de §5
- Reutiliza pipeline, dedupe, sort y promotion
- No crea taxonomía propia paralela
- Se proyecta contextualmente y hacia Home según `promotionPolicy`

---

### FASE 7 — Limpieza final

Objetivo: eliminar legacy una vez el reemplazo esté estable.

Eliminar solo después de que ningún consumer dependa del sistema viejo:

- `AIBannerMessage` como pseudo-modelo de alertas
- `AIMessageType`, `AIAlertPriority`, `AIAlertDomain` como taxonomía canónica
- `AlertType`, `SmartAlert`
- `List<String>? alerts` en flujos funcionales
- Mappers legacy sin consumers

Definition of Done:

- `flutter analyze` limpio sin warnings de deprecated
- No queda taxonomía paralela como fuente real de alertas
- El pipeline canónico es la única ruta oficial

---

## 19. REGLAS INNEGOCIABLES

1. Una alerta se define una sola vez.
2. El dominio nunca depende de UI (`package:flutter`).
3. Home nunca crea lógica de alertas.
4. No hay strings renderizados como contrato canónico — solo keys.
5. No hay enums de alerta duplicados por módulo.
6. Toda alerta canónica tiene `code`, `severity`, `scope`, `audience`, `evidenceRefs`.
7. SOAT existente se adapta mediante adapter en core; no se duplica.
8. No se crea `lib/application/` ni ninguna capa no definida en §3.
9. DI obligatorio para servicios del pipeline; prohibido `Get.find<>()`.
10. Fact keys y evidence keys centralizados; prohibido inventar keys fuera de sus archivos.
11. Todo archivo nuevo lleva encabezado canónico (Qué hace, Qué NO hace, Principios, Enterprise Notes).
12. Enums nuevos son wire-stable: `wireName` + `fromWire`.
13. V1 calcula on-read; no persiste alertas como entidad separada.
14. Sustituir antes de eliminar; nunca eliminar sin reemplazo activo.

---

## 20. NO OBJETIVOS DE V1

V1 no busca:

- resolver i18n completo (titleKey y bodyKey son contratos para futura integración)
- rediseñar Home entero
- persistir alertas como colección independiente
- integrar SIMIT
- cubrir mantenimiento, contabilidad o compras
- unificar visualmente todos los banners

---

## 21. FRASE FINAL

Primero estándar.
Luego contexto.
Después promoción.
Finalmente Home.

Cualquier implementación que invierta este orden reconstruye el mismo sistema roto.
