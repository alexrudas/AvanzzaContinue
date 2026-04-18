// ============================================================================
// lib/infrastructure/isar/codecs/outbox_status_codec.dart
// OUTBOX STATUS CODEC — Única fuente de verdad enum ↔ string para persistencia
//
// QUÉ HACE:
// - Encode/decode estable entre OutboxStatus (dominio) y su representación
//   string canónica persistida en Isar (`'pending' | 'synced' | 'error'`).
// - Reemplaza al getter prohibido `.wire` y a la extensión `fromWire` del
//   dominio. DOMAIN_CONTRACTS.md v1.1.3 §C prohíbe usar `.wire`/`.wireName`
//   como contrato de persistencia; este codec es el único lugar donde el
//   mapping existe.
//
// QUÉ NO HACE:
// - No se importa desde el dominio (violaría la dirección de dependencias).
// - No expone los strings a través de getters sobre el enum. El mapping
//   vive únicamente aquí.
//
// PRINCIPIOS:
// - Single source of truth: cualquier callsite (mapper, repo, query Isar)
//   debe usar este codec. Si el mapping cambia alguna vez, se cambia aquí
//   y solo aquí.
// - Strings legacy preservados literalmente para compatibilidad con datos
//   ya persistidos (sin migración de schema/datos).
// - Fail-hard en decode ante valores desconocidos (preserva la semántica
//   histórica de `OutboxStatusX.fromWire`).
// ============================================================================

import '../../../domain/entities/accounting/outbox_event.dart';

abstract final class OutboxStatusCodec {
  OutboxStatusCodec._();

  // Strings wire legacy (idénticos a los ya persistidos en Isar). Privados:
  // no se exponen hacia afuera para forzar el uso de encode/decode/isValid.
  static const String _pendingWire = 'pending';
  static const String _syncedWire = 'synced';
  static const String _errorWire = 'error';

  /// Enum de dominio → string canónico para persistencia Isar/queries.
  static String encode(OutboxStatus value) {
    switch (value) {
      case OutboxStatus.pending:
        return _pendingWire;
      case OutboxStatus.synced:
        return _syncedWire;
      case OutboxStatus.error:
        return _errorWire;
    }
  }

  /// String persistido → enum de dominio.
  /// Lanza [FormatException] ante valores desconocidos (mismo contrato que
  /// la extensión legacy `OutboxStatusX.fromWire` que este codec reemplaza).
  static OutboxStatus decode(String wire) {
    switch (wire) {
      case _pendingWire:
        return OutboxStatus.pending;
      case _syncedWire:
        return OutboxStatus.synced;
      case _errorWire:
        return OutboxStatus.error;
      default:
        throw FormatException('OutboxStatus invalid: $wire');
    }
  }

  /// Helper para validar un wire string sin lanzar. Útil para guards que
  /// quieran reportar corrupción con su propio mensaje.
  static bool isValid(String wire) =>
      wire == _pendingWire || wire == _syncedWire || wire == _errorWire;
}
