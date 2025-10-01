import 'package:avanzza/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/entities/user/active_context.dart';
import 'session_context_controller.dart';

class OrgSelectionController extends GetxController {
  final _orgs = <OrganizationEntity>[].obs;
  List<OrganizationEntity> get orgs => _orgs;

  late final SessionContextController session;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    session = Get.find<SessionContextController>();
    final uid = session.user?.uid;
    print("[OrgSelectionController] uid $uid");
    if (uid != null) {
      di.orgRepository.watchOrgsByUser(uid).listen((list) {
        _orgs.assignAll(list);
      });
    }
  }

  Future<void> selectOrg(OrganizationEntity org) async {
    final ctx = ActiveContext(orgId: org.id, orgName: org.nombre, rol: 'admin');
    await session.setActiveContext(ctx);
    Get.offAllNamed(Routes.assets);
  }
}
