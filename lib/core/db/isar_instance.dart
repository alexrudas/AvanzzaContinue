import 'package:avanzza/core/db/isar_schemas.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart' as pp;

Future<Isar> openIsar() async {
  final dir = await pp.getApplicationDocumentsDirectory();
  return Isar.open(
    allIsarSchemas,
    directory: dir.path,
    inspector: true,
  );
}
