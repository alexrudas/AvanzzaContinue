// ============================================================================
// test/helpers/isar_test_db_local_contact.dart
// ISAR TEST HELPER — Variante para tests de LocalContactModel
// ============================================================================
// QUÉ HACE:
//   - Abre una instancia Isar aislada por test con el `LocalContactModelSchema`
//     registrado (los schemas de otros tests no hacen falta aquí).
//
// POR QUÉ ESTÁ SEPARADO:
//   - `isar_test_db.dart` original abre con schemas del motor financiero.
//     Cada grupo de tests que usa una colección distinta abre su propio set
//     de schemas. Evita acoplar tests de persistencia entre módulos.
// ============================================================================

import 'dart:io';

import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:isar_community/isar.dart';

bool _isarCoreInitialized = false;

Future<void> _ensureIsarCore() async {
  if (_isarCoreInitialized) return;
  _isarCoreInitialized = true;
  await Isar.initializeIsarCore(download: true);
}

/// Abre una instancia Isar con el schema de LocalContactModel.
Future<Isar> openTestIsarForLocalContact() async {
  await _ensureIsarCore();
  final dir = Directory.systemTemp.createTempSync('isar_local_contact_');
  return Isar.open(
    [LocalContactModelSchema],
    directory: dir.path,
    name: 'db_${dir.path.hashCode.abs()}',
  );
}

/// Cierra y elimina la instancia Isar del test.
Future<void> closeTestIsar(Isar isar) async {
  await isar.close(deleteFromDisk: true);
}
