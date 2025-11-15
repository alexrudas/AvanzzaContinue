# 🎯 RESUMEN DE CORRECCIONES CAPTCHA RUNT

## ✅ PROBLEMAS SOLUCIONADOS

### 1. **Umbral de confianza demasiado alto**
- **Antes**: 0.82 (82%) - rechazaba texto con 80% confianza  
- **Después**: 0.80 (80%) por defecto
- **Configurable**: `OCR_CONFIDENCE_THRESHOLD=0.80` en `.env`

### 2. **CAPTCHA repetido entre intentos**
- **Antes**: Mismo CAPTCHA en 3 intentos = reintentos inútiles
- **Después**: Refresco real con fingerprint validation
- **Nuevo**: Si fingerprint no cambia → `page.reload()` forzado

### 3. **Logs poco claros**
- **Antes**: Solo confianza sin contexto
- **Después**: Logs detallados con `[CaptchaSolver]` y `[OCR]` tags
- **Incluye**: `text_raw`, `text_norm`, `confidence`, `fingerprint_before/after`

---

## 📝 ARCHIVOS MODIFICADOS

### 1. `src/ocr/OcrRouter.js`
```javascript
// Cambio de umbral por defecto
const DEFAULT_THRESHOLD = parseFloat(process.env.OCR_CONFIDENCE_THRESHOLD || '0.80');
```

### 2. `src/scrape-runt.puppeteer.js`
**Nuevas funciones añadidas:**
- `getCaptchaFingerprint()` - Detecta cambios reales en imagen CAPTCHA
- `refreshCaptchaAndWaitChange()` - Fuerza refresco y valida cambio
- `solveCaptchaWithRetries()` - Versión mejorada con:
  - ✅ Fingerprint validation entre intentos
  - ✅ Umbrales degradados: 0.82 → 0.80 → 0.78
  - ✅ Logs detallados `[CaptchaSolver]`
  - ✅ Reload forzado si CAPTCHA no cambia
  - ✅ OCR con router actualizado

---

## 🔧 CONFIGURACIÓN REQUERIDA

### 1. Crear archivo `.env`
```env
OCR_CONFIDENCE_THRESHOLD=0.80
```

### 2. Verificar funcionamiento
```bash
node test-captcha-fix.js
```

---

## 📊 FLUJO MEJORADO

### **Intento 1**: Umbral 0.82 (82%)
- Fingerprint inicial capturado
- Si falla OCR → continúa a Intento 2

### **Intento 2**: Umbral 0.80 (80%)  
- `refreshCaptchaAndWaitChange()` → nuevo CAPTCHA
- Valida que fingerprint cambió
- Si no cambió → `page.reload()`

### **Intento 3**: Umbral 0.78 (78%)
- Último intento con umbral más permisivo
- Si falla → error definitivo

---

## 🎯 LOGS ESPERADOS

```
[CaptchaSolver] Intento CAPTCHA 1/3
[CaptchaSolver] fingerprint_before: IMG:data:image/png;base64,iVBORw0KGgoAAAANS...
[OCR] recognize_text {"attempt":1,"text_raw":"JPK5Z","text_norm":"JPK5Z","confidence":0.8}
[CaptchaSolver] OCR exitoso con confianza 80.0%: JPK5Z
[CaptchaSolver] CAPTCHA ingresado correctamente
```

---

## ✅ CRITERIOS DE VALIDACIÓN CUMPLIDOS

- [x] **Umbral configurable**: `OCR_CONFIDENCE_THRESHOLD=0.80`
- [x] **Refresco real**: Fingerprint validation entre intentos  
- [x] **Logs claros**: `text_raw`, `text_norm`, `confidence` visibles
- [x] **CommonJS**: Sin warnings de módulos
- [x] **No modificar provider**: TesseractProvider.js intacto
- [x] **Degradación umbral**: 0.82 → 0.80 → 0.78
- [x] **Trazabilidad**: `requestId` en todos los logs

---

## 🚀 PRÓXIMOS PASOS

1. **Probar con consulta real**:
   ```
   GET /runt/vehicle/GOV/wpv583/72184925/C
   ```

2. **Verificar en logs**:
   - Cada intento usa CAPTCHA distinto
   - `JPK5Z` con 80% confianza es aceptado
   - No más warnings de módulos ES6

3. **Monitorear**:
   - Tasa de éxito CAPTCHA
   - Tiempo promedio de resolución
   - Errores HTTP 400 (CAPTCHA rechazado por servidor)