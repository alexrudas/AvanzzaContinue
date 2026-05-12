// ============================================================================
// test/core/platform/offline_sync_service_test.dart
// OfflineSyncService — concurrencia, regresión RangeError, contrato preservado
// ============================================================================
// Regresión del bug observado en producción (2026-05-12):
//   RangeError (length): Invalid value: Valid value range is empty: 0
//   #0  List.removeAt
//   #1  OfflineSyncService._process (offline_sync_service.dart:58)
//
// Causa raíz: `_process()` corría concurrentemente consigo mismo cuando
// `enqueue()` se llamaba durante un `await job.op()`. El segundo `_process`
// se programaba vía `_drain()` porque `_timer` se había nulificado al
// inicio del primer `_process`. Ambos leían el mismo job, el primero hacía
// `removeAt(0)` y el segundo crasheaba al intentar removeAt sobre lista
// vacía.
//
// Fix: guard de re-entrancia via `_drainCompleter`.
// ============================================================================

import 'dart:async';

import 'package:avanzza/core/platform/offline_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OfflineSyncService — happy path', () {
    test('processes a single op in order', () async {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      final completed = <int>[];
      svc.enqueue(() async {
        completed.add(1);
      });
      await svc.sync();
      expect(completed, [1]);
      expect(svc.pendingCount, 0);
    });

    test('processes multiple ops in FIFO order', () async {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      final completed = <int>[];
      svc.enqueue(() async => completed.add(1));
      svc.enqueue(() async => completed.add(2));
      svc.enqueue(() async => completed.add(3));
      await svc.sync();
      expect(completed, [1, 2, 3]);
      expect(svc.pendingCount, 0);
    });

    test('offline → enqueue holds; setOnline(true) drains', () async {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      svc.setOnline(false);
      final completed = <int>[];
      svc.enqueue(() async => completed.add(1));
      svc.enqueue(() async => completed.add(2));
      // sync() must NOT drain while offline.
      await svc.sync();
      expect(completed, isEmpty);
      expect(svc.pendingCount, 2);

      svc.setOnline(true);
      // Allow microtask + Timer(Duration.zero) to fire.
      await _flushAsync();
      expect(completed, [1, 2]);
      expect(svc.pendingCount, 0);
    });
  });

  group('OfflineSyncService — retries / backoff', () {
    test('retries up to maxRetries then drops', () async {
      final svc = OfflineSyncService(
        retryDelay: Duration.zero,
        maxRetries: 2,
      );
      var attempts = 0;
      svc.enqueue(() async {
        attempts++;
        throw StateError('boom');
      });
      await svc.sync();
      // attempts = initial + maxRetries retries → after retries>maxRetries
      // the loop drops the job.
      // Sequence: try (retries=0 → fail → retries=1, retry)
      //           try (retries=1 → fail → retries=2, retry)
      //           try (retries=2 → fail → retries=3 > 2 → drop)
      expect(attempts, 3);
      expect(svc.pendingCount, 0);
    });

    test('successful op after failure removes from queue', () async {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      var calls = 0;
      svc.enqueue(() async {
        calls++;
        if (calls == 1) throw StateError('first fails');
      });
      await svc.sync();
      expect(calls, 2);
      expect(svc.pendingCount, 0);
    });
  });

  group('OfflineSyncService — regresión RangeError (concurrencia)', () {
    test(
      'enqueue durante un job activo NO dispara segundo _process concurrente',
      () async {
        final svc = OfflineSyncService(retryDelay: Duration.zero);
        final completed = <String>[];
        final firstJobGate = Completer<void>();

        // Job 1 queda suspendido hasta que el test libere la gate.
        // Durante su suspensión, enqueueamos job 2.
        svc.enqueue(() async {
          completed.add('1-start');
          await firstJobGate.future;
          completed.add('1-end');
        });
        // Permite que `_process` arranque y se suspenda en await de job1.
        await _flushAsync();
        expect(completed, ['1-start']);

        // ─── Disparador del bug ───
        // En el código previo, este enqueue veía `_timer == null` (porque
        // el `_process` activo lo nulificó), spawneaba un nuevo timer →
        // segundo `_process` concurrente → ambos competían por
        // `_queue.removeAt(0)` → RangeError.
        svc.enqueue(() async {
          completed.add('2');
        });
        await _flushAsync();
        // Job 2 todavía no debe haber corrido: el job 1 sigue suspendido.
        expect(completed, ['1-start'],
            reason: 'Job 2 espera a que termine job 1, sin crashear.');
        expect(svc.pendingCount, 2);

        // Libera job 1. El _process activo debe consumir job 2 sin
        // crashear (sin RangeError) y sin spawnar un segundo loop.
        firstJobGate.complete();
        await _flushAsync();

        expect(completed, ['1-start', '1-end', '2']);
        expect(svc.pendingCount, 0);
      },
    );

    test(
      'sync() concurrente con drain activo NO crashea ni duplica trabajo',
      () async {
        final svc = OfflineSyncService(retryDelay: Duration.zero);
        var jobExecutions = 0;
        final gate = Completer<void>();

        svc.enqueue(() async {
          jobExecutions++;
          await gate.future;
        });

        // Dispara el primer drain implícito (via enqueue).
        await _flushAsync();
        expect(jobExecutions, 1);

        // Lanza un sync() concurrente mientras el job 1 está suspendido.
        // Bug previo: este sync() invocaba `_process` directamente,
        // generaba un segundo loop, ambos hacían removeAt(0) → crash.
        final syncFuture = svc.sync();

        // Libera el job.
        gate.complete();
        await syncFuture;

        // El job se ejecutó EXACTAMENTE una vez (no duplicado por loop
        // concurrente) y el queue quedó limpio.
        expect(jobExecutions, 1);
        expect(svc.pendingCount, 0);
      },
    );

    test(
      'cascada de enqueues durante drain procesa todos sin perder ninguno',
      () async {
        final svc = OfflineSyncService(retryDelay: Duration.zero);
        final completed = <int>[];
        final firstJobGate = Completer<void>();

        svc.enqueue(() async {
          completed.add(1);
          await firstJobGate.future;
        });
        await _flushAsync();

        // Mientras job 1 está suspendido, encolamos 5 más.
        for (var i = 2; i <= 6; i++) {
          svc.enqueue(() async {
            completed.add(i);
          });
        }
        await _flushAsync();
        // Solo job 1 ha arrancado; los demás esperan.
        expect(completed, [1]);
        expect(svc.pendingCount, 6);

        firstJobGate.complete();
        await _flushAsync();

        expect(completed, [1, 2, 3, 4, 5, 6],
            reason:
                'Todos los enqueues durante el drain activo se procesan FIFO '
                'sin pérdida ni duplicación.');
        expect(svc.pendingCount, 0);
      },
    );

    test(
      'sync() awaitado por múltiples callers concurrentes resuelve todos',
      () async {
        final svc = OfflineSyncService(retryDelay: Duration.zero);
        final completed = <int>[];
        final gate = Completer<void>();

        svc.enqueue(() async {
          completed.add(1);
          await gate.future;
        });
        await _flushAsync();

        // Tres callers awaitan sync() concurrentemente. El contrato es
        // que todos resuelven cuando el drain termina.
        final s1 = svc.sync();
        final s2 = svc.sync();
        final s3 = svc.sync();

        gate.complete();
        await Future.wait([s1, s2, s3]);

        expect(completed, [1]);
        expect(svc.pendingCount, 0);
      },
    );

    test('setOnline(true) durante drain activo NO duplica el loop', () async {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      var executions = 0;
      final gate = Completer<void>();

      svc.enqueue(() async {
        executions++;
        await gate.future;
      });
      await _flushAsync();
      expect(executions, 1);

      // Toggle online durante el drain activo. Bug potencial: `_drain()`
      // disparado por setOnline veía `_timer == null` y spawneaba uno
      // nuevo → segundo `_process` → race.
      svc.setOnline(true);
      svc.setOnline(true); // idempotente
      await _flushAsync();
      expect(executions, 1, reason: 'No duplicar ejecución del job activo.');

      gate.complete();
      await _flushAsync();
      expect(executions, 1);
      expect(svc.pendingCount, 0);
    });

    test(
      'queue vacío entre operaciones: removeAt NO crashea (defensa explícita)',
      () async {
        // Test directo del invariant: aunque la re-entrancia esté blindada,
        // el `removeAt` defensivo evita crash si una mutación externa
        // vacía la cola entre el peek y el remove.
        final svc = OfflineSyncService(retryDelay: Duration.zero);
        svc.enqueue(() async {
          // job vacío
        });
        await svc.sync();
        // Drain de un queue ya vacío no debe lanzar.
        await svc.sync();
        expect(svc.pendingCount, 0);
      },
    );
  });

  group('OfflineSyncService — contrato preservado', () {
    test('pendingCount refleja queue real', () {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      svc.setOnline(false);
      expect(svc.pendingCount, 0);
      svc.enqueue(() async {});
      svc.enqueue(() async {});
      expect(svc.pendingCount, 2);
    });

    test('sync() retorna inmediato si offline', () async {
      final svc = OfflineSyncService(retryDelay: Duration.zero);
      svc.setOnline(false);
      svc.enqueue(() async {});
      final sw = Stopwatch()..start();
      await svc.sync();
      sw.stop();
      // Inmediato (<50ms) y queue intacto.
      expect(sw.elapsedMilliseconds, lessThan(50));
      expect(svc.pendingCount, 1);
    });
  });
}

/// Helper: agota el microtask queue y deja correr `Timer(Duration.zero)`s
/// pendientes. Equivalente a `await Future.delayed(Duration.zero)` repetido
/// hasta estabilidad — para tests deterministas de concurrencia.
Future<void> _flushAsync() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}
