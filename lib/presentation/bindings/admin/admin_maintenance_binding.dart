import 'package:get/get.dart';
import '../../controllers/admin/maintenance/admin_maintenance_controller.dart';
import '../../controllers/admin/maintenance/maintenance_stats_controller.dart';
import '../../controllers/admin/maintenance/alert_recommender_controller.dart';
import '../../controllers/admin/maintenance/review_events_controller.dart';
import '../../controllers/admin/maintenance/types/i_maintenance_stats_repo.dart';
import '../../controllers/session_context_controller.dart';

class AdminMaintenanceBinding extends Bindings {
  @override
  void dependencies() {
    // Main controller
    Get.lazyPut(() => AdminMaintenanceController(), fenix: true);

    // Stats controller with repository
    Get.lazyPut(() {
      final session = Get.find<SessionContextController>();
      final orgId = session.user?.activeContext?.orgId ?? '';

      return MaintenanceStatsController(
        repo: MockMaintenanceStatsRepo(),
        orgId: orgId,
      );
    }, fenix: true);

    // Alert recommender controller
    Get.lazyPut(() => AlertRecommenderController(), fenix: true);

    // Review events controller
    Get.lazyPut(() => ReviewEventsController(), fenix: true);
  }
}
