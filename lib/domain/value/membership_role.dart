// ============================================================================
// lib/domain/value/membership_role.dart
// MembershipRole — catálogo cerrado de permisos internos del miembro
// ============================================================================
// QUÉ HACE:
//   - Define los roles ASIGNABLES a un miembro DENTRO de un workspace.
//   - Catálogo cerrado: admin | sales_agent | purchase_manager | operator | viewer.
//   - Wire-stable: cada valor expone wireName y se parsea desde wire vía fromWire/
//     tryFromWire; rechaza strings fuera del catálogo.
//
// QUÉ NO HACE:
//   - NO modela "qué ofrece el workspace al mercado": eso es CapabilityProfile
//     (vive en Organization, no en Membership).
//   - NO modela la relación de un workspace/persona con un activo: eso es
//     AssetActorRole (owner/tenant/operator/driver/technician/workshop/legal/manager).
//   - NO modela permisos finos por módulo: el permiso fino se deriva del rol +
//     MembershipScope + ProductAccessContext en la capa de policy.
//
// REGLA CANÓNICA (ver feedback_avanzza_canonical_separation):
//   Membership.roles SOLO acepta valores de este catálogo. Está prohibido
//   poblar Membership.roles con etiquetas tipo 'provider' | 'owner' | 'renter';
//   esos conceptos viven en Workspace.capabilityProfiles y AssetActorLink.
//
// BYPASS DE FUNDADOR:
//   MembershipEntity.isOwner es independiente de este catálogo. Una membership
//   con isOwner=true conserva acceso total al workspace aunque sus roles
//   queden vacíos o sin admin (seguro de vida del creador). El enforcement de
//   ese bypass se aplica en la capa que evalúa permisos, NO en este catálogo.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum MembershipRole {
  /// Gobierna el workspace: invita miembros, configura capacidades,
  /// administra todos los flujos. Único rol asignado al fundador en onboarding.
  @JsonValue('admin')
  admin,

  /// Opera flujos de venta y cotización hacia clientes/contrapartes.
  @JsonValue('sales_agent')
  salesAgent,

  /// Opera flujos de compra y aprovisionamiento del workspace.
  @JsonValue('purchase_manager')
  purchaseManager,

  /// Ejecuta operaciones del día a día (mantenimiento, agenda, ejecución).
  @JsonValue('operator')
  operator,

  /// Solo lectura sobre los datos del workspace.
  @JsonValue('viewer')
  viewer,
}

extension MembershipRoleX on MembershipRole {
  /// Identificador estable usado en JSON / Firestore / Isar.
  String get wireName {
    switch (this) {
      case MembershipRole.admin:
        return 'admin';
      case MembershipRole.salesAgent:
        return 'sales_agent';
      case MembershipRole.purchaseManager:
        return 'purchase_manager';
      case MembershipRole.operator:
        return 'operator';
      case MembershipRole.viewer:
        return 'viewer';
    }
  }

  /// Parsea un wire name a su valor canónico. Throws [ArgumentError]
  /// si el string no está en el catálogo. Usar para datos confiables.
  static MembershipRole fromWire(String raw) {
    final parsed = tryFromWire(raw);
    if (parsed == null) {
      throw ArgumentError('MembershipRole desconocido: $raw');
    }
    return parsed;
  }

  /// Versión no-throw de [fromWire]. Retorna null si el string no
  /// está en el catálogo. Usar para datos legacy o entrada externa
  /// que requiera filtrado silencioso.
  static MembershipRole? tryFromWire(String raw) {
    switch (raw) {
      case 'admin':
        return MembershipRole.admin;
      case 'sales_agent':
        return MembershipRole.salesAgent;
      case 'purchase_manager':
        return MembershipRole.purchaseManager;
      case 'operator':
        return MembershipRole.operator;
      case 'viewer':
        return MembershipRole.viewer;
      default:
        return null;
    }
  }

  /// True si [raw] coincide exactamente con un wire name del catálogo.
  static bool isValidWireName(String raw) => tryFromWire(raw) != null;

  /// Lookup tolerante con normalización: aplica trim + toLowerCase ANTES
  /// de matchear contra el catálogo. Retorna `null` para `null`, vacío,
  /// whitespace-only o desconocido.
  ///
  /// Diseñado para consumidores de POLICY (`MembershipPolicy`) y para el
  /// path tolerante de adapters legacy. Garantiza que un admin almacenado
  /// como `'Admin'`, `'ADMIN'` o `'  admin  '` NO pierda permisos por
  /// inconsistencia de formato.
  ///
  /// Ejemplos:
  /// - `tryParseFlexible('Admin')`   ⇒ `MembershipRole.admin`
  /// - `tryParseFlexible('ADMIN')`   ⇒ `MembershipRole.admin`
  /// - `tryParseFlexible(' admin ')` ⇒ `MembershipRole.admin`
  /// - `tryParseFlexible('manager')` ⇒ `null` (no en catálogo)
  /// - `tryParseFlexible('')`        ⇒ `null`
  /// - `tryParseFlexible(null)`      ⇒ `null`
  static MembershipRole? tryParseFlexible(String? raw) {
    if (raw == null) return null;
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    return tryFromWire(normalized);
  }

  /// Snapshot inmutable de todos los wire names del catálogo, en el
  /// orden de declaración del enum.
  static List<String> get allWireNames =>
      MembershipRole.values.map((r) => r.wireName).toList(growable: false);
}
