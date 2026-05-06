// ============================================================================
// DEMO REGISTRATION V2 — IN-MEMORY STATE (TEMPORARY, SAFE TO DELETE)
//
// Estado en memoria del flujo de registro v2 (demo).
// Vive solo mientras la app está abierta; al cerrar/recargar se pierde.
// No escribe en Isar, Firebase, SharedPreferences ni en ningún repositorio.
// ============================================================================

import 'package:flutter/foundation.dart';

enum DemoTitularType { persona, empresa }

enum DemoRoleCode {
  owner,
  assetAdmin,
  renter,
  provider,
  asesor,
  insurer,
  legal,
  // Broker = intermediación de activos (no proveedor con inventario propio,
  // no asegurador). Cubre gestor/corredor inmobiliario, comercializador
  // de vehículos, y futuros gestores de maquinaria/equipos.
  // Ver decisión estratégica 2026-05 en q3_intent.dart Bloque 5.
  broker,
}

enum DemoAdminScope { propios, terceros, ambos }

enum DemoOwnerScope { self, third, both }

enum DemoAssetType { vehiculo, inmueble, maquinaria, equipo, otro }

/// Sub-rol del Arrendatario, declarado por el usuario en P6.
/// El usuario puede ser combinaciones de los tres en su workspace, pero al
/// onboarding declara el primario.
///
/// Mapping desde renterMarket (en `_onContinueService` de q3_intent.dart):
///   vehiculo  → conductor
///   inmueble  → inquilino
///   maquinaria → cliente (modelo: el que arrienda maquinaria es cliente,
///                          independiente de si la opera él mismo o tercero)
///   equipo    → cliente
enum DemoRenterSubrole {
  conductor('conductor', 'Conductor'),
  inquilino('inquilino', 'Inquilino'),
  cliente('cliente', 'Cliente');

  final String code;
  final String label;
  const DemoRenterSubrole(this.code, this.label);
}

/// Tipo de oferta del Proveedor. Un workspace = una oferta.
/// Si el proveedor también vende lo otro, crea un workspace adicional.
/// Capturado en Q3 (registro) — directamente en la card seleccionada
/// (productos vs servicios son cards distintas en Bloque 3 de Proveedores).
enum DemoProviderOfferType {
  productos('productos', 'Productos'),
  servicios('servicios', 'Servicios');

  final String code;
  final String label;
  const DemoProviderOfferType(this.code, this.label);
}

/// Especialidad del Asegurador / Broker. Single-select en P3 follow-up.
enum DemoInsurerSpecialty {
  seguros('seguros', 'Seguros'),
  inmobiliario('inmobiliario', 'Inmobiliario');

  final String code;
  final String label;
  const DemoInsurerSpecialty(this.code, this.label);
}

/// Especialidad del Abogado / Firma legal. Single-select en P3 follow-up.
enum DemoLegalSpecialty {
  civil('civil', 'Civil'),
  penal('penal', 'Penal'),
  ambas('ambas', 'Ambas');

  final String code;
  final String label;
  const DemoLegalSpecialty(this.code, this.label);
}

class DemoRegistrationState extends ChangeNotifier {
  // ── P1 ───────────────────────────────────────────────────────────────────
  String countryDialCode = '+57';
  String phone = '';
  bool acceptedTerms = false;

  // ── P2 ───────────────────────────────────────────────────────────────────
  String otp = '';
  bool otpVerified = false;

  /// Identificador devuelto por Firebase cuando se invoca `sendOtp(phone)`
  /// en P1. Se usa en P2 para `verifyOtp(verificationId, code)`. Null si
  /// aún no se envió OTP o si Firebase auto-verificó (en cuyo caso el uid
  /// queda directamente en FirebaseAuth.instance.currentUser).
  String? verificationId;

  /// True si el usuario completó la verificación OTP contra Firebase y
  /// existe `FirebaseAuth.instance.currentUser`. Diferente de otpVerified
  /// (legacy, solo UI). Sin esto en true, el commit final (Q6) NO debe
  /// proceder.
  bool firebaseAuthenticated = false;

  // ── P3 ───────────────────────────────────────────────────────────────────
  DemoTitularType titularType = DemoTitularType.persona;
  String fullNameOrCompany = '';
  String countryCode = 'CO';
  String countryName = 'Colombia';
  String city = '';

  /// NIT colombiano (solo Empresa). 9 dígitos sin DV — el DV se calcula
  /// vía módulo 11 y se muestra inmutable en helper text.
  String nit = '';

  /// IDs del catálogo geográfico CO (cuando se usa LocationSelector).
  /// `regionId` = departamento (ej. 'col-ant'), `cityId` = ciudad (ej. 'col-ant-med').
  /// El `city` (string libre) se sigue manteniendo para retrocompat con
  /// código que solo lee texto, pero ahora se puebla del cityName del catálogo.
  String? regionId;
  String? cityId;
  String? regionName;

  // ── P4 ───────────────────────────────────────────────────────────────────
  DemoRoleCode? role;
  DemoAdminScope? adminScope;
  DemoOwnerScope? ownerScope;

  // ── P6 (configuración post-bienvenida) ───────────────────────────────────
  /// Tipo de activo elegido por Owner/Admin en P6.
  DemoAssetType? assetType;

  /// Sub-rol elegido por Arrendatario en P4 (follow-up inline).
  DemoRenterSubrole? renterSubrole;

  /// Mercado que atiende el Proveedor (single-select). P3 follow-up inline.
  /// Un workspace = un mercado. Si el proveedor atiende varios, crea
  /// otro workspace por cada uno (mismo principio que Productos XOR Servicios).
  DemoAssetType? providerMarket;

  /// Tipo de oferta del Proveedor (Productos XOR Servicios).
  DemoProviderOfferType? providerOfferType;

  /// Especialidades seleccionadas del catálogo (multi-select).
  final Set<String> providerSpecialties = {};

  /// Especialidad libre cuando ninguna del catálogo encaja ("Otra…").
  String providerOtherSpecialty = '';

  /// Mercado que atiende el Asesor comercial (single-select). P3 follow-up.
  /// Misma estructura que `providerMarket` pero conceptualmente distinto:
  /// asesor vende productos/servicios de terceros a comisión, no su propio
  /// inventario.
  DemoAssetType? asesorMarket;

  /// Mercado al que el Arrendatario quiere acceder (single-select). P3 follow-up.
  /// Estructura paralela a `asesorMarket` pero conceptualmente distinto:
  /// el renter NO posee el activo, lo toma en arriendo o lo opera.
  /// No se usa `assetType` para evitar que el routing dispatchee a Q5
  /// (registro de activo con RUNT) — el renter no registra activos propios.
  DemoAssetType? renterMarket;

  /// Especialidad del Asegurador / Broker, capturada en P3 follow-up.
  /// NOTA 2026-05: actualmente DORMIDO (Invisible Broker para seguros).
  /// Solo se reactivará tras Fase 0 con corredor de seguros real.
  DemoInsurerSpecialty? insurerSpecialty;

  /// Mercado del Broker (gestor/comercializador de activos). Single-select.
  /// Capturado en P3 cuando el usuario elige una card del Bloque 5 de
  /// gestión/comercialización. Reusa `DemoAssetType` porque el broker
  /// SIEMPRE intermedia un tipo de activo.
  ///
  /// Mapping en q3_intent.dart:
  ///   'broker_inmobiliario' → role=broker, brokerMarket=inmueble
  ///   'broker_vehiculos'    → role=broker, brokerMarket=vehiculo
  ///   (futuro) maquinaria + equipo bajo el mismo patrón
  DemoAssetType? brokerMarket;

  /// Especialidad del Abogado / Legal, capturada en P3 follow-up.
  DemoLegalSpecialty? legalSpecialty;

  /// Datos del activo capturados en P6 (placa, marca, dirección, etc.).
  /// Map flexible porque cada tipo tiene campos distintos.
  final Map<String, String> assetData = {};

  /// El usuario completó la configuración (CTA primario en P5/P6).
  bool configCompleted = false;

  /// El usuario saltó la configuración (link disuasivo).
  bool configSkipped = false;

  // ── Step control ─────────────────────────────────────────────────────────
  int step = 0;

  void setStep(int v) {
    step = v;
    notifyListeners();
  }

  void next() {
    step += 1;
    notifyListeners();
  }

  void back() {
    if (step > 0) step -= 1;
    notifyListeners();
  }

  void goTo(int v) {
    step = v;
    notifyListeners();
  }

  void reset() {
    countryDialCode = '+57';
    phone = '';
    acceptedTerms = false;
    otp = '';
    otpVerified = false;
    verificationId = null;
    firebaseAuthenticated = false;
    titularType = DemoTitularType.persona;
    fullNameOrCompany = '';
    countryCode = 'CO';
    countryName = 'Colombia';
    city = '';
    nit = '';
    regionId = null;
    cityId = null;
    regionName = null;
    role = null;
    adminScope = null;
    ownerScope = null;
    assetType = null;
    renterSubrole = null;
    providerMarket = null;
    providerOfferType = null;
    providerSpecialties.clear();
    providerOtherSpecialty = '';
    asesorMarket = null;
    renterMarket = null;
    insurerSpecialty = null;
    brokerMarket = null;
    legalSpecialty = null;
    assetData.clear();
    configCompleted = false;
    configSkipped = false;
    step = 0;
    notifyListeners();
  }

  void update(VoidCallback mutate) {
    mutate();
    notifyListeners();
  }

  // ── Helpers de rol ───────────────────────────────────────────────────────
  /// ¿Este rol requiere configuración post-bienvenida?
  bool get roleNeedsConfig {
    if (role == null) return false;
    // Empresa + Insurer salta config (cubren todo).
    if (role == DemoRoleCode.insurer && titularType == DemoTitularType.empresa) {
      return false;
    }
    // Renter ya respondió su sub-rol en P4 (follow-up inline).
    if (role == DemoRoleCode.renter) {
      return false;
    }
    // Provider responde mercados en P3 (follow-up inline).
    if (role == DemoRoleCode.provider) {
      return false;
    }
    // Asesor comercial responde mercados en P3 (follow-up inline).
    if (role == DemoRoleCode.asesor) {
      return false;
    }
    return true;
  }

  // ── Serialización ────────────────────────────────────────────────────────
  // Orientada a `OnboardingSessionService` (persistencia Isar como blob JSON).
  // No depende de json_serializable: el state es local del flow demo y los
  // enums se mapean por nombre (Enum.name) que ya es estable mientras los
  // valores no se renombren.

  Map<String, dynamic> toJson() => <String, dynamic>{
        'countryDialCode': countryDialCode,
        'phone': phone,
        'acceptedTerms': acceptedTerms,
        'otp': otp,
        'otpVerified': otpVerified,
        'verificationId': verificationId,
        'firebaseAuthenticated': firebaseAuthenticated,
        'titularType': titularType.name,
        'fullNameOrCompany': fullNameOrCompany,
        'countryCode': countryCode,
        'countryName': countryName,
        'city': city,
        'nit': nit,
        'regionId': regionId,
        'cityId': cityId,
        'regionName': regionName,
        'role': role?.name,
        'adminScope': adminScope?.name,
        'ownerScope': ownerScope?.name,
        'assetType': assetType?.name,
        'renterSubrole': renterSubrole?.code,
        'providerMarket': providerMarket?.name,
        'providerOfferType': providerOfferType?.code,
        'providerSpecialties': providerSpecialties.toList(),
        'providerOtherSpecialty': providerOtherSpecialty,
        'asesorMarket': asesorMarket?.name,
        'renterMarket': renterMarket?.name,
        'insurerSpecialty': insurerSpecialty?.code,
        'brokerMarket': brokerMarket?.name,
        'legalSpecialty': legalSpecialty?.code,
        'assetData': Map<String, String>.from(assetData),
        'configCompleted': configCompleted,
        'configSkipped': configSkipped,
        'step': step,
      };

  /// Aplica un snapshot previamente serializado. No emite `notifyListeners`:
  /// el caller decide cuándo notificar (típicamente una sola vez tras
  /// `goTo(restoredStep)`).
  ///
  /// Throws [FormatException] si el JSON tiene un valor de enum desconocido
  /// (schema drift). El [OnboardingSessionService] captura y borra la sesión
  /// para reiniciar limpio en Q1.
  void applyJson(Map<String, dynamic> json) {
    countryDialCode = (json['countryDialCode'] as String?) ?? '+57';
    phone = (json['phone'] as String?) ?? '';
    acceptedTerms = (json['acceptedTerms'] as bool?) ?? false;
    otp = (json['otp'] as String?) ?? '';
    otpVerified = (json['otpVerified'] as bool?) ?? false;
    verificationId = json['verificationId'] as String?;
    firebaseAuthenticated = (json['firebaseAuthenticated'] as bool?) ?? false;
    titularType = _enumByName(
      DemoTitularType.values,
      json['titularType'] as String?,
      fallback: DemoTitularType.persona,
    );
    fullNameOrCompany = (json['fullNameOrCompany'] as String?) ?? '';
    countryCode = (json['countryCode'] as String?) ?? 'CO';
    countryName = (json['countryName'] as String?) ?? 'Colombia';
    city = (json['city'] as String?) ?? '';
    nit = (json['nit'] as String?) ?? '';
    regionId = json['regionId'] as String?;
    cityId = json['cityId'] as String?;
    regionName = json['regionName'] as String?;
    role = _nullableEnumByName(DemoRoleCode.values, json['role'] as String?);
    adminScope =
        _nullableEnumByName(DemoAdminScope.values, json['adminScope'] as String?);
    ownerScope =
        _nullableEnumByName(DemoOwnerScope.values, json['ownerScope'] as String?);
    assetType =
        _nullableEnumByName(DemoAssetType.values, json['assetType'] as String?);
    renterSubrole = _nullableRenterSubrole(json['renterSubrole'] as String?);
    providerMarket = _nullableEnumByName(
        DemoAssetType.values, json['providerMarket'] as String?);
    providerOfferType =
        _nullableProviderOfferType(json['providerOfferType'] as String?);
    providerSpecialties
      ..clear()
      ..addAll(((json['providerSpecialties'] as List?) ?? const [])
          .whereType<String>());
    providerOtherSpecialty =
        (json['providerOtherSpecialty'] as String?) ?? '';
    asesorMarket = _nullableEnumByName(
        DemoAssetType.values, json['asesorMarket'] as String?);
    renterMarket = _nullableEnumByName(
        DemoAssetType.values, json['renterMarket'] as String?);
    insurerSpecialty =
        _nullableInsurerSpecialty(json['insurerSpecialty'] as String?);
    brokerMarket = _nullableEnumByName(
        DemoAssetType.values, json['brokerMarket'] as String?);
    legalSpecialty = _nullableLegalSpecialty(json['legalSpecialty'] as String?);
    assetData
      ..clear()
      ..addAll(_decodeStringMap(json['assetData']));
    configCompleted = (json['configCompleted'] as bool?) ?? false;
    configSkipped = (json['configSkipped'] as bool?) ?? false;
    step = (json['step'] as int?) ?? 0;
  }
}

// ============================================================================
// HELPERS DE DECODIFICACIÓN — privados al archivo. Aceptan null y devuelven
// null cuando aplica. Los enums con `code` (no `name`) tienen su propio helper
// para preservar el wire stable que ya estaba documentado.
// ============================================================================

T _enumByName<T extends Enum>(List<T> values, String? raw, {required T fallback}) {
  if (raw == null) return fallback;
  for (final v in values) {
    if (v.name == raw) return v;
  }
  throw FormatException('Enum desconocido: $raw (válidos: '
      '${values.map((e) => e.name).join(', ')})');
}

T? _nullableEnumByName<T extends Enum>(List<T> values, String? raw) {
  if (raw == null) return null;
  for (final v in values) {
    if (v.name == raw) return v;
  }
  throw FormatException('Enum desconocido: $raw (válidos: '
      '${values.map((e) => e.name).join(', ')})');
}

DemoRenterSubrole? _nullableRenterSubrole(String? raw) {
  if (raw == null) return null;
  for (final v in DemoRenterSubrole.values) {
    if (v.code == raw) return v;
  }
  throw FormatException('DemoRenterSubrole desconocido: $raw');
}

DemoProviderOfferType? _nullableProviderOfferType(String? raw) {
  if (raw == null) return null;
  for (final v in DemoProviderOfferType.values) {
    if (v.code == raw) return v;
  }
  throw FormatException('DemoProviderOfferType desconocido: $raw');
}

DemoInsurerSpecialty? _nullableInsurerSpecialty(String? raw) {
  if (raw == null) return null;
  for (final v in DemoInsurerSpecialty.values) {
    if (v.code == raw) return v;
  }
  throw FormatException('DemoInsurerSpecialty desconocido: $raw');
}

DemoLegalSpecialty? _nullableLegalSpecialty(String? raw) {
  if (raw == null) return null;
  for (final v in DemoLegalSpecialty.values) {
    if (v.code == raw) return v;
  }
  throw FormatException('DemoLegalSpecialty desconocido: $raw');
}

Map<String, String> _decodeStringMap(Object? raw) {
  if (raw is! Map) return const <String, String>{};
  final out = <String, String>{};
  raw.forEach((k, v) {
    if (k is String && v is String) out[k] = v;
  });
  return out;
}
