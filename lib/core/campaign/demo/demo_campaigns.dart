import 'package:avanzza/routes/app_pages.dart';

import '../models/campaign.dart';
import '../models/campaign_eligibility.dart';

/// Registro estático de campañas de demostración.
///
/// ESTADO ACTUAL: Fallback registry del Campaign Engine.
///
/// CampaignOrchestrator._selectCampaign() intenta primero CampaignResolver
/// (datos reales del dominio). Si retorna null, usa [DemoCampaigns.forScreen()]
/// como fallback para garantizar que siempre haya contenido.
///
/// No eliminar: este registro se usa como contenido de relleno mientras los
/// módulos reales (mantenimientos, catálogo, etc.) no tienen resolver propio.
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

  /// Selección aleatoria por timestamp — solo para testing/QA.
  ///
  /// No usar en flujos de producción. El Campaign Engine usa
  /// CampaignResolver + [forScreen()] como fallback.
  @Deprecated('Usar CampaignResolver en producción. '
      'Solo válido para testing/QA manual.')
  static Campaign? random() {
    if (all.isEmpty) return null;
    final index = DateTime.now().millisecondsSinceEpoch % all.length;
    return all[index];
  }
}
