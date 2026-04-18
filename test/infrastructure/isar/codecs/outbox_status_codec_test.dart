// ============================================================================
// test/infrastructure/isar/codecs/outbox_status_codec_test.dart
// Único lugar que valida el mapping enum ↔ string de OutboxStatus.
// Cualquier cambio aquí DEBE ser considerado una ruptura de datos persistidos.
// ============================================================================

import 'package:avanzza/domain/entities/accounting/outbox_event.dart';
import 'package:avanzza/infrastructure/isar/codecs/outbox_status_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OutboxStatusCodec.encode', () {
    test('OutboxStatus.pending → "pending"', () {
      expect(OutboxStatusCodec.encode(OutboxStatus.pending), 'pending');
    });

    test('OutboxStatus.synced → "synced"', () {
      expect(OutboxStatusCodec.encode(OutboxStatus.synced), 'synced');
    });

    test('OutboxStatus.error → "error"', () {
      expect(OutboxStatusCodec.encode(OutboxStatus.error), 'error');
    });

    test('exhaustividad: todo valor del enum tiene encode no vacío', () {
      for (final v in OutboxStatus.values) {
        final wire = OutboxStatusCodec.encode(v);
        expect(wire, isNotEmpty,
            reason: 'encode($v) debe producir un String no vacío');
      }
    });
  });

  group('OutboxStatusCodec.decode', () {
    test('"pending" → OutboxStatus.pending', () {
      expect(OutboxStatusCodec.decode('pending'), OutboxStatus.pending);
    });

    test('"synced" → OutboxStatus.synced', () {
      expect(OutboxStatusCodec.decode('synced'), OutboxStatus.synced);
    });

    test('"error" → OutboxStatus.error', () {
      expect(OutboxStatusCodec.decode('error'), OutboxStatus.error);
    });

    test('string vacío → FormatException (fail-hard, sin fallback)', () {
      expect(() => OutboxStatusCodec.decode(''), throwsFormatException);
    });

    test('valor desconocido → FormatException', () {
      expect(
          () => OutboxStatusCodec.decode('done'), throwsFormatException);
      expect(() => OutboxStatusCodec.decode('abierta'),
          throwsFormatException);
    });

    test('es case-sensitive: "PENDING" no es válido', () {
      expect(() => OutboxStatusCodec.decode('PENDING'),
          throwsFormatException);
    });

    test('rechaza espacios al lado (sin tolerancia implícita)', () {
      expect(() => OutboxStatusCodec.decode(' pending'),
          throwsFormatException);
      expect(() => OutboxStatusCodec.decode('pending '),
          throwsFormatException);
    });
  });

  group('OutboxStatusCodec.isValid', () {
    test('los 3 valores legacy son válidos', () {
      expect(OutboxStatusCodec.isValid('pending'), isTrue);
      expect(OutboxStatusCodec.isValid('synced'), isTrue);
      expect(OutboxStatusCodec.isValid('error'), isTrue);
    });

    test('rechaza string vacío, casing distinto y valores ajenos', () {
      expect(OutboxStatusCodec.isValid(''), isFalse);
      expect(OutboxStatusCodec.isValid('PENDING'), isFalse);
      expect(OutboxStatusCodec.isValid('pendiente'), isFalse);
      expect(OutboxStatusCodec.isValid('abierta'), isFalse);
    });
  });

  group('round-trip encode → decode (SSOT)', () {
    test('identidad para todos los valores', () {
      for (final v in OutboxStatus.values) {
        expect(OutboxStatusCodec.decode(OutboxStatusCodec.encode(v)), v);
      }
    });
  });

  group('contract: strings legacy inmutables', () {
    // Este test congela los strings que Isar ya tiene persistidos en dev/prod.
    // Cualquier cambio aquí implicaría migración de datos.
    test('set exacto de strings wire = {pending, synced, error}', () {
      final wire = {
        for (final v in OutboxStatus.values) OutboxStatusCodec.encode(v),
      };
      expect(wire, {'pending', 'synced', 'error'});
    });
  });
}
