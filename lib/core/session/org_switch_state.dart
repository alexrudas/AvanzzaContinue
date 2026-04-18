// ============================================================================
// lib/core/session/org_switch_state.dart
// ORG SWITCH STATE — Estado global del cambio de organización activa.
//
// QUÉ HACE:
// - Define OrgSwitchState como enum canónico de los estados de tenancy switch.
// - OrgSwitchStateHolder: singleton reactivo compartido por CoreApiClient
//   (interceptor de bloqueo), SwitchActiveOrganizationUC (orquestador) y
//   SessionContextController (exposición a UI).
// - Mantiene el CancelToken compartido para cancelar requests org-scoped
//   en vuelo al inicio de cada switch.
//
// QUÉ NO HACE:
// - No ejecuta la lógica del switch (responsabilidad del use case).
// - No navega ni decide routing.
// - No persiste estado entre reinicios de app (siempre arranca en idle).
//
// PRINCIPIOS:
// - Singleton: único estado global para toda la app, sin duplicados.
// - CancelToken se rota en cada switch: cancela in-flight, nuevo token para futuros.
// - Rx<OrgSwitchState> habilita reactividad en UI via GetX sin acoplamiento directo.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Estados posibles del cambio de organización activa.
///
/// - [idle]: Sin operación en curso. Requests normales permitidos.
/// - [validating]: Startup — contexto Isar cargado pero no validado contra JWT claims.
///   Solo lectura permitida; escrituras org-scoped bloqueadas por CoreApiClient.
/// - [switching]: Cambio de org en progreso. Todos los requests bloqueados por interceptor.
/// - [failed]: El último switch falló. Contexto previo preservado. Requests normales.
enum OrgSwitchState { idle, validating, switching, failed }

/// Singleton observable que porta el estado de tenancy switch.
///
/// Accesible desde cualquier capa sin acoplamiento a GetX controllers ni al
/// árbol de widgets. Usado por [OrgSwitchInterceptor] (en CoreApiClient) y
/// por [SwitchActiveOrganizationUC].
class OrgSwitchStateHolder {
  static final OrgSwitchStateHolder _instance = OrgSwitchStateHolder._();

  factory OrgSwitchStateHolder() => _instance;

  OrgSwitchStateHolder._();

  /// Estado reactivo observable del switch de organización.
  ///
  /// Observar con Obx() en UI o con .ever() en controllers para reaccionar
  /// a cambios de estado sin polling.
  final Rx<OrgSwitchState> state = Rx<OrgSwitchState>(OrgSwitchState.idle);

  /// Token de cancelación compartido para requests org-scoped activos.
  ///
  /// El [OrgSwitchInterceptor] adjunta este token a cada request org-scoped
  /// cuando el estado es [OrgSwitchState.idle]. Al rotar el token, todos los
  /// requests in-flight que lo tenían adjunto reciben una cancelación.
  CancelToken _cancelToken = CancelToken();

  /// Token activo. El interceptor lo lee para adjuntarlo a nuevas requests.
  CancelToken get currentCancelToken => _cancelToken;

  /// Cancela todas las requests org-scoped in-flight y rota el token.
  ///
  /// Llamado por el use case al inicio del switch, ANTES de la HTTP call al
  /// backend, para garantizar que no queden requests en vuelo con contexto viejo.
  void cancelAndRotateToken() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('Org switch started — context changing');
    }
    _cancelToken = CancelToken();
  }
}
