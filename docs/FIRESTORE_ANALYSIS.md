# Análisis de Base de Datos Firebase - Avanzza 2.0

**Fecha**: 2025-10-16
**Analista**: Claude (Auditoría de arquitectura)
**Objetivo**: Validar si la estructura de Firestore es óptima para consultas rápidas, económicas y escalable

---

## ⚠️ CONVENCIÓN DE SCOPING (NO NEGOCIABLE)

**Antes de continuar con el análisis, aclaración crítica de nomenclatura:**

- **`orgId`**: Partition key multi-tenant (SaaS organization). Usado en queries Firestore como scope principal.
- **`workspaceId`**: Contexto UX (workspace/rol del usuario). NO es partition key de datos.
- **`tenantId`**: Arrendatario/inquilino (rental tenant). SOLO en contratos de arrendamiento (rental agreements).

**Todas las referencias en este documento a "particionamiento multi-tenant" usan `orgId`.**

---

## 📊 Resumen Ejecutivo

### ✅ Fortalezas Identificadas
- **Particionamiento por `orgId`**: Excelente estrategia multi-tenant (SaaS organization)
- **Arquitectura offline-first**: Reduce costos de lectura
- **Colecciones flat (no anidadas)**: Facilita queries y costos predecibles
- **Uso de índices compuestos**: Queries con múltiples where

### ⚠️ Áreas de Mejora Críticas
- **Falta de subcollections**: Puede causar hot spots en escala
- **No hay paginación implementada**: Riesgo de lecturas masivas
- **Ausencia de índices TTL**: Datos antiguos se acumulan
- **Queries sin límites**: Costo impredecible en producción

### 🎯 Score de Optimización: **6.5/10**

---

## 🏗️ 1. Estructura de Colecciones

### 1.1 Arquitectura Actual

```
Firestore Root/
├── countries/
├── regions/
├── cities/
├── local_regulations/
├── users/
├── organizations/
├── memberships/
├── assets/                    ← Flat collection
├── asset_vehiculo/
├── asset_inmueble/
├── asset_maquinaria/
├── asset_documents/           ← Flat collection
├── incidencias/               ← Flat collection
├── maintenance_programming/   ← Flat collection
├── maintenance_process/       ← Flat collection
├── maintenance_finished/      ← Flat collection
├── purchase_requests/
├── supplier_responses/
├── accounting_entries/
├── adjustments/
├── insurance_policies/
├── insurance_purchases/
├── chat_messages/             ← Flat collection
├── broadcast_messages/
├── ai_advisor/
├── ai_predictions/
└── ai_audit_logs/
```

### 1.2 Evaluación: **BUENA pero con riesgos**

✅ **Positivo:**
- Estructura flat facilita queries cross-org (ej: búsqueda global de proveedores)
- Separación lógica de módulos
- No hay over-nesting (evita queries complejas)

⚠️ **Riesgos:**
- **Hot spots potenciales**: Todas las escrituras van a colecciones root
- **Sin jerarquía organizacional**: Dificulta permisos granulares en Security Rules
- **Escalabilidad limitada**: En 10,000+ orgs, queries se vuelven lentas

---

## 🔍 2. Análisis de Queries

### 2.1 Queries Actuales

#### Assets (asset_remote_ds.dart)
```dart
// Query típica
db.collection('assets')
  .where('orgId', isEqualTo: orgId)
  .where('assetType', isEqualTo: assetType)  // Requiere índice compuesto
  .where('cityId', isEqualTo: cityId)         // Requiere índice compuesto
  .get();
```

**Evaluación:**
- ✅ Filtra por `orgId` primero (buen partition key)
- ⚠️ **Sin límite**: Puede traer 10,000 documentos en una query
- ❌ **Sin paginación**: Consume lecturas innecesarias
- ⚠️ Requiere índices compuestos: `(orgId, assetType, cityId)`

**Costo estimado:**
- Org pequeña (100 assets): 100 lecturas por query
- Org grande (10,000 assets): **10,000 lecturas por query** 💸

#### Maintenance (maintenance_remote_ds.dart)
```dart
// Incidencias
db.collection('incidencias')
  .where('orgId', isEqualTo: orgId)
  .where('assetId', isEqualTo: assetId)
  .where('cityId', isEqualTo: cityId)
  .get();
```

**Evaluación:**
- ✅ Filtra por `orgId`
- ❌ **Sin límite ni paginación**
- ⚠️ Queries repetitivas para programación/proceso/finalizado

**Problema de escalabilidad:**
- 4 colecciones separadas (programming, process, finished, incidencias)
- Cada query trae TODOS los documentos
- En 1 año de operación: 10,000+ documentos por org

#### Chat (chat_remote_ds.dart)
```dart
// Mensajes por chat
db.collection('chat_messages')
  .where('chatId', isEqualTo: chatId)
  .orderBy('timestamp', descending: false)
  .get();
```

**Evaluación:**
- ✅ Usa `orderBy` (bueno para UI)
- ❌ **SIN LÍMITE**: Trae TODOS los mensajes históricos
- ❌ **Sin paginación**: Chat con 10,000 mensajes = 10,000 lecturas

**Crítico:** En un chat con 1 año de uso, cada vez que un usuario abre el chat se leen miles de documentos.

#### Memberships (user_remote_ds.dart)
```dart
// Membresías de usuario
db.collection('memberships')
  .where('userId', isEqualTo: uid)
  .get();
```

**Evaluación:**
- ✅ Query simple y eficiente
- ✅ Bajo volumen (típicamente < 10 memberships por user)

---

## 📈 3. Escalabilidad

### 3.1 Proyección de Costos

#### Escenario 1: Startup (100 orgs, 10,000 assets totales)
```
Consultas diarias:
- Assets: 100 orgs × 10 queries/día × 100 docs = 100,000 lecturas/día
- Maintenance: 50 orgs × 5 queries/día × 200 docs = 50,000 lecturas/día
- Chat: 200 users × 3 chats/día × 500 msgs = 300,000 lecturas/día

Total: ~450,000 lecturas/día
Costo mensual: 450k × 30 = 13.5M lecturas = $0 (dentro free tier)
```

#### Escenario 2: Crecimiento (1,000 orgs, 100,000 assets)
```
Consultas diarias:
- Assets: 1,000 orgs × 10 queries/día × 100 docs = 1,000,000 lecturas/día
- Maintenance: 500 orgs × 5 queries/día × 500 docs = 1,250,000 lecturas/día
- Chat: 2,000 users × 3 chats/día × 1,000 msgs = 6,000,000 lecturas/día

Total: ~8.25M lecturas/día
Costo mensual: 8.25M × 30 = 247.5M lecturas = $49.50/mes 💰
```

#### Escenario 3: Escala (10,000 orgs, 1M assets)
```
Consultas diarias:
- Assets: 10,000 orgs × 10 queries/día × 100 docs = 10,000,000 lecturas/día
- Maintenance: 5,000 orgs × 5 queries/día × 1,000 docs = 25,000,000 lecturas/día
- Chat: 20,000 users × 3 chats/día × 2,000 msgs = 120,000,000 lecturas/día

Total: ~155M lecturas/día
Costo mensual: 155M × 30 = 4,650M lecturas = $930/mes 💸💸💸
```

**Conclusión:** Sin paginación, los costos crecen linealmente con el uso histórico.

### 3.2 Límites de Firestore

| Límite | Valor | Impacto en Avanzza |
|--------|-------|-------------------|
| Writes/segundo por documento | 1 write/sec | ⚠️ Assets muy activos pueden chocar |
| Reads/segundo | Sin límite | ✅ OK |
| Queries/segundo | Sin límite | ✅ OK |
| Tamaño documento | 1 MB | ✅ OK (modelos pequeños) |
| Subcollections | Sin límite | ⚠️ No se están usando |
| Colecciones root | Sin límite | ✅ OK |

---

## 🎯 4. Mejores Prácticas - Comparación

### 4.1 Particionamiento

| Práctica | Avanzza Actual | Recomendado | Status |
|----------|----------------|-------------|--------|
| Multi-tenancy por `orgId` | ✅ Implementado | ✅ | ✅ BIEN |
| Subcollections por org | ❌ No | ✅ `/organizations/{orgId}/assets/` | ⚠️ MEJORAR |
| Collection group queries | ❌ No disponible | ✅ Con subcollections | ⚠️ MEJORAR |

### 4.2 Queries

| Práctica | Avanzza Actual | Recomendado | Status |
|----------|----------------|-------------|--------|
| Límites en queries | ❌ Sin límite | ✅ `.limit(50)` | ❌ CRÍTICO |
| Paginación | ❌ No | ✅ `startAfter()` | ❌ CRÍTICO |
| Índices compuestos | ⚠️ Implícitos | ✅ Definidos en firestore.indexes.json | ⚠️ PENDIENTE |
| Cache de lectura | ✅ Isar local | ✅ | ✅ BIEN |

### 4.3 Datos Históricos

| Práctica | Avanzza Actual | Recomendado | Status |
|----------|----------------|-------------|--------|
| TTL (Time To Live) | ❌ No | ✅ Cloud Functions cleanup | ❌ CRÍTICO |
| Archiving | ❌ No | ✅ Move to Cloud Storage | ⚠️ FUTURO |
| Soft delete | ❌ Delete directo | ✅ `deletedAt` timestamp | ⚠️ MEJORAR |

---

## 🚨 5. Problemas Críticos Identificados

### 5.1 Sin Paginación en Chat (CRÍTICO)

**Archivo:** `lib/data/sources/remote/chat_remote_ds.dart:10-17`

```dart
// ❌ PROBLEMA: Trae TODOS los mensajes
Future<List<ChatMessageModel>> messagesByChat(String chatId) async {
  final snap = await db
      .collection('chat_messages')
      .where('chatId', isEqualTo: chatId)
      .orderBy('timestamp', descending: false)
      .get();  // ← Sin límite
  return snap.docs.map((d) => ChatMessageModel.fromFirestore(d.id, d.data())).toList();
}
```

**Impacto:**
- Chat con 5,000 mensajes = 5,000 lecturas cada vez que se abre
- Usuario activo con 10 chats = 50,000 lecturas al día
- Costo: $10/mes por usuario activo 💸

**Solución:**
```dart
// ✅ SOLUCIÓN: Paginación con límite
Future<List<ChatMessageModel>> messagesByChat(
  String chatId, {
  int limit = 50,
  DocumentSnapshot? startAfter,
}) async {
  Query q = db
      .collection('chat_messages')
      .where('chatId', isEqualTo: chatId)
      .orderBy('timestamp', descending: true)  // Más recientes primero
      .limit(limit);

  if (startAfter != null) {
    q = q.startAfterDocument(startAfter);
  }

  final snap = await q.get();
  return snap.docs.map((d) => ChatMessageModel.fromFirestore(d.id, d.data())).toList();
}
```

### 5.2 Sin Límites en Assets (CRÍTICO)

**Archivo:** `lib/data/sources/remote/asset_remote_ds.dart:14-25`

```dart
// ❌ PROBLEMA: Puede traer 10,000+ assets
Future<List<AssetModel>> listAssetsByOrg(String orgId,
    {String? assetType, String? cityId}) async {
  Query q = db.collection('assets').where('orgId', isEqualTo: orgId);
  if (assetType != null) q = q.where('assetType', isEqualTo: assetType);
  if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
  final snap = await q.get();  // ← Sin límite
  return snap.docs.map(...).toList();
}
```

**Solución:**
```dart
// ✅ SOLUCIÓN: Paginación
Future<List<AssetModel>> listAssetsByOrg(
  String orgId, {
  String? assetType,
  String? cityId,
  int limit = 100,
  DocumentSnapshot? startAfter,
}) async {
  Query q = db
      .collection('assets')
      .where('orgId', isEqualTo: orgId);

  if (assetType != null) q = q.where('assetType', isEqualTo: assetType);
  if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

  q = q.orderBy('createdAt', descending: true).limit(limit);

  if (startAfter != null) {
    q = q.startAfterDocument(startAfter);
  }

  final snap = await q.get();
  return snap.docs.map(...).toList();
}
```

### 5.3 Maintenance en 4 Colecciones Separadas (INEFICIENTE)

**Archivos:** `maintenance_remote_ds.dart`

```dart
// ❌ PROBLEMA: 4 queries separadas para ver el ciclo completo
incidencias()          // Query 1
programaciones()       // Query 2
procesos()             // Query 3
finalizados()          // Query 4
```

**Impacto:**
- Ver el estado completo de mantenimiento = 4 queries
- Duplica índices necesarios
- Dificulta reportes aggregados

**Solución 1: Una sola colección con `status`**
```dart
// Colección unificada: maintenance_records
{
  "id": "maint_001",
  "orgId": "org_123",
  "assetId": "asset_456",
  "status": "incidencia" | "programado" | "en_proceso" | "finalizado",
  "type": "preventivo" | "correctivo",
  "createdAt": timestamp,
  "updatedAt": timestamp
}

// Query unificada
db.collection('maintenance_records')
  .where('orgId', isEqualTo: orgId)
  .where('status', isEqualTo: 'en_proceso')
  .orderBy('updatedAt', descending: true)
  .limit(50)
  .get();
```

**Solución 2: Subcollections** (más escalable)
```dart
// /organizations/{orgId}/maintenance/{maintenanceId}
// Ventajas:
// - Partition key natural (orgId)
// - Permisos granulares en Security Rules
// - Collection group queries cross-org cuando sea necesario
```

### 5.4 Sin Índices TTL (Time To Live)

**Problema:** Datos históricos se acumulan infinitamente.

**Ejemplos críticos:**
- Chat messages más de 1 año
- AI predictions antiguas
- Logs de auditoría

**Solución:** Cloud Functions con cron job
```javascript
// functions/src/cleanup.js
exports.cleanupOldMessages = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const cutoff = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 365 * 24 * 60 * 60 * 1000) // 1 año
    );

    const snapshot = await db
      .collection('chat_messages')
      .where('timestamp', '<', cutoff)
      .limit(500)
      .get();

    const batch = db.batch();
    snapshot.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();

    console.log(`Deleted ${snapshot.size} old messages`);
  });
```

---

## 🏆 6. Recomendaciones Priorizadas

### 🔴 Prioridad CRÍTICA (Implementar AHORA)

#### 1. Agregar Paginación a Todas las Queries
**Impacto:** Reduce costos 80-90%
**Esfuerzo:** 2-3 días
**Archivos afectados:**
- `asset_remote_ds.dart`
- `maintenance_remote_ds.dart`
- `chat_remote_ds.dart`
- `accounting_remote_ds.dart`
- `purchase_remote_ds.dart`

**Implementación:**
```dart
// Patrón estándar para todos los data sources
Future<PaginatedResult<T>> list({
  required String orgId,
  int limit = 50,
  DocumentSnapshot? startAfter,
  Map<String, dynamic>? filters,
}) async {
  Query q = db.collection('collection_name')
      .where('orgId', isEqualTo: orgId)
      .orderBy('createdAt', descending: true)
      .limit(limit);

  if (startAfter != null) {
    q = q.startAfterDocument(startAfter);
  }

  // Aplicar filtros adicionales
  filters?.forEach((key, value) {
    if (value != null) q = q.where(key, isEqualTo: value);
  });

  final snap = await q.get();

  return PaginatedResult(
    items: snap.docs.map((d) => fromFirestore(d)).toList(),
    lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
    hasMore: snap.docs.length == limit,
  );
}
```

#### 2. Implementar Límites por Defecto
**Impacto:** Previene queries accidentales costosas
**Esfuerzo:** 1 día

```dart
// Wrapper global
class SafeFirestore {
  static const defaultLimit = 100;
  static const maxLimit = 1000;

  static Query applyLimit(Query q, int? userLimit) {
    final limit = userLimit ?? defaultLimit;
    if (limit > maxLimit) {
      throw ArgumentError('Limit exceeds maximum of $maxLimit');
    }
    return q.limit(limit);
  }
}
```

#### 3. Crear firestore.indexes.json
**Impacto:** Evita errores en producción, queries más rápidas
**Esfuerzo:** 2 horas

```json
{
  "indexes": [
    {
      "collectionGroup": "assets",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "orgId", "order": "ASCENDING" },
        { "fieldPath": "assetType", "order": "ASCENDING" },
        { "fieldPath": "cityId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "chat_messages",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "chatId", "order": "ASCENDING" },
        { "fieldPath": "timestamp", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "incidencias",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "orgId", "order": "ASCENDING" },
        { "fieldPath": "assetId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

### 🟡 Prioridad ALTA (Próximas 2-4 semanas)

#### 4. Migrar a Subcollections para Particionamiento

**Ventajas:**
- Mejor particionamiento (evita hot spots)
- Security Rules más granulares
- Queries más eficientes

**Estructura propuesta:**
```
/organizations/{orgId}/
  ├── assets/{assetId}
  ├── maintenance/{maintenanceId}
  ├── accounting/{entryId}
  └── chats/{chatId}/
      └── messages/{messageId}
```

**Migración gradual:**
1. Crear nuevas subcollections
2. Dual-write (ambas estructuras)
3. Migrar datos históricos con Cloud Functions
4. Deprecar colecciones flat
5. Eliminar código legacy

**Esfuerzo:** 2-3 sprints (6-9 semanas)

#### 5. Unificar Colecciones de Maintenance

**De:**
- `incidencias/`
- `maintenance_programming/`
- `maintenance_process/`
- `maintenance_finished/`

**A:**
- `maintenance_records/` con campo `status`

**Ventajas:**
- 1 query en lugar de 4
- Índices más simples
- Reportes agregados más fáciles

**Esfuerzo:** 1 sprint (3 semanas)

#### 6. Implementar TTL para Datos Históricos

**Cloud Functions para limpieza automática:**
```javascript
// Ejecutar diariamente
- chat_messages > 1 año → delete
- ai_predictions > 6 meses → delete
- ai_audit_logs > 1 año → archive to Cloud Storage
```

**Esfuerzo:** 1 semana

### 🟢 Prioridad MEDIA (Próximos 3-6 meses)

#### 7. Agregar Soft Delete

```dart
// En lugar de delete directo
await db.collection('assets').doc(assetId).delete();

// Usar soft delete
await db.collection('assets').doc(assetId).update({
  'deletedAt': FieldValue.serverTimestamp(),
  'deletedBy': userId,
});

// En queries, excluir deleted
q = q.where('deletedAt', isNull: true);
```

**Ventajas:**
- Recuperación de datos accidental
- Auditoría completa
- Compliance con GDPR (derecho al olvido)

#### 8. Implementar Aggregation Queries

**Problema actual:** Para dashboards, se traen todos los docs y se cuenta en cliente.

**Solución:** Firestore Count() Aggregations
```dart
final count = await db
    .collection('assets')
    .where('orgId', isEqualTo: orgId)
    .count()
    .get();

print('Total assets: ${count.count}');
```

**Ventaja:** 1 lectura en lugar de N lecturas.

#### 9. Monitoring y Alertas

**Implementar:**
- Firebase Performance Monitoring
- Cloud Monitoring dashboards
- Alertas de costo (>$X/día)
- Slow query tracking

---

## 📋 7. Plan de Acción - Roadmap

### Sprint 1-2 (Semanas 1-2) - CRÍTICO
- [ ] Agregar paginación a `chat_remote_ds.dart`
- [ ] Agregar paginación a `asset_remote_ds.dart`
- [ ] Agregar paginación a `maintenance_remote_ds.dart`
- [ ] Crear `firestore.indexes.json`
- [ ] Implementar límites por defecto en queries

### Sprint 3-4 (Semanas 3-4) - ALTA
- [ ] Implementar `PaginatedResult<T>` genérico
- [ ] Refactorizar UI para scroll infinito (en lugar de traer todo)
- [ ] Testing de queries paginadas
- [ ] Deploy de índices a producción

### Sprint 5-6 (Semanas 5-6) - ALTA
- [ ] Cloud Function para TTL de chat messages
- [ ] Cloud Function para TTL de AI predictions
- [ ] Monitoring y alertas de costos

### Sprint 7-12 (Semanas 7-12) - MEDIA
- [ ] Diseño de migración a subcollections
- [ ] Dual-write implementation
- [ ] Migración gradual de datos

### Backlog (3-6 meses)
- [ ] Soft delete implementation
- [ ] Aggregation queries
- [ ] Archiving a Cloud Storage
- [ ] Collection group queries

---

## 💰 8. Estimación de Ahorro de Costos

### Implementando Prioridad CRÍTICA (Paginación + Límites)

| Escenario | Antes (lecturas/mes) | Después (lecturas/mes) | Ahorro |
|-----------|----------------------|------------------------|--------|
| Startup (100 orgs) | 13.5M | 2.7M | **80%** ($0 → $0) |
| Crecimiento (1k orgs) | 247.5M | 49.5M | **80%** ($49 → $10) |
| Escala (10k orgs) | 4,650M | 930M | **80%** ($930 → $186) |

### Implementando Prioridad ALTA (TTL + Unificación)

| Escenario | Antes (lecturas/mes) | Después (lecturas/mes) | Ahorro |
|-----------|----------------------|------------------------|--------|
| Crecimiento (1k orgs) | 49.5M | 35M | **30%** adicional |
| Escala (10k orgs) | 930M | 650M | **30%** adicional |

**Ahorro total combinado: ~85-90%** 🎉

---

## 🎓 9. Mejores Prácticas - Checklist

### Para Nuevas Colecciones

```
□ ¿Tiene filtro por orgId?
□ ¿Tiene paginación (.limit() + startAfter)?
□ ¿Tiene índices compuestos definidos?
□ ¿Tiene orderBy para UI consistente?
□ ¿Tiene TTL o estrategia de cleanup?
□ ¿Tiene timestamps (createdAt, updatedAt)?
□ ¿Tiene soft delete (deletedAt)?
□ ¿Está en subcollection si es >1000 docs/org?
```

### Para Nuevas Queries

```
□ ¿Tiene límite explícito?
□ ¿Tiene paginación si retorna lista?
□ ¿Filtra por orgId primero?
□ ¿Usa cache cuando es apropiado?
□ ¿Tiene índice compuesto si usa múltiples where?
□ ¿Maneja el caso de 0 resultados?
□ ¿Tiene timeout razonable?
```

---

## 🔗 10. Referencias

### Documentación Firebase
- [Best Practices for Cloud Firestore](https://firebase.google.com/docs/firestore/best-practices)
- [Understanding Firestore Pricing](https://firebase.google.com/docs/firestore/pricing)
- [Firestore Query Indexes](https://firebase.google.com/docs/firestore/query-data/indexing)
- [Paginating Data with Query Cursors](https://firebase.google.com/docs/firestore/query-data/query-cursors)

### Tools
- [Firebase Console](https://console.firebase.google.com)
- [Firestore Usage Dashboard](https://console.cloud.google.com/firestore/usage)
- [Cloud Monitoring](https://console.cloud.google.com/monitoring)

---

## ✅ 11. Conclusión

### Estado Actual: **6.5/10** - BUENO pero necesita optimización

**Fortalezas:**
- ✅ Arquitectura multi-tenant bien implementada
- ✅ Offline-first reduce lecturas
- ✅ Estructura lógica y limpia

**Debilidades Críticas:**
- ❌ Sin paginación → costos altos a escala
- ❌ Sin límites → queries impredecibles
- ❌ Sin TTL → acumulación infinita de datos

### Recomendación: **Implementar correcciones críticas ANTES de escalar**

Si se implementan las prioridades CRÍTICA y ALTA, el score subiría a **9/10** y la base de datos estaría lista para escalar a 10,000+ organizaciones con costos predecibles y rendimiento óptimo.

**Próximos pasos inmediatos:**
1. Crear ticket/issue para paginación
2. Implementar límites por defecto
3. Crear firestore.indexes.json
4. Configurar monitoring de costos

---

**Análisis realizado por:** Claude (Anthropic)
**Contacto para dudas:** Ver issues en el repositorio
**Última actualización:** 2025-10-16
