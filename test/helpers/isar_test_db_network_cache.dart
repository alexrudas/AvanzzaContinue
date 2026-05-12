// ============================================================================
// test/helpers/isar_test_db_network_cache.dart
// ISAR TEST HELPER — Mi Red local-first (3 colecciones nuevas)
// ============================================================================
// Abre una instancia Isar aislada por test, registrando los schemas de las
// colecciones de cache local de Mi Red. Sin acoplarse a otros módulos.
// ============================================================================

import 'dart:io';

import 'package:avanzza/data/models/network/network_actor_cache_model.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/team_actor_cache_model.dart';
import 'package:isar_community/isar.dart';

bool _isarCoreInitialized = false;

Future<void> _ensureIsarCore() async {
  if (_isarCoreInitialized) return;
  _isarCoreInitialized = true;
  await Isar.initializeIsarCore(download: true);
}

/// Abre una instancia Isar con los 3 schemas de cache de Mi Red.
Future<Isar> openTestIsarForNetworkCache() async {
  await _ensureIsarCore();
  final dir = Directory.systemTemp.createTempSync('isar_network_cache_');
  return Isar.open(
    [
      NetworkActorCacheModelSchema,
      TeamActorCacheModelSchema,
      NetworkSectionMetaModelSchema,
    ],
    directory: dir.path,
    name: 'db_${dir.path.hashCode.abs()}',
  );
}

/// Cierra y elimina la instancia Isar del test.
Future<void> closeTestIsarNetworkCache(Isar isar) async {
  await isar.close(deleteFromDisk: true);
}
