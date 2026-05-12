// ============================================================================
// lib/presentation/view_models/network/v2/mi_red_labels.dart
// MI RED LABELS — Copy congelado para Mi Red V1
// ============================================================================
// QUÉ HACE:
//   - Centraliza los labels humanos visibles para los buckets V1.
//   - Separa "label de header de sección" (forma larga, explícita) de
//     "label de badge secundario" (forma corta, usada cuando un actor
//     pertenece a múltiples buckets y se muestra como subtitle del tile).
//   - Centraliza también los textos de count ("8 contactos · 2 aliados",
//     "5 miembros") y los labels Contacto/Aliado.
//
// QUÉ NO HACE:
//   - No infiere copy ni hace traducciones: las strings son las aprobadas
//     en blueprint final. Cambiarlas exige reapertura UX.
//   - No mapea wire keys del backend (`parts_and_supplies`, etc.). Ese
//     mapeo vive en mi_red_buckets.dart porque allí está la lógica de
//     asignación; aquí solo presentamos.
//
// LABELS CONGELADOS (V1):
//   Headers: Equipo, Proveedores de productos, Proveedores de servicios
//   Badges:  Productos, Servicios
//   Estado:  Contacto, Aliado
// ============================================================================

import 'mi_red_buckets.dart';

/// Copy V1 de Mi Red. Todos los strings están congelados y deben coincidir
/// con el blueprint aprobado.
class MiRedLabels {
  MiRedLabels._();

  // ── Headers de sección (forma larga) ──────────────────────────────────

  static String sectionHeader(MiRedBucket bucket) => switch (bucket) {
        MiRedBucket.equipo => 'Equipo',
        MiRedBucket.productos => 'Proveedores de productos',
        MiRedBucket.servicios => 'Proveedores de servicios',
      };

  // ── Badges secundarios del tile (forma corta) ─────────────────────────
  //
  // Se renderizan en formato "Productos · Servicios" cuando un actor
  // pertenece a más de un bucket V1. Para bucket único el subtitle del
  // tile queda vacío (no se imprime un solo badge — sería ruido visual).

  static String sectionBadge(MiRedBucket bucket) => switch (bucket) {
        MiRedBucket.equipo => 'Equipo',
        MiRedBucket.productos => 'Productos',
        MiRedBucket.servicios => 'Servicios',
      };

  /// Une los badges con separador " · ". Lista ordenada por enum.
  /// Devuelve string vacío si hay 0 o 1 buckets (un solo badge no aporta).
  static String secondaryBadgeLine(List<MiRedBucket> buckets) {
    if (buckets.length < 2) return '';
    return buckets.map(sectionBadge).join(' · ');
  }

  // ── Counts del header de sección ──────────────────────────────────────

  /// Para buckets de network: "8 contactos · 2 aliados" / "8 contactos" /
  /// "2 aliados". Si total=0 devuelve string vacío (el bucket no debería
  /// renderizarse en ese caso).
  static String networkCount({required int contactos, required int aliados}) {
    if (contactos == 0 && aliados == 0) return '';
    if (contactos > 0 && aliados > 0) {
      return '${_plural(contactos, 'contacto', 'contactos')} · '
          '${_plural(aliados, 'aliado', 'aliados')}';
    }
    if (contactos > 0) return _plural(contactos, 'contacto', 'contactos');
    return _plural(aliados, 'aliado', 'aliados');
  }

  /// Para bucket Equipo: "5 miembros" / "1 miembro".
  static String teamCount(int members) =>
      _plural(members, 'miembro', 'miembros');

  // ── Estado del actor (badge en trailing del tile) ─────────────────────

  static const String contactoLabel = 'Contacto';
  static const String aliadoLabel = 'Aliado';

  // ── Empty state global ────────────────────────────────────────────────

  static const String emptyTitle =
      'Aún no tienes registros en tu red operativa';
  static const String emptyDescription =
      'Registra miembros de tu equipo o proveedores para coordinar la '
      'operación de tus activos.';
  static const String emptyCta = 'Registrar';

  // ── Register actor sheet ──────────────────────────────────────────────

  static const String registerSheetTitle = '¿A quién quieres registrar?';
  static const String registerSheetSubtitle = 'Selecciona una opción';

  static const String registerOptionTeam = 'Mi equipo';
  static const String registerOptionTeamSubtitle =
      'Personas que trabajan contigo en este workspace.';

  static const String registerOptionProductos = 'Proveedores de productos';
  static const String registerOptionProductosSubtitle =
      'Repuestos, insumos, llantas, baterías y otros productos.';

  static const String registerOptionServicios = 'Proveedores de servicios';
  static const String registerOptionServiciosSubtitle =
      'Talleres, técnicos, mantenimiento y servicios especializados.';

  /// Copy mostrado cuando una opción aún no tiene flujo Flutter implementado
  /// (caso V1: "Mi equipo"). El BottomSheet renderiza la opción pero
  /// muestra este snackbar al tocar, en vez de navegar a un stub roto.
  static const String registerOptionComingSoon =
      'Esta opción estará disponible próximamente.';

  // ── Form titles (provider_form_page contextual) ───────────────────────

  static const String formTitleProductos = 'Registrar proveedor de productos';
  static const String formTitleServicios = 'Registrar proveedor de servicios';

  // ── Team member tile (humanización de roles bootstrap) ────────────────

  /// Mapeo wire→humano de roles del workspace. Catálogo cerrado por ahora;
  /// cuando el backend exponga un catálogo dinámico de roles humanos, esto
  /// se sustituye por la fuente real (no se inventan claves nuevas).
  ///
  /// TODO(backend): wirear un endpoint /v1/team/role-labels o exponer
  /// `humanLabel` dentro de teamRoleKeys para evitar hardcode aquí.
  static const Map<String, String> _teamRoleHumanLabels = {
    'bootstrap_default_role': 'Administrador',
  };

  /// Devuelve la etiqueta humana del rol si está en el catálogo, o `null`
  /// si la clave es desconocida (forward-compat: no se inventa label).
  static String? humanTeamRoleLabel(String roleKey) =>
      _teamRoleHumanLabels[roleKey];

  /// Título visible para el current user en la sección Equipo.
  static const String teamTitleCurrentUser = 'Administrador (Tú)';

  /// Subtítulo del current user.
  static const String teamSubtitleCurrentUser = 'Administrador de cuenta';

  /// Título fallback cuando un member NO es el current user pero su
  /// displayName está vacío/null.
  static const String teamTitleAnonymousFallback = 'Administrador';

  /// Subtítulo fallback cuando un member NO es current user, sin displayName.
  static const String teamSubtitleAnonymousFallback = 'Cuenta Avanzza';

  // ── Internals ─────────────────────────────────────────────────────────

  static String _plural(int n, String one, String many) =>
      '$n ${n == 1 ? one : many}';
}
