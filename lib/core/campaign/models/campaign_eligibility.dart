/// Contexto del usuario para evaluar elegibilidad de campaña
class CampaignContext {
  /// ID de la pantalla actual
  final String screenId;

  /// ID del usuario (si está autenticado)
  final String? userId;

  /// ID de la organización activa
  final String? orgId;

  /// Rol del usuario en la organización activa
  final String? role;

  /// ID de ciudad del usuario
  final String? cityId;

  /// Timestamp de evaluación
  final DateTime currentTime;

  CampaignContext({
    required this.screenId,
    this.userId,
    this.orgId,
    this.role,
    this.cityId,
  }) : currentTime = DateTime.now();
}

/// Función que determina si una campaña es elegible para mostrar
typedef CampaignEligibilityFn = Future<bool> Function(CampaignContext context);

/// Funciones de elegibilidad predefinidas
class EligibilityFunctions {
  /// Siempre elegible
  static Future<bool> always(CampaignContext ctx) async => true;

  /// Nunca elegible (para testing o campañas desactivadas)
  static Future<bool> never(CampaignContext ctx) async => false;

  /// Solo para usuarios con rol de administrador
  static Future<bool> adminOnly(CampaignContext ctx) async =>
      ctx.role?.toLowerCase().contains('admin') ?? false;

  /// Solo para usuarios con rol de propietario
  static Future<bool> ownerOnly(CampaignContext ctx) async =>
      ctx.role?.toLowerCase().contains('propietario') ?? false;

  /// Solo para usuarios con rol de proveedor
  static Future<bool> providerOnly(CampaignContext ctx) async =>
      ctx.role?.toLowerCase().contains('proveedor') ?? false;

  /// Constructor de función para ciudades específicas
  static CampaignEligibilityFn citySpecific(List<String> cityIds) {
    return (CampaignContext ctx) async => cityIds.contains(ctx.cityId);
  }

  /// Constructor de función para pantallas específicas
  static CampaignEligibilityFn screenSpecific(List<String> screenIds) {
    return (CampaignContext ctx) async => screenIds.contains(ctx.screenId);
  }

  /// Combina múltiples funciones con AND lógico
  static CampaignEligibilityFn combine(List<CampaignEligibilityFn> fns) {
    return (CampaignContext ctx) async {
      for (final fn in fns) {
        if (!await fn(ctx)) return false;
      }
      return true;
    };
  }
}
