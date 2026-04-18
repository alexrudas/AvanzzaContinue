import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../core/session/org_switch_exceptions.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/entities/user/active_context.dart';
import '../../routes/app_pages.dart';
import 'session_context_controller.dart';

class OrgSelectionController extends GetxController {
  final _orgs = <OrganizationEntity>[].obs;
  List<OrganizationEntity> get orgs => _orgs;

  // M-2: prevención de doble tap y loading state para switchOrganization()
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
    // Prevención de doble tap
    if (_isLoading.value) return;
    _isLoading.value = true;

    try {
      final currentOrgId = session.user?.activeContext?.orgId ?? '';

      if (currentOrgId.isEmpty) {
        // Setup inicial — el usuario no tiene org activa todavía.
        // setActiveContext() no dispara el hard throw cuando currentOrgId es vacío.
        // No se requiere backend sync porque no hay tenancy anterior que cambiar.
        final membership = session.memberships
            .firstWhereOrNull((m) => m.orgId == org.id);
        final role = membership?.roles.firstOrNull ?? 'admin';
        await session.setActiveContext(
          ActiveContext(orgId: org.id, orgName: org.nombre, rol: role),
        );
      } else if (currentOrgId == org.id) {
        // Misma org — no-op en términos de tenancy.
        // Nada que hacer; navegar directamente.
      } else {
        // Org switch real — pasa por backend + JWT sync.
        final membership = session.memberships
            .firstWhereOrNull((m) => m.orgId == org.id);
        final role = membership?.roles.firstOrNull ?? 'admin';
        await session.switchOrganization(
          organizationId: org.id,
          targetWorkspaceRole: role,
        );
      }

      Get.offAllNamed(Routes.assets);
    } on SwitchOrganizationException catch (e) {
      debugPrint('[OrgSelection] switchOrganization failed: $e');
      // Rethrow para que la UI pueda mostrar error al usuario
      rethrow;
    } catch (e) {
      debugPrint('[OrgSelection] selectOrg error: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
}
