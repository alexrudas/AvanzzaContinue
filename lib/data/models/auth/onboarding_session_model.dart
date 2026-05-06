// ============================================================================
// lib/data/models/auth/onboarding_session_model.dart
// OnboardingSessionModel — colección Isar de la sesión activa del onboarding
// canónico (FusionadoFlow). Sustituye al uso legacy de RegistrationProgress
// como mecanismo de reanudación.
// ============================================================================
// QUÉ HACE:
//   - Persiste el estado del FusionadoFlow para que un usuario que cierra la
//     app a mitad de onboarding pueda reanudarlo en el mismo paso.
//   - Aislamiento por usuario: clave única `userId`. Un cambio de cuenta en
//     el mismo dispositivo NO hereda el estado del usuario anterior.
//   - Resiliente a schema drift: el estado completo viaja como un blob JSON
//     (`stateJson`). Si el JSON está corrupto o falta un campo, el service
//     borra la sesión y reinicia el onboarding en lugar de crashear.
//
// QUÉ NO HACE:
//   - NO mapea cada campo de DemoRegistrationState a una columna Isar. Eso
//     genera fragilidad ante cambios del flow. El blob es opaco al storage.
//   - NO persiste pasos pre-auth (Q1: phone + terms). Antes de que Firebase
//     emita un uid, no hay sujeto al cual aislar el estado.
// ============================================================================

import 'package:isar_community/isar.dart';

part 'onboarding_session_model.g.dart';

@Collection(inheritance: false)
class OnboardingSessionModel {
  Id? isarId;

  /// Identificador único persistente. Equivale al `uid` de Firebase: garantiza
  /// que un cambio de cuenta en el dispositivo no hereda estado.
  @Index(unique: true, replace: true)
  late String userId;

  /// Paso actual del wizard fusionado (0..4). Se replica fuera del blob
  /// para inspección/telemetría sin deserializar el JSON.
  late int currentStep;

  /// Snapshot completo del `DemoRegistrationState` serializado como JSON.
  /// Lo decodifica el service al rehidratar; cualquier fallo de parse se
  /// trata como corrupción → sesión borrada → onboarding reinicia en Q1.
  late String stateJson;

  /// Última actualización en UTC. La política de expiración (7 días) se
  /// evalúa contra este campo en el service.
  late DateTime updatedAt;

  /// True una vez que `CompleteOnboardingUC.execute()` finaliza con éxito.
  /// El service borra la sesión completed inmediatamente; el flag existe
  /// como guardrail por si la limpieza queda diferida.
  late bool isCompleted;

  OnboardingSessionModel();
}
