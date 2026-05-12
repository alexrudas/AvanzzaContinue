// ============================================================================
// lib/data/sources/local/core_common/local_contact_local_ds.dart
// LOCAL CONTACT LOCAL DS — Data Layer / Sources / Local
// ============================================================================
// QUÉ HACE:
//   - Acceso a LocalContactModel en Isar.
//   - Soft delete operativo. Queries operativas excluyen soft-deleted.
//
// QUÉ NO HACE:
//   - No mapea a Entity (responsabilidad del repositorio).
//   - No accede a remoto.
//
// PRINCIPIOS:
//   - writeTxn atómico para upsert/softDelete.
//   - UTC en timestamps persistidos.
//   - REGLA DURA: cualquier reconstrucción de `LocalContactModel` dentro de
//     `writeTxn` DEBE copiar TODOS los campos del modelo entrante — incluidos
//     los de perfil estructurado v2 (supplierType, categorías, geo, alt phone,
//     website, coverage). Se dejó un helper privado `_copyForWrite` para que
//     cualquier extensión futura quede forzada a tocar un solo lugar y no
//     vuelva a olvidar campos. Si se añaden campos nuevos al modelo, se
//     añaden aquí o se pierden silenciosamente en persistencia.
//
// HISTORIA:
//   - Bug previamente corregido: la versión anterior reconstruía el modelo
//     manualmente y omitía los campos v2, provocando que todo lo estructurado
//     se perdiera al guardar y el detalle mostrase campos vacíos al reabrir.
//     Consolidar la copia en `_copyForWrite` cierra la puerta a que el bug
//     vuelva por distracción al agregar campos nuevos.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/core_common/local_contact_model.dart';

class LocalContactLocalDataSource {
  final Isar _isar;

  LocalContactLocalDataSource(this._isar);

  Future<LocalContactModel?> getById(String id) async {
    return _isar.localContactModels.filter().idEqualTo(id).findFirst();
  }

  Stream<LocalContactModel?> watchById(String id) {
    return _isar.localContactModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<LocalContactModel> upsert(LocalContactModel model) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.localContactModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      // Política de merge mínima:
      //   - Se preserva el `isarId` del registro existente (para que Isar
      //     actualice in-place y no cree un duplicado).
      //   - Se preserva `createdAt` del existente (inmutable por canon).
      //   - Todos los demás campos (incluyendo los de perfil estructurado v2)
      //     se toman del modelo entrante.
      final toSave = _copyForWrite(
        source: model,
        isarId: existing?.isarId,
        createdAtOverride: existing?.createdAt ?? model.createdAt.toUtc(),
      );

      await _isar.localContactModels.put(toSave);
      return toSave;
    });
  }

  Future<void> softDeleteById(String id, DateTime now) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.localContactModels
          .filter()
          .idEqualTo(id)
          .findFirst();
      if (existing == null) return;
      if (existing.isDeleted) return;

      // Para soft-delete preservamos todos los campos actuales del existente
      // y solo marcamos las banderas de borrado + updatedAt. Ver regla dura
      // del encabezado: usar `_copyForWrite` para NUNCA olvidar campos.
      final updated = _copyForWrite(
        source: existing,
        isarId: existing.isarId,
        createdAtOverride: existing.createdAt,
        updatedAtOverride: now.toUtc(),
        isDeletedOverride: true,
        deletedAtOverride: now.toUtc(),
      );
      await _isar.localContactModels.put(updated);
    });
  }

  Future<List<LocalContactModel>> listByWorkspace(String workspaceId) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Stream<List<LocalContactModel>> watchByWorkspace(String workspaceId) {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true);
  }

  /// Watch INCLUYENDO soft-deleted. Necesario para Mi Red Tab 5: el merger
  /// usa contactos archivados para construir el "archive override" set —
  /// oculta actores wire cuyo LocalContact local está archivado, aunque el
  /// backend aún no haya procesado el archive.
  ///
  /// NO usar para queries operativas normales (usar [watchByWorkspace] que
  /// filtra archivados). Solo para casos donde la intención local de
  /// archivado debe arbitrar sobre el cache remoto.
  Stream<List<LocalContactModel>> watchAllByWorkspace(String workspaceId) {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .watch(fireImmediately: true);
  }

  /// organizationId null = contactos sueltos.
  Future<List<LocalContactModel>> listByOrganization(
    String workspaceId,
    String? organizationId,
  ) async {
    final base = _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false);
    if (organizationId == null) {
      return base.organizationIdIsNull().findAll();
    }
    return base.organizationIdEqualTo(organizationId).findAll();
  }

  Stream<List<LocalContactModel>> watchByOrganization(
    String workspaceId,
    String? organizationId,
  ) {
    final base = _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false);
    if (organizationId == null) {
      return base.organizationIdIsNull().watch(fireImmediately: true);
    }
    return base
        .organizationIdEqualTo(organizationId)
        .watch(fireImmediately: true);
  }

  Future<List<LocalContactModel>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .primaryPhoneE164EqualTo(phoneE164Normalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Future<List<LocalContactModel>> findByEmail(
    String workspaceId,
    String emailNormalized,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .primaryEmailEqualTo(emailNormalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Future<List<LocalContactModel>> findByDocId(
    String workspaceId,
    String docIdNormalized,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .docIdEqualTo(docIdNormalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Resuelve el `LocalContactModel` vinculado a un `providerProfileId`
  /// canónico (campo `linkedProviderProfileId`, indexado).
  ///
  /// Uso primario: bucketizer de Mi Red, que recibe actores con
  /// `ref=platform:<providerProfileId>` y necesita conocer su
  /// `supplierType` desde la intención local guardada al registrar.
  ///
  /// Retorna `null` si no existe match. Devuelve solo registros NO
  /// soft-deleted. Indexado: O(log n).
  Future<LocalContactModel?> findByLinkedProviderProfileId(
    String workspaceId,
    String providerProfileId,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .linkedProviderProfileIdEqualTo(providerProfileId)
        .isDeletedEqualTo(false)
        .findFirst();
  }

  // ── HELPERS PRIVADOS ─────────────────────────────────────────────────────

  /// Copia TODOS los campos persistidos de `source` permitiendo overrides
  /// selectivos en los parámetros nombrados. Punto ÚNICO de reconstrucción
  /// del modelo dentro de `writeTxn` — cualquier campo nuevo del modelo debe
  /// agregarse aquí o se perderá silenciosamente al guardar (ese fue el bug
  /// histórico documentado en el encabezado).
  LocalContactModel _copyForWrite({
    required LocalContactModel source,
    required Id? isarId,
    DateTime? createdAtOverride,
    DateTime? updatedAtOverride,
    bool? isDeletedOverride,
    DateTime? deletedAtOverride,
  }) {
    return LocalContactModel(
      isarId: isarId,
      id: source.id,
      workspaceId: source.workspaceId,
      displayName: source.displayName,
      createdAt: (createdAtOverride ?? source.createdAt).toUtc(),
      updatedAt: (updatedAtOverride ?? source.updatedAt).toUtc(),
      organizationId: source.organizationId,
      roleLabel: source.roleLabel,
      primaryPhoneE164: source.primaryPhoneE164,
      primaryEmail: source.primaryEmail,
      docId: source.docId,
      notesPrivate: source.notesPrivate,
      tagsPrivate: List<String>.from(source.tagsPrivate),
      snapshotSourcePlatformActorId: source.snapshotSourcePlatformActorId,
      snapshotAdoptedAt: source.snapshotAdoptedAt?.toUtc(),
      isDeleted: isDeletedOverride ?? source.isDeleted,
      deletedAt:
          (deletedAtOverride ?? source.deletedAt)?.toUtc(),
      // ── v2 PERFIL ESTRUCTURADO — NO OLVIDAR ────────────────────────────
      supplierTypeWire: source.supplierTypeWire,
      categories: List<String>.from(source.categories),
      countryId: source.countryId,
      regionId: source.regionId,
      cityId: source.cityId,
      addressLine: source.addressLine,
      secondaryPhoneE164: source.secondaryPhoneE164,
      website: source.website,
      coverageCityIds: List<String>.from(source.coverageCityIds),
      coverageAllCountry: source.coverageAllCountry,
      // ── SEDES ADICIONALES — NO OLVIDAR ─────────────────────────────────
      additionalBranches: List.of(source.additionalBranches),
      // ── LINK CANÓNICO A PROVIDER PROFILE — NO OLVIDAR ──────────────────
      // Persistir el link tras `provision()` 2xx exitoso es lo que permite
      // al bucketizer de Mi Red resolver `platform:<providerProfileId>` →
      // contact local → `supplierType` en O(1). Olvidarlo en este helper
      // hace que el campo se pierda silenciosamente al guardar — exactamente
      // el bug histórico documentado en el encabezado.
      linkedProviderProfileId: source.linkedProviderProfileId,
    );
  }
}
