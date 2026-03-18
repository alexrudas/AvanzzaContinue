# Track A — Cierre oficial y congelamiento

| Campo         | Valor                                      |
|---------------|--------------------------------------------|
| **Estado**    | ✅ DONE                                     |
| **Freeze**    | 🔒 FROZEN                                   |
| **Fecha de cierre** | 2026-03-18                           |
| **Módulo**    | Seguros / Asset Detail / Estado del vehículo |
| **Versión de referencia** | Asset OS — Track A Seguros v1 |

---

## Alcance del Track A

Saneamiento completo del modelo de pólizas de seguros para activos vehiculares.
Incluye el refactor del dominio, la corrección de bugs de persistencia, los tiles
dinámicos en el grid "Estado del vehículo" y las detail pages específicas para
SOAT y Seguros RC.

---

## Hechos implementados y cerrados

### A1 — Dominio: `InsurancePolicyType` enum
- Incorporación del enum `InsurancePolicyType` con 6 wire values estables:
  `soat`, `rc_contractual`, `rc_extracontractual`, `todo_riesgo`, `inmueble`, `unknown`
- `fromWireString()` con `.toLowerCase()` para tolerancia al legacy `'SOAT'` mayúsculo
- Getter `policyType` añadido a `InsurancePolicyEntity`

### A2 — Persistencia: `@Index()` en `tipo`
- Anotación `@Index()` sobre el campo `tipo` en `InsurancePolicyModel`
- Cambio aditivo (no breaking), habilita `.tipoEqualTo()` en queries Isar

### A3 — Codegen
- Ejecución de `build_runner` tras A1 y A2

### A4 — Contrato y repositorio: `latestPolicyByTipo()`
- Método `latestPolicyByTipo(assetId, tipo)` añadido al contrato `InsuranceRepository`
- Implementación en `InsuranceLocalDs` con `.tipoEqualTo().sortByFechaFinDesc().limit(1)`
- Wrapper en `InsuranceRepositoryImpl`, fail-silent (null ante error)

### A5 — Fix de persistencia RC
- Corrección del bug crítico en `_buildInsurancePolicies()`: los registros RC
  se persistían con `tipo: 'todo_riesgo'` hardcodeado
- SOAT: `'SOAT'` → `InsurancePolicyType.soat.toWireString()` → `'soat'`
- RC: → helper `_mapRcTipoPoliza(rec['tipoPoliza'])` que detecta
  `'rc_extracontractual'` antes que `'rc_contractual'` (substring containment)
  para evitar falsos positivos

### A6 — Campaign resolver
- Filtro SOAT actualizado: `p.tipo.toUpperCase() == 'SOAT'` → `p.policyType == InsurancePolicyType.soat`

### A7 — Rutas
- `Routes.soatDetail` → `/asset/insurance/soat` → `SoatDetailPage`
- `Routes.segurosRcDetail` → `/asset/insurance/rc` → `SegurosRcDetailPage`
- Ambas registradas en `app_pages.dart`

### A8 — Detail pages específicas

**`SoatDetailPage`**
- Carga pólizas SOAT del activo, filtra por `policyType == soat`
- Sort por `fechaFin` desc; sección "Póliza más reciente" + historial
- Vigencia calculada dinámicamente desde `fechaFin` por fecha calendario local
  (`_calendarDay()` con `.toLocal()` para evitar off-by-one UTC)

**`SegurosRcDetailPage`**
- Dos bloques permanentes y explícitos: **RC Contractual** y **RC Extracontractual**
- Sort determinístico: `fechaFin` calendario local desc → `createdAt` desc → `id` desc
- Banner de inconsistencia solo cuando ambos bloques tienen datos y difieren
  en fecha de vencimiento o aseguradora normalizada
- `_NoDataChip` específico por subtipo cuando un bloque está vacío
- `_calendarDay()` usado uniformemente en sort, vigencia e inconsistencia

### A9 — Tiles dinámicos en el grid "Estado del vehículo"
- `_loadInsurancePolicies()` carga en paralelo (`Future.wait`) SOAT, RCC y RCEC
  usando `latestPolicyByTipo()`; fail-silent
- `_buildSoatModuleDef()`: métrica y severidad calculadas desde `fechaFin`
- `_buildRcModuleDef()`: peor severidad entre RCC y RCEC; métrica del más urgente
- Navegación conectada: tile SOAT → `SoatDetailPage`; tile RC → `SegurosRcDetailPage`

### A10 — Validación estática
- `flutter analyze` ejecutado post-implementación: **cero nuevos errores ni warnings**
  en los 12 archivos del Track A

---

## Separación correcta de RC Contractual y RC Extracontractual

El bug previo persistía todos los registros RC con `tipo: 'todo_riesgo'`.
Tras el fix, el helper `_mapRcTipoPoliza()` clasifica correctamente usando el campo
`tipoPoliza` devuelto por RUNT, evaluando `'extracontractual'` antes que
`'contractual'` para evitar falsos positivos por substring containment.

---

## Flujo de navegación validado

```
Portafolio
  └── Lista de activos
        └── Detalle del activo (Asset OS)
              ├── Tile SOAT       → SoatDetailPage
              ├── Tile Seguros RC → SegurosRcDetailPage (RCC + RCEC agrupados)
              └── Tile RTM        → RtmDetailPage
```

---

## Evidencia funcional validada en uso real

Validación completada sobre **4 vehículos reales**: 3 taxis + 1 vehículo particular.

Los siguientes flujos fueron verificados como operativos en producción:

- ✅ El activo se acepta en el portafolio
- ✅ Aparece correctamente en la lista de activos
- ✅ El detalle del activo se abre sin errores
- ✅ El grid "Estado del vehículo" muestra estados correctos
  (vigente / por vencer / vencido según `fechaFin` calendario local)
- ✅ Tile SOAT: abre `SoatDetailPage` con datos reales y vigencia correcta
- ✅ Tile Seguros RC: abre `SegurosRcDetailPage` mostrando ambas pólizas
  (RC Contractual y RC Extracontractual) correctamente separadas
- ✅ Tile RTM: abre `RtmDetailPage` correctamente (pre-existente, no afectado)
- ✅ Los cálculos de vigencia por fecha calendario local son correctos en todos
  los vehículos probados

---

## Fuera del alcance de Track A (pendiente o cancelado)

| Ítem | Razón |
|------|-------|
| Limpieza manual de registros legacy (`tipo: 'todo_riesgo'`) en activos previos al fix | Requiere intervención manual por activo; no hay flujo automático seguro |
| **Track B**: Seguros Todo Riesgo y Seguros Inmueble | Fuera de alcance Track A; abrirse como Track B |
| Sincronización remota de seguros (Track C) | Fuera de alcance; no autorizado en esta sesión |
| Mejoras UX/UI futuras en las detail pages | Cualquier ajuste debe abrirse como Track A.1 o ticket independiente |
| Formulario manual de pólizas (datos no disponibles en RUNT) | Fuera de alcance |

---

## Regla de congelamiento

> **Track A queda oficialmente cerrado y congelado a partir del 2026-03-18.**

- No se permiten cambios dentro de Track A salvo **bugs críticos** con impacto directo en producción.
- Cualquier mejora, refactor, ampliación o ajuste incremental posterior debe abrirse como:
  - `Track A.1` — corrección puntual o mejora menor dentro del mismo módulo
  - `Track B` — módulo nuevo (Todo Riesgo, Inmueble, sync remoto)
  - Ticket independiente — cambio sin relación directa con seguros/asset detail

---

## Archivos modificados o creados en Track A

| Archivo | Acción | Entregable |
|---------|--------|------------|
| `lib/domain/entities/insurance/insurance_policy_entity.dart` | Modificado | A1 |
| `lib/data/models/insurance/insurance_policy_model.dart` | Modificado | A2 |
| `lib/domain/repositories/insurance_repository.dart` | Modificado | A4 |
| `lib/data/sources/local/insurance_local_ds.dart` | Modificado | A4 |
| `lib/data/repositories/insurance_repository_impl.dart` | Modificado | A4 |
| `lib/data/repositories/asset_repository_impl.dart` | Modificado | A5 |
| `lib/core/campaign/resolver/campaign_resolver.dart` | Modificado | A6 |
| `lib/routes/app_routes.dart` | Modificado | A7 |
| `lib/routes/app_pages.dart` | Modificado | A7 |
| `lib/presentation/pages/asset/soat_detail_page.dart` | Creado | A8 |
| `lib/presentation/pages/asset/seguros_rc_detail_page.dart` | Creado | A8 |
| `lib/presentation/pages/asset/asset_detail_page.dart` | Modificado | A9 |
