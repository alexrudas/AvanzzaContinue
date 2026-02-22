#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';

/// Enforces DOMAIN_CONTRACTS.md v1.1.3 — ENUM SERIALIZATION STANDARD.
///
/// Scans [lib/] and [test/] for any usage of the deprecated `.wire` getter.
/// Excludes generated files (*.g.dart, *.freezed.dart).
///
/// Detection rules (high-level):
/// - Detects member access `.wire` but NOT `.wireName`.
/// - Ignores generated Dart files.
/// - Ignores code inside block comments (`/* ... */`) and line comments (`// ...`).
/// - Tries to ignore inline `//` comments only when they occur outside of string literals.
///
/// Exit codes:
/// - 0 = no violations.
/// - 1 = violations found.
void main() {
  const scanDirs = ['lib', 'test'];

  // Matches `.wire` accessor but NOT `.wireName`.
  // - \b ensures we do not match `.wireframe`, `.wireup`, etc.
  // - (?!Name) explicitly excludes `.wireName`.
  final dotWireRegex = RegExp(r'\.(wire)\b(?!Name)');

  final violations = <String>[];

  for (final dirName in scanDirs) {
    final dir = Directory(dirName);
    if (!dir.existsSync()) continue;

    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;

      final normalizedPath = entity.path.replaceAll('\\', '/');

      // Positive filter: only .dart sources
      if (!normalizedPath.endsWith('.dart')) continue;

      // Exclusions: generated sources
      if (normalizedPath.endsWith('.g.dart')) continue;
      if (normalizedPath.endsWith('.freezed.dart')) continue;

      // Optional: skip hidden/irrelevant folders if they appear under lib/test
      // (kept minimal on purpose; avoid surprising skips)

      final lines = entity.readAsLinesSync();
      var inBlockComment = false;

      for (var i = 0; i < lines.length; i++) {
        final raw = lines[i];

        // Step 1: Strip block-comment regions; update running state.
        final (codePart, nextInBlockComment) =
            _extractCodePart(raw, inBlockComment);
        inBlockComment = nextInBlockComment;

        // Step 2: Skip pure line-comment lines (after block comment stripping).
        final trimmedLeft = codePart.trimLeft();
        if (trimmedLeft.isEmpty || trimmedLeft.startsWith('//')) continue;

        // Step 3: Strip trailing inline comment (`// ...`) only when outside strings.
        final code = _removeInlineComment(codePart);

        // Step 4: Flag any `.wire` usage.
        if (dotWireRegex.hasMatch(code)) {
          violations.add('$normalizedPath:${i + 1}: ${raw.trim()}');
        }
      }
    }
  }

  if (violations.isEmpty) {
    exit(0);
  }

  for (final v in violations) {
    print(v);
  }

  print(
    '\n🛑 VIOLACIÓN DE DOMAIN_CONTRACTS.md v1.1.3: '
    'Uso de .wire detectado. '
    'Use .wireName para logs/debug o @JsonValue (codegen) para JSON.',
  );

  exit(1);
}

// ─── Helpers ────────────────────────────────────────────────────────────────

/// Returns the portion of [line] that lies OUTSIDE block comments (`/* … */`),
/// and the updated [inBlockComment] state for the next line.
///
/// Handles `/*` starts and `*/` ends that appear mid-line.
/// Does NOT attempt to parse nested block comments (Dart does not support them).
(String, bool) _extractCodePart(String line, bool inBlockComment) {
  final buf = StringBuffer();
  var i = 0;

  while (i < line.length) {
    if (inBlockComment) {
      // Look for closing `*/`.
      if (i + 1 < line.length && line[i] == '*' && line[i + 1] == '/') {
        inBlockComment = false;
        i += 2;
      } else {
        i++;
      }
    } else {
      // Look for opening `/*`.
      if (i + 1 < line.length && line[i] == '/' && line[i + 1] == '*') {
        inBlockComment = true;
        i += 2;
      } else {
        buf.write(line[i]);
        i++;
      }
    }
  }

  return (buf.toString(), inBlockComment);
}

/// Returns [line] with any trailing inline `//` comment removed.
///
/// Walks character-by-character, tracking single- and double-quoted string
/// literals (including `\` escape sequences) to find the first `//` that
/// appears outside a string.
///
/// Note:
/// - This is a pragmatic guardrail, not a full Dart parser.
/// - When in doubt (e.g., unclosed string), returns the full line to avoid
///   hiding violations.
String _removeInlineComment(String line) {
  var inString = false;
  var delimiter = '';
  var escaped = false;

  for (var i = 0; i < line.length; i++) {
    final ch = line[i];

    if (escaped) {
      escaped = false;
      continue;
    }

    if (inString) {
      if (ch == '\\') {
        escaped = true;
      } else if (ch == delimiter) {
        inString = false;
        delimiter = '';
      }
    } else {
      if (ch == '"' || ch == "'") {
        inString = true;
        delimiter = ch;
      } else if (ch == '/' && i + 1 < line.length && line[i + 1] == '/') {
        // Found `//` outside a string — comment starts here.
        return line.substring(0, i);
      }
    }
  }

  // No inline comment found (or ended inside an unclosed string literal —
  // return full line so no violation can be hidden).
  return line;
}
