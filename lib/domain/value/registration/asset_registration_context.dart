// ============================================================================
// lib/domain/value/registration/asset_registration_context.dart
// ASSET REGISTRATION CONTEXT — Value object de contexto de registro
//
// QUÉ HACE:
// - Transporta el contexto mínimo necesario para iniciar un flujo de registro
//   de activo: identificación del portafolio destino, tipo de activo y un ID
//   único de sesión de registro (registrationSessionId).
// - Actúa como argumento de navegación tipado para Get.toNamed(Routes.assetRegister).
//
// QUÉ NO HACE:
// - No carga datos de red ni de base de datos.
// - No es una entidad persistible. No tiene toJson/fromJson.
// - No expone PortfolioEntity completo — solo los campos primitivos necesarios.
//
// PRINCIPIOS:
// - Campos primitivos (String, String?) — sin dependencias de entidades de dominio.
//   Excepto assetType que usa el enum existente AssetRegistrationType.
// - registrationSessionId SIEMPRE es un UUID v4 generado en el entry point.
//   NUNCA debe ser el portfolioId. Esta es la garantía que elimina el bug
//   draftId == portfolioId en el subsistema RUNT.
// - cityId es nullable porque algunas jurisdicciones no requieren ciudad.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): parte de Fase 1 de separación Portfolio / Asset Registration.
// EXTENDIDO (2026-05): +vrcSnapshot +expectedRelationKind para soportar el
//   handoff onboarding → asset register sin Map<String,dynamic> sueltos.
//   Ambos opcionales — los entry points legacy (Step1, PortfolioDetail,
//   PortfolioAssetList, AssetDetail) siguen pasando solo los campos
//   originales. Backward compatible.
// ============================================================================

import '../../entities/core_common/value_objects/asset_actor_role.dart';
import '../../shared/enums/asset_type.dart';

/// Value object que transporta el contexto de un flujo de registro de activo.
///
/// Se construye en los entry points (Step1Page, PortfolioDetailController,
/// PortfolioAssetListPage) y se pasa como argumento de navegación a
/// [AssetRegistrationPage] vía `Get.toNamed(Routes.assetRegister, arguments: ctx)`.
///
/// ### Invariante crítica
/// [registrationSessionId] es siempre `Uuid().v4()` — nunca el portfolioId.
/// Esta invariante elimina el bug donde el subsistema RUNT recarga el job anterior
/// del mismo portafolio en lugar de iniciar una consulta nueva.
class AssetRegistrationContext {
  /// ID del portafolio destino donde se registrará el activo.
  final String portfolioId;

  /// Nombre del portafolio para mostrar en el header de la página.
  final String portfolioName;

  /// País del portafolio (ISO code, ej: 'CO', 'MX').
  final String countryId;

  /// Ciudad del portafolio. Nullable: algunas jurisdicciones no requieren ciudad.
  final String? cityId;

  /// Tipo de activo a registrar.
  ///
  /// Usa el enum tipado [AssetRegistrationType] — NUNCA String.
  final AssetRegistrationType assetType;

  /// ID único de esta sesión de registro.
  ///
  /// Se usa como `draftId` en [RuntQueryController.startQuery()] y
  /// [RuntQueryController.loadDraft()]. Generado como `Uuid().v4()` en el
  /// entry point — NUNCA debe ser igual a [portfolioId].
  ///
  /// Garantía: cada intento de registro tiene su propio draftId, lo que
  /// evita que un job RUNT completado de un registro anterior sea recargado
  /// automáticamente al iniciar un nuevo registro en el mismo portafolio.
  final String registrationSessionId;

  /// Placa pre-cargada al abrir el formulario de registro.
  ///
  /// Null en el flujo estándar (formulario vacío).
  /// Poblado cuando se navega desde [AssetDetailPage] vía "Actualizar
  /// información" — el activo ya tiene una placa conocida que se pre-rellena
  /// para evitar que el usuario la ingrese de nuevo.
  final String? initialPlate;

  /// Snapshot de los datos del activo capturados durante onboarding (Q5/P6
  /// de FusionadoFlow). Pre-llena el formulario RUNT cuando el usuario
  /// llega aquí justo tras `CompleteOnboardingUC`.
  ///
  /// Null en todos los entry points legacy (Step1, PortfolioDetail,
  /// PortfolioAssetList, AssetDetail "Actualizar información"). Solo el
  /// onboarding lo emite.
  ///
  /// **TEMPORAL** — sigue siendo `Map<String, String>?` porque hoy
  /// `DemoRegistrationState.assetData` ya es `Map<String, String>` y no hay
  /// VO canónico para el snapshot pre-RUNT. Cuando exista un VO tipado
  /// (`AssetIntakeDraft` o similar), reemplazar el tipo aquí. NO usar
  /// `Map<String, dynamic>` (anti-patrón documentado en memory).
  final Map<String, String>? vrcSnapshot;

  /// Hint del rol con el que VRC debe crear el primer `AssetActorLink`
  /// al añadir el primer asset al portfolio. Se propaga desde
  /// `Portfolio.expectedRelationKind` para evitar re-derivarlo en VRC
  /// cuando el flujo viene del onboarding.
  ///
  /// Null cuando:
  /// - El portfolio es legacy (creado antes de la feature de
  ///   expectedRelationKind), o
  /// - El usuario llega desde un entry point que no captura intent
  ///   (Step1, PortfolioDetail "Agregar otro activo", AssetDetail
  ///   "Actualizar información"). En esos casos VRC pregunta el rol
  ///   al añadir el activo.
  final AssetActorRole? expectedRelationKind;

  const AssetRegistrationContext({
    required this.portfolioId,
    required this.portfolioName,
    required this.countryId,
    this.cityId,
    required this.assetType,
    required this.registrationSessionId,
    this.initialPlate,
    this.vrcSnapshot,
    this.expectedRelationKind,
  });

  @override
  String toString() =>
      'AssetRegistrationContext('
      'portfolioId=$portfolioId, '
      'portfolioName=$portfolioName, '
      'countryId=$countryId, '
      'cityId=$cityId, '
      'assetType=$assetType, '
      'registrationSessionId=$registrationSessionId, '
      'vrcSnapshot=${vrcSnapshot == null ? 'null' : '${vrcSnapshot!.length} keys'}, '
      'expectedRelationKind=${expectedRelationKind?.wireName}'
      ')';
}
