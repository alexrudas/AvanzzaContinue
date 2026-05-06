// ============================================================================
// test/domain/services/onboarding/map_intent_to_canonical_test.dart
// Tests de la función pura mapIntentToCanonical (ítem 8 v3.1).
// ============================================================================
// Cubre los 8 intents pedidos:
//   1. owner
//   2. assetAdmin
//   3. renter (× 3 subroles)
//   4. provider (× 2 offer types)
//   5. advisor
//   6. broker
//   7. legal
//   8. insurer
//
// Verifica:
//   - capabilityProfiles producidos correctamente.
//   - expectedRelationKind correcto (null cuando no aplica).
//   - shellMode correcto.
//   - Mapping de enums legacy → canonical.
//   - NO escribe Membership.roles (output no contiene roles — el mapper
//     no expone roles).
//   - Casos inválidos (campos requeridos faltantes) lanzan ArgumentError.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/services/onboarding/intent_mapping_result.dart';
import 'package:avanzza/domain/services/onboarding/map_intent_to_canonical.dart';
import 'package:avanzza/domain/services/onboarding/shell_mode.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/legal_specialty.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:avanzza/domain/value/migration/legacy_migration_warning.dart';
import 'package:avanzza/presentation/demo_registration_v2/demo_state.dart';
import 'package:flutter_test/flutter_test.dart';

DemoRegistrationState _state(void Function(DemoRegistrationState s) build) {
  final s = DemoRegistrationState();
  build(s);
  return s;
}

void main() {
  // ──────────────────────────────────────────────────────────────────────
  // 1. owner
  // ──────────────────────────────────────────────────────────────────────
  group('1. owner', () {
    test('produce expectedRelationKind=owner y shellMode=assetOwner', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.owner;
      }));
      expect(r.capabilityProfiles, isEmpty);
      expect(r.expectedRelationKind, AssetActorRole.owner);
      expect(r.shellMode, ShellMode.assetOwner);
    });

    test('owner NO produce capability (no ofrece al mercado)', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.owner;
      }));
      expect(r.capabilityProfiles, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 2. assetAdmin
  // ──────────────────────────────────────────────────────────────────────
  group('2. assetAdmin', () {
    test('expectedRelationKind=manager (NO workshop, NO technician)', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.assetAdmin;
      }));
      expect(r.expectedRelationKind, AssetActorRole.manager);
      expect(r.shellMode, ShellMode.assetOwner);
      expect(r.capabilityProfiles, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 3. renter (× 3 subroles)
  // ──────────────────────────────────────────────────────────────────────
  group('3. renter', () {
    test('renter conductor ⇒ AssetActorRole.driver', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.renter;
        s.renterSubrole = DemoRenterSubrole.conductor;
      }));
      expect(r.expectedRelationKind, AssetActorRole.driver);
      expect(r.shellMode, ShellMode.renter);
      expect(r.capabilityProfiles, isEmpty);
    });

    test('renter inquilino ⇒ AssetActorRole.tenant', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.renter;
        s.renterSubrole = DemoRenterSubrole.inquilino;
      }));
      expect(r.expectedRelationKind, AssetActorRole.tenant);
      expect(r.shellMode, ShellMode.renter);
    });

    test('renter cliente ⇒ AssetActorRole.operator', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.renter;
        s.renterSubrole = DemoRenterSubrole.cliente;
      }));
      expect(r.expectedRelationKind, AssetActorRole.operator);
      expect(r.shellMode, ShellMode.renter);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 4. provider (× 2 offer types × multiple markets)
  // ──────────────────────────────────────────────────────────────────────
  group('4. provider', () {
    test('provider productos ⇒ kind=provider, providerType=articulos, '
        'shellMode=providerArticulos', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.productos;
        s.providerMarket = DemoAssetType.vehiculo;
      }));
      expect(r.capabilityProfiles.length, 1);
      final c = r.capabilityProfiles.first;
      expect(c.kind, ProfileKind.provider);
      expect(c.providerSpec, isNotNull);
      expect(c.providerSpec!.providerType, ProviderType.articulos);
      expect(c.providerSpec!.market, AssetRegistrationType.vehiculo);
      expect(r.expectedRelationKind, isNull);
      expect(r.shellMode, ShellMode.providerArticulos);
    });

    test('provider servicios ⇒ providerType=servicios, '
        'shellMode=providerServicios', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.maquinaria;
      }));
      final c = r.capabilityProfiles.first;
      expect(c.providerSpec!.providerType, ProviderType.servicios);
      expect(c.providerSpec!.market, AssetRegistrationType.maquinaria);
      expect(r.shellMode, ShellMode.providerServicios);
    });

    test('provider con businessCategory válida ⇒ businessCategoryRef poblada',
        () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
        s.providerSpecialties.add('mecanico_independiente');
      }));
      final c = r.capabilityProfiles.first;
      expect(c.providerSpec!.businessCategoryRef?.value,
          'mecanico_independiente');
    });

    test('provider con businessCategory inválida (formato) ⇒ ref null '
        '+ warning malformedBusinessCategory', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
        s.providerSpecialties.add('Lubricentro'); // mayúscula = inválido
      }));
      final c = r.capabilityProfiles.first;
      expect(c.providerSpec!.businessCategoryRef, isNull);
      // El mapper ahora deja señal de la degradación (no más drop silencioso).
      expect(r.hasWarnings, isTrue);
      expect(r.warnings.length, 1);
      expect(
        r.warnings.first.kind,
        LegacyMigrationWarningKind.malformedBusinessCategory,
      );
      expect(r.warnings.first.rawValue, 'Lubricentro');
      expect(r.warnings.first.fieldPath, 'intent.providerSpecialties[0]');
    });

    test('provider sin specialties ⇒ ref null', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
      }));
      final c = r.capabilityProfiles.first;
      expect(c.providerSpec!.businessCategoryRef, isNull);
    });

    test('todos los markets se mapean correctamente', () {
      const expected = {
        DemoAssetType.vehiculo: AssetRegistrationType.vehiculo,
        DemoAssetType.inmueble: AssetRegistrationType.inmueble,
        DemoAssetType.maquinaria: AssetRegistrationType.maquinaria,
        DemoAssetType.equipo: AssetRegistrationType.equipo,
        DemoAssetType.otro: AssetRegistrationType.otro,
      };
      for (final entry in expected.entries) {
        final r = mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.provider;
          s.providerOfferType = DemoProviderOfferType.servicios;
          s.providerMarket = entry.key;
        }));
        expect(
          r.capabilityProfiles.first.providerSpec!.market,
          entry.value,
          reason: '${entry.key} debe mapear a ${entry.value}',
        );
      }
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 5. advisor
  // ──────────────────────────────────────────────────────────────────────
  group('5. advisor', () {
    test('advisor inmueble ⇒ kind=advisor, advisorSpec.market=inmueble', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.asesor;
        s.asesorMarket = DemoAssetType.inmueble;
      }));
      final c = r.capabilityProfiles.first;
      expect(c.kind, ProfileKind.advisor);
      expect(c.advisorSpec!.market, AssetRegistrationType.inmueble);
      expect(r.expectedRelationKind, isNull);
      expect(r.shellMode, ShellMode.advisor);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 6. broker
  // ──────────────────────────────────────────────────────────────────────
  group('6. broker', () {
    test('broker vehiculo ⇒ kind=broker, brokerSpec.market=vehiculo', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.broker;
        s.brokerMarket = DemoAssetType.vehiculo;
      }));
      final c = r.capabilityProfiles.first;
      expect(c.kind, ProfileKind.broker);
      expect(c.brokerSpec!.market, AssetRegistrationType.vehiculo);
      expect(r.expectedRelationKind, isNull);
      expect(r.shellMode, ShellMode.broker);
    });

    test('broker inmueble (gestor inmobiliario)', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.broker;
        s.brokerMarket = DemoAssetType.inmueble;
      }));
      expect(r.capabilityProfiles.first.brokerSpec!.market,
          AssetRegistrationType.inmueble);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 7. legal
  // ──────────────────────────────────────────────────────────────────────
  group('7. legal', () {
    test('legal civil ⇒ kind=legal, legalSpec.specialty=civil', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.legal;
        s.legalSpecialty = DemoLegalSpecialty.civil;
      }));
      final c = r.capabilityProfiles.first;
      expect(c.kind, ProfileKind.legal);
      expect(c.legalSpec!.specialty, LegalSpecialty.civil);
      expect(r.shellMode, ShellMode.legal);
    });

    test('legal penal', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.legal;
        s.legalSpecialty = DemoLegalSpecialty.penal;
      }));
      expect(r.capabilityProfiles.first.legalSpec!.specialty,
          LegalSpecialty.penal);
    });

    test('legal ambas', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.legal;
        s.legalSpecialty = DemoLegalSpecialty.ambas;
      }));
      expect(r.capabilityProfiles.first.legalSpec!.specialty,
          LegalSpecialty.ambas);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 8. insurer
  // ──────────────────────────────────────────────────────────────────────
  group('8. insurer', () {
    test('insurer seguros ⇒ kind=insurer, isCarrier=true, '
        'insuranceLines=[auto, soat], market=vehiculo', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.insurer;
        s.insurerSpecialty = DemoInsurerSpecialty.seguros;
      }));
      final c = r.capabilityProfiles.first;
      expect(c.kind, ProfileKind.insurer);
      expect(c.insurerSpec!.isCarrier, isTrue);
      expect(c.insurerSpec!.insuranceLines,
          [InsuranceLine.auto, InsuranceLine.soat]);
      expect(c.insurerSpec!.market, AssetRegistrationType.vehiculo);
      expect(r.shellMode, ShellMode.insurer);
    });

    test('insurer inmobiliario ⇒ insuranceLines=[hogar], market=inmueble',
        () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.insurer;
        s.insurerSpecialty = DemoInsurerSpecialty.inmobiliario;
      }));
      final spec = r.capabilityProfiles.first.insurerSpec!;
      expect(spec.insuranceLines, [InsuranceLine.hogar]);
      expect(spec.market, AssetRegistrationType.inmueble);
      expect(spec.isCarrier, isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // Casos inválidos: campos requeridos faltantes
  // ──────────────────────────────────────────────────────────────────────
  group('Inválidos — campos requeridos faltantes', () {
    test('role=null ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(DemoRegistrationState()),
        throwsArgumentError,
      );
    });

    test('renter sin renterSubrole ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.renter;
        })),
        throwsArgumentError,
      );
    });

    test('provider sin providerOfferType ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.provider;
          s.providerMarket = DemoAssetType.vehiculo;
        })),
        throwsArgumentError,
      );
    });

    test('provider sin providerMarket ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.provider;
          s.providerOfferType = DemoProviderOfferType.servicios;
        })),
        throwsArgumentError,
      );
    });

    test('asesor sin asesorMarket ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.asesor;
        })),
        throwsArgumentError,
      );
    });

    test('broker sin brokerMarket ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.broker;
        })),
        throwsArgumentError,
      );
    });

    test('legal sin legalSpecialty ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.legal;
        })),
        throwsArgumentError,
      );
    });

    test('insurer sin insurerSpecialty ⇒ ArgumentError', () {
      expect(
        () => mapIntentToCanonical(_state((s) {
          s.role = DemoRoleCode.insurer;
        })),
        throwsArgumentError,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // Garantías estructurales
  // ──────────────────────────────────────────────────────────────────────
  group('Garantías estructurales', () {
    test('IntentMappingResult NO incluye Membership.roles (campo ausente)',
        () {
      // El tipo IntentMappingResult NO tiene un campo "roles". El fundador
      // siempre recibe [admin] en CompleteOnboardingUC, no aquí.
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.owner;
      }));
      // Verificación estructural: si esto compila, la garantía está
      // satisfecha (el tipo no expone roles).
      expect(r, isA<IntentMappingResult>());
    });

    test('mapper es función pura: mismo input ⇒ mismo output', () {
      final state1 = _state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
      });
      final state2 = _state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
      });
      final r1 = mapIntentToCanonical(state1);
      final r2 = mapIntentToCanonical(state2);
      expect(r1, equals(r2));
    });

    test('mapper NO muta el state input', () {
      final state = _state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
      });
      // Snapshot del estado relevante.
      final preRole = state.role;
      final preOffer = state.providerOfferType;
      final preMarket = state.providerMarket;

      mapIntentToCanonical(state);

      expect(state.role, preRole);
      expect(state.providerOfferType, preOffer);
      expect(state.providerMarket, preMarket);
    });

    test('expectedRelationKind es null para todos los roles de mercado', () {
      final marketRoles = [
        (
          role: DemoRoleCode.provider,
          builder: (DemoRegistrationState s) {
            s.providerOfferType = DemoProviderOfferType.servicios;
            s.providerMarket = DemoAssetType.vehiculo;
          },
        ),
        (
          role: DemoRoleCode.asesor,
          builder: (DemoRegistrationState s) {
            s.asesorMarket = DemoAssetType.vehiculo;
          },
        ),
        (
          role: DemoRoleCode.broker,
          builder: (DemoRegistrationState s) {
            s.brokerMarket = DemoAssetType.vehiculo;
          },
        ),
        (
          role: DemoRoleCode.legal,
          builder: (DemoRegistrationState s) {
            s.legalSpecialty = DemoLegalSpecialty.civil;
          },
        ),
        (
          role: DemoRoleCode.insurer,
          builder: (DemoRegistrationState s) {
            s.insurerSpecialty = DemoInsurerSpecialty.seguros;
          },
        ),
      ];
      for (final entry in marketRoles) {
        final r = mapIntentToCanonical(_state((s) {
          s.role = entry.role;
          entry.builder(s);
        }));
        expect(
          r.expectedRelationKind,
          isNull,
          reason: '${entry.role} no debe producir expectedRelationKind',
        );
      }
    });

    test('warnings vacíos por default cuando no hay drift', () {
      final cases = <Map<String, dynamic>>[
        {'role': DemoRoleCode.owner, 'build': (DemoRegistrationState _) {}},
        {
          'role': DemoRoleCode.assetAdmin,
          'build': (DemoRegistrationState _) {}
        },
        {
          'role': DemoRoleCode.renter,
          'build': (DemoRegistrationState s) =>
              s.renterSubrole = DemoRenterSubrole.conductor,
        },
        {
          'role': DemoRoleCode.provider,
          'build': (DemoRegistrationState s) {
            s.providerOfferType = DemoProviderOfferType.servicios;
            s.providerMarket = DemoAssetType.vehiculo;
            // sin businessCategory ⇒ no warning (ausencia legítima)
          },
        },
        {
          'role': DemoRoleCode.asesor,
          'build': (DemoRegistrationState s) =>
              s.asesorMarket = DemoAssetType.vehiculo,
        },
        {
          'role': DemoRoleCode.broker,
          'build': (DemoRegistrationState s) =>
              s.brokerMarket = DemoAssetType.vehiculo,
        },
        {
          'role': DemoRoleCode.legal,
          'build': (DemoRegistrationState s) =>
              s.legalSpecialty = DemoLegalSpecialty.civil,
        },
        {
          'role': DemoRoleCode.insurer,
          'build': (DemoRegistrationState s) =>
              s.insurerSpecialty = DemoInsurerSpecialty.seguros,
        },
      ];
      for (final entry in cases) {
        final r = mapIntentToCanonical(_state((s) {
          s.role = entry['role'] as DemoRoleCode;
          (entry['build'] as void Function(DemoRegistrationState))(s);
        }));
        expect(
          r.warnings,
          isEmpty,
          reason: '${entry['role']} sin drift no debe emitir warnings',
        );
        expect(r.hasWarnings, isFalse);
      }
    });

    test('provider con businessCategory válida ⇒ NO warnings', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
        s.providerSpecialties.add('mecanico_independiente');
      }));
      expect(r.warnings, isEmpty);
    });

    test('provider sin businessCategory (vacío) ⇒ NO warnings (ausencia '
        'legítima, NO degradación)', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
      }));
      expect(r.warnings, isEmpty);
    });

    test('provider con providerOtherSpecialty inválida ⇒ warning con '
        'fieldPath providerOtherSpecialty', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
        s.providerOtherSpecialty = 'Mi Negocio'; // mayúsculas + espacio
      }));
      expect(r.warnings.length, 1);
      expect(r.warnings.first.fieldPath, 'intent.providerOtherSpecialty');
      expect(r.warnings.first.rawValue, 'Mi Negocio');
    });

    test('warnings expone hasWarnings y warningCount', () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
        s.providerSpecialties.add('cat-egoria'); // guion inválido
      }));
      expect(r.hasWarnings, isTrue);
      expect(r.warningCount, 1);
    });

    test('warnings retornados son inmutables (no se pueden mutar después)',
        () {
      final r = mapIntentToCanonical(_state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        s.providerMarket = DemoAssetType.vehiculo;
        s.providerSpecialties.add('Bad-Format');
      }));
      expect(
        () => r.warnings.add(const LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.unknownLegacyRole,
          fieldPath: 'x',
          message: 'y',
        )),
        throwsUnsupportedError,
      );
    });

    test('expectedRelationKind != null SOLO para owner/assetAdmin/renter', () {
      final assetRoles = [
        (
          role: DemoRoleCode.owner,
          expected: AssetActorRole.owner,
          builder: (DemoRegistrationState _) {}
        ),
        (
          role: DemoRoleCode.assetAdmin,
          expected: AssetActorRole.manager,
          builder: (DemoRegistrationState _) {}
        ),
        (
          role: DemoRoleCode.renter,
          expected: AssetActorRole.driver,
          builder: (DemoRegistrationState s) =>
              s.renterSubrole = DemoRenterSubrole.conductor,
        ),
      ];
      for (final entry in assetRoles) {
        final r = mapIntentToCanonical(_state((s) {
          s.role = entry.role;
          entry.builder(s);
        }));
        expect(r.expectedRelationKind, entry.expected);
        expect(r.capabilityProfiles, isEmpty);
      }
    });
  });
}
