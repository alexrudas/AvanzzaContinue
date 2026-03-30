# ALERTS_SYSTEM_V3.md

> Documento rector de arquitectura para el sistema de alertas de Avanzza 2.0.
>
> Reglas obligatorias:
>
> - No crear sistemas de alertas fuera de este modelo.
> - Todo PR que toque alertas debe respetar este documento.
> - Este documento define la arquitectura objetivo y el plan de migración desde el estado actual del código.
> - Si el código actual contradice este documento, prevalece este documento para todo desarrollo nuevo o migración controlada.

---

## 1. PROPÓSITO

Definir una arquitectura única, escalable y ejecutable para el sistema de alertas de Avanzza 2.0, evitando:

- duplicación de modelos
- lógica fragmentada
- alertas mock visibles
- dependencia del dominio respecto a UI
- múltiples sistemas paralelos de alertas

Este documento define:

- contrato canónico
- capas reales alineadas con el repo
- pipeline
- integración con código existente
- fases ejecutables con Definition of Done

---

## 2. PRINCIPIO RECTOR

Las alertas nacen en su contexto operativo y se proyectan hacia capas superiores (Home).

NO existe un sistema global como origen.

Flujo correcto:

1. estándar transversal
2. productor contextual
3. consumo contextual
4. promotion layer
5. Home

Home nunca crea lógica.

---

## 3. ALINEACIÓN CON ESTRUCTURA REAL DEL REPO

⚠️ Se prohíbe crear `lib/application/`.

Arquitectura válida:

- `lib/domain/`
- `lib/core/`
- `lib/data/`
- `lib/presentation/`

---

## 4. ESTRUCTURA DE ARCHIVOS (OBLIGATORIA)

### Dominio

- `lib/domain/entities/alerts/domain_alert.dart`
- `lib/domain/entities/alerts/alert_code.dart`
- `lib/domain/entities/alerts/alert_severity.dart`
- `lib/domain/entities/alerts/alert_scope.dart`
- `lib/domain/entities/alerts/alert_audience.dart`
- `lib/domain/entities/alerts/alert_promotion_policy.dart`

### Servicios de dominio

- `lib/domain/services/alerts/asset_alert_snapshot.dart`
- `lib/domain/services/alerts/asset_alert_snapshot_assembler.dart`
- `lib/domain/services/alerts/asset_compliance_alert_orchestrator.dart`

### Core (soporte técnico)

- `lib/core/alerts/support/alert_dedupe.dart`
- `lib/core/alerts/support/alert_sort.dart`
- `lib/core/alerts/support/alert_fact_keys.dart`

### Evaluadores (usar domain/services o core según dependencia)

- `lib/domain/services/alerts/evaluators/soat_alert_adapter.dart`
- `lib/domain/services/alerts/evaluators/rtm_alert_evaluator.dart`
- `lib/domain/services/alerts/evaluators/rc_alert_evaluator.dart`
- `lib/domain/services/alerts/evaluators/legal_alert_evaluator.dart`

### Presentación

- `lib/presentation/alerts/viewmodels/alert_card_vm.dart`
- `lib/presentation/alerts/mappers/domain_alert_mapper.dart`

---

## 5. CONTRATO CANÓNICO

### DomainAlert

Campos obligatorios:

- id
- code (AlertCode)
- severity (AlertSeverity)
- scope (AlertScope)
- promotionPolicy
- sourceEntityId
- titleKey
- bodyKey
- facts (Map<String, Object?>)
- evidenceRefs (List<Map<String, Object?>>)
- isActive
- detectedAt
- dedupeKey

### REGLAS

DomainAlert:

- NO usa IconData
- NO usa colores
- NO usa Widgets
- NO usa strings renderizados finales

---

## 6. ENUMS CANÓNICOS

### AlertCode (V1 mínimo)

- soat_expired
- soat_due_soon
- rtm_expired
- rtm_due_soon
- rc_contractual_expired
- rc_contractual_due_soon
- rc_extracontractual_expired
- rc_extracontractual_due_soon
- legal_limitation_active
- embargo_active

Debe ser wire-stable.

---

### AlertSeverity

- critical
- high
- medium
- low

Mapeo obligatorio desde enums legacy.

---

### AlertScope

- asset
- organization
- maintenance
- accounting
- purchasing

---

### AlertPromotionPolicy

- none
- promote_if_high
- promote_if_critical
- always_promote
- aggregate_only

---

## 7. FACT KEYS CENTRALIZADOS

Archivo obligatorio:
`lib/core/alerts/support/alert_fact_keys.dart`

Ejemplo:

- expiration_date
- days_remaining
- policy_type
- legal_type

Regla:
Nadie puede inventar keys nuevas fuera de este archivo.

---

## 8. DECISIÓN OFFLINE-FIRST

V1:

- NO se persisten alertas
- cálculo on-read

---

## 9. INTEGRACIÓN CON SOAT (CRÍTICO)

Archivo existente REAL:

- `lib/core/campaign/soat/soat_campaign_evaluator.dart`

### DECISIÓN OBLIGATORIA

NO reescribir.

Crear adapter:

- `soat_alert_adapter.dart`

Este adapter:

- llama a evaluateSoat()
- traduce a DomainAlert

### SoatFrequencyGuard

- NO usar para ocultar alertas in-app
- mantener para campañas futuras

---

## 10. PIPELINE

fuentes → snapshot → evaluadores → DomainAlert → dedupe → sort → promotion → mapper → UI

---

## 11. SNAPSHOT

### AssetAlertSnapshot

Incluye:

- datos del activo
- SOAT
- RTM
- RC
- legal
- metadata

---

## 12. ORQUESTADOR

### AssetComplianceAlertOrchestrator

Responsabilidades:

- ejecutar evaluadores
- consolidar alertas
- aplicar dedupe y sort

---

## 13. CONSUMO CONTEXTUAL

### Detalle vehículo

Eliminar:
`List<String> alerts`

Usar:
ViewModels derivados de DomainAlert

### Vista documental

Consumir directamente DomainAlert

---

## 14. PROMOTION LAYER

### Servicio

- AlertPromotionService

Reglas V1:

Promover:

- soat_expired
- rtm_expired
- embargo_active
- legal_limitation_active

### Due soon

Regla explícita:

- promover solo si <= 7 días

---

## 15. HOME

Home:

- NO calcula alertas
- consume promotion layer
- elimina lista demo

---

## 16. DI (OBLIGATORIO)

Todos los servicios:

- se registran en DIContainer

Prohibido:

- Get.find()

---

## 17. FASES

### Fase 0 — Contención

- @Deprecated en SmartAlert
- eliminar mocks visibles
- congelar AIBannerMessage

DONE:
no más mocks en UI

---

### Fase 1 — Dominio

- crear DomainAlert + enums

DONE:
compila + enums wire-stable

---

### Fase 2 — Productor

- snapshot
- evaluadores
- adapter SOAT

DONE:
orchestrator devuelve DomainAlert

---

### Fase 3 — Consumo

- conectar detalle vehículo
- activar \_AlertsBanner

DONE:
sin List<String>

---

### Fase 4 — Promotion

- implementar AlertPromotionService

DONE:
Home consume datos reales

---

### Fase 5 — Home

- eliminar demo
- render real

DONE:
Home funcional con alertas reales

---

### Fase 6 — Escalamiento

- maintenance
- accounting
- purchasing

---

### Fase 7 — Limpieza

- eliminar AIBannerMessage
- eliminar AlertType
- eliminar mocks

DONE:
solo sistema canónico activo

---

## 18. REGLAS INNEGOCIABLES

1. Una alerta = una definición
2. Dominio sin UI
3. Home no crea lógica
4. No strings como contrato
5. No enums duplicados
6. Todo alert tiene code + severity + scope + evidence
7. SOAT no se reescribe, se adapta
8. No se crea nueva capa fuera del repo
9. DI obligatorio
10. Fact keys centralizados

---

## 19. FRASE FINAL

Primero estándar → luego contexto → luego promoción → luego Home.

Si rompes este orden, rompes el sistema.
