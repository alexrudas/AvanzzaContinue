# Avanzza — Configuraciones de ejecución por ambiente

Los hosts de las APIs se eligen vía `--dart-define`. La fuente de verdad es
[`lib/core/config/api_endpoints.dart`](../lib/core/config/api_endpoints.dart);
los defaults del archivo **no se tocan** — los flags los sobreescriben en
runtime.

## Cuándo usar cuál

| Configuración | Core API | Integrations (RUNT/SIMIT/VRC) | Estado |
|---|---|---|---|
| **Avanzza Dev Local** | `http://192.168.1.83:3000` | `http://192.168.1.83:3001` | ✅ ÚNICA config aprobada hoy. Desarrollo en LAN. |
| **Avanzza Hetzner Integrations only** | *(no seteado)* | `http://178.156.227.90` | ⛔ PENDIENTE — no usar para flujos que tocan Core. Falta confirmar host/puerto de Core en prod. |

> Mientras Core en Hetzner no esté confirmado, **siempre usa "Avanzza Dev Local"**. La segunda config queda como recordatorio del trabajo pendiente; lanzarla con un flujo que pegue a Core API enviaría las requests al default local — no es prod real.

## VS Code

`.vscode/launch.json` ya tiene las dos configuraciones. Selecciona en la barra
de Run & Debug y presiona F5.

## Terminal

### Dev Local

```bash
flutter run \
  --dart-define=AVANZZA_CORE_URL=http://192.168.1.83:3000 \
  --dart-define=AVANZZA_INTEGRATIONS_URL=http://192.168.1.83:3001
```

### Hetzner (PENDIENTE — no usar todavía)

Core en Hetzner aún no está confirmado. Cuando se sepa el host real,
completar este comando (y `launch.json`) con el flag de Core. Ejemplo
plantilla:

```bash
# RECHAZADO HASTA CONFIRMAR HOST DE CORE EN PROD
flutter run \
  --dart-define=AVANZZA_CORE_URL=<HOST-CORE-PROD> \
  --dart-define=AVANZZA_INTEGRATIONS_URL=http://178.156.227.90
```

> En Windows PowerShell usa `` ` `` (backtick) en vez de `\` para continuar
> la línea, o ponlo todo en una sola línea.

## Reglas

- Un build = un ambiente. No se mezclan dev y prod.
- Cualquier nuevo host (staging, producción definitiva) se agrega como **otra
  configuración**, no como fallback dinámico.
- Si cambias los puertos del servidor local, actualiza ambas líneas
  (`launch.json` + este documento).
