// lib/domain/publications/entities/payloads/branch_announcement_payload.dart
// Payload específico para publicaciones tipo BRANCH_ANNOUNCEMENT (proveedor anuncia nueva sucursal).
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:avanzza/domain/shared/shared.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VALUE OBJECTS LOCALES
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: VO para lista de servicios ofrecidos con normalización y límites.
class ServicesOfferedList {
  static const int _maxItems = 50;
  static const int _maxLenPerItem = 80;

  final List<String> _values;
  List<String> get values => List.unmodifiable(_values);

  ServicesOfferedList._(this._values);

  factory ServicesOfferedList(Iterable<dynamic> raw) {
    final cleaned = <String>[];
    final seen = <String>{};

    for (final entry in raw) {
      if (entry == null) continue;
      final s = entry.toString().trim();
      if (s.isEmpty) continue;
      if (s.length > _maxLenPerItem) {
        throw ArgumentError(
          'Servicio "${s.substring(0, 30)}..." excede $_maxLenPerItem caracteres',
        );
      }

      final norm = s.toLowerCase();
      if (seen.add(norm)) cleaned.add(s);
    }

    if (cleaned.length > _maxItems) {
      throw ArgumentError('No puede exceder $_maxItems servicios');
    }

    return ServicesOfferedList._(cleaned);
  }

  int get length => _values.length;
  bool get isEmpty => _values.isEmpty;
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServicesOfferedList) return false;
    if (_values.length != other._values.length) return false;
    for (int i = 0; i < _values.length; i++) {
      if (_values[i] != other._values[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_values);

  @override
  String toString() => 'ServicesOfferedList(${_values.join(', ')})';
}

// ══════════════════════════════════════════════════════════════════════════════
// ENTIDAD PRINCIPAL
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: entidad inmutable para anuncio de nueva sucursal con validación fuerte y superficie pública compatible con JSON.
class BranchAnnouncementPayload {
  final String branchName;
  final String? address;
  final String? city;
  final List<String> coverageAreas;
  final int? openingDateEpochMs;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? mapsUrl;
  final List<String> servicesOffered;
  final String? notes;

  BranchAnnouncementPayload._({
    required this.branchName,
    this.address,
    this.city,
    required List<String> coverageAreas,
    this.openingDateEpochMs,
    this.phone,
    this.whatsapp,
    this.email,
    this.mapsUrl,
    required List<String> servicesOffered,
    this.notes,
  })  : coverageAreas = List.unmodifiable(coverageAreas),
        servicesOffered = List.unmodifiable(servicesOffered);

  // Comentarios en el código: helpers públicos que calculan derivados desde campos normalizados.
  bool coverageIncludes(String area) {
    final norm = area.trim().toLowerCase();
    return coverageAreas.any((c) => c.toLowerCase() == norm);
  }

  bool get hasOpeningDate => openingDateEpochMs != null;

  // Comentarios en el código: fábrica que delega en tryCreate y lanza ArgumentError con errores acumulados.
  factory BranchAnnouncementPayload.create({
    required String branchName,
    String? address,
    String? city,
    List<String> coverageAreas = const [],
    int? openingDateEpochMs,
    String? phone,
    String? whatsapp,
    String? email,
    String? mapsUrl,
    List<String> servicesOffered = const [],
    String? notes,
  }) {
    final result = tryCreate(
      branchName: branchName,
      address: address,
      city: city,
      coverageAreas: coverageAreas,
      openingDateEpochMs: openingDateEpochMs,
      phone: phone,
      whatsapp: whatsapp,
      email: email,
      mapsUrl: mapsUrl,
      servicesOffered: servicesOffered,
      notes: notes,
    );

    if (result.isFailure) {
      throw ArgumentError(
        result.errors.map((e) => e.toString()).join('; '),
      );
    }

    return result.value;
  }

  // Comentarios en el código: fábrica sin lanzamiento que valida con VOs y devuelve Result con lista completa de errores.
  static CreationResult<BranchAnnouncementPayload> tryCreate({
    required String branchName,
    String? address,
    String? city,
    List<String> coverageAreas = const [],
    int? openingDateEpochMs,
    String? phone,
    String? whatsapp,
    String? email,
    String? mapsUrl,
    List<String> servicesOffered = const [],
    String? notes,
  }) {
    final errors = <ValidationError>[];

    final normName = branchName.trim();
    final normAddress = address?.trim();
    final normCity = city?.trim();
    final normPhone = phone?.trim();
    final normWhatsapp = whatsapp?.trim();
    final normEmail = email?.trim();
    final normMapsUrl = mapsUrl?.trim();
    final normNotes = notes?.trim();

    if (normName.isEmpty) {
      errors.add(const ValidationError('branchName', 'No puede estar vacío'));
    } else if (normName.length > 120) {
      errors.add(const ValidationError(
          'branchName', 'No puede exceder 120 caracteres'));
    }

    if (normAddress != null && normAddress.length > 240) {
      errors.add(
          const ValidationError('address', 'No puede exceder 240 caracteres'));
    }

    if (normCity != null && normCity.length > 120) {
      errors.add(
          const ValidationError('city', 'No puede exceder 120 caracteres'));
    }

    CoverageAreaList? areas;
    try {
      areas = CoverageAreaList(coverageAreas);
    } catch (e) {
      errors.add(ValidationError('coverageAreas', e.toString()));
    }

    if (openingDateEpochMs != null && openingDateEpochMs < 0) {
      errors.add(
          const ValidationError('openingDateEpochMs', 'No puede ser negativo'));
    }

    if (normPhone != null && normPhone.length > 30) {
      errors.add(
          const ValidationError('phone', 'No puede exceder 30 caracteres'));
    }

    if (normWhatsapp != null && normWhatsapp.length > 30) {
      errors.add(
          const ValidationError('whatsapp', 'No puede exceder 30 caracteres'));
    }

    if (normEmail != null) {
      if (normEmail.length > 120) {
        errors.add(
            const ValidationError('email', 'No puede exceder 120 caracteres'));
      } else if (!normEmail.contains('@') || !normEmail.contains('.')) {
        errors.add(const ValidationError('email', 'Formato inválido'));
      }
    }

    if (normMapsUrl != null && normMapsUrl.length > 500) {
      errors.add(
          const ValidationError('mapsUrl', 'No puede exceder 500 caracteres'));
    }

    ServicesOfferedList? services;
    try {
      services = ServicesOfferedList(servicesOffered);
    } catch (e) {
      errors.add(ValidationError('servicesOffered', e.toString()));
    }

    if (normNotes != null && normNotes.length > 2000) {
      errors.add(
          const ValidationError('notes', 'No puede exceder 2000 caracteres'));
    }

    if (errors.isNotEmpty) {
      return CreationResult.failure(errors);
    }

    return CreationResult.success(
      BranchAnnouncementPayload._(
        branchName: normName,
        address: normAddress,
        city: normCity,
        coverageAreas: areas!.values,
        openingDateEpochMs: openingDateEpochMs,
        phone: normPhone,
        whatsapp: normWhatsapp,
        email: normEmail,
        mapsUrl: normMapsUrl,
        servicesOffered: services!.values,
        notes: normNotes,
      ),
    );
  }

  // Comentarios en el código: parser robusto desde JSON con casteo seguro num→int y validación vía tryCreate.
  static BranchAnnouncementPayload fromJson(Map<String, Object?> json) {
    final openingVal = (json['openingDateEpochMs'] as num?)?.toInt();

    final name = (json['branchName'] as String?)?.trim();
    final addr = (json['address'] as String?)?.trim();
    final cityVal = (json['city'] as String?)?.trim();
    final phoneVal = (json['phone'] as String?)?.trim();
    final whatsappVal = (json['whatsapp'] as String?)?.trim();
    final emailVal = (json['email'] as String?)?.trim();
    final mapsVal = (json['mapsUrl'] as String?)?.trim();
    final notesVal = (json['notes'] as String?)?.trim();

    final areas = (json['coverageAreas'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty && s.toLowerCase() != 'null')
            .toList() ??
        const <String>[];

    final services = (json['servicesOffered'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty && s.toLowerCase() != 'null')
            .toList() ??
        const <String>[];

    final result = tryCreate(
      branchName: name ?? '',
      address: addr,
      city: cityVal,
      coverageAreas: areas,
      openingDateEpochMs: openingVal,
      phone: phoneVal,
      whatsapp: whatsappVal,
      email: emailVal,
      mapsUrl: mapsVal,
      servicesOffered: services,
      notes: notesVal,
    );

    if (result.isFailure) {
      throw ArgumentError(
        'Validación JSON falló: ${result.errors.map((e) => e.toString()).join('; ')}',
      );
    }

    return result.value;
  }

  // Comentarios en el código: serialización a JSON con wire names estables y campos primitivos.
  Map<String, Object?> toJson() => {
        'branchName': branchName,
        'address': address,
        'city': city,
        'coverageAreas': coverageAreas,
        'openingDateEpochMs': openingDateEpochMs,
        'phone': phone,
        'whatsapp': whatsapp,
        'email': email,
        'mapsUrl': mapsUrl,
        'servicesOffered': servicesOffered,
        'notes': notes,
      };

  // Comentarios en el código: copy-with que pasa por create para revalidar con VOs.
  BranchAnnouncementPayload copyWith({
    String? branchName,
    String? address,
    String? city,
    List<String>? coverageAreas,
    int? openingDateEpochMs,
    String? phone,
    String? whatsapp,
    String? email,
    String? mapsUrl,
    List<String>? servicesOffered,
    String? notes,
  }) {
    return BranchAnnouncementPayload.create(
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      city: city ?? this.city,
      coverageAreas: coverageAreas ?? this.coverageAreas,
      openingDateEpochMs: openingDateEpochMs ?? this.openingDateEpochMs,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      mapsUrl: mapsUrl ?? this.mapsUrl,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      notes: notes ?? this.notes,
    );
  }

  // Comentarios en el código: igualdad y hash con comparación orden-sensible de listas por diseño.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BranchAnnouncementPayload) return false;

    if (coverageAreas.length != other.coverageAreas.length) return false;
    for (int i = 0; i < coverageAreas.length; i++) {
      if (coverageAreas[i] != other.coverageAreas[i]) return false;
    }

    if (servicesOffered.length != other.servicesOffered.length) return false;
    for (int i = 0; i < servicesOffered.length; i++) {
      if (servicesOffered[i] != other.servicesOffered[i]) return false;
    }

    return branchName == other.branchName &&
        address == other.address &&
        city == other.city &&
        openingDateEpochMs == other.openingDateEpochMs &&
        phone == other.phone &&
        whatsapp == other.whatsapp &&
        email == other.email &&
        mapsUrl == other.mapsUrl &&
        notes == other.notes;
  }

  @override
  int get hashCode => Object.hash(
        branchName,
        address,
        city,
        Object.hashAll(coverageAreas),
        openingDateEpochMs,
        phone,
        whatsapp,
        email,
        mapsUrl,
        Object.hashAll(servicesOffered),
        notes,
      );

  @override
  String toString() => 'BranchAnnouncementPayload('
      'branchName: $branchName, '
      'city: $city, '
      'areas: ${coverageAreas.length}, '
      'services: ${servicesOffered.length})';
}
