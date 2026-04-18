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
// - Gestiona la lista de placas para consulta multi-vehículo (plates,
//   plateInputError, addPlate(), removePlate()) — Phase 1 multi-plate feature.
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
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../domain/errors/asset_creation_exception.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../domain/value/registration/asset_runt_snapshot.dart';
import '../../../domain/value/registration/vehicle_plate_item.dart';
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

  // ── Lista de placas para consulta multi-vehículo ─────────────────────────

  /// Número máximo de placas que el usuario puede agregar por bloque de consulta.
  ///
  /// Límite operativo: el backend procesa hasta 10 vehículos por batch RUNT.
  /// La UI muestra un modal informativo si el usuario intenta superar este límite.
  static const int maxPlatesPerBatch = 10;

  /// Lista de placas agregadas por el usuario para consulta simultánea.
  ///
  /// Cada elemento es un [VehiclePlateItem] con placa + estado + error.
  /// Se limpia cuando el usuario inicia una nueva sesión de registro.
  final plates = <VehiclePlateItem>[].obs;

  /// Error de validación del campo de entrada de placa actual.
  ///
  /// Null cuando no hay error o el campo está vacío.
  final plateInputError = RxnString();

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

      // Pre-poblar placa si el contexto la trae (ej: desde AssetDetailPage
      // vía "Actualizar información"). En flujo estándar initialPlate es null.
      if (arg.initialPlate?.isNotEmpty == true) {
        draftPlate.value = arg.initialPlate!;
      }

      if (kDebugMode) {
        debugPrint(
          '[ASSET_REG][onInit] contexto recibido:\n'
          '  portfolioId=${arg.portfolioId}\n'
          '  portfolioName="${arg.portfolioName}"\n'
          '  assetType=${arg.assetType}\n'
          '  registrationSessionId=${arg.registrationSessionId}\n'
          '  initialPlate=${arg.initialPlate}',
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
  /// 3. Llama [AssetRepository.createAssetFromRuntAndLinkToPortfolio] → retorna [AssetEntity].
  /// 4. Limpia el estado RUNT: [RuntQueryController.clearQueryState()].
  /// 5. Obtiene el [PortfolioEntity] actualizado del repositorio.
  /// 6. Navega a [Routes.assetDetail] vía [AppNavigator.afterAssetRegistration].
  ///    Si getPortfolioById() devuelve null, [AppNavigator] aterriza en Home.
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

    // ── GUARDRAIL FINAL: integridad de portafolio ────────────────────────
    // Si el RUNT data proviene de un recovery de otro portafolio, el
    // registrationContext.portfolioId no coincide con recoveredPortfolioId.
    // En ese caso se aborta silenciosamente — la UI ya mostró el flujo
    // de redirección; este check es la última línea de defensa.
    if (Get.isRegistered<RuntQueryController>()) {
      final recoveredPid =
          Get.find<RuntQueryController>().recoveredPortfolioId;
      if (recoveredPid != null && recoveredPid != ctx.portfolioId) {
        if (kDebugMode) {
          debugPrint(
            '[ASSET_REG][registerVehicle] ABORTADO — guardrail portafolio: '
            'RUNT data pertenece a portfolioId=$recoveredPid, '
            'contexto actual=${ctx.portfolioId}. '
            'Registro bloqueado para evitar activo en portafolio incorrecto.',
          );
        }
        return;
      }
    }

    // Activar isRegistering antes de cualquier operación asíncrona.
    // RuntQueryResultPage observa este flag y muestra un loading overlay
    // en lugar de reevaluar vehicleData (que quedará null tras clearQueryState).
    isRegistering.value = true;

    bool registrationSucceeded = false;

    try {
      isLoading.value = true;

      // Captura el AssetEntity creado — necesario para la navegación al detalle.
      final createdAsset =
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
          '  assetId=${createdAsset.id} plate=$plate portfolioId=${ctx.portfolioId}',
        );
      }

      // Limpieza RUNT explícita tras registro exitoso.
      // isRegistering permanece true durante clearQueryState() para que
      // RuntQueryResultPage no reevalúe vehicleData (que quedará null aquí)
      // y no muestre el glitch "No se obtuvieron resultados".
      if (Get.isRegistered<RuntQueryController>()) {
        await Get.find<RuntQueryController>().clearQueryState();
      }

      // Obtener el PortfolioEntity actualizado para pasarlo a AppNavigator.
      // Si el fetch falla (portfolio fue eliminado), AppNavigator.backFromAssetDetail
      // usará el fallback a Home.
      final portfolio = await DIContainer()
          .portfolioRepository
          .getPortfolioById(ctx.portfolioId);

      if (kDebugMode && portfolio == null) {
        debugPrint(
          '[ASSET_REG][registerVehicle] ⚠️ getPortfolioById devolvió null '
          'para portfolioId=${ctx.portfolioId} — AppNavigator usará fallback Home.',
        );
      }

      registrationSucceeded = true;

      // Navegar al detalle del activo recién creado.
      // AppNavigator construye el argumento AssetDetailArgs y limpia el stack.
      // El AppBar back de AssetDetailPage irá al portafolio de forma explícita.
      if (portfolio != null) {
        AppNavigator.afterAssetRegistration(
          asset: createdAsset,
          portfolio: portfolio,
        );
      } else {
        // Portfolio no encontrado (eliminado entre el registro y el fetch).
        // Aterrizamos en el detalle del activo sin contexto de portafolio;
        // el back irá a Home como fallback seguro.
        Get.offAllNamed(Routes.assetDetail, arguments: createdAsset.id);
      }
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
  // Operaciones multi-placa
  // ──────────────────────────────────────────────────────────────────────────

  /// Agrega [draftPlate] a [plates] si la validación pasa.
  ///
  /// Validaciones:
  /// - Entre 5 y 7 caracteres alfanuméricos (cubre placas CO estándar y motos).
  /// - No duplicada en la lista actual (comparación case-insensitive).
  ///
  /// Si la validación falla, establece [plateInputError] y retorna sin agregar.
  /// Si pasa, limpia [plateInputError] y [draftPlate] para la siguiente entrada.
  void addPlate() {
    final plate = draftPlate.value.trim().toUpperCase();

    if (plate.length != 6) {
      plateInputError.value = 'La placa debe tener exactamente 6 caracteres';
      return;
    }

    if (plates.any((p) => p.plate == plate)) {
      plateInputError.value = 'Esta placa ya fue agregada';
      return;
    }

    // Límite operativo: no superar maxPlatesPerBatch por consulta.
    // La UI ya verifica esto antes de llamar addPlate(), pero este guard
    // asegura consistencia si se invoca desde otro contexto.
    if (plates.length >= maxPlatesPerBatch) {
      plateInputError.value =
          'Máximo $maxPlatesPerBatch vehículos por consulta';
      return;
    }

    plateInputError.value = null;
    plates.add(VehiclePlateItem(id: const Uuid().v4(), plate: plate));
    // Limpiar observable de entrada — el caller también debe limpiar el TextController.
    draftPlate.value = '';
  }

  /// Elimina de [plates] el elemento con el [id] dado.
  void removePlate(String id) {
    plates.removeWhere((p) => p.id == id);
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
