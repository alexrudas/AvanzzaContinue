// ============================================================================
// lib/presentation/controllers/admin/network/provider_detail_controller.dart
// PROVIDER DETAIL CONTROLLER — Lectura por secciones de un proveedor
// ============================================================================
// QUÉ HACE:
//   - Expone en tiempo real la entidad `LocalContactEntity` del proveedor
//     identificado por `providerId` usando `LocalContactRepository.watchById`.
//     Cualquier edición (desde el form, el directorio o el picker) re-emite.
//   - Calcula completeness al vuelo con el helper puro.
//   - Ofrece acciones `softDelete` y `restore` (misma semántica que el
//     directorio, dupliquemos lo mínimo por consistencia con ADR §15:
//     controller de composición, sin mini-backend).
//
// QUÉ NO HACE:
//   - NO carga categorías de catálogo, nombres de ciudad vía RPC, ni
//     enriquece con info externa. El detalle es un rostro LECTOR del mismo
//     stream que ya conoce el directorio.
//   - NO duplica la regla de completeness: consume el helper.
//   - NO abre flujos cruzados (relaciones, pedidos, etc.) — ese alcance
//     queda para el módulo Red Operativa v2.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/entities/core_common/provider_branch_entity.dart';
import '../../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../../domain/services/core_common/local_contact_completeness.dart';

class ProviderDetailController extends GetxController {
  final LocalContactRepository _contacts;
  final String providerId;

  ProviderDetailController({
    required LocalContactRepository contacts,
    required this.providerId,
  }) : _contacts = contacts;

  final Rxn<LocalContactEntity> provider = Rxn<LocalContactEntity>();
  final isLoading = true.obs;
  final RxnString error = RxnString();

  StreamSubscription<LocalContactEntity?>? _sub;

  @override
  void onInit() {
    super.onInit();
    if (providerId.isEmpty) {
      error.value = 'Proveedor no especificado.';
      isLoading.value = false;
      return;
    }
    _sub = _contacts.watchById(providerId).listen(
      (value) {
        provider.value = value;
        if (isLoading.value) isLoading.value = false;
        if (value == null) {
          error.value = 'Este proveedor ya no existe.';
        } else {
          error.value = null;
        }
      },
      onError: (Object e) {
        debugPrint('[ProviderDetailController] stream error: $e');
        error.value = 'No se pudo cargar el proveedor.';
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  // ── DERIVADOS ────────────────────────────────────────────────────────────

  List<String> get missingFields {
    final p = provider.value;
    if (p == null) return const <String>[];
    return missingProviderProfileFields(p);
  }

  bool get isComplete => missingFields.isEmpty && provider.value != null;

  // ── ACCIONES ────────────────────────────────────────────────────────────

  Future<String?> softDelete() async {
    final p = provider.value;
    if (p == null) return 'Proveedor no cargado.';
    try {
      await _contacts.deleteById(p.id);
      return null;
    } catch (e) {
      debugPrint('[ProviderDetailController] softDelete fail: $e');
      return 'No se pudo eliminar el proveedor: $e';
    }
  }

  /// Persiste una nueva lista de sedes adicionales sobre el proveedor
  /// actual, preservando el resto de campos. Llamado desde el detalle cuando
  /// el usuario agrega, edita o elimina una sede.
  ///
  /// NO pasa por el probe (misma política del form completo). Retorna `null`
  /// si OK; mensaje humano si falla la persistencia local.
  Future<String?> saveAdditionalBranches(
    List<ProviderBranchEntity> branches,
  ) async {
    final p = provider.value;
    if (p == null) return 'Proveedor no cargado.';
    try {
      final updated = p.copyWith(
        additionalBranches: List<ProviderBranchEntity>.unmodifiable(branches),
        updatedAt: DateTime.now().toUtc(),
      );
      await _contacts.save(updated);
      return null;
    } catch (e) {
      debugPrint(
          '[ProviderDetailController] saveAdditionalBranches fail: $e');
      return 'No se pudo actualizar las sedes: $e';
    }
  }

  Future<String?> restore() async {
    final p = provider.value;
    if (p == null) return 'Proveedor no cargado.';
    try {
      final restored = p.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: DateTime.now().toUtc(),
      );
      await _contacts.save(restored);
      return null;
    } catch (e) {
      debugPrint('[ProviderDetailController] restore fail: $e');
      return 'No se pudo restaurar el proveedor: $e';
    }
  }
}
