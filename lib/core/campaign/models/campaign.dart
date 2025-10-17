import 'campaign_eligibility.dart';

/// Modelo de campaña promocional
///
/// Define el contenido visual, CTA y condiciones de elegibilidad
/// para una campaña in-app
class Campaign {
  /// ID único de la campaña
  final String id;

  /// Título principal
  final String title;

  /// Subtítulo o descripción
  final String subtitle;

  /// Path del asset de imagen (debe estar en assets/campaign/)
  final String imageAsset;

  /// Texto del botón CTA
  final String ctaText;

  /// Ruta de navegación al hacer click en CTA (opcional)
  final String? routeName;

  /// Función que determina si la campaña es elegible para el usuario actual
  final CampaignEligibilityFn eligibilityFn;

  /// Metadata adicional (opcional)
  final Map<String, dynamic>? metadata;

  const Campaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.ctaText,
    this.routeName,
    required this.eligibilityFn,
    this.metadata,
  });

  @override
  String toString() => 'Campaign($id, $title)';
}
