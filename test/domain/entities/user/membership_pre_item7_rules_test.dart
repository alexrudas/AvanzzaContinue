// ============================================================================
// test/domain/entities/user/membership_pre_item7_rules_test.dart
// Verifica las 4 reglas exigidas antes del ítem 7:
//   1. providerProfiles deprecated pero LEGIBLE.
//   2. roles legacy válidos: lista de strings se preserva tal cual está
//      (la conversión a MembershipRole tipado es separate concern del parser).
//   3. roles legacy inválidos NO rompen lectura del entity.
//   4. roles=[] permitido (Fase 2 kill-switch).
//   5. isOwner=true NO se convierte en rol (independencia respecto a roles).
// ============================================================================
// Este archivo CONSCIENTEMENTE accede a Membership.providerProfiles para
// verificar que el campo @Deprecated sigue legible. Es la única excepción
// autorizada en el ámbito de tests fuera del migrator.
// ignore_for_file: deprecated_member_use
// ============================================================================

import 'dart:convert';

import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/entities/user/provider_profile.dart';
import 'package:flutter_test/flutter_test.dart';

MembershipEntity _membership({
  List<String> roles = const [],
  // ignore: deprecated_member_use_from_same_package
  List<ProviderProfile> providerProfiles = const [],
  bool? isOwner,
}) {
  return MembershipEntity(
    userId: 'uid-1',
    orgId: 'org-1',
    orgName: 'Acme',
    roles: roles,
    providerProfiles: providerProfiles,
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO'},
    isOwner: isOwner,
  );
}

void main() {
  group('Regla 1: providerProfiles deprecated pero legible', () {
    test('el campo se puede LEER tras la marca @Deprecated', () {
      final m = _membership(
        providerProfiles: [
          const ProviderProfile(
            providerType: 'servicios',
            businessCategoryId: 'mecanico_independiente',
          ),
        ],
      );
      // El acceso al getter sigue funcionando — el migrator del ítem 6
      // depende de esta legibilidad.
      expect(m.providerProfiles.length, 1);
      expect(m.providerProfiles.first.businessCategoryId,
          'mecanico_independiente');
    });

    test('el campo tiene default [] (compat construcción sin pasar nada)',
        () {
      final m = _membership();
      expect(m.providerProfiles, isEmpty);
    });

    test('JSON roundtrip preserva providerProfiles legacy', () {
      // NOTA: forzamos roundtrip vía jsonEncode/jsonDecode porque
      // MembershipEntity (preexistente) no usa explicitToJson:true en su
      // anotación freezed; su `toJson()` emite objetos Dart anidados.
      // jsonEncode los canoniza vía toJson recursivo, lo que refleja el
      // comportamiento real al persistir/leer JSON.
      final original = _membership(
        providerProfiles: [
          const ProviderProfile(
            providerType: 'articulos',
            businessCategoryId: 'autopartes',
            assetTypeIds: ['vehiculos'],
          ),
        ],
      );
      final encoded = jsonEncode(original.toJson());
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      final restored = MembershipEntity.fromJson(decoded);
      expect(restored.providerProfiles.length, 1);
      expect(restored.providerProfiles.first.providerType, 'articulos');
    });
  });

  group('Regla 2: roles legacy válidos preservados tal cual', () {
    test('lista de roles strings se conserva sin transformación', () {
      final m = _membership(roles: const ['admin', 'sales_agent']);
      expect(m.roles, ['admin', 'sales_agent']);
    });

    test('roles con case mixto se conservan literalmente (parser separado normaliza)',
        () {
      // El entity NO normaliza; eso es responsabilidad de
      // LegacyMembershipRoleParser. El entity transporta strings tal cual.
      final m = _membership(roles: const ['Admin', 'ADMIN', '  admin  ']);
      expect(m.roles, ['Admin', 'ADMIN', '  admin  ']);
    });
  });

  group('Regla 3: roles legacy inválidos NO rompen lectura', () {
    test('strings desconocidos en roles ⇒ entity construye sin lanzar', () {
      // El entity NO valida el catálogo. La validación es trabajo del parser.
      // Construir el entity con strings desconocidos NO debe lanzar.
      expect(
        () => _membership(
          roles: const ['admin', 'super_admin', 'unknown_role'],
        ),
        returnsNormally,
      );
    });

    test('strings vacíos en roles ⇒ entity construye sin lanzar', () {
      expect(
        () => _membership(roles: const ['', '   ', 'admin']),
        returnsNormally,
      );
    });

    test('JSON con roles malformados ⇒ fromJson NO lanza', () {
      expect(
        () => MembershipEntity.fromJson(<String, dynamic>{
          'userId': 'u',
          'orgId': 'o',
          'orgName': 'O',
          'roles': ['unknown_legacy_role', '', 'admin'],
          'providerProfiles': <Map<String, dynamic>>[],
          'estatus': 'activo',
          'primaryLocation': {'countryId': 'CO'},
        }),
        returnsNormally,
      );
    });
  });

  group('Regla 4: roles=[] permitido (Fase 2 kill-switch)', () {
    test('lista vacía explícita ⇒ entity válido', () {
      final m = _membership(roles: const []);
      expect(m.roles, isEmpty);
    });

    test('default sin pasar roles ⇒ entity con roles=[]', () {
      final m = _membership();
      expect(m.roles, isEmpty);
    });

    test('JSON con roles=[] explícito ⇒ entity con lista vacía', () {
      final json = <String, dynamic>{
        'userId': 'u',
        'orgId': 'o',
        'orgName': 'O',
        'roles': <String>[],
        'providerProfiles': <Map<String, dynamic>>[],
        'estatus': 'activo',
        'primaryLocation': {'countryId': 'CO'},
      };
      final m = MembershipEntity.fromJson(json);
      expect(m.roles, isEmpty);
    });

    test('JSON sin clave roles ⇒ default [] aplicado', () {
      final json = <String, dynamic>{
        'userId': 'u',
        'orgId': 'o',
        'orgName': 'O',
        'providerProfiles': <Map<String, dynamic>>[],
        'estatus': 'activo',
        'primaryLocation': {'countryId': 'CO'},
      };
      final m = MembershipEntity.fromJson(json);
      expect(m.roles, isEmpty);
    });
  });

  group('Regla 5: isOwner NO se convierte en rol', () {
    test('isOwner=true con roles=[] ⇒ campo independiente, roles sigue vacío',
        () {
      final m = _membership(roles: const [], isOwner: true);
      expect(m.isOwner, isTrue);
      expect(m.roles, isEmpty);
      // isOwner NO aparece como string dentro de roles.
      expect(m.roles.contains('owner'), isFalse);
      expect(m.roles.contains('isOwner'), isFalse);
      expect(m.roles.contains('admin'), isFalse);
    });

    test('isOwner=true con roles=[admin] ⇒ ambos coexisten independientes',
        () {
      final m = _membership(roles: const ['admin'], isOwner: true);
      expect(m.isOwner, isTrue);
      expect(m.roles, ['admin']);
    });

    test('isOwner=null por default ⇒ no afecta a roles', () {
      final m = _membership(roles: const ['admin']);
      expect(m.isOwner, isNull);
      expect(m.roles, ['admin']);
    });

    test('isOwner=false ⇒ roles no se expanden ni colapsan', () {
      final m = _membership(roles: const ['viewer'], isOwner: false);
      expect(m.isOwner, isFalse);
      expect(m.roles, ['viewer']);
    });

    test('isOwner+roles vía JSON roundtrip preserva ambos campos', () {
      // Roundtrip canónico vía jsonEncode/jsonDecode (ver nota en regla 1).
      final original = _membership(
        roles: const ['admin', 'sales_agent'],
        isOwner: true,
      );
      final encoded = jsonEncode(original.toJson());
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      final restored = MembershipEntity.fromJson(decoded);
      expect(restored.isOwner, isTrue);
      expect(restored.roles, ['admin', 'sales_agent']);
    });
  });
}
