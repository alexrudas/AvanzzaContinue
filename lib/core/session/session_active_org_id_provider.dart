// ============================================================================
// lib/core/session/session_active_org_id_provider.dart
// SESSION ACTIVE ORG ID PROVIDER — adapter que envuelve SessionContextController
// y satisface `ActiveOrgIdProvider` (domain) sin introducir estado duplicado.
// ============================================================================
// QUÉ HACE:
// - Implementa `ActiveOrgIdProvider` leyendo de `SessionContextController`.
// - Aplica la regla canónica: preferir `user.activeContext.orgId`; si viene
//   vacío, caer a la primera membership activa (repair del race documentado
//   en `feedback_orgid_race`).
//
// QUÉ NO HACE:
// - NO cachea el orgId. Siempre lee el SSOT del controller.
// - NO expone observables. Consumers que necesiten reactividad usan las
//   Rx ya publicadas por `SessionContextController`.
// - NO escribe. Este adapter es estrictamente de sólo lectura.
//
// PRINCIPIOS:
// - Un único SSOT del orgId (el controller). Este adapter es un lente.
// - Síncrono puro. Sin I/O. Sin `Future`.
// - Adapter ubicado en `core/session/` siguiendo el precedente de
//   `core/auth/auth_state_observer.dart` (core ya tolera importar
//   presentation en adapters específicos por pragmatismo GetX + observers).
//
// ENTERPRISE NOTES:
// - Registro: `SplashBinding` + `HomeBinding` lo ponen en GetX como
//   singleton permanente justo después de `SessionContextController`.
// - Consumer del container: `container.dart` NO importa esta clase. Lee
//   únicamente la interface `ActiveOrgIdProvider` vía `Get.find` dinámico.
//   Eso preserva "core-di NO importa presentation" — el único ingreso a
//   la interface es por DI.
// ============================================================================

import '../../domain/services/session/active_org_id_provider.dart';
import '../../presentation/controllers/session_context_controller.dart';

class SessionActiveOrgIdProvider implements ActiveOrgIdProvider {
  final SessionContextController _session;

  SessionActiveOrgIdProvider(this._session);

  @override
  String? get activeOrgId {
    // 1) Preferir el orgId del activeContext — SSOT del rol activo.
    final primary = _session.user?.activeContext?.orgId;
    if (primary != null && primary.isNotEmpty) return primary;

    // 2) Fallback: primera membership activa.
    //    Cubre el race documentado en `feedback_orgid_race`: portfolios
    //    creados antes de que el controller cargara el activeContext
    //    pueden quedar con `orgId == ''`. El repair natural es leer la
    //    membership como fuente alternativa hasta que el stream hidrate.
    for (final m in _session.memberships) {
      if (m.orgId.isNotEmpty &&
          m.estatus.trim().toLowerCase() == 'activo') {
        return m.orgId;
      }
    }

    // 3) Sin fuente fiable → null. El caller (gateway/interceptor) decide:
    //    proactivo → `SELECT_WORKSPACE`; reactivo → bootstrap sin orgId
    //    (el backend intenta el claim o responde 400 ACTIVE_ORG_ID_MISSING).
    return null;
  }
}
