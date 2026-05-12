import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeForSearch — casos base ES/CO', () {
    test('texto plano sin transformaciones', () {
      expect(normalizeForSearch('Autokorea'), 'autokorea');
    });

    test('mayúsculas + puntuación de razón social', () {
      expect(normalizeForSearch('Auto Korea S.A.S.'), 'auto korea sas');
    });

    test('frase con espacios simples', () {
      expect(
        normalizeForSearch('Lubricantes y Aceites'),
        'lubricantes y aceites',
      );
    });
  });

  group('normalizeForSearch — política ñ tolerante', () {
    test('"Peña" → "pena" (ñ se mapea a n)', () {
      expect(normalizeForSearch('Peña'), 'pena');
    });

    test('búsqueda "pena" matchea displayNameNormalized de "Peña Motors"', () {
      final indexed = normalizeForSearch('Peña Motors');
      final query = normalizeForSearch('pena');
      expect(indexed, 'pena motors');
      expect(indexed.contains(query), isTrue);
    });

    test('búsqueda "peña" también matchea (ambas normalizan igual)', () {
      final indexed = normalizeForSearch('Peña Motors');
      final query = normalizeForSearch('peña');
      expect(indexed.contains(query), isTrue);
    });

    test('"Niño" → "nino"', () {
      expect(normalizeForSearch('Niño'), 'nino');
    });

    test('búsqueda "nino" matchea "Niño Repuestos"', () {
      final indexed = normalizeForSearch('Niño Repuestos');
      final query = normalizeForSearch('nino');
      expect(indexed, 'nino repuestos');
      expect(indexed.contains(query), isTrue);
    });
  });

  group('normalizeForSearch — diacríticos generales', () {
    test('acentos agudos', () {
      expect(normalizeForSearch('Café'), 'cafe');
      expect(normalizeForSearch('José Ángel Núñez'), 'jose angel nunez');
    });

    test('diéresis', () {
      expect(normalizeForSearch('Müller'), 'muller');
    });

    test('combo completo: tildes + ñ + mayúsculas + puntuación', () {
      expect(normalizeForSearch('PEÑA & NIÑO S.A.'), 'pena nino sa');
    });
  });

  group('normalizeForSearch — espacios y puntuación', () {
    test('collapse de espacios múltiples + trim externo', () {
      expect(normalizeForSearch('  Hola   Mundo  '), 'hola mundo');
    });

    test('puntuación en mitad de palabra se elimina (sin generar espacio)', () {
      expect(normalizeForSearch('Taller 24/7'), 'taller 247');
    });

    test('guiones y underscores se eliminan', () {
      expect(normalizeForSearch('AB-Corp_2024'), 'abcorp2024');
    });

    test('emojis y símbolos no-latinos se strippean como puntuación', () {
      expect(normalizeForSearch('Taller 🔧 Express!'), 'taller express');
    });
  });

  group('normalizeForSearch — edge cases', () {
    test('string vacía → string vacía', () {
      expect(normalizeForSearch(''), '');
    });

    test('solo whitespace → string vacía', () {
      expect(normalizeForSearch('   '), '');
    });

    test('solo puntuación → string vacía', () {
      expect(normalizeForSearch('.,;:!?'), '');
    });

    test('dígitos puros se preservan', () {
      expect(normalizeForSearch('2024'), '2024');
    });

    test('mezcla letras + dígitos preserva ambos', () {
      expect(normalizeForSearch('Taller2024'), 'taller2024');
    });
  });

  group('normalizeForSearch — propiedades', () {
    test('idempotente: normalize(normalize(x)) == normalize(x)', () {
      const samples = [
        'Peña Motors',
        'Auto Korea S.A.S.',
        '  Hola   Mundo  ',
        'José Ángel Núñez',
        'PEÑA & NIÑO S.A.',
        '',
      ];
      for (final s in samples) {
        final once = normalizeForSearch(s);
        final twice = normalizeForSearch(once);
        expect(twice, once, reason: 'no idempotente para "$s"');
      }
    });

    test('determinista: misma entrada → misma salida', () {
      final a = normalizeForSearch('Peña & Niño S.A.');
      final b = normalizeForSearch('Peña & Niño S.A.');
      expect(a, b);
    });

    test('salida nunca contiene caracteres fuera de [a-z0-9 ]', () {
      const samples = [
        'PEÑA & NIÑO S.A.',
        'Café Müller',
        'Taller 24/7 — Express!',
        'AB-Corp_2024',
        'José Ángel Núñez',
      ];
      final allowed = RegExp(r'^[a-z0-9 ]*$');
      for (final s in samples) {
        final out = normalizeForSearch(s);
        expect(
          allowed.hasMatch(out),
          isTrue,
          reason: 'salida inválida para "$s": "$out"',
        );
      }
    });
  });
}
