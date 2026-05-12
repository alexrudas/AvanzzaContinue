// ============================================================================
// lib/presentation/controllers/provider/specialties/specialties_selection_result.dart
// SpecialtiesSelectionResult — wrapper que devuelve el selector al caller
// ============================================================================
//
// QUÉ HACE:
//   Resultado canónico que `SelectSpecialtiesController.submit()` devuelve
//   vía `Get.back(result: ...)`. Lleva tanto los IDs (contrato histórico)
//   como los detalles mínimos (id + name) de las specialties realmente
//   seleccionadas — los suficientes para que el caller construya un
//   resumen compacto sin volver a consultar el catálogo.
//
// QUÉ NO HACE:
//   - NO expone `kind`, `key` ni metadata extra: el caller (form de
//     proveedor) sólo necesita id + name para el subtítulo del tile.
//   - NO ordena ni filtra: el orden del backend (name ASC) se preserva.
//
// COMPATIBILIDAD:
//   Este wrapper REEMPLAZA el contrato anterior `Get.back<Set<String>>`.
//   Los tests del orquestador del form usan `applySelectedSpecialties()`
//   directamente con un Set<String>, así que NO se rompen — el wrapper
//   solo viaja por el wire UI, no por el contrato del controller.
// ============================================================================

/// Detalle mínimo de una specialty seleccionada (id + name).
///
/// Inmutable. `name` es UI copy en español ya provisto por el backend
/// (`Specialty.name`). El cliente NO lo traduce ni reformatea.
class SpecialtySelectionDetail {
  final String id;
  final String name;
  const SpecialtySelectionDetail({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpecialtySelectionDetail &&
          other.id == id &&
          other.name == name);

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'SpecialtySelectionDetail($id, "$name")';
}

/// Resultado del flujo de selección de especialidades.
///
/// Contrato:
///   - `ids`: Set unmodifiable con los IDs canónicos seleccionados.
///   - `details`: List unmodifiable con (id, name) en el ORDEN del
///     catálogo backend (name ASC). Misma cardinalidad que `ids`.
///
/// El caller habitual (provider form) usa `ids` para el `PUT
/// /v1/providers/:id/specialties` y `details` para construir el
/// subtítulo compacto del tile.
class SpecialtiesSelectionResult {
  /// IDs de specialties seleccionadas. Inmutable (Set.unmodifiable).
  final Set<String> ids;

  /// Detalles (id, name) de las seleccionadas, en orden del catálogo
  /// backend. Inmutable (List.unmodifiable).
  final List<SpecialtySelectionDetail> details;

  SpecialtiesSelectionResult({
    required Set<String> ids,
    required List<SpecialtySelectionDetail> details,
  })  : ids = Set<String>.unmodifiable(ids),
        details = List<SpecialtySelectionDetail>.unmodifiable(details);

  /// Helper para construir un mapa `id → name` desde `details`. Útil
  /// para el form que cachea nombres y los usa en el subtítulo.
  Map<String, String> namesById() {
    return <String, String>{
      for (final d in details) d.id: d.name,
    };
  }
}
