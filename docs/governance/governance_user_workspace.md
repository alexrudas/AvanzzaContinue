# GOVERNANCE_USER_WORKSPACE.md

## Avanzza 2.0 — User, Role & Workspace Governance

> **TIPO:** Documento de Gobernanza Constitucional
> **ESTADO:** ACTIVO / VIGENTE
> **VERSIÓN:** 1.0.0
> **AUTORIDAD:** SUPREMA (Subordinado solo a GOVERNANCE_CORE.md)
> **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO Y ALCANCE

Este documento define, de forma **normativa, cerrada y no interpretable**, las reglas que gobiernan:

- La relación entre **User**, **Role** y **Workspace**.
- Las **condiciones mínimas** (Prerrequisitos) para acceder a un Workspace.
- Los **estados válidos** de un Workspace (Máquina de Estados de Negocio).
- Los **prerrequisitos de activos** específicos por rol.

**Este documento NO define:**

- Lógica financiera o contable.
- Permisos técnicos de bajo nivel (Auth, ACL, RBAC).
- Reglas internas de dominios específicos (ej. Mantenimiento, Rutas).

---

## 2. JERARQUÍA DE AUTORIDAD

1.  **GOVERNANCE_CORE.md** (Constitución Máxima)
2.  **GOVERNANCE_USER_WORKSPACE.md** (Este documento)
3.  `DOMAIN_CONTRACTS.md`
4.  `UI_CONTRACTS.md`

**Regla de Resolución:**
Si existe conflicto entre este documento y un contrato de dominio o decisión de UI, **este documento prevalece**.

---

## 3. DEFINICIONES CANÓNICAS (NO NEGOCIABLES)

| Término       | Definición Estricta                                                                |
| :------------ | :--------------------------------------------------------------------------------- |
| **User**      | Una cuenta registrada y autenticada en Avanzza.                                    |
| **Org**       | Entidad organizacional aislada (Tenant).                                           |
| **Role**      | Responsabilidad funcional asignada a un User dentro de una Org específica.         |
| **Workspace** | El contexto operativo **único** resultante de la intersección `User + Org + Role`. |
| **Asset**     | Unidad económica gestionada (Según GOVERNANCE_CORE).                               |

**Términos Prohibidos:** Actor, Perfil Global, Workspace Universal, Dashboard (como sinónimo de Workspace).

---

## 4. PRINCIPIOS FUNDAMENTALES DEL WORKSPACE

### 4.1 Workspace ≠ Pantalla [CRÍTICO]

Un Workspace **NO es una vista**, **NO es un dashboard** y **NO es un menú de navegación**.

Un Workspace es un **Contexto Operativo** que:

- Está estrictamente delimitado por `orgId`.
- Carga reglas de negocio específicas para un `Role`.
- Determina qué operaciones son legales antes de pintar cualquier píxel.

**Regla:** La UI **no decide** si un Workspace existe o es accesible; solo visualiza el estado determinado por el Dominio.

### 4.2 Unicidad del Workspace [CRÍTICO]

La identidad de un Workspace se define por la triada: **[User ID] + [Org ID] + [Role ID]**.

- Un User con múltiples Roles en una Org = **Múltiples Workspaces**.
- Un User con el mismo Role en múltiples Orgs = **Múltiples Workspaces**.
- **No existen Workspaces compartidos** o híbridos.

---

## 5. MÁQUINA DE ESTADOS DEL WORKSPACE

Un Workspace **SIEMPRE** debe estar en uno de estos estados deterministas. No existen estados intermedios en la lógica de negocio.

| Estado         | Significado de Negocio                                                                                  | Acción Esperada de la UI                                                                                                     |
| :------------- | :------------------------------------------------------------------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------- |
| **BLOCKED**    | El usuario tiene el Rol, pero **NO cumple** los prerrequisitos duros (ej. Asset Owner sin activos).     | Mostrar pantalla de bloqueo con **Call-to-Action (CTA)** para resolver el bloqueo (ej. "Crear Activo"). Bloquear navegación. |
| **EMPTY**      | El usuario cumple los prerrequisitos, pero **NO tiene datos operativos** (ej. Tenant sin asignaciones). | Mostrar patrón **Empty State** explicativo. Permitir navegación limitada si aplica.                                          |
| **ACTIVE**     | El usuario cumple requisitos y tiene datos operativos.                                                  | Mostrar Dashboard o vista principal operativa.                                                                               |
| **RESTRICTED** | Acceso concedido pero con capacidades limitadas (ej. Suspensión de pago, Auditoría).                    | Mostrar vista operativa con indicadores de restricción claros.                                                               |

**Estados Prohibidos:** `Undefined`, `Loading` (Loading es estado de UI, no de Negocio), `Error` (Los fallos técnicos no son estados de negocio).

---

## 6. PATRÓN OBLIGATORIO: EMPTY WORKSPACE

### 6.1 Definición

Un **Empty Workspace** es un estado válido y saludable del sistema. Significa "Todo está bien configurado, pero aún no hay actividad".

**Reglas:**

- Debe explicar **por qué** está vacío.
- Debe indicar la **siguiente acción** (o que debe esperar a un tercero).
- **PROHIBIDO:** Simular datos falsos ("Lorem Ipsum") para llenar el vacío.
- **PROHIBIDO:** Ocultar el Workspace o mostrar un error 404.

---

## 7. GOBERNANZA POR ROL (MATRIZ DE ACCESO)

Esta sección define las reglas duras para determinar el estado (`BLOCKED` vs `EMPTY` vs `ACTIVE`) según el Rol.

### 7.1 Role: Asset Owner (Propietario)

_El dueño de la flota o del negocio._

- **Prerrequisito Duro:** Debe haber registrado **al menos un (1) Asset**.
- **Estado BLOCKED:** Si tiene 0 Assets. (Debe ser forzado al flujo de "Crear Primer Activo").
- **Estado ACTIVE:** Si tiene >= 1 Assets.

### 7.2 Role: Asset Administrator

_Gestor delegado._

- **Prerrequisito Duro:** Debe tener assets propios **O** assets vinculados por permiso.
- **Estado BLOCKED:** Si no tiene vinculaciones.
- **Estado ACTIVE:** Si tiene vinculaciones.

### 7.3 Role: Tenant / Renter (Arrendatario)

_Cliente final._

- **Prerrequisito:** Ninguno (su existencia depende de terceros).
- **Estado EMPTY:** Si no tiene activos/servicios asignados. (No es Blocked porque él no puede resolverlo solo; debe esperar).
- **Estado ACTIVE:** Si tiene asignaciones.

### 7.4 Role: Service Provider / Supplier

_Mecánico, Conductor externo, Aseguradora._

- **Prerrequisito:** Ninguno.
- **Estado EMPTY:** Si no tiene órdenes de servicio o casos activos.
- **Estado ACTIVE:** Si tiene operaciones en curso.

---

## 8. REGLAS DE EJECUCIÓN (CRÍTICAS)

1.  **Backend Authority:** El estado del Workspace (`BLOCKED/EMPTY/ACTIVE`) se calcula en el Backend (o Dominio local), **NUNCA** en el Widget de UI.
2.  **No Bypass:** Ningún botón o enlace profundo ("Deep Link") puede saltarse la validación de estado del Workspace.
3.  **Resolución de Bloqueo:** Un Workspace `BLOCKED` debe ofrecer, obligatoriamente, la ruta para desbloquearse (ej. Botón "Registrar Vehículo"). No puede ser un callejón sin salida.

---

## 9. ANTIPATRONES PROHIBIDOS

- ❌ **Workspace Zombi:** Un Workspace visible en el menú para el cual el usuario ya no tiene el Rol.
- ❌ **Falso Positivo:** Mostrar un Workspace como `ACTIVE` cuando no cumple los prerrequisitos (ej. Dashboard vacío para un Owner sin carros).
- ❌ **UI Legisladora:** Que un `if` en el frontend decida si el usuario entra. La decisión debe venir pre-calculada del Dominio/Core.
- ❌ **Error Técnico como Estado:** Mostrar "Error 500" cuando en realidad es un estado `BLOCKED`.

---

## 10. REGLA PARA IA (OBLIGATORIA)

Toda IA que genere código, vistas o flujos relacionados con Workspaces **DEBE**:

1.  **Identificar el Rol** en cuestión.
2.  **Consultar esta matriz** (Sección 7) para determinar los estados posibles.
3.  **Implementar** el manejo de `BLOCKED` y `EMPTY` explícitamente.
4.  **Validar** contra `GOVERNANCE_CORE.md` (especialmente `orgId`).

Si existe ambigüedad sobre el comportamiento de un Rol nuevo no listado aquí:
👉 **STOP AND REPORT.**

> **VINCULACIÓN:** Este documento es estricta y legalmente vinculante para cualquier IA que opere bajo el mandato de `AI_MASTER_PROMPT.md`.

---

**FIN DE GOVERNANCE_USER_WORKSPACE**
