// ============================================================================
// lib/presentation/pages/portfolio/controllers/create_portfolio_controller.dart
// CREATE PORTFOLIO CONTROLLER — Wizard de creación de portafolio (Step1)
//
// QUÉ HACE:
// - Gestiona el wizard Step1: crea el portafolio en Isar/Firestore y expone
//   los primitivos necesarios (createdPortfolioId/Name/CountryId/CityId) para
//   que Step1Page construya un AssetRegistrationContext y navegue a assetRegister.
// - Persiste el DRAFT de formulario (nombre, país, ciudad, tipo) como observables
//   reactivos para que los campos no se reseteen al navegar hacia atrás.
//
// QUÉ NO HACE:
// - NO persiste un AssetRegistrationDraftEntity (draft RUNT) en createPortfolioStep1().
//   El draft RUNT vive exclusivamente en el flujo de AssetRegistrationController
//   usando registrationSessionId (UUID fresco). Hacerlo aquí recrearía el bug
//   draftId == portfolioId que esta migración elimina.
// - No registra activos directamente (linkFirstAssetToPortfolio está @Deprecated).
// - No toca Isar directamente (delega a repositorios).
//
// PRINCIPIOS:
// - UID real: SessionContextController como fuente primaria;
//   FirebaseAuth.instance.currentUser como fallback.
// - AssetCreationException se propaga sin envolver para mensajes tipados en UI.
//
// ENTERPRISE NOTES:
// MIGRADO (2026-03): Fase 1 separación Portfolio / Asset Registration.
// linkFirstAssetToPortfolio() y clearRuntDraft() marcados @Deprecated —
// muertos en el flujo activo; conservados para evitar romper compilación
// mientras se limpia el legacy en una fase posterior.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../../domain/errors/asset_creation_exception.dart';
import '../../../../domain/repositories/portfolio_repository.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../routes/app_pages.dart';
import '../../../controllers/session_context_controller.dart';

/// Controller compartido entre Step1 y Step2.
/// Step1 usa Get.put(), Step2 usa Get.find().
class CreatePortfolioController extends GetxController {
  late final PortfolioRepository _portfolioRepository;

  final isLoading = false.obs;

  /// ID del portafolio creado en Step1; requerido en Step2.
  String? portfolioId;

  // ── Primitivos expuestos para AssetRegistrationContext (Fase 1) ─────────────
  // Step1Page construye AssetRegistrationContext con estos valores tras crear
  // el portafolio. Son los únicos campos de PortfolioEntity que AssetRegistrationPage
  // necesita — no se expone PortfolioEntity completo por argumento de navegación.

  /// ID del portafolio creado. Alias legible de [portfolioId].
  String? createdPortfolioId;

  /// Nombre del portafolio creado (canónico, post-auto-generación).
  String? createdPortfolioName;

  /// countryId del portafolio creado.
  String? createdCountryId;

  /// cityId del portafolio creado (nullable — algunas jurisdicciones no lo requieren).
  String? createdCityId;

  // ── Draft Step 1 ────────────────────────────────────────────────────────────

  /// Tipo de activo elegido por el usuario (categoría wizard).
  /// null = usuario no ha seleccionado aún (muestra placeholder).
  /// Persiste entre navegaciones para que Step2 pueda leerlo y que al
  /// volver a Step1 el selector no quede en blanco.
  final selectedAssetType = Rxn<AssetRegistrationType>();

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

  bool get isVehiculo =>
      selectedAssetType.value == AssetRegistrationType.vehiculo;

  @override
  void onInit() {
    super.onInit();
    _portfolioRepository = DIContainer().portfolioRepository;
  }

  // ---------------------------------------------------------------------------
  // Operaciones de limpieza del draft
  // ---------------------------------------------------------------------------

  /// @Deprecated — Dead code desde Fase 1 (2026-03).
  /// El flujo activo usa AssetRegistrationController.registerVehicle() +
  /// RuntQueryController.clearQueryState(). Conservado para evitar romper
  /// compilación hasta limpieza de legacy en fase posterior.
  @Deprecated(
    'Usar RuntQueryController.clearQueryState() desde AssetRegistrationController. '
    'Este método no forma parte del flujo activo desde Fase 1 (2026-03).',
  )
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
        orgId: _resolveOrgId(),
        status: PortfolioStatus.draft,
        assetsCount: 0,
        createdBy: currentUserId,
        createdAt: DateTime.now().toUtc(),
      );

      final created = await _portfolioRepository.createPortfolio(portfolioData);
      portfolioId = created.id;

      // Primitivos expuestos para que Step1Page construya AssetRegistrationContext.
      // createdPortfolioName usa created.portfolioName (el valor canónico persistido
      // por el repositorio) en lugar del parámetro de entrada, por si el repositorio
      // normaliza o auto-genera el nombre.
      createdPortfolioId = created.id;
      createdPortfolioName = created.portfolioName;
      createdCountryId = created.countryId;
      createdCityId = created.cityId;

      // Reflejar valores en el draft del controller para que los campos
      // de Step1 no se reseteen si el usuario navega hacia atrás.
      draftCountryId.value = countryId;
      draftCityId.value = cityId;
      draftPortfolioName.value = portfolioName;

      // NOTA DE ARQUITECTURA: NO se persiste un AssetRegistrationDraftEntity aquí.
      // El draft RUNT vive exclusivamente en AssetRegistrationController usando
      // registrationSessionId (Uuid().v4()). Persistirlo con draftId == portfolioId
      // recrearía el bug que esta migración elimina.

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

  /// @Deprecated — Dead code desde Fase 1 (2026-03).
  /// El flujo activo usa AssetRegistrationController.registerVehicle().
  /// Conservado para evitar romper compilación hasta limpieza de legacy.
  @Deprecated(
    'Usar AssetRegistrationController.registerVehicle(). '
    'Este método no forma parte del flujo activo desde Fase 1 (2026-03).',
  )
  // ignore: deprecated_member_use_from_same_package
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
    final countryId =
        draftCountryId.value?.isNotEmpty == true ? draftCountryId.value! : 'CO';
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
