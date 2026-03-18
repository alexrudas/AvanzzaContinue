# Avanzza Onboarding Workspace Contract

Versión: 1.1  
Fase: 2 — Registro tipado  
Estado: Borrador aprobado para implementación  
Fecha: 2026-03-15

---

# 1. Contexto

## Problema del modelo antiguo

El sistema de registro original de Avanzza producía como salida principal un campo `selectedRole` de tipo `String`.

Ejemplos:

- "propietario"
- "administrador"
- "proveedor_servicios"

Este valor se propagaba a:

- `RegistrationProgressModel.selectedRole`
- `MembershipEntity.roles[]`
- `UserEntity.activeContext.rol`

Este modelo presenta varios problemas estructurales.

### 1. Sin tipado

Los strings de rol son opacos al compilador.  
Errores tipográficos como `"propietaro"` no generan error en compilación.

### 2. Acoplamiento por substring

El routing se resolvía usando expresiones como:

`rol.contains('propietario')`

Esto introduce ambigüedad y rompe el sistema cuando aparecen variantes.

### 3. Sin semántica de negocio

El rol `"proveedor"` no distingue entre:

- proveedor de artículos
- proveedor de servicios
- empresa vs persona

### 4. Trazabilidad incompleta

El `workspaceId` no puede derivarse de manera determinística únicamente desde un rol string.

### 5. Extensión difícil

Agregar nuevos workspaces (por ejemplo `insurer` o `advisor`) obliga a modificar múltiples capas del sistema.

## Consecuencia

El `SplashBootstrapController` actual requiere una cadena de fallbacks precisamente porque el registro no garantiza que exista un `WorkspaceContext` válido al finalizar el onboarding.

---

# 2. Objetivo de la Fase 2

La Fase 2 transforma el onboarding para que produzca un **contrato tipado**.

El registro debe producir como resultado:

- un `WorkspaceType` canónico
- un `WorkspaceContext` inicial
- un `activeWorkspaceId`
- compatibilidad transicional con el modelo legacy

Al finalizar el registro:

- `SplashBootstrapController` debe resolver Gate 4 por el camino principal
- el sistema no debe depender del rol string como fuente primaria de verdad

---

# 3. Conceptos Clave

## WorkspaceType

Enumeración canónica del tipo de workspace.

Valores soportados:

| Valor      | Descripción                                                                            |
| ---------- | -------------------------------------------------------------------------------------- |
| assetAdmin | Empresa o unidad operativa que administra activos, especialmente de terceros           |
| owner      | Propietario titular que supervisa sus activos y puede delegar administración operativa |
| renter     | Usuario que arrienda o consume un activo                                               |
| workshop   | Proveedor de servicios técnicos o mantenimiento                                        |
| supplier   | Proveedor de artículos o repuestos                                                     |
| insurer    | Aseguradora o broker                                                                   |
| legal      | Abogado o representante legal                                                          |
| advisor    | Asesor externo                                                                         |
| unknown    | Centinela de error                                                                     |

`WorkspaceType.unknown` nunca debe persistirse al finalizar el onboarding.

---

## WorkspaceContext

Representa el contexto UX activo.

Contiene:

- workspaceType
- workspaceId
- orgId
- orgType
- orgName
- membershipId
- roleCode (legacy)
- providerType si aplica
- source

---

## Membership

Relación entre usuario y organización.

Contiene:

- userId
- orgId
- roles[] (legacy)
- estatus
- providerProfiles[]

---

## Organization

Entidad que representa el tenant del sistema.

Contiene:

- orgId
- nombre
- tipo

Tipos posibles:

- personal
- empresa

Nota importante:

`Organization` sigue siendo el mecanismo actual de partición de datos SaaS.  
No equivale todavía al modelo final de workspace del dominio.

---

## BusinessMode

Define el modo operativo inicial del usuario.

Valores válidos:

| Valor            | Significado                                              |
| ---------------- | -------------------------------------------------------- |
| self_managed     | El propietario gestiona directamente sus propios activos |
| delegated        | El propietario delega la gestión a un tercero            |
| third_party      | La organización administra activos de terceros           |
| hybrid           | La organización administra activos propios y de terceros |
| consumer         | Usuario que consume o arrienda un activo                 |
| service_provider | Usuario que ofrece servicios técnicos                    |
| retailer         | Usuario que comercializa artículos o repuestos           |

---

# 4. Matriz de Mapeo Formal

Tabla oficial de resolución:

WorkspaceType + BusinessMode + orgType → legacyRoleCode

| WorkspaceType | BusinessMode     | orgType  | legacyRoleCode      |
| ------------- | ---------------- | -------- | ------------------- |
| owner         | self_managed     | personal | propietario         |
| owner         | delegated        | personal | propietario         |
| assetAdmin    | third_party      | empresa  | administrador       |
| assetAdmin    | hybrid           | empresa  | administrador       |
| renter        | consumer         | personal | arrendatario        |
| renter        | consumer         | empresa  | arrendatario        |
| workshop      | service_provider | empresa  | proveedor_servicios |
| supplier      | retailer         | empresa  | proveedor_articulos |

### Reglas de resolución

1. La combinación `(workspaceType, businessMode, orgType)` es la clave primaria de resolución.
2. Si la combinación no existe en esta tabla el registro debe fallar.
3. `legacyRoleCode` se escribe en `Membership.roles[]`.
4. `providerType` se escribe cuando el workspace es `workshop` o `supplier`.

---

# 5. RegistrationWorkspaceIntent

Objeto que captura la intención del usuario antes de persistir.

RegistrationWorkspaceIntent {

workspaceType : WorkspaceType  
businessMode : BusinessMode  
orgType : String  
providerType : String?

}

### Responsabilidades

- Capturar la intención declarativa del onboarding.
- No contener IDs persistidos.
- Ser validado contra la matriz formal antes de crear entidades.

### Validaciones previas

| Campo         | Regla                                              |
| ------------- | -------------------------------------------------- |
| workspaceType | Debe ser distinto de unknown                       |
| businessMode  | Debe ser uno de los valores definidos              |
| orgType       | Debe ser personal o empresa                        |
| providerType  | Obligatorio si el workspace es workshop o supplier |

---

# 6. ResolvedRegistrationWorkspace

Contrato de salida canónico del registro.

ResolvedRegistrationWorkspace {

workspaceType  
workspaceId  
orgId  
orgType  
membershipId  
legacyRoleCode  
activeWorkspaceId  
workspaceContextSeed  
businessMode

}

---

# 7. Derivación de workspaceId

El `workspaceId` debe derivarse de forma determinística usando:

workspaceId = deterministic(
orgId,
membershipId,
workspaceType
)

Regla clave:

El identificador **no debe depender estructuralmente del legacyRoleCode**.

Esto evita que el sistema nuevo quede acoplado al modelo legacy.

---

# 8. MembershipId Transicional

En Fase 2 el sistema puede utilizar:

membershipId = "${userId}_${orgId}"

Este valor es un **identificador determinístico transicional**.

No representa el diseño final del modelo de Membership.

En fases posteriores `membershipId` será generado como entidad independiente.

---

# 9. WorkspaceContextSeed (DTO Conceptual)

El seed se define como un DTO conceptual.

WorkspaceContextSeed {

workspaceId  
membershipId  
orgId  
orgName  
orgType  
workspaceType  
roleCode  
providerType  
source

}

Internamente puede serializarse como:

Map<String, dynamic>

Pero conceptualmente debe tratarse como un objeto tipado del dominio.

---

# 10. Construcción del WorkspaceContext inicial

El seed se construye después de crear:

- Organization
- Membership

workspaceContextSeed {

workspaceId  
membershipId  
orgId  
orgName  
orgType  
workspaceType  
roleCode  
providerType  
source = "fromRegistration"

}

---

# 11. Compatibilidad Legacy

Durante Fase 2 existe **doble escritura obligatoria**.

| Destino                                   | Valor                |
| ----------------------------------------- | -------------------- |
| Membership.roles[]                        | legacyRoleCode       |
| User.activeContext.rol                    | legacyRoleCode       |
| WorkspaceRepository.activeId              | workspaceId          |
| RegistrationProgress.workspaceContextSeed | WorkspaceContextSeed |

Principio fundamental:

El **modelo nuevo tiene precedencia**.

El sistema legacy solo actúa como fallback temporal.

---

# 12. Flujo de Creación

Onboarding finalizado  
↓  
capturar RegistrationWorkspaceIntent  
↓  
validar contra matriz formal  
↓  
resolver legacyRoleCode  
↓  
crear Organization  
↓  
crear Membership  
↓  
derivar workspaceId  
↓  
crear WorkspaceContextSeed  
↓  
persistir doble escritura transicional  
↓  
generar ResolvedRegistrationWorkspace  
↓  
disparar SplashBootstrapController.bootstrap()  
↓  
Gate 4 → WorkspaceContext válido

---

# 13. Invariantes

Al finalizar el registro deben cumplirse todas estas condiciones:

1. workspaceType ≠ WorkspaceType.unknown
2. workspaceContextSeed existe y es serializable
3. activeWorkspaceId persistido
4. membership válida creada
5. legacyRoleCode válido
6. membershipId derivable
7. activeWorkspaceId == workspaceId

Si alguna falla el bootstrap no debe ejecutarse.

---

# 14. providerType

`providerType` es metadata de resolución del onboarding.

No es equivalente a `WorkspaceType`.

Solo se usa para distinguir:

- workshop
- supplier

No debe convertirse en concepto raíz del dominio.

---

# 15. Fuera de Alcance

Esta fase no incluye:

- Party model
- ownership legal
- service relationships
- permission graph avanzado
- multi-workspace onboarding
- workspace switching durante registro
- migración de usuarios existentes
