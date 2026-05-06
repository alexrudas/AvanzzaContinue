// ============================================================================
// lib/domain/entities/core_common/local_contact_entity.dart
// LOCAL CONTACT ENTITY — Core Common v1 / Red Local del Workspace
// ============================================================================
// QUÉ HACE:
//   - Representa un contacto operativo persona en la red local del workspace.
//   - Puede pertenecer a una LocalOrganization (1:N) o ser independiente.
//   - SSOT del workspace.
//   - Soporta soft delete (isDeleted + deletedAt).
//   - v2 (flujo Proveedores): añade campos estructurados para perfil completo
//     (tipo de proveedor, categorías, geo, dirección, teléfono alt, web,
//     cobertura). Todos opcionales: registros legados siguen siendo válidos.
//
// QUÉ NO HACE:
//   - No representa un User (identidad de autenticación).
//   - No representa un PlatformActor (identidad operativa en plataforma).
//   - No lleva atributos específicos por rol (licencias, matrículas, etc.):
//     esos son extensiones futuras, no Core Common.
//   - NO decide completitud: la regla vive en `local_contact_completeness.dart`.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - organizationId es nullable: soporta contacto suelto.
//   - Campos *Private nunca se sincronizan.
//   - roleLabel es texto libre; NO es semántica de módulo vertical.
//   - Soft delete: isDeleted=true + deletedAt=<ts> = registro archivado.
//     El flujo operativo NO borra físicamente; el repo expone delete como soft.
//   - Campos v2 son opcionales + default seguros: cero migración destructiva
//     sobre registros locales previos (todos nacen con los nuevos campos en
//     null/[] y la UI los pide cuando el usuario completa el perfil).
//
// ENTERPRISE NOTES:
//   - workspaceId ≡ orgId del tenant SaaS.
//   - primaryPhoneE164 es la llave candidata principal de una persona.
//   - docId es cédula o equivalente normalizado (sin puntos, sin guiones).
//   - countryId / regionId / cityId reusan el mismo sistema geo (assets
//     regions_entities_co.v3.json + cities_entities_co.v3.json) que el resto
//     del proyecto: NO se introduce un selector paralelo.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'provider_branch_entity.dart';
import 'value_objects/supplier_type.dart';

part 'local_contact_entity.freezed.dart';
part 'local_contact_entity.g.dart';

/// Contacto persona registrado en la red local de un workspace.
/// SSOT: workspace. Puede o no pertenecer a una LocalOrganization.
@freezed
abstract class LocalContactEntity with _$LocalContactEntity {
  const factory LocalContactEntity({
    required String id,

    /// Partition key. Workspace dueño del registro local.
    required String workspaceId,

    /// Nombre mostrado en la UI del workspace.
    required String displayName,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// FK opcional a LocalOrganization del mismo workspace.
    /// Null = contacto suelto (ej. conductor persona, técnico freelance).
    String? organizationId,

    /// Etiqueta libre del rol en el workspace ("vendedor", "conductor",
    /// "técnico"). Sin semántica vertical: solo anotación local.
    String? roleLabel,

    /// Teléfono normalizado a E.164. Llave candidata principal.
    String? primaryPhoneE164,

    /// Email de contacto. Llave candidata secundaria.
    String? primaryEmail,

    /// Documento de identidad normalizado. Llave candidata secundaria.
    String? docId,

    /// Nota privada del workspace. NUNCA se sincroniza.
    String? notesPrivate,

    /// Tags privadas del workspace. NUNCA se sincronizan.
    @Default(<String>[]) List<String> tagsPrivate,

    /// PlatformActor origen de adopciones manuales de campo (si aplica).
    String? snapshotSourcePlatformActorId,

    /// Timestamp de la última adopción.
    DateTime? snapshotAdoptedAt,

    /// Soft delete flag. true = registro archivado.
    /// Las queries operativas del repositorio excluyen isDeleted=true por default.
    @Default(false) bool isDeleted,

    /// Timestamp del soft-delete. Null mientras isDeleted=false.
    DateTime? deletedAt,

    // ── v2 PERFIL ESTRUCTURADO (flujo Proveedores) ─────────────────────────

    /// Clasificación comercial operativa. Null = sin clasificar (legado o
    /// alta rápida). Ver `SupplierType` para el wire contract.
    SupplierType? supplierType,

    /// Categorías verticales libres (repuestos, lubricantes, taller...).
    /// Acepta cualquier string; la UI ofrece sugerencias pero no impone.
    /// Vacío = sin categorías.
    @Default(<String>[]) List<String> categories,

    /// País del proveedor. Reusa IDs del catálogo geo del proyecto.
    String? countryId,

    /// Región/Departamento.
    String? regionId,

    /// Ciudad principal (sede).
    String? cityId,

    /// Dirección de calle libre (complemento a cityId/regionId). No se parsea.
    String? addressLine,

    /// Teléfono alternativo E.164. No es llave de matching.
    String? secondaryPhoneE164,

    /// URL del sitio web del proveedor. Texto libre, sin validación remota.
    String? website,

    /// IDs de ciudades donde el proveedor ofrece servicio. Puede estar
    /// vacía (ej. proveedor solo de productos). Cuando está vacía, asumir
    /// que la cobertura es cityId (ver completeness helper).
    ///
    /// Semántica con `coverageAllCountry`:
    ///   - `coverageAllCountry=true`  → esta lista DEBE estar vacía (canon).
    ///   - `coverageAllCountry=false` → selección manual opcional.
    @Default(<String>[]) List<String> coverageCityIds,

    /// Modo "Envíos a todo el país". Cuando es true, `coverageCityIds`
    /// debe ignorarse (canon: el controller lo vacía al activar el toggle).
    /// Campo público (se sincroniza vía Firestore).
    @Default(false) bool coverageAllCountry,

    /// FK opcional al `ProviderProfile` canónico (Postgres) que representa
    /// este contacto en la red comercial (Avanzza Core API).
    ///
    /// Semántica:
    ///   - `null` = aún no provisionado contra Core API (default).
    ///   - String = el `providerProfileId` retornado por
    ///     `POST /v1/providers`. Usado por `ProviderFormController` para:
    ///       1. Saltar el POST en edit mode → ir directo a `GET + PUT`.
    ///       2. Hidratar `specialtyIds` desde `GET /v1/providers/:id`.
    ///
    /// Default `null` ⇒ retrocompatible con registros legacy: contactos
    /// creados antes del flujo canónico simplemente nacen sin vinculación.
    /// Sin migración destructiva.
    ///
    /// IMPORTANTE: este campo se persiste SOLO tras un `provision()` 2xx
    /// exitoso (ver `ProviderFormController.save()`). Si el POST falla o
    /// si `replaceSpecialties` falla luego, la regla canónica es:
    ///   - POST falló → NO tocar este campo (queda null o el valor previo).
    ///   - POST OK + PUT specialties falló → este campo SÍ se actualiza
    ///     porque el provider ya existe; el siguiente save salta el POST
    ///     y reintenta solo el PUT (idempotente backend).
    String? linkedProviderProfileId,

    /// Sedes ADICIONALES del proveedor. La sede PRINCIPAL vive IMPLÍCITA
    /// en los campos geo + `primaryPhoneE164` del propio `LocalContactEntity`
    /// (retrocompat con registros ya persistidos). Esta lista cubre solo
    /// las sedes extra — visualmente se muestran bajo una sección
    /// "Otras sedes".
    ///
    /// DECISIÓN EXPLÍCITA — ASIMETRÍA INCREMENTAL:
    ///   Existe a propósito una asimetría entre la sede principal
    ///   (campos sueltos del proveedor) y las sedes adicionales (objetos
    ///   en esta lista). La razón es cero migración destructiva sobre los
    ///   registros de proveedor ya guardados en producción. Cuando el
    ///   producto justifique un refactor a un modelo simétrico
    ///   (`mainBranch: ProviderBranchEntity` + `additionalBranches: List`),
    ///   esa migración debe hacerse con un paso de hidratación explícito
    ///   que mueva los campos actuales a `mainBranch.*`. HOY NO es el
    ///   momento: romper la SSOT y los datos persistidos para ganar
    ///   simetría estética no justifica el riesgo.
    ///
    /// Semántica:
    ///   - La identidad de cada sede es el `id` (uuid) del
    ///     `ProviderBranchEntity`.
    ///   - Cobertura, supplierType y categorías NO se duplican por sede:
    ///     son del proveedor como entidad comercial.
    ///   - Notas operativas de la sede (`notes`) son públicas; las privadas
    ///     del proveedor siguen en `notesPrivate`.
    @Default(<ProviderBranchEntity>[])
    List<ProviderBranchEntity> additionalBranches,
  }) = _LocalContactEntity;

  factory LocalContactEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalContactEntityFromJson(json);
}
