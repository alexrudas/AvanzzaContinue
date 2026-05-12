// ============================================================================
// lib/domain/entities/core_common/provider_branch_entity.dart
// PROVIDER BRANCH ENTITY — Sede operativa dentro de un Proveedor
// ============================================================================
// QUÉ HACE:
//   - Representa una SEDE ADICIONAL del proveedor (la sede principal del
//     proveedor vive en los campos geo/phone del `LocalContactEntity`
//     directamente — ver `LocalContactEntity.countryId/regionId/cityId/
//     addressLine/primaryPhoneE164`, que se considera la sede principal
//     implícita del proveedor para retrocompatibilidad con registros ya
//     guardados).
//   - Subestructura PURA de dominio (freezed). Se embebe en el proveedor
//     como `List<ProviderBranchEntity>`. Cero repositorio propio, cero
//     ruta paralela, cero segunda fuente de verdad.
//
// QUÉ NO HACE:
//   - NO es una entidad estable con identidad comercial propia. El `id` es
//     un UUID local del workspace únicamente para CRUD dentro de la UI.
//   - NO guarda cobertura ni clasificación comercial: eso vive a nivel
//     proveedor (`LocalContactEntity.coverageAllCountry`, `coverageCityIds`,
//     `supplierType`, `categories`). La sede es UBICACIÓN + contacto local.
//   - NO lleva campos privados: si el usuario quiere notas privadas, eso va
//     a `LocalContactEntity.notesPrivate` (sigue siendo private por canon).
//     Las notas de sede (`notes`) son públicas y sincronizan al workspace.
//
// PRINCIPIOS:
//   - Identidad por `id` (UUID). El controller/UI garantiza unicidad.
//   - Todos los campos opcionales salvo `id`: una sede recién creada puede
//     persistirse incompleta y completarse después (mismo espíritu que el
//     perfil del proveedor).
//   - Label humano opcional ("Sede Norte", "Bodega Medellín"): si es null
//     la UI lo deriva como "Sede en {ciudad}" o similar.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_branch_entity.freezed.dart';
part 'provider_branch_entity.g.dart';

/// Sede operativa adicional de un proveedor.
@freezed
abstract class ProviderBranchEntity with _$ProviderBranchEntity {
  const factory ProviderBranchEntity({
    /// UUID local del workspace — permite CRUD desde la UI.
    required String id,

    /// Etiqueta humana opcional ("Sede Norte", "Bodega", "Punto Chapinero").
    /// Si es null, la UI deriva un label por ciudad/dirección.
    String? label,

    /// País de la sede. Reusa catálogo geo del proyecto.
    String? countryId,

    /// Departamento / región.
    String? regionId,

    /// Ciudad.
    String? cityId,

    /// Dirección de calle libre (complemento a cityId).
    String? addressLine,

    /// Teléfono local de la sede, en formato E.164 canónico.
    /// Validación/normalización responsabilidad del input (ver `PhoneField`).
    String? phoneE164,

    /// Nombre del contacto específico de la sede (ej. "Andrés — jefe de
    /// bodega"). Opcional. Campo público.
    String? contactName,

    /// Observaciones operativas de la sede. Público, sincroniza al workspace.
    /// (Las notas PRIVADAS del proveedor viven en `LocalContactEntity.notesPrivate`).
    String? notes,
  }) = _ProviderBranchEntity;

  factory ProviderBranchEntity.fromJson(Map<String, dynamic> json) =>
      _$ProviderBranchEntityFromJson(json);
}
