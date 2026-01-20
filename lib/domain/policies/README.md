# Policy Layer

## Problema que resuelve

El Policy Layer centraliza las reglas operativas y de elegibilidad que determinan:

- **Automatización**: ¿Se puede ejecutar un cobro automático?
- **Desembolso**: ¿Se puede ejecutar un pago automático a terceros o comisiones?
- **Visibilidad**: ¿El usuario puede ver información financiera?

### Anti-patrón evitado

Sin este layer, la lógica operativa termina dispersa en:

- Controllers (preguntando `if (isInformal)` antes de cada acción)
- Widgets (mostrando/ocultando según flags)
- Servicios (duplicando validaciones)

Esto dificulta auditoría, testing y escalabilidad multi-país.

---

## FASE 1: Foundation (Fail-Safe)

En FASE 1, el `PolicyContextFactory` retorna **siempre** `PolicyContext.failSafe()`:

- Sin sesión real
- Sin usuario real
- Sin acceso a Firestore/Isar

Ejemplo de un `PolicyContext.failSafe()` típico:

- `role`: rol con permisos mínimos
- `legalStatus`: estado que bloquea automatización
- `countryCode`: código genérico
- `hasActiveContract`: sin contrato activo

Esto garantiza comportamiento seguro por defecto:

- Automatización bloqueada
- Payouts a terceros bloqueados
- Comisiones automáticas bloqueadas (sin contrato)
- Visibilidad restringida (según rol)

### Open/Closed Principle

En FASE 2, solo se cambia el `PolicyContextFactory` para leer sesión/usuario real.
Las implementaciones de políticas (`DefaultAutomationPolicy`, etc.) **no se modifican**.

---

## Arquitectura Offline-First

Avanzza es Offline-First. Los datos históricos viven en el dispositivo (Isar).

### Qué puede bloquear la falta de contrato

| Operación                    | ¿Bloqueada sin contrato? |
| ---------------------------- | ------------------------ |
| Sincronización (Sync)        | ✅ Sí                    |
| Automatización (Auto-cobro)  | ✅ Sí                    |
| Payouts a terceros           | ✅ Sí                    |
| Visibilidad de datos locales | ❌ **NO**                |

### Anti-patrón: "Data Hostage"

Bloquear al usuario de ver sus propios datos históricos locales porque "no tiene contrato activo" es un anti-patrón conocido como **Data Hostage**.

Por esta razón, `AccessPolicy` depende **exclusivamente del Rol** (identidad), nunca del estado del contrato.

---

## Ejemplos conceptuales (Matriz de Decisiones)

### Ejemplo 1: Actor informal con permisos financieros

_Un actor (persona o empresa) con rol `owner` o `admin`, cuyo estado operativo es `informal`._

- **Ledger**: Todos los eventos financieros se registran normalmente. El ledger es **inmutable e incondicional**.
- **Automatización**: **Bloqueada**. No se ejecutan cobros automáticos por criterios de elegibilidad operativa y compliance.
- **Payouts**: **Bloqueados**. No se ejecutan pagos automáticos hacia este actor.
- **Visibilidad**: **Permitida**. Al ser `owner/admin`, accede a **resúmenes financieros agregados y KPIs económicos locales** (ej. totales, balances, históricos consolidados).

### Ejemplo 2: Actor formal con permisos financieros

_Un actor con rol `admin`, estado operativo `formal` y contrato activo._

- **Ledger**: Registro completo e inmutable.
- **Automatización**: **Habilitada** (en FASE 2 con contexto real).
- **Payouts a terceros**: **Habilitados**.
- **Comisiones automáticas**: **Habilitadas** (validación de elegibilidad exitosa).
- **Visibilidad**: **Completa**. Acceso total a dashboards financieros, KPIs y reportes agregados.

### Ejemplo 3: Actor operativo sin permisos financieros

_Un actor con rol `tenant` u otro rol operativo, sin contrato activo._

- **Ledger**: Todos los eventos asociados se registran normalmente.
- **Automatización**: **Bloqueada**.
- **Payouts / Comisiones**: **Bloqueados**.
- **Visibilidad**: **Restringida**. No puede ver resúmenes financieros agregados del activo,  
  pero **mantiene acceso a sus datos históricos locales**, documentos y eventos propios, evitando el anti-patrón **“Data Hostage”**.

---

## Aclaración sobre Visibilidad (AccessPolicy)

`AccessPolicy` **NO** controla el acceso a los datos crudos del ledger ni a los archivos locales del dispositivo.

Controla **exclusivamente** la **visibilidad de información financiera agregada**, como:

- Resúmenes consolidados
- KPIs económicos
- Totales, balances y vistas analíticas derivadas

La decisión de visibilidad se basa **únicamente en el Rol del actor**, nunca en el estado del contrato, garantizando que el usuario **siempre conserve acceso a su información histórica local**, independientemente de su relación comercial con Avanzza.

---

## Estructura de archivos

```
lib/domain/policies/
├── policy_types.dart              # Enums wire-stable (Role, LegalStatus)
├── policy_context.dart            # Contexto inmutable + failSafe()
├── policy_context_factory.dart    # Factory (fail-safe en FASE 1)
├── automation_policy.dart         # Contrato: canAutoCharge, canCreateDebt
├── payout_policy.dart             # Contrato: canAutoPayout, canAutoCommissionPayout
├── access_policy.dart             # Contrato: canSeeFinancialSummary
├── default_automation_policy.dart # Implementación default
├── default_payout_policy.dart     # Implementación default
├── default_access_policy.dart     # Implementación default
├── policy_engine.dart             # Agregador de políticas
└── README.md                      # Este archivo
```

---

## Registro en DI

Todas las políticas se registran como **singletons** en `lib/core/di/container.dart`:

- `PolicyContextFactory` → `DefaultPolicyContextFactory`
- `AutomationPolicy` → `DefaultAutomationPolicy`
- `PayoutPolicy` → `DefaultPayoutPolicy`
- `AccessPolicy` → `DefaultAccessPolicy`
- `PolicyEngine` → Inyecta las 3 políticas anteriores
