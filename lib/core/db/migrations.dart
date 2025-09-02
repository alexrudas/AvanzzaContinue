import 'package:isar_community/isar.dart';

// Increase when breaking Isar schema changes are introduced
const int schemaVersion = 1;

typedef MigrationStep = Future<void> Function(Isar isar);

final List<MigrationStep> _migrations = <MigrationStep>[
  // Add migration steps here as needed. No-ops for now.
  (isar) async {},
];

Future<void> runMigrations(Isar isar) async {
  for (final m in _migrations) {
    await m(isar);
  }
}
