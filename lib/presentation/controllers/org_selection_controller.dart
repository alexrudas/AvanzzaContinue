import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/user/membership_entity.dart';
import '../../domain/policy/membership_policy.dart';
import '../../domain/value/membership_role.dart';
import '../../routes/app_pages.dart';
import 'session_context_controller.dart';

class OrgSelectionController extends GetxController {
  final _orgs = <OrganizationEntity>[].obs;
  List<OrganizationEntity> get orgs => _orgs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late final SessionContextController session;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    session = Get.find<SessionContextController>();
    final uid = session.user?.uid;
    if (uid != null) {
      di.orgRepository.watchOrgsByUser(uid).listen((list) {
        _orgs.assignAll(list);
      });
    }
  }

  Future<void> selectOrg(OrganizationEntity org) async {
    if (_isLoading.value) return;
    _isLoading.value = true;

    try {
      final currentOrgId = session.user?.activeContext?.orgId ?? '';
      final membership =
          session.memberships.firstWhereOrNull((m) => m.orgId == org.id);
      final role = resolveActiveRoleWireName(membership);
      final ctx = ActiveContext(orgId: org.id, orgName: org.nombre, rol: role);

      if (currentOrgId.isEmpty) {
        // Setup inicial — sin tenancy previa que sincronizar.
        await session.setActiveContext(ctx);
      } else if (currentOrgId == org.id) {
        // Misma org — no-op.
      } else {
        // Cross-org. Sin Cloud Function de switch, la nueva tenancy se
        // persiste localmente y AccessGateway re-consulta /v1/access/me/context.
        // Core API resuelve activeOrgId por inferencia server-side cuando hay
        // exactamente 1 membership viable. Para >1 memberships, el contrato
        // §5 devuelve SELECT_WORKSPACE y la UI lo maneja en el splash.
        // Cross-org switch retired: `applyLocalActiveContext` aún no está
        // expuesto por `SessionContextController` y `setActiveContext`
        // lanza duro en cross-org por contrato. Hasta que la migración
        // que reintroduce el método local-first esté completa, el
        // selector hace no-op + log estructurado para no crashear si el
        // usuario lo toca con >1 memberships.
        debugPrint(
          '[ORG_SELECTION] cross-org switch is currently a no-op '
          '(target orgId=${ctx.orgId}); awaiting applyLocalActiveContext '
          'reintroduction in SessionContextController.',
        );
        return;
      }

      Get.offAllNamed(Routes.assets);
    } catch (e) {
      debugPrint('[OrgSelection] selectOrg error: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
}

/// Resuelve el wireName del rol que se asigna al [ActiveContext.rol] al
/// seleccionar una organización.
///
/// Política:
/// - `null` membership ⇒ fallback `MembershipRole.admin.wireName` (compat
///   histórica: el comportamiento previo retornaba `'admin'` literal).
/// - Membership con roles válidos ⇒ primer rol parseado tipado, normalizado
///   case-insensitive vía [MembershipPolicy.parsedRoles].
/// - Membership con roles vacíos o todos desconocidos ⇒ fallback `admin`.
///
/// Razón de la extracción: aislar la lógica del controller para testing
/// determinístico y para canalizar el acceso a `roles` por
/// [MembershipPolicy] (regla canónica: nadie consume `Membership.roles`
/// directo en lógica).
@visibleForTesting
String resolveActiveRoleWireName(MembershipEntity? membership) {
  if (membership == null) return MembershipRole.admin.wireName;
  final parsed = MembershipPolicy.parsedRoles(membership);
  if (parsed.isEmpty) return MembershipRole.admin.wireName;
  return parsed.first.wireName;
}
