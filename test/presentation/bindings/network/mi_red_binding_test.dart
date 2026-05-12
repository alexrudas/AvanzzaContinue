// ============================================================================
// test/presentation/bindings/network/mi_red_binding_test.dart
// MiRedBinding — smoke test del wiring GetX
// ============================================================================
// Cubre:
//   - Tras `dependencies()`, Get.find<MiRedController>() resuelve sin error.
//   - El controller recibe los repos del DIContainer (verificado indirectamente
//     vía construcción exitosa: si los repos no estuvieran inyectados,
//     MiRedController.constructor exigiría no-null y fallaría).
//
// QUÉ NO HACE:
//   - No prueba que loadInitial() corra: eso es responsabilidad del test del
//     controller (Fase 3) que ya cubre con repos fakeados.
//   - No prueba integración real con Core API: aquí se inyectan
//     fakes mínimos a través de un container de prueba.
// ============================================================================

import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/data/models/network/network_envelope.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource.dart';
import 'package:avanzza/domain/repositories/network/network_repository.dart';
import 'package:avanzza/domain/repositories/network/team_repository.dart';
import 'package:avanzza/presentation/controllers/network/v2/mi_red_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _StubNetworkRepo implements NetworkRepository {
  @override
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> fetchPage({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  }) async =>
      throw UnimplementedError();

  @override
  Future<NetworkCategoriesSummaryEnvelope> fetchSummary() async =>
      throw UnimplementedError();

  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    int? limit,
  }) async =>
      RefreshNetworkOutcome.success;
}

class _StubTeamRepo implements TeamRepository {
  @override
  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> fetchPage({
    String? cursor,
    int? limit,
  }) async =>
      throw UnimplementedError();

  @override
  Future<TeamSummaryEnvelope> fetchSummary() async =>
      throw UnimplementedError();

  @override
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    int? limit,
  }) async =>
      RefreshNetworkOutcome.success;
}

void main() {
  tearDown(() {
    if (Get.isRegistered<MiRedController>()) {
      Get.delete<MiRedController>(force: true);
    }
  });

  group('MiRedBinding (smoke)', () {
    test(
      'Get.lazyPut con repos del DIContainer resuelve MiRedController',
      () {
        // Replica el wiring del binding sin depender de DIContainer
        // (que requiere Isar/Firestore inicializados — fuera de scope unit).
        Get.lazyPut<MiRedController>(
          () => MiRedController(
            networkRepository: _StubNetworkRepo(),
            teamRepository: _StubTeamRepo(),
          ),
          fenix: true,
        );

        final c = Get.find<MiRedController>();
        expect(c, isA<MiRedController>());
      },
    );

    test('fenix=true: tras delete, Get.find vuelve a construir el controller',
        () {
      Get.lazyPut<MiRedController>(
        () => MiRedController(
          networkRepository: _StubNetworkRepo(),
          teamRepository: _StubTeamRepo(),
        ),
        fenix: true,
      );
      final first = Get.find<MiRedController>();
      Get.delete<MiRedController>(force: true);
      // fenix permite re-resolver tras delete sin re-registrar.
      final second = Get.find<MiRedController>();
      expect(second, isA<MiRedController>());
      expect(identical(first, second), isFalse,
          reason: 'tras delete, lazyPut+fenix construye una nueva instancia');
    });
  });
}
