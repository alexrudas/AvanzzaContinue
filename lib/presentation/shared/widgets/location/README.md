# Sistema de Widgets de Localización

Sistema modular y reutilizable para selección de localización geográfica (País, Región, Ciudad) en Avanzza 2.0.

## Arquitectura

### Controlador: LocationController

**Path:** `lib/presentation/location/controllers/location_controller.dart`

Controlador GetX que centraliza toda la lógica de localización:

- ✅ Carga de países, regiones y ciudades desde `GeoRepository`
- ✅ Gestión de estados de selección (selectedCountryId, selectedRegionId, selectedCityId)
- ✅ Manejo de cascada (cambio de país resetea región/ciudad)
- ✅ Estados de carga (isLoadingCountries, isLoadingRegions, isLoadingCities)
- ✅ Manejo de errores unificado

**Registrado en DI:** `lib/core/di/app_bindings.dart` (lazyPut con fenix: true)

---

## Widgets

### 1. CountrySelectorField

**Path:** `country_selector_field.dart`

Widget para seleccionar un país.

```dart
CountrySelectorField(
  initialValue: 'col',
  enabled: true,
  onChanged: (country) {
    print('País: ${country.name}');
  },
)
```

**Props:**
- `initialValue`: String? - ID del país inicial
- `enabled`: bool - Habilitar/deshabilitar campo (default: true)
- `onChanged`: ValueChanged<CountryEntity>? - Callback al seleccionar
- `labelText`: String? - Etiqueta personalizada (default: 'País')
- `contentPadding`: EdgeInsetsGeometry? - Padding del ListTile

---

### 2. RegionSelectorField

**Path:** `region_selector_field.dart`

Widget para seleccionar una región/estado. Depende de país.

```dart
RegionSelectorField(
  countryId: 'col',
  initialValue: 'col-ant',
  enabled: true,
  onChanged: (region) {
    print('Región: ${region.name}');
  },
)
```

**Props:**
- `countryId`: String? - ID del país (requerido, si es null se deshabilita)
- `initialValue`: String? - ID de la región inicial
- `enabled`: bool - Habilitar/deshabilitar campo
- `onChanged`: ValueChanged<RegionEntity>? - Callback al seleccionar
- `labelText`: String? - Etiqueta personalizada (default: 'Región/Estado')

**Comportamiento:**
- Si `countryId == null`: deshabilitado con hint "Primero selecciona un país"
- Carga automática de regiones cuando cambia countryId

---

### 3. CitySelectorField

**Path:** `city_selector_field.dart`

Widget para seleccionar una ciudad. Depende de país y región.

```dart
CitySelectorField(
  countryId: 'col',
  regionId: 'col-ant',
  initialValue: 'col-ant-med',
  enabled: true,
  onChanged: (city) {
    print('Ciudad: ${city.name}');
  },
)
```

**Props:**
- `countryId`: String? - ID del país (requerido)
- `regionId`: String? - ID de la región (requerido)
- `initialValue`: String? - ID de la ciudad inicial
- `enabled`: bool - Habilitar/deshabilitar campo
- `onChanged`: ValueChanged<CityEntity>? - Callback al seleccionar
- `labelText`: String? - Etiqueta personalizada (default: 'Ciudad')

**Comportamiento:**
- Si `countryId == null`: deshabilitado con hint "Primero selecciona un país"
- Si `regionId == null`: deshabilitado con hint "Primero selecciona una región"
- Carga automática de ciudades cuando cambian countryId o regionId

---

### 4. LocationSelector (Orquestador)

**Path:** `location_selector.dart`

Widget compuesto que orquesta los 3 selectores con gestión automática de cascada.

```dart
LocationSelector(
  initialCountryId: 'col',
  initialRegionId: 'col-ant',
  initialCityId: 'col-ant-med',
  onChanged: (selection) {
    if (selection.isComplete) {
      print('Selección completa: ${selection.countryId}');
    }
  },
)
```

**Props:**
- `showCountry`: bool - Mostrar selector de país (default: true)
- `showRegion`: bool - Mostrar selector de región (default: true)
- `showCity`: bool - Mostrar selector de ciudad (default: true)
- `initialCountryId`: String? - ID inicial del país
- `initialRegionId`: String? - ID inicial de la región
- `initialCityId`: String? - ID inicial de la ciudad
- `onChanged`: ValueChanged<LocationSelection> - Callback con selección completa
- `spacing`: double - Espacio entre selectores (default: 8.0)
- `enabled`: bool - Habilitar/deshabilitar todos los selectores

**Gestión de Cascada Automática:**
- Cambio de país → resetea región y ciudad
- Cambio de región → resetea ciudad
- Cada cambio dispara `onChanged` con estado actualizado

**Configuraciones posibles:**
```dart
// Solo país
LocationSelector(
  showCountry: true,
  showRegion: false,
  showCity: false,
  onChanged: (sel) => print(sel.countryId),
)

// País + Ciudad (sin región)
LocationSelector(
  showCountry: true,
  showRegion: false,
  showCity: true,
  onChanged: (sel) => print('${sel.countryId} - ${sel.cityId}'),
)
```

---

## Modelo de Datos

### LocationSelection

**Path:** `lib/domain/entities/location/location_selection.dart`

Modelo inmutable que encapsula la selección de localización.

```dart
class LocationSelection {
  final String? countryId;
  final String? regionId;
  final String? cityId;

  bool get isComplete;  // true si los 3 están seleccionados
  bool get isEmpty;     // true si ninguno está seleccionado
  bool get hasCountry;  // true si al menos país está seleccionado
  bool get hasRegion;   // true si país y región están seleccionados
}
```

---

## Ejemplo de Uso Completo

### En una página de registro:

```dart
import 'package:flutter/material.dart';
import 'package:avanzza/presentation/shared/widgets/location/location_widgets.dart';
import 'package:avanzza/domain/entities/location/location_selection.dart';

class MyRegistrationPage extends StatefulWidget {
  @override
  State<MyRegistrationPage> createState() => _MyRegistrationPageState();
}

class _MyRegistrationPageState extends State<MyRegistrationPage> {
  LocationSelection _selection = const LocationSelection();

  void _handleLocationChange(LocationSelection selection) {
    setState(() {
      _selection = selection;
    });

    // Guardar en controlador, repositorio, etc.
    print('Nueva selección: ${selection.countryId}, ${selection.regionId}, ${selection.cityId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Selecciona tu ubicación'),

          LocationSelector(
            initialCountryId: _selection.countryId,
            initialRegionId: _selection.regionId,
            initialCityId: _selection.cityId,
            onChanged: _handleLocationChange,
          ),

          ElevatedButton(
            onPressed: _selection.isComplete ? _continue : null,
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _continue() {
    // Procesar selección completa
  }
}
```

---

## Integración con Sistema DI

### Controlador registrado en app_bindings.dart:

```dart
Get.lazyPut<LocationController>(
  () => LocationController(DIContainer().geoRepository),
  fenix: true,
);
```

**Uso en widgets:**
```dart
final controller = Get.find<LocationController>();
```

---

## Dependencias

- **GetX:** Para reactive state management
- **GeoRepository:** Fuente de datos de países/regiones/ciudades
- **BottomSheetSelector:** Widget de selección modal compartido
- **CountryEntity, RegionEntity, CityEntity:** Modelos del dominio

---

## Ventajas del Diseño

✅ **Reutilizable:** Los widgets pueden usarse en cualquier parte de la app
✅ **Desacoplado:** No depende de RegistrationController ni de flujos específicos
✅ **Testeable:** LocationController fácil de mockear para tests
✅ **Mantenible:** Lógica centralizada en un solo lugar
✅ **Escalable:** Fácil agregar nuevos casos de uso (filtros, búsquedas, etc.)
✅ **Consistente:** Comportamiento uniforme en toda la aplicación

---

## Casos de Uso Actuales

1. **Registro de usuario:** [select_country_city_page.dart](../../../auth/pages/select_country_city_page.dart)
2. **Perfil de proveedor:** (futuro) filtrar cobertura de servicios
3. **Filtros de búsqueda:** (futuro) filtrar activos por ubicación
4. **Configuración de organización:** (futuro) ubicación de sucursales

---

## Mejoras Futuras

- [ ] Modo de selección múltiple (ej: múltiples ciudades para cobertura)
- [ ] Búsqueda asíncrona con debounce en los selectores
- [ ] Persistencia automática en SharedPreferences
- [ ] Caché de selecciones recientes
- [ ] Soporte para geolocalización automática (GPS)
- [ ] Modo compacto (Dropdowns en vez de BottomSheet)

---

**Fecha de creación:** 2025-12-10
**Última actualización:** 2025-12-10
**Autor:** Sistema de localización Avanzza 2.0
