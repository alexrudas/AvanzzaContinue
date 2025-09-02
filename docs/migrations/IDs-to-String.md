# Migration: IDs to String

Decision: All business IDs in domain and data models are String.

Rationale:
- Web/JS number precision issues (safe integer limit ~ 2^53-1) make numeric IDs unsafe.
- Firestore doc IDs are strings; aligning simplifies client/server interoperability.
- Human-readable IDs ease debugging and logs.

Isar guideline:
- Persist an auto-increment primary key for Isar using `@Id()` int? isarId.
- Keep a unique indexed `id: String` field for the business identifier.
- Import rule for Isar models: always `import 'package:isar_community/isar.dart';` (or your chosen isar package variant).

Implementation notes:
- Domain entities use `String id`.
- Data models:
  - `@Id()` int? isarId
  - `@Index(unique: true, replace: true)` on `id: String`

Regeneration steps:
1. Run code generation:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
2. Run tests:
```
flutter test
```

Backward compatibility:
- When reading legacy Firestore documents with numeric IDs, cast or stringify to String before using in models:
  - Example: `final id = '${raw['id']}'`.
- Consider a one-time migration function for legacy datasets.
