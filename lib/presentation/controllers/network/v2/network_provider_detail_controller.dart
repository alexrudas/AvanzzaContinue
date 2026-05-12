// ============================================================================
// lib/presentation/controllers/network/v2/network_provider_detail_controller.dart
// NETWORK PROVIDER DETAIL CONTROLLER — Read-only V1 detail de Mi Red
// ============================================================================
// QUÉ HACE:
//   - Carga `ProviderCanonicalEntity` vía `ProviderCanonicalRepository.getById`
//     (`GET /v1/providers/:providerProfileId`) y publica el resultado en un
//     sealed `ProviderDetailState`.
//   - Estados disjuntos: Loading | Loaded | NotFound | Error. Imposible
//     representar combinaciones inconsistentes.
//   - Provee `reload()` para reintentos desde la UI.
//
// QUÉ NO HACE:
//   - NO toca LocalContactRepository ni Isar. Esta page es 100% Core API.
//   - NO edita ni mutate state remoto. Solo lectura.
//   - NO infiere phone/email/availableActions desde otras fuentes — esos
//     campos no están en `ProviderCanonicalEntity` y NO se inventan.
//   - NO mantiene cache. La SSOT es Postgres via Core API.
// ============================================================================

import 'package:get/get.dart';

import '../../../../domain/entities/provider/provider_canonical_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/provider/provider_canonical_repository.dart';

/// Estado sealed de la página de detalle. Disjunto y exhaustivo.
sealed class ProviderDetailState {
  const ProviderDetailState();
}

class ProviderDetailLoading extends ProviderDetailState {
  const ProviderDetailLoading();
}

class ProviderDetailLoaded extends ProviderDetailState {
  final ProviderCanonicalEntity entity;
  const ProviderDetailLoaded(this.entity);
}

/// 404 PROVIDER_PROFILE_NOT_FOUND del backend, o providerProfileId vacío.
class ProviderDetailNotFound extends ProviderDetailState {
  const ProviderDetailNotFound();
}

/// Cualquier otra falla (network, server, schemaVersion, etc.). La UI
/// muestra mensaje genérico + botón "Reintentar" — no expone `error.toString()`.
class ProviderDetailError extends ProviderDetailState {
  final Object error;
  const ProviderDetailError(this.error);
}

class NetworkProviderDetailController extends GetxController {
  final ProviderCanonicalRepository _repository;

  /// ID del ProviderProfile a cargar. Inmutable durante la vida del
  /// controller — cada navegación instancia uno nuevo via Get.create.
  final String providerProfileId;

  final Rx<ProviderDetailState> _state =
      Rx<ProviderDetailState>(const ProviderDetailLoading());

  /// Guard contra reentrancia (pull-to-refresh + tap reintentar concurrente).
  bool _inFlight = false;

  NetworkProviderDetailController({
    required ProviderCanonicalRepository repository,
    required this.providerProfileId,
  }) : _repository = repository;

  /// Stream reactivo para Obx.
  Rx<ProviderDetailState> get stateRx => _state;

  /// Estado actual.
  ProviderDetailState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    // Disparo inicial. No se hace en el constructor porque GetX prefiere
    // efectos colaterales en lifecycle.
    reload();
  }

  /// Carga (o recarga) el ProviderProfile. Idempotente bajo concurrencia.
  Future<void> reload() async {
    if (_inFlight) return;
    _inFlight = true;
    _state.value = const ProviderDetailLoading();
    try {
      // providerProfileId vacío = navegación mal armada por el caller.
      // No vale la pena hacer un request que el backend va a rechazar.
      if (providerProfileId.isEmpty) {
        _state.value = const ProviderDetailNotFound();
        return;
      }
      final entity = await _repository.getById(providerProfileId);
      _state.value = ProviderDetailLoaded(entity);
    } on ProviderProfileNotFoundException {
      _state.value = const ProviderDetailNotFound();
    } catch (e) {
      // Cualquier otra excepción (Unauthorized, Forbidden, Network, Server,
      // BadRequest) cae al estado de error genérico. La UI muestra mensaje
      // neutro y botón Reintentar.
      _state.value = ProviderDetailError(e);
    } finally {
      _inFlight = false;
    }
  }
}
