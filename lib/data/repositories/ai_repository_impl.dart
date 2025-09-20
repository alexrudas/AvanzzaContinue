import 'dart:async';

import 'package:avanzza/core/di/container.dart';

import '../../domain/entities/ai/ai_advisor_entity.dart';
import '../../domain/entities/ai/ai_audit_log_entity.dart';
import '../../domain/entities/ai/ai_prediction_entity.dart';
import '../../domain/repositories/ai_repository.dart';
import '../models/ai/ai_advisor_model.dart';
import '../models/ai/ai_audit_log_model.dart';
import '../models/ai/ai_prediction_model.dart';
import '../sources/local/ai_local_ds.dart';
import '../sources/remote/ai_remote_ds.dart';

class AIRepositoryImpl implements AIRepository {
  final AILocalDataSource local;
  final AIRemoteDataSource remote;

  AIRepositoryImpl({required this.local, required this.remote});

  // Advisor / Assistant
  @override
  Future<AIAdvisorEntity> chatAssistant(
      {required String orgId,
      required String userId,
      required String inputText,
      Map<String, dynamic>? structuredContext}) async {
    final now = DateTime.now().toUtc();
    final temp = AIAdvisorEntity(
      id: '${orgId}_${DateTime.now().millisecondsSinceEpoch}',
      orgId: orgId,
      userId: userId,
      modulo: structuredContext?['modulo'] ?? 'chat',
      inputText: inputText,
      structuredContext: structuredContext,
      outputText: null,
      suggestions: const [],
      createdAt: now,
      updatedAt: now,
    );
    final model = AIAdvisorModel.fromEntity(temp);
    // Optimistic local insert
    await local.upsertAdvisor(model);
    // Remote call with enqueue on failure
    try {
      await remote.upsertAdvisor(model);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertAdvisor(model));
    }
    return temp;
  }

  @override
  Stream<List<AIAdvisorEntity>> watchAdvisorSessions(String orgId,
      {String? userId, String? modulo}) async* {
    final controller = StreamController<List<AIAdvisorEntity>>();
    Future(() async {
      try {
        final locals =
            await local.advisorSessions(orgId, userId: userId, modulo: modulo);
        controller.add(locals.map((e) => e.toEntity()).toList());
        final remotes =
            await remote.advisorSessions(orgId, userId: userId, modulo: modulo);
        await _syncAdvisor(locals, remotes);
        final updated =
            await local.advisorSessions(orgId, userId: userId, modulo: modulo);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO: log error
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<AIAdvisorEntity>> fetchAdvisorSessions(String orgId,
      {String? userId, String? modulo}) async {
    final locals =
        await local.advisorSessions(orgId, userId: userId, modulo: modulo);
    unawaited(() async {
      try {
        final remotes =
            await remote.advisorSessions(orgId, userId: userId, modulo: modulo);
        await _syncAdvisor(locals, remotes);
      } catch (e) {
        // TODO
      }
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncAdvisor(
      List<AIAdvisorModel> locals, List<AIAdvisorModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertAdvisor(r);
      }
    }
  }

  // Predictions
  @override
  Future<AIPredictionEntity> analyzeAsset(
      {required String orgId,
      required String assetId,
      String? cityId,
      Map<String, dynamic>? context}) async {
    final now = DateTime.now().toUtc();
    final e = AIPredictionEntity(
      id: '${orgId}_${assetId}_${now.millisecondsSinceEpoch}',
      orgId: orgId,
      tipo: 'fallas',
      targetId: assetId,
      score: 0,
      explicacion: 'pending',
      recomendaciones: const [],
      createdAt: now,
      updatedAt: now,
    );
    final m = AIPredictionModel.fromEntity(e);
    await local.upsertPrediction(m);
    try {
      await remote.upsertPrediction(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPrediction(m));
    }
    return e;
  }

  @override
  Future<AIPredictionEntity> analyzeMaintenance(
      {required String orgId,
      required String targetId,
      Map<String, dynamic>? context}) async {
    final now = DateTime.now().toUtc();
    final e = AIPredictionEntity(
      id: '${orgId}_${targetId}_${now.millisecondsSinceEpoch}',
      orgId: orgId,
      tipo: 'mantenimiento',
      targetId: targetId,
      score: 0,
      explicacion: 'pending',
      recomendaciones: const [],
      createdAt: now,
      updatedAt: now,
    );
    final m = AIPredictionModel.fromEntity(e);
    await local.upsertPrediction(m);
    try {
      await remote.upsertPrediction(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPrediction(m));
    }
    return e;
  }

  @override
  Future<AIPredictionEntity> recommendSuppliers(
      {required String orgId,
      required String tipoRepuesto,
      String? cityId,
      String? assetId}) async {
    final now = DateTime.now().toUtc();
    final target = assetId ?? tipoRepuesto;
    final e = AIPredictionEntity(
      id: '${orgId}_${target}_${now.millisecondsSinceEpoch}',
      orgId: orgId,
      tipo: 'compras',
      targetId: target,
      score: 0,
      explicacion: 'pending',
      recomendaciones: const [],
      createdAt: now,
      updatedAt: now,
    );
    final m = AIPredictionModel.fromEntity(e);
    await local.upsertPrediction(m);
    try {
      await remote.upsertPrediction(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPrediction(m));
    }
    return e;
  }

  @override
  Future<AIPredictionEntity> predictCashflow(
      {required String orgId,
      String? countryId,
      String? cityId,
      Map<String, dynamic>? context}) async {
    final now = DateTime.now().toUtc();
    final e = AIPredictionEntity(
      id: '${orgId}_${countryId ?? 'na'}_${cityId ?? 'na'}_${now.millisecondsSinceEpoch}',
      orgId: orgId,
      tipo: 'contabilidad',
      targetId: 'org:$orgId',
      score: 0,
      explicacion: 'pending',
      recomendaciones: const [],
      createdAt: now,
      updatedAt: now,
    );
    final m = AIPredictionModel.fromEntity(e);
    await local.upsertPrediction(m);
    try {
      await remote.upsertPrediction(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPrediction(m));
    }
    return e;
  }

  @override
  Stream<List<AIPredictionEntity>> watchPredictions(String orgId,
      {String? tipo, String? targetId}) async* {
    final controller = StreamController<List<AIPredictionEntity>>();
    Future(() async {
      try {
        final locals =
            await local.predictions(orgId, tipo: tipo, targetId: targetId);
        controller.add(locals.map((e) => e.toEntity()).toList());
        final remotes =
            await remote.predictions(orgId, tipo: tipo, targetId: targetId);
        await _syncPredictions(locals, remotes);
        final updated =
            await local.predictions(orgId, tipo: tipo, targetId: targetId);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<AIPredictionEntity>> fetchPredictions(String orgId,
      {String? tipo, String? targetId}) async {
    final locals =
        await local.predictions(orgId, tipo: tipo, targetId: targetId);
    unawaited(() async {
      try {
        final remotes =
            await remote.predictions(orgId, tipo: tipo, targetId: targetId);
        await _syncPredictions(locals, remotes);
      } catch (e) {
        // TODO
      }
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncPredictions(
      List<AIPredictionModel> locals, List<AIPredictionModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertPrediction(r);
      }
    }
  }

  // Audit logs
  @override
  Stream<List<AIAuditLogEntity>> watchAuditLogs(String orgId,
      {String? userId, String? modulo}) async* {
    final controller = StreamController<List<AIAuditLogEntity>>();
    Future(() async {
      try {
        final locals =
            await local.auditLogs(orgId, userId: userId, modulo: modulo);
        controller.add(locals.map((e) => e.toEntity()).toList());
        final remotes =
            await remote.auditLogs(orgId, userId: userId, modulo: modulo);
        await _syncAuditLogs(locals, remotes);
        final updated =
            await local.auditLogs(orgId, userId: userId, modulo: modulo);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<AIAuditLogEntity>> fetchAuditLogs(String orgId,
      {String? userId, String? modulo}) async {
    final locals = await local.auditLogs(orgId, userId: userId, modulo: modulo);
    unawaited(() async {
      try {
        final remotes =
            await remote.auditLogs(orgId, userId: userId, modulo: modulo);
        await _syncAuditLogs(locals, remotes);
      } catch (e) {
        // TODO
      }
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncAuditLogs(
      List<AIAuditLogModel> locals, List<AIAuditLogModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertAuditLog(r);
      }
    }
  }

  @override
  Future<void> upsertAuditLog(AIAuditLogEntity log) async {
    final now = DateTime.now().toUtc();
    final m = AIAuditLogModel.fromEntity(
        log.copyWith(updatedAt: log.updatedAt ?? now));
    try {
      await local.upsertAuditLog(m);
    } catch (e) {
      // TODO
    }
    try {
      await remote.upsertAuditLog(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertAuditLog(m));
    }
  }

  @override
  Future<void> upsertAdvisor(AIAdvisorEntity advisor) async {
    final now = DateTime.now().toUtc();
    final m = AIAdvisorModel.fromEntity(
      advisor.copyWith(updatedAt: advisor.updatedAt ?? now),
    );
    try {
      await local.upsertAdvisor(m);
    } catch (e) {
      // TODO: manejo de error local
    }
    try {
      await remote.upsertAdvisor(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertAdvisor(m));
    }
  }

  @override
  Future<void> upsertPrediction(AIPredictionEntity prediction) async {
    final now = DateTime.now().toUtc();
    final m = AIPredictionModel.fromEntity(
      prediction.copyWith(updatedAt: prediction.updatedAt ?? now),
    );
    try {
      await local.upsertPrediction(m);
    } catch (e) {
      // TODO: manejo de error local
    }
    try {
      await remote.upsertPrediction(m);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPrediction(m));
    }
  }
}
