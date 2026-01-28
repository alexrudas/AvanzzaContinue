# UI_OFFLINE_SYNC_GUIDE.md

## Avanzza 2.0 — Guía de Estados Visuales Offline & Sync

> **TIPO:** Guía de Implementación Operativa
> **VERSIÓN:** 1.0.0
> **SUBORDINADO A:** UI_CONTRACTS.md (v1.0.2) §7
> **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO

Definir la representación visual de estados de sincronización y conectividad en la UI.

**ALCANCE ESTRICTO:**
Este documento SOLO define **feedback visual**.

**FUERA DE ALCANCE (PROHIBIDO EN ESTE DOCUMENTO):**

- ❌ Lógica de sincronización
- ❌ Queues de operaciones
- ❌ Retry policies
- ❌ Sync engines
- ❌ Conflict resolution algorithms
- ❌ Database operations
- ❌ Network layer

> **Ref:** UI_CONTRACTS.md §7

---

## 2. PRINCIPIO FUNDAMENTAL

Avanzza 2.0 es **offline-first**.

| Principio                                       | Obligatorio |
| ----------------------------------------------- | ----------- |
| La ausencia de conectividad NO impide operación | ✅ SÍ       |
| La UI NO bloquea por estado offline             | ✅ SÍ       |
| La UI muestra estado de sync, no lo decide      | ✅ SÍ       |

> **Ref:** UI_CONTRACTS.md §7.1

---

## 3. ESTADOS DE SINCRONIZACIÓN [CRÍTICO]

### 3.1 Definición de Estados

| Estado           | Definición                           | Fuente de Verdad             |
| ---------------- | ------------------------------------ | ---------------------------- |
| **Synced**       | Datos sincronizados con servidor     | Controller/Application Layer |
| **Stale**        | Datos potencialmente desactualizados | Controller/Application Layer |
| **Pending Sync** | Cambios locales pendientes de envío  | Controller/Application Layer |
| **Sync Error**   | Fallo en sincronización              | Controller/Application Layer |

### 3.2 Regla de Gobernanza [CRÍTICO]

> La UI **RECIBE** el estado de sincronización.
> La UI **NO DETERMINA** el estado de sincronización.
>
> El estado DEBE ser provisto explícitamente por el Controller o Application Layer.
> La UI NO puede inferir, calcular ni asumir estados de sync.

> **Ref:** UI_CONTRACTS.md §7.2 (Nota de Gobernanza)

---

## 4. REPRESENTACIÓN VISUAL POR ESTADO

### 4.1 Estado: Synced

| Aspecto          | Especificación                     |
| ---------------- | ---------------------------------- |
| Indicador visual | Ninguno (estado por defecto)       |
| Color            | N/A                                |
| Icono            | N/A                                |
| Tooltip          | N/A                                |
| Interacción      | Normal, sin restricciones visuales |

**Regla:** Synced es el estado implícito. NO requiere indicador.

### 4.2 Estado: Stale

| Aspecto                | Especificación                                    |
| ---------------------- | ------------------------------------------------- |
| Indicador visual       | Sutil, no bloqueante                              |
| Opacidad del contenido | 0.6 - 0.7                                         |
| Borde                  | Gris punteado (opcional)                          |
| Icono                  | Reloj o nube con signo de pregunta                |
| Tooltip                | "Datos pueden estar desactualizados" (desde i18n) |
| Interacción            | **PERMITIDA** — No bloquear                       |

**Regla:** Stale NO bloquea interacción. Solo informa visualmente.

### 4.3 Estado: Pending Sync

| Aspecto          | Especificación                                   |
| ---------------- | ------------------------------------------------ |
| Indicador visual | Badge o icono visible                            |
| Icono            | Nube con flecha hacia arriba ↑                   |
| Badge            | Número de operaciones pendientes (si > 1)        |
| Color            | Azul o naranja (según design system)             |
| Tooltip          | "Cambios pendientes de sincronizar" (desde i18n) |
| Interacción      | **PERMITIDA** — No bloquear                      |

**Regla:** Pending Sync NO bloquea interacción. Usuario puede seguir operando.

### 4.4 Estado: Sync Error

| Aspecto          | Especificación                         |
| ---------------- | -------------------------------------- |
| Indicador visual | Prominente pero no modal               |
| Icono            | Alerta, nube con X, o exclamación      |
| Color            | Rojo o naranja de alerta               |
| Tooltip          | Mensaje de error legible (desde i18n)  |
| Acción visible   | Botón/icono de retry                   |
| Interacción      | **PERMITIDA** — No bloquear navegación |

**Regla:** Sync Error muestra retry pero NO bloquea la aplicación.

---

## 5. WIDGETS DE INDICADOR

### 5.1 Widget Canónico

| Propósito               | Widget                | Uso Alternativo |
| ----------------------- | --------------------- | --------------- |
| Indicar estado de sync  | `SyncStatusIndicator` | ❌ PROHIBIDO    |
| Badge de pendientes     | `PendingSyncBadge`    | ❌ PROHIBIDO    |
| Error de sync con retry | `SyncErrorBanner`     | ❌ PROHIBIDO    |

### 5.2 Nota sobre Nombres de Widgets

Los nombres son **contractuales a nivel de ROL y FUNCIÓN**.
La implementación puede variar siempre que cumpla el contrato visual especificado.

---

## 6. UBICACIÓN DE INDICADORES

### 6.1 Indicadores Globales

| Ubicación         | Uso                        | Widget                |
| ----------------- | -------------------------- | --------------------- |
| AppBar / Header   | Estado general de la app   | `SyncStatusIndicator` |
| Bottom Navigation | Badge de pendientes global | `PendingSyncBadge`    |
| Drawer / Sidebar  | Resumen de estado          | `SyncStatusIndicator` |

### 6.2 Indicadores por Elemento

| Ubicación       | Uso                           | Widget                         |
| --------------- | ----------------------------- | ------------------------------ |
| Card / ListTile | Estado de ese ítem específico | `SyncStatusIndicator` (inline) |
| Form            | Estado del formulario actual  | `SyncStatusIndicator`          |
| Detail View     | Estado del registro mostrado  | `SyncStatusIndicator`          |

### 6.3 Regla de Jerarquía

| Nivel    | Prioridad | Ejemplo                           |
| -------- | --------- | --------------------------------- |
| Global   | Baja      | App está online                   |
| Pantalla | Media     | Esta lista tiene datos stale      |
| Elemento | Alta      | Este registro tiene error de sync |

**Regla:** Indicadores de elemento específico tienen prioridad visual sobre indicadores globales.

---

## 7. REGLAS DE INTERACCIÓN [CRÍTICO]

### 7.1 Prohibiciones

| Acción                                  | Permitido |
| --------------------------------------- | --------- |
| Bloquear UI completa por estado offline | ❌ NO     |
| Bloquear navegación por Pending Sync    | ❌ NO     |
| Modal bloqueante por Sync Error         | ❌ NO     |
| Deshabilitar inputs por estado Stale    | ❌ NO     |
| Impedir submit por Pending Sync         | ❌ NO     |

### 7.2 Excepciones Controladas

| Excepción                      | Condición                        | Fuente de Decisión |
| ------------------------------ | -------------------------------- | ------------------ |
| Deshabilitar acción específica | Controller indica explícitamente | Application Layer  |
| Bloquear operación crítica     | Dominio lo requiere              | Dominio            |
| Mostrar modal de conflicto     | Conflicto real detectado         | Application Layer  |

**Regla dura:** Cualquier restricción funcional DEBE provenir del Dominio o Application Layer, NO de la UI.

> **Ref:** UI_CONTRACTS.md §7.2 (Nota de Gobernanza)

---

## 8. OPTIMISTIC UI [CRÍTICO]

### 8.1 Flujo Visual Obligatorio

| Paso | Acción UI                            | Responsable                                                                                        |
| ---- | ------------------------------------ | -------------------------------------------------------------------------------------------------- |
| 1    | Usuario realiza acción               | Usuario                                                                                            |
| 2    | UI refleja cambio **inmediatamente** | UI                                                                                                 |
| 3    | Indicador Pending Sync aparece       | UI                                                                                                 |
| 4a   | Éxito → Indicador desaparece         | Controller → UI                                                                                    |
| 4b   | Fallo                                | Controller emite estado previo + error → UI renderiza únicamente la reversión visual y el feedback |

### 8.2 Reglas de Optimistic UI

| Regla                                    | Obligatorio |
| ---------------------------------------- | ----------- |
| Reacción inmediata al input              | ✅ SÍ       |
| No esperar respuesta para mostrar cambio | ✅ SÍ       |
| Revertir visualmente si falla            | ✅ SÍ       |
| Mostrar feedback de error en fallo       | ✅ SÍ       |

> **Ref:** UI_CONTRACTS.md §7.3

---

## 9. NO SPINNERS OF DEATH [CRÍTICO]

### 9.1 Clasificación de Cargas

| Tipo de Carga  | Spinner Bloqueante    | Comportamiento                          |
| -------------- | --------------------- | --------------------------------------- |
| **Crítica**    | ✅ Permitido (máx 3s) | Sin datos no hay sentido de la pantalla |
| **No crítica** | ❌ PROHIBIDO          | Skeleton/placeholder, UI navegable      |
| **Background** | ❌ PROHIBIDO          | Indicador sutil, UI funcional           |

### 9.2 Ejemplos

| Escenario                           | Tipo       | Tratamiento                      |
| ----------------------------------- | ---------- | -------------------------------- |
| Cargar lista principal de Assets    | Crítica    | Spinner hasta datos o timeout 3s |
| Cargar avatar de usuario            | No crítica | Placeholder, carga en background |
| Sincronizar cambios                 | Background | Badge de pending, UI funcional   |
| Cargar datos secundarios en detalle | No crítica | Skeleton parcial                 |

> **Ref:** UI_CONTRACTS.md §7.4

---

## 10. MANEJO VISUAL DE CONFLICTOS

### 10.1 Flujo Visual

| Paso | Acción UI                                        |
| ---- | ------------------------------------------------ |
| 1    | Controller notifica conflicto                    |
| 2    | UI muestra indicador de conflicto en el elemento |
| 3    | Usuario puede acceder a detalle de conflicto     |
| 4    | UI presenta opciones (si Controller las provee)  |
| 5    | Usuario selecciona opción                        |
| 6    | UI despacha intención al Controller              |

### 10.2 Opciones Visuales de Resolución

| Opción          | Descripción Visual                |
| --------------- | --------------------------------- |
| Mantener local  | Botón "Conservar mis cambios"     |
| Aceptar remoto  | Botón "Usar versión del servidor" |
| Ver diferencias | Enlace a vista comparativa        |

### 10.3 Prohibiciones

| Acción                             | Permitido |
| ---------------------------------- | --------- |
| Resolver conflicto automáticamente | ❌ NO     |
| Sobrescribir sin notificar         | ❌ NO     |
| Perder datos sin confirmación      | ❌ NO     |
| UI decide la resolución            | ❌ NO     |

> **Ref:** UI_CONTRACTS.md §7.5

---

## 11. CHECKLIST DE REVISIÓN

### Para cada pantalla con datos sincronizables:

| Verificación                                        | Cumple |
| --------------------------------------------------- | ------ |
| ¿Indicador de estado Stale implementado?            | ☐      |
| ¿Indicador de Pending Sync implementado?            | ☐      |
| ¿Indicador de Sync Error implementado?              | ☐      |
| ¿Sync Error muestra acción de retry?                | ☐      |
| ¿Ningún estado bloquea la UI?                       | ☐      |
| ¿Optimistic update implementado?                    | ☐      |
| ¿Spinner solo en cargas críticas?                   | ☐      |
| ¿Conflictos notifican sin resolver automáticamente? | ☐      |
| ¿Textos de indicadores provienen de i18n?           | ☐      |

---

## 12. ANTIPATRONES

| Antipatrón             | Descripción                         | Sección Violada |
| ---------------------- | ----------------------------------- | --------------- |
| Blocking Offline Modal | "Sin conexión" bloquea toda la app  | §7.1, §7.4      |
| Silent Sync            | Sincronizar sin indicador visual    | §4.3, §4.4      |
| Sync Spinner           | Spinner bloqueante durante sync     | §7.4            |
| Auto-Resolve Conflict  | Resolver conflicto sin usuario      | §7.5            |
| UI Decides Sync State  | UI calcula si está synced           | §3.2            |
| Disable on Stale       | Deshabilitar inputs por datos stale | §7.1            |

---

## 13. MAPEO A UI_CONTRACTS.md

| Sección de esta Guía         | Sección de UI_CONTRACTS.md |
| ---------------------------- | -------------------------- |
| §2 Principio Fundamental     | §7.1                       |
| §3 Estados de Sincronización | §7.2                       |
| §4-6 Representación Visual   | §7.2                       |
| §7 Reglas de Interacción     | §7.2 (Nota de Gobernanza)  |
| §8 Optimistic UI             | §7.3                       |
| §9 No Spinners of Death      | §7.4                       |
| §10 Conflictos               | §7.5                       |

---

**FIN DE UI_OFFLINE_SYNC_GUIDE.md — v1.0.0**
