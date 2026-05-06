// ============================================================================
// lib/data/sources/remote/core_common/nestjs_exceptions.dart
// NESTJS EXCEPTIONS — Re-export desde el dominio (compat)
// ============================================================================
// Los tipos canónicos viven ahora en `lib/domain/errors/remote_exceptions.dart`
// para respetar Clean Architecture (presentation puede importar de domain,
// no de data). Este archivo permanece como re-export por compatibilidad con
// callers existentes en `data/` y `test/` que importaban desde aquí.
//
// Migración recomendada para callers nuevos: importar directamente desde
// `../../../domain/errors/remote_exceptions.dart`.
// ============================================================================

export '../../../../domain/errors/remote_exceptions.dart';
