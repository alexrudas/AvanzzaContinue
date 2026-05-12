// ============================================================================
// lib/data/adapters/capability/legacy_migration_warning.dart
// SHIM — re-exporta los tipos canónicos desde domain.
// ============================================================================
// Los value objects (`LegacyMigrationWarningKind`, `LegacyMigrationWarning`,
// `LegacyParseResult`, `LegacyParseException`) viven en
// `lib/domain/value/migration/legacy_migration_warning.dart` desde 2026-05.
// Este archivo se mantiene como re-export para preservar backward-compat
// con call-sites existentes que importaban del path data layer.
//
// Para código nuevo: importar directamente del path canónico domain.
// ============================================================================

export '../../../domain/value/migration/legacy_migration_warning.dart';
