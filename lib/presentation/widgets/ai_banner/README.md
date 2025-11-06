# AIBanner - Widget Reutilizable de Banner de IA

Widget global y desacoplado para mostrar alertas y recomendaciones de IA con rotación automática.

## Características

- ✅ **Rotación automática** de mensajes configurable
- ✅ **Modal integrado** con lista completa de recomendaciones
- ✅ **Colores desde tema** con soporte para dark mode
- ✅ **Variante sticky** para CustomScrollView (`SliverAIBanner`)
- ✅ **Accesibilidad**: Contraste AA, touch targets ≥44px, semantic labels
- ✅ **Animaciones suaves** con AnimatedSwitcher
- ✅ **Zero dependencias** externas

## Uso Básico

```dart
import 'package:avanzza/presentation/widgets/ai_banner/ai_banner.dart';

// Definir mensajes
const messages = [
  AIBannerMessage(
    type: 'success',
    icon: Icons.check_circle,
    text: 'Todo está funcionando correctamente',
  ),
  AIBannerMessage(
    type: 'warning',
    icon: Icons.warning_amber,
    text: 'Atención: Revisa las configuraciones pendientes',
  ),
  AIBannerMessage(
    type: 'danger',
    icon: Icons.error,
    text: 'Alerta: Acción requerida urgentemente',
  ),
  AIBannerMessage(
    type: 'info',
    icon: Icons.info,
    text: 'Tip: Puedes optimizar el rendimiento',
  ),
];

// Usar el banner
AIBanner(
  messages: messages,
  rotationInterval: Duration(seconds: 5),
)
```

## Uso con CustomScrollView (Sticky)

Para que el banner se fije en la parte superior del scroll:

```dart
CustomScrollView(
  slivers: [
    // Banner sticky (pinned)
    SliverAIBanner(
      messages: messages,
      rotationInterval: Duration(seconds: 5),
    ),

    // Otros slivers
    SliverList(...),
    SliverGrid(...),
  ],
)
```

## Tipos de Mensajes

| Tipo | Color | Uso recomendado |
|------|-------|------------------|
| `success` | Verde | Confirmaciones, logros, estado saludable |
| `warning` | Naranja/Ámbar | Advertencias, acciones sugeridas |
| `danger` | Rojo | Alertas críticas, errores importantes |
| `info` | Azul | Información general, tips, recomendaciones |

## Personalización

### Callback personalizado al hacer tap

```dart
AIBanner(
  messages: messages,
  onTap: () {
    // Navegar a otra pantalla
    Get.toNamed('/ai-recommendations');
  },
)
```

### Modal personalizado

```dart
AIBanner(
  messages: messages,
  detailsBuilder: (context) {
    // Tu modal personalizado
    return MyCustomModal(messages: messages);
  },
)
```

### Ajustes visuales

```dart
AIBanner(
  messages: messages,
  padding: EdgeInsets.all(20),
  borderRadius: BorderRadius.circular(16),
)
```

## Renderizado Condicional

El widget automáticamente se oculta si no hay mensajes:

```dart
// Si messages está vacío, devuelve SizedBox.shrink()
AIBanner(messages: []) // No renderiza nada
```

## Ejemplo Completo (AdminAccountingPage)

```dart
Container(
  color: Theme.of(context).scaffoldBackgroundColor,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: const AIBanner(
    messages: [
      AIBannerMessage(
        type: 'success',
        icon: Icons.auto_graph_rounded,
        text: 'Liquidez saludable (+12%). Flujo neto positivo este mes.',
      ),
      AIBannerMessage(
        type: 'warning',
        icon: Icons.local_gas_station_rounded,
        text: 'IA: reduce combustible 8% → utilidad +9%.',
      ),
      AIBannerMessage(
        type: 'danger',
        icon: Icons.priority_high_rounded,
        text: 'Alerta: presupuesto de gastos supera el 110% del plan.',
      ),
    ],
    rotationInterval: Duration(seconds: 5),
  ),
)
```

## Arquitectura

```
AIBanner (StatefulWidget)
├── Timer para rotación automática
├── AnimatedSwitcher para transiciones
├── InkWell para interacción
└── Modal con lista completa (default o custom)

SliverAIBanner (StatelessWidget)
└── SliverPersistentHeader (pinned)
    └── _AIBannerHeaderDelegate
        └── AIBanner
```

## Propiedades

### AIBanner / SliverAIBanner

| Propiedad | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| `messages` | `List<AIBannerMessage>` | Sí | - | Lista de mensajes a rotar |
| `rotationInterval` | `Duration` | No | `Duration(seconds: 5)` | Intervalo entre cambios |
| `onTap` | `VoidCallback?` | No | `null` | Callback al tocar (default: abre modal) |
| `detailsBuilder` | `WidgetBuilder?` | No | `null` | Builder para modal personalizado |
| `padding` | `EdgeInsetsGeometry?` | No | `EdgeInsets.symmetric(horizontal: 14, vertical: 12)` | Padding interno |
| `borderRadius` | `BorderRadius?` | No | `BorderRadius.circular(12)` | Border radius del contenedor |

### AIBannerMessage

| Propiedad | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `type` | `String` | Sí | Tipo: `'success'`, `'warning'`, `'danger'`, `'info'` |
| `icon` | `IconData` | Sí | Ícono del mensaje |
| `text` | `String` | Sí | Texto del mensaje (máx. 2 líneas) |

## Notas de Accesibilidad

- ✅ Touch targets ≥ 44px de altura
- ✅ Contraste AA entre texto y fondo
- ✅ Semantic labels en íconos
- ✅ MaxLines y overflow configurados
- ✅ InkWell con borderRadius para feedback táctil

## Soporte de Tema

El widget usa colores del `Theme.of(context).colorScheme`:

- **success**: Verde `Color(0xFF10B981)` (Emerald 500)
- **warning**: Naranja `Color(0xFFF59E0B)` (Amber 500)
- **danger**: `colorScheme.error`
- **info**: `colorScheme.primary`

Funciona correctamente en modo claro y oscuro.

## Migración desde _DynamicAIBanner

Si estabas usando las clases privadas `_AIMsg` y `_DynamicAIBanner`:

**Antes:**
```dart
child: const _DynamicAIBanner(),
```

**Después:**
```dart
child: const AIBanner(
  messages: [
    AIBannerMessage(
      type: 'success',
      icon: Icons.check_circle,
      text: 'Tu mensaje aquí',
    ),
  ],
)
```

## Mantenimiento

- **Archivo**: `lib/presentation/widgets/ai_banner/ai_banner.dart`
- **Líneas**: ~460
- **Dependencias**: Solo Flutter + Material
- **Tests**: Pendiente (añadir tests unitarios y de widget)
