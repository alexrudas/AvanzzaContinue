/// Configuración centralizada de endpoints para la API de Avanzza.
///
/// Esta clase proporciona las URLs base para acceder a los diferentes
/// servicios de la API backend de Avanzza (RUNT, SIMIT, GPS, etc.).
///
/// ## Arquitectura de API
///
/// Todos los servicios (RUNT, SIMIT, etc.) están montados sobre la misma
/// API Node.js, solo difieren en sus paths:
/// - RUNT: `{base}/runt/...`
/// - SIMIT: `{base}/simit/...`
///
/// Por lo tanto, todos los servicios comparten el mismo `baseUrl`.
///
/// ## Configuración por Ambiente
///
/// La URL base se configura mediante la variable de entorno `AVANZZA_API_URL`:
///
/// **Desarrollo local (emulador Android):**
/// ```bash
/// flutter run
/// # Usa el valor por defecto: http://10.0.2.2:3000
/// ```
///
/// **Desarrollo local (web/iOS):**
/// ```bash
/// flutter run --dart-define=AVANZZA_API_URL=http://localhost:3000
/// ```
///
/// **Staging:**
/// ```bash
/// flutter run --dart-define=AVANZZA_API_URL=https://api-staging.avanzza.com
/// ```
///
/// **Producción:**
/// ```bash
/// flutter build apk --dart-define=AVANZZA_API_URL=https://api.avanzza.com
/// ```
///
/// ## CI/CD
///
/// En pipelines de CI/CD, define la variable según el ambiente:
/// ```yaml
/// - flutter build apk --dart-define=AVANZZA_API_URL=$API_URL
/// ```
class ApiEndpoints {
  // ==================== CONFIGURACIÓN BASE ====================

  /// URL base de la API de Avanzza.
  ///
  /// Esta URL es compartida por todos los servicios (RUNT, SIMIT, GPS, etc.).
  /// Los servicios individuales agregan sus propios paths sobre esta base.
  ///
  /// **Valor por defecto (desarrollo):**
  /// - `http://10.0.2.2:3000` - Emulador Android apuntando a localhost:3000 del host
  ///
  /// **Para web o iOS en desarrollo:**
  /// - Usar `--dart-define=AVANZZA_API_URL=http://localhost:3000`
  ///
  /// **Para producción:**
  /// - Usar `--dart-define=AVANZZA_API_URL=https://api.tu-dominio.com`
  static String get _baseApiUrl {
    return const String.fromEnvironment(
      'AVANZZA_API_URL',
      // Por defecto apunta a localhost del host desde emulador Android
      // Para web/iOS, usar localhost:3000 con --dart-define
      defaultValue: "http://192.168.1.84:3000",
    );
  }

  // ==================== SERVICIOS ESPECÍFICOS ====================

  /// URL base para el servicio de RUNT (Registro Único Nacional de Tránsito).
  ///
  /// Proporciona acceso a información sobre:
  /// - Conductores y sus licencias
  /// - Vehículos y su historial (SOAT, RTM, etc.)
  ///
  /// **Endpoints típicos:**
  /// - `GET {runtBaseUrl}/runt/person/consult/:document/:typeDcm`
  /// - `GET {runtBaseUrl}/runt/vehicle/:type/:plaque/:license/:typeDcm`
  ///
  /// **Uso en binding:**
  /// ```dart
  /// RuntService(Get.find<Dio>(), baseUrl: ApiEndpoints.runtBaseUrl)
  /// ```
  static String get runtBaseUrl => _baseApiUrl;

  /// URL base para el servicio de SIMIT (Sistema Integrado de Multas de Tránsito).
  ///
  /// Proporciona acceso a información sobre:
  /// - Multas de tránsito
  /// - Comparendos
  /// - Acuerdos de pago
  /// - Historial de infracciones
  ///
  /// **Endpoints típicos:**
  /// - `GET {simitBaseUrl}/simit/multas/:license`
  ///
  /// **Uso en binding:**
  /// ```dart
  /// SimitService(Get.find<Dio>(), baseUrl: ApiEndpoints.simitBaseUrl)
  /// ```
  static String get simitBaseUrl => _baseApiUrl;

  // ==================== DESARROLLO LOCAL ====================

  /// **Nota para desarrollo local:**
  ///
  /// Si necesitas cambiar el host/puerto durante desarrollo sin recompilar:
  ///
  /// **Opción 1: Variable de entorno (recomendado)**
  /// ```bash
  /// flutter run --dart-define=AVANZZA_API_URL=http://localhost:3000
  /// ```
  ///
  /// **Opción 2: Modificar temporalmente el defaultValue**
  /// ```dart
  /// // En _baseApiUrl, cambiar temporalmente:
  /// defaultValue: 'http://localhost:3000',  // Web/iOS
  /// // o
  /// defaultValue: 'http://192.168.1.100:3000',  // IP local de tu máquina
  /// ```
  ///
  /// **URLs comunes de desarrollo:**
  /// - Emulador Android → `http://10.0.2.2:3000`
  /// - iOS Simulator → `http://localhost:3000`
  /// - Web → `http://localhost:3000`
  /// - Dispositivo físico → `http://192.168.x.x:3000` (IP de tu PC en la red local)

  // ==================== SERVICIOS FUTUROS ====================

  /// Conforme se integren más servicios, agregar getters aquí:
  ///
  /// ```dart
  /// /// URL base para el servicio de GPS y seguimiento de flotas.
  /// static String get gpsBaseUrl => _baseApiUrl;
  ///
  /// /// URL base para el servicio de pagos y transacciones.
  /// static String get paymentsBaseUrl => _baseApiUrl;
  ///
  /// /// URL base para el servicio de notificaciones push.
  /// static String get notificationsBaseUrl => _baseApiUrl;
  /// ```
  ///
  /// Todos comparten el mismo `_baseApiUrl`, solo varían los paths dentro
  /// de cada Service.
}
