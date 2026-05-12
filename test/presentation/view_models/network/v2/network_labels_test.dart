// ============================================================================
// test/presentation/view_models/network/v2/network_labels_test.dart
// NetworkLabels — cobertura exhaustiva del resolver de copy ES
// ============================================================================
// Cubre TODOS los valores de los enums cerrados. Si alguien agrega un valor
// al enum y olvida actualizar el resolver, el switch no-exhaustive del
// resolver lo señala en compilación; este test es la malla extra que
// confirma que ningún label retorna string vacío.
// ============================================================================

import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_labels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkLabels.category — cobertura completa', () {
    test('cada NetworkCategory tiene label no vacío', () {
      for (final c in NetworkCategory.values) {
        final label = NetworkLabels.category(c);
        expect(label, isNotEmpty, reason: 'category=${c.wireName}');
      }
    });

    test('algunos labels canónicos esperados (smoke)', () {
      expect(NetworkLabels.category(NetworkCategory.workshop), 'Talleres');
      expect(NetworkLabels.category(NetworkCategory.unclassified), 'Otros');
      expect(NetworkLabels.category(NetworkCategory.legal), 'Legal');
    });
  });

  group('NetworkLabels.actionLabel — cobertura completa', () {
    test('cada NetworkActionType tiene label no vacío', () {
      for (final t in NetworkActionType.values) {
        final label = NetworkLabels.actionLabel(t);
        expect(label, isNotEmpty, reason: 'action=${t.wireName}');
      }
    });

    test('canónicos esperados', () {
      expect(NetworkLabels.actionLabel(NetworkActionType.call), 'Llamar');
      expect(NetworkLabels.actionLabel(NetworkActionType.whatsapp), 'WhatsApp');
      expect(NetworkLabels.actionLabel(NetworkActionType.requestQuote), 'Cotizar');
    });
  });

  group('NetworkLabels.actionDisabledHint — cobertura completa', () {
    test('cada NetworkActionDisabledReason tiene hint no vacío (incluido other)', () {
      for (final r in NetworkActionDisabledReason.values) {
        final hint = NetworkLabels.actionDisabledHint(r);
        expect(hint, isNotEmpty, reason: 'reason=${r.wireName}');
      }
    });

    test('"other" tiene mensaje genérico (safety valve)', () {
      // No debería filtrar el wirename literal "other" al usuario.
      final hint = NetworkLabels.actionDisabledHint(NetworkActionDisabledReason.other);
      expect(hint, isNot(equals('other')));
      expect(hint, isNot(contains('__')));
    });
  });

  group('NetworkLabels.restrictionBadge — cobertura completa', () {
    test('cada NetworkRestrictionReason tiene badge', () {
      for (final r in NetworkRestrictionReason.values) {
        expect(NetworkLabels.restrictionBadge(r), isNotEmpty);
      }
    });

    test('canónicos esperados', () {
      expect(NetworkLabels.restrictionBadge(NetworkRestrictionReason.suspended),
          'Suspendido');
      expect(NetworkLabels.restrictionBadge(NetworkRestrictionReason.closed),
          'Cerrado');
    });
  });

  group('NetworkLabels.relationshipState — cobertura completa', () {
    test('cada NetworkRelationshipState tiene label', () {
      for (final s in NetworkRelationshipState.values) {
        expect(NetworkLabels.relationshipState(s), isNotEmpty);
      }
    });
  });
}
