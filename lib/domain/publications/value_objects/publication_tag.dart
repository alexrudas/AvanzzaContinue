// lib/domain/publications/value_objects/publication_tag.dart
// Dominio puro: sin dependencias de UI ni DS.
//
// PROPÓSITO
// - Definir tags con normalización para búsqueda y discovery.
// - Matching exacto y fuzzy con scoring de relevancia.
// - Serialización estable y parsers robustos.
//
// NOTAS
// - Normalización: lowercase, sin acentos comunes, trim y colapsar espacios.
// - Límite de 50 caracteres por tag y 10 tags por publicación.
// - Fuzzy: contención con longitud mínima para reducir falsos positivos.

/// Tag de publicación con normalización para búsqueda.
class PublicationTag {
  final String raw; // Texto original ingresado por el usuario
  final String normalized; // Versión normalizada para matching

  const PublicationTag({
    required this.raw,
    required this.normalized,
  });

  /// Crea un tag normalizando la entrada.
  factory PublicationTag.create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Tag no puede estar vacío');
    }
    if (trimmed.length > 50) {
      throw ArgumentError('Tag no puede exceder 50 caracteres');
    }
    final normalized = _normalize(trimmed);
    return PublicationTag(raw: trimmed, normalized: normalized);
  }

  /// Normalización básica: lowercase, quitar acentos comunes, colapsar espacios.
  static String _normalize(String text) {
    String result = text.toLowerCase();

    // Mapeo simple de acentos comunes a ASCII básico
    const accents = {
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'â': 'a',
      'é': 'e',
      'è': 'e',
      'ë': 'e',
      'ê': 'e',
      'í': 'i',
      'ì': 'i',
      'ï': 'i',
      'î': 'i',
      'ó': 'o',
      'ò': 'o',
      'ö': 'o',
      'ô': 'o',
      'ú': 'u',
      'ù': 'u',
      'ü': 'u',
      'û': 'u',
      'ñ': 'n',
    };
    for (final e in accents.entries) {
      result = result.replaceAll(e.key, e.value);
    }

    // Colapsar espacios múltiples
    result = result.replaceAll(RegExp(r'\s+'), ' ');

    return result.trim();
  }

  /// Serializa a Map simple.
  Map<String, Object?> toJson() => {
        'raw': raw,
        'normalized': normalized,
      };

  /// Parser desde Map. No re-normaliza si ya viene `normalized`.
  static PublicationTag fromJson(Map<String, Object?> json) {
    final raw = (json['raw'] as String).trim();
    final normalized = (json['normalized'] as String).trim();
    return PublicationTag(raw: raw, normalized: normalized);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PublicationTag && other.normalized == normalized);

  @override
  int get hashCode => normalized.hashCode;

  @override
  String toString() => 'PublicationTag(raw: $raw, normalized: $normalized)';
}

/// Conjunto inmutable de tags con límites y utilidades.
class PublicationTagSet {
  final List<PublicationTag> tags;

  const PublicationTagSet({required this.tags});

  /// Máximo de tags permitidos por publicación.
  static const int maxTagsPerPublication = 10;

  /// Crea el set validando límites y deduplicando por `normalized`.
  factory PublicationTagSet.create(List<String> rawTags) {
    if (rawTags.length > maxTagsPerPublication) {
      throw ArgumentError('Máximo $maxTagsPerPublication tags por publicación');
    }

    final list = <PublicationTag>[];
    final seen = <String>{};

    for (final raw in rawTags) {
      final tag = PublicationTag.create(raw);
      if (seen.add(tag.normalized)) {
        list.add(tag);
      }
    }

    return PublicationTagSet(tags: list);
  }

  /// Agrega un tag si no existe. Idempotente.
  PublicationTagSet addTag(String rawTag) {
    final newTag = PublicationTag.create(rawTag);
    if (tags.any((t) => t.normalized == newTag.normalized)) return this;
    if (tags.length >= maxTagsPerPublication) {
      throw ArgumentError('Límite de tags alcanzado');
    }
    return PublicationTagSet(tags: [...tags, newTag]);
  }

  /// Remueve un tag usando comparación normalizada.
  PublicationTagSet removeTag(String rawTag) {
    final normalized = PublicationTag._normalize(rawTag);
    final filtered = tags.where((t) => t.normalized != normalized).toList();
    return PublicationTagSet(tags: filtered);
  }

  /// Verifica existencia por texto raw.
  bool contains(String rawTag) {
    final normalized = PublicationTag._normalize(rawTag);
    return tags.any((t) => t.normalized == normalized);
  }

  int get count => tags.length;
  bool get isEmpty => tags.isEmpty;

  Map<String, Object?> toJson() => {
        'tags': tags.map((t) => t.toJson()).toList(),
      };

  static PublicationTagSet fromJson(Map<String, Object?> json) {
    final list = (json['tags'] as List<dynamic>?)
            ?.map((e) => PublicationTag.fromJson(e as Map<String, Object?>))
            .toList() ??
        const <PublicationTag>[];
    return PublicationTagSet(tags: list);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PublicationTagSet) return false;
    if (tags.length != other.tags.length) return false;
    final a = tags.map((t) => t.normalized).toSet();
    final b = other.tags.map((t) => t.normalized).toSet();
    return a.length == b.length && a.containsAll(b);
  }

  @override
  int get hashCode => Object.hashAll(tags.map((t) => t.normalized));

  @override
  String toString() =>
      'PublicationTagSet(${tags.map((t) => t.raw).join(', ')})';
}

/// Resultado de matching de tags con scoring.
class TagMatchResult {
  final int exactMatches; // cantidad de matches exactos
  final int fuzzyMatches; // cantidad de matches por contención
  final double score; // 0.0 - 1.0

  const TagMatchResult({
    required this.exactMatches,
    required this.fuzzyMatches,
    required this.score,
  });

  bool get hasMatch => exactMatches > 0 || fuzzyMatches > 0;

  Map<String, Object?> toJson() => {
        'exactMatches': exactMatches,
        'fuzzyMatches': fuzzyMatches,
        'score': score,
      };
}

/// Servicio de dominio para matching y scoring de tags.
class PublicationTagService {
  static const double exactMatchWeight = 1.0;
  static const double fuzzyMatchWeight = 0.5;

  /// Compara dos conjuntos y devuelve un score de relevancia.
  ///
  /// Reglas:
  /// - Match exacto (normalized iguales): 1.0 por tag.
  /// - Match fuzzy (contención) con longitud mínima 3: 0.5 por tag.
  /// - Score final normalizado por cantidad de tags del query.
  static TagMatchResult matchTags({
    required PublicationTagSet publicationTags,
    required PublicationTagSet queryTags,
  }) {
    if (queryTags.isEmpty) {
      return const TagMatchResult(exactMatches: 0, fuzzyMatches: 0, score: 0.0);
    }

    int exactMatches = 0;
    int fuzzyMatches = 0;

    for (final q in queryTags.tags) {
      bool exact = false;
      bool fuzzy = false;

      for (final p in publicationTags.tags) {
        if (p.normalized == q.normalized) {
          exact = true;
          break;
        }

        // Fuzzy contención con longitud mínima 3 para reducir ruido.
        if (!fuzzy) {
          final a = p.normalized;
          final b = q.normalized;
          final minLen = a.length < b.length ? a.length : b.length;
          final eligible = minLen >= 3;
          if (eligible && (a.contains(b) || b.contains(a))) {
            fuzzy = true;
          }
        }
      }

      if (exact) {
        exactMatches++;
      } else if (fuzzy) {
        fuzzyMatches++;
      }
    }

    final total =
        (exactMatches * exactMatchWeight) + (fuzzyMatches * fuzzyMatchWeight);
    final normalized =
        (total / (queryTags.count * exactMatchWeight)).clamp(0.0, 1.0);

    return TagMatchResult(
      exactMatches: exactMatches,
      fuzzyMatches: fuzzyMatches,
      score: normalized,
    );
  }

  /// Filtra por umbral mínimo de score.
  static bool shouldIncludeByTags({
    required TagMatchResult matchResult,
    double minScoreThreshold = 0.3,
  }) {
    return matchResult.score >= minScoreThreshold;
  }

  /// Sugerencias ingenuas desde texto libre.
  static List<String> extractSuggestedTags(
    String freeText, {
    int maxSuggestions = 5,
  }) {
    final trimmed = freeText.trim();
    if (trimmed.isEmpty) return const [];

    final words = trimmed.split(RegExp(r'\s+'));
    final suggestions = <String>[];

    for (final w in words) {
      if (w.length >= 3 && w.length <= 50) {
        final norm = PublicationTag._normalize(w);
        // Evitar duplicados por normalización
        if (!suggestions.any((s) => PublicationTag._normalize(s) == norm)) {
          suggestions.add(w);
        }
      }
      if (suggestions.length >= maxSuggestions) break;
    }

    return suggestions;
  }
}
