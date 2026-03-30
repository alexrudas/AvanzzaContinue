// ============================================================================
// lib/data/gateways/runt_async_query_gateway_impl.dart
//
// RUNT ASYNC QUERY GATEWAY IMPL — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Implementación concreta del gateway de aplicación para la consulta RUNT
// asíncrona basada en jobs.
//
// RESPONSABILIDAD
// - Consumir RuntQueryService (infraestructura HTTP)
// - Traducir modelos de data a modelos neutrales de aplicación
// - Actuar como anticorruption layer entre infraestructura y capas superiores
//
// DEPENDENCIAS CORRECTAS
//   data -> application abstraction
//   data -> data service/models
//
// NO RESPONSABILIDAD
// - No contiene polling
// - No contiene persistencia
// - No contiene lógica de UI
// - No contiene lógica de navegación
//
// ARQUITECTURA
// Este archivo NO importa presentation.
// La abstracción [RuntAsyncQueryGateway] y sus tipos asociados deben vivir
// en una capa neutral, por ejemplo:
//
//   lib/application/runt/runt_async_query_gateway.dart
//
// ============================================================================

import '../../application/runt/runt_async_query_gateway.dart';
import '../runt/models/runt_job_models.dart';
import '../runt/runt_query_service.dart';

class RuntAsyncQueryGatewayImpl implements RuntAsyncQueryGateway {
  final RuntQueryService _service;

  RuntAsyncQueryGatewayImpl(this._service);

  @override
  Future<RuntAsyncQueryStartResult> startQuery({
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
  }) async {
    final response = await _service.startQuery(
      plate: plate,
      ownerDocument: ownerDocument,
      ownerDocumentType: ownerDocumentType,
    );

    return RuntAsyncQueryStartResult(
      jobId: response.jobId,
    );
  }

  @override
  Future<RuntAsyncQueryStatusResult> getJobStatus(String jobId) async {
    final response = await _service.getJobStatus(jobId);

    return RuntAsyncQueryStatusResult(
      jobId: response.jobId,
      status: _mapJobStatus(response.status),
      steps: _mapSteps(response.steps),
      progressPercent: response.progressPercent,
      partialData: response.partialData,
      finalData: response.data,
      error: response.error,
      failureReason: response.failureReason,
      failureMessage: response.failureMessage,
      updatedAt: response.updatedAt,
      completedAt: response.completedAt,
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Mapeos data -> application
  // ───────────────────────────────────────────────────────────────────────────

  RuntQueryJobStatus _mapJobStatus(RuntJobStatus status) {
    return switch (status) {
      RuntJobStatus.pending => RuntQueryJobStatus.pending,
      RuntJobStatus.running => RuntQueryJobStatus.running,
      RuntJobStatus.completed => RuntQueryJobStatus.completed,
      RuntJobStatus.failed => RuntQueryJobStatus.failed,
    };
  }

  RuntQueryStepStatus _mapStepStatus(RuntJobStepStatus status) {
    return switch (status) {
      RuntJobStepStatus.pending => RuntQueryStepStatus.pending,
      RuntJobStepStatus.loading => RuntQueryStepStatus.loading,
      RuntJobStepStatus.done => RuntQueryStepStatus.done,
      RuntJobStepStatus.failed => RuntQueryStepStatus.failed,
      RuntJobStepStatus.blocked => RuntQueryStepStatus.blocked,
    };
  }

  RuntQuerySteps _mapSteps(RuntJobSteps steps) {
    return RuntQuerySteps(
      vehicle: _mapStepStatus(steps.vehicle),
      soat: _mapStepStatus(steps.soat),
      rtm: _mapStepStatus(steps.rtm),
      history: _mapStepStatus(steps.history),
    );
  }
}
