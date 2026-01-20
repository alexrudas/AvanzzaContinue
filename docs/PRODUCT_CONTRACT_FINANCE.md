# PRODUCT CONTRACT: Finance Module

**Avanzza 2.0 — Golden Source v1.2.1**

**Versión:** 1.2.1 (Consolidado Final)

**Fecha:** 2026-01-11

**Tipo:** Contrato de Producto — NO NEGOCIABLE

**Basado en:** PRODUCT_CONTRACT_ASSET_CREATION.md v1.3 (Frozen 2026-01-10)

**Autor:** Product Architecture + CTO Office + Fintech Lead

**Estado:** ✅ FROZEN — Golden Source Único

**Audiencia:** Engineering (Backend, Frontend, QA), Product Management, Finance Team

---

## CHANGELOG

| Versión | Fecha      | Cambios                                                                      |
| ------- | ---------- | ---------------------------------------------------------------------------- |
| 1.0     | 2026-01-11 | Contrato inicial: Event-Driven Finance, Asset-First, Ledger Inmutable        |
| 1.1     | 2026-01-11 | Deuda, Amortización, Motor de Decisión Automática, Kill-Switch               |
| 1.2     | 2026-01-11 | Consolidación con Asset Creation v1.3, resolución de conflictos              |
| 1.2.1   | 2026-01-11 | Definición contractual explícita de portfolioId como workspace NO financiero |

---

## 0. PROPÓSITO ABSOLUTO DEL CONTRATO

### 0.1 Naturaleza del Sistema Financiero

**Avanzza NO tiene un módulo financiero.**

**Avanzza ES un sistema operativo financiero gobernado por eventos.**

**Implicaciones:**

- Toda operación que impacta dinero es un evento financiero.
- Todo evento financiero debe ser rastreable, inmutable y auditable.
- El sistema financiero NO es un add-on, es el core operativo.

### 0.2 Reglas Madre (Axiomas del Sistema)

1. Si un evento NO impacta finanzas → NO existe en el sistema.
2. Si un impacto financiero NO tiene evento → ES INVÁLIDO.
3. Este contrato gobierna TODA lógica financiera presente y futura.

### 0.3 Relación con Asset Creation v1.3

Este contrato EXTIENDE PRODUCT_CONTRACT_ASSET_CREATION.md v1.3:

- Asset Creation v1.3 define el modelo base de Portfolio y Asset.
- Finance v1.2.1 NO MODIFICA esos modelos, solo los CONSUME y EXTIENDE.
- Toda incompatibilidad detectada debe resolverse en Finance, NO en Asset Creation.

---

## I. PRINCIPIOS FUNDAMENTALES (NO NEGOCIABLES)

### 1.1 Event-Driven Finance

**Principio:**

Todo impacto financiero debe nacer de un evento operativo explícito.

**Flujo obligatorio:**

```
EVENTO OPERATIVO → IMPACTO FINANCIERO → ASIENTO EN LEDGER
```

**Ejemplos válidos:**

- RentalPeriodClosed (cierre de período de arrendamiento) → IncomeCalculated → LedgerEntry(INCOME)
- MaintenanceCompleted (mantenimiento completado) → ExpenseIncurred → LedgerEntry(EXPENSE)
- DebtPaymentExecuted (pago de cuota de deuda) → InterestExpenseRecorded + DebtBalanceReduced → LedgerEntry(EXPENSE)

**Prohibiciones absolutas:**

- ❌ Asientos manuales sin evento rastreable.
- ❌ Ajustes silenciosos (ediciones directas de ledger).
- ❌ Ingresos o gastos "huérfanos" (sin eventId).

**Validación técnica:**

```javascript
if (!transaction.eventId || !transaction.eventType) {
  throw new FinancialRuleViolation(
    "Toda transacción debe tener eventId y eventType rastreables"
  );
}
```

### 1.2 Asset-First Accounting

**Principio:**

Toda transacción financiera debe tener assetId obligatorio.

**Jerarquía financiera obligatoria:**

```
ownerId → portfolioId → assetId → operationId → eventId → transactionId
```

**Donde:**

- ownerId = Portfolio.createdBy (usuario propietario del portfolio).
- portfolioId = workspace lógico de agrupación (NO almacena dinero).
- assetId = unidad financiera única (OBLIGATORIA en toda transacción).
- operationId = operación específica (ej: contrato de arrendamiento, servicio).
- eventId = evento que originó la transacción.
- transactionId = identificador único del asiento en ledger.

**Regla estricta:**

```javascript
if (!transaction.assetId) {
  throw new FinancialRuleViolation(
    "Toda transacción financiera debe tener assetId. " +
      "portfolioId solo se usa para agrupación y permisos."
  );
}
```

**Integración con Asset Creation v1.3:**

- assetId es FK a Asset.id (modelo definido en Asset Creation v1.3).
- portfolioId es FK a Portfolio.id (solo para contexto, NO para lógica financiera).
- ownerId se deriva de Portfolio.createdBy (NO se agrega campo nuevo a Portfolio).

### 1.3 Ledger Inmutable (Append-Only)

**Principio:**

El ledger financiero es append-only (solo agregar, nunca editar ni eliminar).

**Reglas de inmutabilidad:**

- ✅ PERMITIDO: Agregar nuevos asientos (INSERT).
- ❌ PROHIBIDO: Actualizar asientos existentes (UPDATE).
- ❌ PROHIBIDO: Eliminar asientos existentes (DELETE).

**Corrección de errores:**

Solo mediante eventos correctivos con transacción inversa.

**Ejemplo de corrección válida:**

```javascript
// Asiento original (error: monto incorrecto)
LedgerEntry {
  entryId: "entry-001",
  assetId: "asset-123",
  type: "INCOME",
  amount: 2000000,  // Error: debió ser 2500000
  eventId: "event-rental-001",
  createdAt: "2026-01-10T10:00:00Z"
}

// ❌ PROHIBIDO: Editar el asiento
UPDATE ledger_entries SET amount = 2500000 WHERE entry_id = 'entry-001';

// ✅ CORRECTO: Evento correctivo
CorrectionEvent {
  eventId: "correction-001",
  originalEntryId: "entry-001",
  reason: "Error en cálculo de canon mensual",
  authorizedBy: "user-admin-001"
}

LedgerEntry {
  entryId: "entry-002",
  assetId: "asset-123",
  type: "INCOME",
  amount: 500000,  // Diferencia (2500000 - 2000000)
  eventId: "correction-001",
  description: "Corrección de canon: +500000",
  createdAt: "2026-01-11T14:00:00Z"
}
```

**Auditoría:**

Todo evento correctivo debe tener:

- reason (justificación obligatoria).
- authorizedBy (quién aprobó la corrección).
- originalEntryId (referencia al asiento corregido).

### 1.4 Naturaleza Financiera Obligatoria

**Principio:**

Toda transacción debe declarar su naturaleza financiera para evitar mezclar conceptos.

**Enum obligatorio:**

```javascript
enum FinancialNature {
  OPERATIVE       // Genera rentabilidad (canon, flete, servicios)
  RECOVERY        // Mitiga pérdidas (recaudo cartera, indemnizaciones)
  EXTRAORDINARY   // No recurrente (venta de activo, ganancia/pérdida excepcional)
}
```

**Impacto en KPIs:**

| Nature        | ¿Cuenta para rentabilidad? | ¿Cuenta para cashflow? | ¿Entra en proyecciones? |
| ------------- | -------------------------- | ---------------------- | ----------------------- |
| OPERATIVE     | ✅ SÍ                      | ✅ SÍ                  | ✅ SÍ                   |
| RECOVERY      | ❌ NO                      | ✅ SÍ                  | ❌ NO                   |
| EXTRAORDINARY | ❌ NO                      | ✅ SÍ                  | ❌ NO                   |

**Separación crítica:**

- OPERATIVE: Ingresos recurrentes que miden rentabilidad del activo (canon, flete).
- RECOVERY: Dinero recuperado de pérdidas previas (NO es ganancia nueva).
- EXTRAORDINARY: Eventos únicos (venta de activo, liquidación).

**Ejemplo de uso correcto:**

```javascript
// Ingreso por canon mensual → OPERATIVE
{
  type: "INCOME",
  nature: "OPERATIVE",
  amount: 2500000,
  eventType: "RentalPeriodClosed"
}

// Pago de cliente moroso → RECOVERY (NO es ganancia nueva)
{
  type: "INCOME",
  nature: "RECOVERY",
  amount: 1500000,
  eventType: "DebtPaymentReceived"
}

// Venta de activo → EXTRAORDINARY
{
  type: "INCOME",
  nature: "EXTRAORDINARY",
  amount: 50000000,
  eventType: "AssetSold"
}
```

### 1.5 Definición Contractual de portfolioId (NO NEGOCIABLE)

**Principio fundamental:**

portfolioId representa únicamente el workspace lógico de agrupación donde vive un activo.

**Características definitivas:**

**✅ portfolioId ES:**

- Un contenedor de agrupación (workspace, carpeta lógica).
- Un filtro de visualización (dashboards, reportes, permisos).
- Una etiqueta de contexto para BI y analytics.
- Un scope de permisos (usuario X puede ver portfolio Y).

**❌ portfolioId NO ES:**

- Una unidad financiera (NO almacena dinero, NO tiene balance).
- Un origen de transacciones (NO genera ingresos ni gastos directamente).
- Una entidad contable (NO aparece en ledger como cuenta).
- Un nivel de consolidación financiera (consolidación se hace sumando assets, NO portfolios).

**Implicaciones operacionales:**

Toda transacción financiera se registra exclusivamente a nivel de assetId.

```javascript
// ✅ CORRECTO: Transacción con assetId
{
  transactionId: "txn-001",
  assetId: "asset-123",           // OBLIGATORIO
  portfolioId: "portfolio-456",   // Solo para contexto/filtrado
  ownerId: "user-789",
  amount: 2500000,
  type: "INCOME",
  nature: "OPERATIVE"
}

// ❌ INCORRECTO: Transacción sin assetId
{
  transactionId: "txn-002",
  portfolioId: "portfolio-456",   // Sin assetId = RECHAZADO
  amount: 500000,
  type: "EXPENSE"
}
// → Lanza FinancialRuleViolation
```

Portfolios sin activos NO generan métricas financieras.

```javascript
// Portfolio vacío (assetsCount = 0)
Portfolio {
  id: "portfolio-empty",
  portfolioName: "Mi Flota Futura",
  status: "DRAFT",
  assetsCount: 0
}

// Consulta financiera
GET /api/v1/portfolios/portfolio-empty/financial-summary
→ Response: {
  "portfolioId": "portfolio-empty",
  "status": "DRAFT",
  "cashflowTotal": 0,
  "message": "Portfolio sin activos. No hay métricas financieras."
}
```

portfolioId se usa SOLO para etiquetar, agrupar, filtrar y consolidar información.

**Casos de uso válidos:**

| Caso de Uso    | Descripción                                      | Válido |
| -------------- | ------------------------------------------------ | ------ |
| Etiquetado     | Asset.portfolioId indica pertenencia a workspace | ✅     |
| Filtrado       | Consultar ingresos de assets en portfolio X      | ✅     |
| Agrupación     | Agrupar activos por portfolio en UI              | ✅     |
| Permisos       | Usuario solo ve portfolios asignados             | ✅     |
| Consolidación  | Sumar métricas de assets del portfolio           | ✅     |
| Balance        | Portfolio tiene balance propio                   | ❌     |
| Transacciones  | Gasto asignado a portfolio sin assetId           | ❌     |
| Transferencias | Mover dinero entre portfolios                    | ❌     |

**Excepción formal: Gastos Administrativos (Overhead).**

Si existen gastos generales del portfolio (ej: administración, seguros globales):

- Se crea un asset ficticio dentro del portfolio:
  - Nombre: "Gastos Administrativos - [Nombre Portfolio]"
  - Tipo: ADMINISTRATIVE_OVERHEAD
  - incomeBaseline = null (no genera ingresos)
- Los gastos se asignan a ese asset ficticio.
- En cálculos de rentabilidad, se distribuyen proporcionalmente a assets reales.

**Ejemplo:**

```javascript
// Asset ficticio para overhead
Asset {
  id: "asset-overhead-001",
  portfolioId: "portfolio-vehiculos",
  assetType: "ADMINISTRATIVE_OVERHEAD",
  assetName: "Gastos Administrativos - Mi Flota",
  incomeBaseline: null,
  operationalStatus: "N_A"
}

// Gasto administrativo asignado al asset ficticio
{
  assetId: "asset-overhead-001",  // ✅ VÁLIDO
  portfolioId: "portfolio-vehiculos",
  amount: 500000,
  type: "EXPENSE",
  category: "ADMINISTRATIVE"
}
```

**Validación técnica:**

```typescript
export class FinancialTransactionService {
  async createTransaction(dto: TransactionCreateDTO): Promise<Transaction> {
    // Validación 1: assetId obligatorio
    if (!dto.assetId) {
      throw new FinancialRuleViolation(
        "assetId es obligatorio. portfolioId solo se usa para agrupación."
      );
    }

    // Validación 2: Verificar que asset existe
    const asset = await this.assetRepository.findById(dto.assetId);
    if (!asset) {
      throw new AssetNotFoundError(`Asset ${dto.assetId} no existe`);
    }

    // Validación 3: Consistencia portfolio ↔ asset
    if (dto.portfolioId && asset.portfolioId !== dto.portfolioId) {
      throw new ConsistencyError(
        `Asset ${dto.assetId} pertenece a portfolio ${asset.portfolioId}, ` +
          `no a ${dto.portfolioId}`
      );
    }

    // Auto-asignar portfolioId del asset
    dto.portfolioId = asset.portfolioId;
    dto.ownerId = asset.ownerId;

    return this.ledgerRepository.create(dto);
  }
}
```

**Resumen contractual:**

| Concepto             | portfolioId        | assetId                   |
| -------------------- | ------------------ | ------------------------- |
| Naturaleza           | Workspace lógico   | Unidad financiera         |
| Almacena dinero      | ❌ NO              | ✅ SÍ (vía transacciones) |
| Genera transacciones | ❌ NO              | ✅ SÍ (obligatorio)       |
| Tiene balance        | ❌ NO              | ✅ SÍ (calculado)         |
| Aparece en ledger    | Solo como etiqueta | ✅ SÍ (FK obligatorio)    |
| Consolidación        | Suma de assets     | Suma de transacciones     |

Esta definición es NO NEGOCIABLE y se aplica a todos los módulos financieros presentes y futuros.

---

## II. ARQUITECTURA DE INGRESOS

### 2.1 Ingresos Operativos (Nature: OPERATIVE)

#### 2.1.1 Arrendamiento (Time-Based)

**Evento:** RentalPeriodClosed

**Condición:** El período de alquiler (mes/trimestre/año) se completa.

**Flujo:**

1. Sistema detecta fin de período (scheduler diario).
2. Valida contrato activo (Contract.status = ACTIVE).
3. Calcula ingreso esperado:
   - Fuente: Asset.incomeBaseline (campo de Asset Creation v1.3).
   - Normalización: Según Asset.incomeBaselinePeriod (MENSUAL/ANUAL).
4. Genera evento RentalPeriodClosed:

```javascript
{
  eventId: "rental-close-001",
  eventType: "RentalPeriodClosed",
  assetId: "asset-123",
  contractId: "contract-456",
  periodStart: "2026-01-01",
  periodEnd: "2026-01-31",
  expectedAmount: 2500000,  // Asset.incomeBaseline
  actualAmount: 2500000     // Puede diferir si hay ajustes
}
```

5. Crea asiento en ledger:

```javascript
LedgerEntry {
  assetId: "asset-123",
  portfolioId: "portfolio-vehiculos",
  ownerId: "user-owner-001",
  type: "INCOME",
  nature: "OPERATIVE",
  amount: 2500000,
  eventId: "rental-close-001",
  eventType: "RentalPeriodClosed"
}
```

6. Opcional: Si no se cobró inmediatamente, genera CxC (ver sección IV).

**Validaciones:**

- Si Asset.incomeBaseline = null → ERROR (activo sin ingreso configurado).
- Si Asset.operationalStatus != ALQUILADO → WARNING (activo no alquilado).
- Si Contract.status != ACTIVE → SKIP (contrato inactivo).

#### 2.1.2 Flete / Servicio (Task-Based)

**Evento:** ServiceCompleted

**Condición:** El servicio/operación se marca como completado.

**Flujo:**

1. Operador marca servicio como completado en sistema.
2. Valida:
   - Service.assetId existe.
   - Service.status = COMPLETED.
3. Calcula ingreso:
   - Service.agreedPrice (precio acordado del servicio).
4. Genera evento ServiceCompleted:

```javascript
{
  eventId: "service-complete-001",
  eventType: "ServiceCompleted",
  assetId: "asset-truck-789",
  serviceId: "service-456",
  completedAt: "2026-01-15T18:00:00Z",
  agreedPrice: 800000,
  actualPrice: 850000  // Puede incluir ajustes
}
```

5. Crea asiento en ledger (INCOME, OPERATIVE).

**Validaciones:**

- Si Asset.operationalStatus = MANTENIMIENTO → BLOCK (activo en mantenimiento).
- Si Asset.operationalStatus = FUERA_SERVICIO → BLOCK (activo dado de baja).
- Si Service.agreedPrice <= 0 → ERROR (precio inválido).

### 2.2 Ingresos por Recuperación (Nature: RECOVERY)

**CRÍTICO:** Estos ingresos NO son rentabilidad, son mitigación de pérdidas.

#### 2.2.1 Recaudo de Cartera

**Evento:** DebtPaymentReceived

**Condición:** Cliente paga deuda pendiente (CxC).

**Flujo:**

1. Sistema registra pago.
2. Reduce AccountReceivable.outstandingBalance.
3. Crea asiento:

```javascript
LedgerEntry {
  type: "INCOME",
  nature: "RECOVERY",  // NO OPERATIVE
  amount: 1500000,
  eventType: "DebtPaymentReceived"
}
```

4. Si outstandingBalance = 0 → CxC.status = CLOSED.

**Separación de KPIs:**

- INCOME_RECOVERY va a KPI "Recuperación de Cartera".
- NO se suma a "Ingresos Operativos" ni "Rentabilidad del Activo".

#### 2.2.2 Pago por Daños

**Evento:** DamageRecovered

**Condición:** Responsable paga daños causados al activo.

**Flujo:**

1. Incidencia registrada con damageAmount.
2. Se genera CxC al responsable.
3. Al cobrar → DamageRecovered.
4. Crea asiento (INCOME, RECOVERY).

#### 2.2.3 Indemnización de Seguro

**Evento:** InsuranceIndemnified

**Condición:** Aseguradora paga siniestro.

**Flujo:**

1. Siniestro aprobado por aseguradora.
2. Pago recibido.
3. Crea asiento (INCOME, RECOVERY).
4. Actualiza estado del siniestro a PAID.

---

## III. ARQUITECTURA DE GASTOS

### 3.1 Gastos Reales

**Evento:** ExpenseIncurred

**Condición:** Se ejecuta un gasto real (compra, servicio, reparación).

**Flujo:**

1. Usuario registra gasto en sistema.
2. Valida:
   - Expense.assetId existe (obligatorio).
   - Expense.amount > 0.
   - Expense.category válida.
3. Genera evento ExpenseIncurred.
4. Crea asiento en ledger (EXPENSE).
5. Opcional: Valida contra presupuesto (ver sección VI).

**Validaciones:**

- assetId obligatorio (NO se permiten gastos sin activo).
- Si Asset.operationalStatus = FUERA_SERVICIO y category != DISPOSAL → WARNING.

### 3.2 Gastos Recurrentes

**Evento:** RecurringExpenseExecuted

**Condición:** Scheduler ejecuta gasto programado (ej: seguro mensual).

**Flujo:**

1. Scheduler detecta vencimiento de RecurringExpense.
2. Valida:
   - RecurringExpense.status = ACTIVE.
   - RecurringExpense.assetId existe.
3. Genera evento RecurringExpenseExecuted.
4. Crea asiento (EXPENSE).
5. Incrementa contador de ejecuciones.

**Ejemplo:**

Seguro mensual de vehículo: frequency = MONTHLY, amount = $500.
Cada mes, el sistema genera automáticamente el gasto.

---

## IV. CUENTAS POR COBRAR (CxC)

### 4.1 Modelo de Datos

```typescript
interface AccountReceivable {
  cxcId: string;
  assetId: string;             // FK a Asset.id (obligatorio)
  ownerId: string;             // Portfolio.createdBy
  debtorType: DebtorType;      // ARRENDATARIO | TERCERO | ASEGURADORA
  debtorId: string;
  originEventId: string;
  originEventType: string;
  principalAmount: number;
  outstandingBalance: number;
  dueDate: Date;
  status: CxCStatus;
  createdAt: Date;
  updatedAt: Date;
}

enum DebtorType {
  ARRENDATARIO   // Cliente que alquila el activo
  TERCERO        // Responsable de daño
  ASEGURADORA    // Aseguradora que debe pagar siniestro
}

enum CxCStatus {
  PENDING         // Pendiente de pago
  OVERDUE         // Vencida (dueDate pasado)
  PARTIALLY_PAID  // Pagada parcialmente
  CLOSED          // Pagada en su totalidad
}
```

### 4.2 Generación Automática de CxC

**Escenario 1: Arrendamiento no cobrado**

```
RentalPeriodClosed
  → Si pago NO recibido inmediatamente
  → Crea CxC {
      debtorType: ARRENDATARIO,
      originEventType: "RentalPeriodClosed",
      principalAmount: expectedAmount
    }
```

**Escenario 2: Daño causado por tercero**

```
DamageIncurred
  → Crea CxC {
      debtorType: TERCERO,
      originEventType: "DamageIncurred",
      principalAmount: estimatedRepairCost
    }
```

**Escenario 3: Siniestro aprobado**

```
InsuranceClaimApproved
  → Crea CxC {
      debtorType: ASEGURADORA,
      originEventType: "InsuranceClaimApproved",
      principalAmount: approvedAmount
    }
```

---

## V. MULTI-PROPIETARIO

### 5.1 Regla Fundamental

El dinero siempre tiene dueño.

**Implementación actual:**

```javascript
transaction.ownerId = asset.ownerId;

// Donde:
asset.ownerId = Portfolio.createdBy;
```

**Decisión contractual:**

- Portfolio.createdBy ES el ownerId para propósitos financieros.
- NO se agrega campo ownerId explícito a Portfolio (evita redundancia).

### 5.2 Extensión Futura: Multi-Ownership

Si en el futuro se implementa copropietarios de un portfolio:

- Se crea tabla PortfolioOwnership { portfolioId, ownerId, ownershipPercentage }.
- Las transacciones financieras se dividen proporcionalmente:

```javascript
if (portfolio.hasMultipleOwners) {
  const ownerships = getPortfolioOwnerships(portfolio.id);

  for (const ownership of ownerships) {
    createTransaction({
      ownerId: ownership.ownerId,
      assetId: asset.id,
      amount: totalAmount * ownership.ownershipPercentage,
      type: transactionType,
      nature: nature,
    });
  }
}
```

---

## VI. CONTROL PRESUPUESTAL PROFIT-FIRST

### 6.1 Configuración

Admin define por Portfolio o Asset:

```typescript
interface BudgetConfig {
  targetEntityType: "PORTFOLIO" | "ASSET";
  targetEntityId: string;
  expectedProfitMargin: number; // % (ej: 0.25 = 25%)
  period: "MONTHLY" | "QUARTERLY" | "ANNUAL";
}
```

### 6.2 Cálculo Automático de Techo de Gastos

```javascript
projectedIncome = sum(Asset.incomeBaseline for assets in portfolio)
spendingCeiling = projectedIncome × (1 − expectedProfitMargin)

if (actualExpenses > spendingCeiling) {
  EVENT: BudgetCeilingExceeded {
    portfolioId,
    projectedIncome,
    expectedProfitMargin,
    spendingCeiling,
    actualExpenses,
    overrun: actualExpenses - spendingCeiling
  }
}
```

**Fuente de datos:**

- projectedIncome se calcula sumando Asset.incomeBaseline (Asset v1.3).
- Si Asset.incomeBaseline = null → NO se incluye en proyección.
- Si Asset.financialSetupStatus = PENDING → WARNING.

### 6.3 Efectos de Superación

- Alerta crítica enviada a admin.
- Opcional: Bloqueo automático de nuevos gastos (configurable).
- Override documentado: Si admin aprueba, evento BudgetOverrideApproved.

---

## VII. MOTOR DE PROYECCIÓN

### 7.1 Proyección de Cashflow

```javascript
ProjectedCashflow = ProjectedIncome − (FixedExpenses + AvgVariableExpenses)

// Donde:
ProjectedIncome = sum(Asset.incomeBaseline normalized to period)
FixedExpenses = sum(RecurringExpense.amount)
AvgVariableExpenses = avg(non-recurring expenses last 3-6 months)
```

**Normalización de incomeBaseline:**

- Si incomeBaselinePeriod = ANUAL y período = MONTHLY → dividir por 12.
- Si incomeBaselinePeriod = MENSUAL y período = ANNUAL → multiplicar por 12.
- Si incomeBaselinePeriod = N_A → excluir del cálculo.

### 7.2 Detección de Riesgo

```javascript
if (ProjectedCashflow < 0) {
  EVENT: CashflowRiskDetected {
    portfolioId,
    projectedIncome,
    projectedExpenses,
    projectedCashflow,  // negativo
    severity: 'HIGH' | 'CRITICAL'
  }
}
```

**Acciones automáticas:**

- HIGH: Alerta a admin.
- CRITICAL: Bloqueo de gastos no esenciales + notificación urgente.

---

## VIII. KPIs CORE OBLIGATORIOS

### 8.1 KPIs Globales (Portfolio Level)

| KPI                      | Fórmula                                                           | Fuente                |
| ------------------------ | ----------------------------------------------------------------- | --------------------- |
| Cashflow Total           | SUM(INCOME) - SUM(EXPENSE)                                        | Ledger                |
| Saldo Vivo de Cartera    | SUM(CxC.outstandingBalance WHERE status != CLOSED)                | AccountReceivable     |
| Recuperación de Daños    | SUM(INCOME WHERE nature=RECOVERY AND originEvent=DamageRecovered) | Ledger                |
| Ejecución Presupuestal   | (ActualExpenses / SpendingCeiling) × 100                          | BudgetConfig + Ledger |
| Costo de Improductividad | SUM(EXPENSE WHERE Asset.downtime > 0)                             | Ledger + Asset        |

### 8.2 KPI CRÍTICO: Rentabilidad Neta por Activo

```javascript
AssetNetProfitability = OperativeIncome − DirectExpenses − AllocatedOverhead

// Donde:
OperativeIncome = SUM(INCOME WHERE nature=OPERATIVE AND assetId=X)
DirectExpenses = SUM(EXPENSE WHERE assetId=X)
AllocatedOverhead = (TotalOverhead / TotalAssets)
```

**Separación crítica:**

- Solo INCOME_OPERATIVE cuenta para rentabilidad.
- INCOME_RECOVERY NO se incluye (no es ganancia nueva).

---

## IX. ARQUITECTURA DE DEUDA

### 9.1 Principio Absoluto

**Un activo que no paga su propia deuda**

**NO tiene derecho a seguir operando.**

### 9.2 Modelo de Datos

**Decisión contractual:** Debt es entidad separada (tabla debts), NO extiende Asset.

```typescript
interface Debt {
  debtId: string;
  assetId: string;             // FK a Asset.id
  ownerId: string;             // Portfolio.createdBy
  creditor: string;
  debtType: DebtType;
  principal: number;
  interestRate: number;        // % anual
  termMonths: number;
  outstandingBalance: number;
  monthlyPayment: number;
  status: DebtStatus;
  startDate: Date;
  endDate: Date;
  createdAt: Date;
  updatedAt: Date;
}

enum DebtType {
  BANK_LOAN
  LEASE
  SUPPLIER_CREDIT
  OTHER
}

enum DebtStatus {
  ACTIVE
  PAID
  DEFAULTED
  RESTRUCTURED
}
```

**Relación con Asset v1.3:**

- Relación: Debt.assetId → Asset.id (FK).
- Un Asset puede tener múltiples Debts (varios créditos simultáneos).

### 9.3 Evento de Registro de Deuda

**Evento:** DebtRegistered

**Efecto:** Impacta proyección, NO genera transacción de cashflow inmediato.

**Flujo:**

1. Admin registra nueva deuda.
2. Valida:
   - assetId existe.
   - principal > 0.
   - interestRate >= 0.
   - termMonths > 0.
3. Calcula monthlyPayment (amortización francesa).
4. Genera evento DebtRegistered.
5. Actualiza FixedExpenses (suma monthlyPayment).

**¿Se captura en Wizard de Asset (Step 2)?**

**Decisión contractual:** NO en MVP.

**Razón:**

- Step 2 ya captura MVD crítico (incomeBaseline, assetValuation, operationalStatus).
- Agregar deuda aumenta complejidad (contra principio Zero-Friction).
- Alternativa: Deuda se registra post-creación en "Finanzas" del activo.

---

## X. AMORTIZACIÓN

### 10.1 Amortización Financiera (Deuda)

**Evento:** DebtPaymentExecuted

**Trigger:** Scheduler mensual o pago manual.

**Flujo:**

1. Sistema detecta vencimiento de cuota.
2. Calcula:
   - interestAmount = outstandingBalance × (interestRate / 12)
   - principalAmount = monthlyPayment − interestAmount
3. Genera evento DebtPaymentExecuted.
4. Crea transacciones:
   - EXPENSE (interestAmount) — Nature: OPERATIVE
   - Reducción de Debt.outstandingBalance (NO es gasto, es pago de capital)
5. Actualiza Debt.outstandingBalance.
6. Si outstandingBalance = 0 → Debt.status = PAID.

**Separación contable:**

- Intereses → Gasto (afecta rentabilidad).
- Capital → Reducción de pasivo (NO afecta rentabilidad, solo balance).

### 10.2 Amortización Técnica (Depreciación)

**Evento:** DepreciationApplied

**Trigger:** Scheduler mensual/anual (según política contable).

**Flujo:**

1. Calcula depreciación:
   - Método: Línea recta (default).
   - Fórmula: monthlyDepreciation = assetValuation / usefulLifeMonths
2. Genera evento DepreciationApplied.
3. Crea transacción: NON_CASH_EXPENSE (NO impacta cashflow, solo valor en libros).

**Integración con Asset v1.3:**

- assetValuation viene de Asset.assetValuation (Asset v1.3).
- Si Asset.assetValuation = null → NO se puede calcular depreciación.
- Depreciación NO se captura en Step 2 (se configura post-creación).

---

## XI. MOTOR DE DECISIÓN AUTOMÁTICA

### 11.1 Asset Health Score

```javascript
AssetHealthScore =
  RentabilityScore        // 0-100
  + LiquidityScore        // 0-100
  − DebtPressureScore     // 0-100
  − DowntimeScore         // 0-100

// Rango final: -200 a +200
```

**Componentes:**

**RentabilityScore:**

```javascript
RentabilityScore = (AssetNetProfitability / Asset.incomeBaseline) × 100
```

**LiquidityScore:**

```javascript
LiquidityScore = AssetCashflow > 0 ? 50 : -50;
```

**DebtPressureScore:**

```javascript
DebtPressureScore = (SUM(Debt.monthlyPayment) / Asset.incomeBaseline) × 100
```

**DowntimeScore:**

```javascript
DowntimeScore = (DaysInactive / 30) × 100
// DaysInactive = días en MANTENIMIENTO o FUERA_SERVICIO
```

**Integración con Asset v1.3:**

- Usa Asset.incomeBaseline y Asset.operationalStatus.
- Si incomeBaseline = null → RentabilityScore y DebtPressureScore = 0.
- Si operationalStatus = FUERA_SERVICIO → DowntimeScore = 100 (máxima penalización).

---

## XII. SEMÁFORO AUTOMÁTICO DE ACTIVOS

### 12.1 Clasificación Automática

```javascript
if (AssetHealthScore >= 50) {
  status = "🟢 SANO";
} else if (AssetHealthScore >= 0) {
  status = "🟡 EN RIESGO";
} else {
  status = "🔴 INVIABLE";
  EVENT: AssetDeclaredUnviable;
}
```

**Efectos por clasificación:**

| Estado    | Color | Efectos                              |
| --------- | ----- | ------------------------------------ |
| SANO      | 🟢    | Operación normal                     |
| EN RIESGO | 🟡    | Alerta a admin, revisión recomendada |
| INVIABLE  | 🔴    | Kill-Switch automático               |

---

## XIII. KILL-SWITCH DE ACTIVOS

### 13.1 Triggers del Kill-Switch

El Kill-Switch se activa automáticamente si se cumple cualquiera:

**Incumplimiento de deuda crítico:**

```javascript
if (Debt.status === "DEFAULTED" && daysOverdue > 90) {
  activateKillSwitch(assetId, "DEBT_DEFAULT");
}
```

**Cashflow negativo persistente:**

```javascript
if (AssetCashflow < 0 for last 6 months) {
  activateKillSwitch(assetId, 'NEGATIVE_CASHFLOW_PERSISTENT');
}
```

**Rentabilidad negativa prolongada:**

```javascript
if (AssetNetProfitability < 0 for last 12 months) {
  activateKillSwitch(assetId, 'NEGATIVE_PROFITABILITY_PROLONGED');
}
```

**Costo de reparación > valor recuperable:**

```javascript
if (estimatedRepairCost > Asset.assetValuation * 0.7) {
  activateKillSwitch(assetId, "REPAIR_COST_EXCEEDS_VALUE");
}
```

**Riesgo legal crítico:**

```javascript
if (legalIssue.severity === "CRITICAL") {
  activateKillSwitch(assetId, "LEGAL_RISK_CRITICAL");
}
```

### 13.2 Modelo de Datos

**Decisión contractual:** Kill-Switch es campo separado (tabla asset_kill_switches), NO modifica Asset.operationalStatus.

**Razón:**

- operationalStatus (Asset v1.3) es físico/operativo.
- killSwitchActive es financiero/decisional.
- Un activo puede estar físicamente DISPONIBLE pero financieramente bloqueado.

```typescript
interface AssetKillSwitch {
  assetId: string;             // PK, FK a Asset.id
  killSwitchActive: boolean;
  activatedAt: Date | null;
  activatedBy: string;         // 'SYSTEM' | userId
  reason: KillSwitchReason;
  allowedOperations: string[]; // ['RECOVERY', 'SALE', 'DISPOSAL']
  deactivatedAt: Date | null;
  deactivatedBy: string | null;
  overrideReason: string | null;
}

enum KillSwitchReason {
  DEBT_DEFAULT
  NEGATIVE_CASHFLOW_PERSISTENT
  NEGATIVE_PROFITABILITY_PROLONGED
  REPAIR_COST_EXCEEDS_VALUE
  LEGAL_RISK_CRITICAL
  MANUAL_OVERRIDE
}
```

### 13.3 Efectos del Kill-Switch

Cuando killSwitchActive = true:

**Bloqueo total operativo:**

- NO se puede crear nuevo contrato de arrendamiento.
- NO se puede asignar a nueva operación.
- NO se puede marcar como DISPONIBLE.

**Operaciones permitidas SOLO:**

- RECOVERY: Intentar recuperar valor.
- SALE: Vender el activo.
- DISPOSAL: Dar de baja definitiva.

**UI Indicator:**

- Badge rojo: "🔴 ACTIVO BLOQUEADO POR KILL-SWITCH"
- Tooltip: Razón + fecha activación.

### 13.4 Salida del Kill-Switch

**Evento:** AssetRehabilitated

**Condiciones para rehabilitar:**

- Deuda saldada (si razón = DEBT_DEFAULT).
- Cashflow positivo sostenido por 3 meses (si razón = NEGATIVE_CASHFLOW_PERSISTENT).
- Reparación completada con costo < valor recuperable (si razón = REPAIR_COST_EXCEEDS_VALUE).
- Override manual documentado por admin (con justificación obligatoria).

**Flujo:**

```javascript
if (conditionsForRehabilitation met) {
  EVENT: AssetRehabilitated {
    assetId,
    previousReason,
    rehabilitatedBy: 'SYSTEM' | userId,
    justification: string
  }

  UPDATE asset_kill_switches
  SET kill_switch_active = FALSE,
      deactivated_at = NOW(),
      deactivated_by = userId,
      override_reason = justification
  WHERE asset_id = assetId;
}
```

**Integración con Asset v1.3:**

- Al rehabilitar, el activo vuelve a operar normalmente.
- Asset.operationalStatus puede cambiar de FUERA_SERVICIO a DISPONIBLE.
- Kill-Switch desactivado NO fuerza cambio de operationalStatus (son independientes).

---

## XIV. KPIs EXTENDIDOS

### 14.1 Ratio Deuda / Ingreso Operativo

```javascript
DebtToIncomeRatio = SUM(Debt.monthlyPayment) / Asset.incomeBaseline;

// Interpretación:
// < 0.3 (30%) → Deuda manejable
// 0.3 - 0.5 → Deuda moderada
// > 0.5 → Deuda crítica (riesgo de insolvencia)
```

### 14.2 Tiempo a Punto de Equilibrio

```javascript
MonthsToBreakEven = Asset.assetValuation / (Asset.incomeBaseline − MonthlyExpenses)
```

**Validación:**

- Si assetValuation = null → NO se puede calcular.
- Si (incomeBaseline − MonthlyExpenses) <= 0 → Punto de equilibrio = NEVER.

### 14.3 Índice de Supervivencia del Activo

```javascript
SurvivalIndex = (MonthsInOperation / ExpectedUsefulLife) × 100
```

---

## XV. PROHIBICIONES GLOBALES (NO NEGOCIABLES)

### 15.1 Prohibiciones Absolutas

**❌ Ingresos sin contrato o servicio**

→ Todo ingreso operativo debe tener contractId o serviceId.

**❌ Gastos sin assetId**

→ Toda transacción de gasto debe tener assetId obligatorio.

**❌ Edición de ledger**

→ Ledger es append-only. Correcciones solo con eventos inversos.

**❌ Mezclar recuperación con rentabilidad**

→ INCOME_RECOVERY NO se suma a KPIs de rentabilidad operativa.

**❌ Operar activos con Kill-Switch activo**

→ Solo operaciones de recuperación/venta/disposición.

**❌ Decisiones manuales sin evento trazable**

→ Todo override debe generar evento con authorizedBy.

**❌ Transacciones a nivel portfolio**

→ Toda transacción financiera debe tener assetId obligatorio.

**❌ Balance por portfolio**

→ Portfolio NO tiene balance propio. Se calcula sumando assets.

**❌ Transferencias entre portfolios**

→ NO se mueve dinero entre portfolios. Se mueve el asset (cambio de portfolioId).

### 15.2 Validaciones Obligatorias en Código

```javascript
// Validación: assetId obligatorio
if (!transaction.assetId) {
  throw new FinancialRuleViolation("assetId es obligatorio");
}

// Validación: Ingreso operativo requiere contrato
if (
  transaction.nature === "OPERATIVE" &&
  !transaction.contractId &&
  !transaction.serviceId
) {
  throw new FinancialRuleViolation(
    "Ingreso operativo requiere contractId o serviceId"
  );
}

// Validación: Kill-Switch
const killSwitch = await getKillSwitch(transaction.assetId);
if (
  killSwitch?.killSwitchActive &&
  !killSwitch.allowedOperations.includes(transaction.operationType)
) {
  throw new KillSwitchViolation("Operación bloqueada por Kill-Switch");
}
```

---

## XVI. ANTI-PATTERNS PROHIBIDOS

### 16.1 Anti-Pattern: Balance a Nivel Portfolio

**❌ MAL:**

```javascript
Portfolio {
  id: "portfolio-123",
  balance: 5000000  // ← PROHIBIDO
}
```

**✅ CORRECTO:**

Balance se calcula sumando cashflow de assets.

### 16.2 Anti-Pattern: Transferencias Entre Portfolios

**❌ MAL:**

```javascript
POST /api/v1/portfolios/transfer
Body: {
  fromPortfolio: "portfolio-A",
  toPortfolio: "portfolio-B",
  amount: 1000000
}
```

**✅ CORRECTO:**

Mover el asset de un portfolio a otro (UPDATE Asset SET portfolioId = ...).

### 16.3 Anti-Pattern: Gastos Generales sin assetId

**❌ MAL:**

```javascript
{
  portfolioId: "portfolio-123",
  amount: 200000,
  type: "EXPENSE",
  category: "ADMIN"
}
```

**✅ CORRECTO:**

Crear asset ficticio "Gastos Administrativos" dentro del portfolio.

---

## XVII. MODELO DE DATOS CONSOLIDADO

### 17.1 Entidades Existentes (Asset Creation v1.3 — NO MODIFICADAS)

```typescript
Portfolio {
  id: string
  portfolioName: string
  portfolioType: VEHICULOS | INMUEBLES
  status: DRAFT | ACTIVE
  assetsCount: number
  createdBy: string  // ← ownerId para Finance
  createdAt: DateTime
  updatedAt: DateTime
}

Asset {
  id: string
  portfolioId: string
  assetType: VEHICULO | INMUEBLE | ...
  countryId: string
  cityId: string
  currencyCode: string
  incomeBaseline: number | null
  incomeBaselinePeriod: MENSUAL | ANUAL | N_A
  assetValuation: number | null
  financialSetupStatus: PENDING | COMPLETE
  operationalStatus: DISPONIBLE | ALQUILADO | MANTENIMIENTO | FUERA_SERVICIO
  sourceType: INTEGRATION_FULL | MANUAL_BASIC | FALLBACK_MANUAL
  createdAt: DateTime
  updatedAt: DateTime
}
```

### 17.2 Entidades Nuevas (Finance v1.2.1)

```typescript
Debt {
  debtId: string (PK)
  assetId: string (FK → Asset.id)
  ownerId: string (Portfolio.createdBy)
  creditor: string
  debtType: DebtType
  principal: number
  interestRate: number
  termMonths: number
  outstandingBalance: number
  monthlyPayment: number
  status: DebtStatus
  startDate: Date
  endDate: Date
  createdAt: Date
  updatedAt: Date
}

AssetKillSwitch {
  assetId: string (PK, FK → Asset.id)
  killSwitchActive: boolean
  activatedAt: Date | null
  activatedBy: string
  reason: KillSwitchReason
  allowedOperations: string[]
  deactivatedAt: Date | null
  deactivatedBy: string | null
  overrideReason: string | null
}

AccountReceivable {
  cxcId: string (PK)
  assetId: string (FK → Asset.id)
  ownerId: string (Portfolio.createdBy)
  debtorType: DebtorType
  debtorId: string
  originEventId: string
  originEventType: string
  principalAmount: number
  outstandingBalance: number
  dueDate: Date
  status: CxCStatus
  createdAt: Date
  updatedAt: Date
}

LedgerEntry {
  entryId: string (PK)
  assetId: string (FK → Asset.id, OBLIGATORIO)
  portfolioId: string (FK → Portfolio.id, solo contexto)
  ownerId: string (Portfolio.createdBy)
  transactionType: INCOME | EXPENSE
  nature: FinancialNature
  amount: number
  currencyCode: string
  eventId: string
  eventType: string
  description: string
  createdAt: Date
}
```

---

## XVIII. ARQUITECTURA DE DATOS (SQL DDL)

```sql
-- Ledger (append-only)
CREATE TABLE ledger_entries (
  entry_id VARCHAR PRIMARY KEY,
  asset_id VARCHAR NOT NULL REFERENCES assets(id),
  portfolio_id VARCHAR NOT NULL,
  owner_id VARCHAR NOT NULL,
  transaction_type VARCHAR NOT NULL,
  nature VARCHAR NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  currency_code VARCHAR(3) NOT NULL,
  event_id VARCHAR NOT NULL,
  event_type VARCHAR NOT NULL,
  description TEXT,
  created_at TIMESTAMP NOT NULL
);

ALTER TABLE ledger_entries
ADD CONSTRAINT ledger_assetid_required
CHECK (asset_id IS NOT NULL AND asset_id != '');

CREATE INDEX idx_ledger_asset_date ON ledger_entries(asset_id, created_at);
CREATE INDEX idx_ledger_portfolio ON ledger_entries(portfolio_id);

-- Debts
CREATE TABLE debts (
  debt_id VARCHAR PRIMARY KEY,
  asset_id VARCHAR NOT NULL REFERENCES assets(id),
  owner_id VARCHAR NOT NULL,
  creditor VARCHAR NOT NULL,
  debt_type VARCHAR NOT NULL,
  principal DECIMAL(15,2) NOT NULL,
  interest_rate DECIMAL(5,4) NOT NULL,
  term_months INT NOT NULL,
  outstanding_balance DECIMAL(15,2) NOT NULL,
  monthly_payment DECIMAL(15,2) NOT NULL,
  status VARCHAR NOT NULL,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Kill-Switch
CREATE TABLE asset_kill_switches (
  asset_id VARCHAR PRIMARY KEY REFERENCES assets(id),
  kill_switch_active BOOLEAN NOT NULL DEFAULT FALSE,
  activated_at TIMESTAMP,
  activated_by VARCHAR,
  reason VARCHAR,
  allowed_operations TEXT[],
  deactivated_at TIMESTAMP,
  deactivated_by VARCHAR,
  override_reason TEXT
);

-- Accounts Receivable
CREATE TABLE accounts_receivable (
  cxc_id VARCHAR PRIMARY KEY,
  asset_id VARCHAR NOT NULL REFERENCES assets(id),
  owner_id VARCHAR NOT NULL,
  debtor_type VARCHAR NOT NULL,
  debtor_id VARCHAR NOT NULL,
  origin_event_id VARCHAR NOT NULL,
  origin_event_type VARCHAR NOT NULL,
  principal_amount DECIMAL(15,2) NOT NULL,
  outstanding_balance DECIMAL(15,2) NOT NULL,
  due_date TIMESTAMP NOT NULL,
  status VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
```

---

## XIX. API ENDPOINTS (Referencia Backend)

### 19.1 Portfolio Financial Summary

```
GET /api/v1/portfolios/:id/financial-summary?period=YYYY-MM

Response:
{
  "portfolioId": "uuid",
  "period": "2026-01",
  "cashflowTotal": 15000000,
  "operativeIncome": 18000000,
  "recoveryIncome": 2000000,
  "totalExpenses": 5000000,
  "netProfitability": 13000000,
  "outstandingReceivables": 3500000,
  "budgetExecution": 75.5,
  "assetsAtRisk": [...],
  "killSwitchedAssets": [...]
}
```

### 19.2 Asset Financial Detail

```
GET /api/v1/assets/:id/financial-detail?period=YYYY-MM

Response:
{
  "assetId": "uuid",
  "period": "2026-01",
  "operativeIncome": 2500000,
  "directExpenses": 800000,
  "netProfitability": 1700000,
  "healthScore": 85,
  "status": "🟢 SANO",
  "debts": [...],
  "receivables": [...],
  "killSwitch": { "active": false }
}
```

### 19.3 Debt Management

```
POST /api/v1/debts
Body: {
  "assetId": "uuid",
  "creditor": "Banco XYZ",
  "debtType": "BANK_LOAN",
  "principal": 50000000,
  "interestRate": 0.12,
  "termMonths": 36,
  "startDate": "2026-01-01"
}

POST /api/v1/debts/:id/payment
Body: {
  "paymentAmount": 1662763,
  "paymentDate": "2026-02-01"
}
```

### 19.4 Kill-Switch Management

```
POST /api/v1/assets/:id/kill-switch/activate
Body: {
  "reason": "DEBT_DEFAULT",
  "activatedBy": "userId",
  "justification": "Mora de 90 días en crédito principal"
}

POST /api/v1/assets/:id/kill-switch/deactivate
Body: {
  "deactivatedBy": "userId",
  "overrideReason": "Deuda saldada completamente"
}
```

---

## XX. ONBOARDING PARA DESARROLLADORES

### 20.1 Regla de Oro

Si estás tentado a agregar lógica financiera a Portfolio:

1. DETENTE.
2. Re-lee sección I.5 (Definición de portfolioId).
3. Pregunta: "¿Esto debería estar en Asset o en entidad relacionada?"
4. Si la respuesta es "Portfolio", estás equivocado.
5. Consulta con Architecture Team antes de proceder.

### 20.2 Checklist de Code Review

- ☑ Toda transacción tiene assetId obligatorio.
- ☑ NO hay lógica financiera a nivel Portfolio.
- ☑ NO hay ediciones directas de ledger (solo eventos correctivos).
- ☑ Ingresos operativos tienen contractId o serviceId.
- ☑ INCOME_RECOVERY NO se mezcla con rentabilidad.
- ☑ Kill-Switch se valida en operaciones bloqueables.
- ☑ Eventos correctivos tienen authorizedBy y reason.

### 20.3 Ejemplo de Razonamiento Correcto

**Pregunta:** "¿Dónde guardo el ROI del portfolio?"

**Respuesta incorrecta:** "En Portfolio.roi" ❌

**Respuesta correcta:** "El ROI del portfolio se calcula sumando ROI de cada asset. No se guarda, se deriva." ✅

---

## XXI. CIERRE CONTRACTUAL

### 21.1 Resumen Ejecutivo

Este contrato convierte Avanzza en:

**Un sistema que decide automáticamente**

**qué activos viven,**

**cuáles se corrigen**

**y cuáles se eliminan.**

Cualquier feature financiero fuera de este contrato NO DEBE IMPLEMENTARSE.

### 21.2 Consolidación v1.2.1

**Decisiones contractuales NO NEGOCIABLES:**

- ✅ Portfolio.createdBy ES el ownerId financiero.
- ✅ Debt es entidad separada (tabla debts).
- ✅ Kill-Switch es campo separado (tabla asset_kill_switches).
- ✅ incomeBaseline alimenta eventos de ingreso.
- ✅ assetValuation es opcional (si null, NO hay depreciación ni ROI).
- ✅ Deuda NO se captura en Step 2 del wizard.
- ✅ Finance EXTIENDE Asset v1.3, NO lo modifica.
- ✅ portfolioId es workspace lógico, NO unidad financiera.

### 21.3 Prevención de Deuda Conceptual

- ✅ Futuros desarrolladores NO podrán argumentar "no sabía que portfolio no es financiero".
- ✅ Code reviews tienen criterio objetivo para rechazar lógica financiera en Portfolio.
- ✅ Arquitectura protegida contra anti-patterns (balance portfolio, transferencias).

---

## XXII. ESTADO DEL DOCUMENTO

**Estado:** ✅ FROZEN — Golden Source v1.2.1

**Aprobación requerida para cambios:**

- CTO Office
- Product Lead
- Fintech Lead
- Engineering Lead

**Auditoría de cumplimiento:**

- ☑ Backend valida assetId obligatorio en todas las transacciones.
- ☑ Backend rechaza transacciones sin assetId.
- ☑ Frontend formularios financieros exigen assetId (AssetSelector required).
- ☑ Dashboards de portfolio consolidan sumando métricas de assets.
- ☑ Documentación técnica (Swagger, ADRs) refleja definición de portfolioId.
- ☑ Code review checklist incluye "NO lógica financiera en Portfolio".
- ☐ Backend implementó TODAS las entidades nuevas (Debt, KillSwitch, CxC, Ledger).
- ☐ Backend implementó TODOS los endpoints definidos.
- ☐ Frontend implementó dashboards financieros (Portfolio Summary, Asset Detail).
- ☐ Frontend implementó gestión de deuda (registro, pagos, visualización).
- ☐ Frontend implementó indicadores de Kill-Switch (badges, bloqueos).
- ☐ QA validó TODAS las reglas de negocio (event-driven, validaciones, prohibiciones).

**Próximas revisiones:**

- v1.3: Integración con módulo de Contratos (contractId en eventos de ingreso).
- v1.4: Módulo de Costos Operativos (mantenimiento, seguros, impuestos) para ROI real.
- v2.0: Machine Learning para predicción de Kill-Switch proactivo.

---

**FIN DEL CONTRATO DE PRODUCTO — FINANCE v1.2.1**

---

**Firma Digital:**

Claude Sonnet 4.5 — Senior Product Architect + Fintech Lead

2026-01-11 18:00 UTC

---

**Metadata para control de versiones:**

- Archivo: docs/PRODUCT_CONTRACT_FINANCE.md
- Versión: v1.2.1-consolidated-golden-source
- Tipo: Contrato de Producto (Product Contract)
- Hash SHA-256: [generado al commit]
- Repository: avanzza-product-specs
- Branch: main
- Tag: v1.2.1-finance-consolidated-final
- Basado en: PRODUCT_CONTRACT_ASSET_CREATION.md v1.3 (2026-01-10)
- Changelog: v1.0 → v1.1 → v1.2 → v1.2.1 (consolidación completa)

**Gobernanza:**

- Este documento es el Golden Source único para todo lo relacionado con finanzas en Avanzza.
- Cualquier conflicto entre implementación y contrato se resuelve a favor del contrato.
- Modificaciones requieren aprobación formal de CTO Office + Product Lead.
- Violaciones en producción se consideran deuda técnica crítica (P0).

---

**FIN**

**✅ END OF FILE (NO MORE CONTENT)**
