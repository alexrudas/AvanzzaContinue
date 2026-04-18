// ============================================================================
// lib/data/vrc/models/vrc_models.dart
// VRC MODELS — Data Layer / DTOs
//
// QUÉ HACE:
// - Define todos los DTOs para parsear la respuesta de la API VRC Individual.
// - Cubre el endpoint GET /vrc/:plate/:documentType/:documentNumber.
// - Serializa/deserializa campos defensivamente (null-safe, tipos ricos).
// - VrcDataModel incluye los bloques documentales completos:
//     soat[], rc[], rtm[] como List<Map<String,dynamic>> defensivas,
//     y legal (VrcLegalModel: limitations[], warranties[], propertyLiens).
//
// QUÉ NO HACE:
// - No contiene lógica de negocio ni reglas operativas (ver vrc_rules.dart).
// - No persiste en cache (VRC es read-only, sin Isar).
// - No mapea a entidades de dominio (no existen entidades VRC; los DTOs son
//   el contrato directo entre servicio y controller).
//
// PRINCIPIOS:
// - Un solo archivo agrupa todos los DTOs del módulo (sin micro-archivos).
// - Los campos no garantizados por contrato se tipan como nullable.
// - El campo JSON "model" se lee como modelYear (int?) por colisión con keyword.
// - Conversores defensivos: num→double, int como String, etc.
// - Listas defensivas: siempre retornan [] ante null o tipo incorrecto.
//
// ENTERPRISE NOTES:
// ADAPTADO (2026-04): Fix auditoría VRC — VrcDataModel ahora parsea soat[],
//   rc[], rtm[] y legal (VrcLegalModel). Sin estos campos, los bloques
//   documentales del backend eran descartados silenciosamente en fromJson().
//   Fix complementario en asset_registration_page.dart (_handleConsult).
// ============================================================================

// ── HELPERS ───────────────────────────────────────────────────────────────────

/// Convierte cualquier valor JSON a String? de forma defensiva.
///
/// El backend VRC puede devolver bool, int, num u otros tipos en campos
/// tipados como String. Este helper normaliza sin explotar.
String? _str(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

/// Parsea una fecha en formato "DD/MM/YYYY" a DateTime.
///
/// Usado para comparar fechas de vencimiento de categorías de licencia
/// que el backend RUNT envía en ese formato (no ISO 8601).
/// Retorna null si el string es inválido o null.
DateTime? _parseDdMmYyyy(String? s) {
  if (s == null || s.isEmpty) return null;
  final parts = s.split('/');
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  return DateTime(year, month, day);
}

// ── ROOT ──────────────────────────────────────────────────────────────────────

/// DTO raíz para la respuesta completa del endpoint VRC Individual.
///
/// - [ok] indica éxito técnico de la consulta.
/// - [data] contiene vehículo, propietario y decisión de negocio.
/// - [meta] contiene diagnóstico técnico (sources, requestId, duración).
/// - [error] presente cuando ok == false.
class VrcResponseModel {
  final bool ok;
  final String? source;
  final VrcDataModel? data;
  final VrcMetaModel? meta;
  final VrcErrorModel? error;

  const VrcResponseModel({
    required this.ok,
    this.source,
    this.data,
    this.meta,
    this.error,
  });

  factory VrcResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'];
    final rawError = json['error'];

    return VrcResponseModel(
      ok: (json['ok'] as bool?) ?? false,
      source: _str(json['source']),
      data: rawData is Map<String, dynamic>
          ? VrcDataModel.fromJson(rawData)
          : null,
      meta: rawMeta is Map<String, dynamic>
          ? VrcMetaModel.fromJson(rawMeta)
          : null,
      error: rawError is Map<String, dynamic>
          ? VrcErrorModel.fromJson(rawError)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'ok': ok,
        if (source != null) 'source': source,
        if (data != null) 'data': data!.toJson(),
        if (meta != null) 'meta': meta!.toJson(),
        if (error != null) 'error': error!.toJson(),
      };
}

/// DTO para errores de la API VRC (ok == false).
class VrcErrorModel {
  final String? code;
  final String? message;

  const VrcErrorModel({this.code, this.message});

  factory VrcErrorModel.fromJson(Map<String, dynamic> json) => VrcErrorModel(
        code: _str(json['code']),
        message: _str(json['message']),
      );

  Map<String, dynamic> toJson() => {
        if (code != null) 'code': code,
        if (message != null) 'message': message,
      };
}

// ── DATA ──────────────────────────────────────────────────────────────────────

/// DTO para el bloque `data` de la respuesta VRC.
///
/// Contiene vehículo, propietario, decisión de negocio y los bloques
/// documentales: SOAT, RC, RTM y estado jurídico (legal).
/// Un campo null indica que el backend no pudo obtener esa información.
class VrcDataModel {
  final VrcVehicleModel? vehicle;
  final VrcOwnerModel? owner;
  final VrcBusinessDecisionModel? businessDecision;

  /// Registros SOAT del vehículo. Lista defensiva (nunca null).
  final List<Map<String, dynamic>> soat;

  /// Registros de Responsabilidad Civil del vehículo. Lista defensiva.
  final List<Map<String, dynamic>> rc;

  /// Registros RTM (Revisión Técnico-Mecánica). Lista defensiva.
  final List<Map<String, dynamic>> rtm;

  /// Estado jurídico: limitaciones, garantías/gravámenes y prenda.
  final VrcLegalModel? legal;

  const VrcDataModel({
    this.vehicle,
    this.owner,
    this.businessDecision,
    List<Map<String, dynamic>>? soat,
    List<Map<String, dynamic>>? rc,
    List<Map<String, dynamic>>? rtm,
    this.legal,
  })  : soat = soat ?? const [],
        rc = rc ?? const [],
        rtm = rtm ?? const [];

  factory VrcDataModel.fromJson(Map<String, dynamic> json) {
    final rawVehicle = json['vehicle'];
    final rawOwner = json['owner'];
    final rawDecision = json['businessDecision'];
    final rawLegal = json['legal'];

    // Parsea defensivamente una clave del JSON como List<Map<String, dynamic>>.
    // Descarta entradas que no sean Map para evitar explosiones en runtime.
    List<Map<String, dynamic>> parseList(dynamic raw) {
      if (raw is! List) return const [];
      return raw.whereType<Map<String, dynamic>>().toList();
    }

    return VrcDataModel(
      vehicle: rawVehicle is Map<String, dynamic>
          ? VrcVehicleModel.fromJson(rawVehicle)
          : null,
      owner: rawOwner is Map<String, dynamic>
          ? VrcOwnerModel.fromJson(rawOwner)
          : null,
      businessDecision: rawDecision is Map<String, dynamic>
          ? VrcBusinessDecisionModel.fromJson(rawDecision)
          : null,
      soat: parseList(json['soat']),
      rc: parseList(json['rc']),
      rtm: parseList(json['rtm']),
      legal: rawLegal is Map<String, dynamic>
          ? VrcLegalModel.fromJson(rawLegal)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (vehicle != null) 'vehicle': vehicle!.toJson(),
        if (owner != null) 'owner': owner!.toJson(),
        if (businessDecision != null) 'businessDecision': businessDecision!.toJson(),
        if (soat.isNotEmpty) 'soat': soat,
        if (rc.isNotEmpty) 'rc': rc,
        if (rtm.isNotEmpty) 'rtm': rtm,
        if (legal != null) 'legal': legal!.toJson(),
      };
}

// ── LEGAL ─────────────────────────────────────────────────────────────────────

/// DTO para el bloque `data.legal` de la respuesta VRC.
///
/// Contiene las tres fuentes del estado jurídico del vehículo:
/// - [limitations]: limitaciones a la propiedad (embargos, medidas cautelares…).
/// - [warranties]: garantías y gravámenes (hipotecas, prendas…).
/// - [propertyLiens]: prenda (texto libre, ej. "NO REGISTRA" o "PRENDA").
///
/// Listas defensivas: nunca null, vacías si el backend no las incluye.
class VrcLegalModel {
  final List<Map<String, dynamic>> limitations;
  final List<Map<String, dynamic>> warranties;

  /// Campo de texto libre del backend para prendas. Ej: "NO REGISTRA".
  final String? propertyLiens;

  const VrcLegalModel({
    List<Map<String, dynamic>>? limitations,
    List<Map<String, dynamic>>? warranties,
    this.propertyLiens,
  })  : limitations = limitations ?? const [],
        warranties = warranties ?? const [];

  factory VrcLegalModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> parseList(dynamic raw) {
      if (raw is! List) return const [];
      return raw.whereType<Map<String, dynamic>>().toList();
    }

    return VrcLegalModel(
      limitations: parseList(json['limitations']),
      warranties: parseList(json['warranties']),
      // "propertyLiens" puede venir como String, bool o null según la fuente RUNT.
      propertyLiens: _str(json['propertyLiens']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (limitations.isNotEmpty) 'limitations': limitations,
        if (warranties.isNotEmpty) 'warranties': warranties,
        if (propertyLiens != null) 'propertyLiens': propertyLiens,
      };
}

// ── VEHICLE ───────────────────────────────────────────────────────────────────

/// DTO para la información del vehículo en VRC.
///
/// NOTA: El campo JSON "model" representa el año del modelo del vehículo.
/// Se deserializa como [modelYear] para evitar colisión con la keyword Dart.
/// Puede venir como int o String — el conversor normaliza ambos.
///
/// Los campos extendidos (color, engineNumber, chassisNumber, vin,
/// engineDisplacement, bodyType, fuelType, transitAuthority,
/// initialRegistrationDate, passengerCapacity, grossWeightKg, axles)
/// son extraídos por el backend desde RUNT Vehículos y expuestos en la
/// respuesta VRC. Se mapean con fallbacks para absorber variaciones de clave.
class VrcVehicleModel {
  final String? plate;
  final String? status;
  // JSON: "brand" (no "make")
  final String? make;
  // JSON: "model" — año como String o int
  final int? modelYear;
  final String? line;
  final String? vehicleClass;
  // JSON: "serviceType" (no "service")
  final String? service;

  // ── Campos extendidos RUNT Vehículos ────────────────────────────────────
  final String? color;
  final String? engineNumber;
  final String? chassisNumber;
  final String? vin;
  // cilindraje en cc — puede venir como int, double o String
  final double? engineDisplacement;
  final String? bodyType;
  final String? fuelType;
  final String? transitAuthority;
  final String? initialRegistrationDate;
  final int? passengerCapacity;
  final double? grossWeightKg;
  final int? axles;

  const VrcVehicleModel({
    this.plate,
    this.status,
    this.make,
    this.modelYear,
    this.line,
    this.vehicleClass,
    this.service,
    this.color,
    this.engineNumber,
    this.chassisNumber,
    this.vin,
    this.engineDisplacement,
    this.bodyType,
    this.fuelType,
    this.transitAuthority,
    this.initialRegistrationDate,
    this.passengerCapacity,
    this.grossWeightKg,
    this.axles,
  });

  factory VrcVehicleModel.fromJson(Map<String, dynamic> json) {
    // "model" puede venir como int o String numérico (año del vehículo)
    final rawModel = json['model'];
    int? modelYear;
    if (rawModel is int) {
      modelYear = rawModel;
    } else if (rawModel is String) {
      modelYear = int.tryParse(rawModel);
    }

    // engineDisplacement (cilindraje) puede venir como int, double o String
    double? engineDisplacement;
    final rawDisp = json['engineDisplacement'] ?? json['cilindraje'];
    if (rawDisp is num) {
      engineDisplacement = rawDisp.toDouble();
    } else if (rawDisp is String) {
      engineDisplacement = double.tryParse(rawDisp);
    }

    // passengerCapacity puede venir como int o String
    int? passengerCapacity;
    final rawPax = json['passengerCapacity'] ?? json['capacidadPasajeros'];
    if (rawPax is int) {
      passengerCapacity = rawPax;
    } else if (rawPax is String) {
      passengerCapacity = int.tryParse(rawPax);
    }

    // grossWeightKg puede venir como num o String
    double? grossWeightKg;
    final rawGross = json['grossWeightKg'] ?? json['pesoKg'];
    if (rawGross is num) {
      grossWeightKg = rawGross.toDouble();
    } else if (rawGross is String) {
      grossWeightKg = double.tryParse(rawGross);
    }

    // axles puede venir como int o String
    int? axles;
    final rawAxles = json['axles'] ?? json['ejes'];
    if (rawAxles is int) {
      axles = rawAxles;
    } else if (rawAxles is String) {
      axles = int.tryParse(rawAxles);
    }

    return VrcVehicleModel(
      plate: _str(json['plate']),
      status: _str(json['status']),
      // Backend envía "brand", no "make"
      make: _str(json['brand'] ?? json['make']),
      modelYear: modelYear,
      line: _str(json['line']),
      vehicleClass: _str(json['vehicleClass']),
      // Backend envía "serviceType", no "service"
      service: _str(json['serviceType'] ?? json['service']),
      color: _str(json['color']),
      // Número de motor: clave principal "engineNumber", fallback "motor"
      engineNumber: _str(json['engineNumber'] ?? json['motor']),
      // Número de chasis: clave principal "chassisNumber", fallback "chasis"
      chassisNumber: _str(json['chassisNumber'] ?? json['chasis']),
      // VIN: clave principal "vin", fallback "vinNumber"
      vin: _str(json['vin'] ?? json['vinNumber']),
      engineDisplacement: engineDisplacement,
      // Carrocería: clave principal "bodyType", fallback "carroceria"
      bodyType: _str(json['bodyType'] ?? json['carroceria'] ?? json['carrocería']),
      // Combustible: clave principal "fuelType", fallback "combustible"
      fuelType: _str(json['fuelType'] ?? json['combustible']),
      // Autoridad de tránsito: clave principal "transitAuthority", fallback "autoridadTransito"
      transitAuthority: _str(json['transitAuthority'] ?? json['autoridadTransito']),
      // Fecha matrícula: clave principal "initialRegistrationDate", fallback "fechaMatricula"
      initialRegistrationDate: _str(
        json['initialRegistrationDate'] ??
            json['fechaMatricula'] ??
            json['fechaMatrícula'],
      ),
      passengerCapacity: passengerCapacity,
      grossWeightKg: grossWeightKg,
      axles: axles,
    );
  }

  Map<String, dynamic> toJson() => {
        if (plate != null) 'plate': plate,
        if (status != null) 'status': status,
        if (make != null) 'brand': make,
        if (modelYear != null) 'model': modelYear,
        if (line != null) 'line': line,
        if (vehicleClass != null) 'vehicleClass': vehicleClass,
        if (service != null) 'serviceType': service,
        if (color != null) 'color': color,
        if (engineNumber != null) 'engineNumber': engineNumber,
        if (chassisNumber != null) 'chassisNumber': chassisNumber,
        if (vin != null) 'vin': vin,
        if (engineDisplacement != null) 'engineDisplacement': engineDisplacement,
        if (bodyType != null) 'bodyType': bodyType,
        if (fuelType != null) 'fuelType': fuelType,
        if (transitAuthority != null) 'transitAuthority': transitAuthority,
        if (initialRegistrationDate != null) 'initialRegistrationDate': initialRegistrationDate,
        if (passengerCapacity != null) 'passengerCapacity': passengerCapacity,
        if (grossWeightKg != null) 'grossWeightKg': grossWeightKg,
        if (axles != null) 'axles': axles,
      };
}

// ── OWNER ─────────────────────────────────────────────────────────────────────

/// DTO para la información del propietario en VRC.
///
/// - [type] es "PERSON" o "COMPANY".
/// - [runt] puede ser null para COMPANY o si el RUNT persona falló.
/// - [simit] puede ser null si SIMIT no devolvió datos.
class VrcOwnerModel {
  /// Tipo de propietario: "PERSON" | "COMPANY"
  final String? type;
  final String? name;
  final String? document;
  final String? documentType;
  final VrcOwnerRuntModel? runt;
  final VrcOwnerSimitModel? simit;

  const VrcOwnerModel({
    this.type,
    this.name,
    this.document,
    this.documentType,
    this.runt,
    this.simit,
  });

  factory VrcOwnerModel.fromJson(Map<String, dynamic> json) {
    final rawRunt = json['runt'];
    final rawSimit = json['simit'];

    return VrcOwnerModel(
      type: _str(json['type']),
      // Backend envía "fullName", no "name"
      name: _str(json['fullName'] ?? json['name']),
      document: _str(json['documentNumber'] ?? json['document']),
      documentType: _str(json['documentType']),
      runt: rawRunt is Map<String, dynamic>
          ? VrcOwnerRuntModel.fromJson(rawRunt)
          : null,
      simit: rawSimit is Map<String, dynamic>
          ? VrcOwnerSimitModel.fromJson(rawSimit)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (type != null) 'type': type,
        if (name != null) 'name': name,
        if (document != null) 'document': document,
        if (documentType != null) 'documentType': documentType,
        if (runt != null) 'runt': runt!.toJson(),
        if (simit != null) 'simit': simit!.toJson(),
      };
}

/// DTO para el bloque RUNT del propietario.
///
/// - [error] no null → el RUNT persona falló (señal de degradación).
/// - [licenses] null es válido para COMPANY (no hay licencias de conducción).
class VrcOwnerRuntModel {
  final String? error;
  final List<VrcLicenseModel>? licenses;

  const VrcOwnerRuntModel({this.error, this.licenses});

  factory VrcOwnerRuntModel.fromJson(Map<String, dynamic> json) {
    final rawLicenses = json['licenses'];
    List<VrcLicenseModel>? licenses;
    if (rawLicenses is List) {
      licenses = rawLicenses
          .whereType<Map<String, dynamic>>()
          .map(VrcLicenseModel.fromJson)
          .toList();
    }

    // "error" puede ser false (bool) o un String de mensaje de error
    final rawError = json['error'];
    final String? errorMsg = (rawError == false || rawError == null)
        ? null
        : _str(rawError);

    return VrcOwnerRuntModel(
      error: errorMsg,
      licenses: licenses,
    );
  }

  Map<String, dynamic> toJson() => {
        if (error != null) 'error': error,
        if (licenses != null) 'licenses': licenses!.map((l) => l.toJson()).toList(),
      };
}

/// DTO para una categoría individual de la licencia de conducción.
///
/// Las licencias RUNT Colombia pueden tener múltiples categorías (B1, C1, A2…)
/// con distintas fechas de expedición y vencimiento por categoría.
/// Formato de fechas: "DD/MM/YYYY" (formato RUNT/VRC).
class VrcLicenseCategoryModel {
  /// Código de categoría: B1, C1, A2, etc.
  final String? categoria;

  /// Fecha de expedición de esta categoría. Formato: "DD/MM/YYYY".
  final String? fechaExpedicion;

  /// Fecha de vencimiento de esta categoría. Formato: "DD/MM/YYYY".
  final String? fechaVencimiento;

  const VrcLicenseCategoryModel({
    this.categoria,
    this.fechaExpedicion,
    this.fechaVencimiento,
  });

  factory VrcLicenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      VrcLicenseCategoryModel(
        categoria: _str(json['categoria']),
        // Backend puede enviar camelCase "fechaExpedicion" o snake_case "fecha_expedicion"
        fechaExpedicion: _str(json['fechaExpedicion'] ?? json['fecha_expedicion']),
        // Backend puede enviar camelCase "fechaVencimiento" o snake_case "fecha_vencimiento"
        fechaVencimiento: _str(json['fechaVencimiento'] ?? json['fecha_vencimiento']),
      );

  Map<String, dynamic> toJson() => {
        if (categoria != null) 'categoria': categoria,
        if (fechaExpedicion != null) 'fecha_expedicion': fechaExpedicion,
        if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      };
}

/// DTO para la licencia de conducción del propietario (PERSON únicamente).
///
/// [categories] contiene las categorías habilitadas (B1, C1…) con fechas
/// por categoría. Una licencia puede tener múltiples categorías con distintas
/// fechas de vencimiento.
///
/// [expiryDate] se deriva de categories[].fecha_vencimiento eligiendo la
/// categoría con fecha más tardía, si el backend no lo envía en nivel raíz.
/// Formato: "DD/MM/YYYY" (formato RUNT/VRC).
class VrcLicenseModel {
  /// Número de licencia (≈ número de cédula en CO).
  /// Mapeado desde json['numero'] — NO es la categoría de manejo (B1, C1).
  final String? category;
  final String? status;
  final String? issueDate;
  final String? expiryDate;

  /// Categorías habilitadas con fechas individuales. Vacía si el backend
  /// no envía el array 'categories' (ej. respuestas legacy).
  final List<VrcLicenseCategoryModel> categories;

  const VrcLicenseModel({
    this.category,
    this.status,
    this.issueDate,
    this.expiryDate,
    List<VrcLicenseCategoryModel>? categories,
  }) : categories = categories ?? const [];

  factory VrcLicenseModel.fromJson(Map<String, dynamic> json) {
    // Parsear array de categorías habilitadas
    final rawCats = json['categories'];
    final List<VrcLicenseCategoryModel> categories;
    if (rawCats is List) {
      categories = rawCats
          .whereType<Map<String, dynamic>>()
          .map(VrcLicenseCategoryModel.fromJson)
          .toList();
    } else {
      categories = const [];
    }

    // expiryDate: campo top-level primero.
    // Si null, derivar de la categoría con fecha_vencimiento más tardía.
    // El backend RUNT no envía 'expiryDate' top-level; las fechas viven en categories[].
    String? expiryDate = _str(json['expiryDate']);
    if (expiryDate == null && categories.isNotEmpty) {
      DateTime? latestDate;
      String? latestDateStr;
      for (final cat in categories) {
        final dt = _parseDdMmYyyy(cat.fechaVencimiento);
        if (dt != null && (latestDate == null || dt.isAfter(latestDate))) {
          latestDate = dt;
          latestDateStr = cat.fechaVencimiento;
        }
      }
      expiryDate = latestDateStr;
    }

    return VrcLicenseModel(
      // Backend usa "numero" para el identificador de la licencia
      category: _str(json['category'] ?? json['numero_licencia'] ?? json['numero']),
      // Backend usa "estado"
      status: _str(json['status'] ?? json['estado']),
      // Backend usa "fechaExpedicion" (camelCase) o "fecha_expedicion" (snake_case)
      issueDate: _str(json['issueDate'] ?? json['fechaExpedicion'] ?? json['fecha_expedicion']),
      expiryDate: expiryDate,
      categories: categories,
    );
  }

  Map<String, dynamic> toJson() => {
        if (category != null) 'category': category,
        if (status != null) 'status': status,
        if (issueDate != null) 'issueDate': issueDate,
        if (expiryDate != null) 'expiryDate': expiryDate,
        if (categories.isNotEmpty)
          'categories': categories.map((c) => c.toJson()).toList(),
      };
}

// ── SIMIT TYPE COUNT / BY-TYPE / FINE ─────────────────────────────────────────

/// DTO para conteo y total de un tipo SIMIT (comparendos, multas, acuerdosDePago).
///
/// Backend contrato 2026-04 (commit 499416b):
///   "comparendos": { "count": 1, "total": 450000 }
class VrcSimitTypeCountModel {
  final int count;
  final num total;

  const VrcSimitTypeCountModel({required this.count, required this.total});

  factory VrcSimitTypeCountModel.fromJson(Map<String, dynamic> json) {
    int parseIntOrZero(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    num parseNumOrZero(dynamic v) {
      if (v is num) return v;
      if (v is String) return num.tryParse(v) ?? 0;
      return 0;
    }

    return VrcSimitTypeCountModel(
      count: parseIntOrZero(json['count']),
      total: parseNumOrZero(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {'count': count, 'total': total};
}

/// DTO para el desglose SIMIT por tipo (simit.summary.byType).
///
/// Backend contrato 2026-04 (commit 499416b):
/// "byType": {
///   "comparendos":    { "count": 1, "total": 450000  },
///   "multas":         { "count": 2, "total": 1337641 },
///   "acuerdosDePago": { "count": 0, "total": 0       }
/// }
/// Un tipo puede ser null si el backend no lo incluye (degradación parcial).
class VrcSimitByTypeModel {
  final VrcSimitTypeCountModel? comparendos;
  final VrcSimitTypeCountModel? multas;
  final VrcSimitTypeCountModel? acuerdosDePago;

  const VrcSimitByTypeModel({this.comparendos, this.multas, this.acuerdosDePago});

  factory VrcSimitByTypeModel.fromJson(Map<String, dynamic> json) {
    VrcSimitTypeCountModel? parse(dynamic raw) =>
        raw is Map<String, dynamic> ? VrcSimitTypeCountModel.fromJson(raw) : null;
    return VrcSimitByTypeModel(
      comparendos: parse(json['comparendos']),
      multas: parse(json['multas']),
      acuerdosDePago: parse(json['acuerdosDePago']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (comparendos != null) 'comparendos': comparendos!.toJson(),
        if (multas != null) 'multas': multas!.toJson(),
        if (acuerdosDePago != null) 'acuerdosDePago': acuerdosDePago!.toJson(),
      };
}

/// DTO para un ítem individual de la lista `fines[]` SIMIT (simit.fines[]).
///
/// Backend contrato 2026-04 (commit 499416b) — campos confirmados en response real:
///   id, fecha, ciudad, valor, valorAPagar, estado, placa, infraccion, detalle
///   classification.severity, classification.codigoInfraccion
///
/// [tipo] PENDIENTE: el campo existe en el contrato teórico pero NO llega aún
/// en el response real del batch. Puede ser null. Usar [infraccion] como proxy.
/// La UI debe manejar tipo == null con fallback (mostrar todo en comparendos).
class VrcSimitFineModel {
  /// PENDIENTE: campo teórico, puede ser null en responses reales.
  final String? tipo;
  final String? id;

  /// Fecha de la infracción. Formato: "DD/MM/YYYY".
  final String? fecha;

  /// Ciudad donde se emitió la infracción.
  final String? ciudad;

  /// Valor original de la multa.
  final num? valor;

  /// Valor a pagar actualmente (puede ser diferente a valor por intereses).
  final num? valorAPagar;

  /// Estado del trámite. Ej: "Pendiente No tiene curso".
  final String? estado;

  /// Placa del vehículo asociado.
  final String? placa;

  /// Código de infracción. Ej: "C31". Sirve como proxy de tipo cuando [tipo] es null.
  final String? infraccion;

  /// Detalle textual adicional (puede ser null).
  final String? detalle;

  /// Severidad desde classification: LOW | MEDIUM | HIGH | CRITICAL.
  final String? severity;

  const VrcSimitFineModel({
    this.tipo,
    this.id,
    this.fecha,
    this.ciudad,
    this.valor,
    this.valorAPagar,
    this.estado,
    this.placa,
    this.infraccion,
    this.detalle,
    this.severity,
  });

  factory VrcSimitFineModel.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) {
      if (v is num) return v;
      if (v is String) return num.tryParse(v);
      return null;
    }

    // classification es un objeto anidado — extraer campos relevantes
    final rawClassification = json['classification'];
    String? severity;
    if (rawClassification is Map<String, dynamic>) {
      severity = _str(rawClassification['severity']);
    }

    return VrcSimitFineModel(
      tipo: _str(json['tipo']),
      id: _str(json['id']),
      fecha: _str(json['fecha']),
      ciudad: _str(json['ciudad']),
      valor: parseNum(json['valor']),
      valorAPagar: parseNum(json['valorAPagar']),
      estado: _str(json['estado']),
      placa: _str(json['placa']),
      infraccion: _str(json['infraccion']),
      detalle: _str(json['detalle']),
      severity: severity,
    );
  }

  Map<String, dynamic> toJson() => {
        if (tipo != null) 'tipo': tipo,
        if (id != null) 'id': id,
        if (fecha != null) 'fecha': fecha,
        if (ciudad != null) 'ciudad': ciudad,
        if (valor != null) 'valor': valor,
        if (valorAPagar != null) 'valorAPagar': valorAPagar,
        if (estado != null) 'estado': estado,
        if (placa != null) 'placa': placa,
        if (infraccion != null) 'infraccion': infraccion,
        if (detalle != null) 'detalle': detalle,
        if (severity != null) 'severity': severity,
      };
}

/// DTO para el bloque SIMIT del propietario.
///
/// [summary] null ≠ "sin multas". Null indica que SIMIT no está disponible.
/// La UI debe distinguir explícitamente: "sin datos" vs "sin multas".
///
/// [fines] lista de ítems individuales (simit.fines[]). Defensiva: nunca null.
/// Backend contrato 2026-04 (commit 499416b): fines[] vive en el nivel simit,
/// no dentro de summary.
class VrcOwnerSimitModel {
  final VrcSimitSummaryModel? summary;

  /// Lista de infracciones/multas individuales (simit.fines[]).
  /// Defensiva: nunca null, vacía si el backend no la incluye.
  final List<VrcSimitFineModel> fines;

  const VrcOwnerSimitModel({
    this.summary,
    List<VrcSimitFineModel>? fines,
  }) : fines = fines ?? const [];

  factory VrcOwnerSimitModel.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'];
    final rawFines = json['fines'];

    List<VrcSimitFineModel> fines = const [];
    if (rawFines is List) {
      fines = rawFines
          .whereType<Map<String, dynamic>>()
          .map(VrcSimitFineModel.fromJson)
          .toList();
    }

    return VrcOwnerSimitModel(
      summary: rawSummary is Map<String, dynamic>
          ? VrcSimitSummaryModel.fromJson(rawSummary)
          : null,
      fines: fines,
    );
  }

  Map<String, dynamic> toJson() => {
        if (summary != null) 'summary': summary!.toJson(),
        if (fines.isNotEmpty) 'fines': fines.map((f) => f.toJson()).toList(),
      };
}

/// DTO para el resumen de multas SIMIT del propietario.
///
/// [total] puede venir como int, double o String numérico — se normaliza a num.
/// [finesCount] conteo total de infracciones (todos los tipos) desde 'finesCount'.
/// [comparendos] desde 'comparendosCount' (legacy) — fallback a finesCount.
///   Con el contrato 2026-04 usar [byType.comparendos.count] para el desglose real.
/// [multas] desde 'multasCount' (legacy). Con contrato 2026-04 usar [byType.multas.count].
/// [paymentAgreementsCount] desde 'paymentAgreementsCount' — acuerdos de pago.
/// [byType] desglose por tipo (comparendos/multas/acuerdosDePago) — contrato 2026-04.
/// [riskLevel] nivel de riesgo: LOW | MEDIUM | HIGH.
class VrcSimitSummaryModel {
  final bool? hasFines;
  final num? total;

  /// Conteo total de infracciones (todos los tipos). Desde 'finesCount'.
  /// Usar este campo para mostrar el total en la UI (no [comparendos]).
  final int? finesCount;

  final int? comparendos;
  final int? multas;
  final int? paymentAgreementsCount;
  final String? formattedTotal;
  final String? document;
  final String? riskLevel;

  /// Desglose por tipo (contrato 2026-04, commit 499416b).
  /// Puede ser null en backends legacy que no envíen byType.
  final VrcSimitByTypeModel? byType;

  const VrcSimitSummaryModel({
    this.hasFines,
    this.total,
    this.finesCount,
    this.comparendos,
    this.multas,
    this.paymentAgreementsCount,
    this.formattedTotal,
    this.document,
    this.riskLevel,
    this.byType,
  });

  factory VrcSimitSummaryModel.fromJson(Map<String, dynamic> json) {
    int? parseIntField(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    // Backend usa "totalAmount", no "total"
    final rawTotal = json['totalAmount'] ?? json['total'];
    num? total;
    if (rawTotal is num) {
      total = rawTotal;
    } else if (rawTotal is String) {
      total = num.tryParse(rawTotal);
    }

    // finesCount: total agregado de todos los tipos (contrato 2026-04)
    final finesCount = parseIntField(json['finesCount']);

    // hasFines: derivar de finesCount si no viene explícito
    bool? hasFines = json['hasFines'] as bool?;
    if (hasFines == null && finesCount != null) {
      hasFines = finesCount > 0;
    }

    // byType: desglose por tipo (contrato 2026-04)
    final rawByType = json['byType'];

    return VrcSimitSummaryModel(
      hasFines: hasFines,
      total: total,
      finesCount: finesCount,
      // comparendos: legacy → comparendosCount fallback finesCount (compatibilidad)
      comparendos: parseIntField(
          json['comparendosCount'] ?? json['comparendos'] ?? json['finesCount']),
      // multas: legacy → multasCount fallback multas
      multas: parseIntField(json['multasCount'] ?? json['multas']),
      paymentAgreementsCount: parseIntField(json['paymentAgreementsCount']),
      formattedTotal: _str(json['formattedTotal']),
      document: _str(json['document']),
      riskLevel: _str(json['riskLevel']),
      byType: rawByType is Map<String, dynamic>
          ? VrcSimitByTypeModel.fromJson(rawByType)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (hasFines != null) 'hasFines': hasFines,
        if (total != null) 'totalAmount': total,
        if (finesCount != null) 'finesCount': finesCount,
        if (comparendos != null) 'comparendos': comparendos,
        if (multas != null) 'multas': multas,
        if (paymentAgreementsCount != null)
          'paymentAgreementsCount': paymentAgreementsCount,
        if (formattedTotal != null) 'formattedTotal': formattedTotal,
        if (document != null) 'document': document,
        if (riskLevel != null) 'riskLevel': riskLevel,
        if (byType != null) 'byType': byType!.toJson(),
      };
}

// ── BUSINESS DECISION ─────────────────────────────────────────────────────────

/// DTO para la decisión de negocio de la API VRC.
///
/// Señal primaria de la UI — NO derivar la decisión de meta.sources.
///
/// [action]: APPROVE | REVIEW | REJECT | UNKNOWN
/// [riskLevel]: LOW | MEDIUM | HIGH | UNKNOWN
class VrcBusinessDecisionModel {
  final String? action;
  final String? riskLevel;

  const VrcBusinessDecisionModel({this.action, this.riskLevel});

  factory VrcBusinessDecisionModel.fromJson(Map<String, dynamic> json) =>
      VrcBusinessDecisionModel(
        action: _str(json['action']),
        riskLevel: _str(json['riskLevel']),
      );

  Map<String, dynamic> toJson() => {
        if (action != null) 'action': action,
        if (riskLevel != null) 'riskLevel': riskLevel,
      };
}

// ── META (solo diagnóstico) ───────────────────────────────────────────────────

/// DTO para el bloque `meta` de la respuesta VRC.
///
/// USO EXCLUSIVO: diagnóstico técnico (sección colapsable en UI).
/// NUNCA usar meta.sources como señal primaria de degradación.
class VrcMetaModel {
  final VrcMetaSourcesModel? sources;
  final String? requestId;
  final int? durationMs;

  const VrcMetaModel({this.sources, this.requestId, this.durationMs});

  factory VrcMetaModel.fromJson(Map<String, dynamic> json) {
    final rawSources = json['sources'];
    return VrcMetaModel(
      sources: rawSources is Map<String, dynamic>
          ? VrcMetaSourcesModel.fromJson(rawSources)
          : null,
      requestId: _str(json['requestId']),
      durationMs: json['durationMs'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (sources != null) 'sources': sources!.toJson(),
        if (requestId != null) 'requestId': requestId,
        if (durationMs != null) 'durationMs': durationMs,
      };
}

/// DTO para el estado de cada fuente en el bloque meta.
///
/// Valores típicos por fuente: "SUCCESS" | "FAILED" | "TIMEOUT" | "CACHED"
class VrcMetaSourcesModel {
  final String? runtVehicle;
  final String? runtPerson;
  final String? simit;

  const VrcMetaSourcesModel({this.runtVehicle, this.runtPerson, this.simit});

  factory VrcMetaSourcesModel.fromJson(Map<String, dynamic> json) =>
      VrcMetaSourcesModel(
        runtVehicle: _str(json['runtVehicle']),
        runtPerson: _str(json['runtPerson']),
        simit: _str(json['simit']),
      );

  Map<String, dynamic> toJson() => {
        if (runtVehicle != null) 'runtVehicle': runtVehicle,
        if (runtPerson != null) 'runtPerson': runtPerson,
        if (simit != null) 'simit': simit,
      };
}
