// lib/domain/publications/entities/publication.dart
// Entidad agregada Publication con discriminated union por kind.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:avanzza/domain/shared/shared.dart';
import 'payloads/branch_announcement_payload.dart';
import 'payloads/driver_seek_payload.dart';
import 'payloads/product_offer_payload.dart';
import 'payloads/service_offer_payload.dart';
import 'payloads/tenant_seek_payload.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ENUMS LOCALES
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: enum para estado del ciclo de vida de la publicación.
enum PublicationStatus {
  draft,
  published,
  archived,
}

// Comentarios en el código: extensión para serialización wire-stable de PublicationStatus.
extension PublicationStatusWire on PublicationStatus {
  String get wireName {
    switch (this) {
      case PublicationStatus.draft:
        return 'draft';
      case PublicationStatus.published:
        return 'published';
      case PublicationStatus.archived:
        return 'archived';
    }
  }

  static PublicationStatus fromWire(String? raw) {
    if (raw == null) return PublicationStatus.draft;
    switch (raw.trim().toLowerCase()) {
      case 'draft':
      case 'borrador':
        return PublicationStatus.draft;
      case 'published':
      case 'publicado':
      case 'publicada':
        return PublicationStatus.published;
      case 'archived':
      case 'archivado':
      case 'archivada':
        return PublicationStatus.archived;
      default:
        return PublicationStatus.draft;
    }
  }
}

// Comentarios en el código: enum para tipo de publicación (discriminador de payload).
enum PublicationKind {
  driverSeek,
  tenantSeek,
  productOffer,
  serviceOffer,
  branchAnnouncement,
}

// Comentarios en el código: extensión para serialización wire-stable de PublicationKind.
extension PublicationKindWire on PublicationKind {
  String get wireName {
    switch (this) {
      case PublicationKind.driverSeek:
        return 'driver_seek';
      case PublicationKind.tenantSeek:
        return 'tenant_seek';
      case PublicationKind.productOffer:
        return 'product_offer';
      case PublicationKind.serviceOffer:
        return 'service_offer';
      case PublicationKind.branchAnnouncement:
        return 'branch_announcement';
    }
  }

  static PublicationKind? fromWire(String? raw) {
    if (raw == null) return null;
    switch (raw.trim().toLowerCase()) {
      case 'driver_seek':
      case 'driverseek':
        return PublicationKind.driverSeek;
      case 'tenant_seek':
      case 'tenantseek':
        return PublicationKind.tenantSeek;
      case 'product_offer':
      case 'productoffer':
        return PublicationKind.productOffer;
      case 'service_offer':
      case 'serviceoffer':
        return PublicationKind.serviceOffer;
      case 'branch_announcement':
      case 'branchannouncement':
        return PublicationKind.branchAnnouncement;
      default:
        return null;
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ENTIDAD AGREGADA
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: entidad agregada inmutable con discriminated union por kind.
class Publication {
  final String id;
  final String ownerId;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;
  final String? countryCode;
  final String? city;
  final String status;
  final String kind;
  final Object payload;

  Publication._({
    required this.id,
    required this.ownerId,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
    this.countryCode,
    this.city,
    required this.status,
    required this.kind,
    required this.payload,
  });

  // Comentarios en el código: helpers públicos para type-safe casting de payload.
  DriverSeekPayload get asDriverSeek {
    if (payload is! DriverSeekPayload) {
      throw StateError('Payload no es DriverSeekPayload');
    }
    return payload as DriverSeekPayload;
  }

  TenantSeekPayload get asTenantSeek {
    if (payload is! TenantSeekPayload) {
      throw StateError('Payload no es TenantSeekPayload');
    }
    return payload as TenantSeekPayload;
  }

  ProductOfferPayload get asProductOffer {
    if (payload is! ProductOfferPayload) {
      throw StateError('Payload no es ProductOfferPayload');
    }
    return payload as ProductOfferPayload;
  }

  ServiceOfferPayload get asServiceOffer {
    if (payload is! ServiceOfferPayload) {
      throw StateError('Payload no es ServiceOfferPayload');
    }
    return payload as ServiceOfferPayload;
  }

  BranchAnnouncementPayload get asBranchAnnouncement {
    if (payload is! BranchAnnouncementPayload) {
      throw StateError('Payload no es BranchAnnouncementPayload');
    }
    return payload as BranchAnnouncementPayload;
  }

  // Comentarios en el código: fábrica que delega en tryCreate y lanza ArgumentError con errores acumulados.
  factory Publication.create({
    required String id,
    required String ownerId,
    required int createdAtEpochMs,
    required int updatedAtEpochMs,
    String? countryCode,
    String? city,
    required String status,
    required String kind,
    required Object payload,
  }) {
    final result = tryCreate(
      id: id,
      ownerId: ownerId,
      createdAtEpochMs: createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs,
      countryCode: countryCode,
      city: city,
      status: status,
      kind: kind,
      payload: payload,
    );

    if (result.isFailure) {
      throw ArgumentError(
        result.errors.map((e) => e.toString()).join('; '),
      );
    }

    return result.value;
  }

  // Comentarios en el código: fábrica sin lanzamiento que valida y devuelve Result con lista completa de errores.
  static CreationResult<Publication> tryCreate({
    required String id,
    required String ownerId,
    required int createdAtEpochMs,
    required int updatedAtEpochMs,
    String? countryCode,
    String? city,
    required String status,
    required String kind,
    required Object payload,
  }) {
    final errors = <ValidationError>[];

    final normId = id.trim();
    final normOwnerId = ownerId.trim();
    final normCountry = countryCode?.trim().toUpperCase();
    final normCity = city?.trim();
    final normStatus = status.trim();
    final normKind = kind.trim();

    if (normId.isEmpty) {
      errors.add(const ValidationError('id', 'No puede estar vacío'));
    } else if (normId.length > 120) {
      errors
          .add(const ValidationError('id', 'No puede exceder 120 caracteres'));
    }

    if (normOwnerId.isEmpty) {
      errors.add(const ValidationError('ownerId', 'No puede estar vacío'));
    } else if (normOwnerId.length > 120) {
      errors.add(
          const ValidationError('ownerId', 'No puede exceder 120 caracteres'));
    }

    if (createdAtEpochMs < 0) {
      errors.add(
          const ValidationError('createdAtEpochMs', 'No puede ser negativo'));
    }

    if (updatedAtEpochMs < 0) {
      errors.add(
          const ValidationError('updatedAtEpochMs', 'No puede ser negativo'));
    }

    if (updatedAtEpochMs < createdAtEpochMs) {
      errors.add(const ValidationError(
          'updatedAtEpochMs', 'No puede ser menor que createdAtEpochMs'));
    }

    if (normCountry != null) {
      final countryPattern = RegExp(r'^[A-Z]{2}$');
      if (!countryPattern.hasMatch(normCountry)) {
        errors.add(const ValidationError('countryCode',
            'Debe ser ISO 3166-1 alpha-2 (2 letras mayúsculas)'));
      }
    }

    if (normCity != null && normCity.length > 120) {
      errors.add(
          const ValidationError('city', 'No puede exceder 120 caracteres'));
    }

    final enumStatus = PublicationStatusWire.fromWire(normStatus);
    final enumKind = PublicationKindWire.fromWire(normKind);

    if (enumKind == null) {
      errors.add(ValidationError('kind', 'Valor no reconocido: "$normKind"'));
    } else {
      // Validar consistencia kind-payload
      final isValid = _validatePayloadConsistency(enumKind, payload);
      if (!isValid) {
        errors.add(ValidationError('payload',
            'Tipo inconsistente con kind "$normKind": ${payload.runtimeType}'));
      }
    }

    if (errors.isNotEmpty) {
      return CreationResult.failure(errors);
    }

    return CreationResult.success(
      Publication._(
        id: normId,
        ownerId: normOwnerId,
        createdAtEpochMs: createdAtEpochMs,
        updatedAtEpochMs: updatedAtEpochMs,
        countryCode: normCountry,
        city: normCity,
        status: enumStatus.wireName,
        kind: enumKind!.wireName,
        payload: payload,
      ),
    );
  }

  // Comentarios en el código: valida que el tipo de payload coincida con el kind.
  static bool _validatePayloadConsistency(
      PublicationKind kind, Object payload) {
    switch (kind) {
      case PublicationKind.driverSeek:
        return payload is DriverSeekPayload;
      case PublicationKind.tenantSeek:
        return payload is TenantSeekPayload;
      case PublicationKind.productOffer:
        return payload is ProductOfferPayload;
      case PublicationKind.serviceOffer:
        return payload is ServiceOfferPayload;
      case PublicationKind.branchAnnouncement:
        return payload is BranchAnnouncementPayload;
    }
  }

  // Comentarios en el código: parser robusto desde JSON con despacho por kind.
  static Publication fromJson(Map<String, Object?> json) {
    final id = (json['id'] as String?)?.trim();
    final ownerId = (json['ownerId'] as String?)?.trim();
    final createdAt = (json['createdAtEpochMs'] as num?)?.toInt();
    final updatedAt = (json['updatedAtEpochMs'] as num?)?.toInt();
    final country = (json['countryCode'] as String?)?.trim();
    final cityVal = (json['city'] as String?)?.trim();
    final statusVal = (json['status'] as String?)?.trim();
    final kindVal = (json['kind'] as String?)?.trim();

    if (kindVal == null || kindVal.isEmpty) {
      throw ArgumentError('Campo "kind" requerido en JSON');
    }

    final enumKind = PublicationKindWire.fromWire(kindVal);
    if (enumKind == null) {
      throw ArgumentError('Valor de kind no reconocido: "$kindVal"');
    }

    final payloadJson = json['payload'] as Map<String, Object?>?;
    if (payloadJson == null) {
      throw ArgumentError('Campo "payload" requerido en JSON');
    }

    Object payload;
    switch (enumKind) {
      case PublicationKind.driverSeek:
        payload = DriverSeekPayload.fromJson(payloadJson);
        break;
      case PublicationKind.tenantSeek:
        payload = TenantSeekPayload.fromJson(payloadJson);
        break;
      case PublicationKind.productOffer:
        payload = ProductOfferPayload.fromJson(payloadJson);
        break;
      case PublicationKind.serviceOffer:
        payload = ServiceOfferPayload.fromJson(payloadJson);
        break;
      case PublicationKind.branchAnnouncement:
        payload = BranchAnnouncementPayload.fromJson(payloadJson);
        break;
    }

    final result = tryCreate(
      id: id ?? '',
      ownerId: ownerId ?? '',
      createdAtEpochMs: createdAt ?? 0,
      updatedAtEpochMs: updatedAt ?? 0,
      countryCode: country,
      city: cityVal,
      status: statusVal ?? 'draft',
      kind: kindVal,
      payload: payload,
    );

    if (result.isFailure) {
      throw ArgumentError(
        'Validación JSON falló: ${result.errors.map((e) => e.toString()).join('; ')}',
      );
    }

    return result.value;
  }

  // Comentarios en el código: serialización a JSON con wire names estables.
  Map<String, Object?> toJson() {
    Map<String, Object?> payloadJson;

    if (payload is DriverSeekPayload) {
      payloadJson = (payload as DriverSeekPayload).toJson();
    } else if (payload is TenantSeekPayload) {
      payloadJson = (payload as TenantSeekPayload).toJson();
    } else if (payload is ProductOfferPayload) {
      payloadJson = (payload as ProductOfferPayload).toJson();
    } else if (payload is ServiceOfferPayload) {
      payloadJson = (payload as ServiceOfferPayload).toJson();
    } else if (payload is BranchAnnouncementPayload) {
      payloadJson = (payload as BranchAnnouncementPayload).toJson();
    } else {
      throw StateError('Tipo de payload desconocido: ${payload.runtimeType}');
    }

    return {
      'id': id,
      'ownerId': ownerId,
      'createdAtEpochMs': createdAtEpochMs,
      'updatedAtEpochMs': updatedAtEpochMs,
      'countryCode': countryCode,
      'city': city,
      'status': status,
      'kind': kind,
      'payload': payloadJson,
    };
  }

  // Comentarios en el código: copy-with que pasa por create para revalidar.
  Publication copyWith({
    String? id,
    String? ownerId,
    int? createdAtEpochMs,
    int? updatedAtEpochMs,
    String? countryCode,
    String? city,
    String? status,
    String? kind,
    Object? payload,
  }) {
    return Publication.create(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      status: status ?? this.status,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
    );
  }

  // Comentarios en el código: igualdad semántica completa incluyendo payload.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Publication) return false;

    return id == other.id &&
        ownerId == other.ownerId &&
        createdAtEpochMs == other.createdAtEpochMs &&
        updatedAtEpochMs == other.updatedAtEpochMs &&
        countryCode == other.countryCode &&
        city == other.city &&
        status == other.status &&
        kind == other.kind &&
        payload == other.payload;
  }

  @override
  int get hashCode => Object.hash(
        id,
        ownerId,
        createdAtEpochMs,
        updatedAtEpochMs,
        countryCode,
        city,
        status,
        kind,
        payload,
      );

  @override
  String toString() =>
      'Publication(id: $id, kind: $kind, status: $status, owner: $ownerId)';
}
