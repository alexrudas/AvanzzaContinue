// ============================================================================
// test/data/models/portfolio/portfolio_model_expected_relation_kind_test.dart
// Tests del campo PortfolioModel.expectedRelationKindWire + mappers
// ============================================================================
// Cubre:
//   - fromEntity encode wire desde AssetActorRole?
//   - toEntity decode tipado vía tryFromWire
//   - Roundtrip entity → model → entity preserva el valor
//   - Compat legacy: registros sin el campo (null) ⇒ entity.expectedRelationKind == null
//   - Wire desconocido (futuro valor) ⇒ silencio + null en entity (sin throw)
//   - manager (nuevo en v3) roundtrip funcional
//   - El campo no rompe los demás (snapshot VRC, status, etc.)
// ============================================================================

import 'package:avanzza/data/models/portfolio/portfolio_model.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:flutter_test/flutter_test.dart';

PortfolioEntity _entity({
  AssetActorRole? expectedRelationKind,
  String? ownerName,
}) {
  return PortfolioEntity(
    id: 'pf-1',
    portfolioType: PortfolioType.vehiculos,
    portfolioName: 'Mi Flota',
    countryId: 'CO',
    cityId: 'col-ant-med',
    orgId: 'org-1',
    createdBy: 'uid',
    expectedRelationKind: expectedRelationKind,
    ownerName: ownerName,
  );
}

void main() {
  group('PortfolioModel.fromEntity — encode wire', () {
    test('expectedRelationKind null ⇒ wire null', () {
      final model = PortfolioModel.fromEntity(_entity());
      expect(model.expectedRelationKindWire, isNull);
    });

    test('expectedRelationKind owner ⇒ wire "owner"', () {
      final model = PortfolioModel.fromEntity(
        _entity(expectedRelationKind: AssetActorRole.owner),
      );
      expect(model.expectedRelationKindWire, 'owner');
    });

    test('expectedRelationKind manager ⇒ wire "manager" (v3)', () {
      final model = PortfolioModel.fromEntity(
        _entity(expectedRelationKind: AssetActorRole.manager),
      );
      expect(model.expectedRelationKindWire, 'manager');
    });

    test('cada AssetActorRole se serializa a su wireName canónico', () {
      for (final r in AssetActorRole.values) {
        final model = PortfolioModel.fromEntity(
          _entity(expectedRelationKind: r),
        );
        expect(model.expectedRelationKindWire, r.wireName);
      }
    });
  });

  group('PortfolioModel.toEntity — decode wire', () {
    test('wire null ⇒ entity con expectedRelationKind null', () {
      final model = PortfolioModel(
        id: 'pf-x',
        portfolioType: 'VEHICULOS',
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        status: 'DRAFT',
        assetsCount: 0,
        createdBy: 'uid',
      );
      final entity = model.toEntity();
      expect(entity.expectedRelationKind, isNull);
    });

    test('wire "owner" ⇒ AssetActorRole.owner', () {
      final model = PortfolioModel(
        id: 'pf-1',
        portfolioType: 'VEHICULOS',
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        status: 'DRAFT',
        assetsCount: 0,
        createdBy: 'uid',
        expectedRelationKindWire: 'owner',
      );
      expect(model.toEntity().expectedRelationKind, AssetActorRole.owner);
    });

    test('wire "manager" ⇒ AssetActorRole.manager (v3)', () {
      final model = PortfolioModel(
        id: 'pf-1',
        portfolioType: 'VEHICULOS',
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        status: 'DRAFT',
        assetsCount: 0,
        createdBy: 'uid',
        expectedRelationKindWire: 'manager',
      );
      expect(model.toEntity().expectedRelationKind, AssetActorRole.manager);
    });

    test('wire desconocido (valor futuro) ⇒ null silencioso (no throw)', () {
      // Política: wire-stable + tolerancia en lectura. Una build vieja que
      // ve un wire de una build futura NO debe crashear; lo expone como null.
      final model = PortfolioModel(
        id: 'pf-future',
        portfolioType: 'VEHICULOS',
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        status: 'DRAFT',
        assetsCount: 0,
        createdBy: 'uid',
        expectedRelationKindWire: 'future_role_v4',
      );
      expect(model.toEntity().expectedRelationKind, isNull);
    });

    test('wire vacío ⇒ null silencioso', () {
      final model = PortfolioModel(
        id: 'pf-1',
        portfolioType: 'VEHICULOS',
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        status: 'DRAFT',
        assetsCount: 0,
        createdBy: 'uid',
        expectedRelationKindWire: '',
      );
      expect(model.toEntity().expectedRelationKind, isNull);
    });

    test('wire con case incorrecto ⇒ null silencioso (case-sensitive)', () {
      final model = PortfolioModel(
        id: 'pf-1',
        portfolioType: 'VEHICULOS',
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        status: 'DRAFT',
        assetsCount: 0,
        createdBy: 'uid',
        expectedRelationKindWire: 'OWNER',
      );
      expect(model.toEntity().expectedRelationKind, isNull);
    });
  });

  group('PortfolioModel — roundtrip entity → model → entity', () {
    test('preserva expectedRelationKind=null', () {
      final original = _entity();
      final restored = PortfolioModel.fromEntity(original).toEntity();
      expect(restored.expectedRelationKind, isNull);
    });

    test('preserva expectedRelationKind=owner', () {
      final original =
          _entity(expectedRelationKind: AssetActorRole.owner);
      final restored = PortfolioModel.fromEntity(original).toEntity();
      expect(restored.expectedRelationKind, AssetActorRole.owner);
    });

    test('preserva expectedRelationKind=manager (v3)', () {
      final original =
          _entity(expectedRelationKind: AssetActorRole.manager);
      final restored = PortfolioModel.fromEntity(original).toEntity();
      expect(restored.expectedRelationKind, AssetActorRole.manager);
    });

    test('roundtrip preserva todos los AssetActorRole.values', () {
      for (final r in AssetActorRole.values) {
        final original = _entity(expectedRelationKind: r);
        final restored = PortfolioModel.fromEntity(original).toEntity();
        expect(restored.expectedRelationKind, r);
      }
    });

    test('roundtrip no rompe campos legacy (ownerName, status, assetsCount)',
        () {
      final original = _entity(
        expectedRelationKind: AssetActorRole.manager,
        ownerName: 'Alex',
      );
      final restored = PortfolioModel.fromEntity(original).toEntity();
      expect(restored.ownerName, 'Alex');
      expect(restored.status, PortfolioStatus.draft);
      expect(restored.assetsCount, 0);
      expect(restored.expectedRelationKind, AssetActorRole.manager);
    });
  });

  group('PortfolioModel — compat legacy (registros pre-v3)', () {
    test('registro Isar sin expectedRelationKindWire ⇒ entity.expectedRelationKind=null',
        () {
      // Reproduce un registro legacy: el campo simplemente no existía cuando
      // se persistió. Isar lo trata como null por contrato del schema bump v3.
      final legacy = PortfolioModel(
        id: 'pf-legacy',
        portfolioType: 'VEHICULOS',
        portfolioName: 'Legacy',
        countryId: 'CO',
        cityId: 'col-ant-med',
        orgId: 'org-l',
        status: 'ACTIVE',
        assetsCount: 3,
        createdBy: 'old-uid',
        // expectedRelationKindWire NO se pasa ⇒ default null
      );
      final entity = legacy.toEntity();
      expect(entity.expectedRelationKind, isNull);
      // Resto de campos preservados
      expect(entity.id, 'pf-legacy');
      expect(entity.assetsCount, 3);
      expect(entity.status, PortfolioStatus.active);
    });

    test('JSON deserializado sin la clave ⇒ wire null en model', () {
      final json = <String, dynamic>{
        'id': 'pf-legacy',
        'portfolioType': 'VEHICULOS',
        'portfolioName': 'Legacy',
        'countryId': 'CO',
        'cityId': 'col-ant-med',
        'orgId': 'org-l',
        'status': 'DRAFT',
        'assetsCount': 0,
        'createdBy': 'uid',
      };
      final model = PortfolioModel.fromJson(json);
      expect(model.expectedRelationKindWire, isNull);
      expect(model.toEntity().expectedRelationKind, isNull);
    });
  });

  group('PortfolioModel — JSON serialización', () {
    test('toJson incluye expectedRelationKindWire cuando hay valor', () {
      final model = PortfolioModel.fromEntity(
        _entity(expectedRelationKind: AssetActorRole.manager),
      );
      final json = model.toJson();
      expect(json['expectedRelationKindWire'], 'manager');
    });

    test('JSON roundtrip preserva el wire', () {
      final original = PortfolioModel.fromEntity(
        _entity(expectedRelationKind: AssetActorRole.tenant),
      );
      final restored = PortfolioModel.fromJson(original.toJson());
      expect(restored.expectedRelationKindWire, 'tenant');
      expect(
        restored.toEntity().expectedRelationKind,
        AssetActorRole.tenant,
      );
    });
  });
}
