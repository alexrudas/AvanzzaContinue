# DOMAIN_CONTRACTS.md

## Avanzza 2.0 — Domain Contracts & Business Invariants

> **TIPO:** Contrato de Dominio
> **ESTADO:** ACTIVO / VIGENTE
> **VERSIÓN:** 1.1.1
> **AUTORIDAD:** ALTA
> **SUBORDINADO A:**
> - GOVERNANCE_CORE.md
> - GOVERNANCE_USER_WORKSPACE.md
> **APLICA A:** Humanos e IA

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
- `assetId`
- `orgId`
- `money` (MonetaryAmount)
- `entryType` (INCOME | EXPENSE)
- `sourceReference` (`maintenanceId` | `purchaseId` | `manualInput`)

**Reglas Duras**
- **Inmutabilidad Total**
- Prohibido editar o borrar.
- Correcciones vía **Contra-Asiento (Reversal Entry)**.

---

## 10. DOMAIN: PURCHASES

### 10.1 Entidad Principal: PurchaseOrder

**Campos Obligatorios**
- `purchaseId`
- `assetId`
- `orgId`
- `supplierId`
- `status`
- `totalAmount` (MonetaryAmount)

**Reglas Duras**
- Toda compra pertenece a un Asset (o Asset genérico de Org).
- Purchases **NO ejecuta pagos**.

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

| eventName | Trigger (Causa) | Payload mínimo obligatorio | Consumidores típicos |
|-----------|-----------------|----------------------------|----------------------|
| MAINTENANCE_COMPLETED | Mantenimiento finalizado | `maintenanceId`, `assetId`, `finalCost: MonetaryAmount` | Accounting, Asset |
| ASSET_STATUS_CHANGED | Cambio ciclo de vida del asset | `assetId`, `oldStatus`, `newStatus` | Tracking, Insurance, Maintenance |
| PURCHASE_AUTHORIZED | Compra aprobada | `purchaseId`, `assetId?`, `money: MonetaryAmount`, `approverId` | Accounting, Logistics |

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

Si el usuario pide algo como: *"Borra este asiento contable"*

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

**FIN DE DOMAIN_CONTRACTS.md — v1.1.1**

**HASH DE INTEGRIDAD:** [Reservado para CI/CD]
