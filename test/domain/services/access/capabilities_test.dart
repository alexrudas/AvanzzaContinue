// ============================================================================
// test/domain/services/access/capabilities_test.dart
//
// QUÉ HACE:
// - Verifica que el catálogo `Capabilities` exponga los ids semánticos
//   wire-stable que Core API emite (no se renombren accidentalmente).
// - Smoke-tests del helper `Capabilities.has/hasAny/hasAll` sobre un
//   `SessionCapabilitiesStore`.
//
// QUÉ NO HACE:
// - No prueba el flujo HTTP de AccessGateway (eso vive en otro test).
// - No prueba persistencia (capabilities no se guardan a disco).
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/application/services/access/session_capabilities_store.dart';
import 'package:avanzza/domain/services/access/capabilities.dart';

void main() {
  group('Capabilities — wire-stable ids', () {
    test('default capabilities tienen los ids exactos del Core API', () {
      // Estos strings DEBEN coincidir literalmente con
      // BOOTSTRAP_DEFAULT_CAPABILITIES de auth-bootstrap.service.ts.
      expect(Capabilities.vehicleBatchCircuitRead,
          equals('vehicle_batch.circuit.read'));
      expect(Capabilities.purchaseRequestRead, equals('purchase_request.read'));
      expect(
          Capabilities.purchaseRequestCreate, equals('purchase_request.create'));
      expect(
          Capabilities.purchaseRequestClose, equals('purchase_request.close'));
      expect(
          Capabilities.purchaseRequestAward, equals('purchase_request.award'));
      expect(Capabilities.purchaseRequestRespond,
          equals('purchase_request.respond'));
      expect(Capabilities.providerSpecialtyReplace,
          equals('provider_specialty.replace'));
      expect(Capabilities.providerCreate, equals('provider.create'));
      expect(Capabilities.providerRead, equals('provider.read'));
      expect(Capabilities.workspaceAssetTypeRead,
          equals('workspace_asset_type.read'));
      expect(
          Capabilities.assetActorLinkCreate, equals('asset_actor_link.create'));
      expect(Capabilities.providerInviteAgent, equals('provider.invite_agent'));
      expect(Capabilities.providerRevokeAgent, equals('provider.revoke_agent'));
    });

    test('high-trust capabilities tienen los ids exactos del Core API', () {
      expect(Capabilities.providerClaim, equals('provider.claim'));
      expect(Capabilities.providerAgentInvitationRead,
          equals('provider.agent_invitation.read'));
    });
  });

  group('Capabilities — helpers de lectura', () {
    late SessionCapabilitiesStore store;

    setUp(() {
      store = SessionCapabilitiesStore();
    });

    test('has() devuelve false en store vacío', () {
      expect(Capabilities.has(store, Capabilities.providerCreate), isFalse);
      expect(Capabilities.has(store, Capabilities.purchaseRequestRead), isFalse);
    });

    test('has() devuelve true cuando la capability fue cargada', () {
      store.set([Capabilities.providerCreate]);

      expect(Capabilities.has(store, Capabilities.providerCreate), isTrue);
      expect(Capabilities.has(store, Capabilities.providerRead), isFalse);
    });

    test('hasAll() exige TODAS las capabilities listadas', () {
      store.set([
        Capabilities.providerCreate,
        Capabilities.providerRead,
      ]);

      expect(
        Capabilities.hasAll(store, [
          Capabilities.providerCreate,
          Capabilities.providerRead,
        ]),
        isTrue,
      );
      // Falta una → false.
      expect(
        Capabilities.hasAll(store, [
          Capabilities.providerCreate,
          Capabilities.providerInviteAgent,
        ]),
        isFalse,
      );
    });

    test('hasAny() basta una coincidencia', () {
      store.set([Capabilities.purchaseRequestRead]);

      expect(
        Capabilities.hasAny(store, [
          Capabilities.providerCreate,
          Capabilities.purchaseRequestRead,
        ]),
        isTrue,
      );
      // Ninguna coincidencia → false.
      expect(
        Capabilities.hasAny(store, [
          Capabilities.providerCreate,
          Capabilities.providerInviteAgent,
        ]),
        isFalse,
      );
    });

    test('clear() vacía las capabilities', () {
      store.set([Capabilities.providerCreate]);
      expect(Capabilities.has(store, Capabilities.providerCreate), isTrue);

      store.clear();
      expect(Capabilities.has(store, Capabilities.providerCreate), isFalse);
      expect(store.capabilities, isEmpty);
    });
  });

  group('Capabilities — invariantes anti-legacy', () {
    test('el catálogo NO contiene strings de roles legacy ("proveedor", '
        '"administrador", "propietario")', () {
      // El "rol UI" se deriva en runtime de capabilities + isProvider, NO
      // de strings tipo "proveedor"/"administrador"/"propietario". Si este
      // test rompe, alguien está reintroduciendo un canon paralelo de roles.
      const legacyRolStrings = <String>{
        'proveedor',
        'proveedor_servicios',
        'proveedor_articulos',
        'administrador',
        'admin_activos_ind',
        'admin_activos_org',
        'propietario',
        'propietario_emp',
        'arrendatario',
        'arrendatario_emp',
        'aseguradora',
        'asesor_seguros',
        'abogado',
      };

      // Lista exhaustiva de constantes públicas del catálogo.
      const allCapabilities = <String>[
        Capabilities.vehicleBatchCircuitRead,
        Capabilities.purchaseRequestRead,
        Capabilities.purchaseRequestCreate,
        Capabilities.purchaseRequestClose,
        Capabilities.purchaseRequestAward,
        Capabilities.purchaseRequestRespond,
        Capabilities.providerSpecialtyReplace,
        Capabilities.providerCreate,
        Capabilities.providerRead,
        Capabilities.workspaceAssetTypeRead,
        Capabilities.assetActorLinkCreate,
        Capabilities.providerInviteAgent,
        Capabilities.providerRevokeAgent,
        Capabilities.providerClaim,
        Capabilities.providerAgentInvitationRead,
      ];

      for (final cap in allCapabilities) {
        expect(
          legacyRolStrings.contains(cap),
          isFalse,
          reason:
              'Capability "$cap" colisiona con un rol legacy — capabilities '
              'son ids semánticos del Core API, NO roles UI.',
        );
      }
    });
  });
}
