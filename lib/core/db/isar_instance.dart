import 'dart:io' show Platform;

import 'package:avanzza/core/db/isar_schemas.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart' as pp;

Future<Isar> openIsar() async {
  // En desktop la BD debe vivir en `getApplicationSupportDirectory`
  // (AppData\Roaming\<app>) — un lugar escribible que no expone el archivo
  // al usuario final como ocurriría con `Documents/`. En móvil mantenemos
  // `getApplicationDocumentsDirectory` para no cambiar la ruta existente y
  // evitar perder datos en upgrades.
  final dir = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
      ? await pp.getApplicationSupportDirectory()
      : await pp.getApplicationDocumentsDirectory();
  return Isar.open(
    allIsarSchemas,
    directory: dir.path,
    inspector: true,
  );
}
