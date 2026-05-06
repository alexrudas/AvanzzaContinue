// ============================================================================
// test/domain/entities/portfolio/portfolio_entity_expected_relation_kind_test.dart
// Tests del campo PortfolioEntity.expectedRelationKind
// ============================================================================
// Cubre:
//   - Default null cuando no se pasa.
//   - Construcción con cada valor de AssetActorRole (incluye manager).
//   - JSON roundtrip preserva el wire name.
//   - JSON sin la clave ⇒ null (compat legacy).
//   - JSON con valor null explícito ⇒ null.
//   - JSON con wire desconocido ⇒ throws (path estricto del entity).
//   - copyWith actualiza el campo correctamente.
//   - El campo NO interfiere con los demás (status, snapshot VRC, etc.).
// ============================================================================

import 'dart:convert';

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:flutter_test/flutter_test.dart';

PortfolioEntity _basePortfolio({
  AssetActorRole? expectedRelationKind,
}) {
  return PortfolioEntity(
    id: 'pf-1',
    portfolioType: PortfolioType.vehiculos,
    portfolioName: 'Mi Flota',
    countryId: 'CO',
    cityId: 'col-ant-med',
    orgId: 'org-1',
    createdBy: 'uid-1',
    expectedRelationKind: expectedRelationKind,
  );
}

void main() {
  group('PortfolioEntity.expectedRelationKind — defaults', () {
    test('omitir el campo ⇒ null', () {
      const p = PortfolioEntity(
        id: 'pf-x',
        portfolioType: PortfolioType.vehiculos,
        portfolioName: 'X',
        countryId: 'CO',
        cityId: 'col-ant-med',
        createdBy: 'uid',
      );
      expect(p.expectedRelationKind, isNull);
    });

    test('null explícito ⇒ null', () {
      final p = _basePortfolio(expectedRelationKind: null);
      expect(p.expectedRelationKind, isNull);
    });

    test('campos legacy preservados (status, snapshot VRC, etc.)', () {
      final p = _basePortfolio();
      expect(p.status, PortfolioStatus.draft);
      expect(p.assetsCount, 0);
      expect(p.ownerName, isNull);
      expect(p.simitFinesCount, isNull);
    });
  });

  group('PortfolioEntity.expectedRelationKind — construcción válida', () {
    test('owner', () {
      final p = _basePortfolio(expectedRelationKind: AssetActorRole.owner);
      expect(p.expectedRelationKind, AssetActorRole.owner);
    });

    test('manager (nuevo en v3)', () {
      final p =
          _basePortfolio(expectedRelationKind: AssetActorRole.manager);
      expect(p.expectedRelationKind, AssetActorRole.manager);
    });

    test('tenant', () {
      final p = _basePortfolio(expectedRelationKind: AssetActorRole.tenant);
      expect(p.expectedRelationKind, AssetActorRole.tenant);
    });

    test('driver', () {
      final p = _basePortfolio(expectedRelationKind: AssetActorRole.driver);
      expect(p.expectedRelationKind, AssetActorRole.driver);
    });

    test('todos los AssetActorRole.values son aceptados', () {
      for (final r in AssetActorRole.values) {
        final p = _basePortfolio(expectedRelationKind: r);
        expect(p.expectedRelationKind, r);
      }
    });
  });

  group('PortfolioEntity.expectedRelationKind — JSON roundtrip', () {
    test('toJson incluye expectedRelationKind como wire name', () {
      final p =
          _basePortfolio(expectedRelationKind: AssetActorRole.manager);
      final json = p.toJson();
      expect(json['expectedRelationKind'], 'manager');
    });

    test('toJson omite cuando null no, lo emite como null (json_serializable default)',
        () {
      final p = _basePortfolio();
      final json = p.toJson();
      // json_serializable serializa nulls explícitamente; lo aceptamos.
      expect(json.containsKey('expectedRelationKind'), isTrue);
      expect(json['expectedRelationKind'], isNull);
    });

    test('roundtrip vía jsonEncode preserva manager', () {
      final original =
          _basePortfolio(expectedRelationKind: AssetActorRole.manager);
      final encoded = jsonEncode(original.toJson());
      final restored =
          PortfolioEntity.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(restored.expectedRelationKind, AssetActorRole.manager);
    });

    test('roundtrip preserva owner', () {
      final original =
          _basePortfolio(expectedRelationKind: AssetActorRole.owner);
      final encoded = jsonEncode(original.toJson());
      final restored =
          PortfolioEntity.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(restored.expectedRelationKind, AssetActorRole.owner);
    });

    test('roundtrip preserva null', () {
      final original = _basePortfolio();
      final encoded = jsonEncode(original.toJson());
      final restored =
          PortfolioEntity.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(restored.expectedRelationKind, isNull);
    });
  });

  group('PortfolioEntity.expectedRelationKind — compat legacy', () {
    test('JSON sin la clave ⇒ default null', () {
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
      final p = PortfolioEntity.fromJson(json);
      expect(p.expectedRelationKind, isNull);
      expect(p.id, 'pf-legacy');
    });

    test('JSON con expectedRelationKind=null explícito ⇒ null', () {
      final json = <String, dynamic>{
        'id': 'pf-x',
        'portfolioType': 'VEHICULOS',
        'portfolioName': 'X',
        'countryId': 'CO',
        'cityId': 'col-ant-med',
        'orgId': 'org-x',
        'status': 'DRAFT',
        'assetsCount': 0,
        'createdBy': 'uid',
        'expectedRelationKind': null,
      };
      final p = PortfolioEntity.fromJson(json);
      expect(p.expectedRelationKind, isNull);
    });
  });

  group('PortfolioEntity.expectedRelationKind — JSON estricto', () {
    test('wire desconocido ⇒ throws (path canónico del entity)', () {
      // El converter generado por json_serializable es estricto: rechaza
      // wires que no estén en @JsonValue del enum. La tolerancia (silenciar
      // wires desconocidos) vive en PortfolioModel, no en la entity.
      final json = <String, dynamic>{
        'id': 'pf-bad',
        'portfolioType': 'VEHICULOS',
        'portfolioName': 'X',
        'countryId': 'CO',
        'cityId': 'col-ant-med',
        'orgId': 'org-bad',
        'status': 'DRAFT',
        'assetsCount': 0,
        'createdBy': 'uid',
        'expectedRelationKind': 'future_role_v4',
      };
      expect(() => PortfolioEntity.fromJson(json), throwsA(anything));
    });
  });

  group('PortfolioEntity — copyWith preserva el campo', () {
    test('copyWith sin tocar el campo ⇒ se preserva', () {
      final p =
          _basePortfolio(expectedRelationKind: AssetActorRole.manager);
      final updated = p.copyWith(portfolioName: 'Renombrado');
      expect(updated.expectedRelationKind, AssetActorRole.manager);
      expect(updated.portfolioName, 'Renombrado');
    });

    test('copyWith mutando el campo ⇒ reemplaza', () {
      final p =
          _basePortfolio(expectedRelationKind: AssetActorRole.owner);
      final updated =
          p.copyWith(expectedRelationKind: AssetActorRole.tenant);
      expect(updated.expectedRelationKind, AssetActorRole.tenant);
    });

    test('copyWith no rompe demás campos legacy', () {
      final p =
          _basePortfolio(expectedRelationKind: AssetActorRole.manager);
      final updated = p.copyWith(assetsCount: 5);
      expect(updated.assetsCount, 5);
      expect(updated.expectedRelationKind, AssetActorRole.manager);
      expect(updated.status, PortfolioStatus.draft);
    });
  });
}
