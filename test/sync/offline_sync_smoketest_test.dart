import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OfflineSyncService smoke test', () {
    test('simulated airplane mode then reconnect cleans queue (skipped)', () async {
      // This project scaffolds OfflineSyncService but repositories do not yet enqueue jobs.
      // A proper integration test would:
      // 1) Mock remote DS to throw
      // 2) Call repository.upsert... which enqueues into OfflineSyncService
      // 3) Assert pending jobs exist
      // 4) Flip connectivity to online and call sync()
      // 5) Assert queue empty
      // Skipping until enqueue is wired.
      expect(true, isTrue);
    }, skip: 'Repositories not yet wiring OfflineSyncService.enqueue; placeholder smoke test');
  });
}
