// ============================================================================
// lib/presentation/pages/portfolio/controllers/create_portfolio_controller.dart
// CREATE PORTFOLIO CONTROLLER — Enterprise Ultra Pro
//
// QUÉ HACE:
// - Coordina el wizard de creación de portafolio (Step1 + Step2).
// - Persiste el DRAFT completo del wizard (Step1 + Step2) como estado reactivo.
//   Esto garantiza que el usuario NO pierda información al navegar entre pasos.
// - Step1: crea portafolio DRAFT en Isar con UID real del usuario autenticado.
// - Step2: registra primer activo vía AssetRepository end-to-end.
//
// DISEÑO DE DRAFT:
// Todos los campos del formulario multi-paso viven en este controller como
// observables. Los widgets leen el draft en initState y escriben en cada cambio.
// Así, al volver al paso anterior y regresar, los datos se restauran.
//
// QUÉ NO HACE:
// - No toca Isar directamente (delega a repositorios).
// - No modifica RuntService, RuntRepository ni RuntController.
//
// NOTAS:
// - UID real: SessionContextController como fuente primaria;
//   FirebaseAuth.instance.currentUser como fallback.
// - AssetCreationException se propaga sin envolver para mensajes tipados en UI.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/entities/asset/asset_registration_draft_entity.dart';
import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../../domain/errors/asset_creation_exception.dart';
import '../../../../domain/repositories/asset_registration_draft_repository.dart';
import '../../../../domain/repositories/portfolio_repository.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../routes/app_pages.dart';
import '../../../controllers/session_context_controller.dart';

/// Controller compartido entre Step1 y Step2.
/// Step1 usa Get.put(), Step2 usa Get.find().
class CreatePortfolioController extends GetxController {
  late final PortfolioRepository _portfolioRepository;
  late final AssetRegistrationDraftRepository _draftRepository;

  final isLoading = false.obs;

  /// ID del portafolio creado en Step1; requerido en Step2.
  String? portfolioId;

  // ── Draft Step 1 ────────────────────────────────────────────────────────────

  /// Tipo de activo elegido por el usuario.
  /// null = usuario no ha seleccionado aún (muestra placeholder).
  /// Persiste entre navegaciones para que Step2 pueda leerlo y que al
  /// volver a Step1 el selector no quede en blanco.
  final selectedAssetType = Rxn<AssetType>();

  /// Nombre del portafolio ingresado o auto-generado.
  /// Persiste para que no desaparezca al navegar hacia Step2 y volver.
  final draftPortfolioName = ''.obs;

  /// País seleccionado en Step1.
  final draftCountryId = RxnString();

  /// Región seleccionada en Step1 (requerida para el draft de registro de activo).
  final draftRegionId = RxnString();

  /// Ciudad seleccionada en Step1.
  final draftCityId = RxnString();

  // ── Draft Step 2 ────────────────────────────────────────────────────────────

  /// Tipo de documento del propietario para la consulta RUNT.
  /// Persiste entre navegaciones para no re-seleccionarlo.
  final draftDocType = RxnString();

  /// Número de documento ingresado por el usuario.
  final draftDocNumber = ''.obs;

  /// Placa del vehículo a consultar.
  final draftPlate = ''.obs;

  // ── Helpers de negocio ───────────────────────────────────────────────────────

  bool get isVehiculo => selectedAssetType.value == AssetType.vehiculo;

  @override
  void onInit() {
    super.onInit();
    _portfolioRepository = DIContainer().portfolioRepository;
    _draftRepository = DIContainer().assetRegistrationDraftRepository;
  }

  // ---------------------------------------------------------------------------
  // Operaciones de limpieza del draft
  // ---------------------------------------------------------------------------

  /// Limpia únicamente el bloque RUNT (placa) del draft.
  /// NO borra tipo/número de documento, ya que el mismo propietario
  /// podría consultar otro vehículo. NO borra datos del Step1.
  void clearRuntDraft() {
    draftPlate.value = '';
    // El resultado de RUNT (vehicleData) se limpia en RuntController,
    // que es quien lo posee. Este método solo borra el campo de placa
    // para que el usuario pueda ingresar una nueva.
  }

  // ---------------------------------------------------------------------------
  // Helpers de sesión (privados)
  // ---------------------------------------------------------------------------

  /// UID del usuario autenticado.
  String? _resolveUid() {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final uid = Get.find<SessionContextController>().user?.uid;
        if (uid != null && uid.isNotEmpty) return uid;
      }
    } catch (_) {}
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// orgId del contexto activo del usuario.
  String _resolveOrgId() {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final orgId =
            Get.find<SessionContextController>().user?.activeContext?.orgId;
        if (orgId != null && orgId.isNotEmpty) return orgId;
      }
    } catch (_) {}
    return '';
  }

  // ---------------------------------------------------------------------------
  // Step 1: Crear portafolio DRAFT
  // ---------------------------------------------------------------------------

  Future<void> createPortfolioStep1({
    required PortfolioType portfolioType,
    required String portfolioName,
    required String countryId,
    required String cityId,
  }) async {
    final currentUserId = _resolveUid();
    if (currentUserId == null || currentUserId.isEmpty) {
      Get.snackbar(
        'Sesión requerida',
        'Inicia sesión para continuar.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      Get.offAllNamed(Routes.welcome);
      return;
    }

    try {
      isLoading.value = true;

      final portfolioData = PortfolioEntity(
        id: '',
        portfolioType: portfolioType,
        portfolioName: portfolioName,
        countryId: countryId,
        cityId: cityId,
        status: PortfolioStatus.draft,
        assetsCount: 0,
        createdBy: currentUserId,
        createdAt: DateTime.now().toUtc(),
      );

      final created = await _portfolioRepository.createPortfolio(portfolioData);
      portfolioId = created.id;

      // Reflejar valores persistidos también en el draft del controller.
      // Esto asegura que Step2 siempre encuentre los datos de Step1.
      draftCountryId.value = countryId;
      draftCityId.value = cityId;
      draftPortfolioName.value = portfolioName;

      // Crear draft de registro en Isar usando el portfolioId como draftId.
      // Esto permite que RuntQueryController persista y restaure el estado
      // del job RUNT a través de reinicios de la app.
      await _draftRepository.saveDraft(
        AssetRegistrationDraftEntity(
          draftId: created.id,
          orgId: _resolveOrgId(),
          assetType: selectedAssetType.value?.name ?? '',
          portfolioName: portfolioName,
          countryId: countryId,
          regionId: draftRegionId.value ?? '',
          cityId: cityId,
          runtStatus: 'idle',
          runtProgressPercent: 0,
          updatedAt: DateTime.now().toUtc(),
        ),
      );

      if (kDebugMode) {
        debugPrint(
          '[P2D][Portfolio][Step1] DRAFT created: $portfolioId '
          'uid=$currentUserId country=$countryId city=$cityId',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[P2D][Portfolio][Step1] error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Step 2: Vincular primer activo al portafolio
  // ---------------------------------------------------------------------------

  /// Registra el primer activo y lo vincula al portafolio creado en Step1.
  ///
  /// Lanza [AssetCreationException] con código tipado para mensajes de UI:
  /// - [AssetCreationExceptionCode.duplicatePlate] → placa ya registrada.
  Future<void> linkFirstAssetToPortfolio({
    required String plate,
    required String marca,
    required String modelo,
    required int anio,
  }) async {
    if (portfolioId == null) {
      throw Exception('No hay portafolio creado. Completa el Paso 1 primero.');
    }

    final createdBy = _resolveUid();
    if (createdBy == null || createdBy.isEmpty) {
      Get.offAllNamed(Routes.welcome);
      return;
    }

    final orgId = _resolveOrgId();
    if (orgId.isEmpty) {
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    // Usar draft del Step1; fallback 'CO' como guardia mínima.
    final countryId = draftCountryId.value?.isNotEmpty == true
        ? draftCountryId.value!
        : 'CO';
    final cityId = draftCityId.value ?? '';

    try {
      isLoading.value = true;

      await DIContainer().assetRepository.createAssetFromRuntAndLinkToPortfolio(
        portfolioId: portfolioId!,
        orgId: orgId,
        plate: plate,
        marca: marca,
        modelo: modelo,
        anio: anio,
        countryId: countryId,
        cityId: cityId,
        createdBy: createdBy,
      );

      if (kDebugMode) {
        debugPrint(
          '[P2D][Portfolio][Step2] asset linked: '
          'plate=$plate portfolioId=$portfolioId orgId=$orgId',
        );
      }
    } on AssetCreationException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[P2D][Portfolio][Step2] error linking asset: $e');
      }
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
