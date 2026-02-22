# DOMAIN_CONTRACTS.md

## Avanzza 2.0 — Domain Contracts & Business Invariants

> **TIPO:** Contrato de Dominio
> **ESTADO:** ACTIVO / VIGENTE
> **VERSIÓN:** 1.1.3
> **AUTORIDAD:** ALTA
> **SUBORDINADO A:**
>
> - GOVERNANCE_CORE.md
> - GOVERNANCE_USER_WORKSPACE.md
>   **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO DEL DOCUMENTO

Este documento define, de forma **explícita, cerrada y no ambigua**, los **contratos de dominio** de Avanzza 2.0.

Su objetivo es:

- Definir **qué dominios existen**.
- Establecer **qué entidades pertenecen a cada dominio**.
- Determinar **campos obligatorios**, **relaciones permitidas** y **restricciones duras**.
- Evitar modelos malformados, entidades híbridas o lógica cruzada indebida.

Este documento es la **fuente única de verdad** para:

- Modelado de entidades
- Casos de uso
- Repositorios de dominio
- Validaciones de negocio

---

## 2. JERARQUÍA DE AUTORIDAD

Orden de precedencia obligatorio:

1. **GOVERNANCE_CORE.md**
2. **GOVERNANCE_USER_WORKSPACE.md**
3. **DOMAIN_CONTRACTS.md** (este documento)
4. `UI_CONTRACTS.md`
5. Guías técnicas o decisiones de implementación

**Regla dura:**
Si un modelo, campo o relación **no está permitido aquí**, **NO EXISTE** en el sistema.

---

## 3. PRINCIPIOS GENERALES DE DOMINIO [CRÍTICOS]

### 3.1 Dominio ≠ UI ≠ Infraestructura

- El Dominio **NO conoce** pantallas, widgets, Firestore, APIs ni DTOs.
- El Dominio define **qué es válido**, no **cómo se guarda** ni **cómo se muestra**.

### 3.2 Asset-Centricity [CRÍTICO]

- Todo dominio operativo gira alrededor de un **Asset**.
- Ningún dominio puede operar "en abstracto" sin Asset cuando aplique.

### 3.3 Scope Organizacional

- Todas las entidades de dominio **DEBEN** estar asociadas a `orgId`.
- No existen entidades "globales" de negocio.

### 3.4 Identificadores Fuertes

- Los IDs no son `string` ni `int` primitivos.
- Cada dominio debe usar **Value Objects** (`AssetId`, `OrgId`, etc.).

### 3.5 Excepción Controlada: `@JsonValue` en Enums de Dominio [ACLARACIÓN]

`@JsonValue` es una **anotación declarativa de wire-format** permitida en enums de dominio.

**Reglas duras:**

- `@JsonValue` **NO constituye** acoplamiento a infraestructura. Es metadata declarativa que define la representación canónica del valor, no una dependencia ejecutable.
- La anotación **no introduce** lógica de serialización en el dominio. La lógica la genera exclusivamente el codegen (`json_serializable` / Freezed).
- Esta es una **excepción explícitamente autorizada** al principio 3.1 ("Dominio ≠ Infraestructura").
- Ningún getter, método ni extensión del enum (incluyendo `wireName`, `wire` u otros) sustituye, complementa ni contradice lo que `@JsonValue` define.
- Véase: **ENUM SERIALIZATION STANDARD** para reglas completas.

**Prohibiciones:**

- ❌ Introducir lógica de serialización imperativa (`toJson()` manual) en enums de dominio.
- ❌ Usar dependencias de infraestructura más allá de `@JsonValue` (imports de HTTP, Firestore, Isar, etc.).
- ❌ Invocar `@JsonValue` como justificación para acoplar otras capas al dominio.

---

## 4. VALUE OBJECTS ESTÁNDAR (SHARED KERNEL)

### Regla Dura Global [CRÍTICO]

**TODOS** los Value Objects definidos en este Shared Kernel son:

- **Inmutables:** Una vez creados, no pueden modificarse. Cualquier "cambio" requiere crear una nueva instancia.
- **Comparables por valor:** Dos instancias son iguales si y solo si todos sus campos internos son iguales.
- **Sin identidad propia:** No poseen `id`, no tienen ciclo de vida, no son entidades.

**Prohibiciones:**

- ❌ Mutar un Value Object después de su creación.
- ❌ Asignar identidad o lifecycle a un Value Object.
- ❌ Persistir Value Objects como entidades independientes.

---

Los siguientes objetos son **inmutables, universales y obligatorios**:

### 4.1 MonetaryAmount

`{ amount: Decimal, currency: ISO_4217 }`

**Regla dura:**
Prohibido operar entre monedas sin conversión explícita.

### 4.2 GeoLocation

`{ lat: double, lng: double, timestamp: UTCDate }`

### 4.3 AuditMetadata

`{ createdBy: UserId, createdAt: UTCDate, reason: string }`

---

## 5. DOMINIOS DEFINIDOS (CANÓNICOS)

Avanzza 2.0 reconoce **únicamente** los siguientes dominios:

1. IAM (Identity & Access)
2. Assets
3. Maintenance
4. Accounting
5. Purchases
6. Insurance

👉 Cualquier dominio nuevo requiere **nueva versión de este documento**.

---

## 6. DOMAIN: IAM (IDENTITY & ACCESS MANAGEMENT)

### 6.1 Entidad Principal: Organization

**Campos:**

- `orgId`
- `legalName`
- `subscriptionPlan`
- `status`

**Regla Dura:**
Ningún Asset, Usuario o Registro puede crearse si la Organization no está en estado `ACTIVE`.

### 6.2 Entidad: UserProfile

**Campos:**

- `userId`
- `orgId`
- `roles` (RBAC)

**Regla Dura:**
No existen usuarios flotantes fuera de una organización.

### 6.3 Value Object Obligatorio: OrganizationAccessContract [CRÍTICO]

Toda `Organization` **DEBE** poseer un `OrganizationAccessContract` como Value Object inmutable obligatorio.

**Naturaleza:**

- Es un **contrato empresarial de acceso y monetización**, no lógica de UI.
- Define las capacidades, límites y restricciones operativas de la organización.
- Es **deny-by-default**: toda capacidad no explícitamente habilitada está prohibida.

**Campos gobernados:**

- `InfrastructureMode` — modo de conectividad/persistencia.
- `IntelligenceTier` — nivel de inteligencia/IA disponible.
- `StructuralCapabilities` — capacidades estructurales habilitadas (booleanos).
- Límites cuantitativos — máximo de assets, miembros, etc. (`QuantitativeLimit`).

**Persistencia:**

- Puede persistirse como `contractJson` (JSON String) en modelos de datos.
- **DEBE** incluir `schemaVersion` obligatorio en su representación serializada.

**Reglas Duras:**

1. `schemaVersion` **DEBE** validarse en runtime al deserializar.
2. Versiones de esquema antiguas **NO pueden** habilitar capacidades nuevas sin migración explícita.
3. **Prohibido** fallback implícito: si `schemaVersion` no es reconocido, el sistema debe rechazar o migrar explícitamente, nunca asumir defaults silenciosos para capacidades nuevas.
4. El contrato es **inmutable** una vez asignado. Cambios requieren nueva instancia con auditoría.
5. La coherencia interna del contrato (ej: `IntelligenceTier.advanced` requiere `InfrastructureMode` con cloud) **DEBE** validarse en el constructor o factory del aggregate.

**Prohibiciones:**

- ❌ Organización sin `OrganizationAccessContract` asignado.
- ❌ Habilitar capacidades por fuera del contrato (bypass).
- ❌ Interpretar el contrato en capa UI sin pasar por policies/use cases.
- ❌ Fallback implícito de `schemaVersion`.

---

## 7. DOMAIN: ASSETS (DOMINIO FUNDACIONAL)

### 7.1 Entidad Principal: Asset

**Campos Obligatorios**

- `assetId`
- `orgId`
- `assetType` (enum estable)
- `status` (enum estable)
- `audit` (AuditMetadata)

**Reglas Duras**

- `assetId ≠ vehicleId`
- Un Asset puede existir sin ser vehículo.
- Asset es la raíz para Maintenance, Accounting e Insurance.

**Relaciones Permitidas**

- Asset → MaintenanceRecord (1:N)
- Asset → AccountingEntry (1:N)
- Asset → InsurancePolicy (0:N)

**Antipatrones Prohibidos**

- ❌ Asset sin `orgId`
- ❌ Vehicle como raíz independiente

---

## 8. DOMAIN: MAINTENANCE

### 8.1 Entidad Principal: MaintenanceRecord

**Campos Obligatorios**

- `maintenanceId`
- `assetId`
- `orgId`
- `maintenanceType`
- `status`
- `scheduledAt` (si aplica)

### 8.2 Máquina de Estados (OBLIGATORIA)

Transiciones permitidas:

- `DRAFT` → `SCHEDULED`
- `SCHEDULED` → `IN_PROGRESS` | `CANCELLED`
- `IN_PROGRESS` → `COMPLETED` | `HALTED`
- `COMPLETED` → `VERIFIED`

**Reglas Duras**

- No existe mantenimiento sin Asset.
- Maintenance **NO** genera efectos financieros directos (emite eventos).

---

## 9. DOMAIN: ACCOUNTING

### 9.1 Entidad Principal: AccountingEntry

**Campos Obligatorios**

- `entryId`
- `assetId?` _(opcional, condicionado por `scope`)_
- `orgId`
- `scope` (AccountingEntryScope — **obligatorio**)
- `money` (MonetaryAmount)
- `entryType` (INCOME | EXPENSE)
- `sourceReference` (`maintenanceId` | `purchaseId` | `manualInput`)

### 9.2 Scope de Asiento Contable [CRÍTICO]

**Definición formal:**

```dart
enum AccountingEntryScope {
  @JsonValue('asset')
  asset,

  @JsonValue('organization')
  organization,
}
```

**Reglas Duras:**

1. `scope` es **obligatorio** en todo `AccountingEntry`.
2. Si `scope == asset` → `assetId` es **obligatorio** (no null).
3. Si `scope == organization` → `assetId` **DEBE** ser null.
4. **Prohibido** usar "Asset genérico" como workaround para gastos organizacionales.
5. **Inmutabilidad Total** se mantiene: prohibido editar o borrar. Correcciones vía **Contra-Asiento (Reversal Entry)**.

**Invariante Ejecutable [NO NEGOCIABLE]:**

La coherencia entre `scope` y `assetId` **DEBE** validarse en el constructor del aggregate.

- Esta validación es **contrato ejecutable**, no recomendación.
- Cualquier violación **DEBE** lanzar error de dominio.
- No se permite instanciar un `AccountingEntry` con `scope == asset` y `assetId == null`.
- No se permite instanciar un `AccountingEntry` con `scope == organization` y `assetId != null`.

---

## 10. DOMAIN: PURCHASES

### 10.1 Entidad Principal: PurchaseOrder

**Campos Obligatorios**

- `purchaseId`
- `assetId?` _(opcional, condicionado por `scope`)_
- `orgId`
- `scope` (PurchaseScope — **obligatorio**)
- `supplierId`
- `status`
- `totalAmount` (MonetaryAmount)

### 10.2 Scope de Compra [CRÍTICO]

**Definición formal:**

```dart
enum PurchaseScope {
  @JsonValue('asset')
  asset,

  @JsonValue('organization')
  organization,
}
```

**Reglas Duras:**

1. `scope` es **obligatorio** en todo `PurchaseOrder`.
2. Si `scope == asset` → `assetId` es **obligatorio** (no null).
3. Si `scope == organization` → `assetId` **DEBE** ser null.
4. **Prohibido** usar "Asset genérico" como workaround para compras organizacionales.
5. Purchases **NO ejecuta pagos**.

**Invariante Ejecutable [NO NEGOCIABLE]:**

La coherencia entre `scope` y `assetId` **DEBE** validarse en el constructor del aggregate.

- Esta validación es **contrato ejecutable**, no recomendación.
- Cualquier violación **DEBE** lanzar error de dominio.
- No se permite instanciar un `PurchaseOrder` con `scope == asset` y `assetId == null`.
- No se permite instanciar un `PurchaseOrder` con `scope == organization` y `assetId != null`.

---

## 11. DOMAIN: INSURANCE

### 11.1 Entidad Principal: InsurancePolicy

**Campos Obligatorios**

- `policyId`
- `assetId`
- `orgId`
- `providerId`
- `coverageType`
- `validityPeriod` (DateRange)

**Reglas Duras**

- Insurance no procesa pagos.
- Insurance no existe sin Asset.

---

## 12. REGLAS TRANSVERSALES Y ANTIPATRONES

### 12.1 Antipatrones Globales Prohibidos

- ❌ Entidades Dios
- ❌ Campos dinámicos sin contrato
- ❌ Reutilizar entidades entre dominios
- ❌ "Ya lo validamos en UI"

---

## 13. INTERACCIÓN ENTRE DOMINIOS (DOMAIN EVENTS)

### 13.1 Principio

La comunicación entre dominios es **asíncrona** y **eventualmente consistente**.

Patrón obligatorio:
`Domain Event` → `Side Effect (Handler)`

### 13.2 Regla Dura: Naturaleza de los Domain Events [CRÍTICO]

Los Domain Events son **notificaciones de hechos pasados**. NO son mecanismos de control.

**Los Domain Events:**

- ✅ Comunican que algo **ya ocurrió** (hecho consumado).
- ✅ Son inmutables una vez emitidos.
- ✅ Transportan datos mínimos necesarios para el consumidor.

**Los Domain Events NO:**

- ❌ Ejecutan lógica de negocio (la lógica vive en el Handler).
- ❌ Validan reglas de dominio (la validación ocurre antes de emitir).
- ❌ Son comandos ni intenciones (los comandos son otra cosa).
- ❌ Orquestan flujos sin un Handler explícito que procese el evento.

**Regla dura:**
El evento **solo comunica**. El Handler **decide y actúa**.
Usar eventos para orquestación implícita sin handler definido es un **antipatrón prohibido**.

---

### 13.3 Estándar de Eventos de Dominio [CRÍTICO]

#### A. Envelope Canónico

```json
{
  "eventId": "UUID",
  "occurredOn": "ISO-8601 UTC",
  "eventName": "UPPER_SNAKE_CASE",
  "version": "1.0",
  "orgId": "OrgId",
  "payload": {}
}
```

#### B. Naming Convention

Los eventos nombran hechos ya ocurridos, no intenciones.

- ❌ CREATE_INVOICE (comando)
- ✅ INVOICE_CREATED (evento)

Formato recomendado: `DOMAIN_ENTITY_PAST_VERB` (UPPER_SNAKE_CASE)

Ejemplos:

- MAINTENANCE_COMPLETED
- ASSET_STATUS_CHANGED
- PURCHASE_AUTHORIZED

#### C. Catálogo de Eventos Canónicos (Mínimos)

Este catálogo define eventos base y payload mínimo obligatorio.

| eventName             | Trigger (Causa)                | Payload mínimo obligatorio                                      | Consumidores típicos             |
| --------------------- | ------------------------------ | --------------------------------------------------------------- | -------------------------------- |
| MAINTENANCE_COMPLETED | Mantenimiento finalizado       | `maintenanceId`, `assetId`, `finalCost: MonetaryAmount`         | Accounting, Asset                |
| ASSET_STATUS_CHANGED  | Cambio ciclo de vida del asset | `assetId`, `oldStatus`, `newStatus`                             | Tracking, Insurance, Maintenance |
| PURCHASE_AUTHORIZED   | Compra aprobada                | `purchaseId`, `assetId?`, `money: MonetaryAmount`, `approverId` | Accounting, Logistics            |

**Notas:**

- `MonetaryAmount` es obligatorio para dinero (no primitives).
- `assetId?` solo es opcional cuando el dominio no aplica (ej. compra no ligada a asset).

#### D. Regla de Idempotencia [CRÍTICO]

Todos los consumidores (Handlers) **DEBEN** ser idempotentes.

**Regla:**
Si el handler recibe el mismo `eventId` dos veces, la segunda ejecución:

- Debe ser ignorada, o
- Retornar éxito sin duplicar efectos secundarios.

**Ejemplo:**

- `MAINTENANCE_COMPLETED` no puede generar dos `AccountingEntry`.
- `PURCHASE_AUTHORIZED` no puede duplicar reservas/cargos.

### 13.4 Delivery Semantics Mínima [CRÍTICO]

**Modelo de entrega:** At-Least-Once Delivery.

El sistema garantiza que todo Domain Event será entregado **al menos una vez** a cada consumidor registrado.

**Reglas Duras:**

1. **Handlers obligatoriamente idempotentes.** Recibir el mismo evento más de una vez **NO DEBE** producir efectos duplicados. La ausencia de idempotencia constituye **violación crítica de contrato**.
2. **Registro persistente de `eventId` procesados.** Todo handler **DEBE** mantener un registro persistente de los `eventId` ya procesados para detectar y descartar duplicados.
3. **No se asume orden global entre dominios.** Los eventos de distintos dominios pueden llegar en cualquier orden. El sistema **NO garantiza** ordenamiento causal entre dominios.
4. **Orden garantizado solo dentro del aggregate raíz.** Los eventos emitidos por un mismo aggregate raíz **DEBEN** procesarse en el orden en que fueron emitidos, dentro del contexto de ese aggregate.

**Prohibiciones:**

- ❌ Asumir entrega exactamente-una-vez (exactly-once) sin mecanismo explícito de deduplicación.
- ❌ Depender del orden de llegada entre dominios para lógica de negocio.
- ❌ Handlers sin mecanismo de idempotencia verificable.

---

## 14. REGLAS DE GENERACIÓN PARA IA (STRICT MODE) [CRÍTICO]

Toda IA que genere código para Avanzza 2.0 **DEBE** seguir este protocolo verificable:

### 14.1 Execution Summary (Obligatorio, verificable)

Antes del código, la IA **DEBE** declarar explícitamente:

- **Dominio(s) afectado(s):** [X, Y]
- **Reglas duras aplicadas:** (referencia a secciones de este documento)
- **Invariantes verificados:** (orgId, inmutabilidad, state machine, value objects)
- **Eventos emitidos/consumidos:** [eventName] + payload mínimo

Si no puede determinar esto:
👉 **STOP AND REPORT**

### 14.2 Validación de Invariantes (No negociable)

La IA **DEBE** verificar si el cambio viola:

- Inmutabilidad (ej. AccountingEntry)
- Jerarquía (GOVERNANCE_CORE y GOVERNANCE_USER_WORKSPACE)
- Máquinas de estado (ej. Maintenance transitions)
- Scope organizacional (orgId)

### 14.3 Uso obligatorio de Value Objects

Prohibido usar tipos primitivos para:

- Dinero → `MonetaryAmount`
- Coordenadas → `GeoLocation`
- Auditoría → `AuditMetadata`
- IDs → Value Objects/Ids canónicos cuando existan

### 14.4 Emisión de Eventos (cuando aplica)

Si el código crea, actualiza estado, o genera efectos persistentes, **DEBE** incluir emisión del evento canónico correspondiente (Sección 13.3).

### 14.5 Stop & Report (Ejemplo)

Si el usuario pide algo como: _"Borra este asiento contable"_

la IA debe responder:

> 🛑 **VIOLACIÓN DE CONTRATO:** Según DOMAIN_CONTRACTS.md Sección 9, los asientos contables son inmutables.
>
> ✅ **Alternativa correcta:** Crear un Contra-Asiento (Reversal Entry).

### 14.6 Resolución de Contradicciones entre Documentos de Gobernanza [CRÍTICO]

Si la IA detecta **contradicción** entre:

- GOVERNANCE_CORE.md
- GOVERNANCE_USER_WORKSPACE.md
- DOMAIN_CONTRACTS.md

**DEBE obligatoriamente:**

1. 👉 **Detener ejecución inmediatamente.**
2. 👉 **Solicitar aclaración humana explícita.**
3. 👉 **NO inferir, asumir ni "elegir" una interpretación.**

**Regla dura:**
La IA **NO tiene autoridad** para resolver ambigüedades entre documentos de gobernanza.
Solo un humano autorizado puede determinar la interpretación correcta.

**Formato de reporte:**

> 🛑 **CONTRADICCIÓN DETECTADA**
>
> - **Documento A:** [cita textual]
> - **Documento B:** [cita textual]
> - **Conflicto:** [descripción breve]
>
> 👉 Requiero aclaración humana antes de continuar.

---

## ENUM SERIALIZATION STANDARD (Enterprise Rule)

> **Versión:** 1.0
> **Aplica a:** Todos los enums de dominio del proyecto Avanzza 2.0
> **Autoridad:** DOMAIN_CONTRACTS.md (Sección vigente, no negociable)

---

### A. PRINCIPIO CANÓNICO

La serialización JSON de enums en Avanzza 2.0 **depende exclusivamente** de la anotación `@JsonValue` declarada en cada valor del enum.

**Reglas duras:**

1. `@JsonValue` es la **única fuente de verdad** del wire-format JSON.
2. El código generado por `json_serializable` / Freezed es el **único mecanismo autorizado** para serializar y deserializar enums.
3. El dominio **no decide** casing, encoding ni representación de red. Eso es responsabilidad de `@JsonValue`.
4. Ningún getter, método ni extensión del enum puede sustituir, complementar ni contradecir lo que `@JsonValue` define.

---

### B. REGLA DE NAMING (wireName / wire)

| Getter     | Propósito                                               | Uso permitido                                               | Uso prohibido                                                                     |
| ---------- | ------------------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `wireName` | Representación estable para logs, debug y telemetría    | `toDebugString()`, `toString()`, logging, métricas internas | Persistencia JSON, payloads de red, comparación de strings para lógica de negocio |
| `wire`     | Alias temporal de `wireName` para compatibilidad legacy | Mismo que `wireName` (delegación directa)                   | Persistencia JSON, payloads de red, comparación de strings para lógica de negocio |

**Reglas duras:**

- `wireName` **NO es contrato de red**. Su formato (UPPER_SNAKE, lowercase, etc.) puede cambiar sin migración de datos.
- `wire` **NO es contrato de red**. Es alias de `wireName` y existe únicamente para no romper callers legacy durante transición.
- Solo `@JsonValue` define el string que viaja por la red y se persiste.

---

### C. PROHIBICIONES EXPLÍCITAS

- ❌ **No usar `enum.wireName`** para construir payloads JSON, maps de Firestore ni bodies de API.
- ❌ **No usar `enum.wire`** para persistencia local (Isar) ni remota (Firestore/REST).
- ❌ **No comparar enums por string manualmente** (`if (mode.wireName == 'LOCAL_ONLY')`). Usar identidad de enum (`if (mode == InfrastructureMode.localOnly)`).
- ❌ **No crear `toJson()` manual** en enums que usan `@JsonValue`. La serialización la genera el codegen.
- ❌ **No asumir correspondencia** entre `wireName` y `@JsonValue`. Son representaciones independientes con propósitos distintos.

---

### D. EJEMPLO CORRECTO (Referencia canónica)

```dart
/// Enum con serialización vía @JsonValue (fuente de verdad).
enum InfrastructureMode {
  @JsonValue('local_only')
  localOnly,

  @JsonValue('cloud_lite')
  cloudLite,

  @JsonValue('cloud_full')
  cloudFull,

  @JsonValue('enterprise')
  enterprise;

  // ── wireName: SOLO para logs/debug/telemetría ──

  /// Representación estable para logs. NO es contrato de red.
  String get wireName => switch (this) {
        InfrastructureMode.localOnly => 'LOCAL_ONLY',
        InfrastructureMode.cloudLite => 'CLOUD_LITE',
        InfrastructureMode.cloudFull => 'CLOUD_FULL',
        InfrastructureMode.enterprise => 'ENTERPRISE',
      };

  /// Alias legacy. Delega a wireName.
  String get wire => wireName;

  String toDebugString() => 'InfrastructureMode($wireName)';
}

/// Uso dentro de una clase Freezed serializable.
/// JSON se genera automáticamente — NO hay serialización manual.
@freezed
abstract class OrganizationAccessContract with _$OrganizationAccessContract {
  const factory OrganizationAccessContract({
    @Default(InfrastructureMode.localOnly) InfrastructureMode mode,
    // ... otros campos
  }) = _OrganizationAccessContract;

  factory OrganizationAccessContract.fromJson(Map<String, dynamic> json) =>
      _$OrganizationAccessContractFromJson(json);
}

// ✅ JSON generado automáticamente por codegen:
// { "mode": "local_only" }   ← viene de @JsonValue, NO de wireName
//
// ✅ Uso correcto en logs:
// log('Contrato: ${contract.mode.wireName}');  → "LOCAL_ONLY"
//
// ❌ PROHIBIDO:
// final payload = {'mode': mode.wireName};     → UPPER_SNAKE en JSON = BUG
// final payload = {'mode': mode.wire};         → misma violación
```

---

### E. JUSTIFICACIÓN ARQUITECTÓNICA

1. **Separación de concerns:** La representación de dominio (cómo el código razona sobre enums) es independiente del wire-format (cómo viajan por la red). `@JsonValue` pertenece a la capa de serialización. `wireName` pertenece a la capa de observabilidad. Mezclarlas genera acoplamiento invisible.

2. **Prevención de deuda técnica:** Si un desarrollador usa `wireName` para construir JSON, cualquier cambio de casing en `wireName` (por ejemplo, de UPPER_SNAKE a PascalCase para telemetría) rompe silenciosamente la persistencia. Con `@JsonValue` como única fuente, el wire-format es inmutable e independiente.

3. **Compatibilidad futura:** Si el equipo decide cambiar el naming de `wireName`, renombrar alias o eliminar `wire`, **cero datos persistidos se ven afectados** porque la serialización nunca dependió de ellos. Solo logs y debug strings cambian.

4. **Gobernanza clara:** Un solo punto de verdad (`@JsonValue`) elimina ambigüedad. No hay que preguntarse "¿este enum se serializa con `.wireName`, `.wire`, `.name` o `@JsonValue`?". La respuesta es siempre `@JsonValue`, y el codegen lo garantiza.

5. **Auditoría:** En caso de bug de serialización, el diagnóstico es directo: revisar `@JsonValue` en el enum y el `.g.dart` generado. No hay lógica manual dispersa que investigar.

---

**FIN DE DOMAIN_CONTRACTS.md — v1.1.3**

**HASH DE INTEGRIDAD:** [Reservado para CI/CD]
