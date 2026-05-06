// ============================================================================
// lib/domain/entities/user/membership_entity.dart
// MEMBERSHIP ENTITY — Enterprise Ultra Pro (Domain / Entity)
//
// QUÉ HACE:
// - Representa la membresía de un usuario en una organización.
// - Contiene datos de identidad (userId, orgId), roles, estatus y ubicación.
// - Incluye MembershipScope para definir alcance de acceso a activos.
// - Soporta providerProfiles para membresías de tipo proveedor.
//
// QUÉ NO HACE:
// - No persiste por sí misma (MembershipModel maneja persistencia).
// - No resuelve scope de grupos (eso es responsabilidad de capa repositorio).
// - No valida roles ni estatus (eso lo hace la capa de negocio/policy).
//
// NOTAS:
// - scope tiene @Default(MembershipScope()) → restricted sin acceso por defecto.
// - Freezed + JsonSerializable para consistencia con el resto del dominio.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value/membership_scope.dart';
import 'provider_profile.dart';

part 'membership_entity.freezed.dart';
part 'membership_entity.g.dart';

@freezed
abstract class MembershipEntity with _$MembershipEntity {
  const factory MembershipEntity({
    required String userId,
    required String orgId,
    required String orgName,

    /// Roles legacy como `List<String>` mientras dura la Fase 1 de transición.
    ///
    /// **PROHIBIDO leer este campo directamente para lógica de permisos.**
    /// Cualquier consumidor que tome decisiones de autorización DEBE pasar
    /// por `MembershipPolicy` (`lib/domain/policy/membership_policy.dart`),
    /// que normaliza case + trim y respeta el bypass de fundador (isOwner).
    ///
    /// Lecturas directas autorizadas:
    /// - Serialización (data layer mappers).
    /// - El parser tolerante (`LegacyMembershipRoleParser`).
    /// - El facade canónico (`MembershipPolicy`).
    ///
    /// Para listar roles en UI, también usar `MembershipPolicy.parsedRoles`.
    /// Razón: comparar `'Admin' == 'admin'` falla en Dart string equality;
    /// strings desconocidos son drift de datos que debe loggearse via
    /// telemetría; el creador del workspace conserva acceso aunque sus
    /// roles queden vacíos.
    @Default(<String>[]) List<String> roles,
    @Deprecated(
      'Use Organization.capabilityProfiles. '
      'Membership.providerProfiles is legacy and will be removed in Fase 2.',
    )
    @Default(<ProviderProfile>[]) List<ProviderProfile> providerProfiles,
    required String estatus, // activo | inactivo | invited | suspended | left
    required Map<String, String>
        primaryLocation, // { countryId, regionId?, cityId? }
    /// Alcance de acceso a activos. Default seguro: restricted sin asignaciones.
    @Default(MembershipScope()) MembershipScope scope,
    bool? isOwner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MembershipEntity;

  factory MembershipEntity.fromJson(Map<String, dynamic> json) =>
      _$MembershipEntityFromJson(json);
}
