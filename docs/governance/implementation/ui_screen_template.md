# UI_SCREEN_TEMPLATE.md

## Avanzza 2.0 — Template de Pantalla UI

> **TIPO:** Template de Implementación
> **VERSIÓN:** 1.0.1
> **SUBORDINADO A:** UI_CONTRACTS.md (v1.0.2)
> **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO

Definir la estructura obligatoria para toda pantalla (Page/Screen) en Avanzza 2.0.
Este template asegura cumplimiento de UI_CONTRACTS.md desde el diseño.

---

## 2. ESTRUCTURA OBLIGATORIA DE ARCHIVO

### 2.1 Orden de Secciones en el Archivo

```
1. Imports
2. Constantes de Keys (si aplica)
3. Page Widget (StatelessWidget)
4. Secciones del Body (widgets privados)
```

### 2.2 Regla de Naming

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Page | `[Feature]Page` | `AssetListPage` |
| Controller | `[Feature]Controller` | `AssetListController` |
| Binding | `[Feature]Binding` | `AssetListBinding` |

---

## 3. BINDING OBLIGATORIO [CRÍTICO]

### 3.1 Regla de Lifecycle

El lifecycle del Controller **NO pertenece a la UI**.
El Controller DEBE ser registrado y gestionado por un Binding.

### 3.2 Estructura de Binding Obligatoria

```dart
class [Feature]Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<[Feature]Controller>(() => [Feature]Controller(
      // Inyección de dependencias aquí
    ));
  }
}
```

### 3.3 Registro en Rutas

```dart
GetPage(
  name: Routes.FEATURE,
  page: () => const [Feature]Page(),
  binding: [Feature]Binding(),
)
```

### 3.4 Prohibiciones de Instanciación [REGLA DURA]

| Patrón | Permitido | Razón |
|--------|-----------|-------|
| `Get.put()` en `build()` | ❌ PROHIBIDO | Lifecycle fuera de UI |
| `Get.put()` en Page | ❌ PROHIBIDO | Lifecycle fuera de UI |
| Instanciar Controller en Page | ❌ PROHIBIDO | Lifecycle fuera de UI |
| `Get.find()` sin Binding previo | ❌ PROHIBIDO | Dependencia no garantizada |
| Controller registrado en Binding | ✅ OBLIGATORIO | Único patrón válido |

---

## 4. DECLARACIÓN DE PANTALLA (HEADER)

Toda pantalla DEBE incluir un bloque de documentación al inicio:

```dart
/// ══════════════════════════════════════════════════════════════════════════
/// SCREEN: [NombrePantalla]
/// ══════════════════════════════════════════════════════════════════════════
///
/// DOMINIO: [Assets | Maintenance | Accounting | Purchases | Insurance | IAM]
///
/// DATOS CONSUMIDOS:
///   - [Entidad1] (fuente: Controller)
///   - [Entidad2] (fuente: Controller)
///
/// FUENTE DE ESTADO: [NombreController] via GetX
///
/// EVENTOS DESPACHADOS:
///   - [onSave] → Controller.saveAsset()
///   - [onDelete] → Controller.deleteAsset()
///
/// ESTADOS VISUALES MANEJADOS:
///   - [x] Loading
///   - [x] Empty
///   - [x] Error
///   - [x] Success
///
/// ESTADO DE SYNC MANEJADO:
///   - [x] Synced
///   - [x] Stale
///   - [x] Pending Sync
///   - [x] Sync Error
///
/// REF: UI_CONTRACTS.md §10.1
/// ══════════════════════════════════════════════════════════════════════════
```

---

## 5. REACTIVIDAD: GetBuilder vs Obx [CRÍTICO]

### 5.1 Regla de Uso Obligatoria

| Widget Reactivo | Uso Permitido | Uso Prohibido |
|-----------------|---------------|---------------|
| `GetBuilder<T>` | Rebuild estructural (Scaffold, AppBar, layout completo) | Reaccionar a variables `.obs` |
| `Obx` | Estado dinámico (variables `.obs`) | Rebuild de estructuras completas |

### 5.2 Criterio de Selección

| Escenario | Widget Obligatorio |
|-----------|-------------------|
| Contenedor principal de la Page | `GetBuilder` |
| Mostrar/ocultar elementos según estado | `Obx` |
| Actualizar texto, badge, indicador | `Obx` |
| Cambiar AppBar completo según modo | `GetBuilder` |
| Lista que reacciona a items.obs | `Obx` |

### 5.3 Prohibiciones [REGLA DURA]

| Patrón | Permitido |
|--------|-----------|
| Usar `GetBuilder` para reaccionar a `.obs` | ❌ PROHIBIDO |
| Usar `Obx` para rebuild estructural completo | ❌ PROHIBIDO |
| Mezclar `GetBuilder` y `Obx` sin criterio definido | ❌ PROHIBIDO |
| `Obx` anidado dentro de `GetBuilder` para estado dinámico | ✅ PERMITIDO |

### 5.4 Patrón Correcto

```dart
// ✅ CORRECTO: GetBuilder para estructura, Obx para estado dinámico
GetBuilder<FeatureController>(
  builder: (controller) => Scaffold(
    appBar: AppBar(
      title: Text(l10n.featureTitle),
      actions: [
        // Obx para indicador dinámico
        Obx(() => SyncStatusIndicator(status: controller.syncStatus.value)),
      ],
    ),
    body: Obx(() {
      // Obx para contenido que cambia con estado
      if (controller.isLoading.value) return _buildLoading();
      return _buildContent(controller);
    }),
  ),
);
```

---

## 6. ESTRUCTURA DEL PAGE WIDGET

### 6.1 Template Base

```dart
class [Feature]Page extends StatelessWidget {
  const [Feature]Page({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<[Feature]Controller>(
      builder: (controller) {
        return Scaffold(
          key: const Key('[feature]_page_scaffold'),
          appBar: _buildAppBar(context, controller),
          body: _buildBody(context, controller),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SECCIONES PRIVADAS
  // ══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context, [Feature]Controller controller) {
    // ...
  }

  Widget _buildBody(BuildContext context, [Feature]Controller controller) {
    // Manejo de estados obligatorio con Obx
    return Obx(() {
      if (controller.isLoading.value) return _buildLoading();
      if (controller.hasError.value) return _buildError(context, controller);
      if (controller.isEmpty.value) return _buildEmpty(context, controller);
      return _buildContent(context, controller);
    });
  }

  Widget _buildLoading() { /* ... */ }
  Widget _buildError(BuildContext context, [Feature]Controller controller) { /* ... */ }
  Widget _buildEmpty(BuildContext context, [Feature]Controller controller) { /* ... */ }
  Widget _buildContent(BuildContext context, [Feature]Controller controller) { /* ... */ }
}
```

---

## 7. REGLAS DE DECLARACIÓN

### 7.1 Elementos OBLIGATORIOS

| Elemento | Obligatorio | Ref |
|----------|-------------|-----|
| `StatelessWidget` (no StatefulWidget) | ✅ SÍ | §3.1, §6.4 |
| `Binding` asociado | ✅ SÍ | §3 (este documento) |
| `Key` en Scaffold | ✅ SÍ | §3.5 |
| `Key` en elementos interactivos | ✅ SÍ | §3.5 |
| Manejo de Loading state | ✅ SÍ | §6.2 |
| Manejo de Empty state | ✅ SÍ | §6.1 |
| Manejo de Error state | ✅ SÍ | §6.2 |
| Textos desde l10n | ✅ SÍ | §3.4 |
| GetBuilder para estructura + Obx para estado | ✅ SÍ | §5 (este documento) |

### 7.2 Elementos PROHIBIDOS

| Elemento | Permitido | Ref |
|----------|-----------|-----|
| `StatefulWidget` | ❌ NO | §3.1, §6.4 |
| `setState()` | ❌ NO | §3.1 |
| Variables de estado locales | ❌ NO | §3.2 |
| Lógica de negocio en build | ❌ NO | §3.1 |
| Llamadas a API/Repository | ❌ NO | §5.3 |
| Hardcoded strings | ❌ NO | §3.4 |
| `if (businessCondition)` | ❌ NO | §3.1 |
| Navegación con lógica de negocio | ❌ NO | §8.4 |
| `Get.put()` en Page | ❌ NO | §3 (este documento) |

---

## 8. ESTADO DE SYNC POR ELEMENTO [CRÍTICO]

### 8.1 Fuente de Verdad

El estado de sincronización por elemento:
- **DEBE** ser expuesto por el Controller o ViewModel
- **NO DEBE** leerse directamente desde entidades de dominio
- **NO DEBE** inferirse en la UI

### 8.2 Patrón Obligatorio

```dart
// ✅ CORRECTO: Estado de sync expuesto por Controller
class ItemViewModel {
  final String id;
  final String name;
  final SyncStatus syncStatus; // Expuesto explícitamente
}

// En el Controller:
final RxList<ItemViewModel> items = <ItemViewModel>[].obs;

// En la UI:
Obx(() => ListView.builder(
  itemCount: controller.items.length,
  itemBuilder: (context, index) {
    final item = controller.items[index];
    return ListTile(
      title: Text(item.name),
      trailing: SyncStatusIndicator(status: item.syncStatus), // Del ViewModel
    );
  },
));
```

### 8.3 Prohibiciones

| Patrón | Permitido | Razón |
|--------|-----------|-------|
| `item.entity.syncStatus` (acceso directo a dominio) | ❌ PROHIBIDO | UI no lee dominio |
| Inferir sync status en UI | ❌ PROHIBIDO | UI no calcula estado |
| `item.syncStatus` (expuesto por Controller) | ✅ OBLIGATORIO | Fuente única de verdad |

> **Ref:** UI_OFFLINE_SYNC_GUIDE.md §3.2

---

## 9. MANEJO DE ESTADOS VISUALES

### 9.1 Template de Loading State

```dart
Widget _buildLoading() {
  return const Center(
    key: Key('[feature]_loading_indicator'),
    child: AvanzzaLoader(), // Widget especializado
  );
}
```

### 9.2 Template de Empty State

```dart
Widget _buildEmpty(BuildContext context, [Feature]Controller controller) {
  final l10n = AppLocalizations.of(context);
  return EmptyStateWidget(
    key: const Key('[feature]_empty_state'),
    message: l10n.featureEmptyMessage,
    actionLabel: l10n.featureEmptyAction,
    onAction: controller.onRefresh,
  );
}
```

### 9.3 Template de Error State

```dart
Widget _buildError(BuildContext context, [Feature]Controller controller) {
  final l10n = AppLocalizations.of(context);
  return ErrorStateWidget(
    key: const Key('[feature]_error_state'),
    message: l10n.featureErrorMessage,
    onRetry: controller.onRetry,
  );
}
```

---

## 10. MANEJO DE ESTADOS DE SYNC

### 10.1 Indicador Global (AppBar)

```dart
PreferredSizeWidget _buildAppBar(BuildContext context, [Feature]Controller controller) {
  return AppBar(
    title: Text(AppLocalizations.of(context).featureTitle),
    actions: [
      Obx(() => SyncStatusIndicator(
        key: const Key('[feature]_sync_indicator'),
        status: controller.syncStatus.value,
      )),
    ],
  );
}
```

### 10.2 Indicador por Elemento

```dart
Widget _buildListItem(BuildContext context, ItemViewModel item) {
  return ListTile(
    key: Key('[feature]_item_${item.id}'),
    title: Text(item.name),
    trailing: SyncStatusIndicator(
      key: Key('[feature]_item_sync_${item.id}'),
      status: item.syncStatus, // Desde ViewModel, NO desde entidad
    ),
  );
}
```

---

## 11. RENDERIZADO DE VALUE OBJECTS

### 11.1 MonetaryAmount

```dart
// ✅ CORRECTO
MoneyDisplay(
  key: Key('[feature]_amount_${item.id}'),
  money: item.totalAmount,
)

// ❌ PROHIBIDO
Text('\$${item.totalAmount.amount}')
```

### 11.2 DateTime

```dart
// ✅ CORRECTO
DateDisplay(
  key: Key('[feature]_date_${item.id}'),
  date: item.createdAt,
  locale: Localizations.localeOf(context),
)

// ❌ PROHIBIDO
Text(item.createdAt.toString())
```

### 11.3 Enums

```dart
// ✅ CORRECTO
StatusBadge(
  key: Key('[feature]_status_${item.id}'),
  status: item.status,
  label: l10n.statusLabel(item.status),
)

// ❌ PROHIBIDO
Text(item.status.name)
```

---

## 12. INPUTS ESPECIALIZADOS

### 12.1 MoneyInput

```dart
MoneyInputField(
  key: const Key('[feature]_amount_input'),
  initialValue: controller.amount,
  onChanged: controller.onAmountChanged,
)
```

### 12.2 DatePicker

```dart
DatePickerField(
  key: const Key('[feature]_date_input'),
  initialValue: controller.selectedDate,
  onChanged: controller.onDateChanged,
)
```

### 12.3 Dropdown para Enums

```dart
DropdownField<MaintenanceType>(
  key: const Key('[feature]_type_dropdown'),
  value: controller.selectedType,
  items: MaintenanceType.values,
  labelBuilder: (type) => l10n.maintenanceTypeLabel(type),
  onChanged: controller.onTypeChanged,
)
```

---

## 13. DESPACHO DE ACCIONES

### 13.1 Patrón Correcto

```dart
// En el Widget:
AvanzzaButton(
  key: const Key('[feature]_save_button'),
  label: l10n.saveButton,
  onPressed: controller.onSave, // Despacha intención
)

// En el Controller:
void onSave() {
  // Controller maneja la lógica
  _saveUseCase.execute(currentData);
}
```

### 13.2 Patrón Prohibido

```dart
// ❌ PROHIBIDO: Lógica en Widget
AvanzzaButton(
  onPressed: () async {
    await repository.save(data); // Viola §5.3
    if (data.amount > 1000) {    // Viola §3.1
      Get.to(ApprovalPage());    // Viola §8.4
    }
  },
)
```

---

## 14. NAVEGACIÓN

### 14.1 Patrón Correcto

```dart
// Controller emite comando:
void onItemTap(String itemId) {
  final destination = _determineDestination(itemId); // Lógica en Controller
  Get.toNamed(destination, arguments: itemId);
}

// Widget solo ejecuta:
ListTile(
  onTap: () => controller.onItemTap(item.id),
)
```

### 14.2 Patrón Prohibido

```dart
// ❌ PROHIBIDO: Lógica de navegación en Widget
ListTile(
  onTap: () {
    if (item.status == Status.pending && item.amount > 1000) {
      Get.to(ApprovalPage());
    } else {
      Get.to(DetailPage());
    }
  },
)
```

---

## 15. CHECKLIST PRE-COMMIT

### Para cada Page nuevo o modificado:

| Verificación | Cumple |
|--------------|--------|
| ¿Es StatelessWidget? | ☐ |
| ¿Tiene Binding asociado? | ☐ |
| ¿Controller registrado en Binding (no en Page)? | ☐ |
| ¿Tiene header de documentación completo? | ☐ |
| ¿Todos los elementos interactivos tienen Key? | ☐ |
| ¿GetBuilder para estructura, Obx para estado dinámico? | ☐ |
| ¿Maneja Loading state? | ☐ |
| ¿Maneja Empty state con CTA? | ☐ |
| ¿Maneja Error state con retry? | ☐ |
| ¿Maneja estados de Sync? | ☐ |
| ¿Sync status viene del Controller/ViewModel? | ☐ |
| ¿Todos los textos desde l10n? | ☐ |
| ¿Value Objects con widgets especializados? | ☐ |
| ¿Inputs especializados para tipos complejos? | ☐ |
| ¿Sin lógica de negocio en build? | ☐ |
| ¿Sin setState()? | ☐ |
| ¿Sin Get.put() en Page? | ☐ |
| ¿Navegación sin lógica de negocio? | ☐ |

---

## 16. ANTIPATRONES EN PANTALLAS

| Antipatrón | Descripción | Ref |
|------------|-------------|-----|
| StatefulWidget para datos | Usar StatefulWidget para estado de negocio | §3.2, §6.4 |
| Business Logic in Build | `if (order.total > 1000)` en build() | §3.1 |
| Missing States | No manejar Loading/Empty/Error | §6.1, §6.2 |
| Raw Value Objects | `Text('${money.amount}')` | §4 |
| Hardcoded Strings | `Text('Guardar')` | §3.4 |
| Missing Keys | Elementos sin Key | §3.5 |
| Direct Navigation Logic | `if (condition) Get.to(X)` en Widget | §8.4 |
| Get.put in Page | Instanciar Controller en Page | §3 (este doc) |
| GetBuilder for Rx | Usar GetBuilder para variables .obs | §5 (este doc) |
| Direct Entity Sync Read | Leer syncStatus de entidad en UI | §8 (este doc) |

---

## 17. MAPEO A UI_CONTRACTS.md

| Sección de este Template | Sección de UI_CONTRACTS.md |
|--------------------------|----------------------------|
| §3 Binding | §3.2 (Single Source of Truth) |
| §4 Declaración Header | §10.1 (Execution Summary) |
| §5 Reactividad | §3.1, §3.2 |
| §6 Estructura Widget | §3.1, §3.2 |
| §7 Reglas de Declaración | §3, §5, §6 |
| §8 Estado de Sync | §7.2, UI_OFFLINE_SYNC_GUIDE §3.2 |
| §9 Estados Visuales | §6.1, §6.2 |
| §10 Estados de Sync | §7.2 |
| §11 Value Objects | §4 |
| §12 Inputs | §5.2 |
| §13 Despacho de Acciones | §5.3 |
| §14 Navegación | §8.4 |

---

**FIN DE UI_SCREEN_TEMPLATE.md — v1.0.1**
