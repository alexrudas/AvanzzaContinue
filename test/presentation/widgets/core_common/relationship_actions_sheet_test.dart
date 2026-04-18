// ============================================================================
// test/presentation/widgets/core_common/relationship_actions_sheet_test.dart
// RELATIONSHIP ACTIONS SHEET — F5 Hito 6/7 (widget test)
// ============================================================================
// QUÉ VALIDA:
//   - El sheet se abre y muestra el botón "Iniciar solicitud" y "Vinculado".
//   - El botón "Cerrar" cierra el sheet sin efectos colaterales.
//
// QUÉ NO VALIDA AQUÍ:
//   - Flujo de creación de la Request (StartOperationalRequest) — cubierto por
//     test/application/core_common/use_cases/start_operational_request_test.dart.
//     Requeriría DIContainer + GetX bindings reales, fuera del scope de un
//     widget test.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/operational_relationship_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/presentation/widgets/core_common/relationship_actions_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

OperationalRelationshipEntity _stubRelationship() {
  final now = DateTime.utc(2026, 1, 1);
  return OperationalRelationshipEntity(
    id: 'rel-42',
    sourceWorkspaceId: 'ws-1',
    targetLocalKind: TargetLocalKind.contact,
    targetLocalId: 'c-1',
    state: RelationshipState.vinculada,
    createdAt: now,
    updatedAt: now,
    stateUpdatedAt: now,
    relationshipKind: RelationshipKind.generic,
    linkedAt: now,
  );
}

void main() {
  testWidgets('muestra header "Vinculado" y botón "Iniciar solicitud"',
      (tester) async {
    final rel = _stubRelationship();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) => Center(
              child: ElevatedButton(
                onPressed: () => RelationshipActionsSheet.show(ctx, rel),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('relationship_actions_sheet.start_request')),
      findsOneWidget,
    );
    expect(find.text('Iniciar solicitud'), findsOneWidget);
    expect(find.text('Vinculado'), findsOneWidget);
  });

  testWidgets('botón "Cerrar" cierra el sheet sin efectos', (tester) async {
    final rel = _stubRelationship();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) => Center(
              child: ElevatedButton(
                onPressed: () => RelationshipActionsSheet.show(ctx, rel),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar solicitud'), findsNothing);
  });
}
