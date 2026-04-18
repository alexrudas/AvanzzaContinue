// ============================================================================
// test/domain/services/core_common/key_normalizer_test.dart
// KEY NORMALIZER — Tests (F4.a)
// ============================================================================

import 'package:avanzza/domain/services/core_common/key_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizePhoneE164', () {
    test('input con + y espacios → E.164 limpio', () {
      expect(
        normalizePhoneE164('+57 300 123 4567', defaultCountryCallingCode: '57'),
        '+573001234567',
      );
    });

    test('input con + y paréntesis + guiones → E.164 limpio', () {
      expect(
        normalizePhoneE164('(+57) 300-123-4567',
            defaultCountryCallingCode: '57'),
        '+573001234567',
      );
    });

    test('input sin + usa defaultCountryCallingCode', () {
      expect(
        normalizePhoneE164('300 123 4567', defaultCountryCallingCode: '57'),
        '+573001234567',
      );
    });

    test('input vacío → null', () {
      expect(
        normalizePhoneE164('', defaultCountryCallingCode: '57'),
        isNull,
      );
    });

    test('input demasiado corto (< 8 dígitos) → null', () {
      expect(
        normalizePhoneE164('123', defaultCountryCallingCode: '57'),
        isNull,
      );
    });

    test('input demasiado largo (> 15 dígitos) → null', () {
      expect(
        normalizePhoneE164('+1234567890123456',
            defaultCountryCallingCode: '57'),
        isNull,
      );
    });

    test('sin + y sin defaultCC → null', () {
      expect(
        normalizePhoneE164('3001234567', defaultCountryCallingCode: ''),
        isNull,
      );
    });

    test('defaultCC con caracteres no-dígito se limpia', () {
      expect(
        normalizePhoneE164('3001234567', defaultCountryCallingCode: '+57'),
        '+573001234567',
      );
    });

    test('determinístico: misma entrada → misma salida', () {
      final a =
          normalizePhoneE164('+57 300 123 4567', defaultCountryCallingCode: '57');
      final b = normalizePhoneE164('+57(300)123-4567',
          defaultCountryCallingCode: '57');
      expect(a, b);
    });
  });

  group('normalizeEmail', () {
    test('trim + lowercase', () {
      expect(normalizeEmail(' Juan@ACME.co  '), 'juan@acme.co');
    });

    test('input sin @ → null', () {
      expect(normalizeEmail('juan acme.co'), isNull);
    });

    test('input con espacios internos → null', () {
      expect(normalizeEmail('juan @acme.co'), isNull);
    });

    test('input sin TLD (.algo) → null', () {
      expect(normalizeEmail('juan@acme'), isNull);
    });

    test('input vacío → null', () {
      expect(normalizeEmail(''), isNull);
    });

    test('múltiples @ → null', () {
      expect(normalizeEmail('juan@@acme.co'), isNull);
    });
  });

  group('normalizeDocId', () {
    test('solo dígitos se preservan', () {
      expect(normalizeDocId('1020304050'), '1020304050');
    });

    test('puntos y guiones se remueven', () {
      expect(normalizeDocId('1.020.304.050'), '1020304050');
      expect(normalizeDocId('1-020-304-050'), '1020304050');
    });

    test('espacios se remueven', () {
      expect(normalizeDocId('1 020 304 050'), '1020304050');
    });

    test('letras se remueven', () {
      expect(normalizeDocId('CC1020304050'), '1020304050');
    });

    test('input sin dígitos → null', () {
      expect(normalizeDocId('abc'), isNull);
      expect(normalizeDocId(''), isNull);
    });
  });

  group('normalizeTaxId', () {
    test('NIT con dígito verificación "-N" al final lo remueve', () {
      expect(normalizeTaxId('900.123.456-7'), '900123456');
      expect(normalizeTaxId('900123456-7'), '900123456');
    });

    test('NIT con guiones múltiples y DV al final', () {
      expect(normalizeTaxId('900-123-456-7'), '900123456');
    });

    test('NIT sin DV se preserva tal cual (solo dígitos)', () {
      expect(normalizeTaxId('900123456'), '900123456');
    });

    test('puntos se limpian', () {
      expect(normalizeTaxId('900.123.456'), '900123456');
    });

    test('input vacío → null', () {
      expect(normalizeTaxId(''), isNull);
    });

    test('input sin dígitos → null', () {
      expect(normalizeTaxId('abc-def'), isNull);
    });
  });
}
