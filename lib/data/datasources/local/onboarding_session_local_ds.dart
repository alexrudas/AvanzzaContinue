// ============================================================================
// lib/data/datasources/local/onboarding_session_local_ds.dart
// OnboardingSessionLocalDataSource — CRUD Isar para `OnboardingSessionModel`.
// ============================================================================
// QUÉ HACE:
//   - Encapsula `isar.onboardingSessionModels` y expone una API estrecha
//     pensada para `OnboardingSessionService`. Nadie más debe importar este
//     datasource: el service es el único cliente.
//   - Garantiza que toda escritura ocurra dentro de un `writeTxn` (regla
//     Isar) y que las lecturas usen el índice único `userId`.
//
// QUÉ NO HACE:
//   - NO valida TTL, ni decodifica el blob JSON, ni decide cuándo borrar
//     una sesión. Esa lógica vive en el service.
//   - NO expone el modelo Isar fuera del service. El service traduce
//     `OnboardingSessionModel` a primitivos.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../models/auth/onboarding_session_model.dart';

class OnboardingSessionLocalDataSource {
  final Isar _isar;

  OnboardingSessionLocalDataSource(this._isar);

  /// Lee la sesión asociada a [userId]. Retorna null si no existe.
  Future<OnboardingSessionModel?> getByUserId(String userId) {
    return _isar.onboardingSessionModels
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
  }

  /// Inserta o reemplaza la sesión del usuario. El índice único en `userId`
  /// (replace: true) garantiza que solo exista una fila por uid.
  Future<void> upsert(OnboardingSessionModel session) async {
    await _isar.writeTxn(() async {
      await _isar.onboardingSessionModels.put(session);
    });
  }

  /// Elimina la sesión asociada a [userId]. No-op si no existe.
  Future<void> deleteByUserId(String userId) async {
    await _isar.writeTxn(() async {
      await _isar.onboardingSessionModels
          .filter()
          .userIdEqualTo(userId)
          .deleteFirst();
    });
  }

  /// Elimina TODAS las sesiones. Usado solo como herramienta de saneamiento
  /// (ej. corrupción global del schema). El flujo normal usa `deleteByUserId`.
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.onboardingSessionModels.clear();
    });
  }
}
