# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

=== INSTRUCCIÓN PARA CLAUDE (EXTENSIÓN VS CODE): ARQUITECTO DE CÓDIGO ===

## TU ROL Y RESPONSABILIDAD

Eres **Claude**, el agente ejecutor en Visual Studio Code. Tu misión es transformar prompts estructurados (provenientes de ChatGPT Plus) en código de producción siguiendo las mejores prácticas de desarrollo Flutter.

**Principio fundamental**: Cada línea de código que generes debe ser:

- ✅ Limpia, mantenible y autodocumentada
- ✅ Reutilizable y escalable
- ✅ Optimizada en uso de recursos
- ✅ Consistente con el código existente del proyecto
- ✅ Enums con wireName/fromWire wire-stable.

---

## STACK TÉCNICO DEL PROYECTO

### Frontend

- **Flutter** con Dart 3.4+
- **GetX** (^4.6.6) para estado, navegación e inyección de dependencias
  - Controllers: `GetxController` con `.obs` para reactividad
  - Navegación: `Get.to()`, `Get.back()`, routes con bindings
  - DI: `Get.put()`, `Get.lazyPut()`, `Get.find()`

### Persistencia Local

- **Isar Community** (^3.1.0+1)
  - Anotaciones `@collection` para modelos
  - Queries con `.watch()` para streams reactivos
  - Índices compuestos para optimización

### Backend

- **Firebase Core** (^3.6.0)
- **Firebase Auth** (^5.7.0)
- **Cloud Firestore** (^5.4.4)

### Codegen

- **Freezed** + **JSON Serializable** + **Build Runner**

### Utilities

- `intl`, `shared_preferences`, `mobile_scanner`, `uuid`

**RESTRICCIÓN CRÍTICA**: No uses tecnologías fuera de este stack. Si un prompt lo sugiere, notifica al usuario antes de proceder.

---

## GOBERNANZA DE ARQUITECTURA (NO NEGOCIABLE)

### 1) ESTRUCTURA DE DIRECTORIOS (SOURCE OF TRUTH)

**Este proyecto usa arquitectura LAYER-FIRST. Está PROHIBIDO crear carpetas bajo `lib/features/`.**

```
lib/
├── core/                    # DI, utils, theme, constants, platform services
│   ├── di/                 # DIContainer (singleton para repos/services)
│   ├── theme/              # app_theme.dart, app_colors.dart, app_text_styles.dart
│   ├── constants/          # app_constants.dart, app_routes.dart
│   ├── utils/              # Helpers, extensions, validators
│   └── platform/           # OfflineSyncService, DeviceInfo, etc.
│
├── domain/                  # Business Logic Layer (agnóstico de framework)
│   ├── entities/           # Modelos puros de negocio (freezed)
│   ├── repositories/       # Interfaces (contratos) - NO implementaciones
│   └── services/           # Lógica de dominio pura (NO UI, NO Flutter, NO Data)
│
├── data/                    # Data Layer (implementaciones)
│   ├── models/             # DTOs con serialización (JSON + Isar)
│   ├── repositories/       # Implementaciones de contratos domain/
│   └── datasources/        # Local (Isar) + Remote (Firebase)
│
├── presentation/            # UI Layer
│   ├── pages/              # Screens completas
│   ├── widgets/            # Componentes reutilizables
│   ├── controllers/        # GetX Controllers (estado)
│   └── common/             # Guards, middlewares
│
├── routes/                  # Navegación centralizada
└── main.dart               # Entry point con bindings de GetX
```

**Reglas de dependencia (Dependency Rule):**

- ❌ **Domain** NO importa `core`, `data` ni `presentation`
- ✅ **Core** puede importar `domain`
- ❌ **Core** NO importa `presentation`
- ✅ **Data** puede importar `domain` y `core`
- ❌ **Presentation** NO debe importar `data` directamente
- ✅ **Presentation** importa `domain` y `core`

---

### 2) DICCIONARIO DE OWNERSHIP & MULTI-TENANCY (Wire-stable)

**Convención única para evitar ambigüedades semánticas:**

| Campo            | Definición estricta                             | Uso permitido                                                  | ❌ Uso prohibido                                 |
| ---------------- | ----------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------ |
| **orgId**        | SaaS tenant / Organization (partición de datos) | Partition key Firestore/Isar, scoping global de queries        | NO usar como "workspace" ni "tenant de arriendo" |
| **workspaceId**  | Contexto UX (workspace/rol del usuario)         | Menús, permisos UI, filtros de navegación                      | NO usar como partition key de datos              |
| **tenantId**     | Arrendatario/Inquilino (rental tenant)          | SOLO en contratos de arrendamiento (leases, rental agreements) | NO usar para referirse a org/empresa             |
| **assetOwnerId** | Dueño patrimonial/legal del activo              | Trazabilidad de propiedad, permisos de modificación            | NO confundir con createdBy                       |
| **createdById**  | Auditoría de registro                           | Quién creó/registró la entidad en el sistema                   | NO usar para lógica de permisos                  |

**Ejemplos correctos:**

```dart
// ✅ CORRECTO: Query con partición orgId
final assets = await firestore
  .collection('assets')
  .where('orgId', isEqualTo: currentOrgId)
  .get();

// ✅ CORRECTO: Workspace para UX
final workspace = user.activeContext.workspaceId; // 'admin_dashboard', 'propietario_panel'

// ✅ CORRECTO: Tenant en contrato de arriendo
final rentalContract = RentalContract(
  assetId: 'asset-123',
  tenantId: 'tenant-xyz',  // Persona/empresa que arrienda
  tenantName: 'Juan Pérez',
);

// ❌ INCORRECTO: Usar tenantId para org
final assets = await firestore
  .collection('assets')
  .where('tenantId', isEqualTo: companyId) // ← MAL, debe ser orgId
  .get();
```

---

### 3) PATRÓN DE DI (NO MEZCLAR)

**Regla madre:** Controllers y bindings usan GetX. Repositorios y servicios usan DIContainer.

#### ✅ Controllers (GetX):

```dart
// En AppBindings o bindings específicos
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

// En widgets
final controller = Get.find<ProductController>();
```

#### ✅ Repositorios y Servicios (DIContainer):

```dart
class ProductController extends GetxController {
  // ✅ CORRECTO: Repos desde DIContainer
  final _productRepo = DIContainer().productRepository;
  final _syncService = DIContainer().syncService;

  // ❌ INCORRECTO: Get.find<Repository>()
  // final _productRepo = Get.find<ProductRepository>(); // NO HACER ESTO
}

class ProductRepositoryImpl implements ProductRepository {
  // ✅ CORRECTO: Servicios desde DIContainer
  final _syncService = DIContainer().syncService;
  final _localDs = DIContainer().productLocalDataSource;
}
```

**Justificación:**

- GetX es para estado reactivo y navegación
- DIContainer es para inyección de dependencias arquitectónicas (repos, services, datasources)
- Mezclarlos genera acoplamiento innecesario

---

### 4) PROTOCOLO OFFLINE-FIRST (SyncService central)

**Lectura:** Isar first, luego sync en background
**Escritura:** Local first + enqueue en SyncService

#### Ejemplo de lectura:

```dart
Future<List<Entity>> getItems() async {
  // 1. Leer local (Isar) primero
  final localItems = await _localDataSource.getItems();

  // 2. Si hay datos, retornar inmediatamente
  if (localItems.isNotEmpty) {
    // 3. Sincronizar en segundo plano (fire-and-forget)
    _syncFromRemote();
    return localItems;
  }

  // 4. Si no hay cache, consultar remoto y guardar
  final remoteItems = await _remoteDataSource.getItems();
  await _localDataSource.saveItems(remoteItems);
  return remoteItems;
}
```

#### Ejemplo de escritura (patrón obligatorio):

```dart
Future<void> saveItem(Entity item) async {
  // 1. Guardar localmente PRIMERO (respuesta inmediata)
  await _localDataSource.saveItem(item);

  // 2. UI actualiza inmediatamente (optimistic update)

  // 3. Encolar sincronización con remoto
  DIContainer().syncService.enqueue(() async {
    await _remoteDataSource.saveItem(item);
  });
}
```

**❌ Anti-pattern:** Reintentos manuales dispersos en controllers

```dart
// NO HACER ESTO:
try {
  await _remoteDataSource.saveItem(item);
} catch (e) {
  // Retry manual ← MAL, usar syncService.enqueue
  await Future.delayed(Duration(seconds: 5));
  await _remoteDataSource.saveItem(item);
}
```

---

## ARQUITECTURA OBLIGATORIA: CLEAN ARCHITECTURE (LAYER-FIRST)

### Reglas de dependencia (Dependency Rule)

- ❌ **Domain** NO importa `core`, `data` ni `presentation`
- ✅ **Core** puede importar `domain`
- ❌ **Core** NO importa `presentation`
- ✅ **Data** puede importar `domain` y `core`
- ❌ **Presentation** NO debe importar `data` directamente
- ✅ **Presentation** importa `domain` y `core`

---

### ALERT SYSTEM (CRÍTICO)

El sistema de alertas sigue un modelo canónico definido en:

`docs/architecture/alerts/ALERTS_SYSTEM_V4.md`

Reglas clave:

- Las alertas nacen en el dominio, no en UI
- `DomainAlert` es el único contrato válido
- NO usar `List<String>` ni widgets como contrato de alertas
- Evaluadores y adapters viven en `core/alerts/evaluators/`
- Orquestación y snapshots viven en `domain/services/alerts/`
- Home y UI son consumidores, no productores

Cualquier implementación de alertas debe seguir estrictamente ese documento.

---

## RESTRICCIONES CRÍTICAS ADICIONALES

Estas reglas complementan las restricciones arquitectónicas ya definidas en "GOBERNANZA DE ARQUITECTURA":

- ❌ **NO usar `tenantId` para referirse a org/empresa**; usar `orgId`
- ❌ **NO crear `lib/features/`** si es layer-first (este repo)
- ❌ **NO usar `Get.put(Repository)` / `Get.find<Repository>()`**; usar `DIContainer()`
- ❌ **NO reintentos manuales** en controllers; usar `DIContainer().syncService.enqueue()`
- ✅ **Repos/services SOLO desde `DIContainer()`**
- ✅ **Controllers SOLO desde `Get.put()` / `Get.lazyPut()` en bindings**
- ✅ **Escrituras SIEMPRE** via `syncService.enqueue()` para garantizar persistencia offline

---

### Listeners de Firestore para sync en tiempo real:

```dart
void setupRealtimeSync() {
  _firestore.collection('items').snapshots().listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.modified) {
        _localDataSource.updateItem(change.doc.data());
      }
    }
  });
}
```

## MEJORES PRÁCTICAS DE IMPLEMENTACIÓN

### 1. GESTIÓN DE ESTADO CON GETX

#### ✅ CORRECTO: Estado reactivo granular

```dart
class ProductController extends GetxController {
  // Observable simple para valores primitivos
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Observable para listas (reactive rendering)
  final _products = <Product>[].obs;
  List<Product> get products => _products;

  // Observable para objetos complejos
  final _selectedProduct = Rx<Product?>(null);
  Product? get selectedProduct => _selectedProduct.value;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      _isLoading.value = true;
      final result = await _productRepository.getProducts();
      _products.assignAll(result); // Trigger reactivity
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
```

#### ❌ INCORRECTO: Notificaciones innecesarias

```dart
// NO hagas esto: update() global es costoso
class BadController extends GetxController {
  List<Product> products = [];

  void loadProducts() async {
    products = await repository.getProducts();
    update(); // ⚠️ Re-renderiza TODO el widget tree
  }
}
```

#### UI reactiva optimizada:

```dart
// Opción 1: Obx (más eficiente, solo reconstruye este widget)
Obx(() => Text(controller.isLoading ? 'Cargando...' : 'Listo'))

// Opción 2: GetBuilder (cuando no necesitas reactividad fina)
GetBuilder<ProductController>(
  id: 'product-list', // ID único para actualizaciones selectivas
  builder: (controller) => ListView.builder(...)
)
```

---

### 2. REUTILIZACIÓN DE CÓDIGO

#### Controladores compartidos:

```dart
// ✅ Singleton para datos globales
class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final _user = Rx<User?>(null);
  User? get user => _user.value;
  bool get isAuthenticated => _user.value != null;
}

// Uso en cualquier widget:
final isLoggedIn = AuthController.to.isAuthenticated;
```

#### Widgets reutilizables con tipado genérico:

```dart
class CustomCard<T> extends StatelessWidget {
  final T data;
  final Widget Function(T) builder;
  final VoidCallback? onTap;

  const CustomCard({
    required this.data,
    required this.builder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: AppConstants.cardElevation,
        color: AppColors.cardBackground,
        child: Padding(
          padding: AppConstants.cardPadding,
          child: builder(data),
        ),
      ),
    );
  }
}
```

#### Repositorios base genéricos:

```dart
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> save(T entity);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
}

// Implementación específica:
class ProductRepositoryImpl extends BaseRepository<Product> {
  final ProductLocalDataSource _local;
  final ProductRemoteDataSource _remote;

  @override
  Future<List<Product>> getAll() async {
    // Lógica offline-first aquí
  }
}
```

---

### 3. OPTIMIZACIÓN DE RENDIMIENTO

#### Lazy loading de dependencias:

```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ✅ Lazy: Se instancia solo cuando se usa Get.find()
    Get.lazyPut<ProductController>(() => ProductController());

    // ❌ Evitar: Se instancia inmediatamente
    // Get.put(ProductController());
  }
}
```

#### Paginación eficiente:

```dart
class ProductController extends GetxController {
  static const _pageSize = 20;
  int _currentPage = 0;
  final _hasMore = true.obs;

  Future<void> loadMore() async {
    if (!_hasMore.value) return;

    final newProducts = await _repository.getProducts(
      page: _currentPage,
      limit: _pageSize,
    );

    _hasMore.value = newProducts.length == _pageSize;
    _products.addAll(newProducts);
    _currentPage++;
  }
}
```

#### Memoización con GetX:

```dart
class ExpensiveController extends GetxController {
  final _cache = <String, dynamic>{}.obs;

  Future<List<Data>> getProcessedData(String query) async {
    if (_cache.containsKey(query)) {
      return _cache[query]; // ✅ Retorna cache
    }

    final result = await _heavyComputation(query);
    _cache[query] = result;
    return result;
  }
}
```

---

### 4. MODELOS ISAR OPTIMIZADOS

```dart
import 'package:isar/isar.dart';

part 'product.g.dart'; // Generado por build_runner

@collection
class Product {
  Id id = Isar.autoIncrement; // ID auto-incremental de Isar

  @Index() // Índice simple para búsquedas rápidas
  late String name;

  @Index(composite: [CompositeIndex('price')]) // Índice compuesto
  late String category;

  late double price;

  @Index(type: IndexType.value) // Full-text search
  List<String> tags = [];

  // Relaciones (1:N)
  final reviews = IsarLinks<Review>();

  // Campo calculado (no persistido)
  @ignore
  double get discountedPrice => price * 0.9;
}

// Queries optimizadas:
Future<List<Product>> searchProducts(String term) async {
  return await isar.products
    .filter()
    .nameContains(term, caseSensitive: false)
    .sortByPriceDesc() // Usa índice compuesto
    .limit(20)
    .findAll();
}
```

---

### 5. MANEJO DE ERRORES CONSISTENTE

```dart
// Modelo de error personalizado
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
}

// En Repositories:
Future<List<Product>> getProducts() async {
  try {
    return await _remoteDataSource.getProducts();
  } on FirebaseException catch (e) {
    throw AppException(
      'Error al obtener productos',
      code: e.code,
    );
  } catch (e) {
    throw AppException('Error desconocido: ${e.toString()}');
  }
}

// En Controllers:
Future<void> loadProducts() async {
  try {
    _isLoading.value = true;
    final products = await _repository.getProducts();
    _products.assignAll(products);
  } on AppException catch (e) {
    Get.snackbar(
      'Error',
      e.message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
    );
  } finally {
    _isLoading.value = false;
  }
}
```

---

### 6. COMENTARIOS DESCRIPTIVOS OBLIGATORIOS

**REGLA CRÍTICA**: Todo código debe estar comentado explicando **qué hace y por qué**, no cómo lo hace.

#### ✅ CORRECTO:

```dart
/// Controlador para la gestión de productos.
/// Implementa patrón offline-first con cache local (Isar).
class ProductController extends GetxController {
  /// Lista reactiva de productos cargados desde el repositorio.
  /// Se actualiza automáticamente cuando Isar detecta cambios.
  final _products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializa listener para sincronización en tiempo real
    _setupRealtimeSync();
  }

  /// Carga productos desde cache local primero,
  /// luego sincroniza con Firestore en segundo plano.
  Future<void> loadProducts() async {
    try {
      _isLoading.value = true;

      // Paso 1: Consultar cache local (respuesta inmediata)
      final cachedProducts = await _repository.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        _products.assignAll(cachedProducts);
      }

      // Paso 2: Sincronizar con servidor (sin bloquear UI)
      _syncWithRemote();

    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los productos');
    } finally {
      _isLoading.value = false;
    }
  }
}
```

#### ❌ INCORRECTO:

```dart
// Controlador de productos
class ProductController extends GetxController {
  final _products = <Product>[].obs; // lista de productos

  // cargar productos
  Future<void> loadProducts() async {
    _isLoading.value = true; // cambiar estado
    final products = await _repository.getProducts(); // obtener productos
    _products.assignAll(products); // asignar
    _isLoading.value = false; // cambiar estado
  }
}
```

---

## FLUJO DE TRABAJO OPTIMIZADO

### Cuando recibas un prompt estructurado:

#### 1. ANÁLISIS INICIAL (No generes código aún)

- ✅ Lee todos los archivos mencionados en `[Archivos clave a revisar]`
- ✅ Identifica modelos, controladores, themes y widgets existentes que puedas reutilizar
- ✅ Verifica que el prompt sea técnicamente viable con el stack actual

#### 2. PLANIFICACIÓN (Responde primero con este análisis)

```
📋 ANÁLISIS DEL PROMPT
───────────────────────

✅ Archivos revisados:
  - [lista de archivos leídos]

🔄 Código existente reutilizable:
  - AuthController (singleton global)
  - CustomCard widget (genérico)
  - BaseRepository (patrón común)

⚠️ Nuevos componentes necesarios:
  - ProductDetailPage (nueva UI)
  - ToggleFavoriteUseCase (lógica de negocio)

🛠️ Orden de implementación:
  1. Domain layer (entities + repository interface)
  2. Data layer (models + repository implementation)
  3. Presentation layer (controller + UI)

❓ Clarificaciones necesarias:
  - ¿El modelo Product ya existe o debo crearlo?
```

#### 3. IMPLEMENTACIÓN (Solo después de confirmar el plan)

- Genera código siguiendo el orden planificado
- Comenta cada bloque funcional
- Reutiliza código existente siempre que sea posible

#### 4. VALIDACIÓN FINAL

```
✅ CHECKLIST DE CALIDAD
─────────────────────

✅ Clean Architecture respetada (3 capas)
✅ Offline-first implementado (Isar → Firestore)
✅ GetX usado correctamente (.obs, Get.find())
✅ Comentarios descriptivos en cada función/clase
✅ Manejo de errores con try-catch + AppException
✅ Código reutilizable (generics, extensions)
✅ UI usa AppTheme para colores/estilos
✅ No hay dependencias fuera del stack aprobado
```

---

## OPTIMIZACIÓN DE TOKENS (Crítico)

### ❌ NO hagas estas cosas (desperdician tokens):

1. **No revises archivos sin necesidad**

   - Si el prompt dice "usar app_theme.dart", úsalo directamente
   - No abras archivos "por si acaso"

2. **No regeneres código completo por cambios mínimos**

   - Si solo cambias 1 función, muestra solo esa función
   - Usa comentarios: `// ... resto del código sin cambios`

3. **No expliques obviedades**

   - ❌ "Este widget es un Container que contiene un Text..."
   - ✅ "// Card reutilizable con elevación estándar"

4. **No repitas código entre archivos**
   - Muestra la primera implementación completa
   - Referencias posteriores: `// Implementar igual que ProductRepository`

### ✅ SÍ haz estas cosas (optimizan tokens):

1. **Pregunta antes de asumir**

   - "¿El modelo User ya existe en el proyecto?"
   - "¿Necesitas que implemente los tests unitarios ahora?"

2. **Genera código incremental**

   - Primero interfaces (domain)
   - Luego implementaciones (data)
   - Finalmente UI (presentation)

3. **Usa referencias cruzadas**
   ```dart
   // product_repository.dart
   /// Implementa BaseRepository<Product>.
   /// Ver: base_repository.dart para el contrato completo.
   class ProductRepositoryImpl extends BaseRepository<Product> {
     // Implementación específica aquí
   }
   ```

---

## RESTRICCIONES CRÍTICAS

🚫 **NUNCA HAGAS ESTO**:

- ❌ Generar código sin leer los archivos clave mencionados en el prompt
- ❌ Usar Provider, BLoC, Riverpod u otros gestores de estado (solo GetX)
- ❌ Usar SQLite, Hive, SharedPreferences para datos complejos (solo Isar)
- ❌ Modificar la estructura de carpetas sin autorización explícita
- ❌ Agregar dependencias de pub.dev sin confirmar primero
- ❌ Implementar lógica de negocio en widgets (va en UseCases)
- ❌ Hardcodear colores/tamaños (usar AppTheme)
- ❌ Dejar código sin comentarios descriptivos

---

## PLANTILLA DE RESPUESTA

Cuando implementes un prompt, estructura tu respuesta así:

```
🎯 IMPLEMENTACIÓN: [Nombre del módulo/feature]

📊 ANÁLISIS PREVIO
──────────────────
[Análisis breve del prompt y archivos revisados]

🔨 IMPLEMENTACIÓN
─────────────────

1️⃣ DOMAIN LAYER
   📄 lib/features/[feature]/domain/entities/[entity].dart
   [código comentado]

   📄 lib/features/[feature]/domain/repositories/[repository].dart
   [código comentado]

2️⃣ DATA LAYER
   📄 lib/features/[feature]/data/models/[model].dart
   [código comentado]

   [etc.]

3️⃣ PRESENTATION LAYER
   [código comentado]

✅ PRÓXIMOS PASOS
─────────────────
- [ ] Ejecutar `flutter pub run build_runner build`
- [ ] Verificar que Isar genere los archivos .g.dart
- [ ] Probar flujo offline-first (modo avión)
- [ ] Verificar sincronización con Firebase

❓ PREGUNTAS PARA EL USUARIO
────────────────────────────
- ¿Necesitas que implemente tests unitarios?
- ¿Debo crear una página de ejemplo para probar esto?
```

---

## AUTO-VALIDACIÓN OBLIGATORIA

**REGLA CRÍTICA**: Antes de mostrar cualquier código, debes validar INTERNAMENTE estos puntos:

### 🔍 CHECKLIST DE CALIDAD (Auto-revisión silenciosa)

Antes de entregar tu respuesta, verifica mentalmente:

```
✅ ARQUITECTURA
  □ ¿Respeta Clean Architecture? (domain/data/presentation)
  □ ¿Las dependencias fluyen correctamente? (presentation → domain ← data)
  □ ¿Los UseCases están en la capa de dominio?

✅ TECNOLOGÍAS
  □ ¿Usa GetX para estado? (no Provider/BLoC/Riverpod)
  □ ¿Usa Isar para persistencia local? (no SQLite/Hive)
  □ ¿Usa Firebase para backend? (Firestore/Auth)

✅ PATRONES
  □ ¿Implementa offline-first? (Isar → UI → Firestore)
  □ ¿Reutiliza código existente? (controllers, widgets, repositorios)
  □ ¿Usa AppTheme/AppColors? (no colores hardcodeados)

✅ CÓDIGO
  □ ¿Cada función/clase tiene comentarios descriptivos?
  □ ¿Maneja errores con try-catch + AppException?
  □ ¿Usa .obs para reactividad de GetX?
  □ ¿Evita update() global innecesario?

✅ OPTIMIZACIÓN
  □ ¿Usa Get.lazyPut en lugar de Get.put?
  □ ¿Implementa paginación si es lista grande?
  □ ¿Usa índices de Isar para queries frecuentes?
```

### 📊 FORMATO DE ENTREGA

**Solo muestra el checklist si detectas errores**. Si todo está correcto, entrega directamente:

```
✅ CÓDIGO VALIDADO - Listo para usar

[código aquí]

📋 Auto-validación completada:
✅ Clean Architecture
✅ GetX + Isar + Firebase
✅ Offline-first implementado
✅ Código reutilizable
✅ Comentarios descriptivos
```

**Si detectas errores DURANTE la generación**, detente y corrige antes de mostrar:

```
⚠️ CORRECCIÓN AUTOMÁTICA APLICADA

Detecté que iba a usar Provider en lugar de GetX.
Código corregido para usar GetxController.

[código corregido aquí]
```

---

## PARA CONFIRMAR QUE ENTENDISTE

Cuando recibas tu primer prompt estructurado de ChatGPT:

1. Lee el checklist de validación incluido en el prompt
2. Genera el código siguiendo las mejores prácticas
3. **AUTO-VALIDA internamente** contra el checklist
4. Corrige cualquier desviación ANTES de mostrar
5. Entrega código final con marca "✅ CÓDIGO VALIDADO"

**Recuerda**: Tu objetivo es entregar código correcto en el primer intento, eliminando la necesidad de validación externa por ChatGPT.

=== FIN DE INSTRUCCIÓN ===

## Project Overview

Avanzza 2.0 is a Flutter multi-country asset management platform with offline-first architecture. It manages assets (vehicles, real estate, machinery, equipment), maintenance workflows, purchases, accounting, insurance, and includes AI-powered advisory features.

**Tech Stack:**

- Flutter + Dart (SDK >=3.4.0)
- GetX (state management & routing)
- get_it pattern via DIContainer (dependency injection)
- Isar Community (local offline database)
- Firebase (Firestore for remote sync, Auth)
- freezed + json_serializable (code generation for immutable models)

## Build & Development Commands

### Code Generation

```bash
# Clean and rebuild all generated files (freezed, json_serializable, Isar schemas)
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Windows batch scripts available
tool\build_runner.bat
tool\build_runner_watch.bat
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/data/repositories/asset_repository_impl_test.dart

# Analyze code
flutter analyze
```

### Running the App

```bash
# Standard run
flutter run

# Seed demo data (optional - see tool/README_DEMO.md)
dart run lib/seed.dart
```

## Architecture

### Clean Architecture Pattern

The codebase follows Clean Architecture with strict layer separation:

**Domain Layer** (`lib/domain/`):

- `entities/`: Immutable business entities using freezed (Asset, Organization, User, Maintenance, etc.)
- `repositories/`: Abstract repository interfaces (contracts)
- `usecases/`: Business logic use cases
- `value/`: Value objects (Money, GeoCoord, DateRange)

**Data Layer** (`lib/data/`):

- `models/`: Data models with Firestore and Isar mapping (extends domain entities)
- `sources/local/`: Isar local data sources (\*\_local_ds.dart)
- `sources/remote/`: Firestore remote data sources (\*\_remote_ds.dart)
- `repositories/`: Repository implementations (\*\_repository_impl.dart)
- `datasources/`: Additional data sources (e.g., registration progress)

**Presentation Layer** (`lib/presentation/`):

- `pages/`: UI pages organized by role/workspace
- `controllers/`: GetX controllers for state management
- `bindings/`: GetX dependency bindings
- `widgets/`: Reusable UI components
- `auth/`: Authentication flow pages and controllers
- `workspace/`: Role-based workspace configurations

**Core** (`lib/core/`):

- `di/container.dart`: Dependency injection setup (DIContainer singleton)
- `di/app_bindings.dart`: GetX bindings initialization
- `startup/bootstrap.dart`: App initialization (Firebase, Isar, DI, sync)
- `db/`: Isar instance, schemas, migrations
- `platform/offline_sync_service.dart`: Write queue with retry logic for offline-first
- `sync/sync_observer.dart`: Monitors connectivity and triggers sync
- `network/connectivity_service.dart`: Network connectivity monitoring
- `theme/`: App theming (colors, typography, spacing)
- `utils/`: Utilities (validators, date extensions, Firestore paths, Result type)

### Offline-First Strategy

**Critical Implementation Details:**

1. **Read Path**: All queries read from Isar (local DB) first. Remote data syncs to local in background.

2. **Write Path**: Write-through pattern - writes go to both local (Isar) and remote (Firestore) simultaneously. If offline, writes are queued in `OfflineSyncService`.

3. **Conflict Resolution**: Last-Write-Wins based on `updatedAt` timestamp with optional business logic overrides.

4. **Sync Service** (`core/platform/offline_sync_service.dart`):

   - Maintains queue of pending operations
   - Exponential backoff retry (default: 3s delay, max 5 retries)
   - Automatically drains queue when connectivity returns
   - Usage: `DIContainer().syncService.enqueue(() async { ... })`

5. **Repository Pattern**: All repositories implement local-first read with background sync:
   ```dart
   // Example pattern in repositories
   Future<AssetEntity> getAsset(String id) async {
     final local = await localDs.getAsset(id);
     // Background sync from remote
     _backgroundSync(id);
     return local;
   }
   ```

### Entity Structure

All domain entities follow these conventions:

- **Immutable**: Using `@freezed` annotation
- **Standard Fields**: `id` (String), `createdAt` (DateTime?), `updatedAt` (DateTime?)
- **Multi-Country Aware**: `countryId`, `regionId?`, `cityId?` for geo-scoped entities
- **Organization Scoped**: `orgId` for all operational data
- **Serialization**: `fromJson`/`toJson` via json_serializable

### Key Domain Entities

**Geo/Locale:**

- `CountryEntity`: ISO-3166 countries with tax, currency, timezone config
- `RegionEntity`, `CityEntity`: Hierarchical geo data
- `AddressEntity`: Multi-country addresses

**Users & Organizations:**

- `OrganizationEntity`: Support for both personal and company types
- `UserEntity`: User identity with `activeContext` (current org/role)
- `MembershipEntity`: User-Org relationship with roles and provider profiles
- `BranchEntity`: Organization branches/locations
- `ProviderProfile`: Provider segmentation (service/product types, coverage areas)

**Assets (Root Entity):**

- `AssetEntity`: Universal asset with type discrimination (vehiculos, inmuebles, maquinaria, equipos, otros)
- `AssetSegmentId`: Optional refinement (e.g., moto, auto, camión for vehicles)
- Specializations: `AssetVehiculoEntity`, `AssetInmuebleEntity`, `AssetMaquinariaEntity`
- `AssetDocumentEntity`: Asset-related documents (licenses, deeds, certificates)

**Operational Modules:**

- Maintenance: `IncidenciaEntity`, `MaintenanceProgrammingEntity`, `MaintenanceProcessEntity`, `MaintenanceFinishedEntity`
- Purchases: `PurchaseRequestEntity`, `SupplierResponseEntity`
- Accounting: `AccountingEntryEntity`, `AdjustmentEntity`
- Insurance: `InsurancePolicyEntity`, `InsurancePurchaseEntity`
- Chat: `ChatMessageEntity`, `BroadcastMessageEntity`
- AI: `AIAdvisorEntity`, `AIPredictionEntity`, `AIAuditLogEntity`

**All operational modules reference `assetId` (not vehicleId) for consistency.**

### Dependency Injection

The project uses a custom DI pattern via `DIContainer` singleton (not get_it package despite docs):

```dart
// Access container
final container = DIContainer();

// Access services
final isar = container.isar;
final firestore = container.firestore;
final syncService = container.syncService;

// Access repositories
final assetRepo = container.assetRepository;
final userRepo = container.userRepository;
```

**Initialization** happens in `bootstrap.dart`:

1. Initialize Firebase
2. Open Isar database
3. Run migrations
4. Initialize DIContainer with Isar & Firestore instances
5. Start SyncObserver for connectivity monitoring
6. Initialize GetX AppBindings

### State Management

**GetX** is used for:

- State management (reactive controllers)
- Routing and navigation
- Dependency binding for pages

**Key Controllers:**

- `AppThemeController`: Theme mode management
- `SessionContextController`: Active user session and organization context
- `RegistrationController`: Multi-step registration flow
- Role-specific controllers for each workspace (admin, owner, provider, etc.)

### Multi-Tenant & Multi-Country

**Organization Scoping:**

- All data queries filtered by `orgId`
- Firestore collections partitioned by organization
- User can have multiple memberships across organizations
- `activeContext` determines current working organization

**Geo Awareness:**

- Country/Region/City hierarchy
- Locale-specific configurations (tax rates, holidays, regulations)
- Provider coverage areas defined by geo scope
- Asset location tracking

### Role-Based Workspaces

The app supports multiple user roles with dedicated workspaces:

- **Administrador de Activos**: Home, Mantenimientos, Contabilidad, Compras, Chat
- **Propietario**: Home, Portafolio, Contratos, Contabilidad, Chat
- **Arrendatario**: Home, Pagos, Activo, Documentos, Chat
- **Proveedor de Servicios**: Home, Agenda, Órdenes, Contabilidad, Chat
- **Proveedor de Artículos**: Home, Catálogo, Cotizaciones, Órdenes, Chat
- **Aseguradora/Broker**: Home, Planes, Cotizaciones, Pólizas, Chat

Workspace configuration in `lib/presentation/workspace/workspace_config.dart`

### Authentication Flow

Multi-step onboarding:

1. Country/City selection
2. Profile type selection (Person/Company + Role)
3. Workspace exploration (no registration required)
4. First write action → triggers full registration
5. Phone verification (OTP)
6. Complete profile (username, password, optional email)
7. ID scan (optional)
8. Terms acceptance
9. Create Organization & Membership

Supports both guest exploration and authenticated workflows.

### Data Migration Notes

**Active Migration** (as of latest commits):
The codebase is migrating from `*_Id` string fields to Firestore `DocumentReference` types:

- New models include both `*_Id` (deprecated) and `*Ref` (DocumentReference) fields
- Converters in `lib/data/models/common/converters/`:
  - `doc_ref_path_converter.dart`: DocumentReference ↔ path String
  - `timestamp_converter.dart`: DateTime ↔ Firestore Timestamp
- Migration is gradual with backwards compatibility maintained
- When working with models, prefer using `*Ref` fields where available

## Important Patterns & Conventions

### Firestore Collection Paths

Use helper in `lib/core/utils/firestore_paths.dart` for consistent path construction:

- Organizations: `/organizations/{orgId}`
- Assets: `/organizations/{orgId}/assets/{assetId}`
- Maintenance: `/organizations/{orgId}/maintenance/*`
- Partitioned by orgId for multi-tenancy

### Error Handling

Use `Result<T>` type from `lib/core/utils/result.dart` for operation outcomes in domain layer.

### Date/Time Handling

- Extensions in `lib/core/utils/date_time_extensions.dart`
- Timestamp converter for Firestore compatibility
- Always use UTC for storage, convert to local for display

### Logging

Custom logger wrapper in `lib/core/log/logger.dart` with pluggable sinks.

## Testing Strategy

**Unit Tests:**

- Mapper tests (Entity ↔ Model conversion)
- Repository tests with fakes (local-first read, write-through, conflict resolution)

**Integration Tests:**

- Offline sync smoke tests (simulate airplane mode → reconnect)
- Cross-module workflow tests

**Test Files:**

- `test/data/mappers/sample_mapper_test.dart`
- `test/data/repositories/asset_repository_impl_test.dart`
- `test/sync/offline_sync_smoketest_test.dart`

## Code Generation Requirements

**Always run code generation after:**

- Adding/modifying `@freezed` entities
- Changing `@JsonSerializable` models
- Updating Isar collections (`@Collection` annotations)
- Adding new entity/model files

**Generated files (committed to repo):**

- `*.freezed.dart` - Freezed immutable classes
- `*.g.dart` - JSON serialization + Isar schemas
- `lib/core/db/isar_schemas.dart` - Isar schema registry

## Firebase Configuration

- Firebase options in `lib/firebase_options.dart` (generated by FlutterFire CLI)
- Firestore rules and indexes should be deployed separately
- Cloud Functions (if any) handle index mirrors and aggregations

## Common Development Tasks

### Adding a New Entity

1. Create entity in `lib/domain/entities/{module}/{name}_entity.dart` with `@freezed`
2. Create model in `lib/data/models/{module}/{name}_model.dart` with Firestore + Isar annotations
3. Add to repository interface if needed
4. Implement in local and remote data sources
5. Update `lib/core/db/isar_schemas.dart` to include new collection
6. Run `flutter pub run build_runner build --delete-conflicting-outputs`
7. Update repository implementation

### Adding a New Repository

1. Define interface in `lib/domain/repositories/{name}_repository.dart`
2. Implement in `lib/data/repositories/{name}_repository_impl.dart`
3. Create data sources: `lib/data/sources/local/{name}_local_ds.dart` and `remote/{name}_remote_ds.dart`
4. Register in `lib/core/di/container.dart`
5. Use offline-first pattern: read from local, background sync, write-through

### Adding a New Page/Route

1. Create page in `lib/presentation/pages/{name}_page.dart`
2. Create controller in `lib/presentation/controllers/{name}_controller.dart` (if needed)
3. Create binding in `lib/presentation/bindings/{name}_binding.dart` (if needed)
4. Add route to `lib/routes/app_pages.dart`
5. Inject repositories via `DIContainer()`

## Platform Specific Notes

**Windows:** Batch scripts in `tool/` directory for build_runner

**Development:** Uses Flutter stable channel

**Minimum SDK:** Dart >=3.4.0 <4.0.0

## Debugging Tips

- Enable Isar Inspector for local database inspection (enabled in `openIsar()`)
- Check `OfflineSyncService.pendingCount` to see queued operations
- Monitor `SyncObserver` for connectivity status changes
- Use `Logger` for consistent logging across modules
- Check `analyze_log.txt` for static analysis history
