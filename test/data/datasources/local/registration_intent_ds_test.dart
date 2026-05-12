// ============================================================================
// test/data/datasources/local/registration_intent_ds_test.dart
//
// QUÉ HACE:
// - Verifica el contrato de RegistrationIntentDS sobre SharedPreferences:
//   set/get/clear de `providerOnboardingIntent`.
// - Caso del bug reportado: tras finalizar el wizard con selectedRole=
//   "proveedor", el flag queda persistido y el splash puede leerlo aunque
//   `RegistrationProgressModel` haya sido limpiado.
// ============================================================================
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:avanzza/data/datasources/local/registration_intent_ds.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('RegistrationIntentDS', () {
    test('default: providerOnboardingIntent=false', () async {
      final ds = RegistrationIntentDS();
      expect(await ds.getProviderOnboardingIntent(), isFalse);
    });

    test('setProviderOnboardingIntent(true) persiste y sobrevive', () async {
      final ds = RegistrationIntentDS();
      await ds.setProviderOnboardingIntent(true);
      expect(await ds.getProviderOnboardingIntent(), isTrue);

      // Crear una segunda instancia: simula que otro controller lo lee
      // tras un restart del proceso. SharedPreferences es proceso-wide.
      final ds2 = RegistrationIntentDS();
      expect(await ds2.getProviderOnboardingIntent(), isTrue,
          reason:
              'El flag debe sobrevivir entre instancias / restarts simulados.');
    });

    test('clear() retira la intención', () async {
      final ds = RegistrationIntentDS();
      await ds.setProviderOnboardingIntent(true);
      await ds.clear();
      expect(await ds.getProviderOnboardingIntent(), isFalse);
    });

    test('setProviderOnboardingIntent(false) explícito desactiva el flag',
        () async {
      final ds = RegistrationIntentDS();
      await ds.setProviderOnboardingIntent(true);
      await ds.setProviderOnboardingIntent(false);
      expect(await ds.getProviderOnboardingIntent(), isFalse);
    });
  });
}
