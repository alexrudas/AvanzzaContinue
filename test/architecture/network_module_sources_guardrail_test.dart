// ============================================================================
// test/architecture/network_module_sources_guardrail_test.dart
// Guardrail del módulo "Mi Red Operativa" (ADR actor-canon §10 + §11)
// ============================================================================
// QUÉ HACE:
//   - Enumera los imports de los archivos del módulo Network y valida que:
//       A) solo dependan de las fuentes canónicas (§10.1).
//       B) NO importen `PortfolioRepository` (§11) — activado al cerrar 5c.
//
// QUÉ NO HACE:
//   - No inspecciona uso (solo imports). Si alguien consume un repo
//     indirectamente vía DIContainer no lo detectamos, pero sí aparecerá en
//     code review y en los comentarios del archivo.
//   - No valida backend. Solo Flutter.
//
// ALCANCE DEL MÓDULO (grep paths):
//   - lib/presentation/**/network*.dart
//   - lib/presentation/**/network*/**
//   - lib/presentation/view_models/network/**
//   - lib/application/**/network*/**
//
// REGLA 10.1 — LISTA BLANCA DE FUENTES CANÓNICAS:
//   - AssetActorLinkRepository
//   - NetworkRelationshipRepository
//   - LocalContactRepository
//   - LocalOrganizationRepository
//
// REGLA 11 — HITO 5C MATA EL BYPASS:
//   - No se permite `PortfolioRepository` en archivos del módulo Network.
//   - Hasta que 5c elimine los últimos imports, la aserción queda `skip: true`.
//     Cuando 5c cierre, quitar el skip.
//
// See docs/adr/0001-actor-canon.md §10, §11.
// ============================================================================

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------

/// Convertido desde los paths del ADR §10 (relativos a la raíz del paquete).
/// Se usan prefijos de ruta para el scan.
const List<String> _kModulePathPrefixes = <String>[
  'lib/presentation/controllers/admin/network/',
  'lib/presentation/bindings/admin/network_operational_binding.dart',
  'lib/presentation/pages/admin/network/',
  'lib/presentation/view_models/network/',
  // 'lib/application/core_common/network/', // reserva futura
];

/// Fuentes canónicas permitidas. Los archivos del módulo solo pueden importar
/// REPOSITORIOS (domain/repositories/**) listados aquí.
const Set<String> _kAllowedRepositoryImports = <String>{
  // Nuevos (hito 5b).
  'package:avanzza/domain/repositories/core_common/asset_actor_link_repository.dart',
  'package:avanzza/domain/repositories/core_common/network_relationship_repository.dart',
  // Libreta (Core Common v1, preexistentes).
  'package:avanzza/domain/repositories/core_common/local_contact_repository.dart',
  'package:avanzza/domain/repositories/core_common/local_organization_repository.dart',
  // 'package:avanzza/domain/repositories/portfolio_repository.dart' — PROHIBIDO por §11
};

/// Repos explícitamente prohibidos en el módulo (§11).
const Set<String> _kForbiddenRepositoryImports = <String>{
  'package:avanzza/domain/repositories/portfolio_repository.dart',
};

/// Regex laxo para detectar import de "repository" (domain/repositories/**).
final _repoImportRe = RegExp(
  r'''^\s*import\s+['"]package:avanzza/domain/repositories/[^'"]+['"]''',
  multiLine: true,
);

// ----------------------------------------------------------------------------
// Helpers
// ----------------------------------------------------------------------------

List<File> _collectModuleFiles() {
  final root = Directory.current.path;
  final out = <File>[];
  for (final prefix in _kModulePathPrefixes) {
    final path = '$root/$prefix';
    final entity = FileSystemEntity.typeSync(path);
    if (entity == FileSystemEntityType.directory) {
      final dir = Directory(path);
      out.addAll(
        dir
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) =>
                f.path.endsWith('.dart') &&
                !f.path.endsWith('.g.dart') &&
                !f.path.endsWith('.freezed.dart')),
      );
    } else if (entity == FileSystemEntityType.file) {
      out.add(File(path));
    }
  }
  return out;
}

/// Extrae la lista de imports `package:avanzza/domain/repositories/...` de un
/// archivo. Devuelve paths completos tal como aparecen en el import.
List<String> _extractRepoImports(File file) {
  final text = file.readAsStringSync();
  final matches = _repoImportRe.allMatches(text);
  return matches.map((m) {
    final line = m.group(0)!;
    final quoteStart = line.contains("'")
        ? line.indexOf("'")
        : line.indexOf('"');
    final quoteChar = line[quoteStart];
    final afterQuote = quoteStart + 1;
    final end = line.indexOf(quoteChar, afterQuote);
    return line.substring(afterQuote, end);
  }).toList();
}

// ----------------------------------------------------------------------------
// Tests
// ----------------------------------------------------------------------------

void main() {
  group('Network module — fuentes de lectura canónicas (ADR §10)', () {
    final files = _collectModuleFiles();

    test(
        'existe al menos un archivo del módulo (sanidad: los prefijos del scan '
        'coinciden con el repo)', () {
      expect(files, isNotEmpty,
          reason: 'Los paths de _kModulePathPrefixes no matchearon archivos. '
              'Si el módulo se reorganizó, actualizar el guardrail.');
    });

    test(
        'ningún archivo del módulo importa un repository fuera de la lista '
        'blanca §10.1', () {
      final violations = <String>[];
      for (final file in files) {
        final imports = _extractRepoImports(file);
        for (final imp in imports) {
          // Dentro del módulo, el único import `domain/repositories/**` válido
          // es uno de la lista blanca. Los _kForbiddenRepositoryImports ya son
          // un subconjunto de "no está en la lista blanca", pero los listamos
          // explícito para mensaje de error claro (ver test siguiente).
          if (!_kAllowedRepositoryImports.contains(imp) &&
              !_kForbiddenRepositoryImports.contains(imp)) {
            violations.add('${file.path}\n  imports: $imp');
          }
        }
      }
      expect(
        violations,
        isEmpty,
        reason:
            'Archivos del módulo Network con imports de repository fuera de '
            'ADR §10.1. Si la fuente es legítima, actualizar el ADR + lista '
            'blanca. Si no, corregir el import.\n\n${violations.join('\n')}',
      );
    });
  });

  group('Network module — ADR §11 (bypass de PortfolioEntity)', () {
    // Hito 5c CERRADO (2026-04-20): el bypass fue retirado del módulo.
    // Este test ahora es guardrail ACTIVO — cualquier PR que reintroduzca
    // `portfolio_repository.dart` en los paths del módulo hará fallar CI.
    test(
      'ningún archivo del módulo importa PortfolioRepository (ADR §11)',
      () {
        final files = _collectModuleFiles();
        final violations = <String>[];
        for (final file in files) {
          final imports = _extractRepoImports(file);
          for (final imp in imports) {
            if (_kForbiddenRepositoryImports.contains(imp)) {
              violations.add(file.path);
            }
          }
        }
        expect(
          violations,
          isEmpty,
          reason:
              'ADR §11: el módulo Network NO puede importar PortfolioRepository. '
              'Regresión detectada.\n\n${violations.join('\n')}',
        );
      },
    );
  });
}
