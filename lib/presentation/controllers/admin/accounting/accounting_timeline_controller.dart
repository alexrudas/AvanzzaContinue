// ============================================================================
// lib/presentation/controllers/admin/accounting/accounting_timeline_controller.dart
// AUDIT TRAIL TIMELINE — Enterprise Ultra Pro (Presentation)
//
// QUÉ HACE:
// - Carga y expone la lista de AccountingEvent de una entidad CxC (DESC)
// - Estado reactivo: isLoading, errorMessage, events
// - refresh() recarga tras save() exitoso (llamado desde ARDetailController)
//
// QUÉ NO HACE:
// - No modifica eventos (Event Store es append-only / inmutable)
// - No pagina más allá del límite 200 (suficiente para uso local)
// - No imprime payload completo en logs
//
// NOTAS:
// - Fail-hard visible: FormatException o StateError → errorMessage en UI
// - Tag en Get.put: 'timeline_<entityId>' para convivir con ARDetailController
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/accounting/accounting_event.dart';
import '../../../../infrastructure/isar/repositories/isar_accounting_event_repository.dart';

class AccountingTimelineController extends GetxController {
  final events = <AccountingEvent>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  String? _entityId;

  // ==========================================================================
  // LOAD
  // ==========================================================================

  Future<void> load(String entityId) async {
    _entityId = entityId;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (!Get.isRegistered<IsarAccountingEventRepository>()) {
        throw StateError('IsarAccountingEventRepository not registered');
      }
      final repo = Get.find<IsarAccountingEventRepository>();

      final page = await repo.listByEntity(
        entityType: 'account_receivable',
        entityId: entityId,
        limit: 200,
      );

      // DESC por sequenceNumber — evento más reciente primero
      events.value = page.items.reversed.toList();
    } on FormatException catch (e) {
      debugPrint(
        '[AccountingTimeline] FormatException '
        'entityId=$entityId type=${e.runtimeType}',
      );
      errorMessage.value = 'Historial no disponible: integridad comprometida.';
      events.clear();
    } on StateError catch (e) {
      debugPrint(
        '[AccountingTimeline] StateError '
        'entityId=$entityId type=${e.runtimeType}',
      );
      errorMessage.value = 'Historial no disponible: integridad comprometida.';
      events.clear();
    } catch (e) {
      debugPrint(
        '[AccountingTimeline] Error '
        'entityId=$entityId type=${e.runtimeType}',
      );
      errorMessage.value = 'Historial no disponible: integridad comprometida.';
      events.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================================
  // REFRESH
  // ==========================================================================

  /// Recarga el historial. Llamado desde ARDetailController.save() tras éxito.
  @override
  void refresh() {
    if (_entityId != null) load(_entityId!);
  }
}
