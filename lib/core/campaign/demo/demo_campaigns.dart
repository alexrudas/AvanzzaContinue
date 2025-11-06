import 'package:avanzza/routes/app_pages.dart';

import '../models/campaign.dart';
import '../models/campaign_eligibility.dart';

class DemoCampaigns {
  static final List<Campaign> all = [
    const Campaign(
      id: 'demo_insurance_soat',
      title: '¡Tu SOAT está próximo a vencer!',
      subtitle: 'Cotiza con las mejores aseguradoras y renueva en minutos.',
      imageAsset: 'assets/campaign/campaign_insurance.png',
      ctaText: 'Ver seguros disponibles',
      routeName: Routes.demoSoat,
      eligibilityFn: EligibilityFunctions.always,
      metadata: {'priority': 'high', 'target_audience': 'admin'},
    ),
    const Campaign(
      id: 'demo_catalog_parts',
      title: 'Nuevo catálogo de repuestos',
      subtitle: '¡Encuentra lo que necesitas con precios actualizados!',
      imageAsset: 'assets/campaign/campaign_catalog.png',
      ctaText: 'Explorar catálogo',
      routeName: Routes.demoSoat,
      eligibilityFn: EligibilityFunctions.always,
      metadata: {'priority': 'medium', 'target_audience': 'all'},
    ),
    const Campaign(
      id: 'demo_maintenance_reminder',
      title: '3 mantenimientos pendientes',
      subtitle: 'Mantén tus activos al día y evita costosas reparaciones.',
      imageAsset: 'assets/campaign/campaign_maintenance.png',
      ctaText: 'Revisar mantenimientos',
      routeName: Routes.demoSoat,
      eligibilityFn: EligibilityFunctions.always,
      metadata: {'priority': 'high', 'target_audience': 'admin,owner'},
    ),
  ];

  static Campaign? forScreen(String screenId) {
    switch (screenId) {
      case 'admin_maintenance':
        return all.first;
      case 'admin_home':
        return all.length > 1 ? all[1] : all.first;
      default:
        return all.isNotEmpty ? all.first : null;
    }
  }

  static Campaign? random() {
    if (all.isEmpty) return null;
    final index = DateTime.now().millisecondsSinceEpoch % all.length;
    return all[index];
  }
}
