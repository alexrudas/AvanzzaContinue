# PRODUCT CONTRACT: Assets & Directory v1.0

> **Documento canónico de arquitectura para el módulo de Activos en Avanzza 2.0**
>
> Fecha: 2026-02-01
> Versión: 1.0
> Estado: ACTIVO

---

## 1. RUTAS CANÓNICAS FIRESTORE

### 1.1 Colección Principal de Activos

```
/assets/{assetId}
```

**El documento raíz /assets/{assetId} contiene SOLO el estado actual del Asset.
Todo historial vive exclusivamente en subcolecciones (audit_log, accounting).**

**Campos obligatorios:**
- `id`: String (UUID v4)
- `assetKey`: String (código legible único, ej: "VEH-ABC123")
- `type`: String ("vehicle" | "real_estate" | "machinery" | "equipment")
- `state`: String ("DRAFT" | "PENDING_OWNERSHIP" | "VERIFIED" | "ACTIVE" | "ARCHIVED")
- `content`: Map (polimórfico según `type`, incluye `runtimeType` discriminador)
- `legalOwner`: Map (propietario legal según fuente oficial)
- `beneficialOwner`: Map (propietario beneficiario en Avanzza)
- `createdAt`: Timestamp
- `updatedAt`: Timestamp

---

### 1.2 Subcolecciones de Asset

#### Control de Acceso
```
/assets/{assetId}/access/{principalId}
```

**REGLA CRÍTICA: beneficialOwner NO implica permisos operativos.
Los permisos efectivos se determinan únicamente en /assets/{assetId}/access/{principalId}.**

**Campos:**
- `principalId`: String
- `principalType`: String ("user" | "org")
- `role`: String ("owner" | "manager" | "operator" | "viewer")
- `permissions`: List<String>
- `grantedBy`: String
- `grantedAt`: Timestamp

---

#### Log de Auditoría (Append-Only)
```
/assets/{assetId}/audit_log/{logId}
```

**Campos:**
- `id`: String (UUID v4)
- `eventType`: String
- `actorId`: String
- `actorType`: String ("user" | "system" | "sync")
- `payload`: Map
- `previousState`: String?
- `newState`: String?
- `timestamp`: Timestamp
- `source`: String ("mobile" | "web" | "api" | "sync")

**REGLA: APPEND-ONLY - NUNCA eliminar ni modificar.**

---

#### Documentos Asociados
```
/assets/{assetId}/documents/{docId}
```

**Campos:**
- `id`: String
- `documentType`: String
- `status`: String
- `startDate`, `endDate`: Timestamp?
- `daysToExpire`: int?
- `referenceNumber`, `provider`: String?
- `source`: String
- `fileUrl`: String?

---

#### Mantenimiento
```
/assets/{assetId}/maintenance/{logId}
```

---

#### Contabilidad (Append-Only)
```
/assets/{assetId}/accounting/{entryId}
```

---

### 1.3 Referencias de Usuario

```
/users/{userId}/asset_refs/{assetId}
```

Índice invertido para acceso rápido.

---

### 1.4 Directorio de Proveedores

```
/directories/service_providers/{userId}
```

**REGLA DE PRIVACIDAD: El directorio contiene SOLO datos públicos.
Nunca emails privados, teléfonos personales ni documentos.**

---

## 2. DEFINICIONES DE DOMINIO

### 2.1 Asset

Entidad principal de activo físico con contenido polimórfico.

### 2.2 AssetDraft

Estado temporal antes de confirmar propiedad. **DEBE eliminarse tras conversión.**

### 2.3 AssetSnapshot

Captura inmutable de datos externos (RUNT, catastro).

### 2.4 AssetContent (Sealed Class Polimórfica)

| Variante | Campos clave |
|----------|--------------|
| VehicleContent | plate, vin, brand, line, model, serviceType |
| RealEstateContent | propertyRegistration, address, area, stratum |
| MachineryContent | serialNumber, brand, capacity, category |
| EquipmentContent | serialNumber, brand, model, category |

**Discriminador JSON:** `runtimeType` serializado automáticamente por Freezed.

### 2.5 LegalOwner vs BeneficialOwner

| Campo | LegalOwner | BeneficialOwner |
|-------|------------|-----------------|
| Fuente | Snapshot oficial (RUNT) | Usuario en Avanzza |
| Editable | NO (solo con nuevo snapshot) | SÍ |
| Puede diferir | - | Sí (leasing, gestión delegada) |

**IMPORTANTE: beneficialOwner indica relación de propiedad/gestión, NO permisos.
Los permisos operativos se definen exclusivamente en la subcolección access.**

### 2.6 Append-Only

audit_log y accounting NUNCA se eliminan. Correcciones via ADJUSTMENT.

### 2.7 Atomic Sync (Batch)

Asset + AuditLog + UserRef viajan JUNTOS en WriteBatch.

---

## 3. ESTADOS DEL CICLO DE VIDA

```
DRAFT → PENDING_OWNERSHIP → VERIFIED → ACTIVE → ARCHIVED
```

| Estado | Sincronizado | Visible |
|--------|--------------|---------|
| DRAFT | No | No |
| PENDING_OWNERSHIP | No | No |
| VERIFIED | Sí | Limitado |
| ACTIVE | Sí | Sí |
| ARCHIVED | Sí | Archivo |

**Transición VERIFIED → ACTIVE:**
VERIFIED → ACTIVE ocurre solo tras confirmación de negocio
o validación administrativa (manual o automática).

---

## 4. EVENTOS DE AUDITORÍA

- CREATED, OWNERSHIP_SET, OWNERSHIP_TRANSFERRED
- STATE_CHANGED, CONTENT_UPDATED
- DOCUMENT_ADDED, DOCUMENT_EXPIRED
- MAINTENANCE_LOGGED
- ACCESS_GRANTED, ACCESS_REVOKED
- SNAPSHOT_REFRESHED
- ARCHIVED, RESTORED

---

## 5. INVARIANTES

1. **Draft Cleanup:** Eliminar tras conversión exitosa.
2. **Audit Always:** Toda operación genera AuditLogEntry.
3. **Atomic Batch:** Asset + AuditLog + UserRef juntos.
4. **Legal Immutable:** LegalOwner solo cambia con nuevo Snapshot.
5. **No Orphans:** Todo Asset tiene BeneficialOwner.
6. **State Machine:** Transiciones válidas únicamente.
7. **Append-Only Inviolable:** audit_log y accounting inmutables.

---

## 6. NOTA DE MIGRACIÓN

**Este contrato introduce un breaking change en persistencia local (Isar).
Durante desarrollo se permite borrar la base local.
No se soporta compatibilidad con esquemas anteriores.**

---

**FIN DEL DOCUMENTO**
