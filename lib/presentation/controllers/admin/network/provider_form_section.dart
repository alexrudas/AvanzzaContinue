// ============================================================================
// lib/presentation/controllers/admin/network/provider_form_section.dart
// PROVIDER FORM SECTION — Enum UX para edición por secciones
// ============================================================================
// QUÉ HACE:
//   - Identifica la sección que el formulario debe ENFOCAR cuando se abre en
//     modo edición desde el detalle. Permite que desde la ficha del proveedor
//     cada tarjeta tenga su propio botón "Editar" que lleva al form con la
//     sección correspondiente resaltada / visible solo (según decida la UI).
//
// QUÉ NO HACE:
//   - NO partir la entidad en sub-entidades: la persistencia siempre trabaja
//     con `LocalContactEntity` COMPLETA (el controller la hidrata íntegra y
//     genera el snapshot completo al guardar). La "edición por sección" es
//     UX, no es un contrato de datos distinto.
//   - NO modifica el alcance de los guardrails: las reglas de completeness,
//     validación y SSOT siguen siendo las mismas.
//
// WIRE-STABLE:
//   `wireName` se usa para serializar la sección en `Get.arguments` cuando se
//   navega desde links/deeplinks o tests. NO renombrar sin revisar callers.
// ============================================================================

/// Sección que el formulario debe mostrar/enfatizar al abrir en modo edit.
/// Cuando es `null`, se muestra el formulario completo (flujo "editar todo").
enum ProviderFormSection {
  basics('basics'),
  contact('contact'),
  location('location'),
  coverage('coverage'),
  notes('notes');

  final String wireName;
  const ProviderFormSection(this.wireName);
}

extension ProviderFormSectionX on ProviderFormSection {
  /// Copy humano en español para headers / tooltips.
  String get humanLabel {
    switch (this) {
      case ProviderFormSection.basics:
        return 'Datos básicos';
      case ProviderFormSection.contact:
        return 'Contacto';
      case ProviderFormSection.location:
        return 'Ubicación';
      case ProviderFormSection.coverage:
        return 'Cobertura';
      case ProviderFormSection.notes:
        return 'Observaciones';
    }
  }

  /// Inverso de `wireName`. Retorna `null` si el string no coincide (no lanza).
  static ProviderFormSection? fromWire(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final s in ProviderFormSection.values) {
      if (s.wireName == value) return s;
    }
    return null;
  }
}
