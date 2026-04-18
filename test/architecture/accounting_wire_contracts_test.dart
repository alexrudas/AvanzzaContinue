// ============================================================================
// test/architecture/accounting_wire_contracts_test.dart
// GUARDRAIL ARQUITECTURAL — DOMAIN_CONTRACTS.md v1.1.3 §B/§C
//
// SCOPE: exclusivamente `lib/domain/entities/accounting/`.
// Este guardrail NO aplica a otras áreas del repo (alerts, core_common, etc.)
// que tienen su propio contrato y getters fromWire documentados.
//
// PROHIBIDO en los archivos de accounting/domain:
//   1. `.wire` (getter) o declaraciones `get wire`
//   2. `fromWire` (estático o extension)
//   3. `switch` sobre valor enum cuyo cuerpo devuelva un literal String
//      (equivalente funcional a `.wire` — segunda fuente de verdad del
//      mapping enum ↔ string).
//
// Objetivo: si alguien reintroduce mapping enum ↔ string dentro del dominio
// de accounting (por la puerta delantera o camuflado), este test rompe
// inmediatamente antes del linter CI.
//
// La fuente canónica del mapping vive en:
//   lib/infrastructure/isar/codecs/outbox_status_codec.dart
//   lib/infrastructure/isar/codecs/ar_projection_estado_codec.dart
// ============================================================================

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const scopedDir = 'lib/domain/entities/accounting';

  final bannedPatterns = <RegExp>[
    RegExp(r'\.wire\b'),
    RegExp(r'\bget\s+wire\b'),
    RegExp(r'\bfromWire\b'),
  ];

  List<File> scopedDartFiles() {
    final dir = Directory(scopedDir);
    if (!dir.existsSync()) {
      throw StateError('Scope no existe en disco: $scopedDir');
    }
    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) =>
            f.path.endsWith('.dart') &&
            !f.path.endsWith('.g.dart') &&
            !f.path.endsWith('.freezed.dart'))
        .toList(growable: false);
  }

  /// Localiza bloques `switch (...) { ... }` balanceados por llaves y los
  /// retorna con índice de inicio y cuerpo (sin las llaves exteriores).
  /// Implementación lineal O(n) sobre el contenido; suficiente para archivos
  /// del tamaño del dominio accounting.
  Iterable<({int start, String body})> findSwitchBlocks(String content) sync* {
    final switchPattern = RegExp(r'\bswitch\b');
    var idx = 0;
    while (idx < content.length) {
      final m = switchPattern.firstMatch(content.substring(idx));
      if (m == null) return;
      final absStart = idx + m.start;
      final openBrace = content.indexOf('{', absStart);
      if (openBrace == -1) return;
      var depth = 1;
      var i = openBrace + 1;
      while (i < content.length && depth > 0) {
        final c = content[i];
        if (c == '{') {
          depth++;
        } else if (c == '}') {
          depth--;
        }
        if (depth == 0) break;
        i++;
      }
      if (depth != 0) return; // archivo mal balanceado — nada más que hacer
      yield (start: absStart, body: content.substring(openBrace + 1, i));
      idx = i + 1;
    }
  }

  test('scope existe y contiene archivos Dart', () {
    expect(scopedDartFiles(), isNotEmpty,
        reason: 'No se encontraron .dart en $scopedDir');
  });

  test('ningún archivo en $scopedDir contiene `.wire` ni `fromWire`', () {
    final files = scopedDartFiles();
    final violations = <String>[];

    for (final f in files) {
      final content = f.readAsStringSync();
      final lines = content.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        for (final pattern in bannedPatterns) {
          if (pattern.hasMatch(line)) {
            violations.add(
                '${f.path}:${i + 1}: "${line.trim()}" (match: ${pattern.pattern})');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: '\nDOMAIN_CONTRACTS.md v1.1.3 §B/§C:\n'
          'Los enums de dominio NO pueden exponer `.wire` ni `fromWire`.\n'
          'El mapping canónico enum ↔ string vive en:\n'
          '  lib/infrastructure/isar/codecs/outbox_status_codec.dart\n'
          '  lib/infrastructure/isar/codecs/ar_projection_estado_codec.dart\n\n'
          'Violaciones:\n  ${violations.join('\n  ')}\n',
    );
  });

  test(
      'ningún archivo en $scopedDir tiene un `switch` sobre enum que '
      'devuelva un literal String (`.wire` camuflado)', () {
    // Detecta el patrón estructural:
    //   switch (X) {
    //     case Enum.valueA: return 'a';
    //     case Enum.valueB: return 'b';
    //   }
    // Equivale funcionalmente a un getter `.wire` y crearía una segunda
    // fuente de verdad del mapping enum ↔ string dentro del dominio.
    //
    // Heurística: un switch cuyo cuerpo contiene al menos un `case IDENT.IDENT`
    // (switch sobre enum) Y al menos un `return '...'` o `return "..."`.
    final caseOnEnum = RegExp(r'\bcase\s+[A-Za-z_][A-Za-z0-9_]*\.'
        r'[A-Za-z_][A-Za-z0-9_]*\s*:');
    final returnsStringLiteral = RegExp(r'''\breturn\s+['"]''');

    final files = scopedDartFiles();
    final violations = <String>[];

    for (final f in files) {
      final content = f.readAsStringSync();
      for (final block in findSwitchBlocks(content)) {
        final body = block.body;
        if (caseOnEnum.hasMatch(body) &&
            returnsStringLiteral.hasMatch(body)) {
          // Calcular número de línea del inicio del switch.
          final line = '\n'.allMatches(content.substring(0, block.start)).length + 1;
          violations.add(
              '${f.path}:$line: switch sobre enum que retorna literal String '
              '(equivalente a `.wire` — prohibido en dominio)');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: '\nDOMAIN_CONTRACTS.md v1.1.3 §B/§C — regla reforzada:\n'
          'Un `switch` sobre enum cuyo cuerpo devuelva literales String es\n'
          'equivalente funcional a `.wire`/`fromWire` y reintroduce una\n'
          'segunda fuente de verdad del mapping en dominio.\n'
          'Si necesitas encode/decode enum ↔ string, úsalo desde los codecs:\n'
          '  lib/infrastructure/isar/codecs/outbox_status_codec.dart\n'
          '  lib/infrastructure/isar/codecs/ar_projection_estado_codec.dart\n\n'
          'Violaciones:\n  ${violations.join('\n  ')}\n',
    );
  });
}
