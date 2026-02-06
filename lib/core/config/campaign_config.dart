/// Campaign System Configuration
///
/// Kill-switch para sistema de campañas promocionales.
///
/// Para desactivar completamente las campañas:
/// - Cambiar `kCampaignsEnabled = false`
/// - O eliminar el wrapper CampaignLauncher de las páginas
///
/// No requiere rebuild de assets ni migraciones.
library;

/// Kill-switch global para campañas
///
/// true = Campañas activas (modo demo)
/// false = Campañas desactivadas (producción segura)
const bool kCampaignsEnabled = true;

/// Modo demo: fuerza 1 muestra por arranque, ignorando frecuencia persistente
///
/// true = Muestra campaña una vez por app launch (útil para desarrollo/QA)
/// false = Respeta reglas de frecuencia normales (producción)
///
/// IMPORTANTE: Solo afecta memoria (no Isar). Desactivar para producción.
const bool kDevForceShowOncePerLaunch = true;

/// Configuración de timings
class CampaignTimings {
  /// Delay inicial antes de mostrar campaña (ms)
  static const int initialDelayMs = 700;

  /// Duración del full-screen antes de auto-cerrar (segundos)
  static const int fullScreenDurationSeconds = 5;

  /// Duración de animaciones normales (ms)
  static const int normalAnimationMs = 280;

  /// Duración de animaciones con "reducir movimiento" (ms)
  static const int reducedMotionAnimationMs = 180;
}

/// Configuración de frecuencia
class CampaignFrequencyLimits {
  /// Máximo de campañas por sesión
  static const int maxPerSession = 1;

  /// Máximo de campañas por día
  static const int maxPerDay = 2;

  /// Horas de silencio tras cierres manuales consecutivos
  static const int silenceHoursAfterDismiss = 24;

  /// Número de cierres consecutivos que activan silencio
  static const int consecutiveDismissThreshold = 2;
}
