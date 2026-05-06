// ============================================================================
// lib/domain/services/onboarding/map_intent_to_canonical.dart
// mapIntentToCanonical — función pura: DemoRegistrationState → IntentMappingResult.
// ============================================================================
// QUÉ HACE:
//   - Convierte el intent capturado en Q3/Q4 del onboarding (legacy demo
//     state) hacia los 3 outputs canónicos del dominio v3.1:
//       · capabilityProfiles  → oferta del workspace al mercado.
//       · expectedRelationKind → intent de relación con activos.
//       · shellMode            → UI shell runtime.
//   - Validación estricta: si el role declarado requiere campos del state
//     que están ausentes (ej. provider sin providerOfferType), throw
//     ArgumentError con mensaje específico. Es función pura — el caller
//     upstream debe validar antes.
//
// QUÉ NO HACE:
//   - NO escribe Membership.roles (eso es CompleteOnboardingUC: el fundador
//     siempre recibe `[admin]`).
//   - NO escribe Organization.tipo (eso es CompleteOnboardingUC: derivado
//     exclusivamente de Q4.titularType).
//   - NO toca Portfolio ni AssetActorLink directamente. El
//     expectedRelationKind se persiste en Portfolio en otra capa.
//   - NO persiste, NO navega, NO emite telemetría. Pure function.
//
// MAPPING (Q3 → outputs):
//
//   role=owner       → capabilityProfiles=[],
//                      expectedRelationKind=AssetActorRole.owner,
//                      shellMode=ShellMode.assetOwner
//
//   role=assetAdmin  → capabilityProfiles=[],
//                      expectedRelationKind=AssetActorRole.manager,
//                      shellMode=ShellMode.assetOwner
//
//   role=renter      → capabilityProfiles=[],
//                      expectedRelationKind=
//                        renterSubrole.conductor → AssetActorRole.driver
//                        renterSubrole.inquilino → AssetActorRole.tenant
//                        renterSubrole.cliente   → AssetActorRole.operator,
//                      shellMode=ShellMode.renter
//
//   role=provider    → capabilityProfiles=[CapabilityProfile{
//                        kind: provider,
//                        providerSpec: { providerType, market, businessCategoryRef? }
//                      }],
//                      expectedRelationKind=null,
//                      shellMode=
//                        providerOfferType.productos → ShellMode.providerArticulos
//                        providerOfferType.servicios → ShellMode.providerServicios
//
//   role=asesor      → capabilityProfiles=[CapabilityProfile{
//                        kind: advisor,
//                        advisorSpec: { market }
//                      }],
//                      expectedRelationKind=null,
//                      shellMode=ShellMode.advisor
//
//   role=broker      → capabilityProfiles=[CapabilityProfile{
//                        kind: broker,
//                        brokerSpec: { market }
//                      }],
//                      expectedRelationKind=null,
//                      shellMode=ShellMode.broker
//
//   role=legal       → capabilityProfiles=[CapabilityProfile{
//                        kind: legal,
//                        legalSpec: { specialty }
//                      }],
//                      expectedRelationKind=null,
//                      shellMode=ShellMode.legal
//
//   role=insurer     → capabilityProfiles=[CapabilityProfile{
//                        kind: insurer,
//                        insurerSpec: { insuranceLines, isCarrier:true, market }
//                      }],
//                      expectedRelationKind=null,
//                      shellMode=ShellMode.insurer
// ============================================================================

import '../../../presentation/demo_registration_v2/demo_state.dart';
import '../../entities/core_common/value_objects/asset_actor_role.dart';
import '../../shared/enums/asset_type.dart';
import '../../value/capability/advisor_spec.dart';
import '../../value/capability/broker_spec.dart';
import '../../value/capability/capability_profile.dart';
import '../../value/capability/insurance_line.dart';
import '../../value/capability/insurer_spec.dart';
import '../../value/capability/legal_spec.dart';
import '../../value/capability/legal_specialty.dart';
import '../../value/capability/profile_kind.dart';
import '../../value/capability/provider_spec.dart';
import '../../value/capability/provider_type.dart';
import '../../value/capability/refs/business_category_ref.dart';
import '../../value/migration/legacy_migration_warning.dart';
import 'intent_mapping_result.dart';
import 'shell_mode.dart';

/// Mapea el intent capturado en Q3/Q4 hacia los outputs canónicos v3.1.
///
/// Throws [ArgumentError] cuando:
/// - `state.role` es null.
/// - El role requiere un sub-campo y éste falta (ej. provider sin
///   providerOfferType, renter sin renterSubrole, legal sin legalSpecialty).
IntentMappingResult mapIntentToCanonical(DemoRegistrationState state) {
  final role = state.role;
  if (role == null) {
    throw ArgumentError(
      'mapIntentToCanonical: state.role es null. '
      'Q3 debe haberse completado antes de invocar el mapper.',
    );
  }

  switch (role) {
    case DemoRoleCode.owner:
      return const IntentMappingResult(
        capabilityProfiles: [],
        expectedRelationKind: AssetActorRole.owner,
        shellMode: ShellMode.assetOwner,
      );

    case DemoRoleCode.assetAdmin:
      return const IntentMappingResult(
        capabilityProfiles: [],
        expectedRelationKind: AssetActorRole.manager,
        shellMode: ShellMode.assetOwner,
      );

    case DemoRoleCode.renter:
      final subrole = state.renterSubrole;
      if (subrole == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=renter requiere renterSubrole '
          '(conductor | inquilino | cliente).',
        );
      }
      return IntentMappingResult(
        capabilityProfiles: const [],
        expectedRelationKind: _mapRenterSubrole(subrole),
        shellMode: ShellMode.renter,
      );

    case DemoRoleCode.provider:
      final offer = state.providerOfferType;
      if (offer == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=provider requiere providerOfferType '
          '(productos | servicios).',
        );
      }
      final market = state.providerMarket;
      if (market == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=provider requiere providerMarket.',
        );
      }
      final warnings = <LegacyMigrationWarning>[];
      final categoryRef = _firstBusinessCategory(state, warnings);
      final providerSpec = ProviderSpec(
        providerType: _mapProviderOfferType(offer),
        market: _mapAssetType(market),
        businessCategoryRef: categoryRef,
      );
      final capability = CapabilityProfile(
        kind: ProfileKind.provider,
        providerSpec: providerSpec,
      );
      return IntentMappingResult(
        capabilityProfiles: [capability],
        expectedRelationKind: null,
        shellMode: offer == DemoProviderOfferType.productos
            ? ShellMode.providerArticulos
            : ShellMode.providerServicios,
        warnings: List.unmodifiable(warnings),
      );

    case DemoRoleCode.asesor:
      final market = state.asesorMarket;
      if (market == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=asesor requiere asesorMarket.',
        );
      }
      final capability = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: AdvisorSpec(market: _mapAssetType(market)),
      );
      return IntentMappingResult(
        capabilityProfiles: [capability],
        expectedRelationKind: null,
        shellMode: ShellMode.advisor,
      );

    case DemoRoleCode.broker:
      final market = state.brokerMarket;
      if (market == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=broker requiere brokerMarket.',
        );
      }
      final capability = CapabilityProfile(
        kind: ProfileKind.broker,
        brokerSpec: BrokerSpec(market: _mapAssetType(market)),
      );
      return IntentMappingResult(
        capabilityProfiles: [capability],
        expectedRelationKind: null,
        shellMode: ShellMode.broker,
      );

    case DemoRoleCode.legal:
      final specialty = state.legalSpecialty;
      if (specialty == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=legal requiere legalSpecialty '
          '(civil | penal | ambas).',
        );
      }
      final capability = CapabilityProfile(
        kind: ProfileKind.legal,
        legalSpec: LegalSpec(specialty: _mapLegalSpecialty(specialty)),
      );
      return IntentMappingResult(
        capabilityProfiles: [capability],
        expectedRelationKind: null,
        shellMode: ShellMode.legal,
      );

    case DemoRoleCode.insurer:
      final specialty = state.insurerSpecialty;
      if (specialty == null) {
        throw ArgumentError(
          'mapIntentToCanonical: role=insurer requiere insurerSpecialty '
          '(seguros | inmobiliario).',
        );
      }
      final spec = _buildInsurerSpec(specialty);
      final capability = CapabilityProfile(
        kind: ProfileKind.insurer,
        insurerSpec: spec,
      );
      return IntentMappingResult(
        capabilityProfiles: [capability],
        expectedRelationKind: null,
        shellMode: ShellMode.insurer,
      );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS DE MAPEO (privados)
// ─────────────────────────────────────────────────────────────────────────────

AssetRegistrationType _mapAssetType(DemoAssetType t) {
  switch (t) {
    case DemoAssetType.vehiculo:
      return AssetRegistrationType.vehiculo;
    case DemoAssetType.inmueble:
      return AssetRegistrationType.inmueble;
    case DemoAssetType.maquinaria:
      return AssetRegistrationType.maquinaria;
    case DemoAssetType.equipo:
      return AssetRegistrationType.equipo;
    case DemoAssetType.otro:
      return AssetRegistrationType.otro;
  }
}

ProviderType _mapProviderOfferType(DemoProviderOfferType t) {
  switch (t) {
    case DemoProviderOfferType.productos:
      return ProviderType.articulos;
    case DemoProviderOfferType.servicios:
      return ProviderType.servicios;
  }
}

AssetActorRole _mapRenterSubrole(DemoRenterSubrole s) {
  switch (s) {
    case DemoRenterSubrole.conductor:
      return AssetActorRole.driver;
    case DemoRenterSubrole.inquilino:
      return AssetActorRole.tenant;
    case DemoRenterSubrole.cliente:
      return AssetActorRole.operator;
  }
}

LegalSpecialty _mapLegalSpecialty(DemoLegalSpecialty s) {
  switch (s) {
    case DemoLegalSpecialty.civil:
      return LegalSpecialty.civil;
    case DemoLegalSpecialty.penal:
      return LegalSpecialty.penal;
    case DemoLegalSpecialty.ambas:
      return LegalSpecialty.ambas;
  }
}

/// Construye un [InsurerSpec] mínimo a partir del specialty del demo
/// state. El demo capture es coarse (seguros vs inmobiliario); el InsurerSpec
/// derivado usa defaults sensatos que el operator afinará después.
///
/// - seguros      → insuranceLines:[auto, soat], market:vehiculo,    isCarrier:true
/// - inmobiliario → insuranceLines:[hogar],     market:inmueble,     isCarrier:true
///
/// `isCarrier:true` por contrato de la frontera v3.1: kind=insurer aplica
/// solo a aseguradoras emisoras. Corredores de seguros usan kind=broker
/// con brokerSpec.market='vehiculo'/'inmueble'.
InsurerSpec _buildInsurerSpec(DemoInsurerSpecialty specialty) {
  switch (specialty) {
    case DemoInsurerSpecialty.seguros:
      return InsurerSpec(
        insuranceLines: const [InsuranceLine.auto, InsuranceLine.soat],
        isCarrier: true,
        market: AssetRegistrationType.vehiculo,
      );
    case DemoInsurerSpecialty.inmobiliario:
      return InsurerSpec(
        insuranceLines: const [InsuranceLine.hogar],
        isCarrier: true,
        market: AssetRegistrationType.inmueble,
      );
  }
}

/// Toma la primera business category del state demo y la parsea como
/// [BusinessCategoryRef]. Política:
/// - Sin candidato (vacío / whitespace) ⇒ retorna null SIN warning
///   (ausencia legítima — el demo flow no exigió categoría).
/// - Candidato presente pero formato inválido ⇒ retorna null CON warning
///   `malformedBusinessCategory`. El caller (CompleteOnboardingUC) decide
///   si emite telemetría con el warning o lo persiste para auditoría.
///
/// El fieldPath del warning distingue el origen (set vs string libre),
/// para diagnóstico downstream.
BusinessCategoryRef? _firstBusinessCategory(
  DemoRegistrationState state,
  List<LegacyMigrationWarning> sink,
) {
  final fromSet = state.providerSpecialties.isNotEmpty;
  final candidate = fromSet
      ? state.providerSpecialties.first
      : state.providerOtherSpecialty;
  if (candidate.trim().isEmpty) return null;
  final ref = BusinessCategoryRef.tryParse(candidate);
  if (ref == null) {
    sink.add(LegacyMigrationWarning(
      kind: LegacyMigrationWarningKind.malformedBusinessCategory,
      fieldPath: fromSet
          ? 'intent.providerSpecialties[0]'
          : 'intent.providerOtherSpecialty',
      rawValue: candidate,
      message:
          'businessCategoryId no cumple sintaxis snake_case ASCII '
          '(letras minúsculas + dígitos + "_", debe empezar por letra); '
          'campo descartado al construir BusinessCategoryRef',
    ));
  }
  return ref;
}
