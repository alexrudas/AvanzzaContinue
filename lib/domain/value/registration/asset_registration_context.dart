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
// ============================================================================

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

  const AssetRegistrationContext({
    required this.portfolioId,
    required this.portfolioName,
    required this.countryId,
    this.cityId,
    required this.assetType,
    required this.registrationSessionId,
  });

  @override
  String toString() =>
      'AssetRegistrationContext('
      'portfolioId=$portfolioId, '
      'portfolioName=$portfolioName, '
      'countryId=$countryId, '
      'cityId=$cityId, '
      'assetType=$assetType, '
      'registrationSessionId=$registrationSessionId'
      ')';
}
