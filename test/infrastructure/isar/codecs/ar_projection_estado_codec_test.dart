// ============================================================================
// test/infrastructure/isar/codecs/ar_projection_estado_codec_test.dart
// Único lugar que valida el mapping enum ↔ string de ARProjectionEstado.
// Cualquier cambio aquí DEBE ser considerado ruptura de datos persistidos.
// ============================================================================

import 'package:avanzza/domain/entities/accounting/account_receivable_projection.dart';
import 'package:avanzza/infrastructure/isar/codecs/ar_projection_estado_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARProjectionEstadoCodec.encode', () {
    test('ARProjectionEstado.abierta → "abierta"', () {
      expect(ARProjectionEstadoCodec.encode(ARProjectionEstado.abierta),
          'abierta');
    });

    test('ARProjectionEstado.cerrada → "cerrada"', () {
      expect(ARProjectionEstadoCodec.encode(ARProjectionEstado.cerrada),
          'cerrada');
    });

    test('ARProjectionEstado.ajustada → "ajustada"', () {
      expect(ARProjectionEstadoCodec.encode(ARProjectionEstado.ajustada),
          'ajustada');
    });

    test('exhaustividad: todo valor del enum tiene encode no vacío', () {
      for (final v in ARProjectionEstado.values) {
        final wire = ARProjectionEstadoCodec.encode(v);
        expect(wire, isNotEmpty);
      }
    });
  });

  group('ARProjectionEstadoCodec.decode', () {
    test('"abierta" → ARProjectionEstado.abierta', () {
      expect(ARProjectionEstadoCodec.decode('abierta'),
          ARProjectionEstado.abierta);
    });

    test('"cerrada" → ARProjectionEstado.cerrada', () {
      expect(ARProjectionEstadoCodec.decode('cerrada'),
          ARProjectionEstado.cerrada);
    });

    test('"ajustada" → ARProjectionEstado.ajustada', () {
      expect(ARProjectionEstadoCodec.decode('ajustada'),
          ARProjectionEstado.ajustada);
    });

    test('string vacío → FormatException', () {
      expect(() => ARProjectionEstadoCodec.decode(''),
          throwsFormatException);
    });

    test('valor desconocido → FormatException', () {
      expect(() => ARProjectionEstadoCodec.decode('open'),
          throwsFormatException);
      expect(() => ARProjectionEstadoCodec.decode('pending'),
          throwsFormatException);
    });

    test('es case-sensitive: "ABIERTA" no es válido', () {
      expect(() => ARProjectionEstadoCodec.decode('ABIERTA'),
          throwsFormatException);
    });

    test('rechaza espacios al lado', () {
      expect(() => ARProjectionEstadoCodec.decode(' abierta'),
          throwsFormatException);
      expect(() => ARProjectionEstadoCodec.decode('abierta '),
          throwsFormatException);
    });
  });

  group('ARProjectionEstadoCodec.isValid', () {
    test('los 3 valores legacy son válidos', () {
      expect(ARProjectionEstadoCodec.isValid('abierta'), isTrue);
      expect(ARProjectionEstadoCodec.isValid('cerrada'), isTrue);
      expect(ARProjectionEstadoCodec.isValid('ajustada'), isTrue);
    });

    test('rechaza string vacío, casing distinto y valores ajenos', () {
      expect(ARProjectionEstadoCodec.isValid(''), isFalse);
      expect(ARProjectionEstadoCodec.isValid('ABIERTA'), isFalse);
      expect(ARProjectionEstadoCodec.isValid('open'), isFalse);
      expect(ARProjectionEstadoCodec.isValid('pending'), isFalse);
    });
  });

  group('round-trip encode → decode (SSOT)', () {
    test('identidad para todos los valores', () {
      for (final v in ARProjectionEstado.values) {
        expect(
            ARProjectionEstadoCodec.decode(
                ARProjectionEstadoCodec.encode(v)),
            v);
      }
    });
  });

  group('contract: strings legacy inmutables', () {
    test('set exacto de strings wire = {abierta, cerrada, ajustada}', () {
      final wire = {
        for (final v in ARProjectionEstado.values)
          ARProjectionEstadoCodec.encode(v),
      };
      expect(wire, {'abierta', 'cerrada', 'ajustada'});
    });
  });
}
