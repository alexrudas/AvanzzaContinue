# ALERTS SYSTEM V5 — CONTRATO CANÓNICO

Avanzza 2.0

QUÉ HACE:
Define el contrato canónico del sistema de señales (Compliance, Opportunity, Exemption) garantizando consistencia entre dominio, mapper y UI.

QUÉ NO HACE:
No gestiona persistencia de alertas, no maneja lifecycle de oportunidades ni navegación UI.

PRINCIPIOS:
Offline-First, Precaución Semántica, UI Muda, Snapshot Coherente, Separación de Responsabilidades.

ENTERPRISE NOTES:
Este documento es la única fuente de verdad para evaluators, mapper y AlertCenter.

Estado: APPROVED / FINAL  
Versión: 2.4.0

---

## 1. PROPÓSITO

Definir un sistema de señales operativas que diferencie:

- Compliance → riesgo/incumplimiento real
- Opportunity → señal comercial
- Exemption → condición informativa

Objetivo:

- evitar contaminación semántica
- proteger métricas de riesgo
- garantizar consistencia dominio → mapper → UI
- permitir evolución sin deuda técnica

---

## 2. ALCANCE

Incluye:

- DomainAlert
- AlertKind
- AlertCode
- AssetAlertSnapshot
- Evaluators
- AlertPromotionService
- DomainAlertMapper
- AlertCardVm
- AlertCenterController

No incluye:

- rediseño del pipeline
- CRM o lifecycle de oportunidades
- cambios estructurales de almacenamiento

---

## 3. MODELO DE DOMINIO

Se mantiene:

DomainAlert

Se extiende con:

enum AlertKind {
compliance,
opportunity,
exemption
}

Regla:

AlertKind define la naturaleza  
AlertSeverity define la urgencia

---

## 4. DESERIALIZACIÓN

AlertKind.fromWire(String? raw)

Reglas:

- null → compliance
- desconocido → compliance

Principio:

Precaución Semántica

- nunca romper pipeline
- nunca perder señales

Nota crítica:

Este fallback NO es semánticamente perfecto.  
Es una decisión defensiva V1 para compatibilidad offline-first.  
Puede generar falsos positivos, pero evita perder señales críticas.

---

## 5. SNAPSHOT — CONTRATO DEFINITIVO

DECISIÓN DE ARQUITECTURA:

Se modifica explícitamente el contrato del snapshot.

El snapshot ahora incluye clasificación canónica del dominio.

Campo nuevo:

enum VehicleServiceCategory {
publicTransport,
privateUse,
unknown
}

AssetAlertSnapshot debe incluir:

vehicleServiceCategory

---

Reglas del snapshot:

- NO contiene lógica de negocio booleana
- NO expone flags regulatorios como:

  - appliesRcRequirement
  - qualifiesForOpportunity

- SÍ contiene datos normalizados para evitar interpretación repetida

---

Responsabilidades:

- Snapshot → datos + clasificación canónica
- Evaluator → lógica de negocio (emisión de señales)

---

Regla crítica:

El evaluator:

- NO interpreta strings crudos
- NO usa vehicleServiceType directamente
- SÍ usa vehicleServiceCategory

---

Cambio explícito:

Se elimina:

\_resolveServiceCategory()

La normalización ocurre en el assembler.

---

## 6. RC — REGLAS DE NEGOCIO

RC contractual:

- publicTransport → obligatorio
- privateUse → no aplica

RC extracontractual:

- publicTransport → obligatorio
- privateUse → oportunidad

Resultados:

- público sin RC → compliance
- público vencido → compliance
- particular sin RC → opportunity
- particular con RC → sin alerta

Safe failure:

- vehicleServiceCategory == unknown → NO emitir alertas RC

---

## 7. ALERT CODES (RC COMPLETO)

Contractual:

- rc_contractual_missing
- rc_contractual_expired
- rc_contractual_due_soon

Extracontractual:

- rc_extracontractual_missing
- rc_extracontractual_expired
- rc_extracontractual_due_soon

Comercial:

- rc_extracontractual_opportunity

---

## 8. INVARIANTE CRÍTICO

Nunca coexistir:

rc_extracontractual_missing  
rc_extracontractual_opportunity

---

## 9. DEDUPE

Formato:

{code}:{scope}:{assetId}:{primaryEvidenceId}

Regla:

primaryEvidenceId = assetId cuando no hay documento

La unicidad depende de:

code.wireName

---

## 10. ESTADO DE EVALUACIÓN

Estados válidos:

- expired
- dueSoon

Nota:

valid NO es estado del sistema de alertas  
no genera DomainAlert

Regla:

expired > dueSoon

---

## 11. ORDENAMIENTO

Orden:

1. alertKind
2. severity
3. estado
4. daysRemaining
5. timestamp

Prioridad:

compliance  
opportunity  
exemption

Regla absoluta:

compliance siempre primero

---

## 12. MÉTRICAS

Definición:

alerta pendiente = alertKind == compliance

Conteo:

- compliance → sí
- opportunity → no
- exemption → no

Home:

- solo compliance
- opportunity excluidas
- exemption excluidas

---

## 13. PROMOCIÓN

Responsable:

AlertPromotionService

Regla:

if alertKind != compliance → NO promover

Nota técnica:
El AlertPromotionService mantiene su lógica interna de normalización de vehicleServiceType
(ex. \_resolveVehicleService()) para alertas de compliance.

La regla:
if alertKind != compliance → NO promover
opera como un gate previo independiente.
No reemplaza la lógica existente de promoción de compliance basada en tipo de servicio y umbrales.

---

## 14. REGLA DE DESAPARICIÓN

Las alertas no se persisten.

Se recalculan.

Si la condición desaparece:
→ la alerta desaparece

No existe lifecycle

---

## 15. MAPPER

Regla:

UI es muda  
Mapper decide todo

AlertCardVm incluye:

- title
- subtitle
- severity
- code
- cardVariant
- badgeLabel
- isCountable
- actionLabel
- actionRoute
- assetPrimaryLabel

cardVariant:

risk  
warning  
commercial  
informational

Reglas exactas:

- compliance + (critical | high) → risk
- compliance + (medium | low) → warning
- opportunity → commercial
- exemption → informational

badgeLabel:

- compliance → Incumplimiento
- opportunity → Oportunidad
- exemption → Exento

isCountable:

- compliance → true
- otros → false

---

## 16. CONTROLLER

Estado único:

alerts

Filtros:

- all
- critical
- documents
- legal
- opportunities

Regla:

usar getters  
no duplicar estado

---

## 17. UI

El widget NO decide lógica.

Solo renderiza:

- cardVariant
- badgeLabel
- isCountable

---

## 18. LÍMITE ARQUITECTÓNICO

DomainAlert soporta oportunidades SOLO si:

- ≤ 5 tipos
- sin lifecycle
- sin persistencia
- sin CRM

Si crece:

→ migrar a AssetOpportunity

---

## 19. PLAN DE IMPLEMENTACIÓN (ACTUALIZADO)

Paso 0  
AlertKind + fromWire

Paso 1  
Agregar vehicleServiceCategory al snapshot  
Actualizar assembler para normalización  
Eliminar \_resolveServiceCategory del evaluator

Paso 2  
AlertCode + evaluator RC

Paso 3  
PromotionService

Paso 4  
Mapper

Paso 5  
Controller

Paso 6  
Validación real

---

## 20. VALIDACIÓN

Casos:

1. publicTransport sin RC → compliance
2. publicTransport con RC vencido → compliance
3. privateUse sin RC → opportunity
4. privateUse con RC vigente → sin alerta
5. privateUse sin RC contractual → sin alerta
6. vehicleServiceCategory unknown → sin alerta

---

## 21. INVARIANTES

- fromWire nunca rompe
- compliance siempre primero
- opportunity no suma métricas
- UI no decide lógica
- evaluator no decide promoción
- evaluator no interpreta strings crudos
- snapshot no contiene lógica booleana regulatoria
- snapshot contiene clasificación canónica
- alerts no persisten estado

---

## 22. DEUDA TÉCNICA

actionRoute es simplificación V1  
Futuro:
actionType desacoplado
