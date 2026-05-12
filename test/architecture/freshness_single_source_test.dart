// ============================================================================
// test/architecture/freshness_single_source_test.dart
// GUARDRAIL — los 3 umbrales de Freshness viven SOLO en section_classifier.dart
// ============================================================================
// REGLA:
//   Cualquier archivo de `lib/` (excepto `section_classifier.dart`) que
//   contenga LOS TRES literales:
//     - Duration(minutes: 5)
//     - Duration(days:    3)
//     - Duration(days:   30)
//   simultáneamente, es sospechoso de reimplementar la clasificación de
//   freshness. El test falla con la lista de violadores.
//
//   Permite que UN umbral suelto aparezca (timeouts genéricos, debounces,
//   etc.) — solo bloquea cuando los TRES aparecen juntos, que es la firma
//   inequívoca de freshness logic.
//
// ROBUSTEZ:
//   - Se eliminan comentarios (// línea + /* bloque */) antes de buscar, para
//     que prosa explicativa o docs no falsifiquen positivos.
//   - Solo escanea `lib/`, no `test/` (donde aparecen literales en
//     fixtures/expects).
//   - Excepciones explícitas — solo el propio archivo del classifier.
// ============================================================================

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _exemptions = <String>{
  'section_classifier.dart',
};

const _freshThresholdPattern = r'Duration\s*\(\s*minutes\s*:\s*5\s*\)';
const _staleThresholdPattern = r'Duration\s*\(\s*days\s*:\s*3\s*\)';
const _veryStaleThresholdPattern = r'Duration\s*\(\s*days\s*:\s*30\s*\)';

String _stripComments(String content) {
  // Bloques /* ... */ (multi-línea).
  final noBlock = content.replaceAll(
    RegExp(r'/\*.*?\*/', dotAll: true),
    '',
  );
  // Línea //... hasta fin de línea (cubre también ///).
  return noBlock.replaceAll(
    RegExp(r'//[^\n]*', multiLine: true),
    '',
  );
}

void main() {
  test(
    'umbrales de freshness (5min/3d/30d) JUNTOS solo en section_classifier.dart',
    () async {
      final fresh = RegExp(_freshThresholdPattern);
      final stale = RegExp(_staleThresholdPattern);
      final veryStale = RegExp(_veryStaleThresholdPattern);

      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue,
          reason: 'lib/ no encontrado — ¿cwd correcto?');

      final violators = <String>[];

      await for (final entity in libDir.list(recursive: true)) {
        if (entity is! File) continue;
        final path = entity.path.replaceAll(r'\', '/');
        if (!path.endsWith('.dart')) continue;
        // .g.dart, .freezed.dart son generados — exentos.
        if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) {
          continue;
        }
        // Exenciones explícitas por nombre de archivo.
        if (_exemptions.any(path.endsWith)) continue;

        final raw = await entity.readAsString();
        final code = _stripComments(raw);

        final hasAll = fresh.hasMatch(code) &&
            stale.hasMatch(code) &&
            veryStale.hasMatch(code);
        if (hasAll) {
          violators.add(path);
        }
      }

      expect(
        violators,
        isEmpty,
        reason: 'Los 3 umbrales de freshness (Duration(minutes: 5), '
            'Duration(days: 3), Duration(days: 30)) aparecen JUNTOS en:\n'
            '${violators.map((v) => "  - $v").join("\n")}\n'
            'Centralizar la lógica de freshness en section_classifier.dart '
            '(la única función autorizada para derivar Freshness).',
      );
    },
  );

  test(
    'section_classifier.dart contiene los 3 umbrales (sanity check del guardrail)',
    () async {
      final fresh = RegExp(_freshThresholdPattern);
      final stale = RegExp(_staleThresholdPattern);
      final veryStale = RegExp(_veryStaleThresholdPattern);

      final classifier = File(
        'lib/presentation/controllers/network/v2/section_classifier.dart',
      );
      expect(classifier.existsSync(), isTrue,
          reason: 'section_classifier.dart no encontrado');

      final code = _stripComments(await classifier.readAsString());
      expect(fresh.hasMatch(code), isTrue, reason: 'falta Duration(minutes:5)');
      expect(stale.hasMatch(code), isTrue, reason: 'falta Duration(days:3)');
      expect(veryStale.hasMatch(code), isTrue,
          reason: 'falta Duration(days:30)');
    },
  );
}
