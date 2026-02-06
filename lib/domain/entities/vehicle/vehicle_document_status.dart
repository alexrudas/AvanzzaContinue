// ============================================================================
// lib/domain/entities/vehicle/vehicle_document_status.dart
// Domain Layer - Dart puro (sin dependencias externas)
// ============================================================================

/// Estado de validez de un documento de vehículo.
enum DocumentValidityStatus {
  /// Documento vigente (más de 30 días para vencer)
  vigente,

  /// Documento próximo a vencer (30 días o menos)
  porVencer,

  /// Documento vencido
  vencido,

  /// Estado desconocido (sin fecha de vencimiento)
  desconocido,
}

// ============================================================================
// MODELO INMUTABLE: VehicleDocumentStatus
// ============================================================================

/// Modelo inmutable que representa el estado normalizado de un documento
/// de vehículo (SOAT, RTM, RC_CONTRACTUAL, RC_EXTRACONTRACTUAL).
///
/// Desacopla la UI y lógica de negocio del formato crudo del RUNT.
class VehicleDocumentStatus {
  /// Tipo de documento.
  /// Valores válidos: "SOAT", "RTM", "RC_CONTRACTUAL", "RC_EXTRACONTRACTUAL"
  final String documentType;

  /// Estado de validez calculado.
  final DocumentValidityStatus status;

  /// Fecha de inicio de vigencia.
  final DateTime? startDate;

  /// Fecha de fin de vigencia.
  final DateTime? endDate;

  /// Días restantes hasta el vencimiento.
  /// Puede ser negativo si el documento ya venció.
  final int? daysToExpire;

  /// Fuente de los datos.
  final String source;

  /// Número de referencia (póliza, certificado, etc.).
  final String? referenceNumber;

  /// Proveedor/Aseguradora/CDA.
  final String? provider;

  /// Constructor privado - usar factories.
  const VehicleDocumentStatus._({
    required this.documentType,
    required this.status,
    this.startDate,
    this.endDate,
    this.daysToExpire,
    this.source = 'RUNT',
    this.referenceNumber,
    this.provider,
  });

  /// True SOLO si el documento está vigente.
  bool get isValid => status == DocumentValidityStatus.vigente;

  /// True SOLO si el documento está vencido.
  bool get isExpired => status == DocumentValidityStatus.vencido;

  /// True si el documento requiere atención (vencido o por vencer).
  bool get requiresAction =>
      status == DocumentValidityStatus.vencido ||
      status == DocumentValidityStatus.porVencer;

  /// Factory constructor que calcula el estado basado en fechas.
  ///
  /// [documentType] - Tipo de documento
  /// [startDate] - Fecha de inicio de vigencia (opcional)
  /// [endDate] - Fecha de fin de vigencia
  /// [referenceNumber] - Número de póliza/certificado
  /// [provider] - Aseguradora/CDA
  /// [now] - Fecha actual (inyección de dependencia temporal)
  /// [source] - Fuente de datos (default: "RUNT")
  factory VehicleDocumentStatus.fromDates({
    required String documentType,
    DateTime? startDate,
    DateTime? endDate,
    String? referenceNumber,
    String? provider,
    required DateTime now,
    String source = 'RUNT',
  }) {
    // Normalizar fecha actual a medianoche
    final today = DateTime(now.year, now.month, now.day);

    // Si no hay fecha de vencimiento → estado desconocido
    if (endDate == null) {
      return VehicleDocumentStatus._(
        documentType: documentType,
        status: DocumentValidityStatus.desconocido,
        startDate: startDate,
        endDate: null,
        daysToExpire: null,
        source: source,
        referenceNumber: referenceNumber,
        provider: provider,
      );
    }

    // Normalizar endDate a medianoche para comparar SOLO por día
    final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    // Calcular días hasta vencimiento
    final daysToExpire = normalizedEndDate.difference(today).inDays;

    // Determinar estado según reglas
    final DocumentValidityStatus status;
    if (daysToExpire < 0) {
      // endDate < now → vencido
      status = DocumentValidityStatus.vencido;
    } else if (daysToExpire <= 30) {
      // endDate >= now y daysToExpire <= 30 → porVencer
      status = DocumentValidityStatus.porVencer;
    } else {
      // endDate >= now y daysToExpire > 30 → vigente
      status = DocumentValidityStatus.vigente;
    }

    return VehicleDocumentStatus._(
      documentType: documentType,
      status: status,
      startDate: startDate,
      endDate: endDate,
      daysToExpire: daysToExpire,
      source: source,
      referenceNumber: referenceNumber,
      provider: provider,
    );
  }

  @override
  String toString() {
    return 'VehicleDocumentStatus('
        'type: $documentType, '
        'status: ${status.name}, '
        'daysToExpire: $daysToExpire, '
        'provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleDocumentStatus &&
        other.documentType == documentType &&
        other.status == status &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.daysToExpire == daysToExpire &&
        other.source == source &&
        other.referenceNumber == referenceNumber &&
        other.provider == provider;
  }

  @override
  int get hashCode {
    return Object.hash(
      documentType,
      status,
      startDate,
      endDate,
      daysToExpire,
      source,
      referenceNumber,
      provider,
    );
  }
}

// ============================================================================
// RESOLVER HELPER: VehicleDocumentStatusResolver
// ============================================================================

/// Helper para resolver el último documento relevante de listas RUNT.
///
/// Extrae el documento más reciente (por fecha de vencimiento) de las
/// listas retornadas por la API RUNT y lo convierte a [VehicleDocumentStatus].
class VehicleDocumentStatusResolver {
  // ---------------------------------------------------------------------------
  // MÉTODOS PÚBLICOS
  // ---------------------------------------------------------------------------

  /// Resuelve el estado del SOAT más reciente.
  ///
  /// [soatList] - Lista de registros SOAT del RUNT.
  /// Returns null si la lista es null o vacía.
  static VehicleDocumentStatus? resolveSoat(List<dynamic>? soatList) {
    if (soatList == null || soatList.isEmpty) return null;

    final now = DateTime.now();
    final records = _toMapList(soatList);
    if (records.isEmpty) return null;

    // Ordenar por fecha de vencimiento DESCENDENTE
    records.sort((a, b) => _compareByEndDateDesc(
      a,
      b,
      'fecha_fin_de_vigencia',
    ));

    final latest = records.first;

    return VehicleDocumentStatus.fromDates(
      documentType: 'SOAT',
      startDate: _parseRuntDate(_getString(latest, 'fecha_inicio_de_vigencia')),
      endDate: _parseRuntDate(_getString(latest, 'fecha_fin_de_vigencia')),
      referenceNumber: _getString(latest, 'n_mero_de_p_liza'),
      provider: _getString(latest, 'entidad_expide_soat'),
      now: now,
      source: 'RUNT',
    );
  }

  /// Resuelve el estado de la RTM más reciente.
  ///
  /// [rtmList] - Lista de registros RTM del RUNT.
  /// Returns null si la lista es null o vacía.
  static VehicleDocumentStatus? resolveRtm(List<dynamic>? rtmList) {
    if (rtmList == null || rtmList.isEmpty) return null;

    final now = DateTime.now();
    final records = _toMapList(rtmList);
    if (records.isEmpty) return null;

    // Ordenar por fecha de vigencia DESCENDENTE
    records.sort((a, b) => _compareByEndDateDesc(a, b, 'fecha_vigencia'));

    final latest = records.first;

    // Para RTM, el inicio puede estar en 'fecha_expedici_n' o 'fecha_expedicion'
    final startDateStr = _getString(latest, 'fecha_expedici_n') ??
        _getString(latest, 'fecha_expedicion');

    return VehicleDocumentStatus.fromDates(
      documentType: 'RTM',
      startDate: _parseRuntDate(startDateStr),
      endDate: _parseRuntDate(_getString(latest, 'fecha_vigencia')),
      referenceNumber: _getString(latest, 'nro_certificado'),
      provider: _getString(latest, 'cda_expide_rtm'),
      now: now,
      source: 'RUNT',
    );
  }

  /// Resuelve los estados de los Seguros RC (Contractual y Extracontractual).
  ///
  /// IMPORTANTE: La sección RC del RUNT contiene DOS documentos DIFERENTES
  /// que deben resolverse de forma INDEPENDIENTE:
  /// - RC_CONTRACTUAL
  /// - RC_EXTRACONTRACTUAL
  ///
  /// [rcList] - Lista de registros de seguro RC del RUNT.
  /// Returns lista vacía si no hay datos válidos.
  static List<VehicleDocumentStatus> resolveRcInsurances(List<dynamic>? rcList) {
    if (rcList == null || rcList.isEmpty) return const [];

    final now = DateTime.now();
    final records = _toMapList(rcList);
    if (records.isEmpty) return const [];

    final result = <VehicleDocumentStatus>[];

    // Resolver RC_CONTRACTUAL
    final contractual = _resolveRcByType(
      records,
      'RC_CONTRACTUAL',
      _isContractual,
      now,
    );
    if (contractual != null) {
      result.add(contractual);
    }

    // Resolver RC_EXTRACONTRACTUAL
    final extraContractual = _resolveRcByType(
      records,
      'RC_EXTRACONTRACTUAL',
      _isExtraContractual,
      now,
    );
    if (extraContractual != null) {
      result.add(extraContractual);
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // MÉTODOS PRIVADOS - RC FILTERING
  // ---------------------------------------------------------------------------

  /// Resuelve un tipo específico de RC.
  static VehicleDocumentStatus? _resolveRcByType(
    List<Map<String, dynamic>> records,
    String documentType,
    bool Function(String?) typeFilter,
    DateTime now,
  ) {
    // Filtrar por tipo de póliza
    final filtered = records.where((record) {
      final tipoPoliza = _getString(record, 'tipo_de_p_liza') ??
          _getString(record, 'tipo_de_poliza');
      return typeFilter(tipoPoliza);
    }).toList();

    if (filtered.isEmpty) return null;

    // Ordenar por fecha de vencimiento DESCENDENTE
    filtered.sort((a, b) => _compareByEndDateDesc(
      a,
      b,
      'fecha_fin_de_vigencia',
    ));

    // Tomar solo el más reciente
    final latest = filtered.first;

    return VehicleDocumentStatus.fromDates(
      documentType: documentType,
      startDate: _parseRuntDate(_getString(latest, 'fecha_inicio_de_vigencia')),
      endDate: _parseRuntDate(_getString(latest, 'fecha_fin_de_vigencia')),
      referenceNumber: _getString(latest, 'n_mero_de_p_liza'),
      provider: _getString(latest, 'entidad_que_expide'),
      now: now,
      source: 'RUNT',
    );
  }

  /// Verifica si el tipo de póliza es CONTRACTUAL (pero NO EXTRACONTRACTUAL).
  static bool _isContractual(String? tipoPoliza) {
    if (tipoPoliza == null || tipoPoliza.isEmpty) return false;
    final upper = tipoPoliza.toUpperCase();
    // Debe contener "CONTRACTUAL" pero NO "EXTRACONTRACTUAL"
    return upper.contains('CONTRACTUAL') && !upper.contains('EXTRACONTRACTUAL');
  }

  /// Verifica si el tipo de póliza es EXTRACONTRACTUAL.
  static bool _isExtraContractual(String? tipoPoliza) {
    if (tipoPoliza == null || tipoPoliza.isEmpty) return false;
    final upper = tipoPoliza.toUpperCase();
    return upper.contains('EXTRACONTRACTUAL');
  }

  // ---------------------------------------------------------------------------
  // MÉTODOS PRIVADOS - HELPERS
  // ---------------------------------------------------------------------------

  /// Convierte lista dinámica a lista de Maps.
  static List<Map<String, dynamic>> _toMapList(List<dynamic> list) {
    return list
        .map((e) => e is Map<String, dynamic> ? e : null)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Obtiene un string de un Map de forma segura.
  /// Returns null si la llave no existe o el valor no es String.
  static String? _getString(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null) return null;
    return value.toString();
  }

  /// Compara dos registros por fecha de vencimiento en orden DESCENDENTE.
  static int _compareByEndDateDesc(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
    String dateKey,
  ) {
    final dateA = _parseRuntDate(_getString(a, dateKey));
    final dateB = _parseRuntDate(_getString(b, dateKey));
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1; // null va al final
    if (dateB == null) return -1;
    return dateB.compareTo(dateA); // Descendente
  }

  /// Parsea una fecha en formato RUNT (DD/MM/YYYY) a DateTime.
  ///
  /// Returns null si el string es null, vacío o tiene formato inválido.
  /// NO lanza excepciones.
  static DateTime? _parseRuntDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;

    try {
      // Formato esperado: DD/MM/YYYY
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;

      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) return null;
      if (day < 1 || day > 31 || month < 1 || month > 12) return null;
      if (year < 1900 || year > 2100) return null;

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}
