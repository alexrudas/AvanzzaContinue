// ============================================================================
// lib/data/models/bootstrap/bootstrap_sync_state_model.dart
// BootstrapSyncStateModel — estado persistente del sync de fondo
// `POST /v1/bootstrap`. Sobrevive a kills, hot restarts y app resumes.
// ============================================================================
// QUÉ HACE:
//   - Persiste UNA fila por usuario (clave única `userId`) con el estado del
//     state machine: pending | syncing | synced | failed.
//   - Cuenta intentos (`attempts`) para implementar retry exponencial
//     acotado [0s, 2s, 10s, 30s, 120s] sin loops infinitos.
//   - Captura `lastError` como string humano para banner UX.
//   - Marca `requiresTokenRefresh` cuando el backend lo solicita; el caller
//     debe refrescar el ID token antes del siguiente intento.
//
// QUÉ NO HACE:
//   - NO almacena el payload del request — el caller (FusionadoFlow) lo
//     reconstruye desde `DemoRegistrationState` cada vez. Si el payload no
//     puede reconstruirse (estado borrado), la fila queda inerte hasta el
//     próximo `start()` con payload nuevo.
//   - NO se sincroniza a Firestore. Es estado puramente local: la fuente
//     de verdad del status remoto es el backend.
//
// REGLAS:
//   - UN registro por `userId` (`@Index(unique: true, replace: true)`).
//   - Persistir en CADA transición del state machine (idle→pending,
//     pending→syncing, syncing→synced|failed). No batching.
//   - Resiliente a schema drift: si el enum gana valores nuevos, el lector
//     trata desconocidos como `failed` (degradación segura).
// ============================================================================

import 'package:isar_community/isar.dart';

part 'bootstrap_sync_state_model.g.dart';

/// Espejo persistente de `BootstrapSyncStatus` (presentation). Wire-stable
/// porque se serializa en Isar; agregar valores SOLO al final.
enum BootstrapSyncStatusModel {
  idle,
  pendingSync,
  syncing,
  synced,
  failed,
}

@Collection(inheritance: false)
class BootstrapSyncStateModel {
  Id? isarId;

  /// `FirebaseAuth.currentUser.uid` del usuario al que pertenece este
  /// estado. Único por colección — un cambio de cuenta crea su propia fila.
  @Index(unique: true, replace: true)
  late String userId;

  /// Estado canónico. Se actualiza en CADA transición del state machine.
  @Enumerated(EnumType.name)
  late BootstrapSyncStatusModel status;

  /// Conteo de intentos consumidos. 0 cuando aún no se ha intentado nada;
  /// se incrementa antes de cada llamada HTTP (no después). El máximo
  /// permitido (5) lo aplica el controller; este campo solo lo persiste.
  late int attempts;

  /// UTC del último intento (independiente del resultado). Null antes de
  /// la primera llamada.
  DateTime? lastAttemptAt;

  /// Mensaje humano del último error, surface al banner. Null cuando
  /// `status == synced` o el sync nunca se invocó.
  String? lastError;

  /// True cuando la última respuesta del backend pidió token refresh
  /// (`requiresTokenRefresh: true`). El controller refresca antes del
  /// siguiente intento y limpia el flag al retomar.
  late bool requiresTokenRefresh;

  /// Payload del último `start()` serializado como JSON
  /// (`UnifiedBootstrapRequestDto`). Persistido para que el retry pueda
  /// continuar tras un kill del proceso sin requerir que el caller
  /// (FusionadoFlow) esté vivo. Null hasta el primer `start()` exitoso.
  ///
  /// Lo deserializa el controller en `_hydrateFromIsar`. Un payload
  /// corrupto se trata como ausente (degradación segura → retry manual).
  String? payloadJson;

  /// UTC de creación de la fila (primer `start()` para este userId). Útil
  /// para telemetría y debug ("cuánto lleva en pending?").
  late DateTime createdAt;

  /// UTC de la última escritura (cualquier transición). Sirve a tests y
  /// a operadores para detectar filas atascadas.
  late DateTime updatedAt;

  BootstrapSyncStateModel();
}
