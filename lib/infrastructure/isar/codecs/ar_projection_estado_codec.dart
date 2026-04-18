// ============================================================================
// lib/infrastructure/isar/codecs/ar_projection_estado_codec.dart
// AR PROJECTION ESTADO CODEC — Única fuente de verdad enum ↔ string
//
// QUÉ HACE:
// - Encode/decode entre ARProjectionEstado (dominio) y su string canónico
//   persistido en Isar (`'abierta' | 'cerrada' | 'ajustada'`).
// - Reemplaza al getter prohibido `.wire` y a la extensión `fromWire` del
//   dominio (DOMAIN_CONTRACTS.md v1.1.3 §C).
//
// QUÉ NO HACE:
// - No se importa desde el dominio.
// - No hace tolerancia de casing/espacios; los valores persistidos son
//   deterministas y cualquier valor no canónico es corrupción.
//
// PRINCIPIOS:
// - Single source of truth del mapping enum ↔ string para toda la app.
// - Strings legacy preservados literalmente para compatibilidad con datos
//   ya escritos en Isar.
// - Fail-hard en decode (mismo contrato que `ARProjectionEstadoX.fromWire`).
// ============================================================================

import '../../../domain/entities/accounting/account_receivable_projection.dart';

abstract final class ARProjectionEstadoCodec {
  ARProjectionEstadoCodec._();

  static const String _abiertaWire = 'abierta';
  static const String _cerradaWire = 'cerrada';
  static const String _ajustadaWire = 'ajustada';

  /// Enum de dominio → string canónico para persistencia Isar.
  static String encode(ARProjectionEstado value) {
    switch (value) {
      case ARProjectionEstado.abierta:
        return _abiertaWire;
      case ARProjectionEstado.cerrada:
        return _cerradaWire;
      case ARProjectionEstado.ajustada:
        return _ajustadaWire;
    }
  }

  /// String persistido → enum de dominio.
  /// Lanza [FormatException] ante valores desconocidos.
  static ARProjectionEstado decode(String wire) {
    switch (wire) {
      case _abiertaWire:
        return ARProjectionEstado.abierta;
      case _cerradaWire:
        return ARProjectionEstado.cerrada;
      case _ajustadaWire:
        return ARProjectionEstado.ajustada;
      default:
        throw FormatException('ARProjectionEstado invalid: $wire');
    }
  }

  /// Helper para validar sin lanzar.
  static bool isValid(String wire) =>
      wire == _abiertaWire ||
      wire == _cerradaWire ||
      wire == _ajustadaWire;
}
