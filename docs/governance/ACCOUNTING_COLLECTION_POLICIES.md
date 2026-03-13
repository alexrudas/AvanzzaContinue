# ACCOUNTING_COLLECTION_POLICIES

Versión: 2.0 (Enterprise Canonical)
Última revisión: 2026-02-28
Alcance: CxC (Cuentas por Cobrar) y CxP (Cuentas por Pagar)
Estado: OBLIGATORIO Y VINCULANTE para todo el módulo contable

──────────────────────────────────────────────────────────────────────────────

1. PRINCIPIO RECTOR
   ──────────────────────────────────────────────────────────────────────────────

Este documento define la política canónica única para:

• Obligatoriedad de campos por método de cobro/pago.
• Semántica oficial de cierre por “Ajuste/Descuento”.
• Validaciones determinísticas y orden obligatorio.
• Mensajes de error exactos y no modificables.
• Representación monetaria oficial del sistema.

Cualquier implementación que contradiga este documento constituye DEUDA TÉCNICA y debe refactorizarse.

No existen excepciones por “casos especiales”.

────────────────────────────────────────────────────────────────────────────── 2. REPRESENTACIÓN MONETARIA (MANDATORIA)
──────────────────────────────────────────────────────────────────────────────

2.1 Regla Canónica

Todos los montos monetarios en Avanzza deben representarse como:

    int (COP entero)

Ejemplo:
150000 → $150.000 COP
0 → $0 COP

2.2 Queda estrictamente prohibido:

• Uso de double para dinero.
• Tolerancias tipo 0.01.
• Comparaciones flotantes.
• clamp(double.infinity).
• toStringAsFixed() para lógica contable.
• Redondeos implícitos.

2.3 Justificación

• Elimina errores de redondeo.
• Garantiza determinismo contable.
• Permite conciliación exacta.
• Unifica CxC y CxP bajo el mismo modelo financiero.

────────────────────────────────────────────────────────────────────────────── 3. ALCANCE TÉCNICO
──────────────────────────────────────────────────────────────────────────────

Componentes afectados:

CxC:
lib/presentation/pages/admin/accounting/account_receivable_detail_page.dart

CxP:
lib/presentation/pages/admin/accounting/account_payable_detail_page.dart

Enum + Extensión:
lib/domain/value/accounting/collection_method.dart

Regla estructural:

Toda obligatoriedad debe consumirse exclusivamente desde:

    CollectionMethodPolicyX

Prohibido:
• Duplicar reglas en controller.
• Duplicar reglas en UI.
• Hardcodear validaciones por método.
• Crear lógica paralela de obligatoriedad.

Single Source of Truth obligatorio.

────────────────────────────────────────────────────────────────────────────── 4. TABLA CANÓNICA DE OBLIGATORIEDAD
──────────────────────────────────────────────────────────────────────────────

Si un campo no aplica (needs\* == false):

• Debe ocultarse en UI.
• Debe limpiarse en el modelo (campo = null).
• Debe limpiarse el controller (text = '' si no tiene foco).

## Método needsBanco needsReferencia needsLast4 needsNota

efectivo false false false false
transferencia true true false false
debito true true true false
credito true true true false
cheque true true false false
otro false false false true

4.1 Definiciones Formales

banco:
Nombre de la entidad financiera.

referencia:
Número de transacción o número de cheque.

last4:
Últimos 4 dígitos de tarjeta.
Regex obligatoria:
^\d{4}$

nota:
Justificación obligatoria para método “otro”.

────────────────────────────────────────────────────────────────────────────── 5. LIMPIEZA AL CAMBIAR MÉTODO
──────────────────────────────────────────────────────────────────────────────

Al cambiar el método en la UI:

Para cada campo donde needs\* == false:

Modelo:
campo = null

Controller:
text = '' (solo si no tiene foco activo)

Caso especial: método efectivo

Debe limpiar obligatoriamente:

• banco
• referencia
• last4
• nota

Objetivo:
CERO datos huérfanos invisibles.

────────────────────────────────────────────────────────────────────────────── 6. SEMÁNTICA DE “AJUSTE/DESCUENTO”
──────────────────────────────────────────────────────────────────────────────

6.1 Definición Formal

“Ajuste/Descuento” es el cierre contable de la diferencia residual entre:

    saldoInicialCop - totalIngresadoCop

No es un pago.
No requiere método.
No genera split adicional.
No crea registro separado.
No representa ingreso ni egreso real.

6.2 Reglas Determinísticas (int COP)

Sea:

    diferenciaCop = saldoInicialCop - totalIngresadoCop

Caso 1 — diferenciaCop > 0

• Se habilita checkbox “Cerrar con Ajuste/Descuento”.
• Si usuario marca:
saldoFinalCop = 0
valorAjusteCop = diferenciaCop

Caso 2 — diferenciaCop == 0

• Checkbox debe forzarse a false.
• saldoFinalCop = 0.
• valorAjusteCop = 0.

Caso 3 — diferenciaCop < 0

• Error: sobrepago.
• No es ajuste.
• Usuario debe corregir monto ingresado.

6.3 Qué NO es Ajuste

• No compensa sobrepago.
• No es método de pago.
• No requiere banco/referencia/last4/nota.
• No genera split.
• No modifica histórico de pagos reales.

────────────────────────────────────────────────────────────────────────────── 7. MENSAJES DE ERROR CANÓNICOS
──────────────────────────────────────────────────────────────────────────────

Los siguientes textos deben usarse EXACTAMENTE iguales en CxC y CxP.

Prohibido:
• Cambiar comillas.
• Cambiar tildes.
• Traducir.
• Abreviar.
• Reescribir.

'Esta cuenta ya no tiene saldo pendiente.'
'Debe ingresar un monto válido.'
'El monto excede el saldo pendiente. Ajusta los montos.'
'Falta banco en un método que lo requiere.'
'Falta referencia / número de transacción.'
'Faltan los últimos 4 dígitos.'
'Últimos 4 dígitos inválidos. Deben ser exactamente 4 números.'
'Falta nota justificativa en el método "Otro".'
'La fecha de transacción no puede ser anterior a la creación de la cuenta.'
'No hay diferencia para ajustar. Desmarca "Ajuste/Descuento".'

────────────────────────────────────────────────────────────────────────────── 8. ORDEN DE VALIDACIÓN (OBLIGATORIO)
──────────────────────────────────────────────────────────────────────────────

El orden no es negociable:

1. saldoInicialCop > 0

2. totalIngresadoCop > 0
   (salvo ajuste puro)

3. totalIngresadoCop ≤ saldoInicialCop

4. Si ajuste activo → diferenciaCop > 0

5. Para cada split con montoCop > 0:

   • banco (si needsBanco)
   • referencia (si needsReferencia)
   • last4 (si needsLast4, regex ^\d{4}$)
   • nota (si needsNota)

6. fechaTransaccion >= fechaCreacionCuenta

7. Si diferenciaCop == 0 → forzar ajuste = false

Sin validaciones paralelas.
Sin short-circuit arbitrarios.

────────────────────────────────────────────────────────────────────────────── 9. PERFORMANCE REACTIVA
──────────────────────────────────────────────────────────────────────────────

Prohibido:
.refresh() por cada tecla.

Obligatorio:
debounce ≈ 140ms para recalcular totales.

CxC y CxP deben mantener comportamiento idéntico.

────────────────────────────────────────────────────────────────────────────── 10. INCUMPLIMIENTO
──────────────────────────────────────────────────────────────────────────────

Se considera incumplimiento técnico:

• Uso de double para dinero.
• Duplicación de reglas de obligatoriedad.
• Strings modificados.
• Lógica de ajuste con tolerancias flotantes.
• Datos ocultos no limpiados al cambiar método.
• Validaciones fuera del orden establecido.

Incumplimiento = refactor obligatorio.

────────────────────────────────────────────────────────────────────────────── 11. ESTÁNDAR ENTERPRISE
──────────────────────────────────────────────────────────────────────────────

Este documento convierte el módulo contable en:

• Determinístico.
• Auditable.
• Simétrico (CxC = CxP).
• Sin errores de redondeo.
• Preparado para conciliación bancaria futura.
• Escalable a factoring, pasarelas, cripto, multimoneda futura.

Extensiones futuras deberán:

• Extender enum CollectionMethod.
• Implementar nuevas políticas dentro de CollectionMethodPolicyX.
• No romper las reglas existentes.
• Mantener representación int COP.

──────────────────────────────────────────────────────────────────────────────
FIN — DOCUMENTO CANÓNICO OFICIAL
──────────────────────────────────────────────────────────────────────────────
