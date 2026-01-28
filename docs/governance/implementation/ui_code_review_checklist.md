# UI Code Review Checklist

> **Versión**: 1.0.5
> **Última actualización**: 2025-01-28
> **Nivel de gobierno**: Implementation Guide (Capa de Ejecución)
> **Aplica a**: Todo código Flutter UI en Avanzza 2.0
> **Modo de uso**: Checklist obligatorio para revisión de PRs que afecten capa UI

---

## Resumen Ejecutivo

Este documento define los criterios **binarios** de revisión de código UI. Cada ítem tiene únicamente dos estados posibles: **✅ CUMPLE** o **❌ NO CUMPLE**. No existen estados intermedios, excepciones contextuales ni interpretaciones subjetivas.

**Documento padre**: [UI_CONTRACTS.md](../UI_CONTRACTS.md) v1.0.2
**Guía de implementación**: [UI_IMPLEMENTATION_GUIDE_FLUTTER.md](./UI_IMPLEMENTATION_GUIDE_FLUTTER.md)

---

## §1. Instrucciones de Uso

### 1.1 Para el Revisor

1. Copiar esta checklist en el PR como comentario
2. Marcar cada ítem con `[x]` (cumple) o `[ ]` (no cumple)
3. Si **cualquier ítem BLOCKER** está marcado como NO CUMPLE → **PR BLOQUEADO**
4. No aprobar PRs con ítems BLOCKER pendientes de verificación

### 1.2 Criterio de Aprobación

| Condición | Resultado |
|-----------|-----------|
| 100% ítems BLOCKER marcados como CUMPLE | ✅ PR puede ser aprobado |
| ≥1 ítem BLOCKER marcado como NO CUMPLE | ❌ PR bloqueado hasta corrección |
| Ítem FORMATIVO no cumple | ⚠️ Requiere documentación, no bloquea |
| Ítem no aplicable | Marcar como N/A con justificación |

### 1.3 Regla de Bloqueo Automático

> **REGLA FORMAL DE GOBERNANZA**

Las siguientes secciones contienen criterios **BLOCKER**. Si **CUALQUIER ítem** de estas secciones falla:
- El PR queda **AUTOMÁTICAMENTE BLOQUEADO**
- **NO puede aprobarse "con comentarios"**
- **NO puede aprobarse "para arreglar después"**
- El merge está **PROHIBIDO** hasta corrección verificada

| Sección | Clasificación | Consecuencia de Fallo |
|---------|---------------|----------------------|
| §2.1 Patrón Dumb View | 🔴 BLOCKER | PR bloqueado |
| §2.2 State Management (GetX) | 🔴 BLOCKER | PR bloqueado |
| §2.3 Reactividad (GetBuilder vs Obx) | 🔴 BLOCKER | PR bloqueado |
| §3.1 Value Objects | 🔴 BLOCKER | PR bloqueado |
| §3.2 Strings e Internacionalización | 🔴 BLOCKER | PR bloqueado |
| §5 Estados Offline/Sync | 🔴 BLOCKER | PR bloqueado |
| §6.1 Navegación (N01–N04) | 🔴 BLOCKER | PR bloqueado |
| §4 Inputs y Formularios | 🟡 FORMATIVO | Documentar, no bloquea |
| §6.1 Navegación (N05 únicamente) | 🟡 FORMATIVO | Documentar, no bloquea |
| §7 Testeabilidad | 🟡 FORMATIVO | Documentar, no bloquea |
| §8 Estructura de Código | 🟡 FORMATIVO | Documentar, no bloquea |

---

## §2. Checklist de Arquitectura UI

### 2.1 Patrón Dumb View 🔴 BLOCKER
> **Referencia**: UI_CONTRACTS.md §2

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| A01 | La Page/Screen NO contiene lógica de negocio | UI_CONTRACTS §2.1 | [ ] |
| A02 | La Page/Screen NO realiza cálculos sobre datos | UI_CONTRACTS §2.1 | [ ] |
| A03 | La Page/Screen NO toma decisiones condicionales de negocio | UI_CONTRACTS §2.1 | [ ] |
| A04 | Toda lógica condicional es puramente visual (mostrar/ocultar, colores) | UI_CONTRACTS §2.1 | [ ] |
| A05 | La Page/Screen solo lee estado del Controller y despacha eventos | UI_CONTRACTS §2.2 | [ ] |

### 2.2 State Management (GetX) 🔴 BLOCKER
> **Referencia**: UI_IMPLEMENTATION_GUIDE_FLUTTER.md §2

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| A06 | NO existe `setState()` en ninguna parte del código | GUIDE §2.1 | [ ] |
| A07a | Ninguna Page/Screen puede ser `StatefulWidget` | GUIDE §2.1 | [ ] |
| A07b | `StatefulWidget` solo permitido en widgets internos (no Pages) para animación/controladores nativos; DEBE incluir comentario `// ALLOWED_STATEFUL_WIDGET(reason): <text>` y NO puede contener lógica de negocio | GUIDE §2.1 | [ ] |
| A07c | Todo `StatefulWidget` permitido DEBE contener explícitamente el comentario `// ALLOWED_STATEFUL_WIDGET(reason): ...` en la declaración de clase | GUIDE §2.1 | [ ] |
| A07d | Ningún `StatefulWidget` permitido puede vivir en directorios `/pages` o `/screens`; solo en `/widgets` o `/components` | GUIDE §2.1 | [ ] |
| A08 | Todo Controller está registrado en un Binding | GUIDE §2.2 | [ ] |
| A09 | NO existe `Get.put()` dentro de `build()` | GUIDE §2.2 | [ ] |
| A10 | NO existe `Get.put()` en el cuerpo de la Page | GUIDE §2.2 | [ ] |
| A11 | NO existe `Get.find()` sin Binding previo registrado | GUIDE §2.2 | [ ] |

### 2.3 Reactividad (GetBuilder vs Obx) 🔴 BLOCKER
> **Referencia**: UI_SCREEN_TEMPLATE.md §5

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| A12 | `GetBuilder<T>` se usa para rebuilds estructurales y SOLO puede reaccionar a estado actualizado vía `controller.update()`; NUNCA puede reaccionar a variables `.obs` | TEMPLATE §5 | [ ] |
| A13 | `Obx` se usa exclusivamente para variables `.obs` | TEMPLATE §5 | [ ] |
| A14 | NO existe `Obx` envolviendo el root layout de pantalla (ver lista abajo) | TEMPLATE §5 | [ ] |
| A15 | NO existe `GetBuilder` reaccionando a variables `.obs` | TEMPLATE §5 | [ ] |

> **REGLA A14 — Root Layouts PROHIBIDOS de envolver con Obx**:
> - `Scaffold`
> - `Navigator` / `Router`
> - `PageView` / `TabBarView` / `IndexedStack`
> - `CustomScrollView` / `ListView` / `GridView` (cuando son root del body)
>
> **PATRÓN RECOMENDADO (no blocker)**:
> ```
> Scaffold → GetBuilder<Controller> → body con Obx solo en sub-widgets pequeños
> ```
> EVITAR envolver `Column`/`Row` grandes o con listas pesadas; preferir `Obx` en sub-widgets reactivos (badges, banners, contadores, chips, botones, indicadores).

---

## §3. Checklist de Renderizado de Tipos 🔴 BLOCKER

> **REGLA NORMATIVA**: Romper el renderizado canónico de Value Objects o las reglas de i18n constituye **VIOLACIÓN DE CONTRATO UI** y genera deuda técnica sistémica. No existen excepciones.

> **REGLA DE PRERREQUISITO — Widgets Canónicos**:
> Si el widget canónico requerido por el contrato (`MoneyDisplay`, `DateDisplay`, `TimeDisplay`, `AddressDisplay`, `CoordinatesDisplay`, `StatusBadge`) **NO existe** en el proyecto:
> - a) El PR **DEBE incluir** su implementación, **O**
> - b) El PR **DEBE depender** de un PR previo que lo agregue (indicar en descripción del PR).
>
> **Ubicación obligatoria**: `presentation/widgets/rendering/`
> **Exportación obligatoria**: vía barrel file (`rendering.dart` o equivalente)
>
> Está **PROHIBIDO** hacer bypass temporal con `Text()`, `toString()`, `NumberFormat` directo, `DateFormat` directo, o mapeos manuales bajo **cualquier justificación** ("mientras se crea el widget", "es temporal", "lo arreglo después"). Si se detecta bypass en UI, el PR queda **BLOQUEADO**.
>
> La definición y contrato de estos widgets vive en [UI_TYPE_RENDERING_GUIDE.md](./UI_TYPE_RENDERING_GUIDE.md).

### 3.1 Value Objects 🔴 BLOCKER
> **Referencia**: UI_TYPE_RENDERING_GUIDE.md §2–§5

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| T01 | `MonetaryAmount` se renderiza con `MoneyDisplay` | RENDER §2 | [ ] |
| T02 | NO existe formato manual de moneda (NumberFormat, toStringAsFixed) | RENDER §2 | [ ] |
| T03 | `DateTime` se renderiza con widget especializado (DateDisplay/TimeDisplay) | RENDER §3 | [ ] |
| T04 | NO existe formato manual de fecha/hora (DateFormat directo) | RENDER §3 | [ ] |
| T05 | `RelativeDateDisplay` solo aparece en: feeds, logs, notifications, comments | RENDER §3.4 | [ ] |
| T06 | `GeoLocation` se renderiza con `AddressDisplay` o `CoordinatesDisplay` | RENDER §4 | [ ] |
| T07 | NO existe concatenación manual de coordenadas/direcciones | RENDER §4 | [ ] |
| T08 | Enums se renderizan con `StatusBadge` o widget especializado | RENDER §5 | [ ] |
| T09 | NO existe mapeo manual enum → string en la UI | RENDER §5 | [ ] |

### 3.2 Strings e Internacionalización 🔴 BLOCKER
> **Referencia**: UI_CONTRACTS.md §6

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| T10 | NO existen strings hardcodeados visibles al usuario | UI_CONTRACTS §6 | [ ] |
| T11 | Todo texto visible usa `AppLocalizations` o `l10n` | UI_CONTRACTS §6 | [ ] |
| T12 | Labels de botones usan `l10n` | UI_CONTRACTS §6 | [ ] |
| T13 | Mensajes de error usan `l10n` | UI_CONTRACTS §6 | [ ] |
| T14 | Placeholders de inputs usan `l10n` | UI_CONTRACTS §6 | [ ] |

> **STRINGS NO VISIBLES PERMITIDAS (sin l10n)**:
> - Separadores de layout: `" "`, `"|"`, `"•"`, `","`
> - Emojis sin texto acompañante
>
> Todo lo demás sigue siendo **BLOCKER**.

---

## §4. Checklist de Inputs y Formularios 🟡 FORMATIVO

### 4.1 Validación
> **Referencia**: UI_CONTRACTS.md §5

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| F01 | Validación de formato se ejecuta en UI (regex, longitud, tipo) | UI_CONTRACTS §5.1 | [ ] |
| F02 | Validación de negocio se delega al Controller/Caso de Uso | UI_CONTRACTS §5.2 | [ ] |
| F03 | NO existe validación de reglas de negocio en la Page | UI_CONTRACTS §5.2 | [ ] |
| F04 | Mensajes de error de validación usan `l10n` | UI_CONTRACTS §6 | [ ] |

### 4.2 Inputs Especializados
> **Referencia**: UI_IMPLEMENTATION_GUIDE_FLUTTER.md §4

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| F05 | Input de moneda usa widget especializado (MoneyInput) | GUIDE §4 | [ ] |
| F06 | Input de fecha usa widget especializado (DatePicker wrapper) | GUIDE §4 | [ ] |
| F07 | Input de ubicación usa widget especializado (LocationPicker) | GUIDE §4 | [ ] |
| F08 | NO existe TextFormField raw para tipos estructurados | GUIDE §4 | [ ] |

---

## §5. Checklist de Estados Offline/Sync 🔴 BLOCKER

### 5.1 Indicadores Visuales
> **Referencia**: UI_OFFLINE_SYNC_GUIDE.md §2

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| S01 | Existe indicador visual de estado de sincronización cuando aplica | OFFLINE §2 | [ ] |
| S02 | Estado Synced NO muestra indicador (estado implícito por defecto) | OFFLINE §2.1 | [ ] |
| S03 | Estado Stale muestra indicador con token semántico `warning` del Design System | OFFLINE §2.2 | [ ] |
| S04 | Estado Pending Sync muestra indicador con token semántico `info` del Design System | OFFLINE §2.3 | [ ] |
| S05 | Estado Sync Error muestra indicador con token semántico `error` del Design System | OFFLINE §2.4 | [ ] |
| S06 | UI NO se bloquea en ningún estado de sincronización | OFFLINE §3 | [ ] |

> **REGLA S03–S05**: Los colores de indicadores de sync DEBEN usar tokens semánticos del Design System (`warning`, `info`, `error`). NO usar colores hardcodeados.

### 5.2 Fuente de Estado
> **Referencia**: UI_SCREEN_TEMPLATE.md §8

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| S07 | Estado de sync se lee del Controller/ViewModel | TEMPLATE §8 | [ ] |
| S08 | NO existe acceso directo a `entity.syncStatus` desde UI | TEMPLATE §8 | [ ] |
| S09 | NO existe lógica de sincronización en la Page | OFFLINE §4 | [ ] |

> **REGLA NORMATIVA**: Cualquier lectura directa de estado de sync desde entidades de dominio constituye **VIOLACIÓN DE CONTRATO UI**. No existen excepciones. El estado de sincronización SOLO se obtiene del Controller/ViewModel.

### 5.3 Optimistic UI
> **Referencia**: UI_OFFLINE_SYNC_GUIDE.md §5

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| S10 | Acciones del usuario reflejan cambio inmediato en UI | OFFLINE §5 | [ ] |
| S11 | En caso de fallo: Controller emite estado previo + error → UI renderiza el cambio | OFFLINE §5 | [ ] |

> **REGLA S11 — ROLLBACK**:
> - El **Controller** emite el estado previo + señal de error
> - La **UI** SOLO re-renderiza ese estado recibido
> - La **UI NO ejecuta** lógica de compensación, reversión ni decisiones de rollback
> - Flujo canónico: `Controller emite estado previo + error → UI renderiza el cambio`

---

## §6. Checklist de Navegación

### 6.1 Patrones de Navegación
> **Referencia**: UI_CONTRACTS.md §7

| # | Criterio | Mapeo | Clasificación | Estado |
|---|----------|-------|---------------|--------|
| N01 | Navegación usa GetX routing (`Get.toNamed`, `Get.offNamed`) | UI_CONTRACTS §7 | 🔴 BLOCKER | [ ] |
| N02 | NO existe `Navigator.push` directo para navegación entre pantallas | UI_CONTRACTS §7 | 🔴 BLOCKER | [ ] |
| N02b | `Navigator` solo permitido para APIs SDK (`showDialog`, `showModalBottomSheet`, `showBottomSheet`) y exclusivamente a través de helpers centralizados (`AppDialogs`, `AppSheets` o equivalentes) | UI_CONTRACTS §7 | 🔴 BLOCKER | [ ] |
| N03 | Rutas están definidas en archivo centralizado de rutas | UI_CONTRACTS §7 | 🔴 BLOCKER | [ ] |
| N04 | NO existe lógica de negocio en callbacks de navegación | UI_CONTRACTS §7 | 🔴 BLOCKER | [ ] |
| N05 | Argumentos de navegación son tipos inmutables o IDs | UI_CONTRACTS §7 | 🟡 FORMATIVO | [ ] |

> **REGLA NORMATIVA N01–N04**: El uso de `Navigator.push` directo para navegación entre pantallas, rutas no centralizadas, o lógica de negocio en navegación constituye **VIOLACIÓN DE CONTRATO UI**. GetX es el único sistema de routing permitido para navegación.
>
> **EXCEPCIÓN CONTROLADA (N02b)**: `Navigator` está permitido **únicamente** para invocar APIs nativas del SDK Flutter (`showDialog`, `showModalBottomSheet`, `showBottomSheet`) y **solo** a través de helpers centralizados del proyecto (`AppDialogs`, `AppSheets`). Uso directo fuera de helpers = BLOCKER.

---

## §7. Checklist de Testeabilidad 🟡 FORMATIVO

### 7.1 Keys y Semantic Labels
> **Referencia**: UI_IMPLEMENTATION_GUIDE_FLUTTER.md §6

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| Q01 | Todo botón tiene `Key` definido | GUIDE §6 | [ ] |
| Q02 | Todo campo de input tiene `Key` definido | GUIDE §6 | [ ] |
| Q03 | Elementos interactivos tienen `semanticLabel` | GUIDE §6 | [ ] |
| Q04 | Keys siguen convención de naming del proyecto | GUIDE §6 | [ ] |

---

## §8. Checklist de Estructura de Código 🟡 FORMATIVO

### 8.1 Organización
> **Referencia**: UI_IMPLEMENTATION_GUIDE_FLUTTER.md §7

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| C01 | Page está en directorio correspondiente a su feature/dominio | GUIDE §7 | [ ] |
| C02 | Binding está en archivo separado o junto al Controller | GUIDE §7 | [ ] |
| C03 | NO existe código duplicado que debería ser widget reutilizable | GUIDE §7 | [ ] |

### 8.2 Imports
> **Referencia**: Arquitectura por capas

| # | Criterio | Mapeo | Estado |
|---|----------|-------|--------|
| C04 | NO existen imports de capas inferiores (Repository, DataSource) | ARCH | [ ] |
| C05 | NO existen imports de infraestructura (HTTP clients, DB) | ARCH | [ ] |
| C06 | Imports de dominio son solo DTOs/ViewModels expuestos | ARCH | [ ] |

---

## §9. Resumen de Verificación

### 9.1 Clasificación de Criterios

| Tipo | Secciones | Total Ítems | Consecuencia |
|------|-----------|-------------|--------------|
| 🔴 BLOCKER | §2, §3, §5, N01–N04, N02b | 44 | PR bloqueado automáticamente |
| 🟡 FORMATIVO | §4, N05, §7, §8 | 13 | Documentar, no bloquea merge |

### 9.2 Template para Comentario de PR

```markdown
## UI Code Review Checklist v1.0.5

### 🔴 BLOCKER — Fallo = PR Bloqueado Automáticamente

#### Arquitectura UI
- [ ] A01-A05: Patrón Dumb View
- [ ] A06: NO setState()
- [ ] A07a-d: StatefulWidget (solo en /widgets o /components, con comentario ALLOWED_STATEFUL_WIDGET)
- [ ] A08-A11: Bindings y Get.put/find
- [ ] A12-A15: Reactividad (GetBuilder + update(), Obx + .obs, NO Obx en root layouts)

#### Renderizado de Tipos
- [ ] Prerrequisito: Widgets canónicos en presentation/widgets/rendering/ (NO bypass)
- [ ] T01-T09: Value Objects (render canónico obligatorio)
- [ ] T10-T14: Strings e i18n (NO hardcoded, excepto separadores permitidos)

#### Estados Offline/Sync
- [ ] S01-S02: Synced = sin indicador
- [ ] S03-S05: Tokens semánticos (warning/info/error)
- [ ] S06: UI no se bloquea
- [ ] S07-S09: Fuente de Estado
- [ ] S10-S11: Optimistic UI

#### Navegación Crítica
- [ ] N01-N04: GetX routing, NO Navigator.push para navegación, rutas centralizadas
- [ ] N02b: Navigator solo para APIs SDK vía helpers centralizados

---

### 🟡 FORMATIVO — Documentar si no cumple

#### Inputs y Formularios
- [ ] F01-F04: Validación
- [ ] F05-F08: Inputs Especializados

#### Navegación General
- [ ] N05: Argumentos inmutables/IDs

#### Testeabilidad
- [ ] Q01-Q04: Keys y Semantic Labels

#### Estructura de Código
- [ ] C01-C03: Organización
- [ ] C04-C06: Imports

---

**Resultado BLOCKER**: [ ] PASA / [ ] FALLA
**Resultado FORMATIVO**: [ ] PASA / [ ] DOCUMENTADO

**Decisión Final**: [ ] APROBADO / [ ] BLOQUEADO

**Comentarios del revisor**:
_[Añadir observaciones si algún ítem no cumple]_
```

---

## §10. Notas de Gobernanza

### 10.1 Actualizaciones

| Cambio en documento padre | Acción requerida |
|---------------------------|------------------|
| Nuevo requisito en UI_CONTRACTS.md | Añadir ítem(s) correspondiente(s) |
| Modificación de regla existente | Actualizar criterio y mapeo |
| Deprecación de requisito | Marcar ítem como DEPRECATED, no eliminar |

### 10.2 Excepciones

> **NO EXISTEN EXCEPCIONES NO DOCUMENTADAS PARA CRITERIOS BLOCKER**

Las únicas excepciones permitidas son las **explícitamente definidas en este checklist** (ej. A07b-d para StatefulWidget interno, N02b para Navigator con APIs SDK).

Cualquier código que no cumpla con un criterio 🔴 BLOCKER debe ser corregido antes de merge. No se aceptan:
- "Lo arreglo en otro PR"
- "Es código legacy"
- "No aplica en este caso específico" (sin documentación formal)
- "Aprobado con comentarios"

Para criterios 🟡 FORMATIVO: el incumplimiento debe documentarse en el PR con justificación y plan de corrección.

### 10.3 Escalamiento

Si existe desacuerdo sobre la interpretación de un criterio:
1. Referir al documento fuente (UI_CONTRACTS.md o guía específica)
2. Si persiste ambigüedad → escalar a Tech Lead
3. Si requiere excepción formal → documentar en ADR

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.5 | 2025-01-28 | A07c/A07d añadidos (comentario obligatorio y ubicación en /widgets o /components); A12 precisión semántica (GetBuilder solo con update(), NUNCA con .obs); A14 patrón recomendado añadido (Scaffold → GetBuilder → Obx en sub-widgets); §3 widgets canónicos: ubicación obligatoria presentation/widgets/rendering/ + barrel file; N02b añadido (Navigator solo para APIs SDK vía helpers centralizados); T10-T14 strings permitidas sin l10n definidas (separadores y emojis); §9.1 conteo actualizado (44 BLOCKER) |
| 1.0.4 | 2025-01-28 | A14 clarificado: lista verificable de root layouts, Column/Row pasan a "EVITAR" (recomendación); A07b tag estandarizado; A12 aclaración semántica; §10.2 alineado; §3 regla de prerrequisito de widgets canónicos |
| 1.0.3 | 2025-01-28 | A07 dividido en A07a/A07b (StatefulWidget refinado), A14 clarificado con lista explícita de layouts raíz, S03–S05 usan tokens semánticos del Design System |
| 1.0.2 | 2025-01-28 | S02 corregido (Synced = sin indicador), §3 Renderizado elevado a BLOCKER, N01–N04 elevados a BLOCKER, mapeos de sección ajustados |
| 1.0.1 | 2025-01-28 | Clasificación BLOCKER/FORMATIVO, regla de bloqueo automático, refuerzo S11 rollback, lenguaje normativo §5.2 |
| 1.0.0 | 2025-01-28 | Versión inicial con 47 criterios binarios |

---

*Documento generado como parte de la Capa de Implementación de Gobernanza UI - Avanzza 2.0*
