// ============================================================================
// test/helpers/isar_test_db.dart
// ISAR TEST HELPER — Enterprise Ultra Pro (Test)
//
// QUÉ HACE:
// - Inicializa el binario nativo de Isar (libisar.dll / libisar.so) una vez.
// - Abre una instancia Isar aislada en directorio temporal del sistema.
// - Registra solo los 3 schemas del motor financiero (P2-A).
// - Expone closeTestIsar() para borrar archivos al finalizar cada test.
//
// QUÉ NO HACE:
// - NO usa path_provider (requiere Flutter binding).
// - NO comparte instancia entre tests (cada setUp obtiene la suya).
//
// PREREQUISITO (Windows):
// - libisar.dll debe estar en la raíz del proyecto.
//   Se obtiene del pub cache de isar_community_flutter_libs:
//   %LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\isar_community_flutter_libs-X.Y.Z\windows\libisar.dll
//   Ejecutar una vez: cp <ruta_dll> <raíz_proyecto>/libisar.dll
// ============================================================================

import 'dart:io';

import 'package:avanzza/infrastructure/isar/entities/account_receivable_projection_entity.dart';
import 'package:avanzza/infrastructure/isar/entities/accounting_event_entity.dart';
import 'package:avanzza/infrastructure/isar/entities/outbox_event_entity.dart';
import 'package:isar_community/isar.dart';

bool _isarCoreInitialized = false;

/// Inicializa el binario nativo de Isar si no se hizo ya.
///
/// Busca libisar en la raíz del proyecto (directorio de trabajo de flutter test).
/// Si no está presente ahí, intenta descargar desde binaries.isar-community.dev.
Future<void> _ensureIsarCore() async {
  if (_isarCoreInitialized) return;
  _isarCoreInitialized = true;
  await Isar.initializeIsarCore(download: true);
}

/// Abre una instancia Isar con los 3 schemas del motor financiero.
///
/// Llama a [_ensureIsarCore] antes de abrir.
/// Usa un directorio temporal único del SO para cada llamada.
Future<Isar> openTestIsar() async {
  await _ensureIsarCore();
  final dir = Directory.systemTemp.createTempSync('isar_acctg_');
  return Isar.open(
    [
      AccountingEventEntitySchema,
      OutboxEventEntitySchema,
      AccountReceivableProjectionEntitySchema,
    ],
    directory: dir.path,
    name: 'db_${dir.path.hashCode.abs()}',
  );
}

/// Cierra y elimina todos los archivos de la instancia Isar de test.
Future<void> closeTestIsar(Isar isar) async {
  await isar.close(deleteFromDisk: true);
}
