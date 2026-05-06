// ============================================================================
// lib/domain/services/core_common/category_taxonomy.dart
// CATEGORY TAXONOMY — Catálogo PURO de categorías para pedidos y proveedores
// ============================================================================
// QUÉ HACE:
//   - Centraliza las listas de categorías sugeridas por (tipo de activo ×
//     naturaleza producto/servicio). Función `categoriesFor` movida desde
//     `purchase_request_controller.dart` para que pueda ser reutilizada por
//     otros consumidores SIN introducir una segunda taxonomía.
//   - Hoy la consume únicamente `PurchaseRequestController` (pedidos).
//     El form canónico de proveedor ya NO usa esta taxonomía: la
//     gobernanza vive en `ProviderProfile + ProviderSpecialty` (Hito 1).
//
// QUÉ NO HACE:
//   - No accede a repositorios, red, Isar ni configuración de runtime.
//   - No conoce de UI.
//   - No impone que las categorías sean un enum cerrado: son sugerencias UX.
//     El persistido puede ser cualquier string (free-text del usuario).
//
// PRINCIPIOS:
//   - Dominio puro, estable, testable sin mocks.
//   - Cambios a las listas son cambios de canon: requieren revisión explícita
//     (afectan tanto pedidos como proveedores).
// ============================================================================

import '../../entities/asset/asset_entity.dart';
import '../../entities/purchase/create_purchase_request_input.dart';

/// Taxonomía UI de categorías según (tipo de activo precontexto × naturaleza).
///
/// Fuente única reutilizada por:
///   - PurchaseRequestController (pedidos),
///   - ProviderFormController (alta/edición de proveedor → variante supplier).
///
/// Las listas para PRODUCTO y SERVICIO son independientes: al cambiar la
/// naturaleza el dropdown muestra un universo distinto. Vehículo tiene la
/// taxonomía aprobada por producto y una lista corta coherente con el dominio
/// de servicios. Para otros tipos se da una salida mínima segura; no se
/// inventa una matriz gigante.
List<String> categoriesFor(
  AssetType? assetType,
  PurchaseRequestTypeInput requestType,
) {
  final isService = requestType == PurchaseRequestTypeInput.service;
  if (assetType == null) {
    return isService
        ? const ['Mantenimiento', 'Reparaciones', 'Otros']
        : const ['Repuestos', 'Materiales', 'Otros'];
  }
  switch (assetType) {
    case AssetType.vehicle:
      return isService
          ? const [
              'Mecánica',
              'Eléctrica',
              'Latonería y pintura',
              'Alineación y balanceo',
              'Diagnóstico',
              'Lubricación',
            ]
          : const [
              'Repuestos generales',
              'Eléctrico',
              'Cauchos',
              'Carrocería',
              'Vidrios y lámparas',
              'Frenos',
            ];
    case AssetType.realEstate:
      return isService
          ? const [
              'Mantenimiento',
              'Reparaciones',
              'Limpieza',
              'Otros',
            ]
          : const [
              'Materiales',
              'Repuestos',
              'Otros',
            ];
    case AssetType.machinery:
      return isService
          ? const [
              'Mantenimiento',
              'Reparaciones',
              'Diagnóstico',
              'Otros',
            ]
          : const [
              'Repuestos',
              'Lubricantes',
              'Consumibles',
              'Otros',
            ];
    case AssetType.equipment:
      return isService
          ? const [
              'Mantenimiento',
              'Reparaciones',
              'Otros',
            ]
          : const [
              'Repuestos',
              'Consumibles',
              'Otros',
            ];
  }
}

