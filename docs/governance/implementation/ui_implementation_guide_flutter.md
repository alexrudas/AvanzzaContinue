# UI_IMPLEMENTATION_GUIDE_FLUTTER.md

## Avanzza 2.0 — Guía de Implementación UI para Flutter

> **TIPO:** Guía de Implementación Operativa
> **VERSIÓN:** 1.0.1
> **SUBORDINADO A:** UI_CONTRACTS.md (v1.0.2)
> **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO

Traducir UI_CONTRACTS.md a reglas operativas para Flutter.
Este documento NO redefine contratos. Solo indica CÓMO cumplirlos en Flutter.

---

## 2. STATE MANAGEMENT CANÓNICO

### 2.1 Solución Única Definida

| Aspecto | Definición |
|---------|------------|
| **State Management** | GetX |
| **Dependency Injection** | GetX (`Get.put`, `Get.lazyPut`, `Get.find`) |
| **Routing** | GetX (`Get.to`, `Get.toNamed`, `Get.off`) |
| **Fuente Única de Estado** | `GetxController` — NUNCA el Widget |

> **Ref:** UI_CONTRACTS.md §3.2 (Single Source of Truth)

### 2.2 Reglas de State Management

| DO | DON'T |
|----|-------|
| Consumir estado desde `GetxController` | Crear estado en StatefulWidget |
| Despachar eventos al Controller | Ejecutar lógica en `onPressed` |
| Usar `Obx`, `GetBuilder`, `GetX<T>` | Usar `setState()` |
| Estado reactivo con `.obs` | Variables locales en Widget |

### 2.3 Prohibición Absoluta: `setState()`

| Uso | Permitido |
|-----|-----------|
| `setState()` para cualquier propósito | ❌ PROHIBIDO SIN EXCEPCIONES |

**Instrucción operativa:**
- Para toggles, checkboxes o cambios visuales locales: usar `RxBool` en Controller + `Obx`.
- Para animaciones: usar `GetxController` con `GetSingleTickerProviderStateMixin`.
- Justificación: Trazabilidad consistente de todo cambio de estado.

> **Ref:** UI_CONTRACTS.md §3.1 (UI is Dumb), §6.4 (Persistencia y Estado Local)

---

## 3. SEPARACIÓN UI vs DOMINIO

### 3.1 Estructura de Archivos (ILUSTRATIVA / REFERENCIA)

> **Nota:** Esta estructura es referencia arquitectónica basada en GOVERNANCE_CORE.md §4.
> NO es regla dura de UI_CONTRACTS.md.

```
lib/
├── presentation/
│   ├── pages/           # Pantallas (solo rendering)
│   ├── widgets/         # Componentes reutilizables (dumb)
│   └── controllers/     # GetxControllers
│
├── domain/
│   ├── entities/        # Entidades puras
│   ├── use_cases/       # Lógica de aplicación
│   └── repositories/    # Interfaces
│
└── data/
    ├── repositories/    # Implementaciones
    └── dtos/            # Data Transfer Objects
```

### 3.2 Reglas de Dependencia

| Capa | Puede importar | NO puede importar |
|------|----------------|-------------------|
| `presentation/pages/` | `presentation/widgets/`, `presentation/controllers/` | `domain/`, `data/` directamente |
| `presentation/controllers/` | `domain/use_cases/`, `domain/entities/` | `data/`, `package:http`, Firebase |
| `presentation/widgets/` | Solo parámetros recibidos | Cualquier otra capa |

### 3.3 Flujo de Datos Obligatorio

```
Widget → GetxController → UseCase → Repository → DataSource
   ↑                                                    ↓
   └──────────── Estado reactivo (.obs) ←───────────────┘
```

---

## 4. WIDGETS: REGLAS OPERATIVAS

### 4.1 Anatomía de un Widget Válido

| Componente | Obligatorio | Descripción |
|------------|-------------|-------------|
| `Key` | ✅ SÍ | Único para elementos interactivos |
| Semantic Label | ✅ SÍ | Para accesibilidad y testing |
| Props tipadas | ✅ SÍ | Nunca `dynamic` |
| Callbacks tipados | ✅ SÍ | `VoidCallback`, `ValueChanged<T>` |

> **Ref:** UI_CONTRACTS.md §3.5 (Testability First)

### 4.2 Widgets Especializados Obligatorios

| Widget Nativo | Widget Avanzza | Regla |
|---------------|----------------|-------|
| `ElevatedButton` | `AvanzzaButton` | ❌ Nativo PROHIBIDO si existe especializado |
| `TextField` | `AvanzzaTextField` | ❌ Nativo PROHIBIDO si existe especializado |
| `Text` para dinero | `MoneyDisplay` | ❌ Text PROHIBIDO para MonetaryAmount |
| `Text` para fechas | `DateDisplay` | ❌ Text PROHIBIDO para DateTime |

**Regla dura:**
Si existe un Widget de Diseño Avanzza para un caso de uso, está **PROHIBIDO** usar el widget nativo de Flutter.
Violación = Rechazo de PR.

### 4.3 DO / DON'T para Widgets

| DO | DON'T |
|----|-------|
| Recibir datos como parámetros | Obtener datos de servicios |
| Despachar callbacks | Ejecutar lógica de negocio |
| Usar `const` constructors | Crear widgets sin `const` |
| Declarar `Key` explícita | Omitir Keys en listas |
| Usar widgets Avanzza especializados | Usar widgets nativos si existe alternativa |

### 4.4 Prohibiciones en Widgets

| Patrón | Sección Violada |
|--------|-----------------|
| `if (amount > 1000)` en build() | §3.1 UI is Dumb |
| `http.get()` en Widget | §5.3 Despacho de Acciones |
| `SharedPreferences.get()` en Widget | §6.4 Persistencia Local |
| `Text('Guardar')` literal | §3.4 No Hardcoded Strings |
| `Text(date.toIso8601String())` | §4.4 Fechas y Timestamps |
| `setState()` | §3.1, §6.4 — PROHIBIDO SIN EXCEPCIONES |

---

## 5. INTERNACIONALIZACIÓN (i18n)

### 5.1 Configuración Obligatoria

| Aspecto | Requerimiento |
|---------|---------------|
| Paquete | `flutter_localizations` + `intl` |
| Archivos | `lib/l10n/*.arb` |
| Acceso | `AppLocalizations.of(context)` o equivalente |

### 5.2 Reglas de Uso

| DO | DON'T |
|----|-------|
| `l10n.saveButton` | `'Guardar'` |
| `l10n.errorMessage(code)` | `'Error: $code'` |
| Enums → `l10n.statusInProgress` | `status.name` |

> **Ref:** UI_CONTRACTS.md §3.4 (No Hardcoded Strings)

---

## 6. INPUTS ESPECIALIZADOS

### 6.1 Mapeo Obligatorio

| Tipo de Dato | Widget Requerido | TextField Genérico |
|--------------|------------------|---------------------|
| `MonetaryAmount` | `MoneyInputField` | ❌ PROHIBIDO |
| `int`, `double` | `NumberInputField` | ❌ PROHIBIDO |
| `DateTime` | `DatePickerField` | ❌ PROHIBIDO |
| `Enum` | `DropdownField<T>` | ❌ PROHIBIDO |
| `String` libre | `AvanzzaTextField` | ✅ Permitido |

> **Ref:** UI_CONTRACTS.md §5.2 (Inputs Especializados Obligatorios)

### 6.2 MoneyInputField: Requisitos Mínimos

| Requisito | Obligatorio |
|-----------|-------------|
| Campo separado para monto | ✅ SÍ |
| Campo separado para moneda | ✅ SÍ |
| Máscara de formato numérico | ✅ SÍ |
| Bloqueo de caracteres no numéricos | ✅ SÍ |
| Retorno de `MonetaryAmount` tipado | ✅ SÍ |

---

## 7. VALIDACIÓN EN UI

### 7.1 Validaciones Permitidas (Formato)

| Validación | Ejemplo | Permitido |
|------------|---------|-----------|
| Email bien formado | `RegExp(emailPattern)` | ✅ SÍ |
| Longitud mínima/máxima | `value.length >= 8` | ✅ SÍ |
| Solo números | `int.tryParse(value)` | ✅ SÍ |
| Campo requerido | `value.isNotEmpty` | ✅ SÍ |

### 7.2 Validaciones Prohibidas (Negocio)

| Validación | Razón | Dónde debe estar |
|------------|-------|------------------|
| Email único | Requiere consulta a Dominio | UseCase |
| Monto > límite de negocio | Regla de negocio | Dominio |
| Transición de estado válida | State Machine | Dominio |
| Permisos de usuario | IAM/Workspace | Controller |

> **Ref:** UI_CONTRACTS.md §5.1 (Validación de Formato vs Invariantes)

---

## 8. ESTADOS VISUALES

### 8.1 Estados Obligatorios por Pantalla

| Estado | Widget/Pattern | Obligatorio |
|--------|----------------|-------------|
| Loading | Skeleton, `AvanzzaLoader` | ✅ SÍ |
| Empty | `EmptyStateWidget` con CTA | ✅ SÍ |
| Error | `ErrorWidget` con acción de recuperación | ✅ SÍ |
| Success | Contenido + feedback opcional | ✅ SÍ |

> **Ref:** UI_CONTRACTS.md §6.1, §6.2 (Estados de Datos y Ciclo de Vida)

### 8.2 Patrón de Implementación con GetX

```
// Estructura conceptual
controller.state.obs → Obx(() {
  switch (controller.state.value) {
    case Loading → AvanzzaLoader
    case Empty → EmptyState(action: controller.retry)
    case Error → ErrorState(message: l10n.error, action: controller.retry)
    case Success → ContentWidget(data: controller.data)
  }
})
```

---

## 9. NAVEGACIÓN

### 9.1 Reglas de Navegación

| DO | DON'T |
|----|-------|
| Recibir destino desde Controller | Calcular destino con `if` en Widget |
| Usar `Get.toNamed()` con rutas nombradas | Hardcodear strings de ruta |
| Validar permisos en Controller | Validar permisos en Widget |

### 9.2 Flujo de Navegación

```
Controller evalúa estado → Emite comando de navegación → Get.toNamed(route)
```

> **Ref:** UI_CONTRACTS.md §8.4 (Navegación ≠ Orquestación)

---

## 10. OFFLINE & SYNC — FEEDBACK VISUAL

> **Alcance:** Esta sección SOLO define representación visual.
> La lógica de sync (queues, retries, optimistic updates, databases) está en UI_OFFLINE_SYNC_GUIDE.md.

### 10.1 Representación Visual de Estados de Sincronización

| Estado | Representación Visual |
|--------|----------------------|
| **Synced** | Sin indicador (estado por defecto) |
| **Stale** | Opacidad reducida (0.6), borde gris punteado, tooltip "Datos desactualizados" |
| **Pending Sync** | Icono de nube con flecha ↑, badge numérico si múltiples pendientes |
| **Sync Error** | Icono de alerta rojo, tooltip con mensaje de error, botón retry visible |

### 10.2 Reglas de Feedback Visual

| Regla | Obligatorio |
|-------|-------------|
| Indicadores NO bloquean interacción | ✅ SÍ |
| Indicadores son sutiles, no modales | ✅ SÍ |
| Error de sync muestra acción de retry | ✅ SÍ |
| Tooltip explica estado al usuario | ✅ SÍ |

> **Ref:** UI_CONTRACTS.md §7.2 (Estados de Sincronización)

---

## 11. TESTING

### 11.1 Requisitos de Testabilidad

| Requisito | Implementación |
|-----------|----------------|
| Elementos con Key | `Key('save_button')` |
| Semantic labels | `Semantics(label: 'Save')` |
| Widgets puros | Sin side effects en build |
| Controllers mockeables | `Get.put()` con mocks en tests |

### 11.2 Patrones de Test

| Tipo | Qué testea | Dónde |
|------|------------|-------|
| Widget Test | Rendering correcto | `test/presentation/widgets/` |
| Integration Test | Flujo completo | `integration_test/` |
| Controller Test | Lógica de estado | `test/presentation/controllers/` |

---

## 12. CHECKLIST DE CUMPLIMIENTO

### Pre-Commit Obligatorio

| Verificación | Pasa |
|--------------|------|
| ¿Widgets sin lógica de negocio? | ☐ |
| ¿State Management exclusivamente en GetxController? | ☐ |
| ¿Cero uso de `setState()`? | ☐ |
| ¿Todos los strings desde l10n? | ☐ |
| ¿Inputs especializados para tipos complejos? | ☐ |
| ¿Widgets Avanzza en lugar de nativos donde aplique? | ☐ |
| ¿Keys en elementos interactivos? | ☐ |
| ¿Estados visuales (loading/error/empty) manejados? | ☐ |
| ¿Navegación sin lógica de negocio? | ☐ |

---

## 13. MAPEO A UI_CONTRACTS.md

| Sección de esta Guía | Sección de UI_CONTRACTS.md |
|----------------------|----------------------------|
| §2 State Management | §3.1, §3.2, §6.4 |
| §3 Separación UI/Dominio | §1.1, §3.3 |
| §4 Widgets | §3.1, §3.5 |
| §5 i18n | §3.4 |
| §6 Inputs | §5.2 |
| §7 Validación | §5.1 |
| §8 Estados Visuales | §6.1, §6.2 |
| §9 Navegación | §8.4 |
| §10 Offline (Visual) | §7.2 |

---

**FIN DE UI_IMPLEMENTATION_GUIDE_FLUTTER.md — v1.0.1**
