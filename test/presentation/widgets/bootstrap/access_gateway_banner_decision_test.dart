// ============================================================================
// test/presentation/widgets/bootstrap/access_gateway_banner_decision_test.dart
// Tests de la matriz pura de decisión `decideAccessBanner`.
// ============================================================================
// QUÉ CUBRE:
//   - Estados especiales del gateway (Blocked, RequiresWorkspaceSelection).
//   - Reglas por bucket de freshness × syncStatus × estado del gateway.
//   - Regla canónica V2.1 (cierre UX): snapshot fresco silencia banner
//     incluso con syncStatus=syncFailed o pendingSync.
//   - Snapshot stale solo se materializa como banner cuando el gateway
//     está fallando o cargando.
//   - Snapshot críticamente stale dispara warning claro siempre.
//   - Sin snapshot + gateway error ⇒ hardError; sin snapshot + ready ⇒ hidden.
//
// GOBERNANZA:
//   La función bajo test es PURA: no toca clock, ni servicios, ni red. Tests
//   ejecutan en milisegundos sin Flutter binding.
// ============================================================================

import 'package:avanzza/application/services/access/access_gateway.dart';
import 'package:avanzza/data/models/access/access_context_snapshot_model.dart';
import 'package:avanzza/domain/entities/access/access_context.dart';
import 'package:avanzza/domain/entities/access/access_enums.dart';
import 'package:avanzza/presentation/widgets/bootstrap/access_gateway_banner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('decideAccessBanner — special gateway states', () {
    test('Blocked siempre HIDDEN (overlay aparte se encarga)', () {
      // Aunque el snapshot esté en cualquier estado, el banner inline NO
      // muestra nada cuando el gateway está Blocked — lo cubre el overlay
      // full-screen separado.
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayBlocked(_dummyContext),
        freshness: AccessBannerFreshness.fresh,
        syncStatus: AccessSyncStatus.confirmed,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test('RequiresWorkspaceSelection ⇒ infoSelect', () {
      final decision = decideAccessBanner(
        gatewayState:
            const AccessGatewayRequiresWorkspaceSelection(_dummyContext),
        freshness: AccessBannerFreshness.none,
        syncStatus: null,
      );
      expect(decision, AccessBannerDecision.infoSelect);
    });
  });

  group('decideAccessBanner — sin snapshot', () {
    test('gateway Error + sin snapshot ⇒ hardError', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayError('boom'),
        freshness: AccessBannerFreshness.none,
        syncStatus: null,
      );
      expect(decision, AccessBannerDecision.hardError);
    });

    test('gateway Ready + sin snapshot ⇒ hidden', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayReady(_dummyContext),
        freshness: AccessBannerFreshness.none,
        syncStatus: null,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test('gateway Loading + sin snapshot ⇒ hidden', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayLoading(),
        freshness: AccessBannerFreshness.none,
        syncStatus: null,
      );
      expect(decision, AccessBannerDecision.hidden);
    });
  });

  group('decideAccessBanner — snapshot fresco (regla canónica V2.1 cierre)',
      () {
    test('fresh + gateway Ready + confirmed ⇒ hidden', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayReady(_dummyContext),
        freshness: AccessBannerFreshness.fresh,
        syncStatus: AccessSyncStatus.confirmed,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test(
        'fresh + gateway Error + syncFailed ⇒ HIDDEN '
        '(silencio aunque haya fallado refresh)', () {
      // El test crítico del fix UX V2.1: cuando local-first puede operar
      // (cache fresh), el ruido del refresh fallido NO se muestra.
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayError('network down'),
        freshness: AccessBannerFreshness.fresh,
        syncStatus: AccessSyncStatus.syncFailed,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test(
        'fresh + gateway Error + pendingSync ⇒ HIDDEN '
        '(onboarding offline reciente, snapshot todavía operativo)', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayError('timeout'),
        freshness: AccessBannerFreshness.fresh,
        syncStatus: AccessSyncStatus.pendingSync,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test('fresh + gateway Loading + cualquier syncStatus ⇒ HIDDEN', () {
      for (final status in AccessSyncStatus.values) {
        final decision = decideAccessBanner(
          gatewayState: const AccessGatewayLoading(),
          freshness: AccessBannerFreshness.fresh,
          syncStatus: status,
        );
        expect(decision, AccessBannerDecision.hidden,
            reason: 'syncStatus=${status.name} debería seguir HIDDEN '
                'cuando el cache es fresh');
      }
    });
  });

  group('decideAccessBanner — snapshot stale (24-72h)', () {
    test('stale + gateway Ready ⇒ hidden (refresh OK reciente)', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayReady(_dummyContext),
        freshness: AccessBannerFreshness.stale,
        syncStatus: AccessSyncStatus.confirmed,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test('stale + gateway Idle ⇒ hidden', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayIdle(),
        freshness: AccessBannerFreshness.stale,
        syncStatus: AccessSyncStatus.confirmed,
      );
      expect(decision, AccessBannerDecision.hidden);
    });

    test('stale + gateway Error + pendingSync ⇒ softPending', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayError('boom'),
        freshness: AccessBannerFreshness.stale,
        syncStatus: AccessSyncStatus.pendingSync,
      );
      expect(decision, AccessBannerDecision.softPending);
    });

    test('stale + gateway Error + syncFailed ⇒ softFailed', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayError('boom'),
        freshness: AccessBannerFreshness.stale,
        syncStatus: AccessSyncStatus.syncFailed,
      );
      expect(decision, AccessBannerDecision.softFailed);
    });

    test(
        'stale + gateway Loading + confirmed ⇒ softFailed '
        '(la última confirmación está envejeciendo y el refresh actual '
        'sigue sin progresar)', () {
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayLoading(),
        freshness: AccessBannerFreshness.stale,
        syncStatus: AccessSyncStatus.confirmed,
      );
      expect(decision, AccessBannerDecision.softFailed);
    });
  });

  group('decideAccessBanner — snapshot críticamente stale (>72h)', () {
    test('crit-stale + gateway Ready ⇒ softCriticallyStale', () {
      // Aunque el gateway esté Ready en este instante, el cache previo es
      // tan viejo que la advertencia se mantiene hasta que la próxima
      // confirmación renueve fetchedAt y baje el bucket.
      final decision = decideAccessBanner(
        gatewayState: const AccessGatewayReady(_dummyContext),
        freshness: AccessBannerFreshness.criticallyStale,
        syncStatus: AccessSyncStatus.confirmed,
      );
      expect(decision, AccessBannerDecision.softCriticallyStale);
    });

    test('crit-stale + gateway Error + cualquier syncStatus ⇒ softCriticallyStale',
        () {
      for (final status in AccessSyncStatus.values) {
        final decision = decideAccessBanner(
          gatewayState: const AccessGatewayError('boom'),
          freshness: AccessBannerFreshness.criticallyStale,
          syncStatus: status,
        );
        expect(decision, AccessBannerDecision.softCriticallyStale,
            reason: 'crit-stale siempre softCriticallyStale; '
                'syncStatus=${status.name}');
      }
    });
  });
}

// AccessContext mínimo válido para construir estados Ready/Blocked/etc en los
// tests. El decisor del banner no inspecciona su contenido; solo necesita
// que el tipo case-match correcto. Si el constructor cambia su firma, este
// const fallará y forzará actualizar el test.
const AccessContext _dummyContext = AccessContext(
  isProvisioned: false,
  user: null,
  activeOrgId: null,
  activeWorkspace: null,
  membership: null,
  capabilities: <String>[],
  requiresAction: RequiresAction.none,
  requiresTokenRefresh: false,
);
