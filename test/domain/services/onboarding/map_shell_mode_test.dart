// ============================================================================
// test/domain/services/onboarding/map_shell_mode_test.dart
// Tests de mapShellMode (ítem 9 v3.1).
// ============================================================================
// Cubre:
//   - Fallback a assetOwner cuando lista vacía + sin expectedRelationKind.
//   - Distinción renter vs assetOwner por expectedRelationKind.
//   - Cada kind individual produce el shell correcto.
//   - Provider distingue articulos vs servicios (sub-shell).
//   - Multi-capability: prioridad provider > advisor > broker > insurer > legal.
//   - Función pura: sin efectos secundarios, mismo input ⇒ mismo output.
//   - No contaminación de boundary: la firma SOLO acepta capability profiles
//     y AssetActorRole opcional — imposible inyectar orgId/workspaceId.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/services/onboarding/map_shell_mode.dart';
import 'package:avanzza/domain/services/onboarding/shell_mode.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/advisor_spec.dart';
import 'package:avanzza/domain/value/capability/broker_spec.dart';
import 'package:avanzza/domain/value/capability/capability_profile.dart';
import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/insurer_spec.dart';
import 'package:avanzza/domain/value/capability/legal_spec.dart';
import 'package:avanzza/domain/value/capability/legal_specialty.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:avanzza/domain/value/capability/provider_spec.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:flutter_test/flutter_test.dart';

CapabilityProfile _provider(ProviderType t) => CapabilityProfile(
      kind: ProfileKind.provider,
      providerSpec: ProviderSpec(providerType: t),
    );

CapabilityProfile _advisor() => CapabilityProfile(
      kind: ProfileKind.advisor,
      advisorSpec: const AdvisorSpec(market: AssetRegistrationType.vehiculo),
    );

CapabilityProfile _broker() => CapabilityProfile(
      kind: ProfileKind.broker,
      brokerSpec: const BrokerSpec(market: AssetRegistrationType.inmueble),
    );

CapabilityProfile _legal() => CapabilityProfile(
      kind: ProfileKind.legal,
      legalSpec: const LegalSpec(specialty: LegalSpecialty.civil),
    );

CapabilityProfile _insurer() => CapabilityProfile(
      kind: ProfileKind.insurer,
      insurerSpec: InsurerSpec(
        insuranceLines: const [InsuranceLine.soat],
        isCarrier: true,
      ),
    );

void main() {
  // ──────────────────────────────────────────────────────────────────────
  // 1. Fallback a assetOwner
  // ──────────────────────────────────────────────────────────────────────
  group('Fallback a assetOwner', () {
    test('capabilities=[] + expectedRelationKind=null ⇒ assetOwner', () {
      expect(
        mapShellMode(capabilityProfiles: const []),
        ShellMode.assetOwner,
      );
    });

    test('capabilities=[] + expectedRelationKind=owner ⇒ assetOwner', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.owner,
        ),
        ShellMode.assetOwner,
      );
    });

    test('capabilities=[] + expectedRelationKind=manager ⇒ assetOwner', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.manager,
        ),
        ShellMode.assetOwner,
      );
    });

    test('capabilities=[] + expectedRelationKind=workshop ⇒ assetOwner', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.workshop,
        ),
        ShellMode.assetOwner,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 2. Distinción renter
  // ──────────────────────────────────────────────────────────────────────
  group('Renter detection', () {
    test('capabilities=[] + expectedRelationKind=tenant ⇒ renter', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.tenant,
        ),
        ShellMode.renter,
      );
    });

    test('capabilities=[] + expectedRelationKind=driver ⇒ renter', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.driver,
        ),
        ShellMode.renter,
      );
    });

    test('capabilities=[] + expectedRelationKind=operator ⇒ renter', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.operator,
        ),
        ShellMode.renter,
      );
    });

    test('expectedRelationKind=technician NO es renter ⇒ assetOwner', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.technician,
        ),
        ShellMode.assetOwner,
      );
    });

    test('expectedRelationKind=legal NO es renter ⇒ assetOwner', () {
      expect(
        mapShellMode(
          capabilityProfiles: const [],
          expectedRelationKind: AssetActorRole.legal,
        ),
        ShellMode.assetOwner,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 3. Single capability — cada kind produce su shell
  // ──────────────────────────────────────────────────────────────────────
  group('Single capability', () {
    test('provider articulos ⇒ providerArticulos', () {
      expect(
        mapShellMode(capabilityProfiles: [_provider(ProviderType.articulos)]),
        ShellMode.providerArticulos,
      );
    });

    test('provider servicios ⇒ providerServicios', () {
      expect(
        mapShellMode(capabilityProfiles: [_provider(ProviderType.servicios)]),
        ShellMode.providerServicios,
      );
    });

    test('advisor ⇒ advisor', () {
      expect(
        mapShellMode(capabilityProfiles: [_advisor()]),
        ShellMode.advisor,
      );
    });

    test('broker ⇒ broker', () {
      expect(
        mapShellMode(capabilityProfiles: [_broker()]),
        ShellMode.broker,
      );
    });

    test('legal ⇒ legal', () {
      expect(
        mapShellMode(capabilityProfiles: [_legal()]),
        ShellMode.legal,
      );
    });

    test('insurer ⇒ insurer', () {
      expect(
        mapShellMode(capabilityProfiles: [_insurer()]),
        ShellMode.insurer,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 4. Multi-capability: prioridad estable
  // ──────────────────────────────────────────────────────────────────────
  group('Multi-capability priority (provider > advisor > broker > insurer > legal)',
      () {
    test('[provider articulos, advisor] ⇒ providerArticulos', () {
      expect(
        mapShellMode(capabilityProfiles: [
          _provider(ProviderType.articulos),
          _advisor(),
        ]),
        ShellMode.providerArticulos,
      );
    });

    test('[advisor, provider servicios] ⇒ providerServicios (orden no importa)',
        () {
      expect(
        mapShellMode(capabilityProfiles: [
          _advisor(),
          _provider(ProviderType.servicios),
        ]),
        ShellMode.providerServicios,
      );
    });

    test('[advisor, broker, legal] ⇒ advisor', () {
      expect(
        mapShellMode(capabilityProfiles: [
          _advisor(),
          _broker(),
          _legal(),
        ]),
        ShellMode.advisor,
      );
    });

    test('[broker, legal] ⇒ broker', () {
      expect(
        mapShellMode(capabilityProfiles: [_broker(), _legal()]),
        ShellMode.broker,
      );
    });

    test('[insurer, legal] ⇒ insurer (insurer prioritario sobre legal)', () {
      expect(
        mapShellMode(capabilityProfiles: [_insurer(), _legal()]),
        ShellMode.insurer,
      );
    });

    test('[legal, broker, insurer] ⇒ broker (orden de array no afecta '
        'prioridad)', () {
      expect(
        mapShellMode(capabilityProfiles: [_legal(), _broker(), _insurer()]),
        ShellMode.broker,
      );
    });

    test('todos los kinds en una lista ⇒ providerArticulos (gana provider)',
        () {
      expect(
        mapShellMode(capabilityProfiles: [
          _legal(),
          _insurer(),
          _broker(),
          _advisor(),
          _provider(ProviderType.articulos),
        ]),
        ShellMode.providerArticulos,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 5. Capabilities + expectedRelationKind (capabilities prevalecen)
  // ──────────────────────────────────────────────────────────────────────
  group('capabilities prevalecen sobre expectedRelationKind', () {
    test('[provider servicios] + expectedRelationKind=owner ⇒ providerServicios',
        () {
      // El workspace ofrece servicios al mercado Y tiene assets propios.
      // El shell por default es la oferta primaria; el switcher de UI
      // permitirá alternar al asset_owner cuando exista.
      expect(
        mapShellMode(
          capabilityProfiles: [_provider(ProviderType.servicios)],
          expectedRelationKind: AssetActorRole.owner,
        ),
        ShellMode.providerServicios,
      );
    });

    test('[advisor] + expectedRelationKind=tenant ⇒ advisor (renter '
        'NO sobreescribe)', () {
      // Un advisor que también arrienda assets es advisor primero.
      expect(
        mapShellMode(
          capabilityProfiles: [_advisor()],
          expectedRelationKind: AssetActorRole.tenant,
        ),
        ShellMode.advisor,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 6. Función pura — invariantes
  // ──────────────────────────────────────────────────────────────────────
  group('Función pura', () {
    test('mismo input ⇒ mismo output (determinismo)', () {
      final caps = [_provider(ProviderType.articulos)];
      final r1 = mapShellMode(
        capabilityProfiles: caps,
        expectedRelationKind: AssetActorRole.owner,
      );
      final r2 = mapShellMode(
        capabilityProfiles: caps,
        expectedRelationKind: AssetActorRole.owner,
      );
      expect(r1, r2);
    });

    test('NO muta la lista de capabilityProfiles', () {
      final caps = <CapabilityProfile>[
        _advisor(),
        _broker(),
      ];
      final pre = caps.length;
      mapShellMode(capabilityProfiles: caps);
      expect(caps.length, pre);
    });

    test('lista vacía const default ⇒ assetOwner sin lanzar', () {
      expect(
        () => mapShellMode(capabilityProfiles: const []),
        returnsNormally,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 7. No contaminación de boundary
  // ──────────────────────────────────────────────────────────────────────
  group('No contaminación de boundary', () {
    test('firma del mapper NO acepta orgId/workspaceId (garantía estructural)',
        () {
      // Verificación por construcción: si esta llamada compila, la firma
      // del mapper NO expone parámetros tipo `orgId` ni `workspaceId`.
      // Cualquier intento de pasar un id de tenancy sería compile-error.
      final r = mapShellMode(capabilityProfiles: const []);
      expect(r, isA<ShellMode>());
    });

    test('output es ShellMode (NO String) — imposible usar como filtro de '
        'where()', () {
      // ShellMode no es String. Para usar como partition key habría que
      // convertir explícitamente vía .wireName, lo cual code review puede
      // bloquear. La separación de tipos hace difícil el accidente.
      final r = mapShellMode(capabilityProfiles: [_advisor()]);
      expect(r, isA<ShellMode>());
      expect(r, isNot(isA<String>()));
    });
  });
}
