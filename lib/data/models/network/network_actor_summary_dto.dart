// ============================================================================
// lib/data/models/network/network_actor_summary_dto.dart
// NETWORK ACTOR SUMMARY DTO — Item de GET /v1/network (Mi Red Operativa v1)
// ============================================================================
// QUÉ HACE:
//   - Modela cada actor de la Red Operativa externa que retorna Core API en
//     GET /v1/network.
//   - Aplica las invariantes del contrato congelado durante el parse:
//       · categories no vacío.
//       · primaryCategory ∈ categories.
//       · isRestricted=true ⇒ primaryPhoneE164=null && primaryEmail=null.
//       · ref nunca puede ser user:* (eso es exclusivo de /v1/team).
//
// QUÉ NO HACE:
//   - No persiste en Isar (Hito 5b es read-only memoria + cursor).
//   - No mapea labels UI ni agrupamiento (eso vive en presentation/view_models).
//   - No infiere permisos: respeta `availableActions[].enabled` calculado por
//     backend.
//
// PRINCIPIOS:
//   - Wire-faithful: campos preservados con fidelidad para round-trip.
//   - Fail-fast en invariantes: un DTO inválido nunca llega a UI.
// ============================================================================

import 'network_action_dto.dart';
import 'network_actor_ref.dart';
import 'network_category.dart';

/// Motivo por el que un actor está restringido. Mapea a badge UI.
///
/// Valor `null` cuando isRestricted=false (no hay restricción).
enum NetworkRestrictionReason {
  suspended('suspended'),
  closed('closed');

  final String wireName;
  const NetworkRestrictionReason(this.wireName);

  static NetworkRestrictionReason? tryFromWire(String? value) {
    if (value == null) return null;
    for (final r in NetworkRestrictionReason.values) {
      if (r.wireName == value) return r;
    }
    return null;
  }
}

/// Estado de la relación operativa con el actor (cara externa del backend).
///
/// Espejo del subset visible vía /v1/network. Los estados internos
/// (referenciada, detectable, activadaUnilateral) NO se exponen aquí —
/// solo los que un consumidor de la Red Operativa necesita ver.
enum NetworkRelationshipState {
  vinculada('vinculada'),
  suspendida('suspendida'),
  cerrada('cerrada');

  final String wireName;
  const NetworkRelationshipState(this.wireName);

  static NetworkRelationshipState fromWire(String value) {
    for (final s in NetworkRelationshipState.values) {
      if (s.wireName == value) return s;
    }
    throw FormatException('NetworkRelationshipState desconocido: "$value"');
  }
}

/// Item de GET /v1/network.
class NetworkActorSummaryDto {
  /// Referencia parseada. Garantizado: kind ∈ {platform, local}.
  /// Nunca user (esa namespace pertenece a /v1/team).
  final NetworkActorRef ref;

  final String? displayName;
  final String? avatarRef;

  /// True cuando el actor es una referencia local sin PlatformActor canónico
  /// resuelto. Habilita CTAs como "Invitar a la plataforma".
  final bool unresolved;

  /// Categorías a las que pertenece el actor. Garantizado no vacío.
  final List<NetworkCategory> categories;

  /// Categoría principal sugerida para agrupamiento UI. Garantizado ∈ categories.
  final NetworkCategory primaryCategory;

  /// True si este actor es además miembro del equipo interno. Permite a la UI
  /// dedupe-mark cuando se renderice una vista unificada (no en Hito 5b).
  final bool isTeamMember;

  /// Estado restringido (suspendido/cerrado). Cuando true, los canales de
  /// contacto vienen null por contrato.
  final bool isRestricted;

  /// Motivo de la restricción. Garantizado no-null cuando isRestricted=true.
  final NetworkRestrictionReason? restrictionReason;

  /// Garantizado null cuando isRestricted=true.
  final String? primaryPhoneE164;

  /// Garantizado null cuando isRestricted=true.
  final String? primaryEmail;

  final bool hasWhatsApp;

  final NetworkRelationshipState relationshipState;

  final String? providerProfileId;

  /// Acciones operativas calculadas por backend, ordenadas por type asc.
  /// El orden lo preserva el parser; no se reordena.
  final List<NetworkActionDto> availableActions;

  /// Secciones UI a las que pertenece el actor según el backend
  /// (NETWORK_API_SCHEMA_VERSION=2). Wire keys conocidas: `parts_and_supplies`,
  /// `services_and_workshops`, `commercial_advisors`, `legal`,
  /// `owners_and_tenants`. Strings raw sin enum cerrado para forward-compat
  /// con valores futuros del backend. Lista posiblemente vacía.
  final List<String> sectionKeys;

  /// Timestamp del último cambio observable del summary. Usado para
  /// invalidación de cache local / delta-sync.
  final DateTime updatedAt;

  const NetworkActorSummaryDto({
    required this.ref,
    required this.displayName,
    required this.avatarRef,
    required this.unresolved,
    required this.categories,
    required this.primaryCategory,
    required this.isTeamMember,
    required this.isRestricted,
    required this.restrictionReason,
    required this.primaryPhoneE164,
    required this.primaryEmail,
    required this.hasWhatsApp,
    required this.relationshipState,
    required this.providerProfileId,
    required this.availableActions,
    required this.sectionKeys,
    required this.updatedAt,
  });

  factory NetworkActorSummaryDto.fromJson(Map<String, dynamic> json) {
    // Ref: parsear string canónico y rechazar user:*.
    final refRaw = json['ref'] as String;
    final ref = NetworkActorRef.parse(refRaw);
    if (ref.isUser) {
      throw FormatException(
        'NetworkActorSummaryDto rechaza ref user:* '
        '(reservado a /v1/team): "$refRaw"',
      );
    }

    // Categorías: lista no vacía + primaryCategory contenido en ella.
    final categoriesRaw = (json['categories'] as List<dynamic>?) ?? const [];
    if (categoriesRaw.isEmpty) {
      throw const FormatException(
        'NetworkActorSummaryDto.categories no puede ser vacío',
      );
    }
    final categories = categoriesRaw
        .map((e) => NetworkCategory.fromWire(e as String))
        .toList(growable: false);

    final primaryCategoryRaw = json['primaryCategory'] as String;
    final primaryCategory = NetworkCategory.fromWire(primaryCategoryRaw);
    if (!categories.contains(primaryCategory)) {
      throw FormatException(
        'NetworkActorSummaryDto.primaryCategory ("${primaryCategory.wireName}") '
        'no pertenece a categories ${categories.map((c) => c.wireName).toList()}',
      );
    }

    // Restricción: si está restringido, contactos deben venir null.
    final isRestricted = json['isRestricted'] as bool;
    final restrictionReasonRaw = json['restrictionReason'] as String?;
    final restrictionReason =
        NetworkRestrictionReason.tryFromWire(restrictionReasonRaw);
    final primaryPhoneE164 = json['primaryPhoneE164'] as String?;
    final primaryEmail = json['primaryEmail'] as String?;

    if (isRestricted) {
      if (restrictionReason == null) {
        throw const FormatException(
          'NetworkActorSummaryDto.restrictionReason requerido cuando '
          'isRestricted=true',
        );
      }
      if (primaryPhoneE164 != null || primaryEmail != null) {
        throw FormatException(
          'NetworkActorSummaryDto inválido: isRestricted=true exige '
          'primaryPhoneE164=null && primaryEmail=null '
          '(recibido phone=${primaryPhoneE164 != null}, '
          'email=${primaryEmail != null})',
        );
      }
    }

    // availableActions: preservar orden recibido.
    final actionsRaw = (json['availableActions'] as List<dynamic>?) ?? const [];
    final availableActions = actionsRaw
        .map((e) => NetworkActionDto.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    // sectionKeys (schemaVersion=2): wire keys raw, sin enum cerrado.
    // Default const [] si no viene (schemas previos o backend en transición).
    final sectionKeysRaw = (json['sectionKeys'] as List<dynamic>?) ?? const [];
    final sectionKeys = sectionKeysRaw
        .whereType<String>()
        .toList(growable: false);

    return NetworkActorSummaryDto(
      ref: ref,
      displayName: json['displayName'] as String?,
      avatarRef: json['avatarRef'] as String?,
      unresolved: json['unresolved'] as bool,
      categories: categories,
      primaryCategory: primaryCategory,
      isTeamMember: json['isTeamMember'] as bool,
      isRestricted: isRestricted,
      restrictionReason: restrictionReason,
      primaryPhoneE164: primaryPhoneE164,
      primaryEmail: primaryEmail,
      hasWhatsApp: json['hasWhatsApp'] as bool,
      relationshipState:
          NetworkRelationshipState.fromWire(json['relationshipState'] as String),
      providerProfileId: json['providerProfileId'] as String?,
      availableActions: availableActions,
      sectionKeys: sectionKeys,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'ref': ref.raw,
        'displayName': displayName,
        'avatarRef': avatarRef,
        'unresolved': unresolved,
        'categories': categories.map((c) => c.wireName).toList(),
        'primaryCategory': primaryCategory.wireName,
        'isTeamMember': isTeamMember,
        'isRestricted': isRestricted,
        'restrictionReason': restrictionReason?.wireName,
        'primaryPhoneE164': primaryPhoneE164,
        'primaryEmail': primaryEmail,
        'hasWhatsApp': hasWhatsApp,
        'relationshipState': relationshipState.wireName,
        'providerProfileId': providerProfileId,
        'availableActions': availableActions.map((a) => a.toJson()).toList(),
        'sectionKeys': sectionKeys,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
