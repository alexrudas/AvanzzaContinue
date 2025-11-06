# STACK TÉCNICO - GUÍA RÁPIDA DE REFERENCIA

## 🎯 Arquitectura
**Clean Architecture (3 capas)**
- Presentación → GetX Controllers + Widgets
- Dominio → Casos de Uso + Entidades
- Datos → Repositories + DataSources (Isar + Firebase)

---

## 🧰 Tecnologías Core

### Estado y Navegación
```yaml
get: ^4.6.6
```
- **Gestión de estado**: `GetxController`, `Obx`, `GetBuilder`, `.obs`
- **Navegación**: `Get.to()`, `Get.off()`, `Get.back()`
- **Inyección**: `Get.put()`, `Get.find()`, `Get.lazyPut()`

### Base de Datos Local (Offline-First)
```yaml
isar_community: ^3.1.0+1
isar_community_flutter_libs: ^3.1.0+1
```
- Anotación: `@collection`
- Queries reactivas: `.watch()` streams
- CRUD: `.put()`, `.get()`, `.delete()`, `.filter()`

### Backend (Cloud)
```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.7.0
cloud_firestore: ^5.4.4
```
- Auth: `FirebaseAuth.instance`
- Firestore: `FirebaseFirestore.instance.collection()`
- Listeners en tiempo real: `.snapshots()`

---

## 📦 Codegen

### Para modelos Isar
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Para Freezed + JSON
```yaml
freezed: ^3.1.0
freezed_annotation: ^3.1.0
json_annotation: ^4.9.0
json_serializable: ^6.9.0
```

---

## 🔄 Patrón Offline-First

```
1. Usuario hace acción
2. ✅ Guardar en Isar (local) inmediatamente
3. 📱 Actualizar UI con datos locales
4. 🌐 Sincronizar con Firestore en background
5. 🔄 Escuchar cambios de Firestore
6. 💾 Actualizar Isar con cambios remotos
```

---

## 🚫 NO USAR

❌ BLoC / Cubit
❌ Provider / Riverpod
❌ SQLite / Hive / SharedPreferences (para datos complejos)
❌ HTTP directo / Dio (usamos Firebase)
❌ Navigator tradicional (usar Get.to)

---

## ✅ ESTRUCTURA DE CARPETAS ESPERADA

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_icons.dart
│   └── services/
│       ├── isar_service.dart
│       └── firebase_service.dart
├── features/
│   └── [nombre_feature]/
│       ├── presentation/
│       │   ├── controllers/
│       │   ├── pages/
│       │   └── widgets/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── data/
│           ├── models/
│           ├── repositories/
│           └── datasources/
│               ├── local/
│               └── remote/
└── main.dart
```

---

## 💡 EJEMPLOS DE CÓDIGO COMÚN

### GetX Controller básico
```dart
class ProductController extends GetxController {
  final ProductRepository repository;
  
  ProductController(this.repository);
  
  final products = <Product>[].obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }
  
  Future<void> loadProducts() async {
    isLoading.value = true;
    final result = await repository.getProducts();
    products.value = result;
    isLoading.value = false;
  }
}
```

### Modelo Isar
```dart
@collection
class Product {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String name;
  
  late double price;
  late DateTime createdAt;
}
```

### Repository con Offline-First
```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ProductRemoteDataSource remoteDataSource;
  
  ProductRepositoryImpl(this.localDataSource, this.remoteDataSource);
  
  @override
  Future<List<Product>> getProducts() async {
    // 1. Retornar datos locales inmediatamente
    final localProducts = await localDataSource.getAll();
    
    // 2. Sincronizar en background
    _syncWithRemote();
    
    return localProducts;
  }
  
  Future<void> _syncWithRemote() async {
    final remoteProducts = await remoteDataSource.getAll();
    await localDataSource.saveAll(remoteProducts);
  }
}
```

---

## 🎨 Tema y Diseño

**SIEMPRE usar archivos de tema centralizados:**
- `app_theme.dart` → ThemeData completo
- `app_colors.dart` → Paleta de colores
- `app_text_styles.dart` → Estilos de tipografía
- `app_icons.dart` → Iconos personalizados

**NUNCA hardcodear:**
- Colores directamente (ej: `Color(0xFF123456)`)
- Tamaños de fuente literales
- Padding/margin mágicos sin constantes

---

## 📝 CHECKLIST PARA PROMPTS

Cuando ChatGPT genere un prompt para Claude, debe verificar:

- [ ] ¿Menciona el módulo/feature específico?
- [ ] ¿Indica qué capa(s) arquitectónica(s) tocar?
- [ ] ¿Especifica usar GetX para estado?
- [ ] ¿Indica Isar para local + Firestore para remoto?
- [ ] ¿Menciona archivos de tema si hay UI?
- [ ] ¿Incluye estrategia offline-first si aplica?
- [ ] ¿Lista archivos que Claude debe revisar?
- [ ] ¿Define restricciones claras?
