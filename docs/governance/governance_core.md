# GOVERNANCE_CORE.md

## Avanzza 2.0 — Gobernanza Core y Estándares de Arquitectura

> **TIPO:** Documento de Gobernanza Constitutivo
> **ESTADO:** ACTIVO / VIGENTE
> **VERSIÓN:** 1.0.0
> **AUTORIDAD:** SUPREMA (Aplica a Humanos e IA)

---

## 1. PROPÓSITO Y AUTORIDAD

Este documento define la **gobernanza constitucional y no negociable** de Avanzza 2.0.

Establece las **reglas de máxima autoridad** que aplican a:

- Todos los dominios, módulos y espacios de trabajo (workspaces).
- Todo el código escrito por humanos.
- Todo el código generado por IA (Claude, ChatGPT, Gemini, Copilot, etc.).

**Reglas de Autoridad:**

- Este documento aplica **por igual a humanos e IAs**.
- Cualquier violación de reglas marcadas como **[CRÍTICO]** es motivo de rechazo inmediato.
- **Precedencia:** Este documento tiene precedencia sobre `DOMAIN_CONTRACTS`, `UI_CONTRACTS` y cualquier guía de implementación.
- Si algún requerimiento entra en conflicto con este documento, **este documento siempre gana**.
- Este archivo es **INMUTABLE** para las operaciones diarias; los cambios requieren aprobación de la Junta de Arquitectura.

---

## 2. PRINCIPIOS FUNDAMENTALES (INVARIANTES DE NEGOCIO)

### 2.1 Producto Asset-First (Activo-Primero) [CRÍTICO]

El **Activo (Asset)** es la abstracción de negocio primaria en Avanzza 2.0. Representa **valor económico**, no solo un objeto físico.

**Reglas:**

- `assetId` es el **identificador canónico**.
- `assetId ≠ vehicleId` (Nunca son intercambiables. Un vehículo es una especialización/proyección de un Activo).
- Ningún dominio, caso de uso o flujo de UI puede operar sin el contexto del activo cuando este aplique.

### 2.2 Sistema con Alcance Organizacional [CRÍTICO]

Avanzza es un sistema **multi-organización por diseño**.

**Reglas:**

- Toda operación DEBE estar delimitada por `orgId`.
- Las lecturas o escrituras cruzadas entre organizaciones están **PROHIBIDAS**.
- El aislamiento de datos es una invariante dura, no una configuración.

### 2.3 Conciencia Geográfica

**Reglas:**

- `countryId` es **REQUERIDO** para operaciones con impacto legal, fiscal o regulatorio.
- `cityId` es **REQUERIDO** para reglas de circulación, rutas, zonificación o localidad.
- El contexto geográfico **nunca se infiere implícitamente**.

### 2.4 Offline-First y Resolución de Conflictos

**Reglas:**

- **Local-First:** Las lecturas DEBEN servirse desde la persistencia local (Isar/SQLite).
- **Write-Local:** Las escrituras DEBEN persistir localmente antes de cualquier sincronización en la nube.
- **Sincronización Asíncrona:** La sincronización con la nube es asíncrona y no bloqueante.
- **Estrategia de Conflicto (v1.x):** El `updatedAt` más reciente gana. (Deuda Técnica Intencional).

---

## 3. GOBERNANZA ARQUITECTÓNICA (INVARIANTES TÉCNICAS)

### 3.1 Ley de Clean Architecture (Arquitectura Limpia) [CRÍTICO]

El sistema está **estrictamente estratificado**. Las dependencias fluyen **solo hacia adentro**.

1.  **Presentación (UI)** → depende de Dominio
2.  **Datos (Infraestructura)** → depende de Dominio
3.  **Dominio (Lógica Core)** → NO depende de NADA externo (Puro Dart/TS)
4.  **Core (Compartido)** → Transversal, independiente de las capas funcionales

**Flujos de Dependencia Prohibidos:**

- ❌ Dominio importando implementaciones de Datos (ej. `AssetEntity` importando `AssetDTO`).
- ❌ Dominio importando frameworks de UI (Flutter, Material, React).
- ❌ UI accediendo directamente a Base de Datos, Firestore o APIs.

### 3.2 Modelo de Fallos y Seguridad [CRÍTICO]

**Reglas:**

- **Política No-Throw:** La lógica de dominio NO DEBE lanzar excepciones. Retornar `Result<T, Failure>`.
- **Defaults A Prueba de Fallos:** Datos faltantes o inválidos resultan en valores por defecto seguros, no en cierres inesperados (crashes).
- **Errores Tipados:** Los errores deben mapearse a fallos específicos del dominio (ej. `CacheFailure`, `PermissionFailure`), nunca excepciones crudas.

---

## 4. ESTRUCTURA DE ARCHIVOS Y DIRECTORIOS (OBLIGATORIO)

El proyecto DEBE seguir esta estructura canónica para asegurar previsibilidad.

```text
lib/
├── core/                       # [COMPARTIDO] Intereses transversales (Seguro de depender)
│   ├── identifiers/            # Objetos de Valor (AssetId, OrgId, CountryId)
│   ├── contracts/              # Interfaces compartidas, DTOs (genéricos), tipos Result
│   ├── errors/                 # Modelos de error seguros para el dominio
│   └── time/                   # Políticas temporales (Reloj, utilidades UTC)
│
├── domain/                     # [PURO] Lógica de Negocio
│   ├── entities/               # Entidades de dominio ricas (comportamiento + invariantes)
│   ├── policies/               # Reglas de negocio puras (lógica sin estado)
│   ├── repositories/           # Interfaces SOLAMENTE (sin implementaciones)
│   └── use_cases/              # Reglas de negocio específicas de la aplicación
│
├── data/                       # [IMPURO] Implementaciones
│   ├── dtos/                   # Objetos de Transferencia de Datos (lógica de serialización)
│   ├── mappers/                # Convertidores Entidad <-> DTO
│   └── repositories/           # Implementaciones de los Repositorios
│
└── presentation/               # [UI] Capa visual y de interacción
    ├── components/             # Widgets reutilizables (tontos)
    ├── pages/                  # Pantallas/Rutas
    └── state/                  # Gestión de Estado (Bloc/Cubit)
```

---

## 5. CONVENCIONES DE NOMENCLATURA [OBLIGATORIO]

La IA y los Desarrolladores DEBEN adherirse estrictamente a estos sufijos para mantener la claridad.

| Componente                 | Convención                  | Ejemplo                                         |
| :------------------------- | :-------------------------- | :---------------------------------------------- |
| **Entidad de Dominio**     | PascalCase (Sin Sufijo)     | `Asset`, `MaintenanceTicket`                    |
| **Caso de Uso**            | Verbo + Entidad + `UseCase` | `CreateAssetUseCase`, `GetAssetByIdUseCase`     |
| **Repositorio (Interfaz)** | Entidad + `Repository`      | `AssetRepository`                               |
| **Repositorio (Impl)**     | Entidad + `RepositoryImpl`  | `AssetRepositoryImpl`                           |
| **Fuente de Datos**        | Fuente + `DataSource`       | `AssetRemoteDataSource`, `AssetLocalDataSource` |
| **DTO**                    | Entidad + `Dto`             | `AssetDto`                                      |
| **Controlador/Cubit**      | Entidad/Feature + `Cubit`   | `AssetDetailCubit`                              |
| **Página/Pantalla**        | Feature + `Page`            | `AssetDetailPage`                               |

---

## 6. ESTÁNDARES DE CÓDIGO

### 6.1 Inmutabilidad y Null Safety

- **Inmutable por Defecto:** Todas las Entidades, Estados y DTOs DEBEN ser `final`.
- **Sin Operador Bang (`!`):** Estrictamente prohibido en código de producción. Usar `?` o guardas explícitas.
- **Constructores Const:** Usar `const` siempre que sea posible en widgets de UI.

### 6.2 Serialización de Datos

- **Enums Estables (Wire-Stable):** NUNCA serializar enums por índice. Usar códigos explícitos (string o int) definidos en contrato.
- **Lógica Desacoplada:** `fromJson`/`toJson` pertenece a la **Capa de Datos (DTOs)**, NUNCA a las Entidades de Dominio.

---

## 7. TERMINOLOGÍA CANÓNICA

| Término       | Significado Estricto                                              |
| :------------ | :---------------------------------------------------------------- |
| **User**      | Una cuenta registrada en Avanzza.                                 |
| **Role**      | Una responsabilidad funcional de un Usuario dentro de una Org.    |
| **Workspace** | El contexto operativo para un Rol específico.                     |
| **Asset**     | Una unidad económica gestionada (El Core).                        |
| **Vehicle**   | Una máquina física (Una especialización/proyección de un Activo). |

**Términos Prohibidos:** Actor, Usuario Global, Activo Universal.

---

**FIN DE GOVERNANCE_CORE**
