# UI_TYPE_RENDERING_GUIDE.md

## Avanzza 2.0 — Guía de Renderizado de Tipos

> **TIPO:** Guía de Implementación Operativa
> **VERSIÓN:** 1.0.1
> **SUBORDINADO A:** UI_CONTRACTS.md (v1.0.2) §4
> **APLICA A:** Humanos e IA

---

## 1. PROPÓSITO

Definir el renderizado canónico de Value Objects del Dominio en la UI.
Este documento NO redefine contratos. Traduce UI_CONTRACTS.md §4 a reglas operativas.

---

## 2. REGLA GENERAL [CRÍTICO]

| Principio | Obligatorio |
|-----------|-------------|
| Value Objects → Widgets especializados | ✅ SÍ |
| Prohibido mostrar JSON crudo | ✅ SÍ |
| Prohibido mostrar tipos complejos como strings sin formato | ✅ SÍ |
| Prohibido truncar información semántica relevante | ✅ SÍ |

> **Ref:** UI_CONTRACTS.md §4.1

### 2.1 Nota sobre Nombres de Widgets

Los nombres de widgets definidos en este documento (`MoneyDisplay`, `DateDisplay`, `StatusBadge`, etc.) son **contractuales a nivel de ROL y FUNCIÓN**, no de implementación literal.

La implementación concreta puede variar (nombre de clase, paquete, estructura interna) **siempre que cumpla el contrato de renderizado especificado**.

Lo que se audita es el **cumplimiento del contrato**, no el nombre exacto del widget.

---

## 3. MONETARYAMOUNT [CRÍTICO]

### 3.1 Definición de Dominio

```
MonetaryAmount { amount: Decimal, currency: ISO_4217 }
```

### 3.2 Widget Canónico

| Propósito | Widget | Uso Alternativo |
|-----------|--------|-----------------|
| Mostrar valor | `MoneyDisplay` | ❌ PROHIBIDO |
| Capturar input | `MoneyInputField` | ❌ PROHIBIDO |

### 3.3 Reglas de Visualización

| Regla | Obligatorio | Ejemplo Correcto |
|-------|-------------|------------------|
| Mostrar símbolo o código de moneda | ✅ SÍ | `$1,234.56 USD` |
| Formatear según locale del usuario | ✅ SÍ | `€1.234,56` (ES), `€1,234.56` (EN) |
| Decimales según moneda | ✅ SÍ | USD → 2, JPY → 0 |
| Separadores de miles apropiados | ✅ SÍ | `1,234,567` (EN), `1.234.567` (ES) |

### 3.4 Prohibiciones

| Formato | Permitido | Sección Violada |
|---------|-----------|-----------------|
| `1234.56` (número crudo) | ❌ NO | §4.2 |
| `Text('${amount}')` | ❌ NO | §4.2 |
| Omitir divisa | ❌ NO | §4.2 |
| Asumir moneda por defecto | ❌ NO | §4.2 |
| Mezclar formatos en una vista | ❌ NO | §4.2 |

### 3.5 DO / DON'T

| DO | DON'T |
|----|-------|
| `MoneyDisplay(money: monetaryAmount)` | `Text('${money.amount}')` |
| `MoneyDisplay(money: monetaryAmount, showCurrency: true)` | `Text('\$${money.amount.toStringAsFixed(2)}')` |
| Obtener locale desde contexto | Hardcodear formato `#,###.##` |

> **Ref:** UI_CONTRACTS.md §4.2

---

## 4. GEOLOCATION

### 4.1 Definición de Dominio

```
GeoLocation { lat: double, lng: double, timestamp: UTCDate }
```

### 4.2 Widgets Canónicos

| Contexto | Widget | Uso Alternativo |
|----------|--------|-----------------|
| Vista principal | `LocationMapView` | ❌ PROHIBIDO |
| Vista compacta | `CoordinatesDisplay` | ❌ PROHIBIDO |
| Vista amigable | `AddressDisplay` | ❌ PROHIBIDO |

### 4.3 Formatos Permitidos

| Formato | Contexto | Ejemplo |
|---------|----------|---------|
| Mapa interactivo con marcador | Vista principal, detalle | Mapa con pin |
| Coordenadas formateadas | Lista, accesibilidad | `19.4326° N, 99.1332° W` |
| Dirección geocodificada | Vista amigable | `Av. Reforma 222, CDMX` |

### 4.4 Regla de Fallback para AddressDisplay [CRÍTICO]

| Condición | Acción Obligatoria |
|-----------|-------------------|
| `AddressDisplay` existe y hay dirección geocodificada | Usar `AddressDisplay` |
| `AddressDisplay` NO existe en el proyecto | ❌ PROHIBIDO mostrar direcciones. Usar `CoordinatesDisplay` |
| Dirección no disponible en runtime | Usar `CoordinatesDisplay` como fallback |
| Ningún widget especializado disponible | ❌ PROHIBIDO. Construir strings manuales está PROHIBIDO |

**Regla dura:** NO se permite improvisar representación de ubicación con `Text()` o strings concatenados bajo ninguna circunstancia.

### 4.5 Prohibiciones

| Formato | Permitido | Sección Violada |
|---------|-----------|-----------------|
| JSON crudo `{"lat": 19.43, "lng": -99.13}` | ❌ NO | §4.3 |
| Coordenadas sin formato `19.4326, -99.1332` | ❌ NO | §4.3 |
| Omitir hemisferio (N/S, E/W) | ❌ NO | §4.3 |
| `Text('${location.lat}, ${location.lng}')` | ❌ NO | §4.3 |
| String manual como fallback | ❌ NO | §4.3 |

### 4.6 DO / DON'T

| DO | DON'T |
|----|-------|
| `CoordinatesDisplay(location: geoLocation)` | `Text('${loc.lat}, ${loc.lng}')` |
| `LocationMapView(location: geoLocation)` | Mostrar lat/lng en Text |
| Incluir indicadores N/S, E/W | Solo mostrar números decimales |
| Usar `CoordinatesDisplay` si no hay dirección | Improvisar string de dirección |

> **Ref:** UI_CONTRACTS.md §4.3

---

## 5. FECHAS Y TIMESTAMPS

### 5.1 Definición de Dominio

```
DateTime (UTC) | Timestamp (Unix) | ISO-8601 String
```

### 5.2 Widget Canónico

| Propósito | Widget | Uso Alternativo |
|-----------|--------|-----------------|
| Mostrar fecha/hora | `DateDisplay` | ❌ PROHIBIDO |
| Mostrar relativo | `RelativeDateDisplay` | ❌ PROHIBIDO |
| Capturar input | `DatePickerField` | ❌ PROHIBIDO |

### 5.3 Reglas de Visualización

| Regla | Obligatorio | Ejemplo |
|-------|-------------|---------|
| Localizar al formato del usuario | ✅ SÍ | `15 de marzo de 2024` (ES) |
| Convertir a zona horaria del usuario | ✅ SÍ | UTC → Local |

### 5.4 Formato Relativo: Contextos Permitidos [CRÍTICO]

El uso de `RelativeDateDisplay` (formatos como "Hace 2 horas") está **PERMITIDO ÚNICAMENTE** en los siguientes contextos:

| Contexto | Permitido | Ejemplo |
|----------|-----------|---------|
| Activity feeds | ✅ SÍ | "Hace 5 minutos" |
| Activity logs | ✅ SÍ | "Hace 2 horas" |
| Notificaciones | ✅ SÍ | "Hace 1 día" |
| Timestamps de comentarios | ✅ SÍ | "Hace 3 días" |

| Contexto | Permitido | Widget Obligatorio |
|----------|-----------|-------------------|
| Fechas de documentos formales | ❌ NO | `DateDisplay` |
| Fechas de vencimiento | ❌ NO | `DateDisplay` |
| Fechas en formularios | ❌ NO | `DateDisplay` |
| Fechas en reportes | ❌ NO | `DateDisplay` |
| Fechas en registros contables | ❌ NO | `DateDisplay` |

**Regla de auditoría:** Si el contexto NO está en la lista de permitidos, usar `DateDisplay` estándar.

### 5.5 Prohibiciones

| Formato | Permitido | Sección Violada |
|---------|-----------|-----------------|
| ISO-8601 crudo `2024-03-15T14:30:00Z` | ❌ NO | §4.4 |
| Timestamp Unix `1710513000` | ❌ NO | §4.4 |
| `Text(date.toIso8601String())` | ❌ NO | §4.4 |
| `Text(date.toString())` | ❌ NO | §4.4 |
| Asumir zona horaria | ❌ NO | §4.4 |
| `RelativeDateDisplay` fuera de contextos permitidos | ❌ NO | §5.4 |

### 5.6 DO / DON'T

| DO | DON'T |
|----|-------|
| `DateDisplay(date: dateTime, locale: context.locale)` | `Text(date.toString())` |
| `RelativeDateDisplay(date: dateTime)` en feeds/logs | `RelativeDateDisplay` en formularios |
| Convertir UTC a local antes de mostrar | Mostrar UTC directamente |
| Usar `intl` para formateo | Formatear manualmente |

> **Ref:** UI_CONTRACTS.md §4.4

---

## 6. ENUMS Y ESTADOS

### 6.1 Regla General

| Principio | Obligatorio |
|-----------|-------------|
| Mostrar etiqueta legible, no valor técnico | ✅ SÍ |
| Etiqueta DEBE provenir de i18n | ✅ SÍ |

### 6.2 Widget Canónico

| Propósito | Widget | Uso Alternativo |
|-----------|--------|-----------------|
| Mostrar estado | `StatusBadge` | ❌ PROHIBIDO |
| Mostrar enum | `EnumLabel` | ❌ PROHIBIDO |
| Seleccionar enum | `DropdownField<T>` | ❌ PROHIBIDO |

### 6.3 Prohibiciones

| Formato | Permitido | Sección Violada |
|---------|-----------|-----------------|
| `Text(status.name)` | ❌ NO | §4.5 |
| `Text('IN_PROGRESS')` | ❌ NO | §4.5 |
| `Text(enum.toString())` | ❌ NO | §4.5 |
| Hardcodear etiquetas | ❌ NO | §4.5, §3.4 |

### 6.4 DO / DON'T

| DO | DON'T |
|----|-------|
| `StatusBadge(status: status, label: l10n.statusLabel(status))` | `Text(status.name)` |
| `EnumLabel(value: type, label: l10n.typeLabel(type))` | `Text('IN_PROGRESS')` |
| Mapear enum → i18n key | Hardcodear strings |

### 6.5 Mapeo Enum → i18n (Patrón Obligatorio)

```
// Estructura conceptual
enum MaintenanceStatus { draft, scheduled, inProgress, completed }

// En l10n:
maintenanceStatusDraft → "Borrador"
maintenanceStatusScheduled → "Programado"
maintenanceStatusInProgress → "En Progreso"
maintenanceStatusCompleted → "Completado"

// Uso:
l10n.maintenanceStatus(status) → String localizado
```

> **Ref:** UI_CONTRACTS.md §4.5, §3.4

---

## 7. TABLA RESUMEN DE WIDGETS

| Tipo de Dato | Widget Display | Widget Input | Text() Permitido |
|--------------|----------------|--------------|------------------|
| `MonetaryAmount` | `MoneyDisplay` | `MoneyInputField` | ❌ NO |
| `GeoLocation` | `LocationMapView`, `CoordinatesDisplay` | N/A | ❌ NO |
| `DateTime` | `DateDisplay`, `RelativeDateDisplay` | `DatePickerField` | ❌ NO |
| `Enum` | `StatusBadge`, `EnumLabel` | `DropdownField<T>` | ❌ NO |
| `String` libre | `Text()` | `AvanzzaTextField` | ✅ SÍ (con i18n) |

---

## 8. CHECKLIST DE REVISIÓN

### Para cada Value Object renderizado:

| Verificación | Cumple |
|--------------|--------|
| ¿Usa widget especializado, no `Text()`? | ☐ |
| ¿Respeta formato según locale? | ☐ |
| ¿No muestra valores crudos/técnicos? | ☐ |
| ¿Etiquetas provienen de i18n? | ☐ |
| ¿No asume defaults (moneda, timezone)? | ☐ |
| ¿RelativeDateDisplay solo en contextos permitidos? | ☐ |
| ¿GeoLocation usa fallback correcto (no strings)? | ☐ |

---

## 9. ANTIPATRONES ESPECÍFICOS

| Antipatrón | Código Ejemplo | Widget Correcto |
|------------|----------------|-----------------|
| Raw Money | `Text('\$${amount}')` | `MoneyDisplay(money)` |
| Raw Date | `Text(date.toString())` | `DateDisplay(date)` |
| Raw Enum | `Text(status.name)` | `StatusBadge(status, l10n)` |
| Raw Coords | `Text('${lat}, ${lng}')` | `CoordinatesDisplay(loc)` |
| Hardcoded Format | `Text('${amount.toStringAsFixed(2)}')` | `MoneyDisplay(money)` |
| Relative in Wrong Context | `RelativeDateDisplay` en reporte | `DateDisplay(date)` |
| Manual Address String | `Text('${street}, ${city}')` | `AddressDisplay` o `CoordinatesDisplay` |

---

## 10. MAPEO A UI_CONTRACTS.md

| Sección de esta Guía | Sección de UI_CONTRACTS.md |
|----------------------|----------------------------|
| §3 MonetaryAmount | §4.2 |
| §4 GeoLocation | §4.3 |
| §5 Fechas/Timestamps | §4.4 |
| §6 Enums/Estados | §4.5, §3.4 |

---

**FIN DE UI_TYPE_RENDERING_GUIDE.md — v1.0.1**
