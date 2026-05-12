// ============================================================================
// lib/presentation/pages/network/v2/mi_red_page.dart
// MI RED PAGE — V1 final: 3 buckets, FAB condicional, empty state humano
// ============================================================================
// QUÉ HACE:
//   - Lee `MiRedController.bucketsRx` (pre-computado por el controller,
//     nunca en build) y renderiza en orden fijo los 3 buckets V1:
//       1. Equipo
//       2. Proveedores de productos
//       3. Proveedores de servicios
//     Los buckets vacíos se omiten — emergen automáticamente cuando
//     llega data.
//   - FAB persistente sólo cuando hay al menos 1 actor renderizado.
//     En empty state global, el FAB se oculta y se muestra una CTA
//     central. Esta es decisión congelada del blueprint V1.
//   - Pull-to-refresh dispara `loadInitial()` (guard `_reloadInFlight`
//     dedupea cualquier carrera).
//   - En debug, una tira amber muestra cuántos actores están ocultos
//     por deuda de data (sectionKeys=[] / no-mapeados / multi-mapeados).
//
// QUÉ NO HACE:
//   - No invoca bucketize en build. Solo lee el cache reactivo del
//     controller.
//   - No paginación visible ("Ver todos" fuera de scope V1).
//   - No tabs, no wizard, no filtros, no búsqueda.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/platform/platform_capabilities.dart';
import '../../../../domain/entities/catalog/specialty_entity.dart'
    show SpecialtyKind;
import '../../../controllers/network/v2/mi_red_controller.dart';
import '../../../controllers/session_context_controller.dart';
import '../../../view_models/network/v2/mi_red_buckets.dart';
import '../../../view_models/network/v2/network_actor_summary_vm.dart';
import '../../../view_models/network/v2/team_member_summary_vm.dart';
import '../../../widgets/network/v2/actions_bottom_sheet.dart';
import '../../../widgets/network/v2/mi_red_bucket_section.dart';
import '../../../widgets/network/v2/mi_red_empty_state.dart';
import '../../../widgets/network/v2/register_actor_sheet.dart';

class MiRedPage extends StatefulWidget {
  const MiRedPage({super.key});

  @override
  State<MiRedPage> createState() => _MiRedPageState();
}

class _MiRedPageState extends State<MiRedPage> {
  late final MiRedController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MiRedController>();
    // Disparo inicial fuera del frame para evitar setState durante build.
    // El guard _reloadInFlight previene duplicación si esto se cruza con
    // un loadInitial pendiente desde otra ruta.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    // currentUserId se resuelve una vez por build. La sección Equipo no
    // depende de cambios reactivos del usuario actual — si el user cambia
    // de cuenta, el shell entero se re-construye.
    final currentUserId = Get.isRegistered<SessionContextController>()
        ? Get.find<SessionContextController>().user?.uid
        : null;

    // NO AppBar aquí: el WorkspaceShell (admin) ya provee uno con el
    // título del tab activo ('Mi red operativa' por workspace_config).
    // Tener un AppBar propio aquí duplicaría el header. Si esta page se
    // entra vía ruta directa (`Routes.miRed` fuera del shell) y se requiere
    // un AppBar, envolver entonces el flujo en una page wrapper que lo
    // provea — no agregar uno aquí.
    return Scaffold(
      body: Obx(() {
        // P1 — gating de Loading inicial estable. Antes de que el primer
        // loadInitial termine, NO renderizamos empty state (eso causaba
        // el flicker empty → vista real). Mientras tanto: spinner central.
        if (!_controller.initialLoadCompletedRx.value) {
          return const _InitialLoadingView();
        }

        final buckets = _controller.bucketsRx.value;
        if (buckets.isEmpty) {
          // Empty state global: ListView para habilitar pull-to-refresh.
          return RefreshIndicator(
            onRefresh: _controller.loadInitial,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (kDebugMode && buckets.hiddenActorCount > 0)
                  _DataDebtBanner(count: buckets.hiddenActorCount),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: MiRedEmptyState(
                    onTapRegistrar: _openRegisterSheet,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _controller.loadInitial,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (kDebugMode && buckets.hiddenActorCount > 0)
                _DataDebtBanner(count: buckets.hiddenActorCount),
              for (final bucket in MiRedBuckets.renderOrder)
                ..._maybeSectionFor(bucket, buckets, currentUserId),
            ],
          ),
        );
      }),
      // FAB condicional: solo cuando ya cargó Y hay data. Durante loading
      // inicial y en empty state global se oculta para no competir con la
      // CTA central / spinner.
      floatingActionButton: Obx(() {
        if (!_controller.initialLoadCompletedRx.value) {
          return const SizedBox.shrink();
        }
        if (_controller.bucketsRx.value.isEmpty) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          // heroTag único para evitar colisión con otros FABs del admin
          // shell (orders/quotes) que conviven en el LazyIndexedStack.
          // Sin esto, Flutter lanza:
          //   "multiple heroes that share the same tag within a subtree".
          heroTag: 'mi_red_register_actor_fab',
          onPressed: _openRegisterSheet,
          tooltip: 'Registrar',
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  /// Devuelve la lista de widgets para el bucket dado, o lista vacía si
  /// el bucket no debe renderizarse (count == 0).
  ///
  /// `currentUserId` se propaga a TeamMemberTile (vía MiRedBucketSection)
  /// para renderizar la variante "(Tú)" del current user.
  List<Widget> _maybeSectionFor(
    MiRedBucket bucket,
    MiRedBuckets buckets,
    String? currentUserId,
  ) {
    final counts = buckets.counts[bucket] ?? BucketCounts.empty;
    if (counts.total == 0) return const [];

    switch (bucket) {
      case MiRedBucket.equipo:
        return [
          MiRedBucketSection(
            bucket: bucket,
            counts: counts,
            teamItems: buckets.equipo,
            currentUserId: currentUserId,
            onTapTeamMember: _openTeamActions,
            // Equipo NO es creable en V1 (sin endpoint Core API).
            // No se renderiza CTA "+ Agregar" aquí. Cuando exista
            // endpoint, basta con pasar el callback.
          ),
        ];
      case MiRedBucket.productos:
      case MiRedBucket.servicios:
        // El "+ Agregar" por sección NO debe abrir el sheet de opciones:
        // el tipo ya está determinado por el bucket. Navegamos directo al
        // provider_form con `initialKind` precargado (el binding lo bloquea
        // vía `isOfferKindLocked`). El FAB global sigue abriendo el sheet
        // porque ahí sí falta contexto.
        final kind = bucket == MiRedBucket.productos
            ? SpecialtyKind.product
            : SpecialtyKind.service;
        return [
          MiRedBucketSection(
            bucket: bucket,
            counts: counts,
            networkItems: buckets.network[bucket] ?? const [],
            onTapNetworkActor: _openNetworkActions,
            onTapAgregar: () => openProviderFormForKind(kind),
          ),
        ];
    }
  }

  // ── Acciones (BottomSheet de contacto del actor) ───────────────────────

  void _openNetworkActions(NetworkActorSummaryVM actor) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      // isScrollControlled permite que el sheet exceda el ~50% del viewport
      // que es default. Sin esto, el contenido del sheet (hasta 6 acciones)
      // se desborda con "Bottom Overflowed by N pixels". El SingleChildScrollView
      // interno del sheet es la red de seguridad si igual no cabe en pantalla.
      isScrollControlled: true,
      builder: (_) => ActionsBottomSheet(
        title: actor.displayName ?? 'Sin nombre',
        actions: actor.actions,
        phoneE164: actor.primaryPhoneE164,
        email: actor.primaryEmail,
        providerProfileId: actor.providerProfileId,
      ),
    );
  }

  void _openTeamActions(TeamMemberSummaryVM member) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => ActionsBottomSheet(
        title: member.displayName ?? 'Sin nombre',
        actions: member.actions,
        phoneE164: member.primaryPhoneE164,
        email: member.primaryEmail,
      ),
    );
  }

  // ── Register sheet (FAB + CTAs internas) ───────────────────────────────

  void _openRegisterSheet() {
    // En desktop companion la creación de actores queda deshabilitada
    // temporalmente: `firebase_auth ^5.7.0` para Windows tiene un bug de
    // threading en el canal `id-token` que, combinado con el fan-out de
    // requests del provider_form, dispara un abort() en el SDK C++ de
    // Firestore (instancia ya iniciada → settings inmutables). El listado
    // (lectura) sigue funcionando — solo se gatea la escritura. El fix
    // real requiere upgrade major de firebase_auth (tracked aparte).
    if (PlatformCapabilities.isDesktopCompanion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La creación de miembros desde escritorio estará disponible '
            'próximamente. Puedes crear miembros desde la app móvil.',
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }
    showRegisterActorSheet(context);
  }
}

/// Loading inicial estable. Se muestra ANTES de que el primer
/// `loadInitial()` termine — evita el flicker
/// (`MiRedBuckets.empty()` → empty state → data real) que aparecía
/// cuando la UI consumía directamente `bucketsRx` sin gate.
class _InitialLoadingView extends StatelessWidget {
  const _InitialLoadingView();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

/// Tira amber dev-only que muestra cuántos actores están ocultos por
/// deuda de data (sectionKeys=[] o ambiguous). No se compila en release
/// builds gracias al guard `kDebugMode`.
class _DataDebtBanner extends StatelessWidget {
  final int count;
  const _DataDebtBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        '🔍 $count actor${count == 1 ? '' : 'es'} oculto'
        '${count == 1 ? '' : 's'} (data debt). Revisa logs '
        '[MiRed] BUCKETIZE_DATA_DEBT.',
        style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
      ),
    );
  }
}
