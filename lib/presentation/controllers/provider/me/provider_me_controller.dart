// ============================================================================
// lib/presentation/controllers/provider/me/provider_me_controller.dart
// PROVIDER ME CONTROLLER — vista agregada self del provider (MF1).
//
// QUÉ HACE:
//   - Carga `GET /v1/providers/me` desde DIContainer.
//   - Expone `me`, `loading`, `error` como Rx para la UI.
//   - Si tras la primera carga `isProvider=false`, redirige a
//     `/provider/bootstrap` (gate operativo del wizard).
//
// QUÉ NO HACE:
//   - NO pasa providerProfileId a otras pantallas (M2 lo cachea).
//   - NO toca invitations / incoming / claim (otras MF).
//   - NO escribe en backend.
//
// PATRÓN:
//   - Repos via `DIContainer()` (regla CLAUDE.md).
//   - Controller via `Get.lazyPut` desde el binding.
//   - Manejo defensivo de excepciones tipadas con UX en español.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../application/services/access/provider_context_store.dart';
import '../../../../core/di/container.dart';
import '../../../../domain/entities/provider/provider_me_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/provider/provider_self_repository.dart';
import '../../../../routes/app_routes.dart';

class ProviderMeController extends GetxController {
  final ProviderSelfRepository _repo = DIContainer().providerSelfRepository;

  /// Estado agregado del provider para el workspace activo. Null durante
  /// la primera carga.
  final Rx<ProviderMeEntity?> me = Rx<ProviderMeEntity?>(null);

  /// `true` durante una carga / refresh.
  final RxBool loading = false.obs;

  /// Mensaje de error UX-ready en español. Vacío cuando no hay error.
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  /// Carga el estado desde backend. Tras cargar, si `isProvider=false`,
  /// redirige a `/provider/bootstrap` (gate operativo del wizard).
  @override
  Future<void> refresh() async {
    loading.value = true;
    error.value = '';
    try {
      final result = await _repo.me();
      me.value = result;
      // Sincroniza el store reactivo canónico — drawer/shell lo leen sin
      // disparar HTTP en cada build.
      if (Get.isRegistered<ProviderContextStore>()) {
        Get.find<ProviderContextStore>().set(
          isProvider: result.isProvider,
          workspaceId: result.workspaceId,
        );
      }
      if (kDebugMode) {
        debugPrint('[ProviderContext] '
            'isProvider=${result.isProvider} '
            'workspaceId=${result.workspaceId} '
            'capabilities=${result.capabilities.length}');
      }
      // Fase 2 — UNIFIED PROVIDER SHELL:
      // Cuando el body se renderiza dentro del shell unificado, el
      // ProviderBootstrapGate ya garantizó isProvider=true antes de
      // pintar; aquí no se redirige.
      // Para el deep link `/provider/me` (uso aislado), SI no es
      // proveedor todavía mandamos al wizard.
      if (!result.isProvider && Get.currentRoute == Routes.providerMe) {
        Get.offAllNamed(Routes.providerBootstrap);
        return;
      }
    } on UnauthorizedException catch (e) {
      error.value = 'Sesión inválida. Vuelve a iniciar sesión. (${e.message})';
    } on WorkspaceNotFoundException catch (_) {
      error.value =
          'Workspace no resuelto. Cierra sesión y vuelve a entrar.';
    } on NetworkException catch (_) {
      error.value = 'Sin conexión. Reintenta cuando tengas red.';
    } on ServerException catch (e) {
      error.value =
          'Error del servidor (${e.statusCode}). Intenta más tarde.';
    } on BadRequestException catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }
}
