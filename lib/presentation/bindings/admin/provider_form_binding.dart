// ============================================================================
// lib/presentation/bindings/admin/provider_form_binding.dart
// PROVIDER FORM BINDING — GetX binding del formulario completo de proveedor
// ============================================================================
// QUÉ HACE:
//   - Registra [ProviderFormController] resolviendo:
//       · LocalContactRepository desde DIContainer (patrón del proyecto).
//       · orgId desde SessionContextController.
//       · Modo create/edit y sección activa desde `Get.arguments`.
//       · `assetType` opcional para el selector de specialties.
//   - Contrato de arguments (Map opcional):
//       · {'providerId': '<id>'}  → edit completo
//       · {'providerId': '<id>', 'section': '<section>'}  → edit por sección
//         (hidrata todos los campos pero la UI enfoca una sola sección)
//       · {'assetType': '<assetType-id>'}  → contexto del catálogo de
//         specialties (e.g. 'vehicle.car'). Combinable con providerId/section.
//         Si está ausente, el form NO exige specialties (alta rápida).
//       · null / sin providerId   → create
//   - Usa `Get.create` y LEE los args DENTRO del closure: de no hacerlo,
//     el providerId quedaría congelado al primer bind y todas las
//     navegaciones posteriores editarían el mismo proveedor (bug crítico
//     observado en producción cuando la lectura estaba fuera del closure).
//
// QUÉ NO HACE:
//   - NO usa `SaveLocalContactWithProbe`. La persistencia del form completo
//     va directa al `LocalContactRepository` para que el alta/edición no
//     dependa del probe remoto. El use case del probe sigue vivo para
//     flujos futuros de identidad transversal — fuera de alcance acá.
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/catalog/specialty_entity.dart'
    show SpecialtyKind;
import '../../controllers/admin/network/provider_form_controller.dart';
import '../../controllers/admin/network/provider_form_section.dart';
import '../../controllers/session_context_controller.dart';

class ProviderFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<ProviderFormController>(() {
      final session = Get.find<SessionContextController>();
      final orgId = session.user?.activeContext?.orgId ?? '';
      final countryId = session.user?.countryId ?? '';

      final args = Get.arguments;
      String? editingId;
      ProviderFormSection? section;
      String? assetType;
      SpecialtyKind? initialOfferKind;
      if (args is Map) {
        final rawId = args['providerId'];
        if (rawId is String && rawId.isNotEmpty) editingId = rawId;
        final rawSection = args['section'];
        if (rawSection is ProviderFormSection) {
          section = rawSection;
        } else if (rawSection is String) {
          section = ProviderFormSectionX.fromWire(rawSection);
        }
        // assetType: opcional. Solo se valida que sea String no vacío;
        // la canonización (trim/lowercase) la hace el backend.
        final rawAssetType = args['assetType'];
        if (rawAssetType is String && rawAssetType.isNotEmpty) {
          assetType = rawAssetType;
        }
        // initialKind (Mi Red V1): cuando el FAB / "+ Agregar" abre el
        // form ya contextualizado a productos o servicios. Acepta
        // `SpecialtyKind` directo o wire string ('product'/'service').
        // El controller usa esto para inicializar `offerKind` y bloquear
        // el toggle interno via `isOfferKindLocked`.
        final rawKind = args['initialKind'];
        if (rawKind is SpecialtyKind) {
          initialOfferKind = rawKind;
        } else if (rawKind is String) {
          for (final k in SpecialtyKind.values) {
            if (k.wireName == rawKind) {
              initialOfferKind = k;
              break;
            }
          }
        }
      }

      return ProviderFormController(
        contacts: DIContainer().localContactRepository,
        // Hito 1: integración canónica con Core API.
        // - `providerCanonicalRepository`: orquestador de POST/GET/PUT.
        // - `matchCandidateNestJs`: reuso del cliente probe ya existente
        //   (verificado en `match_candidate_nestjs_ds.dart`). Cero
        //   duplicación de cliente.
        providers: DIContainer().providerCanonicalRepository,
        matchCandidateProbe: DIContainer().matchCandidateNestJs,
        // Hito 1.x (2026-04-26): asset-types reales del workspace.
        // Reemplaza el dropdown hardcodeado (`kKnownAssetTypes`) por la
        // lista derivada de `AssetActorLink` (server-side query).
        workspaceAssetTypes: DIContainer().workspaceAssetTypeRepository,
        // Local-first (2026-05-11): fuente Isar para derivar el dropdown
        // de "Especialidades" cuando el wire (`AssetActorLink`) está
        // desfasado o caído. El controller fusiona local+wire por id.
        assetRepository: DIContainer().assetRepository,
        orgId: orgId,
        editingProviderId: editingId,
        defaultCountryId: countryId,
        focusedSection: section,
        assetType: assetType,
        initialOfferKind: initialOfferKind,
      );
    });
  }
}
