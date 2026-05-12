// ============================================================================
// lib/domain/repositories/provider/provider_self_repository.dart
// PROVIDER SELF REPOSITORY — interfaz mínima para MF1 (bootstrap + me).
//
// QUÉ HACE:
//   Contrato del flujo "self-onboarding" del proveedor:
//     - bootstrap(...): un user convierte su workspace en provider.
//     - me(): vista agregada del estado del provider del user en el
//             workspace activo.
//
// QUÉ NO HACE:
//   - NO incluye agent invitations / claim / local provider — esos
//     contratos viven en interfaces dedicadas (futuras MF).
//   - NO maneja activeOrgId: el repo lo deduce del Bearer + interceptor
//     `_CoreBearerInterceptor` en coreDio.
// ============================================================================

import '../../entities/provider/bootstrap_provider_result_entity.dart';
import '../../entities/provider/provider_me_entity.dart';

abstract class ProviderSelfRepository {
  /// POST /v1/providers/bootstrap.
  ///
  /// Crea (o reactiva) el ProviderProfile SELF del caller en su workspace
  /// activo. Recibe automáticamente `provider_admin_role` con las
  /// capabilities admin (invite/revoke/agent_invitation.read/read).
  ///
  /// Mutually exclusive: si el caller ya tiene un ProviderProfile ACTIVE
  /// en el workspace, el backend responde 409
  /// `PROVIDER_ALREADY_BOOTSTRAPPED` y la UI debe redirigir a `/provider/me`.
  ///
  /// [name]            — display name del actor canónico (PlatformActor).
  /// [phone]           — opcional. Solo se persiste como User.phoneE164
  ///                      si aún no estaba seteado (idempotente, defensivo).
  /// [specialtyIds]    — al menos una. Validadas contra catálogo backend.
  /// [assetTypeIds]    — opcional. Si vienen, deben ser compatibles con
  ///                      al menos una de las specialties (vía SpecialtyAssetType).
  Future<BootstrapProviderResultEntity> bootstrap({
    required String name,
    String? phone,
    required List<String> specialtyIds,
    List<String>? assetTypeIds,
  });

  /// GET /v1/providers/me.
  ///
  /// Vista agregada self del proveedor para el workspace activo:
  /// `isProvider`, `providerProfile`, `specialties`, `assetTypes`,
  /// `capabilities`. Si el user todavía no es provider, devuelve
  /// `isProvider=false` con `providerProfile=null` (NO lanza).
  Future<ProviderMeEntity> me();
}
