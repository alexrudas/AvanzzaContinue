# UI_CONTRACTS.md

## Avanzza 2.0 — UI Governance Contracts

> **TIPO:** Contrato de Gobernanza de UI
> **ESTADO:** ACTIVO / VIGENTE
> **VERSIÓN:** 1.0.2
> **AUTORIDAD:** MEDIA
> **SUBORDINADO A:**
>
> - GOVERNANCE_CORE.md
> - GOVERNANCE_USER_WORKSPACE.md
> - DOMAIN_CONTRACTS.md (v1.1.1)
>   **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO Y ALCANCE

Este documento define los **contratos de gobernanza** que rigen el comportamiento de la capa de UI en Avanzza 2.0.

### 1.1 Definición Fundamental

La UI es una **proyección tonta (Dumb View)** del estado del Dominio.

**La UI puede:**

- Consumir estado proveniente del Dominio.
- Renderizar datos según contratos de visualización.
- Capturar intenciones del usuario y despacharlas al Dominio.
- Aplicar validaciones de formato (no de negocio).

**La UI NO puede:**

- ❌ Inventar datos de negocio.
- ❌ Corregir o inferir valores faltantes.
- ❌ Suponer estados no confirmados por el Dominio.
- ❌ Ejecutar lógica condicional de negocio.
- ❌ Almacenar verdad de negocio de forma autoritativa.

### 1.2 Alcance del Documento

Este contrato aplica a:

- Todas las pantallas, widgets y componentes visuales.
- Todos los formularios e inputs.
- Todos los estados de carga, error y conectividad.
- Todas las decisiones de navegación basadas en permisos.

### 1.3 Scope Técnico [REGLA DURA]

**UI_CONTRACTS.md es un contrato conceptual, NO una especificación técnica.**

Este contrato:

- ✅ Aplica a **cualquier tecnología de UI**: Flutter, Web, Desktop, o cualquier otra.
- ✅ Es **agnóstico de framework**, toolkit y lenguaje de programación.
- ✅ Define **qué debe cumplirse**, no **cómo implementarlo**.

**Regla dura:**
Ninguna implementación puede excusarse de cumplir este contrato alegando diferencias técnicas, limitaciones de framework o convenciones de plataforma.

Si una tecnología no permite cumplir un requisito de este contrato:

- La tecnología debe adaptarse, o
- Se requiere aprobación explícita documentada en GOVERNANCE_CORE.md.

---

## 2. JERARQUÍA DE AUTORIDAD

Orden de precedencia obligatorio:

1. **GOVERNANCE_CORE.md**
2. **GOVERNANCE_USER_WORKSPACE.md**
3. **DOMAIN_CONTRACTS.md**
4. **UI_CONTRACTS.md** (este documento)
5. Guías de implementación técnica

**Regla dura:**
Si existe conflicto entre este documento y los documentos superiores, **prevalece el documento de mayor jerarquía**.

**Regla dura:**
La UI **obedece** al Dominio. El Dominio **NO conoce** a la UI.

---

## 3. PRINCIPIOS DE UI GOVERNANCE [CRÍTICOS]

### 3.1 UI is Dumb [REGLA DURA]

Los widgets **SOLO** realizan dos operaciones:

1. **Renderizar** estado recibido.
2. **Despachar** eventos/intenciones al Dominio.

**Prohibido:**

- ❌ Ejecutar lógica condicional de negocio (ej. `if (amount > threshold)`).
- ❌ Calcular valores derivados de negocio.
- ❌ Tomar decisiones basadas en reglas de dominio.

### 3.2 Single Source of Truth

El estado de negocio **siempre** proviene del Dominio.
La UI **nunca** es fuente autoritativa de datos de negocio.

### 3.3 Separation of Concerns

| Responsabilidad             | Pertenece a     |
| --------------------------- | --------------- |
| Qué es válido en el negocio | Dominio         |
| Cómo se muestra al usuario  | UI              |
| Qué puede hacer el usuario  | Workspace/IAM   |
| Cómo se persiste            | Infraestructura |

### 3.4 No Hardcoded Strings [REGLA DURA]

**Prohibido** usar texto literal directamente en widgets de UI.

Todo texto visible al usuario **DEBE** provenir de:

- Archivos de internacionalización (l10n / i18n), o
- Estado proveniente del Dominio.

**Esta regla aplica incluso si la aplicación opera en un solo idioma.**

Justificación:

- Facilita internacionalización futura.
- Centraliza cambios de copy.
- Permite testing sin dependencia de texto visible.

### 3.5 Testability First [REGLA DURA]

Todo elemento interactivo de UI **DEBE** exponer:

- Una **Key única**, o
- Una **etiqueta semántica** (semantic label).

**Regla dura:**
La UI debe ser completamente testeable vía pruebas de integración **sin depender de texto visible ni estructura visual**.

---

## 4. CONTRATO DE VISUALIZACIÓN DE TIPOS (TYPE RENDERING) [CRÍTICO]

### 4.1 Regla General

Los Value Objects del Dominio **DEBEN** renderizarse mediante componentes especializados que respeten su semántica.

**Prohibido:**

- ❌ Mostrar Value Objects como JSON crudo.
- ❌ Mostrar tipos complejos como strings sin formato.
- ❌ Truncar información semántica relevante.

---

### 4.2 MonetaryAmount [CRÍTICO]

**Definición de Dominio:** `{ amount: Decimal, currency: ISO_4217 }`

**Reglas de Visualización:**

| Regla                                                       | Obligatoria |
| ----------------------------------------------------------- | ----------- |
| Mostrar símbolo o código de moneda                          | ✅ SÍ       |
| Formatear según locale del usuario                          | ✅ SÍ       |
| Mostrar decimales según moneda (ej. 2 para USD, 0 para JPY) | ✅ SÍ       |
| Usar separadores de miles apropiados                        | ✅ SÍ       |

**Prohibiciones:**

- ❌ Mostrar como `double` o número crudo (ej. `1234.56`).
- ❌ Omitir la divisa.
- ❌ Asumir moneda por defecto sin confirmación del Dominio.
- ❌ Mezclar formatos de moneda en una misma vista.

**Ejemplos:**

- ✅ `$1,234.56 USD`
- ✅ `€1.234,56`
- ✅ `¥1,235`
- ❌ `1234.56`
- ❌ `1234.56 (asumimos USD)`

---

### 4.3 GeoLocation

**Definición de Dominio:** `{ lat: double, lng: double, timestamp: UTCDate }`

**Reglas de Visualización:**

| Formato permitido                                      | Contexto                       |
| ------------------------------------------------------ | ------------------------------ |
| Mapa interactivo con marcador                          | Vista principal                |
| Coordenadas formateadas (ej. `19.4326° N, 99.1332° W`) | Vista compacta o accesibilidad |
| Dirección geocodificada (si disponible)                | Vista amigable                 |

**Prohibiciones:**

- ❌ Mostrar JSON crudo (ej. `{"lat": 19.43, "lng": -99.13}`).
- ❌ Mostrar coordenadas sin formato (ej. `19.4326, -99.1332`).
- ❌ Omitir indicadores de hemisferio (N/S, E/W) en formato texto.

---

### 4.4 Fechas y Timestamps

**Reglas de Visualización:**

| Regla                                                             | Obligatoria    |
| ----------------------------------------------------------------- | -------------- |
| Localizar al formato del usuario (locale)                         | ✅ SÍ          |
| Convertir a zona horaria del usuario                              | ✅ SÍ          |
| Usar formatos relativos cuando sea apropiado (ej. "hace 2 horas") | ✅ Recomendado |

**Prohibiciones:**

- ❌ Mostrar ISO-8601 crudo (ej. `2024-03-15T14:30:00Z`).
- ❌ Mostrar timestamps Unix.
- ❌ Asumir zona horaria sin confirmación.

**Ejemplos:**

- ✅ `15 de marzo de 2024, 2:30 PM`
- ✅ `March 15, 2024 at 2:30 PM`
- ✅ `Hace 2 horas`
- ❌ `2024-03-15T14:30:00Z`
- ❌ `1710513000`

---

### 4.5 Enums y Estados

**Reglas de Visualización:**

- Mostrar etiqueta legible por humanos, no el valor técnico.
- La etiqueta **DEBE** provenir de i18n.

**Ejemplos:**

- ✅ `En Progreso` (mostrado al usuario)
- ❌ `IN_PROGRESS` (valor interno)

---

## 5. CONTRATO DE INTERACCIÓN (INPUTS & ACTIONS)

### 5.1 Validación de Formato vs Validación de Invariantes [CRÍTICO]

| Tipo de Validación        | Responsable | Ejemplos                                                                   |
| ------------------------- | ----------- | -------------------------------------------------------------------------- |
| **Formato (UX)**          | UI          | Email bien formado, campo numérico, longitud máxima, caracteres permitidos |
| **Invariantes (Negocio)** | Dominio     | Unicidad, reglas financieras, transiciones de estado, límites de negocio   |

**Regla dura:**
La UI valida **forma**. El Dominio valida **significado**.

**Prohibido en UI:**

- ❌ Validar si un email ya existe (requiere consulta a Dominio).
- ❌ Validar si un monto excede límites de negocio.
- ❌ Validar transiciones de estado permitidas.
- ❌ Aplicar reglas que dependan de estado de otras entidades.

---

### 5.2 Inputs Especializados Obligatorios [REGLA DURA]

| Tipo de Dato          | Componente Requerido    | TextField Genérico |
| --------------------- | ----------------------- | ------------------ |
| `MonetaryAmount`      | `MoneyInput`            | ❌ PROHIBIDO       |
| Cantidades numéricas  | `NumberInput`           | ❌ PROHIBIDO       |
| Texto libre           | `TextInput`             | ✅ Permitido       |
| Fechas                | `DatePicker`            | ❌ PROHIBIDO       |
| Selección de opciones | `Selector` / `Dropdown` | ❌ PROHIBIDO       |

**Money is Sacred [REGLA DURA]:**
En pantallas de **Accounting** y **Purchases**, todo input de `MonetaryAmount` **DEBE** usar componentes especializados que:

- Capturen monto y moneda por separado.
- Apliquen máscara de formato.
- Impidan entrada de caracteres no numéricos en el monto.

---

### 5.3 Despacho de Acciones

La UI **despacha intenciones**, no ejecuta operaciones.

**Flujo correcto:**

1. Usuario interactúa con widget.
2. Widget despacha intención/evento.
3. Capa de aplicación/dominio procesa.
4. Nuevo estado se propaga a UI.
5. UI re-renderiza.

**Prohibido:**

- ❌ Ejecutar mutaciones de estado directamente en el widget.
- ❌ Llamar a repositorios o APIs desde widgets.

---

## 6. CONTRATO DE ESTADOS VISUALES

### 6.1 Estados de Datos

| Estado      | Definición                              | Representación Visual                     |
| ----------- | --------------------------------------- | ----------------------------------------- |
| **Empty**   | No existen datos                        | Empty state con mensaje y acción sugerida |
| **Partial** | Datos incompletos o en carga progresiva | Skeleton + datos disponibles              |
| **Full**    | Datos completos disponibles             | Vista completa                            |

**Regla dura:**
Cada estado **DEBE** tener representación visual explícita.
Prohibido dejar la UI en blanco sin indicación de estado.

---

### 6.2 Estados de Ciclo de Vida

| Estado      | Definición           | Comportamiento                                     |
| ----------- | -------------------- | -------------------------------------------------- |
| **Loading** | Operación en curso   | Indicador de progreso, UI parcialmente interactiva |
| **Success** | Operación completada | Feedback positivo, transición a siguiente estado   |
| **Error**   | Operación fallida    | Mensaje de error, opciones de recuperación         |

---

### 6.3 Separación Estado Visual vs Estado de Negocio

| Concepto          | Pertenece a | Ejemplo                                  |
| ----------------- | ----------- | ---------------------------------------- |
| Estado de negocio | Dominio     | `MaintenanceRecord.status = IN_PROGRESS` |
| Estado visual     | UI          | `isLoading = true`, `showError = true`   |

**Regla dura:**
El estado visual **refleja** el estado de negocio.
El estado visual **NO determina** el estado de negocio.

---

### 6.4 Persistencia y Estado Local [REGLA DURA]

La UI **NO** tiene autoridad sobre persistencia ni almacenamiento.

**La UI:**

- ❌ NO decide qué se persiste localmente.
- ❌ NO guarda verdad de negocio en memoria, cache o storage local.
- ❌ NO usa mecanismos locales (SharedPreferences, LocalStorage, SQLite, etc.) como fuente autoritativa de datos de negocio.
- ❌ NO mantiene estado de negocio entre sesiones de forma independiente.

**La persistencia es responsabilidad EXCLUSIVA de:**

- Application Layer
- Dominio
- Infraestructura

**Regla dura:**
Si la UI necesita "recordar" algo, debe solicitarlo al Application Layer, quien decide si persiste y cómo.

**Excepciones permitidas (solo estado visual):**

- Preferencias de UI (tema, idioma seleccionado).
- Estado de navegación transitorio.
- Cache de renderizado (no de negocio).

---

## 7. CONTRATO DE CONECTIVIDAD & OFFLINE [CRÍTICO PARA MOBILE]

### 7.1 Principio Fundamental

Avanzza 2.0 es una aplicación **offline-first**.
La ausencia de conectividad **NO debe impedir** la operación del usuario.

### 7.2 Estados de Sincronización

| Estado           | Definición                           | Indicador Visual                |
| ---------------- | ------------------------------------ | ------------------------------- |
| **Synced**       | Datos sincronizados con servidor     | Ninguno (estado por defecto)    |
| **Stale**        | Datos potencialmente desactualizados | Indicador sutil, no bloqueante  |
| **Pending Sync** | Cambios locales pendientes de envío  | Badge o indicador de pendientes |
| **Sync Error**   | Fallo en sincronización              | Indicador de error con retry    |

> **Nota de Gobernanza:**
> La representación visual de estados `Stale`, `Pending Sync` o `Sync Error` > **NO implica bloqueo automático de acciones**.
>
> Cualquier restricción funcional **DEBE** provenir del Dominio o Application Layer
> y ser reflejada explícitamente en el estado consumido por la UI.

---

### 7.3 Optimistic UI [REGLA DURA]

La UI **DEBE** reaccionar inmediatamente al input del usuario.

**Flujo obligatorio:**

1. Usuario realiza acción.
2. UI refleja cambio **inmediatamente** (optimistic update).
3. Operación se envía al Dominio/Backend.
4. Si éxito: estado se confirma.
5. Si fallo: UI **revierte** y muestra error.

**Prohibido:**

- ❌ Bloquear UI esperando respuesta del servidor.
- ❌ Mostrar spinner bloqueante para operaciones no críticas.
- ❌ Impedir navegación durante sincronización.

---

### 7.4 No Spinners of Death [REGLA DURA]

**Prohibido** bloquear navegación completa por cargas no críticas.

| Tipo de Carga                      | Comportamiento Permitido                                         |
| ---------------------------------- | ---------------------------------------------------------------- |
| Crítica (sin datos no hay sentido) | Spinner de pantalla completa, máximo 3 segundos antes de timeout |
| No crítica (datos complementarios) | Skeleton o placeholder, UI navegable                             |
| Background (sincronización)        | Indicador sutil, UI completamente funcional                      |

---

### 7.5 Manejo de Conflictos

Cuando existan cambios locales en conflicto con cambios remotos:

1. **Notificar** al usuario del conflicto.
2. **Presentar** opciones claras (mantener local, aceptar remoto, fusionar).
3. **Delegar** resolución al Dominio si aplica lógica de negocio.

**Prohibido:**

- ❌ Resolver conflictos silenciosamente.
- ❌ Perder datos del usuario sin confirmación.

---

## 8. CONTRATO DE NAVEGACIÓN & PERMISOS

### 8.1 Fuente de Verdad para Permisos

Los permisos de navegación y acceso provienen de:

- **Workspace State** (estado del workspace activo).
- **IAM** (roles y permisos del usuario).

**La UI NO decide permisos.** Solo los refleja.

---

### 8.2 Estados de Elementos según Permisos

| Estado                      | Cuándo Aplicar                        | Comportamiento                             |
| --------------------------- | ------------------------------------- | ------------------------------------------ |
| **Visible + Habilitado**    | Usuario tiene permiso completo        | Interacción normal                         |
| **Visible + Deshabilitado** | Usuario puede ver pero no actuar      | Mostrar, deshabilitar, tooltip explicativo |
| **Oculto**                  | Usuario no debe conocer la existencia | No renderizar                              |

**Regla dura:**
La decisión entre ocultar o deshabilitar proviene del **Workspace/IAM**, no de lógica en la UI.

---

### 8.3 Navegación Condicional

**Prohibido:**

- ❌ Hardcodear rutas permitidas en la UI.
- ❌ Evaluar permisos con lógica local.

**Obligatorio:**

- ✅ Consultar estado de permisos desde fuente autoritativa.
- ✅ Redirigir a pantalla apropiada si acceso denegado.

---

### 8.4 Navegación ≠ Orquestación de Negocio [REGLA DURA]

La navegación en la UI es un **reflejo de estados**, no un **orquestador de flujos**.

**La UI:**

- ❌ NO orquesta flujos de negocio multi-paso.
- ❌ NO ejecuta procesos secuenciales con lógica condicional de negocio.
- ❌ NO decide "qué pantalla sigue" basándose en reglas de dominio.
- ❌ NO implementa wizards o flujos cuya secuencia dependa de invariantes de negocio.

**La navegación:**

- ✅ Solo refleja estados ya resueltos por el Dominio o Application Layer.
- ✅ Responde a comandos de navegación emitidos por capas superiores.
- ✅ Puede gestionar transiciones visuales y animaciones.

**Antipatrón prohibido:**

```
❌ INCORRECTO (lógica de negocio en navegación):

if (order.status == PENDING && order.total > 1000) {
  navigateTo(ApprovalScreen);
} else if (order.requiresSignature) {
  navigateTo(SignatureScreen);
} else {
  navigateTo(ConfirmationScreen);
}
```

**Patrón correcto:**

```
✅ CORRECTO (UI recibe instrucción de navegación):

// El Application Layer determina el destino y emite:
NavigationCommand(destination: nextScreen)

// La UI solo ejecuta:
navigateTo(command.destination);
```

**Regla dura:**
Si la navegación requiere evaluar condiciones de negocio, esa evaluación **DEBE** ocurrir en el Application Layer o Dominio, y la UI solo recibe el resultado.

---

## 9. CONTRATO DE FEEDBACK AL USUARIO

### 9.1 Clasificación de Mensajes

| Tipo                 | Propósito                         | Ejemplo                                     |
| -------------------- | --------------------------------- | ------------------------------------------- |
| **Error Bloqueante** | Impide continuar, requiere acción | "No se pudo guardar. Verifica tu conexión." |
| **Advertencia**      | Alerta sin bloquear               | "Cambios pendientes de sincronizar."        |
| **Información**      | Confirma acción o informa estado  | "Mantenimiento guardado correctamente."     |
| **Éxito**            | Confirma operación completada     | "Pago registrado."                          |

---

### 9.2 Lenguaje de Usuario [REGLA DURA]

Todo mensaje **DEBE** usar lenguaje comprensible para el usuario final.

**Prohibido:**

- ❌ Mostrar excepciones técnicas.
- ❌ Mostrar stack traces.
- ❌ Mostrar códigos de error internos sin traducción.
- ❌ Mostrar mensajes en inglés técnico a usuarios hispanohablantes (o viceversa).

**Ejemplos:**

- ✅ "No pudimos conectar con el servidor. Intenta de nuevo."
- ❌ "NullPointerException at line 234"
- ❌ "Error 500: Internal Server Error"
- ❌ "SQLITE_CONSTRAINT_UNIQUE"

---

### 9.3 Acciones de Recuperación

Todo error **DEBE** ofrecer al menos una acción de recuperación cuando sea posible:

- Reintentar
- Cancelar
- Contactar soporte
- Volver a pantalla anterior

---

## 10. REGLAS PARA IA (STRICT MODE) [CRÍTICO]

Toda IA que genere código de UI para Avanzza 2.0 **DEBE** seguir este protocolo:

### 10.1 Execution Summary (Obligatorio)

Antes de generar código de UI, la IA **DEBE** declarar:

- **Pantalla/Componente:** [nombre]
- **Datos de Dominio consumidos:** [entidades, value objects]
- **Eventos/Intenciones despachados:** [lista]
- **Validaciones de formato aplicadas:** [lista]
- **Estados visuales manejados:** [loading, error, empty, etc.]
- **Fuente de Estado:** Declarar si el estado consumido por la UI proviene de:
  - Dominio confirmado
  - Cache local no autoritativa
  - Sincronización en progreso

**Regla:** La UI **NO puede inferir** esta fuente. Debe ser declarada por la capa que provee el estado.

---

### 10.2 Verificaciones Obligatorias

La IA **DEBE** verificar antes de generar:

| Verificación             | Pregunta                                             |
| ------------------------ | ---------------------------------------------------- |
| Dumb View                | ¿El widget solo renderiza y despacha?                |
| No Business Logic        | ¿Hay condicionales de negocio en la UI?              |
| Type Rendering           | ¿Los Value Objects usan componentes especializados?  |
| i18n Compliance          | ¿Todo texto proviene de l10n?                        |
| Testability              | ¿Hay Keys/semantic labels en elementos interactivos? |
| Specialized Inputs       | ¿MonetaryAmount usa MoneyInput?                      |
| No Local Persistence     | ¿La UI evita persistir estado de negocio?            |
| Navigation as Reflection | ¿La navegación solo refleja estados, sin orquestar?  |

---

### 10.3 Stop & Report

Si la IA detecta que el requerimiento viola este contrato, **DEBE**:

1. 👉 **Detener generación.**
2. 👉 **Reportar violación específica.**
3. 👉 **Proponer alternativa correcta.**

**Formato:**

> 🛑 **VIOLACIÓN DE UI_CONTRACTS.md**
>
> - **Sección violada:** [número y título]
> - **Problema:** [descripción]
>
> ✅ **Alternativa correcta:** [propuesta]

---

### 10.4 Ejemplos de Stop & Report

**Solicitud:** "Agrega un if para mostrar descuento si el monto es mayor a $1000"

> 🛑 **VIOLACIÓN DE UI_CONTRACTS.md**
>
> - **Sección violada:** 3.1 UI is Dumb
> - **Problema:** La lógica de descuento es regla de negocio, no puede evaluarse en UI.
>
> ✅ **Alternativa correcta:** El Dominio debe calcular y exponer `hasDiscount: boolean` y `discountAmount: MonetaryAmount`. La UI solo renderiza estos valores.

---

**Solicitud:** "Muestra el precio como un número con 2 decimales"

> 🛑 **VIOLACIÓN DE UI_CONTRACTS.md**
>
> - **Sección violada:** 4.2 MonetaryAmount
> - **Problema:** Mostrar MonetaryAmount como número crudo viola el contrato de visualización.
>
> ✅ **Alternativa correcta:** Usar componente de visualización de moneda que incluya símbolo, formato según locale y código de divisa.

---

**Solicitud:** "Guarda el carrito en localStorage para que persista entre sesiones"

> 🛑 **VIOLACIÓN DE UI_CONTRACTS.md**
>
> - **Sección violada:** 6.4 Persistencia y Estado Local
> - **Problema:** La UI no puede decidir persistencia de datos de negocio (carrito).
>
> ✅ **Alternativa correcta:** El Application Layer debe manejar la persistencia del carrito. La UI solo consume el estado del carrito desde el Dominio.

---

## 11. ANTIPATRONES PROHIBIDOS

### 11.1 Lista Explícita de Antipatrones

| Antipatrón                      | Descripción                                  | Violación   |
| ------------------------------- | -------------------------------------------- | ----------- |
| **Business Logic in Widget**    | `if (order.total > 1000) showDiscount()`     | Sección 3.1 |
| **Raw Money Display**           | `Text('${amount}')`                          | Sección 4.2 |
| **Hardcoded Strings**           | `Text('Guardar')`                            | Sección 3.4 |
| **Missing Keys**                | Botones sin Key ni semantic label            | Sección 3.5 |
| **Blocking Spinners**           | Spinner fullscreen para carga no crítica     | Sección 7.4 |
| **Technical Errors**            | `Text(exception.toString())`                 | Sección 9.2 |
| **UI as Source of Truth**       | Mantener estado de negocio en StatefulWidget | Sección 3.2 |
| **Direct API Calls**            | `http.post()` desde un widget                | Sección 5.3 |
| **Permission Logic in UI**      | `if (user.role == 'admin') showButton()`     | Sección 8.1 |
| **Silent Conflict Resolution**  | Sobrescribir datos sin notificar             | Sección 7.5 |
| **Generic TextField for Money** | `TextField()` para capturar montos           | Sección 5.2 |
| **Raw Date Display**            | `Text(date.toIso8601String())`               | Sección 4.4 |
| **Local Business Persistence**  | `localStorage.set('cart', cartData)`         | Sección 6.4 |
| **Navigation as Orchestrator**  | Decidir flujo multi-paso con ifs en UI       | Sección 8.4 |

---

### 11.2 Consecuencias de Violación

Código que contenga antipatrones prohibidos:

- **NO debe pasar code review.**
- **NO debe desplegarse a producción.**
- **DEBE ser corregido antes de merge.**

---

## 12. VERSIONADO DEL CONTRATO

### 12.1 Reglas de Modificación

Toda modificación a este documento **DEBE**:

1. **Incrementar versión semántica:**

   - **PATCH (0.0.X):** Correcciones de redacción, clarificaciones sin cambio de reglas.
   - **MINOR (0.X.0):** Nuevas reglas que no rompen contratos existentes.
   - **MAJOR (X.0.0):** Cambios que rompen compatibilidad con implementaciones existentes.

2. **Auditar contra DOMAIN_CONTRACTS.md:**

   - Verificar que no se contradigan reglas de dominio.
   - Verificar que no se amplíen responsabilidades de la UI indebidamente.

3. **Documentar cambios:**
   - Incluir changelog en commit.
   - Referenciar secciones modificadas.

### 12.2 Retrocompatibilidad

**Regla dura:**
No se pueden romper contratos existentes sin incremento de versión **MAJOR** y aprobación explícita en GOVERNANCE_CORE.md.

Las implementaciones existentes que cumplan versiones anteriores **DEBEN** seguir siendo válidas hasta migración planificada.

---

**FIN DE UI_CONTRACTS.md — v1.0.2**

**HASH DE INTEGRIDAD:** [Reservado para CI/CD]
