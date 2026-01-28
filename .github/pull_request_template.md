# Pull Request — Capa UI

> **AVISO OBLIGATORIO**: Este template es **OBLIGATORIO** para todo cambio que afecte la capa UI de Avanzza 2.0.
> El incumplimiento de este formato resultará en el **CIERRE AUTOMÁTICO** del PR sin revisión.

---

## 📚 Lectura Obligatoria Previa

Antes de abrir este PR, el autor **DEBE** haber leído y comprendido:

| Documento | Ubicación | Propósito |
|-----------|-----------|-----------|
| UI_CONTRACTS.md | `docs/governance/UI_CONTRACTS.md` | Contrato maestro de gobernanza UI |
| UI_IMPLEMENTATION_GUIDE_FLUTTER.md | `docs/governance/implementation/` | Guía de implementación Flutter/GetX |
| UI_CODE_REVIEW_CHECKLIST.md v1.0.5 | `docs/governance/implementation/` | Criterios binarios de revisión |
| UI_TYPE_RENDERING_GUIDE.md | `docs/governance/implementation/` | Renderizado canónico de Value Objects |
| UI_OFFLINE_SYNC_GUIDE.md | `docs/governance/implementation/` | Comportamiento offline y sincronización |

---

## 1. Resumen del Cambio

### Ticket / Issue

<!-- OBLIGATORIO: Link al ticket de JIRA, GitHub Issue o ID de tarea -->

**ID**:

### Descripción Técnica

<!--
Describe QUÉ cambia, no POR QUÉ.
Sé conciso y técnico. Máximo 3-4 líneas.
Ejemplo: "Añade AssetDetailPage con GetBuilder, integra MoneyDisplay para costos, implementa indicadores de sync."
-->



### Tipo de Cambio

<!-- Marca con [x] lo que aplique -->

- [ ] Nueva pantalla / Page
- [ ] Modificación de pantalla existente
- [ ] Nuevo widget reutilizable
- [ ] Corrección de bug visual
- [ ] Refactor de UI (sin cambio funcional)
- [ ] Integración de nuevo Value Object en UI

---

## 2. Evidencia Visual

> **⛔ STOP**: Si este PR incluye cambios visuales y **NO hay screenshots**, será **CERRADO AUTOMÁTICAMENTE** sin revisión.

<!--
📸 IMPORTANTE: Incluye contexto suficiente en las capturas.
Muestra la pantalla completa, no solo el widget modificado.
Si hay interacción con otros elementos, inclúyelos.
-->

### Screenshots / Capturas

<!--
OBLIGATORIO para todo cambio visual.
Arrastra las imágenes directamente o usa sintaxis markdown.
-->

| Estado | Light Mode | Dark Mode |
|--------|------------|-----------|
| Antes | <!-- screenshot --> | <!-- screenshot --> |
| Después | <!-- screenshot --> | <!-- screenshot --> |

### Video / GIF (Flujos Animados)

<!--
OBLIGATORIO si el cambio incluye:
- Animaciones
- Transiciones
- Flujos multi-paso
- Comportamiento de scroll
- Estados de carga/sync
-->

| Descripción del Flujo | Video/GIF |
|-----------------------|-----------|
| <!-- ej: "Flujo de creación de asset" --> | <!-- link o embed --> |

---

## 3. Declaración Jurada del Autor

> El autor de este PR **CERTIFICA** bajo su responsabilidad profesional que:

<!--
OBLIGATORIO: Marca TODOS los checkboxes que apliquen.
Si no puedes marcar alguno, documenta la excepción en la sección correspondiente.
-->

- [ ] He leído los documentos de gobernanza listados arriba
- [ ] Cumplo **100%** los criterios 🔴 BLOCKER del UI_CODE_REVIEW_CHECKLIST.md v1.0.5
- [ ] **NO** existe bypass de renderizado canónico (Value Objects usan widgets obligatorios)
- [ ] **NO** uso `Navigator` fuera de helpers permitidos (`AppDialogs`, `AppSheets`) — Regla N02b
- [ ] **NO** existe lógica de negocio en la capa UI (Patrón Dumb View)
- [ ] **NO** existe `setState()` en ninguna parte del código
- [ ] Todo `StatefulWidget` (si existe) cumple A07a-d y tiene comentario `// ALLOWED_STATEFUL_WIDGET(reason): ...`
- [ ] He verificado el comportamiento Offline/Sync visualmente
- [ ] Todos los textos visibles usan `l10n` / `AppLocalizations`
- [ ] Los widgets canónicos nuevos (si aplica) están en `presentation/widgets/rendering/`

> ⚠️ **ADVERTENCIA**: Marcar estos ítems sin cumplimiento real constituye una **falta grave de gobernanza** y puede derivar en el cierre del PR y acciones de revisión técnica.

---

## 4. Checklist de Gobernanza 🔴 BLOCKER

> **Referencia**: UI_CODE_REVIEW_CHECKLIST.md v1.0.5
> Todos los ítems marcados deben cumplirse para que el PR sea aprobado.

### §2 Arquitectura UI

<!-- Marca con [x] cada sección verificada -->

- [ ] **A01–A05**: Patrón Dumb View (Page solo lee estado y despacha eventos)
- [ ] **A06**: NO existe `setState()` en ninguna parte
- [ ] **A07a–d**: StatefulWidget solo en `/widgets` o `/components` con comentario obligatorio
- [ ] **A08–A11**: Controllers registrados en Bindings, NO `Get.put()` en Pages
- [ ] **A12–A15**: GetBuilder para `update()`, Obx para `.obs`, NO Obx en root layouts

### §3 Renderizado de Tipos

- [ ] **T01–T09**: Value Objects usan widgets canónicos (`MoneyDisplay`, `DateDisplay`, `StatusBadge`, etc.)
- [ ] **T10–T14**: NO strings hardcodeados (excepto separadores permitidos: `" "`, `"|"`, `"•"`, `","`)
- [ ] **Prerrequisito**: Widgets canónicos existen o se crean en este PR (NO bypass con `Text()`)

### §5 Estados Offline/Sync

- [ ] **S01–S02**: Synced = sin indicador (estado implícito)
- [ ] **S03–S05**: Estados Stale/Pending/Error usan tokens semánticos del Design System
- [ ] **S06**: UI NO se bloquea en ningún estado de sincronización
- [ ] **S07–S09**: Estado de sync se lee del Controller, NO de entidades de dominio
- [ ] **S10–S11**: Optimistic UI implementado, rollback manejado por Controller

<!--
🔁 RECORDATORIO S11: El rollback lo emite el Controller (estado previo + error).
La UI SOLO re-renderiza. La UI NUNCA ejecuta lógica de compensación.
-->

### §6 Navegación

- [ ] **N01**: Navegación usa GetX routing (`Get.toNamed`, `Get.offNamed`)
- [ ] **N02**: NO existe `Navigator.push` directo para navegación entre pantallas
- [ ] **N02b**: `Navigator` solo para APIs SDK vía helpers centralizados (`AppDialogs`, `AppSheets`)
- [ ] **N03**: Rutas definidas en archivo centralizado
- [ ] **N04**: NO existe lógica de negocio en callbacks de navegación

---

## 5. Gestión de Excepciones (Deuda Técnica)

> Si este PR **viola** alguna regla 🔴 BLOCKER, **DEBE** documentarse aquí con un ADR aprobado.
> **Sin ADR aprobado = PR BLOQUEADO**.

> ⚠️ **No se aceptan excepciones "temporales"** sin fecha de caducidad, responsable asignado y ADR aprobado.

### ¿Existe alguna excepción a las reglas BLOCKER?

- [ ] **NO** — Este PR cumple 100% las reglas BLOCKER
- [ ] **SÍ** — Existe excepción documentada (completar tabla abajo)

### Registro de Excepciones

<!--
Solo completar si marcaste "SÍ" arriba.
Cada excepción DEBE tener un ADR aprobado por Tech Lead.
-->

| Regla Violada | Justificación Técnica | Link al ADR | Fecha Caducidad | Responsable |
|---------------|----------------------|-------------|-----------------|-------------|
| <!-- ej: A07b --> | <!-- Razón técnica concreta --> | <!-- link --> | <!-- YYYY-MM-DD --> | <!-- nombre --> |
| | | | | |

---

## 6. Impacto en Sistemas

<!-- Marca con [x] si aplica -->

### Dependencias y Migraciones

- [ ] Requiere migración de base de datos
- [ ] Rompe compatibilidad con API existente
- [ ] Requiere actualización de dependencias (`pubspec.yaml`)
- [ ] Requiere nuevos assets (imágenes, fuentes, etc.)

### Widgets y Componentes

- [ ] Crea nuevos widgets canónicos en `presentation/widgets/rendering/`
- [ ] Modifica widgets canónicos existentes
- [ ] Requiere actualización del barrel file de exports

### Testing

- [ ] Incluye widget tests para componentes nuevos
- [ ] Tests existentes siguen pasando
- [ ] Requiere actualización de tests existentes

### Documentación

- [ ] Requiere actualización de documentación de gobernanza UI (si se tocaron patrones o widgets canónicos)

---

## 7. Notas Adicionales para el Revisor

<!--
Opcional: Información adicional que el revisor debe conocer.
- Decisiones de diseño no obvias
- Áreas que requieren atención especial
- Contexto adicional del ticket
-->



---

## Checklist Final del Revisor

> **Para uso exclusivo del Code Reviewer**

- [ ] Evidencia visual verificada (screenshots/video presentes y correctos)
- [ ] Declaración jurada del autor completa
- [ ] Todos los criterios 🔴 BLOCKER verificados
- [ ] Excepciones (si existen) tienen ADR aprobado con fecha y responsable
- [ ] Código revisado contra UI_CODE_REVIEW_CHECKLIST.md v1.0.5

**Resultado**:
- [ ] ✅ **APROBADO** — Cumple 100% gobernanza UI
- [ ] ❌ **BLOQUEADO** — Requiere correcciones (detallar en comentarios)

---

*Template de PR generado bajo UI Governance System — Avanzza 2.0*
*Referencia: UI_CODE_REVIEW_CHECKLIST.md v1.0.5*
