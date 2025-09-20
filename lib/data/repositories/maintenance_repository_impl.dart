import 'dart:async';

import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/data/models/maintenance/incidencia_model.dart';
import 'package:avanzza/data/models/maintenance/maintenance_finished_model.dart';
import 'package:avanzza/data/models/maintenance/maintenance_process_model.dart';
import 'package:avanzza/data/models/maintenance/maintenance_programming_model.dart';
import 'package:avanzza/data/sources/local/maintenance_local_ds.dart';
import 'package:avanzza/data/sources/remote/maintenance_remote_ds.dart';

import '../../../domain/entities/maintenance/incidencia_entity.dart';
import '../../../domain/entities/maintenance/maintenance_finished_entity.dart';
import '../../../domain/entities/maintenance/maintenance_process_entity.dart';
import '../../../domain/entities/maintenance/maintenance_programming_entity.dart';
import '../../../domain/repositories/maintenance_repository.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final MaintenanceLocalDataSource local;
  final MaintenanceRemoteDataSource remote;
  MaintenanceRepositoryImpl({required this.local, required this.remote});

  // Incidencias
  @override
  Stream<List<IncidenciaEntity>> watchIncidencias(String orgId,
      {String? assetId, String? cityId}) async* {
    final controller = StreamController<List<IncidenciaEntity>>();
    Future(() async {
      final locals =
          await local.incidencias(orgId, assetId: assetId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.incidencias(orgId, assetId: assetId, cityId: cityId);
      await _syncIncidencias(locals, remotes);
      final updated =
          await local.incidencias(orgId, assetId: assetId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<IncidenciaEntity>> fetchIncidencias(String orgId,
      {String? assetId, String? cityId}) async {
    final locals =
        await local.incidencias(orgId, assetId: assetId, cityId: cityId);
    unawaited(() async {
      final remotes =
          await remote.incidencias(orgId, assetId: assetId, cityId: cityId);
      await _syncIncidencias(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncIncidencias(
      List<IncidenciaModel> locals, List<IncidenciaModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertIncidencia(r);
      }
    }
  }

  @override
  Future<void> upsertIncidencia(IncidenciaEntity entity) async {
    final now = DateTime.now().toUtc();
    final m = IncidenciaModel.fromEntity(
        entity.copyWith(updatedAt: entity.updatedAt ?? now));
    await local.upsertIncidencia(m);
    try {
      await remote.upsertIncidencia(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertIncidencia(m));
    }
  }

  // Programaciones
  @override
  Stream<List<MaintenanceProgrammingEntity>> watchProgramaciones(String orgId,
      {String? assetId, String? cityId}) async* {
    final controller = StreamController<List<MaintenanceProgrammingEntity>>();
    Future(() async {
      final locals =
          await local.programaciones(orgId, assetId: assetId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.programaciones(orgId, assetId: assetId, cityId: cityId);
      await _syncProgramaciones(locals, remotes);
      final updated =
          await local.programaciones(orgId, assetId: assetId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<MaintenanceProgrammingEntity>> fetchProgramaciones(String orgId,
      {String? assetId, String? cityId}) async {
    final locals =
        await local.programaciones(orgId, assetId: assetId, cityId: cityId);
    unawaited(() async {
      final remotes =
          await remote.programaciones(orgId, assetId: assetId, cityId: cityId);
      await _syncProgramaciones(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncProgramaciones(List<MaintenanceProgrammingModel> locals,
      List<MaintenanceProgrammingModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertProgramacion(r);
      }
    }
  }

  @override
  Future<void> upsertProgramacion(MaintenanceProgrammingEntity entity) async {
    final now = DateTime.now().toUtc();
    final m = MaintenanceProgrammingModel.fromEntity(
        entity.copyWith(updatedAt: entity.updatedAt ?? now));
    await local.upsertProgramacion(m);
    try {
      await remote.upsertProgramacion(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertProgramacion(m));
    }
  }

  // Procesos
  @override
  Stream<List<MaintenanceProcessEntity>> watchProcesos(String orgId,
      {String? assetId, String? cityId}) async* {
    final controller = StreamController<List<MaintenanceProcessEntity>>();
    Future(() async {
      final locals =
          await local.procesos(orgId, assetId: assetId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.procesos(orgId, assetId: assetId, cityId: cityId);
      await _syncProcesos(locals, remotes);
      final updated =
          await local.procesos(orgId, assetId: assetId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<MaintenanceProcessEntity>> fetchProcesos(String orgId,
      {String? assetId, String? cityId}) async {
    final locals =
        await local.procesos(orgId, assetId: assetId, cityId: cityId);
    unawaited(() async {
      final remotes =
          await remote.procesos(orgId, assetId: assetId, cityId: cityId);
      await _syncProcesos(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncProcesos(List<MaintenanceProcessModel> locals,
      List<MaintenanceProcessModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertProceso(r);
      }
    }
  }

  @override
  Future<void> upsertProceso(MaintenanceProcessEntity entity) async {
    final now = DateTime.now().toUtc();
    final m = MaintenanceProcessModel.fromEntity(
        entity.copyWith(updatedAt: entity.updatedAt ?? now));
    await local.upsertProceso(m);
    try {
      await remote.upsertProceso(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertProceso(m));
    }
  }

  // Finalizados
  @override
  Stream<List<MaintenanceFinishedEntity>> watchFinalizados(String orgId,
      {String? assetId, String? cityId}) async* {
    final controller = StreamController<List<MaintenanceFinishedEntity>>();
    Future(() async {
      final locals =
          await local.finalizados(orgId, assetId: assetId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.finalizados(orgId, assetId: assetId, cityId: cityId);
      await _syncFinalizados(locals, remotes);
      final updated =
          await local.finalizados(orgId, assetId: assetId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<MaintenanceFinishedEntity>> fetchFinalizados(String orgId,
      {String? assetId, String? cityId}) async {
    final locals =
        await local.finalizados(orgId, assetId: assetId, cityId: cityId);
    unawaited(() async {
      final remotes =
          await remote.finalizados(orgId, assetId: assetId, cityId: cityId);
      await _syncFinalizados(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncFinalizados(List<MaintenanceFinishedModel> locals,
      List<MaintenanceFinishedModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertFinalizado(r);
      }
    }
  }

  @override
  Future<void> upsertFinalizado(MaintenanceFinishedEntity entity) async {
    final now = DateTime.now().toUtc();
    final m = MaintenanceFinishedModel.fromEntity(
        entity.copyWith(updatedAt: entity.updatedAt ?? now));
    await local.upsertFinalizado(m);
    try {
      await remote.upsertFinalizado(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertFinalizado(m));
    }
  }
}
