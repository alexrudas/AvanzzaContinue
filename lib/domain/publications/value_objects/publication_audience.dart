// lib/domain/publications/value_objects/publication_audience.dart
// Dominio puro: sin dependencias de UI ni DS. Solo dart:core y dart:math.
//
// PROPÓSITO
// - Definir alcance geográfico y value objects para discovery.
// - Scoring determinístico: geo, plan, frescura, boost.
// - Serialización estable con wire names y parsers robustos.
//
// NOTAS DE DISEÑO
// - Haversine con dart:math (no series de Taylor).
// - Normalización del plan: 1.0→0.25, 2.0→1.0 (corrige comentario/implementación).
// - Filtros mínimos en shouldShowToViewer: país y umbral de score; distancia opcional.
// - Todas las fechas en UTC. Se usan asserts.

import 'dart:math' as math;

/// Alcance geográfico de una publicación.
enum AudienceScope {
  city, // Solo ciudad del publicador
  region, // Región completa
  multiRegion, // Múltiples regiones
  national, // Todo el país
}

/// Extensión con metadata de cada alcance.
extension AudienceScopeX on AudienceScope {
  /// Clave i18n estable para el nombre del alcance.
  String get i18nKey {
    switch (this) {
      case AudienceScope.city:
        return 'publication.audience.city';
      case AudienceScope.region:
        return 'publication.audience.region';
      case AudienceScope.multiRegion:
        return 'publication.audience.multi_region';
      case AudienceScope.national:
        return 'publication.audience.national';
    }
  }

  /// Wire names explícitos y versionables.
  String get wireName {
    switch (this) {
      case AudienceScope.city:
        return 'city';
      case AudienceScope.region:
        return 'region';
      case AudienceScope.multiRegion:
        return 'multi_region';
      case AudienceScope.national:
        return 'national';
    }
  }

  /// Parser robusto desde string externo.
  static AudienceScope fromWire(String raw) {
    switch (raw) {
      case 'city':
        return AudienceScope.city;
      case 'region':
        return AudienceScope.region;
      case 'multi_region':
        return AudienceScope.multiRegion;
      case 'national':
        return AudienceScope.national;
      default:
        throw ArgumentError('AudienceScope desconocido: $raw');
    }
  }

  /// Peso base para el score geográfico.
  /// Mayor alcance → menor peso local.
  double get baseWeight {
    switch (this) {
      case AudienceScope.city:
        return 1.0;
      case AudienceScope.region:
        return 0.8;
      case AudienceScope.multiRegion:
        return 0.6;
      case AudienceScope.national:
        return 0.4;
    }
  }

  /// Distancia máxima efectiva en km para matching geográfico.
  /// null = sin límite (nacional).
  double? get maxDistanceKm {
    switch (this) {
      case AudienceScope.city:
        return 50.0;
      case AudienceScope.region:
        return 300.0;
      case AudienceScope.multiRegion:
        return 800.0;
      case AudienceScope.national:
        return null;
    }
  }
}

/// Configuración de audiencia de una publicación (value object inmutable).
class PublicationAudience {
  final AudienceScope scope;
  final String countryId;
  final String? regionId;
  final String? cityId;
  final List<String> additionalRegionIds;

  const PublicationAudience({
    required this.scope,
    required this.countryId,
    this.regionId,
    this.cityId,
    this.additionalRegionIds = const [],
  });

  /// Validación de invariantes de construcción.
  PublicationAudience validate() {
    if (scope == AudienceScope.city && cityId == null) {
      throw ArgumentError('cityId requerido para scope city');
    }
    if (scope == AudienceScope.region && regionId == null) {
      throw ArgumentError('regionId requerido para scope region');
    }
    if (scope == AudienceScope.multiRegion && additionalRegionIds.isEmpty) {
      throw ArgumentError(
          'additionalRegionIds requerido para scope multiRegion');
    }
    return this;
  }

  /// Serialización a Map estable.
  Map<String, Object?> toJson() {
    return {
      'scope': scope.wireName,
      'countryId': countryId,
      'regionId': regionId,
      'cityId': cityId,
      'additionalRegionIds': additionalRegionIds,
    };
  }

  /// Parser desde Map con validación.
  static PublicationAudience fromJson(Map<String, Object?> json) {
    return PublicationAudience(
      scope: AudienceScopeX.fromWire(json['scope'] as String),
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      additionalRegionIds:
          (json['additionalRegionIds'] as List<dynamic>?)?.cast<String>() ??
              const [],
    ).validate();
  }

  /// Copy-with inmutable.
  PublicationAudience copyWith({
    AudienceScope? scope,
    String? countryId,
    String? regionId,
    String? cityId,
    List<String>? additionalRegionIds,
  }) {
    return PublicationAudience(
      scope: scope ?? this.scope,
      countryId: countryId ?? this.countryId,
      regionId: regionId ?? this.regionId,
      cityId: cityId ?? this.cityId,
      additionalRegionIds: additionalRegionIds ?? this.additionalRegionIds,
    );
  }
}

/// Contexto del viewer que consume publicaciones (value object inmutable).
class ViewerContext {
  final String userId;
  final String countryId;
  final String? regionId;
  final String? cityId;
  final double? latitude;
  final double? longitude;

  const ViewerContext({
    required this.userId,
    required this.countryId,
    this.regionId,
    this.cityId,
    this.latitude,
    this.longitude,
  });

  bool get hasGeoCoords => latitude != null && longitude != null;

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'countryId': countryId,
      'regionId': regionId,
      'cityId': cityId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static ViewerContext fromJson(Map<String, Object?> json) {
    return ViewerContext(
      userId: json['userId'] as String,
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}

/// Resultado de scoring para ranking de publicaciones.
class AudienceScore {
  final double geoScore; // 0.0 - 1.0
  final double planScore; // 0.0 - 1.0
  final double freshnessScore; // 0.0 - 1.0
  final double boostScore; // 0.0 - 1.0
  final double totalScore; // 0.0 - 1.0

  const AudienceScore({
    required this.geoScore,
    required this.planScore,
    required this.freshnessScore,
    required this.boostScore,
    required this.totalScore,
  });

  AudienceScore copyWith({
    double? geoScore,
    double? planScore,
    double? freshnessScore,
    double? boostScore,
    double? totalScore,
  }) {
    return AudienceScore(
      geoScore: geoScore ?? this.geoScore,
      planScore: planScore ?? this.planScore,
      freshnessScore: freshnessScore ?? this.freshnessScore,
      boostScore: boostScore ?? this.boostScore,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  Map<String, Object?> toJson() => {
        'geoScore': geoScore,
        'planScore': planScore,
        'freshnessScore': freshnessScore,
        'boostScore': boostScore,
        'totalScore': totalScore,
      };
}

/// Servicio de dominio para scoring y matching de audiencias.
class PublicationAudienceService {
  /// Pesos para el cálculo del total.
  static const double geoWeight = 0.40;
  static const double planWeight = 0.30;
  static const double freshnessWeight = 0.20;
  static const double boostWeight = 0.10;

  /// Haversine: distancia en km entre dos coordenadas.
  static double? computeDistanceKm({
    required double? lat1,
    required double? lon1,
    required double? lat2,
    required double? lon2,
  }) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return null;
    }

    const earthRadiusKm = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRad(double deg) => deg * (math.pi / 180.0);

  /// Score geográfico: país, región, ciudad, distancia y scope.
  static double computeGeoScore({
    required PublicationAudience audience,
    required ViewerContext viewer,
    double? distanceKm,
  }) {
    if (audience.countryId != viewer.countryId) return 0.0;

    double score = 0.2; // base por mismo país

    if (audience.regionId != null && audience.regionId == viewer.regionId) {
      score += 0.3;
    }

    if (audience.cityId != null && audience.cityId == viewer.cityId) {
      score += 0.5;
      // Coincidencia exacta de ciudad: tope 1.0 antes de ponderar por scope
      return (score).clamp(0.0, 1.0) * audience.scope.baseWeight;
    }

    // Decaimiento por distancia si se suministra y el scope tiene límite
    if (distanceKm != null && distanceKm > 0) {
      final maxDist = audience.scope.maxDistanceKm ?? 1000.0;
      final decay = (1.0 - (distanceKm / maxDist)).clamp(0.0, 1.0);
      score += 0.3 * decay;
    }

    return (score.clamp(0.0, 1.0)) * audience.scope.baseWeight;
  }

  /// Score de plan: discoveryWeight 1.0..2.0 → 0.25..1.0
  static double computePlanScore({required double planDiscoveryWeight}) {
    final normalized =
        ((planDiscoveryWeight - 1.0) / (2.0 - 1.0)).clamp(0.0, 1.0);
    return 0.25 + 0.75 * normalized;
  }

  /// Score de frescura en función del tiempo desde creación.
  /// <24h: 1.0; 24-72h: 1.0→0.7; 72h-7d: 0.7→0.4; >7d: decaimiento a 0.1.
  static double computeFreshnessScore({
    required DateTime createdAtUtc,
    required DateTime nowUtc,
  }) {
    assert(createdAtUtc.isUtc, 'createdAtUtc debe ser UTC');
    assert(nowUtc.isUtc, 'nowUtc debe ser UTC');

    final ageHours = nowUtc.difference(createdAtUtc).inHours.toDouble();

    if (ageHours < 24) return 1.0;
    if (ageHours < 72) {
      // 48h: 1.0 → 0.7
      final t = (ageHours - 24.0) / 48.0;
      return 1.0 - 0.3 * t;
    }
    if (ageHours < 168) {
      // 96h: 0.7 → 0.4
      final t = (ageHours - 72.0) / 96.0;
      return 0.7 - 0.3 * t;
    }
    // > 7d: decaimiento suavizado a 0.1
    final ageDays = ageHours / 24.0;
    final decayed = 0.4 * (1.0 / (1.0 + 0.2 * (ageDays - 7.0)));
    return decayed.clamp(0.1, 0.4);
  }

  /// Score de boost: activo dentro de la ventana → 1.0; si no → 0.0
  static double computeBoostScore({
    required bool hasActiveBoost,
    DateTime? boostClaimedAtUtc,
    required DateTime nowUtc,
    Duration boostWindow = const Duration(hours: 24),
  }) {
    if (!hasActiveBoost || boostClaimedAtUtc == null) return 0.0;
    assert(boostClaimedAtUtc.isUtc, 'boostClaimedAtUtc debe ser UTC');
    assert(nowUtc.isUtc, 'nowUtc debe ser UTC');

    final expireAt = boostClaimedAtUtc.add(boostWindow);
    return nowUtc.isAfter(expireAt) ? 0.0 : 1.0;
  }

  /// Score total ponderado y normalizado a 0.0..1.0.
  static AudienceScore computeTotalScore({
    required PublicationAudience audience,
    required ViewerContext viewer,
    required double planDiscoveryWeight,
    required DateTime createdAtUtc,
    required DateTime nowUtc,
    required bool hasActiveBoost,
    DateTime? boostClaimedAtUtc,
    double? distanceKm,
  }) {
    final geoScore = computeGeoScore(
      audience: audience,
      viewer: viewer,
      distanceKm: distanceKm,
    );

    final planScore =
        computePlanScore(planDiscoveryWeight: planDiscoveryWeight);

    final freshnessScore = computeFreshnessScore(
      createdAtUtc: createdAtUtc,
      nowUtc: nowUtc,
    );

    final boostScore = computeBoostScore(
      hasActiveBoost: hasActiveBoost,
      boostClaimedAtUtc: boostClaimedAtUtc,
      nowUtc: nowUtc,
    );

    final total = (geoScore * geoWeight) +
        (planScore * planWeight) +
        (freshnessScore * freshnessWeight) +
        (boostScore * boostWeight);

    return AudienceScore(
      geoScore: geoScore,
      planScore: planScore,
      freshnessScore: freshnessScore,
      boostScore: boostScore,
      totalScore: total.clamp(0.0, 1.0),
    );
  }

  /// Filtro mínimo para decidir visibilidad.
  /// País debe coincidir y el score total superar el umbral.
  /// Si quieres aplicar hard-cap por distancia en city, pásala por `distanceKm`
  /// y compara con `audience.scope.maxDistanceKm`.
  static bool shouldShowToViewer({
    required PublicationAudience audience,
    required ViewerContext viewer,
    required AudienceScore score,
    double? distanceKm,
    double minScoreThreshold = 0.2,
  }) {
    if (audience.countryId != viewer.countryId) return false;
    if (score.totalScore < minScoreThreshold) return false;

    final cap = audience.scope.maxDistanceKm;
    if (cap != null && distanceKm != null && distanceKm > cap) return false;

    return true;
  }
}
