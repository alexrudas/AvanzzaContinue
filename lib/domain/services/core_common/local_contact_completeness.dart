// ============================================================================
// lib/domain/services/core_common/local_contact_completeness.dart
// LOCAL CONTACT COMPLETENESS — Regla pura de perfil completo
// ============================================================================
// QUÉ HACE:
//   - Define la REGLA DE NEGOCIO única para declarar que un proveedor
//     (LocalContactEntity con roleLabel = 'proveedor') está OPERATIVAMENTE
//     COMPLETO para aparecer en flujos comerciales avanzados (cotización,
//     orden de compra/trabajo con documentación).
//   - Expone:
//       · `isProviderProfileComplete(entity)` → bool
//       · `missingProviderProfileFields(entity)` → List<String> con las
//         claves faltantes en orden estable (para UX: "Qué falta").
//
// QUÉ NO HACE:
//   - NO accede a repositorios, red, Isar ni Firestore.
//   - NO decide si el proveedor es válido en backend (eso lo hace el backend
//     contra su propio contrato). Aquí es completitud UX local.
//   - NO clasifica por tipo de proveedor salvo requerir `supplierType != null`.
//   - NO se acopla a un vertical: sirve para todo workspace.
//
// REGLA (v2, flujo Proveedores canónico — Hito 1):
//   COMPLETO = displayName no vacío
//            + primaryPhoneE164 no vacío
//            + regionId no vacío (departamento)
//            + cityId no vacío (ciudad principal)
//
//   La clasificación comercial canónica vive en `ProviderProfile +
//   ProviderSpecialty` (Postgres, vía POST /v1/providers + PUT
//   /:id/specialties). Los campos legacy `supplierType` y `categories`
//   se conservan en el entity para no perder datos antiguos, pero NO
//   son criterio de completitud — la sección "Tipo y categorías" se
//   retiró del form/detail/directory en Hito 1.
//
// PRINCIPIOS:
//   - Función pura, estable, testable sin mocks.
//   - El caller consumidor (controller/UI) deriva el badge "Completo /
//     Incompleto" y el CTA "Completar perfil". Nada de side effects aquí.
//   - Los nombres de las llaves faltantes son tokens estables que la UI
//     mapea a copy humano — no cambian sin pasar por code review.
// ============================================================================

import '../../entities/core_common/local_contact_entity.dart';

/// Tokens estables de campos que pueden faltar en el perfil de proveedor.
/// La UI los mapea a copy humano. NO traducir ni renombrar sin actualizar
/// todos los consumidores (hoy: ProviderDetailPage, ProviderFormPage,
/// ProvidersDirectoryPage).
class ProviderProfileField {
  static const displayName = 'displayName';
  static const primaryPhoneE164 = 'primaryPhoneE164';
  static const regionId = 'regionId';
  static const cityId = 'cityId';
}

/// True si el proveedor cumple la regla mínima de completitud v1.
bool isProviderProfileComplete(LocalContactEntity e) {
  return missingProviderProfileFields(e).isEmpty;
}

/// Retorna los campos faltantes en orden estable (para pintar "Qué falta").
/// Vacía = perfil completo.
List<String> missingProviderProfileFields(LocalContactEntity e) {
  final missing = <String>[];

  if (e.displayName.trim().isEmpty) {
    missing.add(ProviderProfileField.displayName);
  }
  if ((e.primaryPhoneE164 ?? '').trim().isEmpty) {
    missing.add(ProviderProfileField.primaryPhoneE164);
  }
  if ((e.regionId ?? '').trim().isEmpty) {
    missing.add(ProviderProfileField.regionId);
  }
  if ((e.cityId ?? '').trim().isEmpty) {
    missing.add(ProviderProfileField.cityId);
  }

  return List<String>.unmodifiable(missing);
}

/// Copy humano en español para cada token de campo faltante. Se mantiene en
/// dominio (no en widgets) porque la app es monolingüe ES por canon de
/// proyecto y evitar drift entre vistas.
String providerProfileFieldHumanLabel(String token) {
  switch (token) {
    case ProviderProfileField.displayName:
      return 'Nombre del proveedor';
    case ProviderProfileField.primaryPhoneE164:
      return 'Teléfono principal';
    case ProviderProfileField.regionId:
      return 'Departamento';
    case ProviderProfileField.cityId:
      return 'Ciudad';
    default:
      return token;
  }
}
