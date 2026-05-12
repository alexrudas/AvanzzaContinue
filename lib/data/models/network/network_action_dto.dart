// ============================================================================
// lib/data/models/network/network_action_dto.dart
// NETWORK ACTION DTO — Acción habilitada/deshabilitada calculada por backend
// ============================================================================
// QUÉ HACE:
//   - Modela cada elemento del array `availableActions[]` que viaja en
//     NetworkActorSummaryDto y TeamMemberSummaryDto.
//   - Centraliza los 4 enums cerrados que componen una acción:
//       · NetworkActionType        (tipo operativo: call, whatsapp, email, ...)
//       · NetworkActionDomain      (a qué dominio pertenece: provider, etc.)
//       · NetworkActionDisabledReason  (por qué está deshabilitada)
//       · NetworkActionCapability  (qué capability requiere si aplica)
//
// QUÉ NO HACE:
//   - No calcula nada: el backend determina `enabled` y `reason`. Flutter
//     SOLO respeta lo que viene. NO infiere permisos cliente-side.
//   - No mapea a labels UI: ese mapeo vive en presentation/view_models.
//
// INVARIANTES (enforced en parse):
//   - enabled=false ⇒ reason !== null (contrato congelado).
//   - enabled=true  ⇒ reason puede venir o no; se preserva si viene.
//   - reason desconocido se mapea a `other` (forward-compat con catálogo
//     extendido por backend sin breaking change).
//   - capability desconocido se mapea a `unknownCapability` (idem).
//
// ORDEN ESTABLE:
//   - El backend garantiza que availableActions[] viene ordenado por type asc.
//   - Flutter NO reordena al parsear (preserva el orden recibido). Si el
//     backend incumpliera el contrato, los tests de orden lo detectan.
// ============================================================================

/// Tipo operativo de una acción.
enum NetworkActionType {
  call('call'),
  whatsapp('whatsapp'),
  email('email'),
  viewProviderProfile('view_provider_profile'),
  requestQuote('request_quote'),
  startCoordinationFlow('start_coordination_flow');

  final String wireName;
  const NetworkActionType(this.wireName);

  /// Parse estricto: lanza si el tipo no está en el catálogo. A diferencia
  /// de reason/capability, el `type` es la clave principal del switch UI;
  /// si llega uno desconocido, es un bug crítico del contrato — fallar
  /// rápido es preferible a ignorar silenciosamente.
  static NetworkActionType fromWire(String value) {
    for (final t in NetworkActionType.values) {
      if (t.wireName == value) return t;
    }
    throw FormatException('NetworkActionType desconocido: "$value"');
  }
}

/// Dominio al que pertenece la acción (para enrutamiento client-side).
/// `null` indica acción transversal (ej. call/whatsapp/email puro).
enum NetworkActionDomain {
  provider('provider'),
  purchaseRequest('purchase-request'),
  coordinationFlow('coordination-flow');

  final String wireName;
  const NetworkActionDomain(this.wireName);

  static NetworkActionDomain? tryFromWire(String? value) {
    if (value == null) return null;
    for (final d in NetworkActionDomain.values) {
      if (d.wireName == value) return d;
    }
    return null;
  }
}

/// Motivo por el que una acción viene `enabled=false`.
///
/// Catálogo cerrado por contrato. `other` actúa como safety valve:
/// cuando backend agregue valores nuevos, clientes viejos los renderizan
/// como motivo genérico hasta actualizarse.
enum NetworkActionDisabledReason {
  phoneNotAvailable('phone_not_available'),
  emailNotAvailable('email_not_available'),
  capabilityMissing('capability_missing'),
  relationshipNotActive('relationship_not_active'),
  notAProvider('not_a_provider'),
  unresolvedActor('unresolved_actor'),
  other('other');

  final String wireName;
  const NetworkActionDisabledReason(this.wireName);

  /// Forward-compat: cualquier valor no listado se mapea a `other`.
  static NetworkActionDisabledReason fromWire(String value) {
    for (final r in NetworkActionDisabledReason.values) {
      if (r.wireName == value) return r;
    }
    return NetworkActionDisabledReason.other;
  }
}

/// Capability requerida por la acción, si aplica.
///
/// Catálogo cerrado actual del backend. `unknownCapability` actúa como
/// safety valve para forward-compat — Flutter NO valida capabilities
/// (es decisión del backend en `enabled`), pero preserva el dato para
/// debugging y telemetría.
enum NetworkActionCapability {
  providerRead('provider.read'),
  purchaseRequestCreate('purchase_request.create'),
  unknownCapability('__unknown__');

  final String wireName;
  const NetworkActionCapability(this.wireName);

  static NetworkActionCapability? tryFromWire(String? value) {
    if (value == null) return null;
    for (final c in NetworkActionCapability.values) {
      if (c.wireName == value) return c;
    }
    return NetworkActionCapability.unknownCapability;
  }
}

/// Acción operativa calculada por el backend para un actor.
///
/// Viene en NetworkActorSummaryDto.availableActions y
/// TeamMemberSummaryDto.availableActions.
class NetworkActionDto {
  final NetworkActionType type;
  final bool enabled;
  final NetworkActionDomain? domain;
  final NetworkActionCapability? capability;

  /// Motivo de deshabilitación. Garantizado no-null cuando enabled=false
  /// (invariante del contrato). Puede venir cuando enabled=true (informativo).
  final NetworkActionDisabledReason? reason;

  /// Wire name original del capability cuando llegó desconocido. Útil para
  /// telemetría: permite reportar drift de catálogo sin perder el valor.
  /// Null si capability fue null o si fue reconocido.
  final String? rawUnknownCapability;

  const NetworkActionDto({
    required this.type,
    required this.enabled,
    this.domain,
    this.capability,
    this.reason,
    this.rawUnknownCapability,
  });

  /// Construye desde JSON validando la invariante enabled=false ⇒ reason.
  factory NetworkActionDto.fromJson(Map<String, dynamic> json) {
    final type = NetworkActionType.fromWire(json['type'] as String);
    final enabled = json['enabled'] as bool;

    final domainRaw = json['domain'] as String?;
    final domain = NetworkActionDomain.tryFromWire(domainRaw);

    final capabilityRaw = json['capability'] as String?;
    NetworkActionCapability? capability;
    String? rawUnknown;
    if (capabilityRaw != null) {
      final parsed = NetworkActionCapability.tryFromWire(capabilityRaw);
      capability = parsed;
      if (parsed == NetworkActionCapability.unknownCapability) {
        rawUnknown = capabilityRaw;
      }
    }

    final reasonRaw = json['reason'] as String?;
    final reason =
        reasonRaw == null ? null : NetworkActionDisabledReason.fromWire(reasonRaw);

    if (!enabled && reason == null) {
      throw FormatException(
        'NetworkActionDto inválido: enabled=false requiere reason '
        '(type=${type.wireName})',
      );
    }

    return NetworkActionDto(
      type: type,
      enabled: enabled,
      domain: domain,
      capability: capability,
      reason: reason,
      rawUnknownCapability: rawUnknown,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.wireName,
        'enabled': enabled,
        'domain': domain?.wireName,
        'capability': rawUnknownCapability ?? capability?.wireName,
        if (reason != null) 'reason': reason!.wireName,
      };
}
