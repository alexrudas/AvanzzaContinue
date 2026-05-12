// ============================================================================
// lib/domain/repositories/capability/business_category_registry.dart
// BusinessCategoryRegistry — contrato de validación semántica para
// BusinessCategoryRef contra el catálogo externo de categorías.
// ============================================================================
// QUÉ HACE:
//   - Define el contrato que el dominio espera para validar la existencia
//     y obtener metadatos de una BusinessCategoryRef.
//   - Permite a use cases (ej: AddCapabilityToWorkspaceUC) verificar que
//     el id de categoría pertenece al catálogo activo antes de aceptarlo.
//
// QUÉ NO HACE:
//   - NO define la implementación. La impl vive en data layer y puede leer
//     desde Firestore, un endpoint del Core API, o un catálogo cacheado en
//     Isar (offline-first).
//   - NO valida la sintaxis del id; eso ya lo garantiza BusinessCategoryRef
//     en su constructor.
//
// CICLO DE VALIDACIÓN (canónico):
//   1. Construir BusinessCategoryRef(...) → garantiza sintaxis.
//   2. Llamar registry.exists(ref) o registry.resolve(ref) en boundary
//      (use case) antes de persistir o exponer al usuario.
//   3. Si exists == false, rechazar la operación con el error apropiado.
// ============================================================================

import '../../value/capability/refs/business_category_ref.dart';

/// Resultado enriquecido de resolver una BusinessCategoryRef contra el
/// catálogo. Permite al consumer mostrar nombre legible y metadatos
/// descriptivos sin volver a consultar.
class BusinessCategoryRecord {
  final BusinessCategoryRef ref;
  final String displayName;
  final String? parentRefValue; // taxonomía jerárquica opcional
  final bool isActive;

  const BusinessCategoryRecord({
    required this.ref,
    required this.displayName,
    required this.isActive,
    this.parentRefValue,
  });
}

abstract class BusinessCategoryRegistry {
  /// True si [ref] existe en el catálogo y está activa.
  /// False si no existe o está deshabilitada / archivada.
  Future<bool> exists(BusinessCategoryRef ref);

  /// Retorna el record completo de [ref] o null si no existe.
  Future<BusinessCategoryRecord?> resolve(BusinessCategoryRef ref);

  /// Lista las categorías activas del catálogo, opcionalmente filtradas
  /// por mercado. Útil para UI de selección.
  Future<List<BusinessCategoryRecord>> listActive({String? marketWireName});
}
