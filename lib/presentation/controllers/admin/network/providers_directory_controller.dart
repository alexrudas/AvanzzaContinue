// ============================================================================
// lib/presentation/controllers/admin/network/providers_directory_controller.dart
// PROVIDERS DIRECTORY CONTROLLER — Fase 1 del arquetipo comercial/servicio
// ============================================================================
// QUÉ HACE:
//   - Expone la lista reactiva de PROVEEDORES del workspace activo (primer
//     rostro visible del arquetipo transversal comercial/servicio) a partir
//     del stream canónico `LocalContactRepository.watchByWorkspace(orgId)`.
//   - Filtra por `roleLabel == 'proveedor'` (y por compat, contactos antiguos
//     sin rol — idéntico criterio que `PurchaseRequestController`, para que
//     ambas vistas muestren SIEMPRE el mismo universo).
//   - Ofrece búsqueda por displayName (case-insensitive).
//   - Ofrece acciones de edición de teléfono/categoría (save canónico) y
//     eliminación (soft delete canónico) delegadas al repositorio.
//
// QUÉ NO HACE:
//   - NO duplica lógica del repo: edit y delete llaman directamente a
//     `LocalContactRepository.save` y `.deleteById`. El controller es de
//     composición (ADR §15: no mini-backend en controller).
//   - NO expone la creación: la creación vive en el widget compartido
//     `showNewVendorDialog`; la page abre ese diálogo directamente.
//     Justificación: la creación NO requiere estado del controller; el
//     stream del repo hidratará la lista cuando el write local complete.
//   - NO se suscribe al picker de Pedidos ni a otros controllers: la única
//     fuente de verdad es el stream del repo.
//
// REACTIVIDAD:
//   - Stream Isar multi-suscriptor: si se crea un proveedor desde Pedidos
//     (via `showNewVendorDialog`), la lista aquí se actualiza sin intervención
//     del usuario. Si se elimina desde aquí, el selector de Pedidos pierde el
//     tile (el controller de Pedidos ya descarta seleccionados desaparecidos,
//     ver `purchase_request_controller.dart:_bindContactsStream`).
//
// TENANCY:
//   - `orgId` se resuelve en el binding desde SessionContextController y se
//     inyecta como String inmutable al controller. Si `orgId` está vacío,
//     la lista queda vacía y se expone `error` humano.
//
// ENTERPRISE NOTES:
//   - Controller parametrizable por `roleLabel` para habilitar en el futuro
//     directorios de Taller / Técnico / Asesor sin rehacer lógica. Hoy el
//     binding lo instancia con `kRoleLabelVendor`.
//   - La edición rápida actualmente permite modificar displayName, teléfono
//     y categoría (notesPrivate). Para edición profunda (email, docId, org,
//     tags) se reutiliza el mismo `save` del repo desde una hoja de detalle
//     cuando se habilite; este controller no cierra la puerta.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/core_common/constants/role_labels.dart';
import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../../domain/services/core_common/key_normalizer.dart';
import '../../../../domain/services/core_common/local_contact_completeness.dart';

class ProvidersDirectoryController extends GetxController {
  final LocalContactRepository _contacts;
  final String _orgId;

  /// Rol a filtrar. Mantiene el controller abierto a futuros rostros del
  /// arquetipo (taller, técnico, asesor) sin refactor. Hoy siempre 'proveedor'.
  final String roleLabel;

  /// Código país por defecto para normalizar teléfonos en edición rápida.
  /// Misma convención que `new_vendor_dialog.dart`.
  final String defaultCountryCallingCode;

  ProvidersDirectoryController({
    required LocalContactRepository localContacts,
    required String orgId,
    this.roleLabel = kRoleLabelVendor,
    this.defaultCountryCallingCode = '57',
  })  : _contacts = localContacts,
        _orgId = orgId;

  /// Expone `orgId` al caller (UI) sin acoplarlo a `SessionContextController`.
  /// Lo usa la página para pasar `workspaceId` al diálogo compartido
  /// `showNewVendorDialog`. Cadena única de resolución: binding → controller →
  /// UI; evita que el widget resuelva sesión por su cuenta.
  String get orgIdForNewContact => _orgId;

  // ── ESTADO REACTIVO ──────────────────────────────────────────────────────

  /// Universo crudo del stream (filtrado ya solo por no-deleted en el repo).
  final RxList<LocalContactEntity> _all = <LocalContactEntity>[].obs;

  /// Carga inicial: true mientras no haya llegado la PRIMERA emisión del
  /// stream. A partir de la primera emisión el reactivo manda.
  final isLoading = true.obs;

  /// Error humano de configuración (ej. orgId vacío). Los errores de IO del
  /// repo no se exponen aquí (Isar local no suele fallar; Firestore enqueue
  /// es async). Si aparecen casos reales, añadir un `onError` al subscribe.
  final RxnString error = RxnString();

  /// Búsqueda libre por displayName (case-insensitive).
  final searchQuery = ''.obs;

  /// Filtro opcional de completitud:
  ///   - null  = todos
  ///   - true  = solo perfiles completos
  ///   - false = solo perfiles incompletos
  /// La regla de completitud vive en `local_contact_completeness.dart`; este
  /// controller NO decide nada por sí mismo — consume el helper puro.
  final Rxn<bool> completenessFilter = Rxn<bool>();

  StreamSubscription<List<LocalContactEntity>>? _sub;

  // ── LIFECYCLE ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    if (_orgId.isEmpty) {
      isLoading.value = false;
      error.value = 'Organización no disponible en la sesión.';
      return;
    }
    _bindStream();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _bindStream() {
    _sub?.cancel();
    _sub = _contacts.watchByWorkspace(_orgId).listen(
      (list) {
        _all.assignAll(list);
        if (isLoading.value) isLoading.value = false;
      },
      onError: (Object e) {
        debugPrint('[ProvidersDirectoryCtrl] stream error: $e');
        error.value = 'No se pudo cargar el directorio.';
        isLoading.value = false;
      },
    );
  }

  // ── DERIVADOS ────────────────────────────────────────────────────────────

  /// Subconjunto que satisface:
  ///   - está marcado como proveedor (o sin rol por compat con altas previas
  ///     a la existencia de `kRoleLabelVendor`);
  ///   - pasa el filtro de búsqueda por displayName;
  ///   - cumple el filtro de completitud, si está activo.
  List<LocalContactEntity> get filteredProviders {
    final q = searchQuery.value.trim().toLowerCase();
    final cFilter = completenessFilter.value;
    return _all.where((c) {
      final r = c.roleLabel?.trim();
      final isProvider =
          r == null || r.isEmpty || isVendorRoleLabel(r);
      if (!isProvider) return false;
      if (q.isNotEmpty &&
          !c.displayName.toLowerCase().contains(q)) {
        return false;
      }
      if (cFilter != null) {
        final complete = isProviderProfileComplete(c);
        if (cFilter != complete) return false;
      }
      return true;
    }).toList(growable: false);
  }

  /// Conteo de proveedores (sin filtros de búsqueda) agrupados por
  /// completeness, útil para los chips del header. Refleja la foto del
  /// universo de proveedores del workspace.
  ({int total, int complete, int incomplete}) get completenessCounts {
    int complete = 0;
    int incomplete = 0;
    for (final c in _all) {
      final r = c.roleLabel?.trim();
      final isProvider =
          r == null || r.isEmpty || isVendorRoleLabel(r);
      if (!isProvider) continue;
      if (isProviderProfileComplete(c)) {
        complete++;
      } else {
        incomplete++;
      }
    }
    return (
      total: complete + incomplete,
      complete: complete,
      incomplete: incomplete,
    );
  }

  /// True si un proveedor dado cumple la regla de completitud. Expuesto para
  /// que el tile no tenga que importar el helper ni el módulo de dominio.
  bool isProviderComplete(LocalContactEntity p) =>
      isProviderProfileComplete(p);

  /// True cuando el stream ya emitió y el universo total del workspace está
  /// vacío. Diferenciado de `filteredProviders.isEmpty` porque "no hay nada"
  /// y "no hay resultados para la búsqueda" son dos empty states distintos.
  bool get hasNoProvidersAtAll {
    final q = searchQuery.value.trim();
    return q.isEmpty && filteredProviders.isEmpty;
  }

  // ── ACCIONES ────────────────────────────────────────────────────────────

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  /// Cambia el filtro de completitud.
  ///   - null  = mostrar todos
  ///   - true  = solo completos
  ///   - false = solo incompletos
  void setCompletenessFilter(bool? value) {
    completenessFilter.value = value;
  }

  /// Edición rápida: actualiza displayName / teléfono / categoría. Mantiene
  /// el `id`, `workspaceId`, `createdAt`, `roleLabel`, tags y resto.
  /// Retorna `null` si OK; mensaje humano si falló (persistencia local).
  Future<String?> updateProviderQuick({
    required LocalContactEntity existing,
    required String displayName,
    required String rawPhone,
    required String category,
  }) async {
    try {
      final phoneE164 = rawPhone.trim().isEmpty
          ? null
          : normalizePhoneE164(
              rawPhone.trim(),
              defaultCountryCallingCode: defaultCountryCallingCode,
            );
      final updated = existing.copyWith(
        displayName: displayName.trim(),
        primaryPhoneE164: phoneE164,
        notesPrivate: category.trim().isEmpty ? null : category.trim(),
        updatedAt: DateTime.now().toUtc(),
      );
      await _contacts.save(updated);
      return null;
    } catch (e) {
      debugPrint('[ProvidersDirectoryCtrl] updateProviderQuick fail: $e');
      return 'No se pudo guardar el proveedor: $e';
    }
  }

  /// Soft delete canónico (repo hace `isDeleted=true` + enqueue Firestore).
  /// El stream descartará el item en la próxima emisión — refresh automático.
  /// Retorna `null` si OK; mensaje humano si falló.
  Future<String?> softDeleteProvider(String id) async {
    try {
      await _contacts.deleteById(id);
      return null;
    } catch (e) {
      debugPrint('[ProvidersDirectoryCtrl] softDeleteProvider fail: $e');
      return 'No se pudo eliminar el proveedor: $e';
    }
  }

  /// Restaura un proveedor soft-deleted (undo). Utilizado por el snackbar de
  /// "Deshacer" tras un delete. `getById` del repo incluye soft-deleted por
  /// contrato, así que podemos recuperar la entidad completa y re-guardarla
  /// con `isDeleted=false`.
  Future<String?> restoreProvider(String id) async {
    try {
      final previous = await _contacts.getById(id);
      if (previous == null) {
        return 'No se encontró el proveedor para restaurar.';
      }
      final restored = previous.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: DateTime.now().toUtc(),
      );
      await _contacts.save(restored);
      return null;
    } catch (e) {
      debugPrint('[ProvidersDirectoryCtrl] restoreProvider fail: $e');
      return 'No se pudo restaurar el proveedor: $e';
    }
  }
}
