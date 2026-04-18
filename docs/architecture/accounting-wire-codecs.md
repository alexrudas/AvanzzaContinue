# Accounting Wire Codecs

**Estado:** vigente · **Versión:** 1.0 · **Última revisión:** 2026-04-18

Cierre del ticket CI "Uso de `.wire` detectado" en `accounting`. Describe la
fuente única de verdad para el mapping `enum ↔ string` de los enums del
módulo accounting que se persisten en Isar.

## Contexto

`DOMAIN_CONTRACTS.md` v1.1.3 §B/§C prohíbe usar `.wire` o `.wireName` como
contrato de persistencia. Los enums `OutboxStatus` y `ARProjectionEstado`
exponían en el dominio una extension con `get wire` y `static fromWire(...)`
usada por `toJson` manual, mappers Isar y queries — 13 callsites en total.
Eso era una segunda fuente de verdad incrustada en el dominio.

## Decisión arquitectónica

- **Estrategia:** fix mínimo — codec explícito fuera del dominio.
- **Descartados:** `@JsonValue`, freezed/codegen, migración de datos, rename
  de columnas Isar, migración de schema. Justificación extendida en el hilo
  de PR.

## Fuente única del mapping

| Enum | Codec canónico |
| --- | --- |
| `OutboxStatus` | `lib/infrastructure/isar/codecs/outbox_status_codec.dart` |
| `ARProjectionEstado` | `lib/infrastructure/isar/codecs/ar_projection_estado_codec.dart` |

Cada codec expone:

- `encode(Enum) → String` — escritura en Isar.
- `decode(String) → Enum` — lectura de Isar; **fail-hard** con
  `FormatException` ante desconocido, vacío o casing distinto.
- `isValid(String) → bool` — guard no destructivo para mappers.

**Estos archivos son los únicos autorizados a contener el mapping.** Cualquier
PR que introduzca strings de estos enums fuera del codec debe ser rechazado.

## Strings wire legacy (inmutables)

| Enum | Wires persistidos |
| --- | --- |
| `OutboxStatus` | `pending`, `synced`, `error` |
| `ARProjectionEstado` | `abierta`, `cerrada`, `ajustada` |

Son exactamente los strings ya escritos por `OutboxStatusX.wire` y
`ARProjectionEstadoX.wire` antes del refactor. Cambiarlos implica migración
de datos y NO es un cambio de codec, es un cambio de schema.

## Reglas de uso

1. **Dominio (`lib/domain/entities/accounting/`):** no contiene ni `.wire`
   ni `fromWire`. No serializa manualmente. No importa el codec.
   **Decisión explícita:** `OutboxEvent` y `AccountReceivableProjection` ya
   no exponen `toJson`/`fromJson`. El dominio ya no serializa directamente
   estos modelos. La serialización, si se requiere, debe realizarse vía
   mappers externos (hoy: mappers de infraestructura Isar; a futuro:
   cualquier serializer nuevo fuera del dominio). Reintroducir `toJson`/
   `fromJson` en el dominio volvería a crear una segunda fuente del mapping
   enum ↔ string — **prohibido**.
2. **Mappers Isar (`lib/infrastructure/isar/entities/*`):** llaman al codec
   en `..statusWire = encode(...)` y en `decode(entity.statusWire)`. Los
   getters `statusEnum`/`estadoEnum` delegan al codec.
3. **Repositorio (`lib/infrastructure/isar/repositories/...`):**
   - Escrituras: `encode(...)`.
   - Queries Isar por igualdad: `encode(...)` (Isar no indexa enums Dart).
   - Lógica de negocio que compara estados: `decode(e.statusWire) == Enum.x`
     (comparación por identidad, no por string).

## Guardrails

- **Test arquitectural:**
  `test/architecture/accounting_wire_contracts_test.dart` escanea
  `lib/domain/entities/accounting/` y rompe si aparece `.wire`, `get wire`
  o `fromWire`.
- **Test de compatibilidad legacy:**
  `test/infrastructure/isar/entities/accounting_wire_compatibility_test.dart`
  congela los 6 strings legacy, verifica round-trip domain↔entity y falla
  ante corrupción (casing distinto, vacío).
- **Tests de codec:** cada codec tiene su test
  (`encode`, `decode`, `isValid`, round-trip, fail-hard).

## Cómo ampliar

- **Añadir un valor al enum:** agregar el case en `encode`, `decode`,
  `isValid` del codec. Añadir el test. Ningún otro archivo cambia.
- **Añadir un enum nuevo en accounting:** crear un nuevo codec
  `*_codec.dart` en `lib/infrastructure/isar/codecs/` siguiendo el patrón
  de los existentes. No replicar mapping en el enum de dominio.

## Lo que **no** es este codec

- No reemplaza `@JsonValue`: cuando un enum tenga serialización canónica
  generada (ej. modelos freezed con `toJson`/`fromJson`), esa anotación es
  la fuente autoritativa según §A. El codec solo aplica al **mapping
  persistente de Isar** para enums que no pasan por codegen.
- No es para logs/debug: para eso la gobernanza reserva `wireName` (que no
  existe aquí porque no hay necesidad actual de esa representación
  independiente). Si llega a necesitarse, se define en el enum como getter
  de dominio — nunca mezclar con el codec.
