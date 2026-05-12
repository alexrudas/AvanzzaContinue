// ============================================================================
// test/architecture/legacy_sunset_guardrail_test.dart
// Guardrail programado: deuda con fecha del factory legacy vendorContactIds
// ============================================================================
// QUÉ HACE:
//   - Mientras DateTime.now().toUtc() < kLegacyVendorContactIdsSunsetUtc:
//       PASA. Nada que hacer.
//   - A partir de la fecha sunset:
//       FALLA con mensaje claro, forzando retirar:
//         1) CreatePurchaseRequestInput.withLegacyContactIds
//         2) CreatePurchaseRequestBody.withLegacyContactIds
//         3) todas las referencias a vendorContactIds en el camino write
//         4) toda fixture de test que lo use
//       + actualizar ADR §13 (fase 2 activa) y esta constante.
//
// QUÉ ES — Y QUÉ NO:
//   - Es enforcement TEMPORAL. No es inteligencia de producto.
//     El evento disparador es `DateTime.now().toUtc() >= sunset`, que
//     depende del RELOJ DEL RUNNER DE CI. No del estado del dominio.
//   - Por eso funciona solo si los runners tienen NTP correcto y ejecutan
//     el suite con regularidad razonable. Un entorno con fecha manipulada,
//     offline, o que no corre este test, no disparará la alarma.
//   - Es un eslabón más dentro de un conjunto: @Deprecated + constante +
//     este test + ADR §8.4. Ninguno por sí solo es barrera absoluta.
//   - No inspecciona el AST: asume que si CI empieza a fallar, el equipo
//     retira el factory a ojo y luego borra este test (o sube la sunset
//     con justificación formal en el ADR).
//
// See docs/adr/0001-actor-canon.md §8.4 — deuda con fecha.
// ============================================================================

import 'package:avanzza/domain/entities/purchase/create_purchase_request_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'DEUDA CON FECHA — retirar withLegacyContactIds antes de la sunset '
      '(ADR actor-canon fase 2)', () {
    final sunset = DateTime.parse(kLegacyVendorContactIdsSunsetUtc);
    final now = DateTime.now().toUtc();

    if (now.isBefore(sunset)) {
      // Todavía dentro de la ventana de transición. OK.
      expect(now.isBefore(sunset), isTrue);
      return;
    }

    fail(
      'Se pasó la sunset ($kLegacyVendorContactIdsSunsetUtc) y '
      'withLegacyContactIds sigue existiendo.\n'
      'Retirar:\n'
      '  1) CreatePurchaseRequestInput.withLegacyContactIds\n'
      '  2) CreatePurchaseRequestBody.withLegacyContactIds\n'
      '  3) vendorContactIds en toJson() del wire body\n'
      '  4) fixtures _legacyInput en test/data/repositories/purchase/\n'
      'Actualizar ADR §13 (fase 2 activada) y borrar este test o subir la '
      'constante kLegacyVendorContactIdsSunsetUtc con justificación.',
    );
  });

  test('kLegacyVendorContactIdsSunsetUtc es ISO-8601 UTC parseable', () {
    // Guardrail secundario: si alguien rompe el formato, este test cae
    // antes del principal.
    final d = DateTime.tryParse(kLegacyVendorContactIdsSunsetUtc);
    expect(d, isNotNull);
    expect(d!.isUtc, isTrue);
  });
}
