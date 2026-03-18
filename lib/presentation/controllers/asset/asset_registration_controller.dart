// ============================================================================
// lib/presentation/controllers/asset/asset_registration_controller.dart
// ASSET REGISTRATION CONTROLLER — Gestión de sesión de registro de activo
//
// QUÉ HACE:
// - Gestiona el estado de una sesión de registro de activo en un portafolio
//   existente.
// - Lee AssetRegistrationContext desde Get.arguments en onInit().
// - Expone campos de formulario RUNT como observables reactivos (draftPlate,
//   draftDocType, draftDocNumber) para persistencia en memoria durante el flujo.
// - registerVehicle(): orquesta el registro final del activo:
//   persiste en repositorio, limpia estado RUNT, navega a portfolioAssets.
//
// QUÉ NO HACE:
// - No crea portafolios (eso es CreatePortfolioController).
// - No hace polling RUNT (eso es RuntQueryController).
// - No accede directamente a Isar ni a Firebase.
// - No llama clearQueryState() en onClose() — la limpieza RUNT es siempre
//   explícita: tras registro exitoso o cancelación explícita del usuario.
//
// PRINCIPIOS:
// - DIContainer para acceso a repositorios.
// - registrationContext es nullable — guard explícito antes de cualquier uso.
// - Sin fenix: true — AssetRegistrationPage permanece en stack durante todo
//   el flujo (ver arquitectura A4), por lo que el controller nunca es destruido
//   prematuramente.
// - Limpieza RUNT en puntos explícitos del flujo, no en onClose().
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 separación Portfolio / Asset Registration.
// Elimina el bug draftId == portfolioId del subsistema RUNT.
// Reemplaza el hack de pre-configuración manual de CreatePortfolioController
// desde PortfolioDetailController y PortfolioAssetListPage.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/errors/asset_creation_exception.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../domain/value/registration/asset_runt_snapshot.dart';
import '../../../routes/app_pages.dart';
import '../runt/runt_query_controller.dart';
import '../session_context_controller.dart';

/// Controller de presentación para el flujo de registro de un activo.
///
/// Instanciado por [AssetRegistrationBinding] al navegar a [Routes.assetRegister].
/// Gestiona el estado de formulario del RUNT y orquesta el registro final.
class AssetRegistrationController extends GetxController {
  // ──────────────────────────────────────────────────────────────────────────
  // Contexto de la sesión de registro
  // ──────────────────────────────────────────────────────────────────────────

  /// Contexto inmutable de esta sesión de registro.
  ///
  /// Inicializado desde Get.arguments en [onInit()].
  /// Null si el argumento de navegación es inválido — en ese caso
  /// [AssetRegistrationPage] muestra un guard de error y retorna.
  AssetRegistrationContext? registrationContext;

  // ──────────────────────────────────────────────────────────────────────────
  // Estado observable
  // ──────────────────────────────────────────────────────────────────────────

  /// Indica que registerVehicle() está en curso.
  /// La UI deshabilita botones cuando es true.
  final isLoading = false.obs;

  /// Bloqueo de UI durante la transición de registro → navegación.
  ///
  /// Se activa al inicio de [registerVehicle()] y permanece true hasta que
  /// [Get.offAllNamed] destruye la pantalla. Esto evita que [RuntQueryResultPage]
  /// reevalúe [RuntQueryController.vehicleData] (que queda null tras
  /// [clearQueryState()]) antes de que la navegación final haya ocurrido,
  /// previniendo el glitch visual de "No se obtuvieron resultados".
  ///
  /// Solo se resetea a false en caso de error — en el camino exitoso,
  /// el controller es destruido por la navegación antes de que importe.
  final isRegistering = false.obs;

  // ── Draft del formulario RUNT (en memoria, no persistido en Isar) ──────────
  // Estos campos permiten que AssetRegistrationPage restaure los valores
  // del formulario si Flutter reconstruye el widget sin destruir el controller.

  /// Placa ingresada en el formulario.
  final draftPlate = ''.obs;

  /// Tipo de documento seleccionado ('CC', 'CE', 'NIT').
  final draftDocType = RxnString();

  /// Número de documento ingresado en el formulario.
  final draftDocNumber = ''.obs;

  // ──────────────────────────────────────────────────────────────────────────
  // Ciclo de vida
  // ──────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    // Leer el contexto de navegación tipado.
    final arg = Get.arguments;
    if (arg is AssetRegistrationContext) {
      registrationContext = arg;
      if (kDebugMode) {
        debugPrint(
          '[ASSET_REG][onInit] contexto recibido:\n'
          '  portfolioId=${arg.portfolioId}\n'
          '  portfolioName="${arg.portfolioName}"\n'
          '  assetType=${arg.assetType}\n'
          '  registrationSessionId=${arg.registrationSessionId}',
        );
      }
    } else {
      // registrationContext queda null → AssetRegistrationPage mostrará guard.
      if (kDebugMode) {
        debugPrint(
          '[ASSET_REG][onInit] ⚠️ argumento inválido: '
          'esperado AssetRegistrationContext, recibido ${arg.runtimeType}',
        );
      }
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Operación principal: registrar activo
  // ──────────────────────────────────────────────────────────────────────────

  /// Registra el activo consultado y vincula al portafolio.
  ///
  /// Flujo:
  /// 1. Valida que registrationContext esté disponible.
  /// 2. Resuelve uid y orgId del usuario autenticado.
  /// 3. Llama [AssetRepository.createAssetFromRuntAndLinkToPortfolio].
  /// 4. Limpia el estado RUNT: [RuntQueryController.clearQueryState()].
  /// 5. Obtiene el [PortfolioEntity] actualizado del repositorio.
  /// 6. Navega a [Routes.portfolioAssets] con el portafolio como argumento.
  ///    Si getPortfolioById() devuelve null, navega con null (PortfolioAssetListPage
  ///    ya tiene guard de argumento inválido).
  ///
  /// Lanza [AssetCreationException] con código tipado para mensajes de UI:
  /// - [AssetCreationExceptionCode.duplicatePlate] → placa ya registrada.
  Future<void> registerVehicle({
    required String plate,
    required String marca,
    required String modelo,
    int? anio,
    AssetRuntSnapshot runtSnapshot = AssetRuntSnapshot.empty,
  }) async {
    final ctx = registrationContext;
    if (ctx == null) {
      if (kDebugMode) {
        debugPrint(
          '[ASSET_REG][registerVehicle] ⚠️ registrationContext es null — '
          'no se puede registrar el activo.',
        );
      }
      return;
    }

    final createdBy = _resolveUid();
    if (createdBy == null || createdBy.isEmpty) {
      if (kDebugMode) {
        debugPrint('[ASSET_REG][registerVehicle] UID no disponible → redirect welcome');
      }
      Get.offAllNamed(Routes.welcome);
      return;
    }

    final orgId = _resolveOrgId();
    if (orgId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[ASSET_REG][registerVehicle] orgId vacío → redirect countryCity');
      }
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    // Activar isRegistering antes de cualquier operación asíncrona.
    // RuntQueryResultPage observa este flag y muestra un loading overlay
    // en lugar de reevaluar vehicleData (que quedará null tras clearQueryState).
    isRegistering.value = true;

    bool registrationSucceeded = false;

    try {
      isLoading.value = true;

      await DIContainer().assetRepository.createAssetFromRuntAndLinkToPortfolio(
        portfolioId: ctx.portfolioId,
        orgId: orgId,
        plate: plate,
        marca: marca,
        modelo: modelo,
        anio: anio ?? 0,
        countryId: ctx.countryId,
        cityId: ctx.cityId ?? '',
        createdBy: createdBy,
        runtSnapshot: runtSnapshot,
      );

      if (kDebugMode) {
        debugPrint(
          '[ASSET_REG][registerVehicle] activo registrado:\n'
          '  plate=$plate portfolioId=${ctx.portfolioId}',
        );
      }

      // Limpieza RUNT explícita tras registro exitoso.
      // isRegistering permanece true durante clearQueryState() para que
      // RuntQueryResultPage no reevalúe vehicleData (que quedará null aquí)
      // y no muestre el glitch "No se obtuvieron resultados".
      if (Get.isRegistered<RuntQueryController>()) {
        await Get.find<RuntQueryController>().clearQueryState();
      }

      // Obtener el PortfolioEntity actualizado para pasarlo como argumento.
      // portfolioAssets requiere PortfolioEntity — lo obtenemos del repositorio.
      // Si el fetch falla (portfolio fue eliminado), se navega con null;
      // PortfolioAssetListPage tiene guard de argumento inválido.
      final portfolio = await DIContainer()
          .portfolioRepository
          .getPortfolioById(ctx.portfolioId);

      if (kDebugMode && portfolio == null) {
        debugPrint(
          '[ASSET_REG][registerVehicle] ⚠️ getPortfolioById devolvió null '
          'para portfolioId=${ctx.portfolioId} — navegando con null.',
        );
      }

      registrationSucceeded = true;

      // Limpiar todo el stack del flujo de registro y aterrizar en la lista
      // de activos del portafolio. El usuario ve el activo recién registrado.
      Get.offAllNamed(Routes.portfolioAssets, arguments: portfolio);
    } on AssetCreationException {
      rethrow; // La UI maneja los códigos tipados con mensajes específicos.
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASSET_REG][registerVehicle] error inesperado: $e');
      }
      rethrow;
    } finally {
      isLoading.value = false;
      // isRegistering solo se resetea en error — en el camino exitoso el
      // controller es destruido por Get.offAllNamed antes de que importe.
      if (!registrationSucceeded) isRegistering.value = false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers de sesión (privados)
  // ──────────────────────────────────────────────────────────────────────────

  /// UID del usuario autenticado.
  ///
  /// Fuente primaria: [SessionContextController].
  /// Fallback: [FirebaseAuth.instance.currentUser].
  String? _resolveUid() {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final uid = Get.find<SessionContextController>().user?.uid;
        if (uid != null && uid.isNotEmpty) return uid;
      }
    } catch (_) {}
    // Fallback: SessionContextController vacío o no registrado.
    final fallbackUid = FirebaseAuth.instance.currentUser?.uid;
    if (kDebugMode) {
      debugPrint(
        '[ASSET_REG][_resolveUid] ⚠️ usando fallback FirebaseAuth '
        '(SessionContextController no disponible). uid=$fallbackUid',
      );
    }
    return fallbackUid;
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
}
