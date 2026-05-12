// ============================================================================
// lib/core/services/notifications/notification_registration_service.dart
// NOTIFICATION REGISTRATION SERVICE — Interfaz cross-platform
// ============================================================================
// QUÉ HACE:
//   - Define el contrato para registrar el dispositivo en el sistema de push
//     notifications (FCM en Android/iOS).
//   - Hoy el proyecto no inicializa FCM en bootstrap. Este servicio queda
//     como seam para cuando se integre `firebase_messaging`, evitando que
//     se llame en Windows (FCM no soporta Windows).
//
// PHASE 0:
//   - `NoopNotificationRegistrationService`: usado en todas las plataformas
//     mientras messaging no esté integrado. Cuando se integre, se añade
//     `FcmNotificationRegistrationService` registrado solo en móvil.
// ============================================================================

abstract class NotificationRegistrationService {
  /// Registra el dispositivo y retorna el token (o null si no aplica).
  Future<String?> register();

  /// Libera la suscripción/token actual.
  Future<void> unregister();
}

class NoopNotificationRegistrationService
    implements NotificationRegistrationService {
  const NoopNotificationRegistrationService();

  @override
  Future<String?> register() async => null;

  @override
  Future<void> unregister() async {}
}
