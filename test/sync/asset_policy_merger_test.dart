// ============================================================================
// test/sync/asset_policy_merger_test.dart
// TESTS — AssetPolicyMerger
//
// QUÉ HACE:
// - Verifica el comportamiento de mergePolicies() en todos los escenarios
//   del contrato: identidad por policyId, unicidad lógica, lock, legacy,
//   activeLogicalKey y orden estable.
// - Cubre normalización por trim/case, deduplicación de locked attempts y
//   edge cases de claves lógicas inválidas.
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore.
// - No prueba lógica de negocio de pólizas (cobertura, vigencia, etc.).
//
// PRINCIPIOS:
// - Cada test verifica un único comportamiento del merger.
// - Fixtures inline — sin archivos externos.
// - Todos los `incoming` tienen policyId no-null (contrato del caller).
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// ============================================================================

import 'package:avanzza/data/sync/asset_policy_merger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS DE FIXTURES
  // ─────────────────────────────────────────────────────────────────────────

  Map<String, dynamic> policy({
    required String policyId,
    required String complianceType,
    required String policyNumber,
    String status = 'ACTIVE',
    Map<String, dynamic>? override,
  }) {
    return {
      'policyId': policyId,
      'complianceType': complianceType,
      'policyNumber': policyNumber,
      'status': status,
      if (override != null) 'override': override,
    };
  }

  Map<String, dynamic> lockedOverride() => {
        'isLocked': true,
        'reason': 'locked by admin',
        'lockedBy': 'admin@avanzza.co',
        'lockedAt': '2026-03-01T00:00:00.000Z',
      };

  Map<String, dynamic> legacyPolicy({
    required String complianceType,
    required String policyNumber,
    String status = 'ACTIVE',
    Map<String, dynamic>? override,
  }) {
    return {
      'complianceType': complianceType,
      'policyNumber': policyNumber,
      'status': status,
      if (override != null) 'override': override,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. CASO BASE: existing vacío + incoming con una póliza nueva
  // ─────────────────────────────────────────────────────────────────────────

  group('incoming agrega póliza nueva', () {
    test('array 0→1 y activeLogicalKey actualizado', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [],
        incoming: [
          policy(
            policyId: 'pid-001',
            complianceType: 'soat',
            policyNumber: 'S-2026-001',
          ),
        ],
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-001');
      expect(result.activeLogicalKey['soat:S-2026-001'], 'pid-001');
      expect(result.lockedOverrideAttempts, isEmpty);
    });

    test('póliza EXPIRED no se registra en activeLogicalKey', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [],
        incoming: [
          policy(
            policyId: 'pid-002',
            complianceType: 'rtm',
            policyNumber: 'RTM-001',
            status: 'EXPIRED',
          ),
        ],
      );

      expect(result.merged.length, 1);
      expect(result.activeLogicalKey, isEmpty);
    });

    test('policyNumber vacío o espacios no crea logical key', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [],
        incoming: [
          policy(
            policyId: 'pid-003',
            complianceType: 'soat',
            policyNumber: '   ',
          ),
        ],
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-003');
      expect(result.activeLogicalKey, isEmpty);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 2. UPDATE POR policyId
  // ─────────────────────────────────────────────────────────────────────────

  group('update por policyId', () {
    test('array 1→1 (in-place), sin duplicado', () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-2026-001',
        ),
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-001',
            complianceType: 'soat',
            policyNumber: 'S-2026-001',
          ),
          'extra': 'updated-field',
        },
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-001');
      expect(result.merged.first['extra'], 'updated-field');
      expect(result.activeLogicalKey['soat:S-2026-001'], 'pid-001');
    });

    test('ACTIVE→EXPIRED elimina clave de activeLogicalKey', () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-2026-001',
        ),
      ];

      final incoming = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-2026-001',
          status: 'EXPIRED',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['status'], 'EXPIRED');
      expect(result.activeLogicalKey, isEmpty);
    });

    test('múltiples pólizas: solo la actualizada cambia', () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
        policy(
          policyId: 'pid-002',
          complianceType: 'rtm',
          policyNumber: 'RTM-001',
        ),
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-001',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
          'notes': 'renovada',
        },
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 2);

      final soat = result.merged.firstWhere((p) => p['policyId'] == 'pid-001');
      expect(soat['notes'], 'renovada');

      final rtm = result.merged.firstWhere((p) => p['policyId'] == 'pid-002');
      expect(rtm.containsKey('notes'), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 3. UNICIDAD LÓGICA — mismo complianceType:policyNumber ACTIVE
  // ─────────────────────────────────────────────────────────────────────────

  group('unicidad lógica por complianceType:policyNumber', () {
    test(
      'incoming con distinto policyId pero misma clave lógica: servidor conserva su policyId, datos se actualizan',
      () {
        final existing = [
          policy(
            policyId: 'pid-server',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
        ];

        final incoming = [
          {
            ...policy(
              policyId: 'pid-local',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 500000,
          },
        ];

        final result = AssetPolicyMerger.mergePolicies(
          existing: existing,
          incoming: incoming,
        );

        expect(result.merged.length, 1);
        expect(result.merged.first['policyId'], 'pid-server');
        expect(result.merged.first['amount'], 500000);
        expect(result.activeLogicalKey['soat:S-001'], 'pid-server');
      },
    );

    test('misma clave lógica pero policyNumber diferente → crea nueva póliza',
        () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
      ];

      final incoming = [
        policy(
          policyId: 'pid-002',
          complianceType: 'soat',
          policyNumber: 'S-002',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 2);
      expect(result.activeLogicalKey.length, 2);
      expect(result.activeLogicalKey['soat:S-001'], 'pid-001');
      expect(result.activeLogicalKey['soat:S-002'], 'pid-002');
    });

    test('normalización: complianceType insensible a mayúsculas/minúsculas',
        () {
      final existing = [
        policy(
          policyId: 'pid-server',
          complianceType: 'SOAT',
          policyNumber: 'S-001',
        ),
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-local',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
          'notes': 'normalizado',
        },
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-server');
      expect(result.merged.first['notes'], 'normalizado');
    });

    test('normalización: policyNumber insensible a mayúsculas/minúsculas', () {
      final existing = [
        policy(
          policyId: 'pid-server',
          complianceType: 'rtm',
          policyNumber: 'rtm-001',
        ),
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-local',
            complianceType: 'rtm',
            policyNumber: 'RTM-001',
          ),
          'notes': 'normalizado',
        },
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-server');
      expect(result.merged.first['notes'], 'normalizado');
    });

    test('normalización: trim en complianceType y policyNumber', () {
      final existing = [
        policy(
          policyId: 'pid-server',
          complianceType: '  SOAT  ',
          policyNumber: '  s-001  ',
        ),
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-local',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
          'notes': 'trim-normalized',
        },
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-server');
      expect(result.merged.first['notes'], 'trim-normalized');
      expect(result.activeLogicalKey['soat:S-001'], 'pid-server');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 4. PÓLIZAS BLOQUEADAS (override.isLocked == true)
  // ─────────────────────────────────────────────────────────────────────────

  group('override.isLocked', () {
    test('incoming no sobreescribe póliza bloqueada por policyId', () {
      final serverPolicy = {
        ...policy(
          policyId: 'pid-locked',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
        'amount': 999999,
        'override': lockedOverride(),
      };

      final result = AssetPolicyMerger.mergePolicies(
        existing: [serverPolicy],
        incoming: [
          {
            ...policy(
              policyId: 'pid-locked',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 100,
          },
        ],
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['amount'], 999999);
      expect(result.lockedOverrideAttempts, contains('pid-locked'));
    });

    test('incoming no sobreescribe póliza bloqueada por unicidad lógica', () {
      final serverPolicy = {
        ...policy(
          policyId: 'pid-server',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
        'amount': 888888,
        'override': lockedOverride(),
      };

      final result = AssetPolicyMerger.mergePolicies(
        existing: [serverPolicy],
        incoming: [
          {
            ...policy(
              policyId: 'pid-local',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 100,
          },
        ],
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['amount'], 888888);
      expect(result.lockedOverrideAttempts, contains('pid-server'));
    });

    test('lockedOverrideAttempts no duplica el mismo policyId bloqueado', () {
      final serverPolicy = {
        ...policy(
          policyId: 'pid-server',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
        'amount': 888888,
        'override': lockedOverride(),
      };

      final result = AssetPolicyMerger.mergePolicies(
        existing: [serverPolicy],
        incoming: [
          {
            ...policy(
              policyId: 'pid-server',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 100,
          },
          {
            ...policy(
              policyId: 'pid-local',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 200,
          },
        ],
      );

      expect(result.lockedOverrideAttempts, ['pid-server']);
    });

    test('pólizas no bloqueadas sí pueden actualizarse', () {
      final serverPolicy = policy(
        policyId: 'pid-001',
        complianceType: 'soat',
        policyNumber: 'S-001',
      );

      final result = AssetPolicyMerger.mergePolicies(
        existing: [serverPolicy],
        incoming: [
          {
            ...policy(
              policyId: 'pid-001',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 750000,
          },
        ],
      );

      expect(result.merged.first['amount'], 750000);
      expect(result.lockedOverrideAttempts, isEmpty);
    });

    test('múltiples pólizas: solo la bloqueada se protege', () {
      final existing = [
        {
          ...policy(
            policyId: 'pid-locked',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
          'amount': 999,
          'override': lockedOverride(),
        },
        policy(
          policyId: 'pid-free',
          complianceType: 'rtm',
          policyNumber: 'RTM-001',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: [
          {
            ...policy(
              policyId: 'pid-locked',
              complianceType: 'soat',
              policyNumber: 'S-001',
            ),
            'amount': 1,
          },
          {
            ...policy(
              policyId: 'pid-free',
              complianceType: 'rtm',
              policyNumber: 'RTM-001',
            ),
            'amount': 2,
          },
        ],
      );

      final locked =
          result.merged.firstWhere((p) => p['policyId'] == 'pid-locked');
      final free = result.merged.firstWhere((p) => p['policyId'] == 'pid-free');

      expect(locked['amount'], 999);
      expect(free['amount'], 2);
      expect(result.lockedOverrideAttempts, contains('pid-locked'));
      expect(result.lockedOverrideAttempts, isNot(contains('pid-free')));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 5. INCOMING VACÍO — existing se preserva íntegramente
  // ─────────────────────────────────────────────────────────────────────────

  group('incoming vacío', () {
    test('preserva todas las pólizas existing', () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
        policy(
          policyId: 'pid-002',
          complianceType: 'rtm',
          policyNumber: 'RTM-001',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: [],
      );

      expect(result.merged.length, 2);
      expect(result.activeLogicalKey.length, 2);
      expect(result.lockedOverrideAttempts, isEmpty);
    });

    test('listas vacías producen resultado vacío', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [],
        incoming: [],
      );

      expect(result.merged, isEmpty);
      expect(result.activeLogicalKey, isEmpty);
      expect(result.lockedOverrideAttempts, isEmpty);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 6. PÓLIZAS LEGACY (sin policyId)
  // ─────────────────────────────────────────────────────────────────────────

  group('pólizas legacy sin policyId', () {
    test('se preservan en el resultado merged', () {
      final existing = [
        legacyPolicy(complianceType: 'soat', policyNumber: 'S-LEGACY-001'),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: [],
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], isNull);
      expect(result.merged.first['policyNumber'], 'S-LEGACY-001');
    });

    test('incoming ACTIVE con misma clave lógica reemplaza legacy no bloqueada',
        () {
      final existing = [
        legacyPolicy(complianceType: 'soat', policyNumber: 'S-001'),
      ];

      final incoming = [
        policy(
          policyId: 'pid-new',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], 'pid-new');
      expect(result.activeLogicalKey['soat:S-001'], 'pid-new');
    });

    test('incoming no reemplaza legacy ACTIVE bloqueada', () {
      final existing = [
        {
          ...legacyPolicy(complianceType: 'soat', policyNumber: 'S-001'),
          'amount': 777,
          'override': lockedOverride(),
        },
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-new',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
          'amount': 1,
        },
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 1);
      expect(result.merged.first['policyId'], isNull);
      expect(result.merged.first['amount'], 777);
    });

    test('legacy sin campos lógicos no bloquea incoming nuevo', () {
      final existing = [
        {'status': 'ACTIVE', 'notes': 'póliza incompleta'},
      ];

      final incoming = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 2);
    });

    test('reemplazo de legacy mantiene orden estable del resultado', () {
      final existing = [
        legacyPolicy(complianceType: 'soat', policyNumber: 'S-001'),
        policy(
          policyId: 'pid-B',
          complianceType: 'rtm',
          policyNumber: 'RTM-001',
        ),
      ];

      final incoming = [
        policy(
          policyId: 'pid-A',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      final ids = result.merged
          .where((p) => p['policyId'] != null)
          .map((p) => p['policyId'] as String)
          .toList();

      expect(ids, ['pid-A', 'pid-B']);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 7. activeLogicalKey — consistencia al final del merge
  // ─────────────────────────────────────────────────────────────────────────

  group('activeLogicalKey consistencia', () {
    test('refleja solo pólizas ACTIVE al final del merge', () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
        ),
        policy(
          policyId: 'pid-002',
          complianceType: 'rtm',
          policyNumber: 'RTM-001',
          status: 'EXPIRED',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: [],
      );

      expect(result.activeLogicalKey.length, 1);
      expect(result.activeLogicalKey.containsKey('soat:S-001'), isTrue);
      expect(result.activeLogicalKey.containsKey('rtm:RTM-001'), isFalse);
    });

    test('status cambia de EXPIRED a ACTIVE → se registra en activeLogicalKey',
        () {
      final existing = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
          status: 'EXPIRED',
        ),
      ];

      final incoming = [
        policy(
          policyId: 'pid-001',
          complianceType: 'soat',
          policyNumber: 'S-001',
          status: 'ACTIVE',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.activeLogicalKey['soat:S-001'], 'pid-001');
    });

    test('activeLogicalKey es inmutable', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [
          policy(
            policyId: 'pid-001',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
        ],
        incoming: [],
      );

      expect(
        () => (result.activeLogicalKey)['x'] = 'y',
        throwsUnsupportedError,
      );
    });

    test('merged es inmutable', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [],
        incoming: [],
      );

      expect(
        () => (result.merged).add({}),
        throwsUnsupportedError,
      );
    });

    test('lockedOverrideAttempts es inmutable', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [],
        incoming: [],
      );

      expect(
        () => (result.lockedOverrideAttempts).add('x'),
        throwsUnsupportedError,
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 8. ORDEN ESTABLE
  // ─────────────────────────────────────────────────────────────────────────

  group('orden estable del resultado', () {
    test('merged siempre sale en orden lexicográfico por policyId', () {
      final result = AssetPolicyMerger.mergePolicies(
        existing: [
          policy(
              policyId: 'pid-C', complianceType: 'soat', policyNumber: 'S-3'),
          policy(policyId: 'pid-A', complianceType: 'rtm', policyNumber: 'R-1'),
          policy(
              policyId: 'pid-B', complianceType: 'soat', policyNumber: 'S-2'),
        ],
        incoming: [],
      );

      final ids = result.merged.map((p) => p['policyId'] as String).toList();
      expect(ids, ['pid-A', 'pid-B', 'pid-C']);
    });

    test('mismo input siempre produce mismo orden', () {
      final existing = [
        policy(policyId: 'pid-Z', complianceType: 'rtm', policyNumber: 'R-9'),
        policy(policyId: 'pid-M', complianceType: 'soat', policyNumber: 'S-5'),
        policy(policyId: 'pid-A', complianceType: 'soat', policyNumber: 'S-1'),
      ];

      final r1 =
          AssetPolicyMerger.mergePolicies(existing: existing, incoming: []);
      final r2 =
          AssetPolicyMerger.mergePolicies(existing: existing, incoming: []);

      final ids1 = r1.merged.map((p) => p['policyId']).toList();
      final ids2 = r2.merged.map((p) => p['policyId']).toList();

      expect(ids1, ids2);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 9. ESCENARIO COMPLETO — múltiples operaciones en un solo merge
  // ─────────────────────────────────────────────────────────────────────────

  group('escenario completo', () {
    test('combinación de nuevas, actualizadas, bloqueadas y legacy', () {
      final existing = [
        policy(
            policyId: 'pid-001', complianceType: 'soat', policyNumber: 'S-001'),
        {
          ...policy(
            policyId: 'pid-002',
            complianceType: 'rtm',
            policyNumber: 'RTM-001',
          ),
          'amount': 500,
          'override': lockedOverride(),
        },
        policy(
          policyId: 'pid-003',
          complianceType: 'fire_insurance',
          policyNumber: 'FI-001',
        ),
        legacyPolicy(
          complianceType: 'rc_contractual',
          policyNumber: 'RC-LEGACY',
        ),
      ];

      final incoming = [
        {
          ...policy(
            policyId: 'pid-001',
            complianceType: 'soat',
            policyNumber: 'S-001',
          ),
          'amount': 999,
        },
        {
          ...policy(
            policyId: 'pid-002',
            complianceType: 'rtm',
            policyNumber: 'RTM-001',
          ),
          'amount': 1,
        },
        policy(
          policyId: 'pid-new',
          complianceType: 'flood_insurance',
          policyNumber: 'FLD-001',
        ),
      ];

      final result = AssetPolicyMerger.mergePolicies(
        existing: existing,
        incoming: incoming,
      );

      expect(result.merged.length, 5);

      final p001 = result.merged.firstWhere((p) => p['policyId'] == 'pid-001');
      expect(p001['amount'], 999);

      final p002 = result.merged.firstWhere((p) => p['policyId'] == 'pid-002');
      expect(p002['amount'], 500);

      final pNew = result.merged.firstWhere((p) => p['policyId'] == 'pid-new');
      expect(pNew['complianceType'], 'flood_insurance');

      final legacy = result.merged.firstWhere((p) => p['policyId'] == null);
      expect(legacy['policyNumber'], 'RC-LEGACY');

      expect(result.lockedOverrideAttempts, contains('pid-002'));

      expect(result.activeLogicalKey.containsKey('soat:S-001'), isTrue);
      expect(result.activeLogicalKey.containsKey('rtm:RTM-001'), isTrue);
      expect(
        result.activeLogicalKey.containsKey('flood_insurance:FLD-001'),
        isTrue,
      );
      expect(
        result.activeLogicalKey.containsKey('fire_insurance:FI-001'),
        isTrue,
      );
    });
  });
}
